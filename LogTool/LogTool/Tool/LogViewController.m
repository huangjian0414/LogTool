//
//  LogViewController.m
//  LogTool
//
//  Created by huangjian on 2019/3/19.
//  Copyright © 2019年 huangjian. All rights reserved.
//

#import "LogViewController.h"
#import "HJSaveLogTool.h"
#import "LogInfoManager.h"
@interface LogViewController ()<UIDocumentInteractionControllerDelegate>
@property(nonatomic,strong) NSTimer *timer;
@property(nonatomic,strong)UITextView *textView;
@property (nonatomic,strong)UIDocumentInteractionController *documentController;
@property(nonatomic,strong)UIButton *stopLogBtn;
@end
#define defalutColor [UIColor colorWithRed:88/255.0 green:173/255.0 blue:223/255.0 alpha:1]
@implementation LogViewController
-(NSTimer *)timer
{
    if (!_timer) {
        _timer=[NSTimer timerWithTimeInterval:1 target:self selector:@selector(readFile) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop]addTimer:_timer forMode:NSRunLoopCommonModes];
    }
    return _timer;
}
-(void)startTimer
{
    [self.timer setFireDate:[NSDate distantPast]];
}
-(void)removeTimer
{
    if (_timer) {
        [_timer invalidate];
        _timer=nil;
    }
}
-(void)readFile
{
    NSString *string = [HJSaveLogTool readFromLogFile];
    self.textView.text=string;
    if (!self.stopLogBtn.selected) {
        [self.textView scrollRangeToVisible:NSMakeRange(self.textView.text.length, 1)];
    }
    //NSLog(@"跑一跑");
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor whiteColor];
    [self setUpUI];
    [self startTimer];
}
-(void)clickBtn:(UIButton *)btn
{
    switch (btn.tag) {
        case 0:
            [[LogInfoManager shareInstance]dismissLogInfoVC];
            [self removeTimer];
            break;
        case 1:
            btn.selected=!btn.selected;
            if (!btn.selected) {
                [self.textView scrollRangeToVisible:NSMakeRange(self.textView.text.length, 1)];
            }
            break;
        case 2:
            [self share];
            break;
        default:
            break;
    }
}
-(void)share
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *logDirectory = [[paths objectAtIndex:0] stringByAppendingPathComponent:@"Log"];
    NSString *logFilePath = [logDirectory stringByAppendingFormat:@"/%@.txt",@"log"];
    
    self.documentController = [UIDocumentInteractionController interactionControllerWithURL:[NSURL fileURLWithPath:logFilePath]];
    self.documentController.delegate = self;
    self.documentController.UTI = [self getUTI:logFilePath.pathExtension];
    [self.documentController presentOpenInMenuFromRect:CGRectZero
                                                inView:self.view
                                              animated:YES];
}
- (NSString *)getUTI:(NSString *)pathExtension
{
    NSString *typeStr = [self getFileTypeStr:pathExtension];
    
    if ([typeStr isEqualToString:@"PDF"]) {
        return @"com.adobe.pdf";
    }
    if ([typeStr isEqualToString:@"Word"]){
        return @"com.microsoft.word.doc";
    }
    if ([typeStr isEqualToString:@"PowerPoint"]){
        return @"com.microsoft.powerpoint.ppt";
    }
    if ([typeStr isEqualToString:@"Excel"]){
        return @"com.microsoft.excel.xls";
    }
    return @"public.data";
}
#pragma mark - 文件类型
- (NSString *)getFileTypeStr:(NSString *)pathExtension
{
    if ([pathExtension isEqualToString:@"pdf"] || [pathExtension isEqualToString:@"PDF"]) {
        return @"PDF";
    }
    if ([pathExtension isEqualToString:@"doc"] || [pathExtension isEqualToString:@"docx"] || [pathExtension isEqualToString:@"DOC"] || [pathExtension isEqualToString:@"DOCX"]) {
        return @"Word";
    }
    if ([pathExtension isEqualToString:@"ppt"] || [pathExtension isEqualToString:@"PPT"]) {
        return @"PowerPoint";
    }
    if ([pathExtension isEqualToString:@"xls"] || [pathExtension isEqualToString:@"XLS"]) {
        return @"Excel";
    }
    return @"public";
}
-(void)setUpUI
{
    UIButton *hiddenBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    [hiddenBtn setTitle:@"Dismiss" forState:UIControlStateNormal];
    [hiddenBtn setTitleColor:defalutColor forState:UIControlStateNormal];
    hiddenBtn.layer.borderColor=defalutColor.CGColor;
    hiddenBtn.layer.borderWidth=1;
    hiddenBtn.tag=0;
    hiddenBtn.contentEdgeInsets=UIEdgeInsetsMake(0, 5, 0, 5);
    [hiddenBtn addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:hiddenBtn];
    hiddenBtn.translatesAutoresizingMaskIntoConstraints = NO;
    
    
    UIButton *stopBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    [stopBtn setTitle:@"StopScroll" forState:UIControlStateNormal];
    [stopBtn setTitleColor:defalutColor forState:UIControlStateNormal];
    stopBtn.layer.borderColor=defalutColor.CGColor;
    stopBtn.layer.borderWidth=1;
    stopBtn.tag=1;
    stopBtn.contentEdgeInsets=UIEdgeInsetsMake(0, 5, 0, 5);
    [stopBtn addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:stopBtn];
    self.stopLogBtn=stopBtn;
    stopBtn.translatesAutoresizingMaskIntoConstraints = NO;
    
    UIButton *shareBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    [shareBtn setTitle:@"Share" forState:UIControlStateNormal];
    [shareBtn setTitleColor:defalutColor forState:UIControlStateNormal];
    shareBtn.layer.borderColor=defalutColor.CGColor;
    shareBtn.layer.borderWidth=1;
    shareBtn.tag=2;
    shareBtn.contentEdgeInsets=UIEdgeInsetsMake(0, 5, 0, 5);
    [shareBtn addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:shareBtn];
    shareBtn.translatesAutoresizingMaskIntoConstraints = NO;
    
    UITextView *textView=[[UITextView alloc]init];
    textView.editable=NO;
    [self.view addSubview:textView];
    self.textView=textView;
    textView.translatesAutoresizingMaskIntoConstraints = NO;
    
    NSArray *constraints1 =[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-left-[hiddenBtn]-padding-[stopBtn]-padding-[shareBtn]" options:0 metrics:@{@"left" : @(20),@"padding":@(10)} views:NSDictionaryOfVariableBindings(hiddenBtn,stopBtn,shareBtn)];
    NSArray *constraints2 =[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-top-[hiddenBtn]-space-[textView]-space-|" options:0 metrics:@{@"top":@(85),@"space":@(20)} views:NSDictionaryOfVariableBindings(hiddenBtn,textView)];
    NSArray *constraints3 =[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-space-[textView]-space-|" options:0 metrics:@{@"space":@(20)} views:NSDictionaryOfVariableBindings(hiddenBtn,textView)];
    [self.view addConstraints:constraints1];
    [self.view addConstraints:constraints2];
    [self.view addConstraints:constraints3];
    
    NSLayoutConstraint *stopBtnCenterY=[NSLayoutConstraint constraintWithItem:stopBtn attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:hiddenBtn attribute:NSLayoutAttributeCenterY multiplier:1 constant:0];
    [self.view addConstraint:stopBtnCenterY];
    
    NSLayoutConstraint *shareBtnCenterY=[NSLayoutConstraint constraintWithItem:shareBtn attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:stopBtn attribute:NSLayoutAttributeCenterY multiplier:1 constant:0];
    [self.view addConstraint:shareBtnCenterY];
    
    self.view.layer.borderColor=defalutColor.CGColor;
    self.view.layer.borderWidth=3;
}
@end
