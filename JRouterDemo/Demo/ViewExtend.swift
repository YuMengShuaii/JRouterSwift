//
//  ViewExtend.swift
//  JRouterDemo
//
//  Created by LDD on 2018/12/20.
//  Copyright © 2018 Parrot. All rights reserved.
//

import UIKit

extension UIView{
    /// 设置点击事件
    ///
    /// - Parameters:
    ///   - target: 事件所在对象
    ///   - action: 事件Selector
    public func setOnClickListener(target: Any?, action: Selector?){
        isUserInteractionEnabled = true
        let clickEvent = UITapGestureRecognizer.init(target: target, action: action)
        clickEvent.numberOfTapsRequired = 1
        addGestureRecognizer(clickEvent)
    }
}
