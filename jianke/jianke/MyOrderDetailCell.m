//
//  MyOrderDetailCell.m
//  JKHire
//
//  Created by fire on 16/10/24.
//  Copyright © 2016年 xianshijian. All rights reserved.
//

#import "MyOrderDetailCell.h"
#import "ResponseInfo.h"
#import "DateHelper.h"
#import "UILabel+MKExtension.h"
#import "MKOpenUrlHelper.h"

@interface MyOrderDetailCell ()

@property (weak, nonatomic) IBOutlet UILabel *labOrderTitle;
@property (weak, nonatomic) IBOutlet UILabel *labOrderContent;
@property (weak, nonatomic) IBOutlet UILabel *labTypeTitle;
@property (weak, nonatomic) IBOutlet UILabel *labDate;
@property (weak, nonatomic) IBOutlet UILabel *labCity;
@property (weak, nonatomic) IBOutlet UILabel *labNum;
@property (weak, nonatomic) IBOutlet UILabel *labDuty;
@property (weak, nonatomic) IBOutlet UIButton *btnPhone;
@property (weak, nonatomic) IBOutlet UILabel *labSalary;

- (IBAction)btnOnClick:(UIButton *)sender;


@end

@implementation MyOrderDetailCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSeparatorStyleNone;
}

- (void)setModel:(TeamCompanyModel *)model{
    self.labOrderTitle.text = model.orderer_basic_info.enterprise_name;
    self.labOrderContent.text = model.orderer_basic_info.desc;
    self.labTypeTitle.text = model.service_team_job.service_title.length ? model.service_team_job.service_title : model.service_team_job.service_classify_name;
    self.labSalary.text = [NSString stringWithFormat:@"%.2f", model.service_team_job.budget_amount.floatValue];
    
    NSString *startDate = [DateHelper getShortDateFromTimeNumber:model.service_team_job.working_time_start_date];
    NSString *endDate = [DateHelper getShortDateFromTimeNumber:model.service_team_job.working_time_end_date];
    
    self.labDate.text = [NSString stringWithFormat:@"用人日期:%@至%@", startDate, endDate];
    self.labCity.text = model.service_team_job.city_name;
    self.labNum.text = [NSString stringWithFormat:@"招聘人数:%@", model.service_team_job.recruitment_num.description];
    self.labDuty.text = [NSString stringWithFormat:@"负责人:%@", model.orderer_basic_info.true_name];
    NSAttributedString *attStr = [[NSAttributedString alloc] initWithString:model.orderer_basic_info.telphone attributes:@{NSUnderlineStyleAttributeName: [NSNumber numberWithInteger:NSUnderlineStyleSingle]}];
    [self.btnPhone setAttributedTitle:attStr forState:UIControlStateNormal];
    
    CGFloat contentHeight = [self.labOrderContent contentSizeWithWidth:SCREEN_WIDTH - 32].height;
    model.cellHeight = 24 + 28 + 33 + 20 + 8 + contentHeight + 16 + 20 + 163;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)btnOnClick:(UIButton *)sender {
    [[MKOpenUrlHelper sharedInstance] callWithPhone:sender.titleLabel.text];
}
@end
