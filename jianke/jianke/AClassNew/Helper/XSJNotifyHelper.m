//
//  XSJNotifyHelper.m
//  jianke
//
//  Created by fire on 16/9/10.
//  Copyright © 2016年 xianshijian. All rights reserved.
//

#import "XSJNotifyHelper.h"
#import "AppDelegate.h"
#import "WebView_VC.h"
#import "MainTabBarCtlMgr.h"
#import "XSJLocalNotificationMgr.h"
#import "Login_VC.h"

@implementation XSJNotifyHelper

+ (void)handleLocalNotification:(NSDictionary *)userInfo{
    if (userInfo) {
        NSInteger type = [[userInfo valueForKey:@"localNotificationType"] integerValue];
        if (type) {
            switch (type) {
                case LocalNotifTypeText:{
                    [[MainTabBarCtlMgr sharedInstance] setSelectMsgTab];
                }
                    break;
                case LocalNotifTypeUrl:{    //处理URL
                    [self handleRemoteWithUrl:userInfo];
                }
                    break;
                default:
                    break;
            }
        }
    }
}

+ (void)handleRemoteWithUrl:(NSDictionary *)userInfo{
    if (!userInfo) {
        return;
    }
    //jpush推送
    NSString *jpushExtrasFlag = [userInfo valueForKey:@"flg"];
    if (jpushExtrasFlag) {
        [WDUserDefaults setObject:userInfo forKey:@"jiguangtuisong"];
        switch (jpushExtrasFlag.integerValue) {
            case 1:{
                NSString *jpushExtrasUrl = [userInfo valueForKey:@"url"];
                [self showNitifyOnWebWithUrl:jpushExtrasUrl block:nil];
            }
                break;
        }
        return;
    }
    
    [self handleRemoteWithUrl:userInfo clickBlock:^(NSString *messageId) {
        ELog(@"发送message_id");
        [[XSJRequestHelper sharedInstance] noticeBoardPushLogClickRecord:messageId block:^(id result) {
            
        }];
    }];
    
}

+ (void)handleRemoteWithUrl:(NSDictionary *)userInfo clickBlock:(MKBlock)clickBlock{
    if (!userInfo) {
        return;
    }
    //rc推送 app内打开
    [self updateBudgeIcon:1];
    NSString *response = [userInfo objectForKey:@"appData"]; //融云扩展字段,不可改
    if (!response) {
        return;
    }
    NSData *data = [response dataUsingEncoding:NSUTF8StringEncoding];
    NSError *error = nil;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
    if (error) {
        return;
    }
    NSNumber *noticeType = [dic objectForKey:@"notice_type"];
    switch (noticeType.integerValue) {
        case WdSystemNoticeType_noticeBoardMessage:{
            NSString *url = [dic objectForKey:@"open_url"];
            NSString *messageId = [dic objectForKey:@"message_id"];
            [self showNitifyOnWebWithUrl:url block:^(id result) {
                if (messageId) {
                    MKBlockExec(clickBlock, messageId);
                }
            }];
            
        }
            break;
            
        default:{
            [self switchToImPage];
        }
            break;
    }

}

+ (void)switchToImPage{
    
    [[UserData sharedInstance] getUserStatus:^(UserLoginStatus loginStatus) {
        switch (loginStatus) {
            case UserLoginStatus_canAutoLogin:
            case UserLoginStatus_loginSuccess:{
                [[MainTabBarCtlMgr sharedInstance] setSelectMsgTab];
            }
                break;
            case UserLoginStatus_needManualLogin:{
                [self showLoginVC];
            }
            default:
                break;
        }
    }];
}

+ (void)showLoginVC{
    Login_VC* loginVC = [UIHelper getVCFromStoryboard:@"Main" identify:@"sid_main_login"];
    MainNavigation_VC* vc = [[MainNavigation_VC alloc] initWithRootViewController:loginVC];
    loginVC.blcok = ^(id result){
        [[MainTabBarCtlMgr sharedInstance] setSelectMsgTab];
    };
    UIViewController *viewCtrl = [MKUIHelper getTopViewController];
    if (viewCtrl) {
        [viewCtrl presentViewController:vc animated:YES completion:^{
            
        }];
    }
}

+ (void)showNitifyOnWebWithUrl:(NSString *)url block:(MKBlock)block{
     UIViewController *viewCtrl = [MKUIHelper getTopViewController];
    if (viewCtrl && viewCtrl.navigationController && url) {
        WebView_VC *webVc = [[WebView_VC alloc] init];
        webVc.url = url;
        webVc.hidesBottomBarWhenPushed = YES;
        [viewCtrl.navigationController pushViewController:webVc animated:YES];
        MKBlockExec(block, nil);
    }
}

//+ (UIViewController *)getCurrentVC{
////    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
////    if (appDelegate.currentViewCtrl && appDelegate.currentViewCtrl.navigationController) {
////        return appDelegate.currentViewCtrl;
////    }else{
////        return appDelegate.currentViewCtrl;
////    }
//    UIViewController *viewCtrl = [MKUIHelper getCurrentRootViewController];
//    if ([viewCtrl isKindOfClass:[UITabBarController class]]) {
//        UITabBarController *tabVC = (UITabBarController *)viewCtrl;
//        UIViewController *VC = [tabVC selectedViewController];
//    }
//    return nil;
//}

+ (void)updateBudgeIcon:(NSInteger)count{
    NSInteger budgeCount = [UIApplication sharedApplication].applicationIconBadgeNumber - count;
    if (budgeCount < 0) {
        [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    }else{
        [UIApplication sharedApplication].applicationIconBadgeNumber = budgeCount;
    }
}

@end
