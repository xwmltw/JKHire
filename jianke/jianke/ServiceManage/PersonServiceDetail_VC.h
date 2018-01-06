//
//  PersonServiceDetail_VC.h
//  jianke
//
//  Created by fire on 16/10/18.
//  Copyright © 2016年 xianshijian. All rights reserved.
//

#import "BottomViewControllerBase.h"

@interface PersonServiceDetail_VC : BottomViewControllerBase

@property (nonatomic, copy) NSNumber *service_personal_job_id;  /*!< 个人服务需求Id */
@property (nonatomic, copy) NSNumber *apply_status;
@property (nonatomic, copy) NSNumber *service_personal_job_apply_id;

@property (nonatomic, copy) MKBlock block;

@end
