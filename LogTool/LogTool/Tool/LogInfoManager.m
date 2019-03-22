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
        btn.frame=CGRectMake(300, 20, 40, 40);
        [btn setBackgroundColor:[UIColor blackColor]];
        [[UIApplication sharedApplication].keyWindow addSubview:btn];
        [btn addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];
        UIPanGestureRecognizer *pan=[[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(panBtn:)];
        [btn addGestureRecognizer:pan];
        [LogInfoManager shareInstance].logBtn=btn;
    });
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
