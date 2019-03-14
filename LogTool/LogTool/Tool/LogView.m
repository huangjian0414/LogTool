//
//  LogView.m
//  LogTool
//
//  Created by huangjian on 2019/3/14.
//  Copyright © 2019年 huangjian. All rights reserved.
//

#import "LogView.h"

#define defalutColor [UIColor colorWithRed:88/255.0 green:173/255.0 blue:223/255.0 alpha:1]

@interface LogView ()

@end
@implementation LogView
-(instancetype)init
{
    if (self=[super init]) {
        [self setUpUI];
    }
    return self;
}
-(void)clickBtn:(UIButton *)btn
{
    switch (btn.tag) {
        case 0:
            
            break;
        case 1:
            
            break;
        case 2:
            
            break;
        default:
            break;
    }
}
-(void)setUpUI
{
    UIButton *hiddenBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    [hiddenBtn setTitle:@"DismissView" forState:UIControlStateNormal];
    hiddenBtn.layer.borderColor=defalutColor.CGColor;
    hiddenBtn.layer.borderWidth=1;
    hiddenBtn.tag=0;
    [hiddenBtn addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:hiddenBtn];
    
    hiddenBtn.translatesAutoresizingMaskIntoConstraints = NO;
    [hiddenBtn addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-20-[hiddenBtn(60)]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(hiddenBtn)]];
    [hiddenBtn addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-60-[hiddenBtn(30)]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(hiddenBtn)]];
    
    UIButton *stopBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    [stopBtn setTitle:@"StopScroll" forState:UIControlStateNormal];
    stopBtn.layer.borderColor=defalutColor.CGColor;
    stopBtn.layer.borderWidth=1;
    stopBtn.tag=1;
    [stopBtn addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:stopBtn];
    stopBtn.translatesAutoresizingMaskIntoConstraints = NO;
    
    UIButton *shareBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    [shareBtn setTitle:@"Share" forState:UIControlStateNormal];
    shareBtn.layer.borderColor=defalutColor.CGColor;
    shareBtn.layer.borderWidth=1;
    shareBtn.tag=2;
    [shareBtn addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:shareBtn];
    shareBtn.translatesAutoresizingMaskIntoConstraints = NO;
    
    UITextView *textView=[[UITextView alloc]init];
    textView.editable=NO;
    [self addSubview:textView];
    textView.translatesAutoresizingMaskIntoConstraints = NO;
}

@end
