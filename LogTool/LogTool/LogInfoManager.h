//
//  LogInfoManager.h
//  ilopTest
//
//  Created by huangjian on 2018/8/3.
//  Copyright © 2018年 huangjian. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface LogInfoManager : NSObject
+(instancetype)shareInstance;
@property (nonatomic,assign)BOOL isShowLogVC;

@property(nonatomic,strong) UIView *logInfoView;

@property(nonatomic,strong) UIButton *logBtn;

-(void)showLogInfoVC;
-(void)dismissLogInfoVC;
@end
