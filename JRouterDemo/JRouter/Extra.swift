//
//  Extra.swift
//  JRouterDemo
//
//  Created by LDD on 2018/12/20.
//  Copyright © 2018 Parrot. All rights reserved.
//

import Foundation
import UIKit

/// 代码块类型
public typealias JRouterMethod<In1> = ((In1) ->())

/// 屏幕宽度
public let SCREEN_WIDTH   = UIScreen.main.bounds.width

/// 屏幕高度
public let SCREEN_HEIGHT  = UIScreen.main.bounds.height

/// with设置
public protocol AnyOpt {}
extension NSObject: AnyOpt {}
extension CGPoint: AnyOpt {}
extension CGRect: AnyOpt {}
extension CGSize: AnyOpt {}
extension CGVector: AnyOpt {}
extension AnyOpt where Self :Any {
    public func with(_ block: (inout Self) throws -> Void) rethrows -> Self {
        var copy = self
        try block(&copy)
        return copy
    }
}

// MARK: - 扩展Bundle
extension Bundle{
    var namespance : String{
        return infoDictionary?["CFBundleName"] as? String ?? ""
    }
}

// MARK: - 扩展NSObject
extension NSObject {
    public var routerClassName: String {
        return "\(Bundle.init(for: type(of: self)).namespance).\(String(describing: type(of: self)))"
    }
    
    public static var routerClassName: String {
        return "\(Bundle.init(for: self).namespance).\(String(describing: self))"
    }
}

// MARK: - 扩展Array
extension Array{
    public func easyFor(_ body: @escaping (_ offset: Int, _ element: Element) -> Void) {
        enumerated().forEach(body)
    }
}
