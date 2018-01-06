//
//  TeamSerMagCenter_VC.h
//  JKHire
//
//  Created by fire on 16/10/21.
//  Copyright © 2016年 xianshijian. All rights reserved.
//

#import "BottomViewControllerBase.h"
#import "TeamJobModel.h"

@interface TeamSerMagCenter_VC : BottomViewControllerBase

@property (nonatomic, copy) NSNumber *service_team_job_id;  /*!< 团队服务需求id */
@property (nonatomic, copy) MKBlock block;

@end
