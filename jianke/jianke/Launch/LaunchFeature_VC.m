//
//  NewFeature_VC.m
//  JKHire
//
//  Created by xuzhi on 16/10/11.
//  Copyright © 2016年 xianshijian. All rights reserved.
//

#import "LaunchFeature_VC.h"
#import "UserData.h"
#import "XSJNotifyHelper.h"
#import "NewFeature_VC.h"

@interface LaunchFeature_VC ()

@end

@implementation LaunchFeature_VC

- (void)viewDidLoad {
    [super viewDidLoad];
//    [UserData sharedInstance].hiddenNewFeature = NO;   //隐藏新特性页面
//    //添加广告界面
//    NSString* lastVersion = [WDUserDefaults stringForKey:WDUserDefault_CFBundleVersion];
//    NSString* currentVersion = [MKDeviceHelper getAppBundleVersion];
//    if (![currentVersion isEqualToString:lastVersion]) {     //新版本
//        //设置第一次登录状态
//        if ([[UserData sharedInstance] getLoginType].integerValue != WDLoginType_Employer) {
//            [[XSJUserInfoData sharedInstance] setIsOpenAppYet:NO];
//        }
//        [WDUserDefaults setObject:currentVersion forKey:WDUserDefault_CFBundleVersion];
//        [WDUserDefaults setBool:YES forKey:NewFeatureAboutBindWechat];
//        [WDUserDefaults setBool:NO forKey:LoginSuccessNoticeBindWechat];
//        [WDUserDefaults synchronize];
//        //是否隐藏新特性
//        if (![UserData sharedInstance].hiddenNewFeature) {
//            NewFeature_VC* vc = [[NewFeature_VC alloc] init];
//            [UIHelper setKeyWindowWithVC:vc];
//        }else{
//            [self requestADInfo];
//        }
//    }else{                                                  //旧版本
//        [WDUserDefaults setBool:NO forKey:NewFeatureAboutBindWechat];
//        [self requestADInfo];
//    }
    
}

- (void)btnOnClick:(UIButton *)sender{
    MKBlockExec(self.callBack, nil);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
