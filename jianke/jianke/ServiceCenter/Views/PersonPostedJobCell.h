//
//  PersonPostedJobCell.h
//  JKHire
//
//  Created by fire on 16/10/13.
//  Copyright © 2016年 xianshijian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JobModel.h"

@protocol PersonPostedJobCellDelegate <NSObject>

- (void)inviteActionWithJobModel:(JobModel *)jobModel;

@end

@interface PersonPostedJobCell : UITableViewCell

@property (nonatomic, weak) id<PersonPostedJobCellDelegate> delegate;
@property (nonatomic, strong) JobModel *model;
@property (nonatomic, assign) BOOL isFromPersonManage;

@end
