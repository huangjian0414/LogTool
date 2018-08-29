//
//  AppDelegate.m
//  LogTool
//
//  Created by huangjian on 2018/8/28.
//  Copyright © 2018年 huangjian. All rights reserved.
//

#import "AppDelegate.h"
#import "LogInfoManager.h"
#import "HJSaveLogTool.h"
@interface AppDelegate ()
{
    UIPushBehavior *_push;
    CGPoint _firstPoint;
    CGPoint _currentPoint;
}
@property (nonatomic,weak)UIButton *btn;
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [HJSaveLogTool removeLogFile];
    [HJSaveLogTool redirectNSLogToDocumentFolder];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        UIButton *btn=[UIButton buttonWithType:UIButtonTypeCustom];
        [btn setTitle:@"Log" forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        btn.titleLabel.font=[UIFont systemFontOfSize:14];
        btn.frame=CGRectMake(300, 20, 40, 40);
        [btn setBackgroundColor:[UIColor blackColor]];
        [btn addTarget:self action:@selector(clickLogBtn:) forControlEvents:UIControlEventTouchUpInside];
        [self.window addSubview:btn];
        UIPanGestureRecognizer *pan=[[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(panBtn:)];
        [btn addGestureRecognizer:pan];
        self.btn=btn;
        [LogInfoManager shareInstance].logBtn=btn;
    });
    return YES;
}
-(void)clickLogBtn:(UIButton *)btn
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
    CGPoint point= [ges locationInView:self.window];
    if (point.y<40) {
        point.y=40;
    }
    self.btn.center=point;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
