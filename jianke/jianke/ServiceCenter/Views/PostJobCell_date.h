//
//  PostJobCell_date.h
//  jianke
//
//  Created by xiaomk on 16/4/18.
//  Copyright © 2016年 xianshijian. All rights reserved.
//

#import "MKBaseTableViewCell.h"

@protocol PostJobCellDateDelegate <MKBaseTableViewCellDelegate>

- (void)btnDateStartOnclick;
- (void)btnDateEndOnclick;

@end

@interface PostJobCell_date : MKBaseTableViewCell

@property (weak, nonatomic) IBOutlet UILabel *labDateStart;
@property (weak, nonatomic) IBOutlet UILabel *labDateEnd;
@property (weak, nonatomic) IBOutlet UIButton *btnDateStart;
@property (weak, nonatomic) IBOutlet UIButton *btnDateEnd;

@property (nonatomic, weak) id<PostJobCellDateDelegate> delegate;

- (void)setStartDate:(NSDate *)startDate endDate:(NSDate *)endDate jobCellType:(NSNumber *)cellType;
+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end

