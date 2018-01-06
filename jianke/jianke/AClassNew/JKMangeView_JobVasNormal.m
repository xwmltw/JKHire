//
//  JKMangeView_JobVasNormal.m
//  JKHire
//
//  Created by yanqb on 2017/4/7.
//  Copyright © 2017年 xianshijian. All rights reserved.
//

#import "JKMangeView_JobVasNormal.h"
#import "WDConst.h"
#import "BaseButton.h"

@interface JKMangeView_JobVasNormal ()

@property (weak, nonatomic) UIButton *btnJobVas;
@property (weak, nonatomic) UIButton *btnRefresh;
@property (weak, nonatomic) UIButton *btnStick;
@property (weak, nonatomic) UIButton *btnPush;

@end

@implementation JKMangeView_JobVasNormal

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupViews];
    }
    return self;
}

- (void)setupViews{
    
    
//    self.btnJobVas.tag = BtnOnClickActionType_jobVas;
//    self.btnRefresh.tag = BtnOnClickActionType_refreshJob;
//    self.btnStick.tag = BtnOnClickActionType_stickJob;
//    self.btnPush.tag = BtnOnClickActionType_pushJob;
//    

//    [self.btnRefresh addTarget:self action:@selector(btnOnClick:) forControlEvents:UIControlEventTouchUpInside];
//    [self.btnStick addTarget:self action:@selector(btnOnClick:) forControlEvents:UIControlEventTouchUpInside];
//    [self.btnPush addTarget:self action:@selector(btnOnClick:) forControlEvents:UIControlEventTouchUpInside];
    UIView *line = [[UIView alloc] init];
    line.backgroundColor = [UIColor XSJColor_clipLineGray];
    
    UILabel *lab1 = [UILabel labelWithText:@"付费推广" textColor:[UIColor XSJColor_tGrayHistoyTransparent64] fontSize:16.0f];
    
    BaseButton *button = [BaseButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:@"曝光量提升2-5倍" forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:@"job_icon_push"] forState:UIControlStateNormal];
    [button.titleLabel setFont:[UIFont systemFontOfSize:13.0f]];
    [button setTitleColor:[UIColor XSJColor_base] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(btnOnClick:) forControlEvents:UIControlEventTouchUpInside];
    [button setMarginForImg:-16 marginForTitle:0];
    button.tag = BtnOnClickActionType_jobVas;
    _btnJobVas = button;
    
    UIView *viewLeft = [[UIView alloc] init];
    UIView *viewMiddle = [[UIView alloc] init];
    UIView *viewRight = [[UIView alloc] init];
    
    UIButton *btnLeft = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnLeft addTarget:self action:@selector(btnOnClick:) forControlEvents:UIControlEventTouchUpInside];
    btnLeft.tag = BtnOnClickActionType_refreshJob;
    _btnRefresh = btnLeft;
    
    UIImageView *imgViewLeft = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"v320_refresh_job_icon"]];
    UILabel *labLeft = [UILabel labelWithText:@"刷新岗位" textColor:[UIColor XSJColor_tGrayDeepTransparent48] fontSize:14.0f];
    
    UIButton *btnMiddle = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnMiddle addTarget:self action:@selector(btnOnClick:) forControlEvents:UIControlEventTouchUpInside];
    btnMiddle.tag = BtnOnClickActionType_stickJob;
    _btnStick = btnLeft;
    
    UIImageView *imgViewMiddle = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"v320_stick_job_icon"]];
    UILabel *labMiddle = [UILabel labelWithText:@"置顶岗位" textColor:[UIColor XSJColor_tGrayDeepTransparent48] fontSize:14.0f];
    
    UIButton *btnRight = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnRight addTarget:self action:@selector(btnOnClick:) forControlEvents:UIControlEventTouchUpInside];
    btnRight.tag = BtnOnClickActionType_pushJob;
    _btnPush = btnRight;
    
    UIImageView *imgViewRight = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"v320_push_job_icon"]];
    UILabel *labRight = [UILabel labelWithText:@"推送推广" textColor:[UIColor XSJColor_tGrayDeepTransparent48] fontSize:14.0f];
    
    [viewLeft addSubview:imgViewLeft];
    [viewLeft addSubview:labLeft];
    [viewLeft addSubview:btnLeft];
    [viewMiddle addSubview:imgViewMiddle];
    [viewMiddle addSubview:labMiddle];
    [viewMiddle addSubview:btnMiddle];
    [viewRight addSubview:imgViewRight];
    [viewRight addSubview:labRight];
    [viewRight addSubview:btnRight];
    
    [self addSubview:lab1];
    [self addSubview:button];
    [self addSubview:viewLeft];
    [self addSubview:viewMiddle];
    [self addSubview:viewRight];
    [self addSubview:line];
    
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self);
        make.height.equalTo(@0.7);
    }];
    
    [lab1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.equalTo(self).offset(16);
        make.height.equalTo(@30);
    }];
    
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(lab1);
        make.right.equalTo(self);
        make.width.equalTo(@140);
        make.height.equalTo(@30);
    }];
    
    [viewLeft mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lab1.mas_bottom).offset(24);
        make.left.equalTo(self);
        make.width.equalTo(viewMiddle);
        make.bottom.equalTo(self);
    }];
    
    [viewMiddle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.height.equalTo(viewLeft);
        make.left.equalTo(viewLeft.mas_right);
        make.width.equalTo(viewRight);
    }];
    
    [viewRight mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.height.equalTo(viewLeft);
        make.left.equalTo(viewMiddle.mas_right);
        make.right.equalTo(self);
    }];
    
    [labLeft mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(viewLeft);
        make.bottom.equalTo(viewLeft).offset(-16);
    }];
    
    [imgViewLeft mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(labLeft.mas_top).offset(-4);
        make.centerX.equalTo(viewLeft);
    }];
    
    [labMiddle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(viewMiddle);
        make.bottom.equalTo(viewMiddle).offset(-16);
    }];
    
    [imgViewMiddle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(labMiddle.mas_top).offset(-4);
        make.centerX.equalTo(viewMiddle);
    }];
    
    [labRight mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(viewRight);
        make.bottom.equalTo(viewRight).offset(-16);
    }];
    
    [imgViewRight mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(labRight.mas_top).offset(-4);
        make.centerX.equalTo(viewRight);
    }];
    
    [btnLeft mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.right.equalTo(viewLeft);
    }];
    
    [btnMiddle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.right.equalTo(viewMiddle);
    }];
    
    [btnRight mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.right.equalTo(viewRight);
    }];
}

- (void)btnOnClick:(UIButton *)sender{
    if ([self.delegate respondsToSelector:@selector(JKMangeView_JobVasNormal:actionType:)]) {
        [self.delegate JKMangeView_JobVasNormal:self actionType:sender.tag];
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
