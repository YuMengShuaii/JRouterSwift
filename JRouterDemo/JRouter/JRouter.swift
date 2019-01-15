//
//  JRouter.swift
//  JRouterDemo
//
//  Created by LDD on 2018/12/20.
//  Copyright © 2018 Parrot. All rights reserved.
//

import UIKit

/// 路由日志代理
var ROUTER_LOGGER = JRouterLoggerManager()

/// 路由核心类
fileprivate class JRouterCore : PagerNotFoundHandle {
    
    ///单例
    fileprivate static let shared = JRouterCore()
    
    /// 路径DIC
    private lazy var pathDic : RouterPagerDictionaryOutput = RouterPagerDictionary(notFoundHandle: self)
    
    /// 构建拦截器
    var interceipt : RouterInterceptor? = nil
    
    /// 构建路径处理
    var pathHandle : RouterPathHandle? = nil
    
    /// 构建路径注入
    var injecter : RouterPathInjecter? = nil
    
    /// 缓存开关
    fileprivate var cacheEnable :Bool = false
    
    /// 自动注入初始化
    init() {
        /// 自动注入处理器
        interceipt = getProcessor()
        pathHandle = getProcessor()
        injecter = getProcessor()
        //路径注入
        inject()
    }
    
    private func inject(){
        if injecter == nil {
            ROUTER_LOGGER.error("【路径注入失败】 =>>> 没有注入RouterPathInjecter实现类,路径注入失败!")
            return
        }
        
        if cacheEnable{
            pathDic.formCache()
        }
        
        if pathDic.pageCount == 0{
            reInject()
        }else{
            ROUTER_LOGGER.debug("从缓存拉取页面信息")
        }
    
    }
    
    /// 重新拉取页面信息
    private func reInject(){
        ROUTER_LOGGER.debug("重新拉取页面信息")
        self.injecter?.inject(pagerDic: pathDic as! RouterPagerDictionaryInput)
        pathDic.cacheDisk()
    }
    
    /// 查找页面失败处理
    func notFoundHandle() {
        pathDic.clear()
        reInject()
    }
    
    /// 获取路径处理器
    private func getProcessor<T : NSObject >() -> T?{
        var processors : [JRouterProcessorControl] = []
        Utils.subclasses(T.self).forEach { item in
            let type = (item as! T.Type)
            let processor = type.init()
            ROUTER_LOGGER.debug("【处理器初始化,找到\(T.routerClassName)的实现子类】=>>> \(type.routerClassName)")
            processors.append(processor as! JRouterProcessorControl)
        }
        processors.sort { x , y  -> Bool in
            return x.getProcessorLevel() < y.getProcessorLevel()
        }
        if processors.count > 0{
            ROUTER_LOGGER.debug("【最终采用\(T.routerClassName)优先级最高的实现类】=>>> \((processors[0] as! NSObject).routerClassName)")
            return processors[0] as? T
        }else{
            return nil
        }
    }
    
    /// 获取实例
    ///
    /// - Parameter data: 索引
    /// - Returns: 实例
    fileprivate func getInstance(data : String) ->UIViewController? {
        let key = pathHandle == nil ? data : (pathHandle?.realHandle(path: data))!
        let className = pathDic.getPagerName(key: key)
        if className == nil {
            ROUTER_LOGGER.error("【无法找到该页面！】=>>> Path = \(data)")
            return nil
        }
        let vc =  (NSClassFromString(className! as String) as! UIViewController.Type).init()
        ROUTER_LOGGER.debug("【获取到\(data)路径所指向实例】->>> \(className!)")
        return vc
    }
    
    /// pop到根页面
    ///
    /// - Parameter anim: 是否需要动画
    fileprivate func popToRoot(anim :Bool = true){
        let window = UIApplication.shared.delegate?.window
        if window != nil && window!!.rootViewController is UINavigationController {
            (window!!.rootViewController as! UINavigationController).popToRootViewController(animated: anim)
            ROUTER_LOGGER.debug("【已退出至根页面】")
        }else{
            if window == nil{
                ROUTER_LOGGER.error("【退出至根页面失败，获取window失败】")
            }else if !(window!!.rootViewController is UINavigationController){
                ROUTER_LOGGER.error("【退出至根页面失败，rootViewController需继承UINavigationController或者其子类】")
            }
        }
    }
    
    /// 退出到指定已存在Controller
    ///
    /// - Parameters:
    ///   - data: 路径
    ///   - anim: 动画
    fileprivate func popToPageInStack(data:String ,anim :Bool){
        let key = pathHandle == nil ? data : (pathHandle?.realHandle(path: data))!
        let className = pathDic.getPagerName(key: key)
        if (className == nil){
            ROUTER_LOGGER.error("退出页面失败,页面注册列表中，不包含该页面 path ->>> \(data)")
            return
        }
        let window = UIApplication.shared.delegate?.window
        if window != nil && window!!.rootViewController is UINavigationController {
            (window!!.rootViewController as! UINavigationController).viewControllers.forEach { item in
                if  item.routerClassName.contains(className!) {
                    (window!!.rootViewController as! UINavigationController).popToViewController(item, animated: anim)
                }
            }
            ROUTER_LOGGER.debug("【退出页面成功，成功退至\(className!)页面】")
        }else{
            if window == nil{
                ROUTER_LOGGER.error("【退出页面失败，获取window失败】")
            }else if !(window!!.rootViewController is UINavigationController){
                ROUTER_LOGGER.error("【退出页面失败，rootViewController需继承UINavigationController或者其子类】")
            }
        }
    }
    
    
    /// 获取当前显示视图
    ///
    /// - Returns: 当前显示视图
    fileprivate func getCurrentPage() ->UIViewController?{
        let window = UIApplication.shared.delegate?.window
        if window != nil && window!!.rootViewController is UINavigationController {
            return  (window!!.rootViewController as! UINavigationController).topViewController?.done({ _ in
                ROUTER_LOGGER.debug("【获取当前顶部视图成功】")
            })
        }else{
            if window == nil{
                ROUTER_LOGGER.error("【获取顶部视图失败，获取window失败】")
            }else if !(window!!.rootViewController is UINavigationController){
                ROUTER_LOGGER.error("【获取顶部视图失败，rootViewController需继承UINavigationController或者其子类】")
            }
            return nil
        }
    }
    
    
    /// 当前ViewController是否包含该页面
    ///
    /// - Parameter name: 页面路径
    /// - Returns: 是否包含
    fileprivate func hasPager(name :String) -> Bool{
        var has = false
        let key = pathHandle == nil ? name : (pathHandle?.realHandle(path: name))!
        let className = pathDic.getPagerName(key: key)
        if (className == nil){
            ROUTER_LOGGER.error("页面注册列表中，不包含该页面 path ->>> \(name)")
            return false
        }
        let window = UIApplication.shared.delegate?.window
        if window != nil && window!!.rootViewController is UINavigationController {
            (window!!.rootViewController as! UINavigationController).viewControllers.easyFor { (index, item) in
                if  item.routerClassName.contains(className!) {
                    has = true
                    return
                }
            }
        }else{
            if window == nil{
                ROUTER_LOGGER.error("【判断栈内页面失败，获取window失败】")
            }else if !(window!!.rootViewController is UINavigationController){
                ROUTER_LOGGER.error("【判断站内页面失败，rootViewController需继承UINavigationController或者其子类】")
            }
        }
        return has
    }
    
    /// 从UINavigationController移除某个页面
    ///
    /// - Parameter data: 页面索引
    fileprivate func removePageInStack(data :String){
        let key = pathHandle == nil ? data : (pathHandle?.realHandle(path: data))!
        let className = pathDic.getPagerName(key: key)
        if (className == nil){
            ROUTER_LOGGER.error("移除页面失败，页面注册列表中，不包含该页面 path ->>> \(data)")
            return
        }
        let window = UIApplication.shared.delegate?.window
        if window != nil && window!!.rootViewController is UINavigationController {
            (window!!.rootViewController as! UINavigationController).viewControllers.easyFor { (index, item) in
                if  item.routerClassName.contains(className!) {
                    (window!!.rootViewController as! UINavigationController).viewControllers.remove(at: index)
                    ROUTER_LOGGER.debug("【移除栈内\(className!)页面成功】")
                    return
                }
            }
        }else{
            if window == nil{
                ROUTER_LOGGER.error("【页面移除失败，获取window失败】")
            }else if !(window!!.rootViewController is UINavigationController){
                ROUTER_LOGGER.error("【页面移除失败，rootViewController需继承UINavigationController或者其子类】")
            }
        }
    }
    
    /// 跳转页面
    ///
    /// - Parameter data: 路由类别
    fileprivate func push(data : String,black :JRouterMethod<RouterPagerAgreement>? = nil , anim :JRouterMethod<UINavigationController>? = nil){
        let key = pathHandle == nil ? data : pathHandle!.realHandle(path: data)
        let className = pathDic.getPagerName(key: key)
        if className == nil {
            ROUTER_LOGGER.error("路由失败，页面注册列表中，不包含该页面 path ->>> \(data)")
            return
        }
        let vc =  (NSClassFromString(className!) as! UIViewController.Type).init()
        if vc is RouterPagerAgreement {
            black? (vc as! RouterPagerAgreement)
            if interceipt != nil {
                let isInterceipt = (interceipt?.realIntercept(path: key, intent: vc as! RouterPagerAgreement))!
                if isInterceipt {
                    return
                }
            }
        }
        let window = UIApplication.shared.delegate?.window
        if window != nil && window!!.rootViewController is UINavigationController {
            anim?((window!!.rootViewController as! UINavigationController))
            (window!!.rootViewController as! UINavigationController).pushViewController(vc, animated: true)
            ROUTER_LOGGER.debug("【路由成功,路由至\(className!)页面成功】")
        }else{
            if window == nil{
                ROUTER_LOGGER.error("【路由失败，获取window失败】")
            }else if !(window!!.rootViewController is UINavigationController){
                ROUTER_LOGGER.error("【路由失败，rootViewController需继承UINavigationController或者其子类】")
            }
        }
    }
    
}

