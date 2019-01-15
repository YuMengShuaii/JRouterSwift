//
//  Utils.swift
//  JRouterDemo
//
//  Created by LDD on 2018/12/20.
//  Copyright © 2018 Parrot. All rights reserved.
//

import Foundation
import UIKit
/// 工具类
class Utils{
    /// 获取指定类所有子类
    ///
    /// - Parameter baseclass: 指定类
    /// - Returns: 子类集合
    static func subclasses(_ baseclass: AnyClass!) -> [AnyClass] {
        
        var result = [AnyClass]()
        
        guard let baseclass = baseclass else {
            return result
        }
        
        func isImpl(someclass: AnyClass) ->Bool{
            let superClass : AnyClass? = class_getSuperclass(someclass)
            if superClass ==  nil{
                return false
            }
            if (superClass == baseclass) {
                return true
            }
            return isImpl(someclass: superClass!)
        }
        
        let count: Int32 = objc_getClassList(nil, 0)
        
        guard count > 0 else {
            return result
        }
        
        let classes = UnsafeMutablePointer<AnyClass>.allocate(
            capacity: Int(count)
        )
        
        defer {
            classes.deallocate()
        }
        
        let buffer = AutoreleasingUnsafeMutablePointer<AnyClass>(classes)
        
        for i in 0..<Int(objc_getClassList(buffer, count)) {
            let someclass: AnyClass = classes[i]
            if isImpl(someclass: someclass) {
                result.append(someclass)
            }
        }
        
        return result
    }
}
