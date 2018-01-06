//
//  JKAppreciteCell.m
//  jianke
//
//  Created by fire on 16/9/23.
//  Copyright © 2016年 xianshijian. All rights reserved.
//

#import "JKAppreciteCell.h"
#import "ResponseInfo.h"
#import "MyEnum.h"

@interface JKAppreciteCell ()

@property (weak, nonatomic) IBOutlet UILabel *labSalary;
@property (weak, nonatomic) IBOutlet UILabel *labUnit;
@property (weak, nonatomic) IBOutlet UILabel *labOffSal;

@property (weak, nonatomic) IBOutlet UIButton *btnConfirm;
@property (weak, nonatomic) IBOutlet UILabel *labOffSalRefresh;

@end

@implementation JKAppreciteCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.btnConfirm.userInteractionEnabled = NO;
}

- (void)setData:(JobVasModel *)model{
    
    self.labOffSal.textColor = MKCOLOR_RGBA(253, 97, 142, 0.32);
    self.labOffSalRefresh.hidden = YES;
    if (model.promotion_price.integerValue > 0) {
        self.labOffSal.hidden = NO;
        self.labSalary.text = [NSString stringWithFormat:@"¥%.2f", model.promotion_price.floatValue * 0.01];
        self.labOffSal.attributedText = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"¥%.2f", model.price.floatValue * 0.01] attributes: @{NSStrikethroughStyleAttributeName: [NSNumber numberWithInteger:NSUnderlineStyleSingle]}];
        model.rechargePrice = model.promotion_price;
    }else{
        self.labOffSal.hidden = YES;
        self.labSalary.text = [NSString stringWithFormat:@"¥%.2f", model.price.floatValue * 0.01];
        model.rechargePrice = model.price;
    }
    
    NSAssert(model.serviceType, @"JKAppreciteCell **** 付费推广的类型一定要赋值~");
    switch (model.serviceType.integerValue) {
        case Appreciation_stick_Type:{
            self.labUnit.text = [NSString stringWithFormat:@"/%ld天", model.top_days.integerValue] ;
        }
            break;
        case Appreciation_push_Type:{
            self.labUnit.text = [NSString stringWithFormat:@"/%@人", model.push_num.stringValue];
        }
            break;
        case Appreciation_Refresh_Type:
        case Appreciation_autoRefresh_Type:{
            self.labOffSal.hidden = NO;
            self.labSalary.text = [NSString stringWithFormat:@"%@天", model.refresh_days.description];
            self.labUnit.hidden = (model.discount_rate == nil);
            self.labUnit.text = [NSString stringWithFormat:@"/享%.1f折，", model.discount_rate.floatValue];
            self.labOffSal.text = [NSString stringWithFormat:@"¥%.2f", model.price.floatValue * 0.01];
            
            if (model.promotion_price.integerValue > 0) {
                self.labOffSal.textColor = MKCOLOR_RGB(255, 97, 142);
                self.labOffSalRefresh.hidden = NO;
                self.labOffSal.text = [NSString stringWithFormat:@"¥%.2f", model.promotion_price.floatValue * 0.01];
                self.labOffSalRefresh.attributedText = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"¥%.2f", model.price.floatValue * 0.01] attributes: @{NSStrikethroughStyleAttributeName: [NSNumber numberWithInteger:NSUnderlineStyleSingle]}];
                model.rechargePrice = model.promotion_price;
            }else{
                self.labOffSal.text = [NSString stringWithFormat:@"¥%.2f", model.price.floatValue * 0.01];
                model.rechargePrice = model.price;
            }
        }
            break;
    }
    self.btnConfirm.selected = model.selected;
    
}
@end
