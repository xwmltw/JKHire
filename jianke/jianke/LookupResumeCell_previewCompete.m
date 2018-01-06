//
//  LookupResumeCell_previewCompete.m
//  jianke
//
//  Created by yanqb on 2017/5/23.
//  Copyright © 2017年 xianshijian. All rights reserved.
//

#import "LookupResumeCell_previewCompete.h"
#import "WDConst.h"


@interface LookupResumeCell_previewCompete ()

@property (weak, nonatomic) IBOutlet UILabel *labLastDate;
@property (weak, nonatomic) IBOutlet UILabel *labCompeteNum;
@property (weak, nonatomic) IBOutlet UILabel *labAwayNum;


@end

@implementation LookupResumeCell_previewCompete

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)setModel:(JKModel *)model{
    NSString *num =model.resume_view_num ? model.resume_view_num.description : @"0";
    self.labLastDate.text =[NSString stringWithFormat:@"%@次",num] ;
    
    NSMutableAttributedString *mutableAttStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%ld", model.complete_work_num.integerValue] attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:26.0f], NSForegroundColorAttributeName: [UIColor XSJColor_base], NSBaselineOffsetAttributeName: @0}];
    NSAttributedString *attStr = [[NSAttributedString alloc] initWithString:@"次" attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:14.0f], NSForegroundColorAttributeName: [UIColor XSJColor_tGrayDeepTransparent32], NSBaselineOffsetAttributeName: @2}];
    [mutableAttStr appendAttributedString:attStr];
    self.labCompeteNum.attributedText = mutableAttStr;
    
    if (model.break_promise_count.integerValue) {
        self.labAwayNum.text = [NSString stringWithFormat:@"%ld次", model.break_promise_count.integerValue];
    }else{
        self.labAwayNum.text = @"无";
    }
}
- (IBAction)completionRecord:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(LookupResumeCell_previewCompete:)]) {
        [self.delegate LookupResumeCell_previewCompete:self];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end