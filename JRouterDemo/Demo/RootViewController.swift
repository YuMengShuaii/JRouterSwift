//
//  ViewController.swift
//  JRouterDemo
//
//  Created by LDD on 2018/12/20.
//  Copyright © 2018 Parrot. All rights reserved.
//

import UIKit

class RootViewController: UIViewController , RouterPagerAgreement{
    
    func getArgs<T>(key: String, defaultValue: T?) -> T {
        return "" as! T
    }
    
    func setArgs(key: String, value: Any) {
        
    }
    
    let textView = UILabel().with {
        $0.font = UIFont.systemFont(ofSize: 15)
        $0.textColor = .black
        $0.textAlignment = .center
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        textView.frame = CGRect.init(x: 0, y: 0, width: SCREEN_WIDTH, height: 40)
        textView.text = "该页面为根页面"
        textView.center = CGPoint.init(x: SCREEN_WIDTH/2, y: SCREEN_HEIGHT/2)
        self.view.addSubview(textView)
        textView.setOnClickListener(target: self, action: #selector(push))
    }
    
    @objc func push(){
        JRouter.push(path: JRouterPathType.ROOT)
    }

}

