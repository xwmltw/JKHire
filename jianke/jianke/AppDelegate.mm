//
//  AppDelegate.m
//  jianke
//
//  Created by xiaomk on 15/9/2.
//  Copyright (c) 2015年 xianshijian. All rights reserved.
//

#import "AppDelegate.h"

#import "UMSocial.h"
#import "UMSocialQQHandler.h"
#import "UMSocialWechatHandler.h"
#import "UMSocialSinaSSOHandler.h"
#import "TencentOpenAPI/TencentOAuthObject.h"
#import "WeiboSDK.h"
#import "WXApi.h"
#import "AlipaySDK/AlipaySDK.h"
// 引入JPush功能所需头文件
#import "JPUSHService.h"
// iOS10注册APNs所需头文件
#ifdef NSFoundationVersionNumber_iOS_9_x_Max
#import <UserNotifications/UserNotifications.h>
#endif

#import <RongIMKit/RongIMKit.h>
#import <RongIMLib/RongIMLib.h>
#import <MapKit/MapKit.h>
#import <MAMapKit/MAMapKit.h>
#import <AMapSearchKit/AMapSearchKit.h>
#import <AMapLocationKit/AMapLocationKit.h>
#import <Foundation/NSException.h>

#import "TalkingDataAppCpa.h"
#import "TalkingData.h"
#import "IQKeyboardManager.h"
#import "AFNetworkReachabilityManager.h"
#import "JKTextMessage.h"
#import "MKFPSStatus.h"

#import "WDConst.h"
#import "XSJUserInfoData.h"
#import "XSJRequestHelper.h"

#import "XSJLocalNotificationMgr.h"

#import "ImDataManager.h"
#import "MainTabBarCtlMgr.h"
#import "XSJNotifyHelper.h"

#import "NewFeature_VC.h"
#import "LaunchManage.h"
#import "XZNewFeature_VC.h"
#import "TmpViewCtrl.h"
#import "MKDeviceHelper.h"


@interface AppDelegate () <WXApiDelegate, WeiboSDKDelegate, JPUSHRegisterDelegate>

@end

@implementation AppDelegate

#pragma mark - ***** didFinishLaunchingWithOptions ******
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    
    [self startNetworkCheck];

    [self initThirdPartySDK:launchOptions];

    [self changeWebViewUserAgent];
    
    //数据补偿，统计等  启动马上执行的一些操作
    [[XSJUserInfoData sharedInstance] versionUserDataCompensate];

    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
    
    //Required
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 10.0) {
        JPUSHRegisterEntity * entity = [[JPUSHRegisterEntity alloc] init];
        entity.types = UNAuthorizationOptionAlert|UNAuthorizationOptionBadge|UNAuthorizationOptionSound;
        [JPUSHService registerForRemoteNotificationConfig:entity delegate:self];
    }
    else if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
        //可以添加自定义categories
        [JPUSHService registerForRemoteNotificationTypes:(UIUserNotificationTypeBadge |
                                                          UIUserNotificationTypeSound |
                                                          UIUserNotificationTypeAlert)
                                              categories:nil];
    }
    else {
        //categories 必须为nil
        [JPUSHService registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge |
                                                          UIRemoteNotificationTypeSound |
                                                          UIRemoteNotificationTypeAlert)
                                              categories:nil];
    }
    
    [JPUSHService setDebugMode];

    //点击 APNS推送 启动app
    NSDictionary* pushInfo = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
    [application setStatusBarHidden:YES withAnimation:UIStatusBarAnimationNone];
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.rootViewController = [[TmpViewCtrl alloc] init];
    
    [LaunchManage createSession:^(BOOL isShowNewFeature) {
        if (isShowNewFeature) {
            NSArray *array = @[@"new_feature_0", @"new_feature_1", @"new_feature_2", @"new_feature_3"];
            XZNewFeature_VC *rootVC = [[XZNewFeature_VC alloc] initWithImgArr:array];
            self.window.rootViewController = rootVC;
        }else{
            self.window.rootViewController = [[MainTabBarCtlMgr sharedInstance] creatEPTabbar];
            [application setStatusBarHidden:NO withAnimation:UIStatusBarAnimationNone];
            [XSJNotifyHelper handleRemoteWithUrl:pushInfo];
        }
    }];
    
    [self.window makeKeyAndVisible];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    ELog(@"//////app  0  applicationWillResignActive");
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    //进入后台 //添加本地通知
    ELog(@"//////app  1  applicationDidEnterBackground");
    [XSJUserInfoData sharedInstance].didEnterBackground = YES;
