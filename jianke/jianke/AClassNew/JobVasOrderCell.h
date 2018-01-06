//
//  JobVasOrderCell.h
//  jianke
//
//  Created by fire on 16/9/24.
//  Copyright © 2016年 xianshijian. All rights reserved.
//

@class JobVasOrderCell;
#import <UIKit/UIKit.h>
#import "MyEnum.h"

@protocol JobVasOrderCellDelegate <NSObject>

- (void)jobVasOrderCell:(JobVasOrderCell *)cell actionType:(NSInteger)type;
- (void)pushHistoryBtnOnClick;
@end

@interface JobVasOrderCell : UITableViewCell

@property (nonatomic, weak) id<JobVasOrderCellDelegate> delegate;
@property (nonatomic, assign) BOOL jobIsOver;    /*!< 岗位是否已经结束 */

- (void)setData:(id)model andType:(NSInteger)type cellDic:(NSMutableDictionary *)cellHeightDic;

@end
