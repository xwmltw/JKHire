//
//  RecruitPostDetailCell.m
//  JKHire
//
//  Created by yanqb on 2017/2/13.
//  Copyright © 2017年 xianshijian. All rights reserved.
//

#import "RecruitPostDetailCell.h"
#import "WDConst.h"

@interface RecruitPostDetailCell ()

@property (nonatomic, strong) RecruitJobNumRecord *model;

@property (weak, nonatomic) IBOutlet UILabel *labTitle;
@property (weak, nonatomic) IBOutlet UILabel *labDate;
@property (weak, nonatomic) IBOutlet UIButton *BtnBuy;
- (IBAction)btnOnClick:(id)sender;


@end

@implementation RecruitPostDetailCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self.BtnBuy setCornerValue:2.0f];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)setModel:(RecruitJobNumRecord *)model{
    _model = model;
    self.labTitle.text = model.record_title.length ? model.record_title : @"";
    
    NSString *starTimeStr = [DateHelper getDateFromTimeNumber:model.begin_time withFormat:@"yyyy/M/dd"];
    NSString *endTimeStr = [DateHelper getDateFromTimeNumber:model.end_time withFormat:@"yyyy/M/dd"];
    self.labDate.text = [NSString stringWithFormat:@"%@ 至 %@", starTimeStr, endTimeStr];
    if ([XSJUserInfoData isReviewAccount]) {
        self.BtnBuy.hidden = YES;
    }else{
        self.BtnBuy.hidden = NO;
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)btnOnClick:(id)sender {
    if ([self.delegate respondsToSelector:@selector(btnOnClickWithRecruitPostDetailCell:withModel:)]) {
        [self.delegate btnOnClickWithRecruitPostDetailCell:self withModel:self.model];
    }
}
@end
