//
//  PostJobCell_twoEdit.h
//  jianke
//
//  Created by xiaomk on 16/4/18.
//  Copyright © 2016年 xianshijian. All rights reserved.
//

#import "MKBaseTableViewCell.h"
#import "MyEnum.h"

@protocol PostJobCellTwoEditDelegate <MKBaseTableViewCellDelegate>

- (void)btnSalaryUnitOnclick;

@end

@interface PostJobCell_twoEdit : MKBaseTableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imgXiaLeft;
@property (weak, nonatomic) IBOutlet UIImageView *imgXiaRight;
@property (weak, nonatomic) IBOutlet UIImageView *imgIcon;
@property (weak, nonatomic) IBOutlet UITextField *tfLeft;
@property (weak, nonatomic) IBOutlet UITextField *tfRight;
@property (weak, nonatomic) IBOutlet UIButton *btnLeft;
@property (weak, nonatomic) IBOutlet UIButton *btnRight;

@property (nonatomic, weak) id<PostJobCellTwoEditDelegate> delegate;

+ (instancetype)cellWithTableView:(UITableView *)tableView;
- (void)setModel:(id)model;
- (void)setModel:(id)model cellType:(PostJobCellType)cellType;

@end
