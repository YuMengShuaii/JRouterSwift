//
//  JRouterExtend.swift
//  JRouterDemo
//
//  Created by LDD on 2018/12/20.
//  Copyright © 2018 Parrot. All rights reserved.
//

import UIKit

extension JRouter{
    
    /// 当前ViewController是否包含该页面
    ///
    /// - Parameter name: 页面路径
    /// - Returns: 是否包含
    public static func hasPager(type :JRouterPathType) -> Bool{
        return hasPager(path: type.rawValue)
    }
    
    /// 从UINavigationController移除某个页面
    ///
    /// - Parameter data: 页面索引
    public static func removePageInStack(path :JRouterPathType){
        removePageInStack(path: path.rawValue)
    }
    
    /// 跳转页面
    ///
    /// - Parameter path: 路径枚举
    public static func push(path :JRouterPathType,block :JRouterMethod<RouterPagerAgreement>? = nil, anim :JRouterMethod<UINavigationController>? = nil){
        push(path: path.rawValue, block: block, anim: anim)
    }
    
    /// 退出到指定已存在Controller
    ///
    /// - Parameters:
    ///   - path: 路径
    ///   - anim: 动画
    public static func popToPageInStack(path :JRouterPathType ,anim :Bool){
        popToPageInStack(path: path.rawValue, anim: anim)
    }
    
    public static func getInstance(type :JRouterPathType) -> UIViewController?{
        return JRouter.getInstance(data: type.rawValue)
    }
    
}
