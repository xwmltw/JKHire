//
//  JobAutoRefresh_VC.h
//  JKHire
//
//  Created by yanqb on 2017/4/19.
//  Copyright © 2017年 xianshijian. All rights reserved.
//

#import "BottomViewControllerBase.h"

@class JobModel;
@interface JobAutoRefresh_VC : BottomViewControllerBase

@property (nonatomic, copy) NSString *jobId;
@property (nonatomic, weak) UIViewController *popToVC;

@end
