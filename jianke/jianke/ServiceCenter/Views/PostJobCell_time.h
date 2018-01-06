//
//  PostJobCell_time.h
//  jianke
//
//  Created by xiaomk on 16/4/20.
//  Copyright © 2016年 xianshijian. All rights reserved.
//

#import "MKBaseTableViewCell.h"

@protocol PostJobCellTimeDelegate <MKBaseTableViewCellDelegate>

- (void)btnAddTimeInclick;
- (void)btnAddMaxTimeInClick;

@end

@interface PostJobCell_time : MKBaseTableViewCell
@property (weak, nonatomic) IBOutlet UIView *timeBgView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *layoutTimeBtnToTop;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *layoutViewHeight;

@property (weak, nonatomic) IBOutlet UIButton *btnAddTime;
@property (weak, nonatomic) IBOutlet UIButton *btnMaxTime;

@property (nonatomic, weak) id<PostJobCellTimeDelegate> delegate;
@property (nonatomic, assign) BOOL selectBtn;

+ (instancetype)cellWithTableView:(UITableView *)tableView;
- (void)setModel:(id)model timeBtnArray:(NSArray *)timeBtnArray;

@end
