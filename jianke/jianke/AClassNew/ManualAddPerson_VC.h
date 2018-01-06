//
//  ManualAddPerson_VC.h
//  jianke
//
//  Created by fire on 16/7/5.
//  Copyright © 2016年 xianshijian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WDViewControllerBase.h"

typedef NS_ENUM(NSInteger, FromViewType) {
    FromViewType_ManualAddJK = 1,   //手动收录
    FromViewType_PayView,   //发放工资
    FromViewType_PostSalayJob,  //发布代发岗位
    FromViewType_PayRecord,  //逻辑和代发岗位一样 ，只是返回不一样
};

@interface ManualAddPerson_VC : WDViewControllerBase

@property (nonatomic, copy) NSString *job_id;   /** 岗位ID */
@property (nonatomic, copy)  MKBlock block;

@property (nonatomic, assign) FromViewType fromViewType;
@property (nonatomic, assign) BOOL isManualBack;    /*!< 手动返回 非上一页 */

@end
