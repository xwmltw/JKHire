//
//  ClientGlobalInfoRM.m
//  jianke
//
//  Created by xiaomk on 16/5/16.
//  Copyright © 2016年 xianshijian. All rights reserved.
//

#import "ClientGlobalInfoRM.h"
#import "MJExtension.h"

@implementation ClientGlobalInfoRM
MJCodingImplementation
- (NSDictionary *)objectClassInArray{
    return @{@"service_type_classify_list" : [serviceTypeClassify class], @"industry_info_list": [IndustryInfoList class]};
}
@end

@implementation ShareModel
MJCodingImplementation
@end

@implementation AdOnOffModel
MJCodingImplementation
@end

@implementation WapUrlModel
MJCodingImplementation
@end

@implementation serviceTypeClassify
MJCodingImplementation
@end

@implementation CityRecruitJobNumPrice
MJCodingImplementation
@end

@implementation IndustryInfoList
MJCodingImplementation
@end
