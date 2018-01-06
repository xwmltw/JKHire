//
//  MyInfoCell_MoneyBag.m
//  JKHire
//
//  Created by yanqb on 2017/3/30.
//  Copyright © 2017年 xianshijian. All rights reserved.
//

#import "MyInfoCell_MoneyBag.h"
#import "WDConst.h"

@interface MyInfoCell_MoneyBag ()

@property (weak, nonatomic) IBOutlet UIView *redPoint;
@property (weak, nonatomic) IBOutlet UILabel *labMoney;
@property (weak, nonatomic) IBOutlet UIButton *btnAuth;
@property (weak, nonatomic) IBOutlet UIButton *btnMoneyBag;

@end

@implementation MyInfoCell_MoneyBag

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self.redPoint setCornerValue:5.0f];
    self.btnAuth.tag = BtnOnClickActionType_verity;
    [self.btnAuth addTarget:self action:@selector(btnOnClick:) forControlEvents:UIControlEventTouchUpInside];
    self.btnMoneyBag.tag = BtnOnClickActionType_moneyBag;
    [self.btnMoneyBag addTarget:self action:@selector(btnOnClick:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)setEpModel:(EPModel *)epModel{
    if ([[UserData sharedInstance] isLogin]) {
        NSString* moneyStr = [NSString stringWithFormat:@"%0.2f", epModel.acct_amount.floatValue*0.01];
        self.labMoney.text = moneyStr;
       self.redPoint.hidden = ![XSJUserInfoData sharedInstance].isShowMoneyBadRedPoint;
    }else{
        self.redPoint.hidden = YES;
        self.labMoney.text = @"0.00";
    }
}

- (void)btnOnClick:(UIButton *)sender{
    if ([self.delegate respondsToSelector:@selector(myinfoCell_MonyeBag:actionType:)]) {
        [self.delegate myinfoCell_MonyeBag:self actionType:sender.tag];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
