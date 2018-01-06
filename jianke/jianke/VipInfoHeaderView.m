//
//  VipInfoHeaderView.m
//  JKHire
//
//  Created by yanqb on 2017/5/11.
//  Copyright © 2017年 xianshijian. All rights reserved.
//

#import "VipInfoHeaderView.h"
#import "WDConst.h"
#import "ResponseInfo.h"

@interface VipInfoHeaderView ()

@property (nonatomic, strong) UILabel *labEpName;
@property (nonatomic, strong) UIImageView *imgIcon;

@property (nonatomic, strong) UILabel *labRefresh;
@property (nonatomic, strong) UILabel *labStick;
@property (nonatomic, strong) UILabel *labPush;
@property (nonatomic, strong) UILabel *labLeftRefresh;
@property (nonatomic, strong) UILabel *labLeftStick;
@property (nonatomic, strong) UILabel *labLeftPush;
@property (nonatomic, strong) UILabel *labDeadRefresh;
@property (nonatomic, strong) UILabel *labDeadStick;
@property (nonatomic, strong) UILabel *labDeadPush;

@end

@implementation VipInfoHeaderView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupViews];
    }
    return self;
}

- (void)setupViews{
    self.backgroundColor = [UIColor XSJColor_newGray];
    
    UIView *viewTopContain = [[UIView alloc] init];
    UIView *viewContain1 = [[UIView alloc] init];
    viewContain1.backgroundColor = [UIColor whiteColor];
    UIView *viewContain2 = [[UIView alloc] init];
    viewContain2.backgroundColor = [UIColor whiteColor];
    UIView *viewContain3 = [[UIView alloc] init];
    viewContain3.backgroundColor = [UIColor whiteColor];
    UIView *viewBotContain = [[UIView alloc] init];
    
    self.labEpName = [[UILabel alloc] init];
    self.labEpName.font = [UIFont systemFontOfSize:14.0f];
    self.labEpName.textColor = [UIColor XSJColor_tGrayDeepTinge];
    
    self.imgIcon = [[UIImageView alloc] init];
    
    UIView *line1 = [[UIView alloc] init];
    line1.backgroundColor = [UIColor XSJColor_clipLineGray];
    
    UILabel *lab4 = [UILabel labelWithText:@"VIP全国通用特权" textColor:[UIColor XSJColor_base] fontSize:14.0f];
    UILabel *lab5 = [UILabel labelWithText:@"全国都可使用，开通多个VIP城市，数量累加" textColor:[UIColor XSJColor_tGrayDeepTransparent3] fontSize:12.0f];
    lab5.numberOfLines = 0;
    
    UILabel *lab6 = [UILabel labelWithText:@"VIP服务城市特权" textColor:[UIColor XSJColor_base] fontSize:14.0f];
    UILabel *lab7 = [UILabel labelWithText:@"以下特权仅在VIP服务城市使用" textColor:[UIColor XSJColor_tGrayDeepTransparent3] fontSize:12.0f];
    lab7.numberOfLines = 0;
    
    self.labRefresh = [[UILabel alloc] init];
    self.labRefresh.textAlignment = NSTextAlignmentCenter;
    self.labRefresh.font = [UIFont systemFontOfSize:16.0f];
    self.labRefresh.textColor = [UIColor XSJColor_tGrayDeepTinge];
    
    self.labStick = [[UILabel alloc] init];
    self.labStick.textAlignment = NSTextAlignmentCenter;
    self.labStick.font = [UIFont systemFontOfSize:16.0f];
    self.labStick.textColor = [UIColor XSJColor_tGrayDeepTinge];
    
    self.labPush = [[UILabel alloc] init];
    self.labPush.textAlignment = NSTextAlignmentCenter;
    self.labPush.font = [UIFont systemFontOfSize:16.0f];
    self.labPush.textColor = [UIColor XSJColor_tGrayDeepTinge];
    
    self.labLeftRefresh = [[UILabel alloc] init];
    self.labLeftRefresh.textAlignment = NSTextAlignmentCenter;
    self.labLeftRefresh.font = [UIFont systemFontOfSize:24.0f];
    self.labLeftRefresh.textColor = [UIColor XSJColor_base];
    
    self.labLeftStick = [[UILabel alloc] init];
    self.labLeftStick.textAlignment = NSTextAlignmentCenter;
    self.labLeftStick.font = [UIFont systemFontOfSize:24.0f];
    self.labLeftStick.textColor = [UIColor XSJColor_base];
    
    self.labLeftPush = [[UILabel alloc] init];
    self.labLeftPush.textAlignment = NSTextAlignmentCenter;
    self.labLeftPush.font = [UIFont systemFontOfSize:24.0f];
    self.labLeftPush.textColor = [UIColor XSJColor_base];

    UILabel *lab1 = [[UILabel alloc] init];
    lab1.text = @"剩余刷新次数";
    lab1.font = [UIFont systemFontOfSize:12.0f];
    lab1.textColor = [UIColor XSJColor_tGrayDeepTransparent32];
    
    UILabel *lab2 = [[UILabel alloc] init];
    lab2.text = @"剩余置顶天数";
    lab2.font = [UIFont systemFontOfSize:12.0f];
    lab2.textColor = [UIColor XSJColor_tGrayDeepTransparent32];
    
    UILabel *lab3 = [[UILabel alloc] init];
    lab3.text = @"剩余推送人数";
    lab3.font = [UIFont systemFontOfSize:12.0f];
    lab3.textColor = [UIColor XSJColor_tGrayDeepTransparent32];

    self.labDeadRefresh = [[UILabel alloc] init];
    self.labDeadRefresh.textAlignment = NSTextAlignmentCenter;
    self.labDeadRefresh.numberOfLines = 0;
    self.labDeadRefresh.font = [UIFont systemFontOfSize:12.0f];
    self.labDeadRefresh.textColor = [UIColor XSJColor_middelRed];
    
    self.labDeadStick = [[UILabel alloc] init];
    self.labDeadStick.textAlignment = NSTextAlignmentCenter;
    self.labDeadStick.numberOfLines = 0;
    self.labDeadStick.font = [UIFont systemFontOfSize:12.0f];
    self.labDeadStick.textColor = [UIColor XSJColor_middelRed];
    
    self.labDeadPush = [[UILabel alloc] init];
    self.labDeadPush.textAlignment = NSTextAlignmentCenter;
    self.labDeadPush.numberOfLines = 0;
    self.labDeadPush.font = [UIFont systemFontOfSize:12.0f];
    self.labDeadPush.textColor = [UIColor XSJColor_middelRed];

    [self addSubview:viewContain1];
    [self addSubview:viewContain2];
    [self addSubview:viewContain3];
    [self addSubview:viewTopContain];
    [self addSubview:viewBotContain];
    
    [viewTopContain addSubview:self.labEpName];
    [viewTopContain addSubview:self.imgIcon];
    [viewTopContain addSubview:lab4];
    [viewTopContain addSubview:lab5];
    [viewTopContain addSubview:line1];
    
    [viewBotContain addSubview:lab6];
    [viewBotContain addSubview:lab7];
    
    [viewContain1 addSubview:self.labRefresh];
    [viewContain1 addSubview:self.labLeftRefresh];
    [viewContain1 addSubview:lab1];
    [viewContain1 addSubview:self.labDeadRefresh];
    
    [viewContain2 addSubview:self.labStick];
    [viewContain2 addSubview:self.labLeftStick];
    [viewContain2 addSubview:lab2];
    [viewContain2 addSubview:self.labDeadStick];
    
    [viewContain3 addSubview:self.labPush];
    [viewContain3 addSubview:self.labLeftPush];
    [viewContain3 addSubview:lab3];
    [viewContain3 addSubview:self.labDeadPush];
    
    [viewTopContain mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self);
        make.height.equalTo(@125);
    }];
    
    [self.labEpName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(viewTopContain).offset(16);
        make.right.lessThanOrEqualTo(viewTopContain).offset(-28);
        make.height.equalTo(@20);
    }];
    [self.imgIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.labEpName.mas_right).offset(4);
        make.centerY.equalTo(self.labEpName);
        make.width.height.equalTo(@20);
    }];
    [line1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.labEpName.mas_bottom).offset(16);
        make.left.right.equalTo(viewTopContain);
        make.height.equalTo(@0.7);
    }];
    [lab4 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(line1.mas_bottom).offset(16);
        make.left.equalTo(self.labEpName);
    }];
    [lab5 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lab4.mas_bottom).offset(4);
        make.left.equalTo(self.labEpName);
    }];
    
    [viewBotContain mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(viewContain1.mas_bottom);
        make.left.right.bottom.equalTo(self);
    }];
    [lab6 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(viewBotContain).offset(16);
        make.bottom.equalTo(lab7.mas_top).offset(-4);
    }];
    [lab7 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(lab6);
        make.bottom.equalTo(viewBotContain).offset(-8);
    }];
    
    [viewContain1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(viewTopContain.mas_bottom);
        make.left.equalTo(self).offset(8);
        make.width.equalTo(viewContain2);
        make.height.equalTo(@175);
    }];
    
    [viewContain2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(viewTopContain.mas_bottom);
        make.left.equalTo(viewContain1.mas_right).offset(0.7);
        make.width.equalTo(viewContain3);
        make.height.equalTo(viewContain1);
    }];
    
    [viewContain3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(viewTopContain.mas_bottom);
        make.left.equalTo(viewContain2.mas_right).offset(0.7);
        make.right.equalTo(self).offset(-8);
        make.height.equalTo(viewContain1);
    }];
    
    [self.labRefresh mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(viewContain1);
        make.height.equalTo(@55);
    }];
    
    [self.labLeftRefresh mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.labRefresh.mas_bottom).offset(16);
        make.left.right.equalTo(viewContain1);
    }];
    
    [lab1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.labLeftRefresh.mas_bottom);
        make.centerX.equalTo(viewContain1);
    }];
    
    [self.labDeadRefresh mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lab1.mas_bottom).offset(8);
        make.left.right.equalTo(viewContain1);
    }];
    
    [self.labStick mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(viewContain2);
        make.height.equalTo(@55);
    }];
    
    [self.labLeftStick mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.labStick.mas_bottom).offset(16);
        make.left.right.equalTo(viewContain2);
    }];
    
    [lab2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.labLeftStick.mas_bottom);
        make.centerX.equalTo(viewContain2);
    }];
    
    [self.labDeadStick mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lab2.mas_bottom).offset(8);
        make.left.right.equalTo(viewContain2);
    }];

    [self.labPush mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(viewContain3);
        make.height.equalTo(@55);
    }];
    
    [self.labLeftPush mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.labPush.mas_bottom).offset(16);
        make.left.right.equalTo(viewContain3);
    }];
    
    [lab3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.labLeftPush.mas_bottom);
        make.centerX.equalTo(viewContain3);
    }];
    
    [self.labDeadPush mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lab3.mas_bottom).offset(8);
        make.left.right.equalTo(viewContain3);
    }];
}

