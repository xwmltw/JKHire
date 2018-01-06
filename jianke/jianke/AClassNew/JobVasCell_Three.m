//
//  JobVasCell_Three.m
//  JKHire
//
//  Created by yanqb on 2017/4/19.
//  Copyright © 2017年 xianshijian. All rights reserved.
//

#import "JobVasCell_Three.h"
#import "ResponseInfo.h"

@interface JobVasCell_Three ()

@property (weak, nonatomic) IBOutlet UILabel *labLeft;
@property (weak, nonatomic) IBOutlet UIButton *btnConfirm;


@end

@implementation JobVasCell_Three

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)setData:(JobVasModel *)model{
    if (model.promotion_price.integerValue > 0) {
        self.labLeft.text = [NSString stringWithFormat:@"方案三：也可以使用立即刷新，￥%.2f/次", model.promotion_price.floatValue * 0.01];
        model.rechargePrice = model.promotion_price;
    }else{
        self.labLeft.text = [NSString stringWithFormat:@"方案三：也可以使用立即刷新，￥%.2f/次", model.price.floatValue * 0.01];
        model.rechargePrice = model.price;
    }
    self.btnConfirm.selected = model.selected;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
