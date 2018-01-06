//
//  ManualAlertView.m
//  JKHire
//
//  Created by yanqb on 16/11/9.
//  Copyright © 2016年 xianshijian. All rights reserved.
//

#import "ManualAlertView.h"
#import "WDConst.h"

@interface ManualAlertView ()

@property (nonatomic,weak)UIView *alertView;
@property (nonatomic,weak) UILabel *titleLab;

@property (nonatomic,weak) UITextField *utf;

@end

@implementation ManualAlertView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = MKCOLOR_RGBA(0, 0, 0, 0.1);
        [self setupViews];
    }
    return self;
}

- (void)setupViews{
    UIView *view = [[UIView alloc] init];
    [view setCornerValue:10.0f];
    _alertView = view;
    [self addSubview:view];
    
    UILabel *label = [[UILabel alloc] init];
    _rightLabel = label;
    [self addSubview:label];
    
    UITextField *utf = [[UITextField alloc] init];
    
    
    UIButton *button1 = [UIButton buttonWithType:UIButtonTypeCustom];
    [button1 setTitle:@"取消" forState:UIControlStateNormal];
    button1.tag = 0;
    [button1 addTarget:self action:@selector(btnOnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *button2 = [UIButton buttonWithType:UIButtonTypeCustom];
    button2.tag = 1;
    [button2 setTitle:@"确定" forState:UIControlStateNormal];
    [button2 addTarget:self action:@selector(btnOnClick:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)btnOnClick:(UIButton *)sender{
    if ([self.delegate respondsToSelector:@selector(ManualAlertView:clickedButtonAtIndex:)]) {
        [self.delegate ManualAlertView:self clickedButtonAtIndex:sender.tag];
    }
}

- (void)setMessage:(NSString *)message{
    _message = message;
    self.titleLab.text = message;
}

- (void)setRightMessage:(NSString *)rightMessage{
    _rightMessage = rightMessage;
    self.rightLabel.text = rightMessage;
}

@end
