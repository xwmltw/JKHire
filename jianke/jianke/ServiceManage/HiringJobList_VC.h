//
//  HiringJobList_VC.h
//  JKHire
//
//  Created by yanqb on 2017/2/8.
//  Copyright © 2017年 xianshijian. All rights reserved.
//

#import "BottomViewControllerBase.h"

@interface HiringJobList_VC : BottomViewControllerBase

@property (nonatomic, strong) RecruitJobNumInfo *model;
@property (nonatomic, copy) NSNumber *cityId;   /*!< 可为空 */
@property (nonatomic, assign) BOOL isFromPost;  /*!< 是否来自发布成功页面，和cityid一起用 */

@end
