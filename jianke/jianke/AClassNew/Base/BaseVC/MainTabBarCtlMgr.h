//
//  MainTabBarCtlMgr.h
//  jianke
//
//  Created by xiaomk on 16/6/14.
//  Copyright © 2016年 xianshijian. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, TabBarSwitchVC) {
    TabBarSwitchVC_None             = -1,
    TabBarSwitchVC_ServiceManage = 1,
    TabBarSwitchVC_EPIM,
    TabBarSwitchVC_MyInfo,
};

@interface MainTabBarCtlMgr : NSObject

+ (instancetype)sharedInstance;


- (UITabBarController *)creatEPTabbar;

- (void)setSelectWithIndex:(NSInteger)index;

- (void)setSelectMsgTab;

- (void)setManageVisibleAtIndex:(NSInteger)showIndex;

@end
