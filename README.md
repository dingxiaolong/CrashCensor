# CrashCensor #
## 记录崩溃日志的siwft版本 ##

## 参考自阿里陈奕龙 ##

## 原理简介 ##

> iOS闪退基本可以分为两种:底层信号Signal和未捕获异常崩溃.

1. 未捕获异常崩溃苹果提供了一个方法NSSetUncaughtExceptionHandler来记录闪退后的回调方法,闭包里面会有一个NSExcaption类型的返回
```language
        NSSetUncaughtExceptionHandler(RecieveException)
```

2. 底层信号崩溃 SIGABRT 收到abort信号被强制退出,底层信号崩溃一般是C或者C++的代码造成的
  SIGFPE:数学计算相关问题,比如除以0的计算等
  ```language
   signal(<#T##Int32#>, <#T##((Int32) -> Void)!##((Int32) -> Void)!##(Int32) -> Void#>)
  ```

## 代码描述 ##
* sdk使用代理来完成的,CrashEye创建单例,并吧代理传给单例.
* 在发生crash的时候设置回调函数,实现

## demo注意事项 ##
在模拟器或者真机直接连接运行调试时,因为xcode调试框的优先级更高,所以不会走自己的代理方法,此时打印不大相关的crash信息.我们需要先断开和xcode的连接,把crash存到本地,然后再下次进入app的时候进行读取,或者上传到服务器的操作


  
