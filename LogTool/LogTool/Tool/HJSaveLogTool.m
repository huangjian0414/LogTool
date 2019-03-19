


//
//  HJSaveLogTool.m
//  ilopTest
//
//  Created by huangjian on 2018/8/1.
//  Copyright © 2018年 huangjian. All rights reserved.
//

#import "HJSaveLogTool.h"
#import <UIKit/UIKit.h>

static FILE *fp;
@implementation HJSaveLogTool
#pragma mark - 保存日志文件
+ (void)redirectNSLogToDocumentFolder{
    //如果已经连接Xcode调试则不输出到文件
    //if(isatty(STDOUT_FILENO)) {return; }
    //    UIDevice *device = [UIDevice currentDevice];
    //    if([[device model] hasSuffix:@"Simulator"]){
    //        //在模拟器不保存到文件中
    //        return;
    //    }
    //获取Document目录下的Log文件夹,若没有则新建
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *logDirectory = [[paths objectAtIndex:0] stringByAppendingPathComponent:@"Log"];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL fileExists = [fileManager fileExistsAtPath:logDirectory];
    if (!fileExists) {
        [fileManager createDirectoryAtPath:logDirectory withIntermediateDirectories:YES attributes:nil error:nil];
        
    }
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"]];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    //每次启动后都保存一个新的日志文件中
    //NSString *dateStr = [formatter stringFromDate:[NSDate date]];
    NSString *logFilePath = [logDirectory stringByAppendingFormat:@"/%@.txt",@"log"];
    // freopen 重定向输出流,将log输入到文件
    //  printf --> stdout    NSLog --> stderr  stdin是标准输入流，默认为键盘；stdout是标准输出流，默认为屏幕；stderr是标准错误流，一般把屏幕设为默认
    freopen([logFilePath cStringUsingEncoding:NSASCIIStringEncoding], "a+", stdout);
    freopen([logFilePath cStringUsingEncoding:NSASCIIStringEncoding], "a+", stderr);
}
+ (NSString *)readFromLogFile
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *logDirectory = [[paths objectAtIndex:0] stringByAppendingPathComponent:@"Log"];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL fileExists = [fileManager fileExistsAtPath:logDirectory];
    if (!fileExists) {
        [fileManager createDirectoryAtPath:logDirectory withIntermediateDirectories:YES attributes:nil error:nil];
    }
    NSString *logFilePath = [logDirectory stringByAppendingFormat:@"/%@.txt",@"log"];
    NSString *content = [[NSString alloc] initWithContentsOfFile:logFilePath encoding:NSUTF8StringEncoding error:nil];
    return content;
}
+(void)removeLogFile
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *logDirectory = [[paths objectAtIndex:0] stringByAppendingPathComponent:@"Log"];
    NSString *logFilePath = [logDirectory stringByAppendingFormat:@"/%@.txt",@"log"];
    NSFileManager *fileManage = [NSFileManager defaultManager];
    if ([fileManage fileExistsAtPath:logFilePath]) {
        [fileManage removeItemAtPath:logFilePath error:nil];
        [self redirectNSLogToDocumentFolder];
    }
    
}

@end
