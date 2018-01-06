//
//  JKManage_NewVC.h
//  JKHire
//
//  Created by yanqb on 2017/4/6.
//  Copyright © 2017年 xianshijian. All rights reserved.
//

#import "BottomViewControllerBase.h"

@interface JKManage_NewVC : BottomViewControllerBase

@property (nonatomic, copy) NSString *jobId; /*!< 岗位ID */
@property (nonatomic, assign) BOOL isOverJob; // 是否已结束岗位
@end
