//
//  XSJADHelper.m
//  jianke
//
//  Created by xiaomk on 16/8/23.
//  Copyright © 2016年 xianshijian. All rights reserved.
//

#import "XSJADHelper.h"
#import "XSJConst.h"


static NSString* const WDUserDefault_baiduSSPBanner     = @"WDUserDefault_baiduSSPBanner";
static NSString* const WDUserDefault_ssp_homeJobList     = @"WDUserDefault_ssp_homeJobList";
static NSString* const WDUserDefault_ssp_applySuccess     = @"WDUserDefault_ssp_applySuccess";


@implementation XSJADHelper

+ (BOOL)getAdIsShowWithType:(XSJADType)adType{
    ClientGlobalInfoRM *globalModel = [[XSJRequestHelper sharedInstance] getClientGlobalModel];

    NSString* SSPCloseDate;
    
    if (adType == XSJADType_jobDetail) {
        if (globalModel && globalModel.ad_on_off.job_detail_third_party_ad_open.integerValue != 1) {
            return NO;
        }
        SSPCloseDate = [WDUserDefaults stringForKey:WDUserDefault_baiduSSPBanner];
    }else if (adType == XSJADType_homeJobList){
        if (globalModel && globalModel.ad_on_off.job_list_third_party_ad_open.integerValue != 1) {
            return NO;
        }
        SSPCloseDate = [WDUserDefaults stringForKey:WDUserDefault_ssp_homeJobList];
        return NO;      //产品那边还没 申请到ssp 数据流的广告，先默认关闭；
    }else if (adType == XSJADType_applySuccess){
        if (globalModel && globalModel.ad_on_off.job_apply_success_third_party_ad_open.integerValue != 1) {
            return NO;
        }
        SSPCloseDate = [WDUserDefaults stringForKey:WDUserDefault_ssp_applySuccess];
    }
    
    long long time = [DateHelper getTimeStamp4Second];
    NSString* todayDate = [DateHelper getDateFromTimeString:[NSString stringWithFormat:@"%lld",time]];
    BOOL ret = ![SSPCloseDate isEqualToString:todayDate];
    return ret;
}

+ (void)closeAdWithADType:(XSJADType)adType{

    long long time = [DateHelper getTimeStamp4Second];
    NSString* todayDate = [DateHelper getDateFromTimeString:[NSString stringWithFormat:@"%lld",time]];
    if (adType == XSJADType_jobDetail) {
        [WDUserDefaults setObject:todayDate forKey:WDUserDefault_baiduSSPBanner];
    }else if (adType == XSJADType_homeJobList){
        [WDUserDefaults setObject:todayDate forKey:WDUserDefault_ssp_homeJobList];
    }else if (adType == XSJADType_applySuccess){
        [WDUserDefaults setObject:todayDate forKey:WDUserDefault_ssp_applySuccess];
    }
    [WDUserDefaults synchronize];
}
@end
