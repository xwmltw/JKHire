//
//  UsedApplyNum_VC.h
//  JKHire
//
//  Created by yanqb on 2017/5/11.
//  Copyright © 2017年 xianshijian. All rights reserved.
//

#import "BottomViewControllerBase.h"
#import "UsedApplyNumDetail_VC.h"

@interface UsedApplyNum_VC : BottomViewControllerBase

@property (nonatomic, assign) UsedApplyNumType fromType;
@property (nonatomic, copy) NSNumber *vip_order_id;  /*!< vip订单id */
@property (nonatomic, copy) NSNumber *arranged_agent_vas_order_id;  /*!< 包代招订单id */

@end
