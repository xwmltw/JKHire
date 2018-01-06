//
//  RecruitPostDetailCell.h
//  JKHire
//
//  Created by yanqb on 2017/2/13.
//  Copyright © 2017年 xianshijian. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RecruitPostDetailCell, RecruitJobNumRecord;

@protocol RecruitPostDetailCellDelegate <NSObject>

- (void)btnOnClickWithRecruitPostDetailCell:(RecruitPostDetailCell *)cell withModel:(RecruitJobNumRecord *)model;

@end

@interface RecruitPostDetailCell : UITableViewCell

@property (nonatomic, weak) id<RecruitPostDetailCellDelegate> delegate;
- (void)setModel:(id)model;

@end
