//
//  SuccessPostPerson_VC.h
//  JKHire
//
//  Created by fire on 16/10/17.
//  Copyright © 2016年 xianshijian. All rights reserved.
//

#import "BottomViewControllerBase.h"

typedef NS_ENUM(NSInteger, SuccessCellType) {
    SuccesscellType_invite,
    SuccessCellType_manage,
    SuccessCellType_contactQQ
};

@interface SuccessPostPerson_VC : BottomViewControllerBase

@property (nonatomic, copy) NSNumber *personServiceType;
@property (nonatomic, copy) NSNumber *service_personal_job_id;  /*!< 个人服务订单Id */

@end
