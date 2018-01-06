//
//  PostJobSuccess_VC.h
//  JKHire
//
//  Created by yanqb on 2017/2/9.
//  Copyright © 2017年 xianshijian. All rights reserved.
//

#import "BottomViewControllerBase.h"
#import "JobModel.h"

@interface PostJobSuccess_VC : BottomViewControllerBase

@property (nonatomic, copy) NSString* jobId;          //C岗位的jobId，String
@property (nonatomic, copy) NSNumber *jobStatus;    /*!< 岗位状态 0待提交审核 1待审核, 2已发布, 3已关闭*/
@property (nonatomic, copy) NSNumber *is_need_recommend;    /*!< 是否需要人才推荐 */
@property (nonatomic, strong) JobModel *jobModel;
@property (nonatomic, strong) CityModel *cityModel;

//弃用
@property (nonatomic, copy) NSNumber *guaranteeAmount;  /*!< 保证金缴纳金额 */
@property (nonatomic, copy) NSString *jobTitle; /*!< 岗位标题 */


@end
