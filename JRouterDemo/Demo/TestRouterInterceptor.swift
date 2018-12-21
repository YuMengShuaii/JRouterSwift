//
//  JRouterInterceptor.swift
//  JRouterDemo
//
//  Created by LDD on 2018/12/20.
//  Copyright © 2018 Parrot. All rights reserved.
//

import Foundation

class TestInterceptor: RouterInterceptor {
    
    /// 拦截操作
    ///
    /// - Parameters:
    ///   - path: 路径
    ///   - intent: 数据
    /// - Returns: 是否拦截跳转
    override func intercept(path: String, intent: RouterPagerAgreement) -> Bool {
        return false
    }
    
}
