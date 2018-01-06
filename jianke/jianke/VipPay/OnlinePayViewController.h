//
//  OnlinePayViewController.h
//  QuanWangDai
//
//  Created by 余文灿 on 2017/12/27.
//  Copyright © 2017年 kizy. All rights reserved.
//

#import "BottomViewControllerBase.h"

@interface OnlinePayViewController : BottomViewControllerBase
@property (nonatomic, copy, nullable) NSNumber *jobId;
@property (nonatomic, assign) int needPayMoney;                 /*!< 支付的金额 单位分*/
@property (nonatomic, copy, nullable) NSNumber *vip_order_id;  /*!< 雇主购买VIP套餐订单id */
@property (nonatomic, copy, nullable) MKBlock updateDataBlock;
@property (nonatomic, copy, nullable) NSString *des;
@property (nonatomic, copy, nullable) NSString *city;
@property (nonatomic, copy, nullable) NSString *date;
@property (nonatomic, copy, nullable) NSString *name;
@end
