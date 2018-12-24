//
//  RouterPagerDictionary.swift
//  JRouterDemo
//
//  Created by LDD on 2018/12/20.
//  Copyright © 2018 Parrot. All rights reserved.
//

import Foundation
import UIKit

/// 路由路径字典封装类
class RouterPagerDictionary : RouterPagerDictionaryInput ,RouterPagerDictionaryOutput  {

    /// 存储实体
    private let dic = NSMutableDictionary()
    
    /// 页面总数
    public var pageCount: Int {
        get {
            return dic.count
        }
    }
    
    /// 注册页面
    ///
    /// - Parameters:
    ///   - controller: controller页面
    ///   - key: 页面索引
    func registerRouterPager(controller: UIViewController.Type, key: String) {
        if controller is RouterPagerAgreement.Type{
            ROUTER_LOGGER.info("注入页面 =======>>>> \(controller.routerClassName)  Path====>>>>> \(key)")
            dic.setValue(controller.routerClassName, forKey: key)
        }
    }
    
    /// 获取页面
    ///
    /// - Parameter key: 索引
    /// - Returns: 页面
    func getPagerName(key: String) -> String? {
        let result = dic.value(forKey: key)
        if result == nil {
            return nil
        }else{
            return result as? String
        }
    }
    
}

/// 路由字典输入协议
public protocol RouterPagerDictionaryInput : RouterPagerInfo{
    
    /// 注册页面
    ///
    /// - Parameters:
    ///   - controller: controller页面
    ///   - key: 页面索引
    func registerRouterPager(controller :UIViewController.Type , key : String)
    
}

/// 路由字典输出协议
protocol RouterPagerDictionaryOutput : RouterPagerInfo{
    
    /// 获取页面
    ///
    /// - Parameter key: 索引
    /// - Returns: 页面
    func getPagerName(key :String) ->String?
    
}

public protocol RouterPagerInfo {
    /// 页面总数
    var pageCount :Int { get }
}
