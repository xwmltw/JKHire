//
//  MyTalentHeaderView.m
//  JKHire
//
//  Created by 徐智 on 2017/6/2.
//  Copyright © 2017年 xianshijian. All rights reserved.
//

#import "MyTalentHeaderView.h"
#import "WDConst.h"

@interface MyTalentHeaderView ()

@property (nonatomic, strong) UILabel *labTitle;
@property (nonatomic, strong) UIButton *btnBuy;

@end

@implementation MyTalentHeaderView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupViews];
    }
    return self;
}

- (void)setupViews{
    self.backgroundColor = MKCOLOR_RGBA(39, 39, 39, 0.94);
    
    self.labTitle = [[UILabel alloc] init];
    self.labTitle.attributedText = [self getMutableAttStrWith:@0];
    self.labTitle.font = [UIFont systemFontOfSize:18.0f];
    
    self.btnBuy = [UIButton buttonWithTitle:@"去购买" bgColor:nil image:nil target:self sector:@selector(btnOnClick:)];
    self.btnBuy.titleLabel.font = [UIFont systemFontOfSize:15.0f];
    
    UIView *line = [[UIView alloc] init];
    line.backgroundColor = MKCOLOR_RGBA(0, 0, 0, 0.5);
    
    [self addSubview:self.labTitle];
    [self addSubview:self.btnBuy];
    [self addSubview:line];
    [self.labTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(16);
        make.centerY.equalTo(self);
        make.right.equalTo(self.btnBuy.mas_left);
    }];
    
    [self.btnBuy mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.bottom.equalTo(self);
        make.width.equalTo(@77);
    }];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.btnBuy.mas_left);
        make.height.equalTo(@16);
        make.width.equalTo(@1);
        make.centerY.equalTo(self);
    }];
    
    if ([XSJUserInfoData isReviewAccount]) {
        self.btnBuy.hidden = YES;
    }
}

- (void)setLeftNum:(NSNumber *)leftNum{
    self.labTitle.attributedText = [self getMutableAttStrWith:leftNum];
}

- (NSMutableAttributedString *)getMutableAttStrWith:(NSNumber *)leftNum{
    
    NSMutableAttributedString *mutableAttStr = [[NSMutableAttributedString alloc] initWithString:@"当前剩余 " attributes:@{NSForegroundColorAttributeName: [UIColor whiteColor]}];
    NSAttributedString *attStr1 = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%ld", leftNum.integerValue] attributes:@{NSForegroundColorAttributeName: [UIColor XSJColor_middelRed]}];
    NSAttributedString *attStr2 = [[NSAttributedString alloc] initWithString:@" 份简历数" attributes:@{NSForegroundColorAttributeName: [UIColor whiteColor]}];
    [mutableAttStr appendAttributedString:attStr1];
    [mutableAttStr appendAttributedString:attStr2];
    return mutableAttStr;
}

- (void)btnOnClick:(UIButton *)sender{
    if ([self.delegate respondsToSelector:@selector(MyTalentHeaderView:)]) {
        [self.delegate MyTalentHeaderView:self];
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
