//
//  AppreciateChooseJobCell.m
//  JKHire
//
//  Created by yanqb on 2017/4/5.
//  Copyright © 2017年 xianshijian. All rights reserved.
//

#import "AppreciateChooseJobCell.h"
#import "JobModel.h"

@interface AppreciateChooseJobCell ()

@property (weak, nonatomic) IBOutlet UILabel *labJobTitle;
@property (weak, nonatomic) IBOutlet UIButton *btnConfirm;


@end

@implementation AppreciateChooseJobCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.btnConfirm.userInteractionEnabled = NO;
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)setJobModel:(JobModel *)jobModel{
    _jobModel = jobModel;
    self.labJobTitle.text = jobModel.job_title.length ? jobModel.job_title : nil;
    self.btnConfirm.selected = jobModel.selected;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
