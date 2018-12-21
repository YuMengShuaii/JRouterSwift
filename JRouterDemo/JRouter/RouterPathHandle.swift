//
//  RouterPathHandle.swift
//  JRouterDemo
//
//  Created by LDD on 2018/12/20.
//  Copyright © 2018 Parrot. All rights reserved.
//

import Foundation

/// 路由路径处理器
open class RouterPathHandle : NSObject{
    
    required override public init() {
        
    }
    
    /// 路径处理 模块内私有暴露
    ///
    /// - Parameter path: 原始路径
    /// - Returns: 处理后的路径
    func realHandle(path :String) ->String {
        let newPath = handle(path: path)
        if (path != newPath){
            ROUTER_LOGGER_PROXY.debug("【路由路径已被处理】处理前->> \(path) 处理后->>> \(newPath)")
        }
        return newPath
    }
    
    /// 路径处理 外部暴露
    ///
    /// - Parameter path: 原始路径
    /// - Returns: 处理后的路径
    open func handle(path :String) ->String {return path}
    
}
