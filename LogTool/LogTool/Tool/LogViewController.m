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
@interface LogViewController ()<UIDocumentInteractionControllerDelegate,UITextFieldDelegate>
@property(nonatomic,strong) NSTimer *timer;
@property(nonatomic,strong)UITextView *textView;
@property (nonatomic,strong)UIDocumentInteractionController *documentController;
@property(nonatomic,strong)UIButton *stopLogBtn;

@property(nonatomic,strong)NSMutableArray *rangeArray;

@property(nonatomic,assign)NSInteger currentRange;
@end
#define defalutColor [UIColor colorWithRed:88/255.0 green:173/255.0 blue:223/255.0 alpha:1]
@implementation LogViewController
-(NSTimer *)timer
{
    if (!_timer) {
        _timer=[NSTimer timerWithTimeInterval:1.5 target:self selector:@selector(readFile) userInfo:nil repeats:YES];
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
    NSMutableAttributedString *attr = [[NSMutableAttributedString alloc]initWithString:string];
    if (self.rangeArray.count > 0) {
        NSDictionary *dict = self.rangeArray[self.currentRange];
        NSRange range = NSMakeRange([dict[@"location"]integerValue], [dict[@"length"]integerValue]);
        [attr addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:range];
    }
    self.textView.attributedText = attr;
    if (!self.stopLogBtn.selected) {
        [self.textView scrollRangeToVisible:NSMakeRange(self.textView.attributedText.length-1, 1)];
    }
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor whiteColor];
    [self setUpUI];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.33 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self startTimer];
    });
}
-(void)clickBtn:(UIButton *)btn
{
    [self.view endEditing:YES];
    switch (btn.tag) {
        case 0:
            [[LogInfoManager shareInstance]dismissLogInfoVC];
            [self removeTimer];
            break;
        case 1:
            btn.selected=!btn.selected;
            if (!btn.selected) {
                [self.timer setFireDate:[NSDate date]];
                [self.textView scrollRangeToVisible:NSMakeRange(self.textView.text.length, 1)];
            }else{
                [self.timer setFireDate:[NSDate distantFuture]];
            }
            break;
        case 2:
            [self share];
            break;
        case 3:
            [self remove];
            break;
        default:
            break;
    }
}

    
-(void)remove
{
    [HJSaveLogTool removeLogFile];
    self.rangeArray = [NSMutableArray new];
    self.currentRange = 0;
    self.textView.attributedText = [[NSMutableAttributedString alloc]initWithString:@""];
}

-(void)scrollToTop{
    [self.view endEditing:YES];
    [self.textView scrollRangeToVisible:NSMakeRange(0, 0)];
    if (!self.stopLogBtn.selected) {
        self.stopLogBtn.selected = YES;
        [self.timer setFireDate:[NSDate distantFuture]];
    }
}

