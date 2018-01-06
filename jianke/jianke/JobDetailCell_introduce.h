//
//  JobDetailCell_introduce.h
//  jianke
//
//  Created by xiaomk on 16/3/15.
//  Copyright © 2016年 xianshijian. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JobDetailCell_introduce : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *labJobDetail;
@property (weak, nonatomic) IBOutlet UILabel *warnLab;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end
