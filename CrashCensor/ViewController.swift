//
//  ViewController.swift
//  CrashCensor
//
//  Created by tonbright on 2020/4/10.
//  Copyright © 2020 tonbright. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        CrashEye.shareInstance.add(delegate: self)

        let test = UserDefaults.standard.value(forKey: "test") as? String ?? ""
        if test != nil || test != "" {
            print(test)
        }
        
        
        let array = [Int]()
        array[1]        
    }
}

extension ViewController: CrashCensorDelegate {
    func crashEyeDidCatchCrash(model: CrashModel) {
        let string = "名字:" + model.name + "\r" + "原因:" + model.reason + "\r" + "app信息:" + model.appinfo + "\r" + "堆栈信息:" + model.callStack
        UserDefaults.standard.setValue(string, forKey: "test")
        UserDefaults.standard.synchronize()
        print(model)
    }
}

