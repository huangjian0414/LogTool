//
//  LogInfoViewController.m
//  ilopTest
//
//  Created by huangjian on 2018/8/2.
//  Copyright © 2018年 huangjian. All rights reserved.
//

#import "LogInfoViewController.h"
#import "HJSaveLogTool.h"
#import "LogInfoManager.h"
@interface LogInfoViewController ()<UIDocumentInteractionControllerDelegate>
@property (weak, nonatomic) IBOutlet UITextView *logInfoView;
@property (weak, nonatomic) IBOutlet UIButton *stopLogBtn;
@property(nonatomic,strong) NSTimer *timer;

@property (nonatomic,strong)UIDocumentInteractionController *documentController;
@end

@implementation LogInfoViewController
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
- (IBAction)goBack:(UIButton *)sender {
    [[LogInfoManager shareInstance]dismissLogInfoVC];
}
- (IBAction)share:(UIButton *)sender {

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


-(void)readFile
{
    NSString *string = [HJSaveLogTool readFromLogFile];
    self.logInfoView.text=string;
    if (!self.stopLogBtn.selected) {
        [self.logInfoView scrollRangeToVisible:NSMakeRange(self.logInfoView.text.length, 1)];
    }
    NSLog(@"跑一跑");
}
- (IBAction)stopLogScroll:(UIButton *)sender {
    sender.selected=!sender.selected;
    if (!sender.selected) {
        [self.logInfoView scrollRangeToVisible:NSMakeRange(self.logInfoView.text.length, 1)];
    }
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor whiteColor];
    NSString *string = [HJSaveLogTool readFromLogFile];
    self.logInfoView.text=string;
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self startTimer];
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self removeTimer];
}
@end
