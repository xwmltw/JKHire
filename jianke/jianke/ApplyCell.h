//
//  ApplyCell.h
//  jianke
//
//  Created by fire on 15/9/29.
//  Copyright (c) 2015年 xianshijian. All rights reserved.
//

typedef NS_ENUM(NSInteger, ActionType){
    ActionTypeHire,
    ActionTypeFire,
    ActionTypeAdjust,
    ActionTypeIM,
    ActionTypeCall,
};

typedef NS_ENUM(NSInteger, ApplyCellType) {
    ApplyCellType_default,  //默认(V321之前的样式，带调整日期按钮)
    ApplyCellType_jobManageForNormal,    //兼职管理-待处理(不带调整日期按钮)
    ApplyCellType_jobManageForHire, //兼职管理-已录用(电话按钮etc)
    ApplyCellType_jobManageForRejected, //兼职管理-已拒绝(电话按钮etc)
};

@class ApplyCell;
@class JKModel;
#import <UIKit/UIKit.h>

@protocol ApplyCellDelegate <NSObject>

- (void)applyCell:(ApplyCell *)cell cellModel:(JKModel *)model actionType:(ActionType)actionType;

@end
// tableView刷新通知
static NSString * const ApplyCellReflushNotification = @"ApplyCellReflushNotification";
static NSString * const ApplyCellReflushInfo = @"ApplyCellReflushInfo";

static NSString * const ApplyChatWithJkNotification = @"ApplyChatWithJkNotification";
static NSString * const ApplyChatWithJkInfo = @"ApplyChatWithJkInfo";


@interface ApplyCell : UITableViewCell

@property (nonatomic, assign) ApplyCellType cellType;
@property (nonatomic, strong) JKModel *cellModel;

@property (nonatomic, strong) NSString *jobId;

@property (weak, nonatomic) IBOutlet UIImageView *redDot; /*!< 小红点 */

@property (nonatomic, weak) id<ApplyCellDelegate> delegate;

@end
