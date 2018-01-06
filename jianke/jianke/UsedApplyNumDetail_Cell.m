//
//  UsedApplyNumDetail_Cell.m
//  JKHire
//
//  Created by yanqb on 2017/5/11.
//  Copyright © 2017年 xianshijian. All rights reserved.
//

#import "UsedApplyNumDetail_Cell.h"
#import "ResponseInfo.h"
#import "WDConst.h"

@interface UsedApplyNumDetail_Cell ()

@property (weak, nonatomic) IBOutlet UILabel *labDate;
@property (weak, nonatomic) IBOutlet UILabel *labApply;


@end

@implementation UsedApplyNumDetail_Cell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)setModel:(ApplyJobListStu *)model{
    _model = model;
    self.labDate.text = [DateHelper getDateTimeFromTimeNumber:model.stu_apply_time];
    self.labApply.text =  [NSString stringWithFormat:@"%@报名", model.stu_true_name];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
