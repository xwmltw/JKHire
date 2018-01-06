//
//  MarketServiceCell.m
//  JKHire
//
//  Created by fire on 16/10/11.
//  Copyright © 2016年 xianshijian. All rights reserved.
//

#import "MarketServiceCell.h"

@interface MarketServiceCell ()

- (IBAction)LeftBtnOnClick:(UIButton *)sender;
- (IBAction)rightBtnOnClick:(UIButton *)sender;

@end

@implementation MarketServiceCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)LeftBtnOnClick:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(BtnOnClick:)]) {
        [self.delegate BtnOnClick:ActionType_ZhongBao];
    }
}

- (IBAction)rightBtnOnClick:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(BtnOnClick:)]) {
        [self.delegate BtnOnClick:ActionType_XiongDitui];
    }
}
@end
