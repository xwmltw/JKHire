//
//  UsedApplyNUm_Cell.m
//  JKHire
//
//  Created by yanqb on 2017/5/11.
//  Copyright © 2017年 xianshijian. All rights reserved.
//

#import "UsedApplyNUm_Cell.h"
#import "ResponseInfo.h"

@interface UsedApplyNUm_Cell ()

@property (weak, nonatomic) IBOutlet UILabel *labTitle;
@property (weak, nonatomic) IBOutlet UILabel *labApplyNum;
@property (weak, nonatomic) IBOutlet UIImageView *imgIcon;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *layoutImgIconRight;


@end

@implementation UsedApplyNUm_Cell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)setModel:(VipJobListModel *)model{
    _model = model;
    self.labTitle.text = [NSString stringWithFormat:@"%@-%@-%@",model.job_city_name ,model.job_title, [model getStatusStr]];
    self.imgIcon.hidden = NO;
    self.layoutImgIconRight.constant = 32;
    if (!model.curr_used_apply_num.integerValue) {
        self.imgIcon.hidden = YES;
        self.layoutImgIconRight.constant = 16;
    }
    self.labApplyNum.text = [NSString stringWithFormat:@"%ld人", model.curr_used_apply_num.integerValue];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
