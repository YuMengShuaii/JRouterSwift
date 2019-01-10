//
//  ViewController.swift
//  JRouterDemo
//
//  Created by LDD on 2018/12/20.
//  Copyright © 2018 Parrot. All rights reserved.
//

import UIKit

class RootViewController: UIViewController , RouterPagerAgreement{
    
//    lazy var testValue : Int = getArgs(key: "int", defaultValue: 99)
//
//    lazy var testObject :String = getArgs(key: "string", defaultValue: "string")
//
//    private var intent : [String : Any] = [:]
//
//    func setArgs(key: String, value: Any) {
//        intent[key] = value
//    }
//
//    func getArgs<T>(key: String, defaultValue: T) -> T {
//        let value = intent.removeValue(forKey: key)
//        if value == nil{
//            return defaultValue
//        }else{
//            return value! as! T
//        }
//    }
    
    
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
//        LOGGER.debug(testValue)
//        LOGGER.debug(testObject)
    }
    
    @objc func push(){
        JRouter.push(path: .TEST,block:{
            $0.setArgs(key: "int", value: 10000)
            $0.setArgs(key: "string", value: "AAAAAAA")
        })
    }

}



class TestViewController: UIViewController , RouterPagerAgreement{
    
    //    lazy var testValue : Int = getArgs(key: "int", defaultValue: 99)
    //
    //    lazy var testObject :String = getArgs(key: "string", defaultValue: "string")
    //
    //    private var intent : [String : Any] = [:]
    //
    //    func setArgs(key: String, value: Any) {
    //        intent[key] = value
    //    }
    //
    //    func getArgs<T>(key: String, defaultValue: T) -> T {
    //        let value = intent.removeValue(forKey: key)
    //        if value == nil{
    //            return defaultValue
    //        }else{
    //            return value! as! T
    //        }
    //    }
    
    
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
        //        LOGGER.debug(testValue)
        //        LOGGER.debug(testObject)
    }
    
    @objc func push(){
        JRouter.push(path: .TEST,block:{
            $0.setArgs(key: "int", value: 10000)
            $0.setArgs(key: "string", value: "AAAAAAA")
        })
    }
    
}
