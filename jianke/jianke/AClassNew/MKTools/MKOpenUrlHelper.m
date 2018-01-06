//
//  MKOpenUrlHelper.m
//  HHDevelopSolutions
//
//  Created by xiaomk on 16/4/7.
//  Copyright © 2016年 xiaomk. All rights reserved.
//

#import "MKOpenUrlHelper.h"
#import "UIHelper.h"
#import "MKAlertView.h"


@interface MKOpenUrlHelper()

@property (nonatomic, strong) UIWebView *phoneWebView;
@property (nonatomic, copy) MKBlock block;

@end

@implementation MKOpenUrlHelper

Impl_SharedInstance(MKOpenUrlHelper);

+ (void)openQQWithNumber:(NSString*)qqNumber onViewController:(UIViewController*)vc block:(MKBoolBlock)block{
    if (![[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"mqq://"]]) {
        if (block) {
            block(NO);
        }
        return;
    }
    if (!qqNumber.length) {
        return;
    }
    NSString* urlStr = [NSString stringWithFormat:@"mqq://im/chat?chat_type=wpa&uin=%@&version=1&src_type=web",qqNumber];

    UIWebView* webView = [[UIWebView alloc] initWithFrame:CGRectZero];
    [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:urlStr]]];
    //    webView.delegate = self;
    [vc.view addSubview:webView];
}

/** 拨打电话 */
- (void)callWithPhone:(NSString *)phone{
    if (!self.phoneWebView) {
        self.phoneWebView = [[UIWebView alloc] initWithFrame:CGRectZero];
    }
    [self.phoneWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@", phone]]]];
}

/** 拨打电话 -- NSURL */
- (void)callWithPhoneUrl:(NSURL *)phoneUrl{
    if (!self.phoneWebView) {
        self.phoneWebView = [[UIWebView alloc] initWithFrame:CGRectZero];
    }
    [self.phoneWebView loadRequest:[NSURLRequest requestWithURL:phoneUrl]];
}

/** 拨打电话（系统） */
- (void)makeAlertCallWithPhone:(NSString *)phone block:(MKBlock)block{
    self.block = block;

    
    if ([self validateCurrentMobileSystem10_2]) {
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",phone]];
        if ([[UIApplication sharedApplication] canOpenURL:url]) {
            
            [[UIApplication sharedApplication] openURL:url];
           //GCD
            dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0/*延迟执行时间*/ * NSEC_PER_SEC));
            
            dispatch_after(delayTime, dispatch_get_main_queue(), ^{
                MKBlockExec(self.block, nil);
            });
            
        }else{
            [UIHelper toast:@"请确认设备是否支持拨打电话，是否插入SIM卡"];
        }
    }else{
        [MKAlertView alertWithTitle:phone message:nil cancelButtonTitle:@"取消" confirmButtonTitle:@"呼叫" completion:^(UIAlertView *alertView, NSInteger buttonIndex) {
            if (buttonIndex == 1) {
                NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",phone]];
                if ([[UIApplication sharedApplication] canOpenURL:url]) {
                    
                    [[UIApplication sharedApplication] openURL:url];
                    
                    
                    //GCD
                    dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0/*延迟执行时间*/ * NSEC_PER_SEC));
                    
                    dispatch_after(delayTime, dispatch_get_main_queue(), ^{
                        MKBlockExec(self.block, nil);
                    });
                    
                    
                }else{
                    [UIHelper toast:@"请确认设备是否支持拨打电话，是否插入SIM卡"];
                }
            }
        }];
    }
    
}

//判断当前系统版本
- (BOOL)validateCurrentMobileSystem10_2{
    NSString *str2 = [[UIDevice currentDevice] systemVersion];
    if ([str2 compare:@"10.2" options:NSNumericSearch] == NSOrderedDescending || [str2 compare:@"10.2" options:NSNumericSearch] == NSOrderedSame) {
        return YES;
    }
    return NO;

}

- (void)makeCallWithPhone:(NSString *)phone{
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",phone]];
    if ([[UIApplication sharedApplication] canOpenURL:url]) {
        [[UIApplication sharedApplication] openURL:url];
//    [self makeAlertCallWithPhone:phone block:nil];
    }
}

/** 打开itunes */
- (void)openItunesWithUrl:(NSURL *)url{
    if (!self.phoneWebView) {
        self.phoneWebView = [[UIWebView alloc] initWithFrame:CGRectZero];
    }
    [self.phoneWebView loadRequest:[NSURLRequest requestWithURL:url]];
}

@end
