//
//  JobMsgHeaderView.m
//  JKHire
//
//  Created by yanqb on 2017/1/10.
//  Copyright © 2017年 xianshijian. All rights reserved.
//

#import "JobMsgHeaderView.h"
#import "ImgTextButton.h"
#import "WDConst.h"
#import "ToolBarItem.h"
#import "BaseButton.h"

@interface JobMsgHeaderView ()

@property (nonatomic, strong) UIView *topContainView;
@property (nonatomic, strong) UIView *bottomContainView;
//@property (nonatomic, strong) UIView *VipContainView;   //直通车 banner
@property (nonatomic, weak) BaseButton *vipBtn;

@property (nonatomic, weak) ImgTextButton *btn1;
@property (nonatomic, weak) ImgTextButton *btn2;
@property (nonatomic, weak) ImgTextButton *btn3;
@property (nonatomic, weak) UIButton *btn4;
@property (nonatomic, weak) UIButton *btn5;
@property (nonatomic, weak) UIButton *btn6;

@property (nonatomic, strong) UIView *line;
@property (nonatomic, weak) UIView *redPointView;

@end

@implementation JobMsgHeaderView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupViews];
    }
    return self;
}

- (void)setupViews{

    self.line = [[UIView alloc] init];
    self.line.backgroundColor = [UIColor XSJColor_tGrayDeepTinge];
    
    ImgTextButton *btn1 = [ImgTextButton buttonWithType:UIButtonTypeCustom];
    [btn1 setImage:[UIImage imageNamed:@"job_msg_insurance"] forState:UIControlStateNormal];
    [btn1 setTitle:@"兼职保险" forState:UIControlStateNormal];
    btn1.titleLabel.font = [UIFont systemFontOfSize:13.0f];
    [btn1 addTarget:self action:@selector(topBtnOnClick:) forControlEvents:UIControlEventTouchUpInside];
    btn1.tag = BtnOnClickActionType_insurance;
    _btn1 = btn1;
    
    ImgTextButton *btn2 = [ImgTextButton buttonWithType:UIButtonTypeCustom];
    [btn2 setImage:[UIImage imageNamed:@"job_msg_post"] forState:UIControlStateNormal];
    [btn2 setTitle:@"发布兼职" forState:UIControlStateNormal];
    btn2.titleLabel.font = [UIFont systemFontOfSize:13.0f];
    [btn2 addTarget:self action:@selector(topBtnOnClick:) forControlEvents:UIControlEventTouchUpInside];
    btn2.tag = BtnOnClickActionType_postJob;
    _btn2 = btn2;
    
    ImgTextButton *btn3 = [ImgTextButton buttonWithType:UIButtonTypeCustom];
    [btn3 setImage:[UIImage imageNamed:@"job_msg_salary1"] forState:UIControlStateNormal];
    [btn3 setTitle:@"招人神器" forState:UIControlStateNormal];
    btn3.titleLabel.font = [UIFont systemFontOfSize:13.0f];
    [btn3 addTarget:self action:@selector(topBtnOnClick:) forControlEvents:UIControlEventTouchUpInside];
    btn3.tag = BtnOnClickActionType_hireTool;
    _btn3 = btn3;
    
    UIButton *btn4 = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn4 setTitle:@"待审核" forState:UIControlStateNormal];
    btn4.titleLabel.font = [UIFont boldSystemFontOfSize:13.0f];
    [btn4 setTitleColor:[UIColor XSJColor_tGrayDeepTransparent2] forState:UIControlStateNormal];
    [btn4 setTitleColor:[UIColor XSJColor_tGrayDeepTinge] forState:UIControlStateSelected];
    [btn4 addTarget:self action:@selector(btnOnClick:) forControlEvents:UIControlEventTouchUpInside];
    btn4.tag = BtnOnClickActionType_waitToPass;
    _btn4 = btn4;
    
    UIButton *btn5 = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn5 setTitle:@"招聘中" forState:UIControlStateNormal];
    btn5.titleLabel.font = [UIFont boldSystemFontOfSize:13.0f];
    [btn5 setTitleColor:[UIColor XSJColor_tGrayDeepTransparent2] forState:UIControlStateNormal];
    [btn5 setTitleColor:[UIColor XSJColor_tGrayDeepTinge] forState:UIControlStateSelected];
    [btn5 addTarget:self action:@selector(btnOnClick:) forControlEvents:UIControlEventTouchUpInside];
    btn5.tag = BtnOnClickActionType_hire;
    btn5.selected = YES;
    _btn5 = btn5;
    
    UIButton *btn6 = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn6 setTitle:@"已结束" forState:UIControlStateNormal];
    btn6.titleLabel.font = [UIFont boldSystemFontOfSize:13.0f];
    [btn6 setTitleColor:[UIColor XSJColor_tGrayDeepTransparent2] forState:UIControlStateNormal];
    [btn6 setTitleColor:[UIColor XSJColor_tGrayDeepTinge] forState:UIControlStateSelected];
    [btn6 addTarget:self action:@selector(btnOnClick:) forControlEvents:UIControlEventTouchUpInside];
    btn6.tag = BtnOnClickActionType_HireOff;
    _btn6 = btn6;
    
    [self.topContainView addSubview:btn1];
    [self.topContainView addSubview:btn2];
    [self.topContainView addSubview:btn3];
    
    [self.bottomContainView addSubview:btn4];
    [self.bottomContainView addSubview:btn5];
    [self.bottomContainView addSubview:btn6];
    [self.bottomContainView addSubview:self.line];
    
    if (![[UserData sharedInstance] isHasOpenYetWithPostJob]) {
        btn2.budgeView.hidden = NO;
    }
    
    [self.topContainView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self);
        make.height.equalTo(@107);
    }];
    
    [self.bottomContainView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.topContainView.mas_bottom);
        make.left.right.equalTo(self);
        make.height.equalTo(@42);
    }];
    
    [btn1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.equalTo(self.topContainView);
        make.right.equalTo(btn2.mas_left);
        make.width.equalTo(btn2);
    }];
    
    [btn2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(self.topContainView);
        make.left.equalTo(btn1.mas_right);
        make.right.equalTo(btn3.mas_left);
        make.width.equalTo(btn3);
    }];
    
    [btn3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.right.equalTo(self.topContainView);
        make.left.equalTo(btn2.mas_right);
        make.width.equalTo(btn2);
    }];
    
    [btn4 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.equalTo(self.bottomContainView);
        make.right.equalTo(btn5.mas_left);
        make.width.equalTo(btn5);
    }];
    
    [btn5 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(self.bottomContainView);
        make.right.equalTo(btn6.mas_left);
        make.left.right.equalTo(btn5.mas_right);
    }];
    
    [btn6 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.right.equalTo(self.bottomContainView);
        make.left.equalTo(btn5.mas_right);
        make.width.equalTo(btn5);
    }];
    
    [self.line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(btn5);
        make.bottom.equalTo(self.bottomContainView);
        make.width.equalTo(@(SCREEN_WIDTH / 3 - 20));
        make.height.equalTo(@0.7);
    }];
}

