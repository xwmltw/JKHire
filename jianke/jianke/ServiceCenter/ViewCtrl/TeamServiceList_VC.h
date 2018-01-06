//
//  TeamServiceList_VC.h
//  JKHire
//
//  Created by fire on 16/10/14.
//  Copyright © 2016年 xianshijian. All rights reserved.
//

#import "BottomViewControllerBase.h"

@interface TeamServiceList_VC : BottomViewControllerBase

@property (nonatomic, copy) NSNumber *cityId;
@property (nonatomic, copy) NSNumber *service_classify_id;
@property (nonatomic, copy) NSString *service_classify_name;
@property (nonatomic, copy) NSNumber *service_team_job_id;

@property (nonatomic, assign) BOOL isPopToPrevious;
@property (nonatomic, copy) MKBlock block;

@end
