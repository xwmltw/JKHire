//
//  BuyApplyNum_VC.h
//  JKHire
//
//  Created by yanqb on 2017/5/12.
//  Copyright © 2017年 xianshijian. All rights reserved.
//

#import "BottomViewControllerBase.h"

@interface BuyApplyNum_VC : BottomViewControllerBase

@property (nonatomic, copy) NSNumber *vip_order_id; /*!< vip会员订单id */
@property (nonatomic, copy) MKBlock block;
@property (nonatomic, strong) CityVipInfo *vipInfo;

@end
