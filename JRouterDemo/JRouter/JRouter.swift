//
//  JRouter.swift
//  JRouterDemo
//
//  Created by LDD on 2018/12/20.
//  Copyright © 2018 Parrot. All rights reserved.
//

import UIKit

/// 路由日志代理
var ROUTER_LOGGER_PROXY : JRouterLoggerProxy = JRouterLoggerProxy()

/// 路由核心类
fileprivate class JRouterCore {
    
    ///单例
    fileprivate static let shared = JRouterCore()
    
    /// 路径DIC
    private let pathDic : RouterPagerDictionaryOutput = RouterPagerDictionary()
    
    /// 构建拦截器
    lazy var interceipt : RouterInterceptor? = getObject()
    
    /// 构建路径处理
    lazy var pathHandle : RouterPathHandle? = getObject()
    
    /// 构建路径注入
    lazy var injecter : RouterPathInjecter? = getObject()
    
    /// 初始化
    init() {
        //路径注入
        injecter?.inject(pathDic: pathDic as! RouterPagerDictionaryInput)
    }
    
    /// 获取路径处理器
    private func getObject<T : NSObject>() -> T?{
        var handle : T? = nil
        Utils.subclasses(T.self).forEach { item in
            let type = (item as! T.Type)
            handle = type.init()
            ROUTER_LOGGER_PROXY.debug("【处理器初始化,找到\(T.className)的实现子类】=>>> \(type.className)")
            return
        }
        return handle
    }
    
    /// 获取实例
    ///
    /// - Parameter data: 索引
    /// - Returns: 实例
    fileprivate func getInstance(data : String) ->UIViewController? {
        let key = pathHandle == nil ? data : (pathHandle?.realHandle(path: data))!
        let className = pathDic.getPagerName(key: key)
        if className == nil {
            ROUTER_LOGGER_PROXY.error("【无法找到该页面！】=> Path = \(data)")
            return nil
        }
        let vc =  (NSClassFromString(className! as String) as! UIViewController.Type).init()
        ROUTER_LOGGER_PROXY.debug("【获取到\(data)路径所指向实例】->>> \(className!)")
        return vc
    }
    
    /// pop到根页面
    ///
    /// - Parameter anim: 是否需要动画
    fileprivate func popToRoot(anim :Bool = true){
        let app = UIApplication.shared.delegate as! AppDelegate
        (app.window?.rootViewController as! UINavigationController).popToRootViewController(animated: anim)
        ROUTER_LOGGER_PROXY.debug("【已退出至根页面】")
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
            ROUTER_LOGGER_PROXY.error("退出页面失败,页面注册列表中，不包含该页面 path ->>> \(data)")
            return
        }
        let app = UIApplication.shared.delegate as! AppDelegate
        (app.window?.rootViewController as! UINavigationController).viewControllers.forEach { item in
            if  item.className.fitClassname().contains(className!) {
                (app.window?.rootViewController as! UINavigationController).popToViewController(item, animated: anim)
            }
        }
        ROUTER_LOGGER_PROXY.debug("【退出页面成功，成功退至\(className!)页面】")
    }
    
    
    /// 获取当前显示视图
    ///
    /// - Returns: 当前显示视图
    fileprivate func getCurrentPage() ->UIViewController?{
        let app = UIApplication.shared.delegate as! AppDelegate
        return  (app.window?.rootViewController as! UINavigationController).topViewController?.with({ _ in
            ROUTER_LOGGER_PROXY.debug("【获取当前顶部视图成功】")
        })
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
            ROUTER_LOGGER_PROXY.error("页面注册列表中，不包含该页面 path ->>> \(name)")
            return false
        }
        let app = UIApplication.shared.delegate as! AppDelegate
        (app.window?.rootViewController as! UINavigationController).viewControllers.forEachEnumerated { (index, item) in
            if  item.className.fitClassname().contains(className!) {
                has = true
                return
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
            ROUTER_LOGGER_PROXY.error("移除页面失败，页面注册列表中，不包含该页面 path ->>> \(data)")
            return
        }
        let app = UIApplication.shared.delegate as! AppDelegate
        (app.window?.rootViewController as! UINavigationController).viewControllers.forEachEnumerated { (index, item) in
            if  item.className.fitClassname().contains(className!) {
                (app.window?.rootViewController as! UINavigationController).viewControllers.remove(at: index)
                ROUTER_LOGGER_PROXY.debug("【移除栈内\(className!)页面成功】")
                return
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
            ROUTER_LOGGER_PROXY.error("路由失败，页面注册列表中，不包含该页面 path ->>> \(data)")
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
        let app = UIApplication.shared.delegate as! AppDelegate
        anim?((app.window?.rootViewController as! UINavigationController))
        (app.window?.rootViewController as! UINavigationController).pushViewController(vc, animated: true)
        ROUTER_LOGGER_PROXY.debug("【路由成功,路由至\(className!)页面成功】")
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
        ROUTER_LOGGER_PROXY.enableLogger()
    }
    
}




