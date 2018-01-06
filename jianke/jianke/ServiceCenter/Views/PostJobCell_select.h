//
//  PostJobCell_select.h
//  jianke
//
//  Created by xiaomk on 16/4/18.
//  Copyright © 2016年 xianshijian. All rights reserved.
//

#import "MKBaseTableViewCell.h"
#import "MyEnum.h"

@interface PostJobCell_select : MKBaseTableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imgIcon;
@property (weak, nonatomic) IBOutlet UIImageView *imgRightIcon;
@property (weak, nonatomic) IBOutlet UILabel *labTitle;

+ (instancetype)cellWithTableView:(UITableView *)tableView;
- (void)setModel:(id)model jobCellType:(NSNumber *)cellType sourceType:(ViewSourceType)sourceType;
- (void)setModel:(id)model jobCellType:(PostJobCellType)cellType;

@end