//    [XSJLocalNotificationMgr registerLoaclNotification];
    
    NSInteger msgCount = [[ImDataManager sharedInstance] getUnreadMsgCount];
    ELog(@"//////app  2  msgCount : %ld", (long)msgCount);
    
    if (msgCount >= 0) {
        [UIApplication sharedApplication].applicationIconBadgeNumber = msgCount;
    }
    
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    //进入前台取消应用消息图标
    ELog(@"//////app  3  applicationWillEnterForeground");
    [XSJUserInfoData sharedInstance].didEnterBackground = NO;
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
    [WDNotificationCenter postNotificationName:WDNotification_ApplicationWillEnterForeground object:nil];
}


//进入前台
- (void)applicationDidBecomeActive:(UIApplication *)application {
    ELog(@"//////app  4  applicationDidBecomeActive");
    
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    ELog(@"//////app  5  applicationWillTerminate");
    [[ImDataManager sharedInstance] loginOutRCIM];
    
}


//获取到推送信息-后台或者活跃状态
//接收到远程推送通知
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo{
    ELog("/////////// application didReceiveRemoteNotification");
    // Required, iOS 7 Support
    [JPUSHService handleRemoteNotification:userInfo];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    ELog("/////////// application didReceiveRemoteNotification");
    // Required, iOS 7 Support
    [JPUSHService handleRemoteNotification:userInfo];
    completionHandler(UIBackgroundFetchResultNewData);
}


//接收本地通知
- (void)application:(UIApplication *)application didReceiveLocalNotification:(nonnull UILocalNotification *)notification{
    NSDictionary *userInfo = notification.userInfo;
    ELog(@"app 前后台 接收点击本地通知事件， userInfo:%@",userInfo);
    if ([UIApplication sharedApplication].applicationState == UIApplicationStateInactive) {
        [XSJNotifyHelper handleLocalNotification:userInfo];
    }
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url{
    return [TencentOAuth HandleOpenURL:url] || [WeiboSDK handleOpenURL:url delegate:self] || [WXApi handleOpenURL:url delegate:self];
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation{
 
    if ([TencentOAuth HandleOpenURL:url] || [WeiboSDK handleOpenURL:url delegate:self] || [WXApi handleOpenURL:url delegate:self]) {
        return YES;
    }else{
        if ([url.host isEqualToString:@"safepay"]) {
            ELog("/////////// alipay  safepay")
            [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
                ELog(@"/////////// 1 result = %@",resultDic);
                NSMutableDictionary *userInfo = [NSMutableDictionary dictionaryWithDictionary:resultDic];
            [WDNotificationCenter postNotificationName:AlipayResponseNotification object:nil userInfo:userInfo];
            }];
        }else if ([url.host isEqualToString:@"platformapi"]) {
            ELog("/////////// alipay  platformapi")
            [[AlipaySDK defaultService] processAuthResult:url standbyCallback:^(NSDictionary *resultDic) {
                ELog(@"/////////// 2 result = %@",resultDic);
////                NSLog(@"result = %@",resultDic);
//                NSMutableDictionary *userInfo = [NSMutableDictionary dictionaryWithDictionary:resultDic];
//                [WDNotificationCenter postNotificationName:AlipayResponseNotification object:weakSelf userInfo:userInfo];
            }];
        }else if ([url.host isEqualToString:@"tel"]){
            
        }
        return YES;
    }
}

/**
 * 推送处理2    注册用户通知设置
 */
- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings{
    ELog("/////////// 2.推送-注册用户通知设置");
    [application registerForRemoteNotifications];
}

/**
 * 推送处理3
 */
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken{
    if (deviceToken) {
        NSString *token = [[[[deviceToken description] stringByReplacingOccurrencesOfString:@"<" withString:@""]
                            stringByReplacingOccurrencesOfString:@">" withString:@""]
                           stringByReplacingOccurrencesOfString:@" " withString:@""];
        [[RCIMClient sharedRCIMClient] setDeviceToken:token];
        ELog("/////////// 3.推送-DeviceToken 设置给融云");
        ELog("/////////// token:%@:",token);
        /// Required - 注册 DeviceToken
        [JPUSHService registerDeviceToken:deviceToken];
        [JPUSHService registrationIDCompletionHandler:^(int resCode, NSString *registrationID) {
            if (registrationID && registrationID.length) {
                [UserData sharedInstance].registrationID = registrationID;
            }
        }];
    }
}

//推送注册失败
- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error{
    ELog(@"/////////// did Fail To Register For Remote Notifications With Error: %@", error);
}

//- (void)application:(UIApplication *)application performFetchWithCompletionHandler:(nonnull void (^)(UIBackgroundFetchResult))completionHandler{
//    ELog(@"/////////// performFetchWithCompletionHandler");
////    completionHandler(UIBackgroundFetchResultNewData);
//}

#pragma mark- JPUSHRegisterDelegate

// iOS 10 Support
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(NSInteger))completionHandler {
    // Required
    NSDictionary * userInfo = notification.request.content.userInfo;
    if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [JPUSHService handleRemoteNotification:userInfo];
    }
    else {
        // 本地通知
    }
    completionHandler(UNNotificationPresentationOptionAlert); // 需要执行这个方法，选择是否提醒用户，有Badge、Sound、Alert三种类型可以选择设置
}

