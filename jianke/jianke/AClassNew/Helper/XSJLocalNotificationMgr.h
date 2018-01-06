//
//  XSJLocalNotificationMgr.h
//  jianke
//
//  Created by xiaomk on 16/7/29.
//  Copyright © 2016年 xianshijian. All rights reserved.
//



#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, LocalNotifType) {
    LocalNotifTypeText = 1,
    LocalNotifTypeUrl
};

@class ImPacket;
@interface XSJLocalNotificationMgr : NSObject

+ (void)registerLoaclNotification;
+ (void)registerLocalNotificationWithImMessage:(ImPacket *)packet;
+ (void)registerLocalNotificationWithImMessage:(ImPacket *)packet isShowInIM:(BOOL)isShowInIm notifType:(LocalNotifType)type;
+ (void)removeAllLocalNotification;


@end
