//
//  JRouterProcessorControl.swift
//  JRouterDemo
//
//  Created by LDD on 2018/12/21.
//  Copyright © 2018 Parrot. All rights reserved.
//

import Foundation

/// 处理器优先级协议
protocol JRouterProcessorControl{
    
    /// 获取处理器等级
    ///
    /// - Returns: 处理器等级
    func getProcessorLevel() -> Int
    
}
