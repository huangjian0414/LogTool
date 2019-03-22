\


//
//  LogInfoManager.m
//  ilopTest
//
//  Created by huangjian on 2018/8/3.
//  Copyright © 2018年 huangjian. All rights reserved.
//

#import "LogInfoManager.h"
#import "LogViewController.h"

#define kLogW  [UIScreen mainScreen].bounds.size.width
#define kLogH  [UIScreen mainScreen].bounds.size.height

static NSString *key=@"hj_isLogBtnHidden";
static NSString *logBtn_CenterX=@"hj_logBtn_CenterX";
static NSString *logBtn_CenterY=@"hj_logBtn_CenterY";

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
-(void)start
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        UIButton *btn=[UIButton buttonWithType:UIButtonTypeCustom];
        [btn setTitle:@"Log" forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        btn.titleLabel.font=[UIFont systemFontOfSize:14];
        btn.frame=CGRectMake(300, 40, 40, 40);
        if ([[NSUserDefaults standardUserDefaults]objectForKey:key]) {
            btn.hidden=[[[NSUserDefaults standardUserDefaults]objectForKey:key]boolValue];
        }else
        {
            btn.hidden=YES;
        }
        [btn setBackgroundColor:[UIColor blackColor]];
        [[UIApplication sharedApplication].keyWindow addSubview:btn];
        [btn addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];
        UIPanGestureRecognizer *pan=[[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(panBtn:)];
        [btn addGestureRecognizer:pan];
        if ([[NSUserDefaults standardUserDefaults]objectForKey:logBtn_CenterX]&&[[NSUserDefaults standardUserDefaults]objectForKey:logBtn_CenterY]) {
            CGPoint center=CGPointMake([[[NSUserDefaults standardUserDefaults]objectForKey:logBtn_CenterX]floatValue], [[[NSUserDefaults standardUserDefaults]objectForKey:logBtn_CenterY]floatValue]);
            btn.center=center;
        }
        [LogInfoManager shareInstance].logBtn=btn;
    });
}
-(void)showOrDismisLogButton
{
    [LogInfoManager shareInstance].logBtn.hidden=![LogInfoManager shareInstance].logBtn.hidden;
    [[NSUserDefaults standardUserDefaults]setObject:@([LogInfoManager shareInstance].logBtn.hidden) forKey:key];
    [[NSUserDefaults standardUserDefaults]synchronize];
}
-(void)clickBtn:(UIButton *)btn
{
    if (![LogInfoManager shareInstance].isShowLogVC) {
        [[LogInfoManager shareInstance]showLogInfoVC];
    }else
    {
        [[LogInfoManager shareInstance]dismissLogInfoVC];
    }
}
-(void)panBtn:(UIGestureRecognizer *)ges
{
    CGPoint point= [ges locationInView:[UIApplication sharedApplication].keyWindow];
    if (point.y<40) {
        point.y=40;
    }
    if (point.y>kLogH-40) {
        point.y=kLogH-40;
    }
    if (point.x<40) {
        point.x=40;
    }
    if (point.x>kLogW-40) {
        point.x=kLogW-40;
    }
    [LogInfoManager shareInstance].logBtn.center=point;
    if (ges.state==UIGestureRecognizerStateEnded) {
        [[NSUserDefaults standardUserDefaults]setObject:@(point.x) forKey:logBtn_CenterX];
        [[NSUserDefaults standardUserDefaults]setObject:@(point.y) forKey:logBtn_CenterY];
        [[NSUserDefaults standardUserDefaults]synchronize];
    }
}
-(void)showLogInfoVC
{
    self.isShowLogVC=YES;
    if (self.logInfoView) {
        self.logInfoView.hidden=NO;
        [[LogInfoManager shareInstance].logVC startTimer];
    }else
    {
        LogViewController *vc= [[LogViewController alloc]init];
        self.logVC=vc;
        self.logInfoView=vc.view;
        [[UIApplication sharedApplication].keyWindow addSubview:self.logInfoView];
        [[UIApplication sharedApplication].keyWindow bringSubviewToFront:self.logBtn];
    }
    
}
-(void)dismissLogInfoVC
{
    self.isShowLogVC=NO;
    if (self.logInfoView) {
        self.logInfoView.hidden=YES;
        [[LogInfoManager shareInstance].logVC removeTimer];
    }
}

@end
