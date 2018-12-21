//
//  RouterPathInjecter.swift
//  JRouterDemo
//
//  Created by LDD on 2018/12/20.
//  Copyright © 2018 Parrot. All rights reserved.
//

import Foundation

/// 路径注入器
open class RouterPathInjecter :NSObject {
    
    
    required override public init() {
        
    }
    
    /// 注入 模块内调用
    ///
    /// - Returns: 模块注入路径综合
    func realInject(pathDic : RouterPagerDictionaryInput) {
        ROUTER_LOGGER_PROXY.info("===========================================")
        ROUTER_LOGGER_PROXY.info("            JROUTER开始路径注入")
        ROUTER_LOGGER_PROXY.info("===========================================")
        inject(pathDic: pathDic)
        ROUTER_LOGGER_PROXY.info("================================================================")
        ROUTER_LOGGER_PROXY.info("        JROUTER路径注入结束，共注入\(pathDic.pageCount)个页面")
        ROUTER_LOGGER_PROXY.info("================================================================")
    }
    
    /// 注入 外部暴露
    ///
    /// - Returns: 模块注入路径综合
    open func inject(pathDic : RouterPagerDictionaryInput) {}
    
}
