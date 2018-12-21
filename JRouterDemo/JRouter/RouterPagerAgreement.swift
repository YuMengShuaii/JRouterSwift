//
//  RouterPagerAgreement.swift
//  JRouterDemo
//
//  Created by LDD on 2018/12/20.
//  Copyright © 2018 Parrot. All rights reserved.
//

/// 基础数据接口
public protocol RouterPagerAgreement {
    
    /// 设置内容
    ///
    /// - Parameters:
    ///   - key: 索引 不可重复
    ///   - value: 数据
    func setArgs(key :String , value :Any)
    
    /// 获取参数
    ///
    /// - Parameter key: 索引
    /// - Returns: 参数
    func getArgs<T>(key : String , defaultValue : T?) ->T
    
}