- (void)setModel:(AccountVipInfo *)model{
    _model = model;
    EPModel *epModel = [[UserData sharedInstance] getEpModelFromHave];
    self.labEpName.text = epModel.enterprise_name.length ? epModel.enterprise_name : nil;
    self.imgIcon.image = [UIImage imageNamed:[epModel getImgOfAccountVipType]];
    self.labRefresh.text = [NSString stringWithFormat:@"刷新%ld次", model.national_general_vip_refresh_privilege.all_refresh_num.integerValue];
    self.labLeftRefresh.text = [NSString stringWithFormat:@"%ld", model.national_general_vip_refresh_privilege.left_can_refresh_num.integerValue];
    if (model.national_general_vip_refresh_privilege.soon_expired_refresh_num.integerValue) {
        self.labDeadRefresh.hidden = NO;
        self.labDeadRefresh.text = [NSString stringWithFormat:@"有%ld次即将到期", model.national_general_vip_refresh_privilege.soon_expired_refresh_num.integerValue];
    }else{
        self.labDeadRefresh.hidden = YES;
    }
    
    
    self.labStick.text = [NSString stringWithFormat:@"置顶%ld天", model.national_general_vip_top_privilege.all_top_num.integerValue];
    self.labLeftStick.text = model.national_general_vip_top_privilege.left_can_top_num.description;
    if (model.national_general_vip_top_privilege.soon_expired_top_num.integerValue) {
        self.labDeadStick.hidden = NO;
        self.labDeadStick.text = [NSString stringWithFormat:@"有%ld天即将过期", model.national_general_vip_top_privilege.soon_expired_top_num.integerValue];
    }else{
        self.labDeadStick.hidden = YES;
    }
    
    self.labPush.text = [NSString stringWithFormat:@"推送%ld人", model.national_general_vip_push_privilege.all_push_num.integerValue];
    self.labLeftPush.text = model.national_general_vip_push_privilege.left_can_push_num.description;
    if (model.national_general_vip_push_privilege.soon_expired_push_num.integerValue) {
        self.labDeadPush.hidden = NO;
        self.labDeadPush.text = [NSString stringWithFormat:@"有%ld人数即将到期", model.national_general_vip_push_privilege.soon_expired_push_num.integerValue];
    }else{
        self.labDeadPush.hidden = YES;
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
