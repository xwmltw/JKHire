//
//  JobDetailCell_jobName.h
//  jianke
//
//  Created by xiaomk on 16/3/15.
//  Copyright © 2016年 xianshijian. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JobDetailCell_jobName : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *imgViewSeize;
@property (weak, nonatomic) IBOutlet UILabel *labJobTitle;
@property (weak, nonatomic) IBOutlet UILabel *labMoney;
@property (weak, nonatomic) IBOutlet UILabel *labUnit;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *LayoutImgSeizeRightEdge;

@property (weak, nonatomic) IBOutlet UILabel *labPostDate;
@property (weak, nonatomic) IBOutlet UILabel *labSeeTime;

+ (instancetype)cellWithTableView:(UITableView *)tableView;


@end