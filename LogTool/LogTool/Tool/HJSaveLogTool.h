//
//  HJSaveLogTool.h
//  ilopTest
//
//  Created by huangjian on 2018/8/1.
//  Copyright © 2018年 huangjian. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HJSaveLogTool : NSObject
/// 保存日志文件
+ (void)redirectNSLogToDocumentFolder;

+ (NSString *)readFromLogFile;

+(void)removeLogFile;

//+(void)freOpenLogToConsole;
@end
