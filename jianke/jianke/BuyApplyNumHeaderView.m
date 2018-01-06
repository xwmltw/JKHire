//
//  BuyApplyNumHeaderView.m
//  JKHire
//
//  Created by yanqb on 2017/5/12.
//  Copyright © 2017年 xianshijian. All rights reserved.
//

#import "BuyApplyNumHeaderView.h"
#import "WDConst.h"
#import "ResponseInfo.h"

@interface BuyApplyNumHeaderView ()

@property (nonatomic, strong) UILabel *labName;
@property (nonatomic, strong) UILabel *labVipType;
@property (nonatomic, strong) UILabel *labVipCity;
@property (nonatomic, strong) UILabel *labVipLeftApply;

@end

@implementation BuyApplyNumHeaderView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupViews];
    }
    return self;
}

- (void)setupViews{
    self.backgroundColor = [UIColor XSJColor_newWhite];
    
    UIImageView *imgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"v320_firendly_icon"]];
    self.labName = [[UILabel alloc] init];
    self.labName.textColor = [UIColor XSJColor_tGrayDeepTransparent48];
    self.labName.font = [UIFont systemFontOfSize:18.0f];
    
    self.labVipType = [[UILabel alloc] init];
    self.labVipType.textColor = [UIColor XSJColor_tGrayDeepTinge];
    self.labVipType.font = [UIFont systemFontOfSize:14.0f];
    
    self.labVipCity = [[UILabel alloc] init];
    self.labVipCity.textColor = [UIColor XSJColor_tGrayDeepTinge];
    self.labVipCity.font = [UIFont systemFontOfSize:14.0f];
    
    self.labVipLeftApply = [[UILabel alloc] init];
    self.labVipLeftApply.textColor = [UIColor XSJColor_tGrayDeepTinge];
    self.labVipLeftApply.font = [UIFont systemFontOfSize:14.0f];
    
    UIView *line = [[UIView alloc] init];
    line.backgroundColor = [UIColor XSJColor_clipLineGray];
    
    [self addSubview:imgView];
    [self addSubview:self.labName];
    [self addSubview:self.labVipType];
    [self addSubview:self.labVipCity];
    [self addSubview:self.labVipLeftApply];
    [self addSubview:line];
    
    [imgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.labName);
        make.left.equalTo(self).offset(16);
    }];
    [self.labName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(16);
        make.left.equalTo(imgView.mas_right).offset(8);
        make.right.equalTo(self).offset(-16);
    }];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(16);
        make.top.equalTo(self.labName.mas_bottom).offset(16);
        make.width.equalTo(@40);
        make.height.equalTo(@1);
    }];
    [self.labVipType mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(16);
        make.top.equalTo(line.mas_bottom).offset(16);
    }];
    [self.labVipCity mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(16);
        make.top.equalTo(self.labVipType.mas_bottom).offset(8);
    }];
    [self.labVipLeftApply mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(16);
        make.top.equalTo(self.labVipCity.mas_bottom).offset(8);
    }];
}

- (void)setModel:(CityVipInfo *)model{
    EPModel *epModel = [[UserData sharedInstance] getEpModelFromHave];
    self.labName.text = [NSString stringWithFormat:@"您好，%@", epModel.enterprise_name.length ? epModel.enterprise_name : @" "];
    
    self.labVipType.text = [NSString stringWithFormat:@"当前VIP套餐：%@", model.vip_package_name];
    self.labVipCity.text = [NSString stringWithFormat:@"当前VIP服务城市：%@", model.vip_city_name];
    
    NSMutableAttributedString *mutableAttStr = [[NSMutableAttributedString alloc] initWithString:@"当前VIP套餐剩余报名数：" attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:14.0f], NSForegroundColorAttributeName :[UIColor XSJColor_tGrayDeepTinge]}];
    NSAttributedString *attStr = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%ld个", model.vip_apply_job_num_obj.left_apply_job_num.integerValue] attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:14.0f], NSForegroundColorAttributeName: [UIColor XSJColor_middelRed]}];
    [mutableAttStr appendAttributedString:attStr];
    self.labVipLeftApply.attributedText = mutableAttStr;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
