//
//  ModelManage.h
//  JKHire
//
//  Created by fire on 16/10/14.
//  Copyright © 2016年 xianshijian. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MyEnum.h"

@interface ModelManage : NSObject

/** 根据服务器支持的个人服务Type获取对应枚举 */
+ (ServicePersonType)getServiceTypeFromNSNumber:(NSNumber *)number;

/** 根据服务器支持的个人服务Type获取对应需求类型名称 */
+ (NSString *)getJobClassfiyNameWithServiceType:(NSNumber *)serviceType;

/** 根据服务器支持的个人服务Type获取对应需求类型名称(tag) */
+ (NSString *)getJobTagNameWithServiceType:(NSNumber *)serviceType;

/** 首页枚举转NSNumber */
+ (NSNumber *)getServiceTypeWithEnmu:(ServicePersonType)type;

@end
