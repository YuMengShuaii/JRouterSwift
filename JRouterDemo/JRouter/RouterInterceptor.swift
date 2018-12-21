//
//  RouterInterceptor.swift
//  JRouterDemo
//
//  Created by LDD on 2018/12/20.
//  Copyright © 2018 Parrot. All rights reserved.
//

import Foundation

/// 路由拦截器
open class RouterInterceptor : NSObject , JRouterProcessorControl{
    
    required override public init() {
        
    }
    
    /// 拦截操作 模块调用
    ///
    /// - Parameters:
    ///   - path: 路径
    ///   - intent: 数据载体
    /// - Returns: 是否拦截
    func realIntercept(path :String , intent :RouterPagerAgreement) -> Bool {
        let isIntercept =  intercept(path:path , intent: intent)
        if (isIntercept){
            ROUTER_LOGGER_PROXY.debug("路由\(path)页面时，被拦截")
        }
        return isIntercept
    }
    
    /// 拦截操作
    ///
    /// - Parameters:
    ///   - path: 路径
    ///   - intent: 数据载体
    /// - Returns: 是否拦截
    open func intercept(path :String , intent :RouterPagerAgreement) -> Bool {return false}
    
    /// 处理器级别控制 只使用级别最高的处理器
    ///
    /// - Returns: 处理器级别
    open func getProcessorLevel() -> Int {
        return 1
    }
    
}
