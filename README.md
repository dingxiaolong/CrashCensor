# CrashCensor #
## 记录崩溃日志的siwft版本 ##

## 参考自阿里陈奕龙 ##

## 简介 ##

>> iOS闪退基本可以分为两种:底层信号Signal和未捕获异常崩溃,
未捕获异常崩溃苹果提供了一个方法NSSetUncaughtExceptionHandler来记录闪退后的回调方法,闭包里面会有一个NSExcaption的返回,根据

底层信号崩溃 SIGABRT 收到abort信号被强制退出,底层信号崩溃一般是C或者C++的代码造成的
  SIGFPE:数学计算相关问题,比如除以0的计算等
  ```language
  code
  ```

 ###





