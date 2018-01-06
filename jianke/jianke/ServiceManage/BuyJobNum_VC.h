//
//  BuyJobNum_VC.h
//  JKHire
//
//  Created by yanqb on 2017/2/8.
//  Copyright © 2017年 xianshijian. All rights reserved.
//

#import "BottomViewControllerBase.h"
#import "MyEnum.h"

@interface BuyJobNum_VC : BottomViewControllerBase

@property (nonatomic, assign) BuyJobNumActionType actionType;
@property (nonatomic, copy) MKBlock block;
@property (nonatomic, copy) NSNumber *recruit_city_id;  /*!< 招聘城市Id */
@property (nonatomic, copy) NSNumber *recruit_job_num;  /*!< 在招岗位数 */
@property (nonatomic, copy) NSNumber *record_id;    /*!< 记录id */

@end
