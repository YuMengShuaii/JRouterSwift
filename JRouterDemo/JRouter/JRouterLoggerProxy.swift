//
//  LoggerProxy.swift
//  JRouterDemo
//
//  Created by LDD on 2018/12/20.
//  Copyright © 2018 Parrot. All rights reserved.
//

import Foundation

/// 路由日志代理
class JRouterLoggerProxy {
    
    /// 日志标记
    private var loggerEnable = false
    
    /// 开启日志
    public func enableLogger(){
        loggerEnable = true
    }
    
    /// debug打印方法
    ///
    /// - Parameters:
    ///   - tag: TAG
    ///   - conetnt: 内容
    ///   - file: 文件名
    ///   - function: 方法名
    ///   - line: 行数
    public func debug(tag : String  = "JRouter::Debuger", _ conetnt : Any , file:String = #file, function:String = #function , line:Int = #line){
        if !loggerEnable{
            return
        }
        let fileName = (file as NSString).lastPathComponent.split(separator: ".")[0]
        let location =  "\(fileName).\(function):\(line)"
        processor(logtype: 2, conetnt: " \(location) \(tag) ->>> \(conetnt)")
    }
    
    /// info打印方法
    ///
    /// - Parameters:
    ///   - tag: TAG
    ///   - conetnt: 内容
    ///   - file: 文件名
    ///   - function: 方法名
    ///   - line: 行数
    public func info(tag : String = "JRouter::Debuger", _ conetnt : Any , file:String = #file, function:String = #function , line:Int = #line) {
        if !loggerEnable{
            return
        }
        let fileName = (file as NSString).lastPathComponent.split(separator: ".")[0]
        let location =  "\(fileName).\(function):\(line)"
        processor(logtype: 2, conetnt: " \(location) \(tag) ->>> \(conetnt)")
    }
    
    /// erorr打印方法
    ///
    /// - Parameters:
    ///   - tag: TAG
    ///   - conetnt: 内容
    ///   - file: 文件名
    ///   - function: 方法名
    ///   - line: 行数
    public func error(tag : String = "JRouter::Debuger", _ conetnt : Any , file:String = #file, function:String = #function , line:Int = #line){
        let fileName = (file as NSString).lastPathComponent.split(separator: ".")[0]
        let location =  "\(fileName).\(function):\(line)"
        processor(logtype: 2, conetnt: " \(location) \(tag) ->>> \(conetnt)")
    }
    
    
    /// 日志处理方法
    ///
    /// - Parameters:
    ///   - logtype: 日志类型
    ///   - location: 日志打印位置
    ///   - tag: TAG
    ///   - conetnt: 内容
    func processor(logtype: Int , conetnt: String) {
        let heart = logtype == 1 ? "❤️" : (logtype == 2 ? "💙" :"💚")
        print("\(getNowDay()) \(heart) \(logtype == 1 ? "ERROR" : (logtype == 2 ? "DEBUG" :"INFO")) ->>> \(conetnt)")
    }
    
    /// 获取当前日期
    ///
    /// - Returns: 当前日期字符串
    private func getNowDay() ->String{
        let date = Date(timeIntervalSince1970: Date().timeIntervalSince1970)
        let dformatter = DateFormatter()
        dformatter.dateFormat = "yyyy-MM-dd hh:mm:ss"
        return dformatter.string(from: date)
    }

}