/// 页面路由
public class JRouter {
    
    private init() {
        
    }
    
    /// 跳转页面
    ///
    /// - Parameter path: 路径字符串
    public static func push(path :String,block :JRouterMethod<RouterPagerAgreement>? = nil, anim :JRouterMethod<UINavigationController>? = nil){
        JRouterCore.shared.push(data: path,black: block ,anim: anim)
    }
    
    /// 退出到指定已存在Controller
    ///
    /// - Parameters:
    ///   - path: 路径
    ///   - anim: 动画
    public static func popToPageInStack(path :String ,anim :Bool){
        JRouterCore.shared.popToPageInStack(data: path , anim:anim)
    }
    
    /// 从UINavigationController移除某个页面
    ///
    /// - Parameter data: 页面索引
    public static func removePageInStack(path :String){
        JRouterCore.shared.removePageInStack(data: path)
    }
    
    /// 获取当前显示页面
    public static func getCurrentPage() ->UIViewController?{
        return JRouterCore.shared.getCurrentPage()
    }
    
    /// 获取实例
    ///
    /// - Parameter data: 索引
    /// - Returns: 实例
    public static func getInstance(data : String) ->UIViewController?{
        return JRouterCore.shared.getInstance(data: data)
    }
    
    // pop到根页面
    ///
    /// - Parameter anim: 是否需要动画
    public static func popToRoot(anim :Bool = true){
        JRouterCore.shared.popToRoot(anim: anim)
    }
    
    /// 当前ViewController是否包含该页面
    ///
    /// - Parameter name: 页面路径
    /// - Returns: 是否包含
    public static func hasPager(path :String) -> Bool{
        return JRouterCore.shared.hasPager(name:path)
    }
    
    /// 开启路由日志打印
    public static func enableDebuger(){
        ROUTER_LOGGER.enableLogger()
    }
    
    /// 开启缓存策略
    public static func enableCache(){
        JRouterCore.shared.cacheEnable = true
    }
    
}




