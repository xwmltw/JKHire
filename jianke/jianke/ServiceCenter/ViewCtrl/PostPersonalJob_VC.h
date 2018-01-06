//
//  PostPersonalJob_VC.h
//  JKHire
//
//  Created by fire on 16/10/11.
//  Copyright © 2016年 xianshijian. All rights reserved.
//

#import "BottomViewControllerBase.h"
#import "MyEnum.h"

@interface PostPersonalJob_VC : BottomViewControllerBase

@property (nonatomic, assign) ViewSourceType sourceType;
@property (nonatomic, copy) NSNumber *stu_account_id;   /*!< 个人服务需求id */
@property (nonatomic, assign) NSNumber *serviceType; /*!< 个人服务类型 */

@property (nonatomic, copy) NSNumber *service_classify_id;  /*!< 团队服务类型Id */
@property (nonatomic, copy) NSNumber *service_apply_id; /*!< 服务商记录Id */
@property (nonatomic, copy) NSString *service_classify_name;    /*!< 团队服务商类型名称 */

@end
