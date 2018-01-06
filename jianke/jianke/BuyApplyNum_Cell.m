//
//  BuyApplyNum_Cell.m
//  JKHire
//
//  Created by yanqb on 2017/5/12.
//  Copyright © 2017年 xianshijian. All rights reserved.
//

#import "BuyApplyNum_Cell.h"
#import "ResponseInfo.h"

@interface BuyApplyNum_Cell ()

@property (weak, nonatomic) IBOutlet UILabel *labTitle;
@property (weak, nonatomic) IBOutlet UILabel *labPrice;
@property (weak, nonatomic) IBOutlet UILabel *labPerPrice;
@property (weak, nonatomic) IBOutlet UIButton *btnSelected;


@end

@implementation BuyApplyNum_Cell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)setModel:(VipApplyPackage *)model{
    self.labTitle.text = [NSString stringWithFormat:@"%ld个", model.apply_job_num.integerValue];
    self.labPrice.text = [NSString stringWithFormat:@"¥%.2f", model.price.floatValue * 0.01];
    self.labPerPrice.text = [NSString stringWithFormat:@"¥%.2f/个", model.unit_price.floatValue * 0.01];
    self.btnSelected.selected = model.isSelected;
}

- (void)setReumeModel:(ResumeNumPackage *)reumeModel{
    self.labTitle.text = [NSString stringWithFormat:@"%ld份", reumeModel.resume_num.integerValue];
    
    if (reumeModel.promotion_price) {
        self.labPrice.text = [NSString stringWithFormat:@"¥%.2f", reumeModel.promotion_price.floatValue * 0.01];
        NSAttributedString *attStr = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"¥%.2f", reumeModel.price.floatValue * 0.01] attributes:@{NSStrikethroughStyleAttributeName: [NSNumber numberWithInteger:NSUnderlineStyleSingle]}];
        self.labPerPrice.attributedText = attStr;
        self.labPerPrice.hidden = NO;
    }else{
        self.labPrice.text = [NSString stringWithFormat:@"¥%.2f", reumeModel.price.floatValue * 0.01];
        self.labPerPrice.hidden = YES;
    }
    self.btnSelected.selected = reumeModel.isSelected;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