// iOS 10 Support
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler {
    // Required
    NSDictionary * userInfo = response.notification.request.content.userInfo;
    if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [JPUSHService handleRemoteNotification:userInfo];
        if ([UIApplication sharedApplication].applicationState != UIApplicationStateInactive) {
            [XSJNotifyHelper handleRemoteWithUrl:userInfo];
        }
    }
    else {
        // 本地通知
        if ([UIApplication sharedApplication].applicationState == UIApplicationStateInactive) {
            [XSJNotifyHelper handleLocalNotification:userInfo];
        }
        
    }
    completionHandler();  // 系统要求执行这个方法
}

#pragma mark - ***** 推送跳转 ******
- (void)treateRemoteNotification:(NSDictionary *)dicInfo{
    [[UserData sharedInstance] userIsLogin:^(id result) {
        if (result) {
            UIViewController* current = [MKUIHelper getCurrentRootViewController];
            if ([current isKindOfClass:[UINavigationController class]]) {
                UINavigationController* nav = (UINavigationController*)current;
                [nav popToRootViewControllerAnimated:NO];
                [UIHelper openInsterJobVCWithRootVC:nav.topViewController];
            }
        }
    }];
}

#pragma mark - ***** 微博授权回调 ******
- (void)didReceiveWeiboResponse:(WBBaseResponse *)response{
//    WBAuthorizeResponse *resp = (WBAuthorizeResponse *)response;
    NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
    userInfo[WBLoginGetRespInfo] = response;
    [[NSNotificationCenter defaultCenter] postNotificationName:WBLoginGetRespNotification object:self userInfo:userInfo];
}

- (void)didReceiveWeiboRequest:(WBBaseRequest *)request{
    
}

