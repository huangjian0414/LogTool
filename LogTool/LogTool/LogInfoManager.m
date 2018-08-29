\


//
//  LogInfoManager.m
//  ilopTest
//
//  Created by huangjian on 2018/8/3.
//  Copyright © 2018年 huangjian. All rights reserved.
//

#import "LogInfoManager.h"

@implementation LogInfoManager
+(instancetype)shareInstance
{
    static LogInfoManager * singleClass = nil;
    static dispatch_once_t onceToken ;
    dispatch_once(&onceToken, ^{
        singleClass = [[LogInfoManager alloc] init] ;
    }) ;
    
    return singleClass ;
}
-(void)showLogInfoVC
{
    self.isShowLogVC=YES;
    if (self.logInfoView) {
        self.logInfoView.hidden=NO;
    }else
    {
        self.logInfoView = [[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:@"logInfo"].view;
        [[UIApplication sharedApplication].keyWindow addSubview:self.logInfoView];
        [[UIApplication sharedApplication].keyWindow bringSubviewToFront:self.logBtn];
    }
}
-(void)dismissLogInfoVC
{
    self.isShowLogVC=NO;
    if (self.logInfoView) {
        self.logInfoView.hidden=YES;
    }
}

@end
