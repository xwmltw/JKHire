//
//  ModelManage.m
//  JKHire
//
//  Created by fire on 16/10/14.
//  Copyright © 2016年 xianshijian. All rights reserved.
//

#import "ModelManage.h"

@implementation ModelManage

+ (ServicePersonType)getServiceTypeFromNSNumber:(NSNumber *)number{
    switch (number.integerValue) {
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

+ (NSString *)getJobClassfiyNameWithServiceType:(NSNumber *)serviceType{
    switch (serviceType.integerValue) {
        case 1:
            return @"模特人员";
        case 2:
            return @"礼仪人员";
        case 3:
            return @"主持人员";
        case 4:
            return @"商演人员";
        case 5:
            return @"家庭教师";
        case 6:
            return @"校园代理";
        case 7:
            return @"促销人员";
        default:
            return @"请填写岗位类型";
    }
}

+ (NSString *)getJobTagNameWithServiceType:(NSNumber *)serviceType{
    switch (serviceType.integerValue) {
        case 1:
            return @"模特";
        case 2:
            return @"礼仪";
        case 3:
            return @"主持";
        case 4:
            return @"商演";
        case 5:
            return @"家教";
        case 6:
            return @"代理";
        case 7:
            return @"促销员";
        default:
            return @"请填写岗位类型";
    }
}

+ (NSNumber *)getServiceTypeWithEnmu:(ServicePersonType)type{
    switch (type) {
        case ServicePersonType_Lady:
            return @(2);
        case ServicePersonType_model:
            return @(1);
        case ServicePersonType_teacher:
            return @(5);
        case ServicePersonType_delegate:
            return @(6);
        case ServicePersonType_actor:
            return @(4);
        case ServicePersonType_reporter:
            return @(3);

        case ServicePersonType_saler:
            return @(7);
        default:
            return @(0);
            break;
    }
}

@end