#pragma mark - ***** 微信授权回调 ******
- (void)onResp:(BaseResp *)resp{
    /*
     ErrCode ERR_OK = 0(用户同意)
     ERR_AUTH_DENIED = -4（用户拒绝授权）
     ERR_USER_CANCEL = -2（用户取消）
     code    用户换取access_token的code，仅在ErrCode为0时有效
     state   第三方程序发送时用来标识其请求的唯一性的标志，由第三方程序调用sendReq时传入，由微信终端回传，state字符串长度不能超过1K
     lang    微信客户端当前语言
     country 微信用户当前国家信息
      */
    if ([resp isKindOfClass:[PayResp class]]) {
        PayResp* response = (PayResp*)resp;
        ELog(@"/////////// wx PayResp onResp:errCode:%d",response.errCode);
        switch (response.errCode) {
            case WXSuccess:
            {
                NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
//                userInfo[WXPayGetCodeInfo] = response.code;
                [WDNotificationCenter postNotificationName:WXPayGetCodeNotification object:self userInfo:userInfo];
                ELog("///////////支付成功");
                break;
            }
            case WXErrCodeCommon:
                [TalkingData trackEvent:@"支付成功/支付失败"];
                [UIHelper toast:@"支付失败"];
                break;
            case WXErrCodeUserCancel: // 用户取消
                [TalkingData trackEvent:@"支付成功/支付失败"];
                [UIHelper toast:@"您已取消"];
                break;
            case WXErrCodeSentFail:
                [TalkingData trackEvent:@"支付成功/支付失败"];
                [UIHelper toast:@"发送失败"];
                break;
            case WXErrCodeAuthDeny:
                [TalkingData trackEvent:@"支付成功/支付失败"];
                [UIHelper toast:@"你已拒绝授权"];
                break;
            case WXErrCodeUnsupport:
                [TalkingData trackEvent:@"支付成功/支付失败"];
                [UIHelper toast:@"微信不支持"];
                break;
            default:
                [TalkingData trackEvent:@"支付成功/支付失败"];
                ELog(@"///////////支付失败，retcode=%d",resp.errCode);
                break;
        }
    }else{
        if ([resp isKindOfClass:[SendMessageToWXResp class]]) {
            return;
        }
        
        SendAuthResp* response = (SendAuthResp *)resp;
        ELog(@"/////////// wx onResp:errCode:%d",response.errCode);
        switch (response.errCode) {
            case WXSuccess:     //用户同意
            {
                ELog(@"用户同意");
                // 发送通知
                if ([response.state isEqualToString:@"EPBindWX"]) { // 企业绑定微信时获取Code
                    NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
                    userInfo[EPGetWXCodeInfo] = response.code;
                    [WDNotificationCenter postNotificationName:EPGetWXCodeNotification object:self userInfo:userInfo];
                    
                } else if ([response.state isEqualToString:@"JKBindWX"]) { // 兼客绑定微信时获取Code
                    NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
                    userInfo[JKGetWXCodeInfo] = response.code;
                    [WDNotificationCenter postNotificationName:JKGetWXCodeNotification object:self userInfo:userInfo];
                    
                } else if ([response.state isEqualToString:@"WXlogin"]) {  // 第三方微信登陆时获取Code
                    NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
                    userInfo[WXLoginGetCodeInfo] = response.code;
                    [WDNotificationCenter postNotificationName:WXLoginGetCodeNotification object:self userInfo:userInfo];
                    
                } else if ([response.state isEqualToString:@"WXGetMoney"]){
                    NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
                    userInfo[WXGetMoneyGetCodeInfo] = response.code;
                    [WDNotificationCenter postNotificationName:WXGetMoneyGetCodeNotification object:self userInfo:userInfo];
                }
            }
                break;
            case WXErrCodeCommon:
                [UIHelper toast:@"授权失败"];
                break;
            case WXErrCodeUserCancel: // 用户取消
                [UIHelper toast:@"你已取消"];
                break;
            case WXErrCodeSentFail:
                [UIHelper toast:@"发送失败"];
                break;
            case WXErrCodeAuthDeny:
                [UIHelper toast:@"你已拒绝授权"];
                break;
            case WXErrCodeUnsupport:
                [UIHelper toast:@"微信不支持"];
                break;
            default:
                ELog(@"/////////// wx onResp:errCode:%d",response.errCode);
                break;
        }
    }
}

- (void)onReq:(BaseReq *)req{
    ELog("/////////// wx req:%@", req);
}

#pragma mark - *********** 修改 webView navigator.userAgent
- (void)changeWebViewUserAgent{
    UIWebView* webView = [[UIWebView alloc] init];
    NSString* secretAgent = [webView stringByEvaluatingJavaScriptFromString:@"navigator.userAgent"];
//    ELog(@"userAgent:%@",secretAgent)
    NSString *newUagent = [NSString stringWithFormat:@"%@ iOS_Jianke YouPin_%d",secretAgent, [MKDeviceHelper getAppIntVersion]];
    [WDUserDefaults registerDefaults:@{@"UserAgent":newUagent}];
    [WDUserDefaults synchronize];
    ELog(@"/////////// UserAgent = %@", [webView stringByEvaluatingJavaScriptFromString:@"navigator.userAgent"]);
}

