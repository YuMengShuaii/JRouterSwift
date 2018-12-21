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
    
    override func pathDictionaryProvider() -> [String : String] {
        return ["RootViewController":JRouterPathType.ROOT.rawValue]
    }
    
}

/// 路径注入器
class AAAPathInjecter : RouterPathInjecter {
    
    override func pathDictionaryProvider() -> [String : String] {
        return ["XXXXX":JRouterPathType.ROOT.rawValue]
    }
    
    override func getProcessorLevel() -> Int {
        return 10
    }

}

