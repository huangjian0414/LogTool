//
//  HJSaveLogTool.h
//  ilopTest
//
//  Created by huangjian on 2018/8/1.
//  Copyright © 2018年 huangjian. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HJSaveLogTool : NSObject
+ (void)redirectNSLogToDocumentFolder;

+ (NSString *)readFromLogFile;

+(void)removeLogFile;
@end