#pragma mark - ***** 初始化 第三方 SDK ******
- (void)initThirdPartySDK:(NSDictionary *)launchOptions{
    
    //高德地图
    [MAMapServices sharedServices].apiKey = kGDMAP_AppKey;
    [AMapSearchServices sharedServices].apiKey = kGDMAP_AppKey;
    [AMapLocationServices sharedServices].apiKey = kGDMAP_AppKey;
    
    //talkingData
    [TalkingData setExceptionReportEnabled:YES];
    [TalkingData sessionStarted:kTalkingData_AppID withChannelId:JKAPP_PLATFORM];
//    [TalkingDataAppCpa init:kTD_AdTrackingID withChannelId:JKAPP_PLATFORM];

    //极光推送
    [JPUSHService setupWithOption:launchOptions appKey:kJPush_AppKey
                          channel:kJPush_Chanel
                 apsForProduction:kJPush_isProduction
            advertisingIdentifier:nil];
    //微博
    [WeiboSDK enableDebugMode:NO];
    [WeiboSDK registerApp:kWB_AppId];

    //微信
    [WXApi registerApp:kWX_AppId];
    [WXApi registerApp:kWX_AppId withDescription:@"youPin_iOS"];

    //友盟
    [UMSocialData setAppKey:kUM_Key];
//
    [UMSocialQQHandler setQQWithAppId:kQQ_AppId appKey:kQQ_AppKey url:kQQ_AppUrl];
    [UMSocialWechatHandler setWXAppId:kWX_AppId appSecret:kWX_AppSecret url:kWX_AppUrl];
    [UMSocialConfig hiddenNotInstallPlatforms:@[UMShareToQQ,UMShareToQzone,UMShareToWechatSession,UMShareToWechatTimeline]];
    [UMSocialSinaSSOHandler openNewSinaSSOWithAppKey:kWB_AppId secret:kWB_AppSecret RedirectURL:@"http://sns.whalecloud.com/sina2/callback"];
    [UMSocialSinaSSOHandler openNewSinaSSOWithRedirectURL:@"http://sns.whalecloud.com/sina2/callback"];

    //融云
    [[RCIM sharedRCIM] initWithAppKey:kRC_AppKey];
    [[RCIM sharedRCIM] registerMessageType:[JKTextMessage class]];
    
    [IQKeyboardManager sharedManager].enable = YES;
//    
//    //JSPatch
//    [JSPatch setupLogger:^(NSString *msg) {
//        ELog(@"JSPatch输出日志：%@", msg);
//    }];
//    [JSPatch startWithAppKey:kJSPatch_AppKey];
//    [JSPatch setupRSAPublicKey:KJSPatch_publicKey];
//#ifdef DEBUG
//    [JSPatch setupDevelopment];
//#endif
//    [JSPatch sync];
}

#pragma mark - ***** 网络检查 ******
- (void)startNetworkCheck{
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
    [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        switch (status) {
            case AFNetworkReachabilityStatusUnknown:
                ELog(@"/////////// 未知网络");
                break;
            case AFNetworkReachabilityStatusNotReachable:
                ELog(@"/////////// 无网络");
                [UIHelper toast:@"网络连接不可用"];
                [XSJRequestHelper sharedInstance].isLostNetwork = YES;
                break;
            case AFNetworkReachabilityStatusReachableViaWiFi:
                [[XSJRequestHelper sharedInstance] connectNetworkAgain];
                ELog(@"/////////// WiFi网络");
                break;
            case AFNetworkReachabilityStatusReachableViaWWAN:
                ELog(@"/////////// 移动网络");
                [[XSJRequestHelper sharedInstance] connectNetworkAgain];
                break;
            default:
                ELog(@"/////////// 其他网络");
                break;
        }
    }];
}
@end
