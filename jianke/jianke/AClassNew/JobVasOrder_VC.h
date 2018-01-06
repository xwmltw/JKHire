//
//  JobVasOrder_VC.h
//  jianke
//
//  Created by fire on 16/9/24.
//  Copyright © 2016年 xianshijian. All rights reserved.
//

#import "BottomViewControllerBase.h"

@class JobModel;
@interface JobVasOrder_VC : BottomViewControllerBase

@property (nonatomic, copy) NSString *jobId;
@property (nonatomic, strong) JobModel *jobModel;
@property (nonatomic, assign) BOOL jobIsOver;   /*!< 岗位是否已经结束 */
@property (nonatomic, assign) BOOL isFromSuccess;   /*!< 用于控制推送成功页面的显示 */
@property (nonatomic, assign) BOOL isShowZhaoRenTitle;  

@property (nonatomic, copy) MKBlock block;

@end
