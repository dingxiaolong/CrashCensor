//
//  CrashCensor.swift
//  CrashCensor
//
//  Created by tonbright on 2020/4/10.
//  Copyright © 2020 tonbright. All rights reserved.
//

import Foundation
import UIKit

enum CrashModelType: Int {
    case signal = 1
    case exception = 2
}

class CrashModel: NSObject {
    var crashType: CrashModelType
    var name: String
    var reason: String
    var appinfo: String
    var callStack: String
    
    init(crashType: CrashModelType,name: String,reason: String,appinfo: String,callStack: String) {
        self.crashType = crashType
        self.name = name
        self.reason = reason
        self.appinfo = appinfo
        self.callStack = callStack
        super.init()
    }
}

protocol CrashCensorDelegate {
    func crashEyeDidCatchCrash(model: CrashModel)
}


var app_old_exceptionHandler: (@convention(c) (NSException) -> Swift.Void)? = nil

class CrashEye: NSObject {
    static let shareInstance = CrashEye()
    var isOpen:Bool = false
    var delegate: CrashCensorDelegate?
    func add(delegate: CrashCensorDelegate) {
        //设置代理
        self.delegate = delegate
        //启动
        open()
    }
    
    
    func open() {
        guard CrashEye.shareInstance.isOpen == false else {
            return
        }
        CrashEye.shareInstance.isOpen = true
        //启动exceptionHandle
        app_old_exceptionHandler = NSGetUncaughtExceptionHandler()
        
        //指定闭包
        NSSetUncaughtExceptionHandler(RecieveException)
        
        //启动signle
        CrashEye.shareInstance.setCrashSignalHandel()
    }
    
    
    private func setCrashSignalHandel() {
        signal(SIGABRT, RecieveSignal)
        signal(SIGILL, RecieveSignal)
        signal(SIGSEGV, RecieveSignal)
        signal(SIGFPE, RecieveSignal)
        signal(SIGBUS, RecieveSignal)
        signal(SIGPIPE, RecieveSignal)
        //http://stackoverflow.com/questions/36325140/how-to-catch-a-swift-crash-and-do-some-logging
        signal(SIGTRAP, RecieveSignal)
    }
    
    let RecieveSignal:@convention(c) (Int32) -> Void = {
        (sinnal) -> Void in
        guard CrashEye.shareInstance.isOpen == true else {
            return
        }
        var stack = Thread.callStackSymbols
        let callStack = stack.joined(separator: "\r")
        let crashName = CrashEye.name(of: sinnal)
        let reason = "Signal \(crashName) was rasied. \n"
        
        let appinfo = CrashEye.appInfo()
        
        let model = CrashModel(crashType: CrashModelType.signal, name: crashName, reason: reason, appinfo: appinfo, callStack: callStack)
        CrashEye.shareInstance.delegate?.crashEyeDidCatchCrash(model: model)
        
        //需要杀死app?=======
        CrashEye.killApp()
    }
    
    
    private let RecieveException:@convention(c) (NSException) -> Void = {
        (exception) -> Void in
        if app_old_exceptionHandler != nil {
            app_old_exceptionHandler!(exception)
        }
        guard CrashEye.shareInstance.isOpen == true else {
            return
        }
        
//        let stack = Thread.callStackSymbols
        let stack = exception.callStackSymbols
        let callStack = stack.joined(separator: "\r")
        let reason = exception.reason ?? ""
        let name = exception.name
        let appinfo = ""
        
        let crashModel = CrashModel(crashType: CrashModelType.exception, name: name.rawValue, reason: reason, appinfo: appinfo, callStack: callStack)
        CrashEye.shareInstance.delegate?.crashEyeDidCatchCrash(model: crashModel)
    }
    
    
    class func appInfo() -> String {
        let displayName: String = Bundle.main.object(forInfoDictionaryKey: "CFBundleName") as? String ?? ""
        let shortVersion = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String ?? ""
//        let version = Bundle.main.object(forInfoDictionaryKey: "CFBundleVersion") as? String ?? ""
        let deviceModel = UIDevice.current.model
        let systemName = UIDevice.current.systemName
        let systemVersion = UIDevice.current.systemVersion
        let tmpStr = "App" + displayName + shortVersion + "\n" + "Device:" + deviceModel + "\n" + "OS Version:\(systemName) \(systemVersion)"
        return tmpStr
    }
    
    private class func name(of signal:Int32) -> String {
        switch (signal) {
        case SIGABRT:
            return "SIGABRT"
        case SIGILL:
            return "SIGILL"
        case SIGSEGV:
            return "SIGSEGV"
        case SIGFPE:
            return "SIGFPE"
        case SIGBUS:
            return "SIGBUS"
        case SIGPIPE:
            return "SIGPIPE"
        default:
            return "OTHER"
        }
    }
    
    
    private class func killApp(){
        NSSetUncaughtExceptionHandler(nil)
        signal(SIGABRT, SIG_DFL)
        signal(SIGILL, SIG_DFL)
        signal(SIGSEGV, SIG_DFL)
        signal(SIGFPE, SIG_DFL)
        signal(SIGBUS, SIG_DFL)
        signal(SIGPIPE, SIG_DFL)
        kill(getpid(), SIGKILL)
    }
}

