//
//  JavaShopPathHandle.swift
//  JRouterDemo
//
//  Created by LDD on 2018/12/20.
//  Copyright © 2018 Parrot. All rights reserved.
//

import Foundation

class TestPathHandle: RouterPathHandle {
    
    /// 处理器
    ///
    /// - Parameter path: 原始路径
    /// - Returns: 处理后的路径
    override func handle(path: String) -> String {
        return path
    }
    
}
