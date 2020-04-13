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

        let test = UserDefaults.standard.value(forKey: "test")
        if test != nil {
            print(test)
        }
        
        
        let array = [Int]()
        array[1]
        
        
    }
}

extension ViewController: CrashCensorDelegate {
    func crashEyeDidCatchCrash(model: CrashModel) {
        UserDefaults.standard.setValue(model, forKey: "test")
        UserDefaults.standard.synchronize()
        print(model)
    }
}

