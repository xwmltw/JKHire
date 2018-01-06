//
//  FindTalent_VC.h
//  JKHire
//
//  Created by yanqb on 2017/5/31.
//  Copyright © 2017年 xianshijian. All rights reserved.
//

#import "BottomViewControllerBase.h"

@interface FindTalent_VC : BottomViewControllerBase

@property (nonatomic, copy, nullable) NSNumber *city_id;  /*!< 城市id */
@property (nonatomic, copy) NSString *city_name;
@property (nonatomic, copy, nullable) NSNumber *address_area_id;  /*!< 区域id */
@property (nonatomic, copy) NSString *address_area_name;
@property (nonatomic, copy) NSString *job_classfie_name;
@property (nonatomic, copy, nullable) NSNumber *job_classify_id;  /*!< 岗位分类id */
@property (nonatomic, copy, nullable) NSNumber *sex;  /*!< 性别 1男 0女 */
@property (nonatomic, copy, nullable) NSNumber *age_limit;    /*!< 年龄：1: 18周岁以上 2 ：18~25周岁 3：25周岁以上 */

@property (nonatomic, assign) BOOL isBeginWithMJRefresh;

@end
