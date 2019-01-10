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

    /// 初始化
    ///
    /// - Parameter notFoundHandle: notfoundc处理
    init(notFoundHandle : PagerNotFoundHandle) {
        self.notFoundHandle = notFoundHandle
    }
    
    /// 查找失败处理
    private weak var notFoundHandle : PagerNotFoundHandle? = nil
    
    /// 存储实体
    private let dic = NSMutableDictionary()
    
    /// 路由页面字典缓存索引
    private let ROUTER_CACHE_KEY = "router_dic_index"

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
        var result = dic.value(forKey: key)
        if result == nil {
            notFoundHandle?.notFoundHandle()
            result = dic.value(forKey: key)
        }
        if result == nil {
            return nil
        }
        return result as? String
    }
    
    /// 存储缓存
    func cacheDisk() {
        if dic.count > 0 {
            UserDefaults.standard.set(dic, forKey: ROUTER_CACHE_KEY)
        }
    }
    
    /// 读取缓存
    func formCache() {
        let cache = UserDefaults.standard.dictionary(forKey: ROUTER_CACHE_KEY)
        if cache != nil{
            dic.setDictionary(cache!)
        }
    }
    
    /// 清空
    func clear() {
        dic.removeAllObjects()
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

/// pager查找失败处理
protocol PagerNotFoundHandle :class {
    
    /// 处理接口
    func notFoundHandle()
    
}

public protocol RouterPagerInfo {
    /// 页面总数
    var pageCount :Int { get }
    
    /// 存储缓存
    func cacheDisk()
    
    /// 读取缓存
    func formCache()

    /// 清空
    func clear()
}
