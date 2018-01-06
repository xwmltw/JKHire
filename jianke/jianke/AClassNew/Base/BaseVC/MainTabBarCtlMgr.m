//
//  MainTabBarCtlMgr.m
//  jianke
//
//  Created by xiaomk on 16/6/14.
//  Copyright © 2016年 xianshijian. All rights reserved.
//

#import "MainTabBarCtlMgr.h"

#import "IMHome_VC.h"
#import "MyInfo_VC.h"
#import "WDConst.h"

#import "JobManage_VC.h"
#import "ServiceMange_VC.h"
#import "ServiceCenter_VC.h"
#import "PersonServiceMag_VC.h"
#import "TeamServiceMag_VC.h"
#import "MarketServiceMag_VC.h"
#import "JobMsgCenter_VC.h"
#import "TalentPool_VC.h"

@interface MainTabBarCtlMgr()<UITabBarControllerDelegate>{
    TabBarSwitchVC _nextVC;
}
@property (nonatomic, strong) UITabBarController *rootTabbarCtl;
@end

@implementation MainTabBarCtlMgr

Impl_SharedInstance(MainTabBarCtlMgr);

- (UITabBarController *)creatEPTabbar{

    JobMsgCenter_VC *vc1 = [[JobMsgCenter_VC  alloc] init];
    MainNavigation_VC *nav1 = [[MainNavigation_VC alloc] initWithRootViewController:vc1];
    nav1.tabBarItem.image = [UIImage imageNamed:@"service_manage_normal"];
    nav1.tabBarItem.selectedImage = [[UIImage imageNamed:@"service_manage_selected"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    nav1.tabBarItem.title = @"首页";
    [nav1.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor XSJColor_tGrayDeepTinge]} forState:UIControlStateSelected];
    
    TalentPool_VC *vc2 = [[TalentPool_VC alloc] init];
    MainNavigation_VC *nav2 = [[MainNavigation_VC alloc] initWithRootViewController:vc2];
    nav2.tabBarItem.image = [UIImage imageNamed:@"job_icon_selectTabBar"];
    nav2.tabBarItem.selectedImage = [[UIImage imageNamed:@"job_icon_tabBar"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    nav2.tabBarItem.title = @"人才库";
    [nav2.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor XSJColor_tGrayDeepTinge]} forState:UIControlStateSelected];
    
    IMHome_VC *vc3 = [[IMHome_VC  alloc] init];
    MainNavigation_VC *nav3 = [[MainNavigation_VC alloc] initWithRootViewController:vc3];
    nav3.tabBarItem.image = [UIImage imageNamed:@"message_tabItem_normal"];
    nav3.tabBarItem.selectedImage = [[UIImage imageNamed:@"message_tabItem_selected"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    nav3.tabBarItem.title = @"消息";
    [nav3.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor XSJColor_tGrayDeepTinge]} forState:UIControlStateSelected];
    
    MyInfo_VC *vc4 = [[MyInfo_VC alloc] init];
    MainNavigation_VC *nav4 = [[MainNavigation_VC alloc] initWithRootViewController:vc4];
    nav4.tabBarItem.image = [UIImage imageNamed:@"profile_tabItem_normal"];
    nav4.tabBarItem.selectedImage = [[UIImage imageNamed:@"profile_tabItem_selected"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    nav4.tabBarItem.title = @"我";
    [nav4.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor XSJColor_tGrayDeepTinge]} forState:UIControlStateSelected];
    
    self.rootTabbarCtl.viewControllers = nil;
    if (self.rootTabbarCtl.presentedViewController) {
        [self.rootTabbarCtl dismissViewControllerAnimated:NO completion:nil];
    }
    [self.rootTabbarCtl.tabBar clearAllSmallBadge];
    self.rootTabbarCtl.viewControllers = @[nav1, nav2, nav3, nav4];
    
    return self.rootTabbarCtl;

}

- (UITabBarController *)rootTabbarCtl{
    if (!_rootTabbarCtl) {
        _rootTabbarCtl = [[UITabBarController alloc] init];
        _rootTabbarCtl.tabBar.tintColor = [UIColor XSJColor_base];
        _rootTabbarCtl.delegate = self;
        _rootTabbarCtl.tabBar.translucent = NO;
    }
    return _rootTabbarCtl;
}

- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController{
    if ([viewController isKindOfClass:[MainNavigation_VC class]]) {
        MainNavigation_VC *nav = (MainNavigation_VC *)viewController;
        if (nav.childViewControllers.count > 0) {
            if ([[nav.childViewControllers firstObject] isKindOfClass:[IMHome_VC class]]){
                if (![[UserData sharedInstance] isLogin]) {
                    _nextVC = TabBarSwitchVC_EPIM;
                    [self showLoginView];
                    return NO;
                }
            }else if ([[nav.childViewControllers firstObject] isKindOfClass:[TalentPool_VC class]]){
                [TalkingData trackEvent:@"底部菜单_人才库"];
                if (![[UserData sharedInstance] isLogin]) {
                    _nextVC = TabBarSwitchVC_ServiceManage;
                    [self showLoginView];
                    return NO;
                }
            }else if ([[nav.childViewControllers firstObject] isKindOfClass:[MyInfo_VC class]]){
                if (![[UserData sharedInstance] isLogin]) {
                    _nextVC = TabBarSwitchVC_MyInfo;
                    [self showLoginView];
                    return NO;
                }
            }
        }
    }
    return YES;
}

- (void)showLoginView{
    WEAKSELF
    [[UserData sharedInstance] userIsLogin:^(id result) {
        if (result) {
            [weakSelf showVC];
        }else{
            _nextVC = TabBarSwitchVC_None;
        }
    }];

}
- (void)showVC{
    if (_nextVC < 0)  return;
    NSInteger index = -1;
    switch (_nextVC) {
        case TabBarSwitchVC_EPIM:
            index = 2;
            break;
        case TabBarSwitchVC_ServiceManage:
            index = 1;
            break;
        case TabBarSwitchVC_MyInfo:
            index = 3;
            break;
        default:
            break;
    }
    if (index >= 0 && index < self.rootTabbarCtl.viewControllers.count) {
        [self.rootTabbarCtl setSelectedIndex:index];
    }
}

- (void)setSelectWithIndex:(NSInteger)index{
    if (self.rootTabbarCtl.viewControllers.count > index) {
        [self.rootTabbarCtl setSelectedIndex:index];
    }
}

- (void)setSelectMsgTab{
    [self setSelectWithIndex:2];
}

- (void)setManageVisibleAtIndex:(NSInteger)showIndex{
    self.rootTabbarCtl.selectedIndex = 1;
    MainNavigation_VC *nav = [self.rootTabbarCtl.viewControllers objectAtIndex:1];
    nav.view;
    [nav popToRootViewControllerAnimated:YES];
    ServiceMange_VC *vc = nav.viewControllers.firstObject;
    vc.selectedIndex = showIndex;
}

@end
