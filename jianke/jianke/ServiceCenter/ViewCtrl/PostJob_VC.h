//
//  PostJob_VC.h
//  jianke
//
//  Created by xiaomk on 16/4/18.
//  Copyright © 2016年 xianshijian. All rights reserved.
//

#import "MKBaseTableViewController.h"
#import "WDConst.h"
#import "JobClassifyInfoModel.h"

@class CityModel, JobModel;

@interface PostJob_VC : MKBaseTableViewController

@property (nonatomic, assign) PostJobType postJobType;  /*!< 岗位发布类型 */
@property (nonatomic, assign) BOOL isShowTip;   /*!< 从个人服务商或者团队进来的 需要顶部提醒业务 */
@property (nonatomic, copy) NSArray* jobClassArray;        /*!< 获取岗位分类列表  */
@property (nonatomic, strong) JobClassifyInfoModel *jobClassifyInfoModel;    /*!< 选择的岗位类型 */

@property (nonatomic, strong) JobModel *myPostJobModel; /*!< 快捷发布时的岗位模型 */
@property (nonatomic, copy) NSNumber *jobId;    /*!< 岗位ID */
@property (nonatomic, assign) BOOL isEditAction;    /*!< 是否是编辑岗位 */
@property (nonatomic, assign) BOOL isUpload;    /*!< 是否是上架岗位 */

@property (nonatomic, copy) MKBlock block;

@end
