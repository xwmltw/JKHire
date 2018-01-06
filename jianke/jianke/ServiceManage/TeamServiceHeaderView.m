//
//  TeamServiceHeaderView.m
//  JKHire
//
//  Created by fire on 16/10/21.
//  Copyright © 2016年 xianshijian. All rights reserved.
//

#import "TeamServiceHeaderView.h"
#import "TeamJobModel.h"
#import "DateHelper.h"

@interface TeamServiceHeaderView ()

@property (weak, nonatomic) IBOutlet UILabel *labTitle;
@property (weak, nonatomic) IBOutlet UILabel *labSalary;
@property (weak, nonatomic) IBOutlet UILabel *labDate;
@property (weak, nonatomic) IBOutlet UILabel *labAddress;
@property (weak, nonatomic) IBOutlet UILabel *labInviteNum;
@property (weak, nonatomic) IBOutlet UILabel *labDes;


@end

@implementation TeamServiceHeaderView

- (void)setModel:(TeamJobModel *)teamJobModel{
    if (teamJobModel) {
        self.labTitle.text = teamJobModel.service_title.length ? teamJobModel.service_title : teamJobModel.service_classify_name;
        self.labSalary.text = [NSString stringWithFormat:@"%.2f", teamJobModel.budget_amount.floatValue];
        self.labDate.text = [NSString stringWithFormat:@"%@至%@", [DateHelper getDateWithNumber:teamJobModel.working_time_start_date], [DateHelper getDateWithNumber:teamJobModel.working_time_end_date]];
        self.labAddress.text = teamJobModel.city_name;
        self.labInviteNum.text = (teamJobModel.recruitment_num) ? [NSString stringWithFormat:@"%ld人", teamJobModel.recruitment_num.integerValue] : @"0人";
        self.labDes.text = [NSString stringWithFormat:@"%ld家我预约的团队", teamJobModel.order_count.integerValue];
    }
}

@end
