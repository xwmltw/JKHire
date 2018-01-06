//
//  JKManageView_JobVasEnd.m
//  JKHire
//
//  Created by yanqb on 2017/4/7.
//  Copyright © 2017年 xianshijian. All rights reserved.
//

#import "JKManageView_JobVasEnd.h"
#import "WDConst.h"
#import "JobModel.h"

@interface JKManageView_JobVasEnd ()

@property (strong, nonatomic) UILabel *labEffect;
@property (strong, nonatomic) UIButton *btnJobVas;

@end

@implementation JKManageView_JobVasEnd

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupViews];
    }
    return self;
}

- (void)setupViews{
    UIView *line = [[UIView alloc] init];
    line.backgroundColor = [UIColor XSJColor_clipLineGray];
    
    UILabel *lab1 = [UILabel labelWithText:@"付费推广" textColor:[UIColor XSJColor_tGrayHistoyTransparent64] fontSize:16.0f];
    
    UIView *line1 = [[UIView alloc] init];
    line1.backgroundColor = [UIColor XSJColor_clipLineGray];
    UIView *viewBot = [[UIView alloc] init];
    
    self.labEffect = [UILabel labelWithText:@"" textColor:[UIColor XSJColor_base] fontSize:14.0f];
    self.labEffect.numberOfLines = 0;
    self.btnJobVas = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.btnJobVas addTarget:self action:@selector(btnOnClick:) forControlEvents:UIControlEventTouchUpInside];
    UIImageView *imgIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"job_icon_push"]];
    [self addSubview:lab1];
    [self addSubview:line1];
    [self addSubview:viewBot];
    [self addSubview:line];
    [viewBot addSubview:self.labEffect];
    [viewBot addSubview:imgIcon];
    [viewBot addSubview:self.btnJobVas];
    
    [lab1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.equalTo(self).offset(16);
    }];
    
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lab1.mas_bottom).offset(16);
        make.left.equalTo(self).offset(16);
        make.width.equalTo(@40);
        make.height.equalTo(@0.7);
    }];
    
    [viewBot mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(line.mas_bottom);
        make.left.right.bottom.equalTo(self);
    }];
    
    [self.labEffect mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(viewBot).offset(16);
        make.centerY.equalTo(viewBot);
    }];
    
    [self.btnJobVas mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(viewBot);
    }];
    
    [imgIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(viewBot);
        make.right.equalTo(viewBot).offset(-16);
    }];
    
    [line1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self);
        make.height.equalTo(@0.7);
    }];
}

- (void)setModel:(JobModel *)model{
    self.labEffect.text = model.job_last_vas_push_str;
}

- (void)btnOnClick:(UIButton *)sender{
    if ([self.delegate respondsToSelector:@selector(JKManageView_JobVasEnd:)]) {
        [self.delegate JKManageView_JobVasEnd:self];
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
