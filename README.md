# LogTool
虾逼怼一个导出控制台log的demo

![images](https://github.com/huangjian0414/LogTool/blob/master/Gif/logTool.gif)





## 使用方法

  `pod 'HJLogTool'`



`#import "HJLogTool.h"`

```
/// 开始写入日志流到文件
[HJSaveLogTool redirectNSLogToDocumentFolder];

/// 开启日志按钮
[[LogInfoManager shareInstance]start];
```

