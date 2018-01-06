//
//  JKAppreciteCell_Job.h
//  JKHire
//
//  Created by yanqb on 2017/4/5.
//  Copyright © 2017年 xianshijian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyEnum.h"

@class JKAppreciteCell_Job;
@protocol JKAppreciteCell_JobDelegate <NSObject>

- (void)jkAppreciteCell:(JKAppreciteCell_Job *)cell;

@end

@interface JKAppreciteCell_Job : UITableViewCell

@property (nonatomic, weak) id<JKAppreciteCell_JobDelegate> delegate;
- (void)setModel:(id)model cellType:(AppreciationType)cellType isEditable:(BOOL)isEditable;

@end
