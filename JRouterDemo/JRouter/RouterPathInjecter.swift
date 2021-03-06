//
//  RouterPathInjecter.swift
//  JRouterDemo
//
//  Created by LDD on 2018/12/20.
//  Copyright © 2018 Parrot. All rights reserved.
//

import Foundation
import UIKit

/// 路径注入器
open class RouterPathInjecter :NSObject , JRouterProcessorControl{
    
    
    required override public init() {
        
    }
    
    /// 基础Class提供者
    ///
    /// - Returns: 基础Class
    open func baseClassProvider() ->[AnyClass]{
        return [UIViewController.self]
    }
    
    /// 注入 模块内调用
    ///
    /// - Returns: 模块注入路径综合
    func realInject(pagerDic : RouterPagerDictionaryInput) {
        ROUTER_LOGGER.info("===========================================")
        ROUTER_LOGGER.info("            JROUTER开始路径注入")
        ROUTER_LOGGER.info("===========================================")
        inject(pagerDic: pagerDic)
        ROUTER_LOGGER.info("================================================================")
        ROUTER_LOGGER.info("        JROUTER路径注入结束，共注入\(pagerDic.pageCount)个页面")
        ROUTER_LOGGER.info("================================================================")
    }
    
    /// 注入 外部暴露
    ///
    /// - Returns: 模块注入路径综合
    open func inject(pagerDic : RouterPagerDictionaryInput) {
        baseClassProvider().forEach {[unowned self] baseClass in
            self.initOfBaseClass(baseClass: baseClass, pagerDic: pagerDic)
        }
    }
    
    /// 初始化以一个baseClass为基准
    ///
    /// - Parameters:
    ///   - baseClass: 基类
    ///   - pagerDic: 路径字典
    private func initOfBaseClass(baseClass : AnyClass , pagerDic : RouterPagerDictionaryInput){
        Utils.subclasses(baseClass).forEach {[unowned self] item in
            let type = (item as! UIViewController.Type)
            if !self.skip(className: type.routerClassName) && item is RouterPagerAgreement.Type && !skipBaseClass(className: type.routerClassName){
                pagerDic.registerRouterPager(controller: type , key: pathDictionaryProvider()[String(type.routerClassName.split(separator: ".")[1])]!)
            }
        }
    }
    
    /// 跳过基础Class不予注入
    ///
    /// - Parameter className: 类名
    /// - Returns: 是否跳过
    private func skipBaseClass(className :String) ->Bool{
        for baseClass in baseClassProvider(){
            let name = (baseClass as! UIViewController.Type).routerClassName
            if name.contains(className) {
                return true
            }
        }
        return false
    }
    
    /// 决策那些页面需要跳过注入
    ///
    /// - Parameter className: 页面名称
    /// - Returns: 是否跳过
    open func skip(className : String) -> Bool{
        for baseClass in skipListProvider(){
            if className.contains(baseClass) {
                return true
            }
        }
        return false
    }
    
    /// 跳过页面的内容提供者
    ///
    /// - Returns: 跳过页面数组
    open func skipListProvider() ->[String]{
        return []
    }
    
    /// 类名：路径字典
    ///
    /// - Returns:字典
    open func pathDictionaryProvider() ->[String:String]{
        return [:]
    }
    
    /// 处理器级别控制 只使用级别最高的处理器
    ///
    /// - Returns: 处理器级别
    open func getProcessorLevel() -> Int {
        return 1
    }
    
}
