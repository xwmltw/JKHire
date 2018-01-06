//
//  XZOpenUrlHelper.m
//  jianke
//
//  Created by fire on 16/9/30.
//  Copyright © 2016年 xianshijian. All rights reserved.
//

#import "XZOpenUrlHelper.h"
#import "UserData.h"

@implementation XZOpenUrlHelper

+ (void)openJobDetailWithblock:(MKBlock)block{
//     [[UserData sharedInstance] setJobUuid:query];
    NSString *jobUuid = [UserData sharedInstance].jobUuid;
    if (jobUuid.length < 1) {
        return;
    }
    MKBlockExec(block, jobUuid);
    [UserData sharedInstance].jobUuid = nil;
}

@end
