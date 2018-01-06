//
//  HiringJobNumCell2.m
//  JKHire
//
//  Created by yanqb on 2017/4/1.
//  Copyright © 2017年 xianshijian. All rights reserved.
//

#import "HiringJobNumCell2.h"
#import "WDConst.h"

@interface HiringJobNumCell2 ()

@property (weak, nonatomic) IBOutlet UIButton *btnBuyJob;


@end

@implementation HiringJobNumCell2

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    NSAttributedString *arrStr1 = [[NSAttributedString alloc] initWithString:@"购买岗位数" attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:17.0f], NSUnderlineStyleAttributeName: @(NSUnderlineStyleSingle), NSUnderlineColorAttributeName: [UIColor XSJColor_tGrayDeepTinge]}];
    [self.btnBuyJob setAttributedTitle:arrStr1 forState:UIControlStateNormal];
    
    self.btnBuyJob.tag = BtnOnClickActionType_buyPostJobNumber;

    [self.btnBuyJob addTarget:self action:@selector(btnOnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    if (![XSJUserInfoData isReviewAccount]) {
        self.btnBuyJob.hidden = NO;
    }else{
        self.btnBuyJob.hidden = YES;
    }
}

- (void)btnOnClick:(UIButton *)sender{
    if ([self.delegate respondsToSelector:@selector(hiringJobNumCell2:actionType:)]) {
        [self.delegate hiringJobNumCell2:self actionType:sender.tag];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