- (void)topBtnOnClick:(ImgTextButton *)sender{
    if ([self.delegate respondsToSelector:@selector(jobMsgHeaderView:actionType:)]) {
        [self.delegate jobMsgHeaderView:self actionType:sender.tag];
    }
}

- (void)btnOnClick:(UIButton *)sender{
    [self setOffsetOfLineWithBtn:sender];
    [self setBtnsSelect:sender];
    if ([self.delegate respondsToSelector:@selector(jobMsgHeaderView:actionType:)]) {
        [self.delegate jobMsgHeaderView:self actionType:sender.tag];
    }
}

- (void)setBtnsSelect:(UIButton *)sender{
    sender.selected = YES;
    NSArray *subViews = self.bottomContainView.subviews;
    for (UIView *view in subViews) {
        if ([view isKindOfClass:[UIButton class]]) {
            UIButton *button = (UIButton *)view;
            [button setSelected:NO];
            if (view == sender) {
                [button setSelected:YES];
            }
        }
    }
}

- (void)setOffsetOfLineWithBtn:(UIButton *)btn{
    [self.line mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(btn);
        make.bottom.equalTo(self.bottomContainView);
        make.width.equalTo(@(SCREEN_WIDTH / 3 - 20));
        make.height.equalTo(@0.7);
    }];
}

- (void)updateBtnStatusAtIndex:(NSInteger)index{
    switch (index) {
        case 0:{
            [self setBtnsSelect:self.btn4];
            [self setOffsetOfLineWithBtn:self.btn4];
        }
            break;
        case 1:{
            [self setBtnsSelect:self.btn5];
            [self setOffsetOfLineWithBtn:self.btn5];
        }
            break;
        case 2:{
            [self setBtnsSelect:self.btn6];
            [self setOffsetOfLineWithBtn:self.btn6];
        }
            break;
        default:
            break;
    }
}

