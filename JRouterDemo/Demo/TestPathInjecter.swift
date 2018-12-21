//
//  JavaShopPathInjecter.swift
//  JRouterDemo
//
//  Created by LDD on 2018/12/20.
//  Copyright © 2018 Parrot. All rights reserved.
//
import UIKit
import Foundation

/// 路径注入器
class TestPathInjecter : RouterPathInjecter {
    
    /// 需要跳过不进行注入的ViewController
    private let skipArray = [""]
    
    /// 注入
    ///
    /// - Parameters:
    ///   - pathHandle: 路径处理器
    ///   - pathDic: 路径集合
    /// - Returns: path总数
    override func inject(pathDic: RouterPagerDictionaryInput) {
        Utils.subclasses(UIViewController.self).forEach {[unowned self] item in
            let type = (item as! UIViewController.Type)
            if !self.skip(className: type.className){
                pathDic.registerRouterPager(controller: type, key: JRouterPathType.typeOfPage(className: type.className).rawValue)
            }
        }
    }
    
    /// 判断是否需要跳过
    private func skip(className : String) -> Bool{
        return skipArray.contains(className)
    }
    
}
