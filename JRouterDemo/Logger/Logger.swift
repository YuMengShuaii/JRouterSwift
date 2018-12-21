//
//  Logger.swift
//  日志打印组件
//
//  Created by LDD on 2018/12/20.
//  Copyright © 2018 Parrot. All rights reserved.
//

import Foundation

/// 全局变量 控制LOGGER开关
public var LOGGER_ENABLE = true

/// 日志打印组件
public class Log {
    
    /// 默认TAG
    fileprivate var defTag : String = "【Logger::Tag】"
    
    /// 默认打印处理器
    fileprivate var printerProcessor : LoggerProcessor = PrinterProcessor()
    
    /// Log可以添加多个自定义日志处理器
    fileprivate var processorList :[LoggerProcessor] = []
    
    /// 私有构造方法，防止外部直接实例化
    fileprivate init(){
        
    }
    
    /// 循环执行处理器列表
    ///
    /// - Parameters:
    ///   - logtype: 日志类型
    ///   - tag: TAG
    ///   - conetnt: 内容
    private func processor(logtype: LogType, location : LogLocation, tag: String?, conetnt: Any){
        processorList.forEach { item in
            item.processor(logtype: logtype,location: location, tag: tag, conetnt: conetnt)
        }
    }
    
    /// debug打印方法
    ///
    /// - Parameters:
    ///   - tag: TAG
    ///   - conetnt: 内容
    ///   - file: 文件名
    ///   - function: 方法名
    ///   - line: 行数
    public func debug(tag : String? = nil , _ conetnt : Any , file:String = #file, function:String = #function , line:Int = #line) {
        if !LOGGER_ENABLE {
            return
        }
        let location = LogLocation.init(fileName: file, method: function, line: line)
        printerProcessor.processor(logtype: .debug,location: location, tag: tag == nil ? defTag : tag, conetnt: conetnt)
        processor(logtype: .debug , location: location , tag: tag == nil ? defTag : tag, conetnt: conetnt)
    }
    
    /// info打印方法
    ///
    /// - Parameters:
    ///   - tag: TAG
    ///   - conetnt: 内容
    ///   - file: 文件名
    ///   - function: 方法名
    ///   - line: 行数
    public func info(tag : String? = nil, _ conetnt : Any , file:String = #file, function:String = #function , line:Int = #line) {
        if !LOGGER_ENABLE {
            return
        }
        let location = LogLocation.init(fileName: file, method: function, line: line)
        printerProcessor.processor(logtype: .info,location: location ,tag: tag == nil ? defTag : tag, conetnt: conetnt)
        processor(logtype: .debug , location: location , tag: tag == nil ? defTag : tag, conetnt: conetnt)
    }
    
    /// erorr打印方法
    ///
    /// - Parameters:
    ///   - tag: TAG
    ///   - conetnt: 内容
    ///   - file: 文件名
    ///   - function: 方法名
    ///   - line: 行数
    public func error(tag : String? = nil, _ conetnt : Any , file:String = #file, function:String = #function , line:Int = #line) {
        if !LOGGER_ENABLE {
            return
        }
        let location = LogLocation.init(fileName: file, method: function, line: line)
        printerProcessor.processor(logtype: .error,location: location, tag: tag == nil ? defTag : tag, conetnt: conetnt)
        processor(logtype: .debug , location: location , tag: tag == nil ? defTag : tag, conetnt: conetnt)
    }
    
    /// 静态构建方法
    ///
    /// - Returns: Log构建配置类
    public static func builder() ->LogBuilder {
        return LogBuilder()
    }
    
}

/// Log类型枚举
public enum LogType : String{
    case info = "INFO"
    case debug = "DEBUG"
    case error = "ERROR"
}

/// 日志处理器协议
/// 用户可根据该协议
/// 自助扩展日志打印功能
public protocol LoggerProcessor{
    
    /// 处理方法
    ///
    /// - Parameters:
    ///   - logtype: 日志类型
    ///   - location :代码位置
    ///   - tag: TAG
    ///   - conetnt: 内容
    func processor(logtype :LogType , location : LogLocation , tag : String?, conetnt : Any)
    
}

/// 日志构造器
public class LogBuilder{
    
    /// 私有构造方法，防止外部直接实例化
    fileprivate init(){
        
    }
    
    /// 懒加载Log
    private lazy var loger = Log()
    
    /// 设置标签
    ///
    /// - Parameter tag: 标签
    /// - Returns: 日志构造器
    public func setTag(tag :String) -> LogBuilder{
        loger.defTag = tag
        return self
    }
    
    /// 设置自定义日志打印处理器
    ///
    /// - Parameter printer: 自定义日志处理器
    /// - Returns: 日志构造器
    public func setCustomPrinterProcessor(printer :LoggerProcessor)  -> LogBuilder{
        loger.printerProcessor = printer
        return self
    }
    
    /// 添加额外日志处理器
    /// 例如可以通过实现LoggerProcessor协议开发上传日志到网络功能
    /// 可以通过实现LoggerProcessor协议开发日志本地化等功能
    /// - Parameter processor: 日志处理器
    /// - Returns: 日志构造器
    public func addProcessor(processor :LoggerProcessor)  -> LogBuilder{
        loger.processorList.append(processor)
        return self
    }
    
    /// 最终构建成功方法
    ///
    /// - Returns: 日志实体
    public func build() -> Log {
        return loger
    }
    
}

/// 预置日志打印实现类
private class PrinterProcessor : LoggerProcessor{
    
    /// 日志处理方法
    ///
    /// - Parameters:
    ///   - logtype: 日志类型
    ///   - location: 日志打印位置
    ///   - tag: TAG
    ///   - conetnt: 内容
    func processor(logtype: LogType , location : LogLocation, tag: String?, conetnt: Any) {
        let heart = logtype == .error ? "❤️" : (logtype == .debug ? "💙" :"💚")
        print("\(getNowDay()) \(heart) \(logtype.rawValue) ->>> \(location.toString()) \(tag!) ->>> \(conetnt)")
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

/// 日志打印位置信息
public struct LogLocation {
    
    /// 文件名
    var fileName :String
    
    /// 方法名
    var method :String
    
    /// 代码行
    var line :Int
    
    /// 格式化成字符串
    ///
    /// - Returns: 字符串
    public func toString() ->String{
        let file = (fileName as NSString).lastPathComponent.split(separator: ".")[0]
        return "\(file).\(method):\(line)"
    }
    
}
