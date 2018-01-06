//
//  JobModel.m
//  jianke
//
//  Created by xiaomk on 15/9/16.
//  Copyright (c) 2015年 xianshijian. All rights reserved.
//

#import "JobModel.h"
#import "MJExtension.h"

@implementation JobModel
MJCodingImplementation

/** 判断是否已读,并设置相应字段readed */
- (void)checkReadStateWithReadedJobIdArray:(NSArray *)jobIdArray{
    for (NSString *jobId in jobIdArray) {
        if ([jobId isEqualToString:self.job_id.stringValue]) {
            self.readed = YES;
        }
    }
}

- (ServicePersonType)getServiceTypeEnum{
    switch (self.service_type.integerValue) {
        case 1:
            return ServicePersonType_model;
        case 2:
            return ServicePersonType_Lady;
        case 3:
            return ServicePersonType_reporter;
        case 4:
            return ServicePersonType_actor;
        case 5:
            return ServicePersonType_teacher;
        case 6:
            return ServicePersonType_delegate;
        case 7:
            return ServicePersonType_saler;
        default:
            return 0;
    }
}

- (NSDictionary *)objectClassInArray{
    return @{@"job_tags" : [WelfareModel class]};
}

@end



@implementation ExpectOnBoardStuCountModel
MJCodingImplementation
@end