-(void)share
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *logDirectory = [[paths objectAtIndex:0] stringByAppendingPathComponent:@"HJLog"];
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
    [hiddenBtn setImage:[LogInfoManager getImageWithName:@"close"] forState:UIControlStateNormal];
    hiddenBtn.tag=0;
    hiddenBtn.contentEdgeInsets = UIEdgeInsetsMake(3, 3, 3, 3);
    [hiddenBtn addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:hiddenBtn];
    hiddenBtn.translatesAutoresizingMaskIntoConstraints = NO;
    
    
    UIButton *stopBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    [stopBtn setImage:[LogInfoManager getImageWithName:@"pause"] forState:UIControlStateNormal];
    [stopBtn setImage:[LogInfoManager getImageWithName:@"play"] forState:UIControlStateSelected];
    stopBtn.tag=1;
    [stopBtn addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:stopBtn];
    self.stopLogBtn=stopBtn;
    stopBtn.translatesAutoresizingMaskIntoConstraints = NO;
    
    UIButton *shareBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    shareBtn.tag=2;
    [shareBtn setImage:[LogInfoManager getImageWithName:@"share"] forState:UIControlStateNormal];
    [shareBtn addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:shareBtn];
    shareBtn.translatesAutoresizingMaskIntoConstraints = NO;
    
    UIButton *removeFileBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    removeFileBtn.tag=3;
    [removeFileBtn setImage:[LogInfoManager getImageWithName:@"delete"] forState:UIControlStateNormal];
    [removeFileBtn addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:removeFileBtn];
    removeFileBtn.translatesAutoresizingMaskIntoConstraints = NO;
    
    UITextView *textView=[[UITextView alloc]init];
    textView.editable=NO;
    [self.view addSubview:textView];
    self.textView=textView;
    textView.translatesAutoresizingMaskIntoConstraints = NO;
    
    NSArray *constraints1 =[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-left-[hiddenBtn(30)]-padding-[stopBtn(30)]-padding-[shareBtn(30)]-padding-[removeFileBtn(30)]" options:0 metrics:@{@"left" : @(20),@"padding":@(10)} views:NSDictionaryOfVariableBindings(hiddenBtn,stopBtn,shareBtn,removeFileBtn)];
    NSArray *constraints11 =[NSLayoutConstraint constraintsWithVisualFormat:@"V:[hiddenBtn(30)][stopBtn(30)][shareBtn(30)][removeFileBtn(30)]" options:0 metrics:@{} views:NSDictionaryOfVariableBindings(hiddenBtn,stopBtn,shareBtn,removeFileBtn)];
    NSArray *constraints2 =[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-top-[hiddenBtn]-space-[textView]-space-|" options:0 metrics:@{@"top":@(85),@"space":@(20)} views:NSDictionaryOfVariableBindings(hiddenBtn,textView)];
    NSArray *constraints3 =[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-space-[textView]-space-|" options:0 metrics:@{@"space":@(20)} views:NSDictionaryOfVariableBindings(hiddenBtn,textView)];
    [self.view addConstraints:constraints1];
    [self.view addConstraints:constraints11];
    [self.view addConstraints:constraints2];
    [self.view addConstraints:constraints3];
    
    NSLayoutConstraint *stopBtnCenterY=[NSLayoutConstraint constraintWithItem:stopBtn attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:hiddenBtn attribute:NSLayoutAttributeCenterY multiplier:1 constant:0];
    [self.view addConstraint:stopBtnCenterY];
    
    NSLayoutConstraint *shareBtnCenterY=[NSLayoutConstraint constraintWithItem:shareBtn attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:stopBtn attribute:NSLayoutAttributeCenterY multiplier:1 constant:0];
    [self.view addConstraint:shareBtnCenterY];
    
    NSLayoutConstraint *removeBtnCenterY=[NSLayoutConstraint constraintWithItem:removeFileBtn attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:shareBtn attribute:NSLayoutAttributeCenterY multiplier:1 constant:0];
    [self.view addConstraint:removeBtnCenterY];
    
    self.view.layer.borderColor=defalutColor.CGColor;
    self.view.layer.borderWidth=3;
    
    
    UITextField *searchTextField = [[UITextField alloc]init];
    searchTextField.delegate = self;
    searchTextField.borderStyle = UITextBorderStyleLine;
    searchTextField.frame = CGRectMake(20, 44, 200, 30);
    searchTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    [self.view addSubview:searchTextField];
    
    //↑ ↓
    UIButton *preBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    [preBtn setImage:[LogInfoManager getImageWithName:@"upload"] forState:UIControlStateNormal];
    preBtn.tag = 4;
    [preBtn addTarget:self action:@selector(goRange:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:preBtn];
    preBtn.frame = CGRectMake(230, 44, 26, 26);
    
    UIButton *nextBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    [nextBtn setImage:[LogInfoManager getImageWithName:@"download"] forState:UIControlStateNormal];
    nextBtn.tag = 5;
    [nextBtn addTarget:self action:@selector(goRange:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:nextBtn];
    nextBtn.frame = CGRectMake(265, 44, 26, 24);
    
    UIButton *topBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    [topBtn setImage:[LogInfoManager getImageWithName:@"top"] forState:UIControlStateNormal];
    [topBtn addTarget:self action:@selector(scrollToTop) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:topBtn];
    topBtn.frame = CGRectMake(305, 42, 30, 30);
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.view endEditing:YES];
    return YES;
}

-(void)textFieldDidEndEditing:(UITextField *)textField
{
    [self.rangeArray removeAllObjects];
    self.currentRange = 0;
    if (textField.text.length == 0) {
        NSMutableAttributedString *attr = [[NSMutableAttributedString alloc]initWithAttributedString:self.textView.attributedText];
        [attr addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(0, self.textView.attributedText.length)];
        self.textView.attributedText = attr;
        return;
    }
    
    NSString *str = self.textView.text;
    NSRegularExpression *regularExpression = [NSRegularExpression regularExpressionWithPattern:textField.text options:0 error:nil];
    [regularExpression enumerateMatchesInString:str options:0 range:NSMakeRange(0, str.length) usingBlock:^(NSTextCheckingResult * _Nullable result, NSMatchingFlags flags, BOOL * _Nonnull stop) {
        NSRange ran = result.range;
        [self.rangeArray addObject:@{@"location":@(ran.location),@"length":@(ran.length)}];
    }];
    if (self.rangeArray.count > 0) {
        [self setRangeContent:0];
    }
    if (!self.stopLogBtn.selected) {
        self.stopLogBtn.selected = YES;
    }
}
//MARK: - 滚动到range逻辑
-(void)goRange:(UIButton *)btn{
    if (self.rangeArray.count == 0) {
        return;
    }
    [self.view endEditing:YES];
    if (btn.tag == 4) {
        if (self.currentRange <= 0) {
            self.currentRange = self.rangeArray.count - 1;
        }else{
            self.currentRange --;
        }
    }else{
        if (self.currentRange >= self.rangeArray.count - 1) {
            self.currentRange = 0;
        }else{
            self.currentRange ++;
        }
    }
    [self setRangeContent:self.currentRange];
    
}
//MARK: - 设置range富文本
-(void)setRangeContent:(NSInteger)currentRange{
    NSDictionary *dict = self.rangeArray[currentRange];
    NSRange range = NSMakeRange([dict[@"location"]integerValue], [dict[@"length"]integerValue]);
    [self.textView scrollRangeToVisible:range];
    NSMutableAttributedString *attr = [[NSMutableAttributedString alloc]initWithString:self.textView.text];
    [attr addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:range];
    self.textView.attributedText = attr;
    
}

-(NSMutableArray *)rangeArray
{
    if (!_rangeArray) {
        _rangeArray = [NSMutableArray array];
    }
    return _rangeArray;
}
@end