- (void)reload{
    if (![[UserData sharedInstance] isHasOpenYetWithPostJob]) {
        [[UserData sharedInstance] setHasOpenYetWithPostJob];
        self.btn2.budgeView.hidden = YES;
    }
}

- (void)setModel:(RecruitJobNumInfo *)model{
//    if ([[UserData sharedInstance] isEnableVipService] && [[UserData sharedInstance] isLogin]) {
//        self.VipContainView.hidden = NO;
        EPModel *epModel = [[UserData sharedInstance] getEpModelFromHave];
        CityModel *cityModel = [UserData sharedInstance].city;
        
        NSString *titleOfBtn = @" ";
        if (epModel.true_name.length) {
            titleOfBtn = [NSString stringWithFormat:@"  您好，%@！您在%@的在招岗位发布情况：%ld/%ld    ", epModel.true_name, cityModel.name, model.userd_recruit_job_num.integerValue, model.all_recruit_job_num.integerValue];
        }else{
            titleOfBtn = [NSString stringWithFormat:@"  您好，您在%@的在招岗位发布情况：%ld/%ld    ", cityModel.name, model.userd_recruit_job_num.integerValue, model.all_recruit_job_num.integerValue];
        }
        [self.vipBtn setTitle:titleOfBtn forState:UIControlStateNormal];
//    }
}

//- (void)resetVipContainView{
//    if (_VipContainView) {
//        [_VipContainView removeFromSuperview];
//        _VipContainView = nil;
//        [self.bottomContainView mas_remakeConstraints:^(MASConstraintMaker *make) {
//            make.top.equalTo(self.topContainView.mas_bottom);
//            make.left.right.equalTo(self);
//            make.height.equalTo(@42);
//        }];
//    }
//}

//- (UIView *)VipContainView{
//    if (!_VipContainView) {
//        _VipContainView = [[UIView alloc] init];
//        
//        BaseButton *btn = [BaseButton buttonWithType:UIButtonTypeCustom];
//        btn.titleLabel.font = [UIFont systemFontOfSize:14.0f];
//        [btn setTitle:@" " forState:UIControlStateNormal];
//        [btn setMarginForImg:-12 marginForTitle:0];
//        [btn setImage:[UIImage imageNamed:@"job_push_icon_blue"] forState:UIControlStateNormal];
//        [btn setImage:[UIImage imageNamed:@"job_push_icon_blue"] forState:UIControlStateHighlighted];
//        [btn setTitleColor:[UIColor XSJColor_base] forState:UIControlStateNormal];
//        [btn setBackgroundColor:MKCOLOR_RGBA(0, 187, 211, 0.03)];
//        [btn addTarget:self action:@selector(topBtnOnClick:) forControlEvents:UIControlEventTouchUpInside];
//        btn.tag = BtnOnClickActionType_Vip;
//        _vipBtn = btn;
//        
//        [self addSubview:_VipContainView];
//        [_VipContainView addSubview:btn];
//        
//        [_VipContainView mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.top.equalTo(self.topContainView.mas_bottom);
//            make.left.right.equalTo(self);
//            make.height.equalTo(@52);
//        }];
//        
//        [self.bottomContainView mas_remakeConstraints:^(MASConstraintMaker *make) {
//            make.top.equalTo(_VipContainView.mas_bottom);
//            make.left.right.equalTo(self);
//            make.height.equalTo(@42);
//        }];
//        
//        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.edges.equalTo(_VipContainView);
//        }];
//        
//        [btn addBorderInDirection:BorderDirectionTypeBottom borderWidth:0.7 borderColor:[UIColor XSJColor_base] isConstraint:YES];
//    }
//    return _VipContainView;
//}

- (UIView *)topContainView{
    if (!_topContainView) {
        _topContainView = [[UIView alloc] init];
        _topContainView.backgroundColor = [UIColor XSJColor_blackBase];
        [self addSubview:_topContainView];
    }
    return _topContainView;
}

- (UIView *)bottomContainView{
    if (!_bottomContainView) {
        _bottomContainView = [[UIView alloc] init];
        _bottomContainView.backgroundColor = [UIColor XSJColor_newWhite];
        [self addSubview:_bottomContainView];
    }
    return _bottomContainView;
}

@end
