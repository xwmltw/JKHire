//
//  LaunchManage.m
//  JKHire
//
//  Created by fire on 16/10/11.
//  Copyright © 2016年 xianshijian. All rights reserved.
//

#import "LaunchManage.h"
#import "UserData.h"
#import "NewFeature_VC.h"

@implementation LaunchManage

+ (void)createSession:(MKBoolBlock)block{
    [[UserData sharedInstance] setLoginStatus:NO];
    
    WEAKSELF
    int versionInt = [MKDeviceHelper getAppIntVersion];
    [[XSJNetWork sharedInstance] createSession:^(id response) {
        [[XSJRequestHelper sharedInstance] postDeviceInfoWithBlock:^(id obj) {
            [[XSJRequestHelper sharedInstance] getClientGlobalInfoMust:YES withBlock:^(ClientGlobalInfoRM* result) {
                if (result) {
                    //检查版本更新
                    ClientVersionModel* cvmModel = result.version_info;
                    if (cvmModel && cvmModel.version.intValue > versionInt) {
                        if (cvmModel.need_force_update.integerValue == 1) {
                            [UIHelper showConfirmMsg:@"有新的版本啦，请更新到最新版本吧！" title:@"提示" cancelButton:@"更新" completion:^(DLAVAlertView *alertView, NSInteger buttonIndex) {
                                if (buttonIndex == 0) {
                                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:cvmModel.url]];
                                }
                            }];
                        }else{
                            [UIHelper showConfirmMsg:@"有新的版本啦，请更新到最新版本吧！" title:@"提示" cancelButton:@"暂不更新" okButton:@"更新" completion:^(DLAVAlertView *alertView, NSInteger buttonIndex) {
                                if (buttonIndex == 0) {
                                    [weakSelf showNewFeature:block];
                                }else if(buttonIndex == 1){
                                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:cvmModel.url]];
                                }
                            }];
                        }
                        return ;
                    }
                }
                [weakSelf showNewFeature:block];
            }];
        }];
    }];
}

+ (void)showNewFeature:(MKBoolBlock)block{
    NSString* lastVersion = [WDUserDefaults stringForKey:WDUserDefault_CFBundleVersion];
    NSString* currentVersion = [MKDeviceHelper getAppBundleVersion];
    if (![currentVersion isEqualToString:lastVersion]) {     //新版本
        //设置第一次登录状态
        
        [WDUserDefaults setObject:currentVersion forKey:WDUserDefault_CFBundleVersion];
        [WDUserDefaults setBool:YES forKey:NewFeatureAboutBindWechat];  //微信关联
        [WDUserDefaults setBool:NO forKey:LoginSuccessNoticeBindWechat];
        [WDUserDefaults synchronize];
        //是否隐藏新特性
        if (![UserData sharedInstance].hiddenNewFeature) {
            MKBlockExec(block, YES);
            return;
        }
    }else{                                                  //旧版本
        [WDUserDefaults setBool:NO forKey:NewFeatureAboutBindWechat];
    }
    MKBlockExec(block, NO);
}

@end
