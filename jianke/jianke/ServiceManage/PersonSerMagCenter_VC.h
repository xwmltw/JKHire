//
//  PersonSerMagCenter_VC.h
//  JKHire
//
//  Created by fire on 16/10/19.
//  Copyright © 2016年 xianshijian. All rights reserved.
//

#import "BottomViewControllerBase.h"
#import "JobModel.h"

@interface PersonSerMagCenter_VC : BottomViewControllerBase

@property (nonatomic, copy) NSNumber *service_personal_job_id;  /*!< 个人服务需求Id */
@property (nonatomic, copy) NSNumber *service_type; /*!< 个人服务类型 */
@property (nonatomic, copy) NSNumber *platform_invite_accept_num;   /*!< 平台邀约数 */

@property (nonatomic, copy) MKBlock block;

@end
