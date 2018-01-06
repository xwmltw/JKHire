//
//  ArrangedAgent_Cell.m
//  JKHire
//
//  Created by 徐智 on 2017/6/5.
//  Copyright © 2017年 xianshijian. All rights reserved.
//

#import "ArrangedAgent_Cell.h"
#import "WDConst.h"

@interface ArrangedAgent_Cell ()

@property (weak, nonatomic) IBOutlet UIView *viewBg;
@property (weak, nonatomic) IBOutlet UILabel *labBuyNum;
@property (weak, nonatomic) IBOutlet UILabel *labDate;
@property (weak, nonatomic) IBOutlet UILabel *labLeftNum;
@property (weak, nonatomic) IBOutlet UILabel *labUsedNum;
@property (weak, nonatomic) IBOutlet UIButton *btnLeftNum;
@property (weak, nonatomic) IBOutlet UIButton *btnUsedNum;


@end

@implementation ArrangedAgent_Cell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    [self.viewBg setBorderWidth:0.7 andColor:[UIColor XSJColor_clipLineGray]];
    self.btnLeftNum.tag = BtnOnClickActionType_arragedLeftApply;
    [self.btnLeftNum addTarget:self action:@selector(btnOnClick:) forControlEvents:UIControlEventTouchUpInside];
    self.btnUsedNum.tag = BtnOnClickActionType_arragedUsedApply;
    [self.btnUsedNum addTarget:self action:@selector(btnOnClick:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)setModel:(ArrangedAgentVas *)model{
    _model = model;
    self.labBuyNum.text = [NSString stringWithFormat:@"%ld人", model.apply_num.integerValue];
    NSString *dateStartStr = [DateHelper getDateFromNumber:model.start_time];
    NSString *dateEndStr = [DateHelper getDateFromNumber:model.end_time];
    self.labDate.text = [NSString stringWithFormat:@"%@ 至 %@", dateStartStr, dateEndStr];
    
    self.labLeftNum.text = [NSString stringWithFormat:@"%ld", model.left_can_apply_num.integerValue];
    self.labUsedNum.text = [NSString stringWithFormat:@"%ld", model.curr_used_apply_num.integerValue];
    self.btnUsedNum.userInteractionEnabled = (model.curr_used_apply_num.integerValue > 0);
    
}

- (void)btnOnClick:(UIButton *)sender{
    if ([self.delegate respondsToSelector:@selector(ArrangedAgent_Cell:actionType:model:)]) {
        [self.delegate ArrangedAgent_Cell:self actionType:sender.tag model:self.model];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
