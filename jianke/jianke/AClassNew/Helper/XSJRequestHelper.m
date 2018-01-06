//
//  XSJRequestHelper.m
//  jianke
//
//  Created by xiaomk on 16/5/16.
//  Copyright © 2016年 xianshijian. All rights reserved.
//

#import "XSJRequestHelper.h"
#import "XSJConst.h"
#import <AdSupport/AdSupport.h>
#import "ResponseInfo.h"
#import "ReportRecordModel.h"
#import "JobModel.h"
#import "PayDetailModel.h"
#import "PostJobModel.h"
#import "NSString+XZExtension.h"
#import "PostJobModel.h"

@interface XSJRequestHelper(){
    
}

@end

static ClientGlobalInfoRM *s_clientGlobalInfoModel = nil;   /*!< 全局配置信息 */

@implementation XSJRequestHelper

Impl_SharedInstance(XSJRequestHelper);

#pragma mark - ***** 网络端开后从新 连接上网络 ******
- (void)connectNetworkAgain{
    if (self.isLostNetwork) {
        self.isLostNetwork = NO;
        [self getClientGlobalInfoWithBlock:^(id result) {
            
        }];
    }
}



#pragma mark - ***** 自动登录 ******

/** 自动登录 */
- (void)activateAutoLoginWithBlock:(MKBlock)block{
    if (![[UserData sharedInstance] getIsLogoutActive] && ![[UserData sharedInstance] isLogin]) {
        [[XSJRequestHelper sharedInstance] autoLogin:^(ResponseInfo *result) {
            if (!result) {
                [UserData sharedInstance].loginFail = YES;
                [WDNotificationCenter postNotificationName:WDNotification_userLoginFail object:nil];
            }
            MKBlockExec(block, result);
        }];
    }else{
        MKBlockExec(block, nil);
    }
}

- (void)autoLogin:(MKBlock)block{
    NSString *userName = [[XSJUserInfoData sharedInstance] getUserInfo].userPhone;
    NSString *password = [[XSJUserInfoData sharedInstance] getUserInfo].password;
    if (password && password.length > 0) {
        [self loginWithUsername:userName pwd:password loginPwdType:LoginPwdType_commonPassword isShowNetworkErr:NO bolck:block];
    }else{
        NSString *password = [[XSJUserInfoData sharedInstance] getUserInfo].dynamicPassword;
        if (password && password.length > 0) {
            [self loginWithUsername:userName pwd:password loginPwdType:LoginPwdType_dynamicPassword isShowNetworkErr:NO bolck:block];
        }else{
            MKBlockExec(block, nil);
        }
    }
}

- (void)loginWithUsername:(NSString*)userName pwd:(NSString*)password bolck:(MKBlock)block{
    [self loginWithUsername:userName pwd:password loginPwdType:LoginPwdType_commonPassword isShowNetworkErr:YES bolck:block];
}

- (void)loginWithUsername:(NSString*)userName pwd:(NSString *)password loginPwdType:(LoginPwdType)loginPwdType bolck:(MKBlock)block{
    [self loginWithUsername:userName pwd:password loginPwdType:loginPwdType isShowNetworkErr:YES bolck:block];
}

- (void)loginWithUsername:(NSString *)userName pwd:(NSString *)password loginPwdType:(LoginPwdType)loginPwdType isShowNetworkErr:(BOOL)isShowNetworkErr bolck:(MKBlock)block{
    [self loginWithUsername:userName pwd:password loginPwdType:loginPwdType isShowNetworkErr:isShowNetworkErr isUpdateEpInfo:NO bolck:block];
}

- (void)loginWithUsername:(NSString *)userName pwd:(NSString *)password loginPwdType:(LoginPwdType)loginPwdType isShowNetworkErr:(BOOL)isShowNetworkErr isUpdateEpInfo:(BOOL)isUpdateEpInfo bolck:(MKBlock)block{
    if (userName.length > 0 && password.length > 0) {
        NSNumber* loginType = [[UserData sharedInstance] getLoginType];
        if (loginType.intValue == 0) {
            loginType = [NSNumber numberWithInt:WDLoginType_JianKe];
        }
        
        UserLoginPM* model = [[UserLoginPM alloc] init];
        model.username = userName;
        model.user_type = loginType;
        
        if (loginPwdType == LoginPwdType_dynamicSmsCode) {          /*!< 动态验证码 */
            model.dynamic_sms_code = password;
        }else if (loginPwdType == LoginPwdType_dynamicPassword){    /*!< 动态密码 */
            NSString *pass = [[[NSString stringWithFormat:@"%@%@", password, [XSJNetWork getChallenge]] MD5] uppercaseString];
            model.dynamic_password = pass;
        }else if (loginPwdType == LoginPwdType_commonPassword){     /*!< 普通密码 */
            NSString *pass = [[[NSString stringWithFormat:@"%@%@", password, [XSJNetWork getChallenge]] MD5] uppercaseString];
            model.password = pass;
        }
        NSString* content = [model getContent];
        
        RequestInfo *request = [[RequestInfo alloc] initWithService:@"shijianke_userLogin" andContent:content];
        request.isShowLoading = isShowNetworkErr;
        request.isShowErrorMsg = isShowNetworkErr;
        if (loginPwdType == LoginPwdType_dynamicSmsCode) {
            request.isShowErrorMsg = NO;
        }
        [request sendRequestWithResponseBlock:^(ResponseInfo* response) {
            if (response && [response success]) {

                [[UserData sharedInstance] setLoginStatus:YES];
                [[UserData sharedInstance] setLogoutActive:NO];
                NSNumber *userId = [response.content objectForKey:@"id"];
                [[UserData sharedInstance] setUserId:userId];
                [[UserData sharedInstance] setLoginType:loginType];
                
                if (loginPwdType == LoginPwdType_dynamicSmsCode) {          /*!< 动态验证码 */
                    NSString *dynamicPassword = [response.content objectForKey:@"dynamic_password"];
                    [[XSJUserInfoData sharedInstance] savePhone:userName password:nil dynamicPassword:dynamicPassword];
                }else if (loginPwdType == LoginPwdType_commonPassword){
                    [[XSJUserInfoData sharedInstance] savePhone:userName password:password dynamicPassword:nil];
                }else if (loginPwdType == LoginPwdType_dynamicPassword){
                    [[XSJUserInfoData sharedInstance] savePhone:userName password:nil dynamicPassword:password];
                }
                
                [TalkingDataAppCpa onLogin:userName];
                
                [[XSJRequestHelper sharedInstance] getClientGlobalInfoWithBlock:^(id result) {
                    if (isUpdateEpInfo) {
                        [[UserData sharedInstance] getEPModelWithShowLoading:YES block:^(id result) {
                            if (isShowNetworkErr) {
                                [UIHelper toast:@"登录成功"];
                            }
                            MKBlockExec(block, response);
                        }];
                    }else{
                        if (isShowNetworkErr) {
                            [UIHelper toast:@"登录成功"];
                        }
                        MKBlockExec(block, response);
                    }
                }];
            }else{
                if (loginPwdType == LoginPwdType_dynamicSmsCode && response ) {    //动态密码登录  用户不存在
                    if (response.errCode.integerValue == 8) {
                        MKBlockExec(block, response);
                        return ;
                    }else if (response.errCode.integerValue == 9){
                        [UIHelper toast:@"请输入正确的动态密码"];
                        return ;
                    }
                }
                MKBlockExec(block, nil);
            }
        }];
    }else{
        MKBlockExec(block, nil);
    }
}

#pragma mark - ***** 获取验证码 ******
//"opt_type" :  操作类型  , 1 注册 , 2 找回密码 , 3 修改手机号码  -- 注册 (1) 判断 是否已经被注册 , (2): 判断 号码是否存在 , (3): 判断 是否已经被注册 .
//"user_type" : 用户类型 ,  1:企业 ，2:学生 , --}

- (void)getAuthNumWithPhoneNum:(NSString*)phoneNum andBlock:(MKBlock)block withOPT:(WdVarifyCodeOptType)optType userType:(NSNumber*)userType{
    GetSmsAuthenticationCodePM* model = [[GetSmsAuthenticationCodePM alloc] init];
    model.phone_num = phoneNum;
    model.opt_type = optType;
    model.user_type = userType;
    NSString* content = [model getContent];
    
    RequestInfo* request = [[RequestInfo alloc] initWithService:@"shijianke_getSmsAuthenticationCode" andContent:content];
    request.isShowLoading = YES;
    request.loadingMessage = @"获取验证码...";
    [request sendRequestWithResponseBlock:^(ResponseInfo* response) {
        if (response && [response success]) {
            MKBlockExec(block,nil);
        }
    }];
}

#pragma mark - ***** 获取全局配置信息 ******
- (void)getClientGlobalInfoWithBlock:(MKBlock)block{
    [self getClientGlobalInfoMust:NO withBlock:block];
}

- (void)getClientGlobalInfoMust:(BOOL)must withBlock:(MKBlock)block{
    if (!must && s_clientGlobalInfoModel) {
        block(s_clientGlobalInfoModel);
    }else{
        GetClientGlobalPM* model = [[GetClientGlobalPM alloc] init];
        model.city_id = [[UserData sharedInstance] city] ? [[UserData sharedInstance] city].id : @(211);
        model.client_type = [XSJUserInfoData getClientType];
        int versionInt = [MKDeviceHelper getAppIntVersion];
        model.app_version_code = @(versionInt);
        model.product_type = [XSJUserInfoData getProductType];
        NSString* content = [model getContent];
        RequestInfo *request = [[RequestInfo alloc] initWithService:@"shijianke_getClientGlobalInfo309" andContent:content];
        request.isShowLoading = NO;
        [request sendRequestWithResponseBlock:^(ResponseInfo* response) {
            if (response && [response success]) {
                ClientGlobalInfoRM* model = [ClientGlobalInfoRM objectWithKeyValues:response.content];
                if (model) {
                    s_clientGlobalInfoModel = model;
                    MKBlockExec(block,model)
                    return ;
                }
            }
            MKBlockExec(block,nil)
        }];
    }
}

- (ClientGlobalInfoRM*)getClientGlobalModel{
    if (s_clientGlobalInfoModel) {
        return s_clientGlobalInfoModel;
    }
    return nil;
}

static NSString* const XSJUserDefault_IDFA  = @"XSJUserDefault_IDFA";

/** 保存设备信息 */
- (void)postDeviceInfoWithBlock:(MKBlock)block{
    NSString *idfaStr = [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
    NSString *oldIDFA = [WDUserDefaults objectForKey:XSJUserDefault_IDFA];
    if (oldIDFA && [oldIDFA isEqualToString:idfaStr]) {
        MKBlockExec(block, @"1");
    }else{
        ActivateDeviceModel *model = [[ActivateDeviceModel alloc] init];
        model.system = [MKDeviceHelper getSysVersionString];
        model.uid = [UIDeviceHardware getUUID];
        model.dev_name = [MKDeviceHelper getPlatformString];
        model.idfa = idfaStr;
        NSString *content = [model getContent];
        RequestInfo *request = [[RequestInfo alloc] initWithService:@"shijianke_postIosDevInfo" andContent:content];
        request.isShowLoading = NO;
        request.isShowErrorMsg = NO;
        [request sendRequestWithResponseBlock:^(id response) {
            if (response) {
                [WDUserDefaults setObject:idfaStr forKey:XSJUserDefault_IDFA];
                [WDUserDefaults synchronize];
                MKBlockExec(block, response);
            }else{
                MKBlockExec(block, nil);
            }
        }];
    }
}

/** 查询钱袋子账户信息 */
- (void)queryAccountMoneyWithBlock:(MKBlock)block{
    RequestInfo *request = [[RequestInfo alloc] initWithService:@"shijianke_queryAccountMoney" andContent:@""];
    request.isShowLoading = NO;
    request.isShowNetworkErrorMsg = NO;
    [request sendRequestWithResponseBlock:^(ResponseInfo *response) {
        MKBlockExec(block,response);
    }];
}

/** 拨打免费电话 */
- (void)callFreePhoneWithCalled:(NSString *)called block:(MKBlock)block{
    FreeCallPM *model = [[FreeCallPM alloc] init];
    model.plat_type = @(1);
    model.caller = [[XSJUserInfoData sharedInstance] getUserInfo].userPhone;
    model.called = called;
    model.opt_type = @(0);
    NSString* content = [model getContent];
    
    WEAKSELF
    [self requestCallFreeWithContent:content block:^(ResponseInfo* response) {
        if (response && [response success]) {
            NSNumber *leftTime = response.content[@"left_can_call"];
            if (leftTime.integerValue > 0) {
                NSString *msg = [NSString stringWithFormat:@"您剩余免费电话时间:%ld分钟",((leftTime.integerValue-1)/60)+1];
                DLAVAlertView *alertView = [[DLAVAlertView alloc] initWithTitle:@"拨打电话" message:msg delegate:nil cancelButtonTitle:nil otherButtonTitles:@"免费电话", @"直接拨打",@"取消",nil];
                [alertView showWithCompletion:^(DLAVAlertView *alertView, NSInteger buttonIndex) {
                    if (buttonIndex == 0) {
                        model.opt_type = @(1);
                        NSString *content2 = [model getContent];
                        [weakSelf requestCallFreeWithContent:content2 block:^(ResponseInfo* response) {
                            if (response && [response success]) {
                                NSNumber *isCanCall = response.content[@"is_can_call"];
                                if (isCanCall.integerValue == 1) {
                                    [UIHelper toast:@"开始拨号..."];
                                    return ;
                                }
                            }
                            [UIHelper toast:@"免费电话拨打失败"];
                            [[MKOpenUrlHelper sharedInstance] callWithPhone:called];
                        }];
                    }else if (buttonIndex == 1){
                        [[MKOpenUrlHelper sharedInstance] callWithPhone:called];
                    }
                }];
                return ;
            }
        }
        [[MKOpenUrlHelper sharedInstance] callWithPhone:called];
    }];
}

- (void)requestCallFreeWithContent:(NSString *)content block:(MKBlock)block{
    RequestInfo *request = [[RequestInfo alloc] initWithService:@"shijianke_callFreePhone" andContent:content];
    request.isShowLoading = YES;
//    request.isShowNetworkErrorMsg = YES;
    [request sendRequestWithResponseBlock:^(ResponseInfo *response) {
        MKBlockExec(block,response);
    }];
}

/** 雇主查询打卡请求接口 */
- (void)entQueryPunchRequestList:(EntQueryPunch *)punch block:(MKBlock)block{
    NSString *content = [punch getContent];
    RequestInfo *request=[[RequestInfo alloc] initWithService:@"shijianke_entQueryPunchRequestList" andContent:content];
    [request sendRequestWithResponseBlock:^(ResponseInfo *response) {
        if (response && response.success) {
            PunchClockModel *result = [PunchClockModel objectWithKeyValues:response.content];
            MKBlockExec(block,result);
        }else{
            MKBlockExec(block,nil);
        }
    }];
}


/** 雇主发起点名接口 */
- (void)entIssuePunchRequest:(NSString *)job_id clockTime:(NSString *)date block:(MKBlock)block{
    NSString *contet = [NSString stringWithFormat:@"job_id:%@,punch_the_clock_time:%@",job_id,date];
    RequestInfo *request = [[RequestInfo alloc] initWithService:@"shijianke_entIssuePunchRequest" andContent:contet];
    [request sendRequestWithResponseBlock:^(ResponseInfo *response) {
        if (response.success) {
            MKBlockExec(block,response);
        }
    }];
}

/** 雇主结束打卡接口 */
- (void)entClosePunchRequest:(NSString *)request_id block:(MKBlock)block{
    NSString *content = [NSString stringWithFormat:@"punch_the_clock_request_id:%@",request_id];
    RequestInfo *request = [[RequestInfo alloc] initWithService:@"shijianke_entClosePunchRequest" andContent:content];
    [request sendRequestWithResponseBlock:^(ResponseInfo *response) {
        if (response.success) {
            MKBlockExec(block,response);
        }
    }];
}

/** 签到列表接口 */
- (void)entQueryStuPunchTheClockRecord:(EntQueryStuPunch *)param block:(MKBlock)block{
    NSString *content = [param getContent];
    RequestInfo *request = [[RequestInfo alloc] initWithService:@"shijianke_entQueryStuPunchTheClockRecord" andContent:content];
    [request sendRequestWithResponseBlock:^(ResponseInfo *response) {
        if (response.success) {
            if (block) {
                QueryClockRecordList *rrModel = [QueryClockRecordList objectWithKeyValues:response.content];
                MKBlockExec(block,rrModel);
            }
        }
    }];
}

/** 修改支付列表接口 */
- (void)entChangeSalaryUnConfirmStu:(NSString *)itemId withTel:(NSString *)telphone withTrueName:(NSString *)name block:(MKBlock)block{
    NSString *content = [NSString stringWithFormat:@"\"item_id\":\"%@\",\"telphone\":\"%@\",\"true_name\":\"%@\"",itemId,telphone,name];
    RequestInfo *request = [[RequestInfo alloc] initWithService:@"shijianke_entChangeSalaryUnConfirmStu" andContent:content];
    [request sendRequestWithResponseBlock:^(ResponseInfo *response) {
        if (response.success) {
            MKBlockExec(block,response);
        }
    }];
}

/** 猜你喜欢接口 */
- (void)getJobListGuessYouLike:(GetJobLikeParam *)param block:(MKBlock)block{
    NSString *content = [param getContent];
    RequestInfo *request = [[RequestInfo alloc] initWithService:@"shijianke_getJobListGuessYouLike" andContent:content];
    [request sendRequestWithResponseBlock:^(ResponseInfo *response) {
        if (response.success) {
            NSArray *jobList = [JobModel objectArrayWithKeyValuesArray:[response.content objectForKey:@"job_list"]];
            MKBlockExec(block,jobList);
        }
    }];
}

/** 招聘余额接口 */
- (void)queryAcctVirtualDetailList:(QueryParamModel *)param block:(MKBlock)block{
    NSString *content = [param getContent];
    RequestInfo *request = [[RequestInfo alloc] initWithService:@"shijianke_queryAcctVirtualDetailList" andContent:content];
    [request sendRequestWithResponseBlock:^(ResponseInfo *response) {
        if (response && response.success) {
            if (block) {
                AcctVirtualResponseModel *acctVirtualList = [AcctVirtualResponseModel objectWithKeyValues:response.content];
                MKBlockExec(block,acctVirtualList);
            }
        }else{
            MKBlockExec(block,nil);
        }
    }];
}

/** 招聘余额转入接口 */
- (void)rechargeRecruitmentAmount:(PayJobInfoModel *)param block:(MKBlock)block{
    NSString *content = [param getContent];
    RequestInfo *request = [[RequestInfo alloc] initWithService:@"shijianke_rechargeRecruitmentAmount" andContent:content];
    [request sendRequestWithResponseBlock:^(ResponseInfo *response) {
        if (response.success) {
            MKBlockExec(block,response);
        }
    }];
}

/** 用户虚拟账户流水明细查询 */
- (void)queryAcctVirtualDetailItem:(DetailItmeParam *)param block:(MKBlock)block{
    NSString *content = [param getContent];
    RequestInfo *request = [[RequestInfo alloc] initWithService:@"shijianke_queryAcctVirtualDetailItem" andContent:content];
    [request sendRequestWithResponseBlock:^(ResponseInfo *response) {
        if (response.success) {
            if (block) {
                NSArray *result = [PayDetailModel objectArrayWithKeyValuesArray:[response.content objectForKey:@"stu_list"]];
                MKBlockExec(block,result);
            }
        }else{
            MKBlockExec(block,nil);
        }
    }];
}

/** 兼客获取自己的最新认证信息 */
- (void)getLatestVerifyInfo:(MKBlock)block{
    RequestInfo *request = [[RequestInfo alloc] initWithService:@"shijianke_getLatestVerifyInfo" andContent:nil];
    request.isShowLoading = YES;
    [request sendRequestWithResponseBlock:^(ResponseInfo *response) {
        if (response && response.success) {
            if (block) {
                MKBlockExec(block,response);
            }
        }else{
            MKBlockExec(block,nil);
        }
    }];
}

/** 收藏岗位 */
- (void)collectJob:(NSString *)jobId block:(MKBlock)block{
    NSString *content = [NSString stringWithFormat:@"job_id:%@",jobId];
    RequestInfo *request = [[RequestInfo alloc] initWithService:@"shijianke_collectJob" andContent:content];
    [request sendRequestWithResponseBlock:^(ResponseInfo *response) {
        if (response && response.success) {
            MKBlockExec(block, response);
        }else{
            MKBlockExec(block, nil);
        }
    }];
}

/** 取消收藏岗位 loading */
- (void)cancelCollectedJob:(NSString *)jobId isShowLoding:(BOOL)isShowLoding block:(MKBlock)block{
    NSString *content = [NSString stringWithFormat:@"job_id:%@",jobId];
    RequestInfo *request = [[RequestInfo alloc] initWithService:@"shijianke_cancelCollectedJob" andContent:content];
    request.isShowLoading = isShowLoding;
    [request sendRequestWithResponseBlock:^(ResponseInfo *response) {
        if (response && response.success) {
            MKBlockExec(block, response);
        }else{
            MKBlockExec(block, nil);
        }
    }];
}


/** 取消收藏岗位 */
- (void)cancelCollectedJob:(NSString *)jobId block:(MKBlock)block{
    [self cancelCollectedJob:jobId isShowLoding:NO block:block];
}

/** 查询收藏岗位列表 */
- (void)getCollectedJobList:(QueryParamModel *)queryParam block:(MKBlock)block{
    NSString *content = [queryParam getContent];
    RequestInfo *request = [[RequestInfo alloc] initWithService:@"shijianke_getCollectedJobList" andContent:content];
    [request sendRequestWithResponseBlock:^(ResponseInfo *response) {
        if (response && response.success) {
            NSArray *result = [JobModel objectArrayWithKeyValuesArray:[response.content objectForKey:@"parttime_job_list"]];
            MKBlockExec(block, result);
        }else{
            MKBlockExec(block, nil);
        }
    }];
}

/** 账户交易流水查询 */
- (void)queryAccDetail:(QueryParamModel *)queryParam moneyDetailType:(NSNumber *)moneyDetailType withJobId:(NSString *)jobId block:(MKBlock)block{
    NSString *content = [NSString stringWithFormat:@"%@,job_id:%@",[queryParam getContent],jobId];
    if (moneyDetailType) {
        content = [content stringByAppendingFormat:@", money_detail_type:%@", moneyDetailType];
    }
    RequestInfo *request = [[RequestInfo alloc] initWithService:@"shijianke_queryAcctDetail_v2" andContent:content];
    [request sendRequestWithResponseBlock:^(ResponseInfo *response) {
        MKBlockExec(block, response);
    }];
}

/** 广告点击日志接口 */
- (void)queryAdClickLogRecordWithADId:(NSNumber *)AdId{
    NSString *content = [NSString stringWithFormat:@"ad_id:%@",AdId];
    RequestInfo *request = [[RequestInfo alloc] initWithService:@"shijianke_adClickLogRecord" andContent:content];
    [request sendRequestWithResponseBlock:^(ResponseInfo *response) {
        ELog(@" ad_id : %@",AdId);
    }];
}

/** 人脉王岗位推送开关 */
- (void)openSocialActivistJobPush:(NSString *)optType block:(MKBlock)block{
    RequestInfo *request = [[RequestInfo alloc] initWithService:@"shijianke_openSocialActivistJobPush" andContent:[NSString stringWithFormat:@"opt_type:%@",optType]];
    [request sendRequestWithResponseBlock:^(ResponseInfo *response) {
        if (response && response.success) {
            MKBlockExec(block, response);
        }else{
            MKBlockExec(block, nil);
        }

    }];
}

/** 获取人脉王任务列表 */
- (void)getSocialActivistTaskList:(NSString *)inHistory queryParam:(QueryParamModel *)param block:(MKBlock)block{
    NSString *content = [NSString stringWithFormat:@"\"in_history\":\"%@\"",inHistory];
    if (param) {
        content = [NSString stringWithFormat:@"%@,%@",[param getContent], content];
    }
    RequestInfo *request = [[RequestInfo alloc]initWithService:@"shijianke_getSocialActivistTaskList" andContent:content];
    [request sendRequestWithResponseBlock:^(ResponseInfo *response) {
        if (response && response.success) {
            SocialActivistTaskListModel *model = [SocialActivistTaskListModel objectWithKeyValues:response.content];
            MKBlockExec(block, model);
        }else{
            MKBlockExec(block, nil);
        }
        
    }];
}

/** 记录图文消息点击日志 */
- (void)graphicPushLogClickRecord:(NSString *)contentId block:(MKBlock)block{
    NSString *content = [NSString stringWithFormat:@"content_id:%@",contentId];
    RequestInfo *request = [[RequestInfo alloc]initWithService:@"shijianke_graphicPushLogClickRecord" andContent:content];
    [request sendRequestWithResponseBlock:^(ResponseInfo *response) {
        MKBlockExec(block, response);        
    }];
}

/** 兼客联系岗位申请 */
- (void)postStuContactApplyJob:(NSString *)jobId resultType:(NSNumber *)resultType remark:(NSString *)remakr block:(MKBlock)block{
    NSString *content = [NSString stringWithFormat:@"\"job_id\":\"%@\", \"stu_contact_result_type\":\"%@\"", jobId, resultType];
    if (remakr) {
        content = [NSString stringWithFormat:@"%@, \"contact_remark\":\"%@\"", content, remakr];
    }
    RequestInfo *request = [[RequestInfo alloc]initWithService:@"shijianke_stuContactApplyJob" andContent:content];
    request.isShowLoading = YES;
    [request sendRequestWithResponseBlock:^(ResponseInfo *response) {
        MKBlockExec(block, response);
    }];
    
}

/** 查询电话联系岗位的兼客列表 */
- (void)queryContactApplyJobResumeList:(QueryParamModel *)queryParam jobId:(NSString *)jobId block:(MKBlock)block{
    
    NSString *content = [NSString stringWithFormat:@"%@, job_id:%@", [queryParam getContent], jobId];
    RequestInfo *request = [[RequestInfo alloc]initWithService:@"shijianke_queryContactApplyJobResumeList" andContent:content];
    [request sendRequestWithResponseBlock:^(ResponseInfo *response) {
        MKBlockExec(block, response);
    }];
}

/** 记录通知栏消息点击日志 */
- (void)noticeBoardPushLogClickRecord:(NSString *)messageId block:(MKBlock)block{
    
    NSString *content = [NSString stringWithFormat:@"message_id:%@", messageId];
    RequestInfo *request = [[RequestInfo alloc]initWithService:@"shijianke_noticeBoardPushLogClickRecord" andContent:content];
    [request sendRequestWithResponseBlock:^(ResponseInfo *response) {
        MKBlockExec(block, response);
    }];
}

/** 记录搜索关键字 */
- (void)recordSearchKeyWord:(NSString *)keyWord cityId:(NSNumber *)cityId block:(MKBlock)block{
    NSString *content = [NSString stringWithFormat:@"\"key_word\":\"%@\",\"city_id\":\"%@\"", keyWord,cityId];
    RequestInfo *request = [[RequestInfo alloc]initWithService:@"shijianke_recordSearchKeyWord" andContent:content];
    [request sendRequestWithResponseBlock:^(ResponseInfo *response) {
        MKBlockExec(block, response);
    }];
}

/** 查询增值服务列表 */
- (void)queryJobVasListLoading:(BOOL)isShowLoding block:(MKBlock)block{
    RequestInfo *request = [[RequestInfo alloc]initWithService:@"shijianke_queryJobVasList" andContent:nil];
    request.isShowLoading = isShowLoding;
    [request sendRequestWithResponseBlock:^(ResponseInfo *response) {
        if (response && response.success) {
            MKBlockExec(block, response);
        }else{
            MKBlockExec(block, nil);
        }
    }];
}

/** 雇主购买岗位增值服务 */
- (void)entRechargeJobVas:(NSString *)jobId totalAmount:(NSNumber *)totalAmount orderType:(NSNumber *)orderType oderId:(NSNumber *)orderId block:(MKBlock)block{
    [self entRechargeJobVas:jobId classifyId:nil tagIds:nil totalAmount:totalAmount orderType:orderType oderId:orderId block:block];
}

- (void)entRechargeJobVas:(NSString *)jobId classifyId:(NSNumber *)classifyId tagIds:(NSArray *)tagIds totalAmount:(NSNumber *)totalAmount orderType:(NSNumber *)orderType oderId:(NSNumber *)orderId block:(MKBlock)block{
    NSString *content = [NSString stringWithFormat:@"job_id:%@, total_amount:%@, vas_order_type:%@, vas_order_vas_id:%@", jobId, totalAmount, orderType, orderId];
    if (classifyId) {
        content = [NSString stringWithFormat:@"%@, job_push_classify_id:%@", content, classifyId];
    }
    if (tagIds.count) {
        content = [NSString stringWithFormat:@"%@, job_push_label_id_list:%@", content, tagIds];
    }
    RequestInfo *request = [[RequestInfo alloc]initWithService:@"shijianke_entRechargeJobVas" andContent:content];
    request.isShowLoading = YES;
    [request sendRequestWithResponseBlock:^(ResponseInfo *response) {
        if (response && response.success) {
            MKBlockExec(block, response);
        }else{
            MKBlockExec(block, nil);
        }
    }];
}

/** 支付岗位增值服务订单 */
- (void)payJobVasOrder:(PayJobInfoModel *)model block:(MKBlock)block{
    NSString *content = [model getContent];
    RequestInfo *request = [[RequestInfo alloc]initWithService:@"shijianke_payJobVasOrder" andContent:content];
    request.isShowLoading = YES;
    [request sendRequestWithResponseBlock:^(ResponseInfo *response) {
        if (response && response.success) {
            MKBlockExec(block, response);
        }else{
            MKBlockExec(block, nil);
        }
    }];
}

/** 查询岗位订阅增值服务信息 */
- (void)queryJobVasInfo:(NSString *)jobId block:(MKBlock)block{
    NSString *content = [NSString stringWithFormat:@"job_id:%@", jobId];
    RequestInfo *request = [[RequestInfo alloc] initWithService:@"shijianke_queryJobVasInfo" andContent:content];
    request.isShowLoading = YES;
    [request sendRequestWithResponseBlock:^(ResponseInfo *response) {
        if (response && response.success) {
            MKBlockExec(block, response);
        }else{
            MKBlockExec(block, nil);
        }
    }];

}

/** 获取个人服务兼客列表 */
- (void)getServicePersonalStuList:(NSNumber *)serviceType cityId:(NSNumber *)cityId jobId:(NSNumber *)jobId param:(QueryParamModel *)param block:(MKBlock)block{
    cityId = cityId ? cityId : @211 ;
    NSString *content = [NSString stringWithFormat:@"service_type:%@, city_id:%@, %@", serviceType, cityId ,[param getContent]];
    if (jobId) {
        content = [NSString stringWithFormat:@"%@, service_personal_job_id:%@", content, jobId];
    }
    RequestInfo *request = [[RequestInfo alloc] initWithService:@"shijianke_getServicePersonalStuList" andContent:content];
    [request sendRequestWithResponseBlock:^(ResponseInfo *response) {
        if (response && response.success) {
            NSArray *result = [ServicePersonalStuModel objectArrayWithKeyValuesArray:[response.content objectForKey:@"service_personal_stu_list"]];
            MKBlockExec(block, result);
        }else{
            MKBlockExec(block, nil);
        }
    }];
}

/** 雇主获取个人服务需求列表 */
- (void)entQueryServicePersonalJobList:(NSNumber *)serviceType queryParam:(QueryParamModel *)param listType:(NSNumber *)listType block:(MKBlock)block{
    [self entQueryServicePersonalJobList:serviceType withAccountId:nil inHistory:nil queryParam:param listType:listType block:block];
}

/** 雇主获取个人服务需求列表 */
- (void)entQueryServicePersonalJobList:(NSNumber *)serviceType withAccountId:(NSNumber *)accountId inHistory:(NSNumber *)inHistory queryParam:(QueryParamModel *)param listType:(NSNumber *)listType block:(MKBlock)block{
    NSString *content = nil;
    if (param) {
        content = [NSString stringWithFormat:@"%@", [param getContent]];
    }
    if (serviceType) {
        content = content ? [NSString stringWithFormat:@"%@, service_type:%@", content, serviceType] : [NSString stringWithFormat:@"service_type:%@", serviceType];
    }
    if (accountId) {
        content = content ? [NSString stringWithFormat:@"%@, stu_account_id:%@",content , accountId] : [NSString stringWithFormat:@"stu_account_id:%@", accountId];
    }
    if (inHistory) {
        if (content) {
            content = [NSString stringWithFormat:@"%@, in_history:%@", content, inHistory];
        }else{
            content = [NSString stringWithFormat:@"in_history:%@", inHistory];
        }
    }
    if (listType) {
        if (content) {
            content = [NSString stringWithFormat:@"%@, list_type:%@", content, listType];
        }else{
            content = [NSString stringWithFormat:@"list_tyoe:%@", listType];
        }
    }
    RequestInfo *request = [[RequestInfo alloc] initWithService:@"shijianke_entQueryServicePersonalJobList" andContent:content];
    [request sendRequestWithResponseBlock:^(ResponseInfo *response) {
        if (response && response.success) {
            MKBlockExec(block, response);
        }else{
            MKBlockExec(block, nil);
        }
    }];
}

/** 发布个人服务需求 */
- (void)postServicePersonalJob:(PostJobModel *)postJobModel block:(MKBlock)block{
    NSString *content = [NSString stringWithFormat:@"service_personal_job: {%@}", [postJobModel getContent]];
    RequestInfo *request = [[RequestInfo alloc] initWithService:@"shijianke_postServicePersonalJob" andContent:content];
    request.isShowLoading = YES;
    [request sendRequestWithResponseBlock:^(ResponseInfo *response) {
        if (response && response.success) {
            MKBlockExec(block, response);
        }else{
            MKBlockExec(block, nil);
        }
    }];

}

/** 获取团队服务商列表 */
- (void)getServiceTeamList:(NSNumber *)cityId serviceId:(NSNumber *)serviceClassifyId queryParam:(QueryParamModel *)queryParam block:(MKBlock)block{
    NSString *content = [NSString stringWithFormat:@"city_id:%@, service_classify_id:%@, %@", cityId, serviceClassifyId, [queryParam getContent]];
    RequestInfo *request = [[RequestInfo alloc] initWithService:@"shijianke_getServiceTeamList" andContent:content];
    [request sendRequestWithResponseBlock:^(ResponseInfo *response) {
        if (response && response.success) {
            NSArray *result = [ServiceTeamModel objectArrayWithKeyValuesArray:[response.content objectForKey:@"service_team_list"]];
            MKBlockExec(block, result);
        }else{
            MKBlockExec(block, nil);
        }
    }];
}

/** 查询服务商服务类别列表 */
- (void)getServiceClassifyInfoList:(MKBlock)block{
    RequestInfo *request = [[RequestInfo alloc] initWithService:@"shijianke_getServiceClassifyInfoList" andContent:nil];
    [request sendRequestWithResponseBlock:^(ResponseInfo *response) {
        if(response && response.success){
            MKBlockExec(block, response);
        }else{
            MKBlockExec(block, nil);
        }
    }];

}

/** 发布团队服务需求 */
- (void)postServiceTeamJobWithModel:(PostJobModel *)postJobModel block:(MKBlock)block{
    NSString *content = [NSString stringWithFormat:@"service_team_job: {%@}", [postJobModel getContent]];
    RequestInfo *request = [[RequestInfo alloc] initWithService:@"shijianke_postServiceTeamJob" andContent:content];
    request.isShowLoading = YES;
    [request sendRequestWithResponseBlock:^(ResponseInfo *response) {
        if (response && response.success) {
            MKBlockExec(block, response);
        }else{
            MKBlockExec(block, nil);
        }
    }];
}

/** 雇主获取团队服务需求列表 */
- (void)entQueryServiceTeamJobList:(NSNumber *)classifyId queryParam:(QueryParamModel *)queryParam block:(MKBlock)block{
    [self entQueryServiceTeamJobList:classifyId inHistory:nil queryParam:queryParam serviceApplyId:nil listType:nil block:block];
}

/** 雇主获取团队服务需求列表 */
- (void)entQueryServiceTeamJobList:(NSNumber *)classifyId inHistory:(NSNumber *)inHistory queryParam:(QueryParamModel *)queryParam serviceApplyId:(NSNumber *)serviceApplyId listType:(NSNumber *)listType block:(MKBlock)block{
    
    NSString *content = nil;
    if (queryParam) {
        content = [NSString stringWithFormat:@"%@", [queryParam getContent]];
    }
    if (classifyId) {
        content = content ? [NSString stringWithFormat:@"%@, service_classify_id:%@", content, classifyId] : [NSString stringWithFormat:@"service_classify_id:%@", classifyId];
    }
    if (inHistory) {
        content = content ? [NSString stringWithFormat:@"%@, in_history:%@", content, inHistory] : [NSString stringWithFormat:@"in_history:%@", inHistory] ;
    }
    if (serviceApplyId) {
        content = content ? [NSString stringWithFormat:@"%@, service_apply_id:%@", content, serviceApplyId] : [NSString stringWithFormat:@"service_apply_id:%@", serviceApplyId];
    }
    if (listType) {
        content = content ? [NSString stringWithFormat:@"%@, list_type:%@", content, listType] : [NSString stringWithFormat:@"list_type:%@", listType];
    }
    RequestInfo *request = [[RequestInfo alloc] initWithService:@"shijianke_entQueryServiceTeamJobList" andContent:content];
    [request sendRequestWithResponseBlock:^(ResponseInfo *response) {
        if (response && response.success) {
            MKBlockExec(block, response);
        }else{
            MKBlockExec(block, nil);
        }
    }];
    
}

/** 雇主邀约兼客 */
- (void)entInviteServicePersonal:(NSNumber *)stuAccountId serviceJobId:(NSNumber *)serviceJobId block:(MKBlock)block{
    NSString *content = [NSString stringWithFormat:@"stu_account_id:%@,service_personal_job_id:%@", stuAccountId, serviceJobId];
    RequestInfo *request = [[RequestInfo alloc] initWithService:@"shijianke_entInviteServicePersonal" andContent:content];
    request.isShowLoading = YES;
    [request sendRequestWithResponseBlock:^(ResponseInfo *response) {
        if (response && response.success) {
            MKBlockExec(block, response);
        }else{
            MKBlockExec(block, nil);
        }
    }];
}

/** 雇主预约团队服务商 */
- (void)entOrderServiceTeam:(NSNumber *)serviceApplyId teamJobId:(NSNumber *)teamJobId block:(MKBlock)block{
    NSString *content = [NSString stringWithFormat:@"service_apply_id:%@,service_team_job_id:%@", serviceApplyId, teamJobId];
    RequestInfo *request = [[RequestInfo alloc] initWithService:@"shijianke_entOrderServiceTeam" andContent:content];
    request.isShowLoading = YES;
    [request sendRequestWithResponseBlock:^(ResponseInfo *response) {
        if (response && response.success) {
            MKBlockExec(block, response);
        }else{
            MKBlockExec(block, nil);
        }
    }];
}

/** 获取个人服务需求邀约列表 */
- (void)entQueryServicePersonalJobApplyListWithApplyType:(NSNumber *)applyType jobId:(NSNumber *)jobId queryParam:(QueryParamModel *)queryParam block:(MKBlock)block{
    [self entQueryServicePersonalJobApplyListWithApplyType:applyType jobId:jobId queryParam:queryParam isShowLoding:YES block:block];
}

- (void)entQueryServicePersonalJobApplyListWithApplyType:(NSNumber *)applyType jobId:(NSNumber *)jobId queryParam:(QueryParamModel *)queryParam isShowLoding:(BOOL)isShowLoding block:(MKBlock)block{
    NSString *content = [NSString stringWithFormat:@"apply_type:%@,service_personal_job_id:%@, %@", applyType, jobId, [queryParam getContent]];
    RequestInfo *request = [[RequestInfo alloc] initWithService:@"shijianke_entQueryServicePersonalJobApplyList" andContent:content];
    request.isShowLoading = isShowLoding;
    [request sendRequestWithResponseBlock:^(ResponseInfo *response) {
        if (response && response.success) {
            MKBlockExec(block, response);
        }else{
            MKBlockExec(block, nil);
        }
    }];
}

/** 获取个人服务需求详情 */
- (void)getServicePersonalJobDetailWithJobId:(NSNumber *)personaJobId block:(MKBlock)block{
    [self getServicePersonalJobDetailWithJobId:personaJobId isShowLoding:YES block:block];
}

- (void)getServicePersonalJobDetailWithJobId:(NSNumber *)personaJobId isShowLoding:(BOOL)isShowLoding block:(MKBlock)block{
    NSString *content = [NSString stringWithFormat:@"service_personal_job_id:%@", personaJobId];
    RequestInfo *request = [[RequestInfo alloc] initWithService:@"shijianke_getServicePersonalJobDetail" andContent:content];
    request.isShowLoading = isShowLoding;
    [request sendRequestWithResponseBlock:^(ResponseInfo *response) {
        if (response && response.success) {
            MKBlockExec(block, response);
        }else{
            MKBlockExec(block, nil);
        }
    }];
}

/** 雇主购买个人服务联系方式 */
- (void)entRechargeServicePersonalWithJobApplyId:(NSNumber *)jobApplyId block:(MKBlock)block{
    NSString *content = [NSString stringWithFormat:@"service_personal_job_apply_id:%@", jobApplyId];
    RequestInfo *request = [[RequestInfo alloc] initWithService:@"shijianke_entRechargeServicePersonal" andContent:content];
    request.isShowLoading = YES;
    [request sendRequestWithResponseBlock:^(ResponseInfo *response) {
        if (response && response.success) {
            MKBlockExec(block, response);
        }else{
            MKBlockExec(block, nil);
        }
    }];
    
}

/** 雇主支付个人服务订单 */
- (void)payServicePersonalOrder:(PayJobInfoModel *)model block:(MKBlock)block{
    RequestInfo *request = [[RequestInfo alloc] initWithService:@"shijianke_payServicePersonalOrder" andContent:[model getContent]];
    request.isShowLoading = YES;
    [request sendRequestWithResponseBlock:^(ResponseInfo *response) {
        if (response && response.success) {
            MKBlockExec(block, response);
        }else{
            MKBlockExec(block, nil);
        }
    }];
}

/** 获取团队服务需求详情 */
- (void)getServiceTeamJobDetail:(NSNumber *)serviceJobId block:(MKBlock)block{
    NSString *content = [NSString stringWithFormat:@"service_team_job_id:%@", serviceJobId];
    RequestInfo *request = [[RequestInfo alloc] initWithService:@"shijianke_getServiceTeamJobDetail" andContent:content];
    request.isShowLoading = YES;
    [request sendRequestWithResponseBlock:^(ResponseInfo *response) {
        if (response && response.success) {
            MKBlockExec(block, response);
        }else{
            MKBlockExec(block, nil);
        }
    }];
}

/** 雇主获取团队服务需求预约列表 */
- (void)entQueryServiceTeamJobApplyListWithJobId:(NSNumber *)teamJobId param:(QueryParamModel *)queryParam block:(MKBlock)block{
    NSString *content = [NSString stringWithFormat:@"service_team_job_id:%@, %@", teamJobId, [queryParam getContent]];
    RequestInfo *request = [[RequestInfo alloc] initWithService:@"shijianke_entQueryServiceTeamJobApplyList" andContent:content];
    [request sendRequestWithResponseBlock:^(ResponseInfo *response) {
        if (response && response.success) {
            MKBlockExec(block, response);
        }else{
            MKBlockExec(block, nil);
        }
    }];
}

/** 推广订单 */
- (void)getSpreadOrderWithParam:(QueryParamModel *)param block:(MKBlock)block{
    RequestInfo *request = [[RequestInfo alloc] initWithService:@"shijianke_getSpreadOrder" andContent:[param getContent]];
    [request sendRequestWithResponseBlock:^(ResponseInfo *response) {
        if (response && response.success) {
            MKBlockExec(block, response);
        }else{
            MKBlockExec(block, nil);
        }
    }];
}

/** 获取团队服务需求预约列表 */
- (void)queryServiceTeamJobApplyListWithListType:(NSNumber *)listType queryParam:(QueryParamModel *)queryParam block:(MKBlock)block{
    NSString *content = [NSString stringWithFormat:@"list_type:%@, %@", listType, [queryParam getContent]];
    RequestInfo *request = [[RequestInfo alloc] initWithService:@"shijianke_queryServiceTeamJobApplyList" andContent:content];
    [request sendRequestWithResponseBlock:^(ResponseInfo *response) {
        if (response && response.success) {
            MKBlockExec(block, response);
        }else{
            MKBlockExec(block, nil);
        }
    }];
}

/** 获取团队服务需求预约详情 */
- (void)getServiceTeamJobApplyDetailWithApplyId:(NSNumber *)applyId block:(MKBlock)block{
    NSString *content = [NSString stringWithFormat:@"service_team_job_apply_id:%@", applyId];
    RequestInfo *request = [[RequestInfo alloc] initWithService:@"shijianke_getServiceTeamJobApplyDetail" andContent:content];
    [request sendRequestWithResponseBlock:^(ResponseInfo *response) {
        if (response && response.success) {
            MKBlockExec(block, response);
        }else{
            MKBlockExec(block, nil);
        }
    }];
}

/** 雇主获取关注的粉丝列表 */
- (void)entQueryFocusFansListWithQueryParam:(QueryParamModel *)param block:(MKBlock)block{
    NSString *content = [param getContent];
    RequestInfo *request = [[RequestInfo alloc] initWithService:@"shijianke_entQueryFocusFansList" andContent:content];
    [request sendRequestWithResponseBlock:^(ResponseInfo *response) {
        if (response && response.success) {
            MKBlockExec(block, response);
        }else{
            MKBlockExec(block, nil);
        }
    }];
}

/** 雇主填写企业服务商基本信息 */
- (void)postEnterpriseServiceBasicInfo:(EPModel *)epmodl block:(MKBlock)block{
    NSString *content = [epmodl getContent];
    RequestInfo *request = [[RequestInfo alloc] initWithService:@"shijianke_postEnterpriseServiceBasicInfo" andContent:content];
    request.isShowLoading = YES;
    [request sendRequestWithResponseBlock:^(ResponseInfo *response) {
        if (response && response.success) {
            MKBlockExec(block, response);
        }else{
            MKBlockExec(block, nil);
        }
    }];
}

/** 获取已申请的团队服务列表 */
- (void)queryServiceTeamApplyListWithEntID:(NSNumber *)entId status:(NSNumber *)status block:(MKBlock)block{
    NSString *content = nil;
    if (entId) {
       content = [NSString stringWithFormat:@"enterprise_id:%@", entId];
    }
    if (status) {
        content = content ? [NSString stringWithFormat:@"%@, status:%@", content, status] :[NSString stringWithFormat:@"status:%@", status];
    }
    RequestInfo *request = [[RequestInfo alloc] initWithService:@"shijianke_queryServiceTeamApplyList" andContent:content];
    [request sendRequestWithResponseBlock:^(ResponseInfo *response) {
        if (response && response.success) {
            MKBlockExec(block, response);
        }else{
            MKBlockExec(block, nil);
        }
    }];
}

/** 查询投保记录列表 */
- (void)queryInsuranceRecordList:(QueryParamModel *)queryParam block:(MKBlock)block{
    RequestInfo *request = [[RequestInfo alloc] initWithService:@"shijianke_queryInsuranceRecordList" andContent:[queryParam getContent]];
    [request sendRequestWithResponseBlock:^(ResponseInfo *response) {
        if (response && response.success) {
            MKBlockExec(block, response);
        }else{
            MKBlockExec(block, nil);
        }
    }];
}

/** 查询已成功投保的日期列表 */
- (void)getSuccessInsuredDateListWithIdCard:(NSString *)idCard block:(MKBlock)block{
    NSString *content = [NSString stringWithFormat:@"\"insured_id_card_num\":\"%@\"", idCard];
    RequestInfo *request = [[RequestInfo alloc] initWithService:@"shijianke_getSuccessInsuredDateList" andContent:content];
    request.isShowLoading = YES;
    [request sendRequestWithResponseBlock:^(ResponseInfo *response) {
        if (response && response.success) {
            MKBlockExec(block, response);
        }else{
            MKBlockExec(block, nil);
        }
    }];
}

/** 投保人投保(购买保单) */
- (void)rechargeInsuranceWithTotalAmount:(NSNumber *)totalAmount insuranceList:(NSArray *)insuranceList block:(MKBlock)block{
    PinganInsuranceModel *model = [[PinganInsuranceModel alloc] init];
    model.total_amount = totalAmount;
    model.insurance_policy_list = insuranceList;
    
    NSString *content = [model getContent];
    RequestInfo *request = [[RequestInfo alloc] initWithService:@"shijianke_rechargeInsurance" andContent:content];
    request.isShowLoading = YES;
    [request sendRequestWithResponseBlock:^(ResponseInfo *response) {
        if (response && response.success) {
            MKBlockExec(block, response);
        }else{
            MKBlockExec(block, nil);
        }
    }];
}

/** 查询投保记录详情列表 */
- (void)queryInsuranceRecordDetailList:(NSNumber *)recordId queryParam:(QueryParamModel *)queryParam block:(MKBlock)block{
    NSString *content = [NSString stringWithFormat:@"insurance_record_id:%@, %@", recordId, [queryParam getContent]];
    RequestInfo *request = [[RequestInfo alloc] initWithService:@"shijianke_queryInsuranceRecordDetailList" andContent:content];
    [request sendRequestWithResponseBlock:^(ResponseInfo *response) {
        if (response && response.success) {
            MKBlockExec(block, response);
        }else{
            MKBlockExec(block, nil);
        }
    }];
}

/** 投保人支付投保保单 */
- (void)payInsurancePolicy:(PayJobInfoModel *)model block:(MKBlock)block{
    RequestInfo *request = [[RequestInfo alloc] initWithService:@"shijianke_payInsurancePolicy" andContent:[model getContent]];
    request.isShowLoading = YES;
    [request sendRequestWithResponseBlock:^(ResponseInfo *response) {
        if (response && response.success) {
            MKBlockExec(block, response);
        }else{
            MKBlockExec(block, nil);
        }
    }];
}

/** 雇主联系个人服务商 */
- (void)entContactWithStuWithApplyId:(NSNumber *)applyId block:(MKBlock)block{
    NSString *content = [NSString stringWithFormat:@"service_personal_job_apply_id: %@", applyId];
    RequestInfo *request = [[RequestInfo alloc] initWithService:@"shijianke_entContactWithStu" andContent:content];
    request.isShowLoading = YES;
    [request sendRequestWithResponseBlock:^(ResponseInfo *response) {
        if (response && response.success) {
            MKBlockExec(block, response);
        }else{
            MKBlockExec(block, nil);
        }
    }];
}

/** 记录app访问页面 */
- (void)recordPageVisitLogWithVisitPageId:(NSNumber *)visit_page_id block:(MKBlock)block{
    NSString *content = [NSString stringWithFormat:@"visit_page_id: %@", visit_page_id];
    RequestInfo *request = [[RequestInfo alloc] initWithService:@"shijianke_recordPageVisitLog" andContent:content];
    [request sendRequestWithResponseBlock:^(ResponseInfo *response) {
        if (response && response.success) {
            MKBlockExec(block, response);
        }else{
            MKBlockExec(block, nil);
        }
    }];
}

/** 检测用户登陆状态 */
- (void)checkUserLogin:(MKBlock)block{
    RequestInfo *request = [[RequestInfo alloc] initWithService:@"shijianke_checkUserLogin" andContent:nil];
    [request sendRequestWithResponseBlock:^(ResponseInfo *response) {
        if (response && response.success) {
            MKBlockExec(block, response);
        }else{
            MKBlockExec(block, nil);
        }
    }];
}

/** 雇主关闭个人服务需求 */
- (void)entCloseServicePersonalJobWithJobId:(NSNumber *)jobId block:(MKBlock)block{
    NSString *content = [NSString stringWithFormat:@"service_personal_job_id:%@", jobId];
    RequestInfo *request = [[RequestInfo alloc] initWithService:@"shijianke_entCloseServicePersonalJob" andContent:content];
    request.isShowLoading = YES;
    request.loadingMessage = @"正在结束订单";
    [request sendRequestWithResponseBlock:^(ResponseInfo *response) {
        if (response && response.success) {
            MKBlockExec(block, response);
        }else{
            MKBlockExec(block, nil);
        }
    }];
}

/** 提交推送平台信息（极光推送） */
- (void)postThirdPushPlatInfo{
    if ([UserData sharedInstance].registrationID){
        [self postThirdPushPlatInfo:[UserData sharedInstance].registrationID block:^(id result) {
            
        }];
    }
}
- (void)postThirdPushPlatInfo:(NSString *)push_id block:(MKBlock)block{
    NSNumber *accountType = @1;
    NSString *content = [NSString stringWithFormat:@"\"push_id\":\"%@\", \"account_type\":\"%@\"", push_id, accountType];
    RequestInfo *request = [[RequestInfo alloc] initWithService:@"shijianke_postThirdPushPlatInfo" andContent:content];
    [request sendRequestWithResponseBlock:^(ResponseInfo *response) {
        MKBlockExec(block, response);
    }];
}

/** 支付代发工资 */
- (void)entPayforStuByAgency:(PayJobInfoModel *)payJobInfoModel block:(MKBlock)block{
    NSString *content = [payJobInfoModel getContent];
    RequestInfo *request = [[RequestInfo alloc] initWithService:@"shijianke_entPayforStuByAgency" andContent:content];
    request.isShowLoading = YES;
    [request sendRequestWithResponseBlock:^(ResponseInfo *response) {
        MKBlockExec(block, response);
    }];
}

/** 工资撤回 */
- (void)entCancelUnConfirmStuSalaryWithItemId:(NSString *)itemId block:(MKBlock)block{
    NSString *content = [NSString stringWithFormat:@"\"item_id\": \"%@\"", [NSString stringNoneNullFromValue:itemId]];
    RequestInfo *request = [[RequestInfo alloc] initWithService:@"shijianke_entCancelUnConfirmStuSalary" andContent:content];
    request.isShowLoading = YES;
    [request sendRequestWithResponseBlock:^(ResponseInfo *response) {
        if (response && response.success) {
            MKBlockExec(block, response);
        }else{
            MKBlockExec(block, nil);
        }
    }];
}

/** 新增雇主查询可投保兼客简历列表 */
- (void)entQueryCanInsureApplyResumeListWithJobId:(NSString *)jobId block:(MKBlock)block{
    NSString *content = [NSString stringWithFormat:@"\"job_id\": \"%@\"", [NSString stringNoneNullFromValue:jobId]];
    RequestInfo *request = [[RequestInfo alloc] initWithService:@"shijianke_entQueryCanInsureApplyResumeList" andContent:content];
    request.isShowLoading = YES;
    [request sendRequestWithResponseBlock:^(ResponseInfo *response) {
        if (response && response.success) {
            MKBlockExec(block, response);
        }else{
            MKBlockExec(block, nil);
        }
    }];
}

/** 雇主获取自己发布的岗位 */
- (void)getEnterpriseSelfJobList:(GetEnterpriscJobModel *)paramModel block:(MKBlock)block{
    if (!paramModel) {
        return;
    }
    RequestInfo *request = [[RequestInfo alloc] initWithService:@"shijianke_getEnterpriseSelfJobList_v2" andContent:[paramModel getContent]];
    [request sendRequestWithResponseBlock:^(ResponseInfo *response) {
        if (response && response.success) {
            MKBlockExec(block, response);
        }else{
            MKBlockExec(block, nil);
        }
    }];
}

/** 雇主购买在招岗位数 */
- (void)rechargeRecruitJobNum:(RechargeRecruitParam *)param block:(MKBlock)block{
    if (!param) {
        return;
    }
    RequestInfo *request = [[RequestInfo alloc] initWithService:@"shijianke_rechargeRecruitJobNum" andContent:[param getContent]];
    request.isShowLoading = YES;
    [request sendRequestWithResponseBlock:^(ResponseInfo *response) {
        if (response && response.success) {
            MKBlockExec(block, response);
        }else{
            MKBlockExec(block, nil);
        }
    }];
}

/** 雇主查询在招岗位数相关信息 */
- (void)entQueryRecruitJobNumInfo:(NSNumber *)cityId block:(MKBlock)block{
    [self entQueryRecruitJobNumInfo:cityId isShowLoading:YES block:block];
}

- (void)entQueryRecruitJobNumInfo:(NSNumber *)cityId isShowLoading:(BOOL)isShowLoading block:(MKBlock)block{
    if (!cityId) {
        return;
    }
    NSString *content = [NSString stringWithFormat:@"city_id: %@", cityId];
    RequestInfo *request = [[RequestInfo alloc] initWithService:@"shijianke_entQueryRecruitJobNumInfo" andContent:content];
    request.isShowLoading = isShowLoading;
    [request sendRequestWithResponseBlock:^(ResponseInfo *response) {
        if (response && response.success) {
            RecruitJobNumInfo *model = [RecruitJobNumInfo objectWithKeyValues:response.content];
            if ([UserData sharedInstance].city.id && [[UserData sharedInstance].city.id isEqual:cityId] ) {
                [UserData sharedInstance].recruitJobNumInfo = model;
            }
            MKBlockExec(block, response);
        }else{
            MKBlockExec(block, nil);
        }
    }];
}

/** 支付在招岗位数订单 */
- (void)payRecruitJobNumOrder:(PayJobInfoModel *)param block:(MKBlock)block{
    RequestInfo *request = [[RequestInfo alloc] initWithService:@"shijianke_payRecruitJobNumOrder" andContent:[param getContent]];
    request.isShowLoading = YES;
    [request sendRequestWithResponseBlock:^(ResponseInfo *response) {
        if (response && response.success) {
            MKBlockExec(block, response);
        }else{
            MKBlockExec(block, nil);
        }
    }];
}

/** 查询购买的在招岗位数记录 */
- (void)entQueryRecruitJobNumRecordList:(NSNumber *)cityId block:(MKBlock)block{
    if (!cityId) {
        return;
    }
    NSString *content = [NSString stringWithFormat:@"city_id:%@", cityId];
    RequestInfo *request = [[RequestInfo alloc] initWithService:@"shijianke_entQueryRecruitJobNumRecordList" andContent:content];
    request.isShowLoading = YES;
    [request sendRequestWithResponseBlock:^(ResponseInfo *response) {
        if (response && response.success) {
            MKBlockExec(block, response);
        }else{
            MKBlockExec(block, nil);
        }
    }];
}

/** 雇主续费在招岗位数 */
- (void)renewRecruitJobNum:(RechargeRecruitParam *)param block:(MKBlock)block{
    if (!param) {
        return;
    }
    RequestInfo *request = [[RequestInfo alloc] initWithService:@"shijianke_renewRecruitJobNum" andContent:[param getContent]];
    request.isShowLoading = YES;
    [request sendRequestWithResponseBlock:^(ResponseInfo *response) {
        if (response && response.success) {
            MKBlockExec(block, response);
        }else{
            MKBlockExec(block, nil);
        }
    }];
}

/** 查询增值服务信息列表 */
- (void)queryJobVasListLoading:(BOOL)isShowLoding cityId:(NSNumber *)cityId jobId:(NSString *)jobId block:(MKBlock)block{
    NSString *content = [NSString stringWithFormat:@"city_id: %@", cityId];
    if (jobId) {
        content = [content stringByAppendingFormat:@", job_id:%@", jobId];
    }
    RequestInfo *request = [[RequestInfo alloc] initWithService:@"shijianke_queryJobVasList" andContent:content];
    request.isShowLoading = isShowLoding;
    [request sendRequestWithResponseBlock:^(ResponseInfo *response) {
        if (response && response.success) {
            MKBlockExec(block, response);
        }else{
            MKBlockExec(block, nil);
        }
    }];
}

/** 雇主使用岗位特权推广 */

- (void)entUseJobVipSpreadWithJobId:(NSString *)jobId spreadType:(NSNumber *)spreadType spreadNum:(NSString *)spreadNum classfyId:(NSNumber *)classfyId idList:(NSArray *)idList vasOrderVasId:(NSNumber *)vasOrderVasId block:(MKBlock)block{
    NSString *content = [NSString stringWithFormat:@"job_id:%@, vip_spread_type:%@, vip_spread_num:%@",  jobId, spreadType, spreadNum];
    if (classfyId) {
        content = [NSString stringWithFormat:@"%@, job_push_classify_id:%@", content, classfyId];
    }
    if (idList.count) {
        content = [NSString stringWithFormat:@"%@, job_push_label_id_list:%@", content, idList];
    }
    if (vasOrderVasId) {
        content = [NSString stringWithFormat:@"%@, vas_order_vas_id: %@", content, vasOrderVasId];
    }
    RequestInfo *request = [[RequestInfo alloc]initWithService:@"shijianke_entUseJobVipSpread" andContent:content];
    request.isShowLoading = YES;
    [request sendRequestWithResponseBlock:^(ResponseInfo *response) {
        if (response && response.success) {
            MKBlockExec(block, response);
        }else{
            MKBlockExec(block, nil);
        }
    }];
}

- (void)entUseJobVipSpreadWithJobId:(NSString *)jobId spreadType:(NSNumber *)spreadType spreadNum:(NSString *)spreadNum classfyId:(NSNumber *)classfyId idList:(NSArray *)idList block:(MKBlock)block{
    [self entUseJobVipSpreadWithJobId:jobId spreadType:spreadType spreadNum:spreadNum classfyId:classfyId idList:idList vasOrderVasId:nil block:block];
}

/** 记录销售线索 */
- (void)postSaleClueWithDesc:(NSString *)desc isNeedContact:(NSNumber *)isNeedContact block:(MKBlock)block{
    [self postSaleClueWithDesc:desc isNeedContact:isNeedContact isShowloading:NO block:block];
}

- (void)postSaleClueWithDesc:(NSString *)desc isNeedContact:(NSNumber *)isNeedContact isShowloading:(BOOL)isShowLoading block:(MKBlock)block{
    CityModel *cityModel = [UserData sharedInstance].city;
    if (!cityModel.id) {
        return;
    }
    NSString *content = [NSString stringWithFormat:@"\"city_id\": \"%@\", \"clue_desc\": \"%@\", \"is_need_contact\": \"%@\"", cityModel.id, desc, isNeedContact];
    RequestInfo *request = [[RequestInfo alloc]initWithService:@"shijianke_postSaleClue" andContent:content];
    request.isShowLoading = isShowLoading;
    [request sendRequestWithResponseBlock:^(ResponseInfo *response) {
        if (response && response.success) {
            MKBlockExec(block, response);
        }else{
            MKBlockExec(block, nil);
        }
    }];
}

/** 保证金缴纳 */
- (void)payGuaranteeAmount:(PayJobInfoModel *)param block:(MKBlock)block{
    RequestInfo *request = [[RequestInfo alloc]initWithService:@"shijianke_payGuaranteeAmount" andContent:[param getContent]];
    request.isShowLoading = YES;
    [request sendRequestWithResponseBlock:^(ResponseInfo *response) {
        if (response && response.success) {
            MKBlockExec(block, response);
        }else{
            MKBlockExec(block, nil);
        }
    }];
}

/** 获取岗位类型 */
- (void)getJobClassifyInfoListWithCityId:(NSNumber *)cityId isShowLoading:(BOOL)isShowLoading block:(MKBlock)block{
    NSString* content = [NSString stringWithFormat:@"\"city_id\":\"%@\"", cityId];
    RequestInfo* request = [[RequestInfo alloc] initWithService:@"shijianke_getJobClassifyInfoList" andContent:content];
    request.isShowLoading = isShowLoading;
    [request sendRequestWithResponseBlock:^(ResponseInfo *response) {
        if (response && response.success) {
            MKBlockExec(block, response);
        }else{
            MKBlockExec(block, nil);
        }
    }];
}

/** 雇主提交岗位审核 */
- (void)entJobSubmitAuditWithJobId:(NSNumber *)jobId block:(MKBlock)block{
    if (!jobId) {
        return;
    }
    NSString* content = [NSString stringWithFormat:@"\"parttime_job_id\":\"%@\"", jobId];
    RequestInfo* request = [[RequestInfo alloc] initWithService:@"shijianke_entJobSubmitAudit" andContent:content];
    request.isShowLoading = YES;
    request.isShowErrorMsg = NO;
    [request sendRequestWithResponseBlock:^(ResponseInfo *response) {
        if (response) {
            MKBlockExec(block, response);
        }else{
            MKBlockExec(block, nil);
        }
    }];
}

/** 雇主编辑岗位信息 */
- (void)editParttimeJobServiceWithJobId:(NSNumber *)jobId parttimeJob:(PostJobModel *)parttimeJob block:(MKBlock)block{
    NSString* content = [NSString stringWithFormat:@"parttime_job:{%@}, job_id: %@", [parttimeJob getContent], jobId];
    RequestInfo* request = [[RequestInfo alloc] initWithService:@"shijianke_editParttimeJobService" andContent:content];
    request.isShowLoading = YES;
    [request sendRequestWithResponseBlock:^(ResponseInfo *response) {
        if (response && response.success) {
            MKBlockExec(block, response);
        }else{
            MKBlockExec(block, nil);
        }
    }];
}

/** 获取附近求职者数量 */
- (void)getNearbyJobSeekerNumWithLongitude:(NSString *)longitude latitude:(NSString *)latitude block:(MKBlock)block{
    if (!longitude.length) {
        longitude = @"0";
    }
    if (!latitude.length) {
        latitude = @"0";
    }
    
    NSString* content = [NSString stringWithFormat:@"\"map_coordinates\":\"%@,%@\"", longitude, latitude];
    RequestInfo* request = [[RequestInfo alloc] initWithService:@"shijianke_getNearbyJobSeekerNum" andContent:content];
    request.isShowLoading = YES;
    [request sendRequestWithResponseBlock:^(ResponseInfo *response) {
        if (response) {
            MKBlockExec(block, response);
        }else{
            MKBlockExec(block, nil);
        }
    }];
}

/** 查询当前账号当前城市对应的VIP信息 */
- (void)getAccountVipInfo:(NSNumber *)cityId block:(MKBlock)block{
    if (![[UserData sharedInstance] isLogin]) {
        return;
    }
    NSString* content = [NSString stringWithFormat:@"\"city_id\":\"%@\"", cityId];
    RequestInfo* request = [[RequestInfo alloc] initWithService:@"shijianke_getAccountVipInfo" andContent:content];
    [request sendRequestWithResponseBlock:^(ResponseInfo *response) {
        if (response) {
            MKBlockExec(block, response);
        }else{
            MKBlockExec(block, nil);
        }
    }];
}

/**  获取城市vip套餐入口列表接口 */
- (void)getVipPackageEntryList:(NSNumber *)cityId isShowLoading:(BOOL)isShowLoading block:(MKBlock)block{
    NSString* content = [NSString stringWithFormat:@"\"city_id\":\"%@\"", cityId];
    RequestInfo* request = [[RequestInfo alloc] initWithService:@"shijianke_getVipPackageEntryList" andContent:content];
    request.isShowLoading = isShowLoading;
    [request sendRequestWithResponseBlock:^(ResponseInfo *response) {
        if (response && response.success) {
            MKBlockExec(block, response);
        }else{
            MKBlockExec(block, nil);
        }
    }];
}

/** 雇主购买VIP会员套餐 */
- (void)rechargeVipPackageWithVipId:(NSNumber *)packetId totalAmount:(NSNumber *)totalAmount cityId:(NSNumber *)cityId saleManId:(NSNumber *)saleManId block:(MKBlock)block{
    NSString* content = [NSString stringWithFormat:@"vip_city_id:%@, total_amount:  %@, vip_package_id:%@", cityId, totalAmount, packetId];
    if (saleManId) {
        content = [content stringByAppendingString:[NSString stringWithFormat:@"saleman_id_code:%@", saleManId]];
    }
    RequestInfo* request = [[RequestInfo alloc] initWithService:@"shijianke_rechargeVipPackage" andContent:content];
    [request sendRequestWithResponseBlock:^(ResponseInfo *response) {
        if (response && response.success) {
            MKBlockExec(block, response);
        }else{
            MKBlockExec(block, nil);
        }
    }];
}

/** 支付VIP会员套餐订单 */
- (void)payVipOrder:(PayJobInfoModel *)param block:(MKBlock)block{
    {
        RequestInfo *request = [[RequestInfo alloc]initWithService:@"shijianke_payVipOrder" andContent:[param getContent]];
        request.isShowLoading = YES;
        [request sendRequestWithResponseBlock:^(ResponseInfo *response) {
            if (response && response.success) {
                MKBlockExec(block, response);
            }else{
                MKBlockExec(block, nil);
            }
        }];
    }
}

/** 推荐码查询后台账号是否存在 */
- (void)getAdminUserInfoWithSaleCode:(NSNumber *)saleCode block:(MKBlock)block{
    NSString* content = [NSString stringWithFormat:@"saleman_id_code:%@", saleCode];
    RequestInfo* request = [[RequestInfo alloc] initWithService:@"shijianke_getAdminUserInfo" andContent:content];
    [request sendRequestWithResponseBlock:^(ResponseInfo *response) {
        if (response && response.success) {
            MKBlockExec(block, response);
        }else{
            MKBlockExec(block, nil);
        }
    }];
}

/** 查询VIP会员信息 */
- (void)queryAccountVipInfo:(MKBlock)block{
    RequestInfo* request = [[RequestInfo alloc] initWithService:@"shijianke_queryAccountVipInfo" andContent:nil];
    [request sendRequestWithResponseBlock:^(ResponseInfo *response) {
        if (response && response.success) {
            MKBlockExec(block, response);
        }else{
            MKBlockExec(block, nil);
        }
    }];
}

/** 查询消耗报名数的岗位列表 */
- (void)queryJobListByVipOrder:(NSNumber *)vipOrderId queryParam:(QueryParamModel *)queryParam block:(MKBlock)block{
    NSString *content = [NSString stringWithFormat:@"vip_order_id:%@, %@", vipOrderId, [queryParam getContent]];
    RequestInfo *request = [[RequestInfo alloc] initWithService:@"shijianke_queryJobListByVipOrder" andContent:content];
    [request sendRequestWithResponseBlock:^(ResponseInfo *response) {
        if (response && response.success) {
            MKBlockExec(block, response);
        }else{
            MKBlockExec(block, nil);
        }
    }];
}

/** 查询消耗报名数的投递列表 */
- (void)queryApplyJobListByVipOrderJob:(NSNumber *)jobId orderId:(NSNumber *)orderId queryParam:(QueryParamModel *)queryParam block:(MKBlock)block{
    NSString *content = [NSString stringWithFormat:@"vip_order_id:%@, job_id:%@, %@", orderId, jobId, [queryParam getContent]];
    RequestInfo *request = [[RequestInfo alloc] initWithService:@"shijianke_queryApplyJobListByVipOrderJob" andContent:content];
    [request sendRequestWithResponseBlock:^(ResponseInfo *response) {
        if (response && response.success) {
            MKBlockExec(block, response);
        }else{
            MKBlockExec(block, nil);
        }
    }];
}

/** 查询报名数套餐列表 */
- (void)queryVipApplyJobNumPackageList:(NSNumber *)cityId isShowLoading:(BOOL)isShowLoading block:(MKBlock)block{
    NSString *content = [NSString stringWithFormat:@"city_id:%@", cityId];
    RequestInfo *request = [[RequestInfo alloc] initWithService:@"shijianke_queryVipApplyJobNumPackageList" andContent:content];
    request.isShowLoading = isShowLoading;
    [request sendRequestWithResponseBlock:^(ResponseInfo *response) {
        if (response && response.success) {
            MKBlockExec(block, response);
        }else{
            MKBlockExec(block, nil);
        }
    }];
}

/** 雇主购买VIP会员报名数套餐 */
- (void)rechargeVipApplyJobNumPackageWithOrderId:(NSNumber *)orderId packageId:(NSNumber *)packageId totalAmount:(NSNumber *)totalAmount block:(MKBlock)block{
    NSString *content = [NSString stringWithFormat:@"total_amount:%@, package_id:%@, vip_order_id:%@", totalAmount, packageId, orderId];
    RequestInfo *request = [[RequestInfo alloc] initWithService:@"shijianke_rechargeVipApplyJobNumPackage" andContent:content];
    request.isShowLoading = YES;
    [request sendRequestWithResponseBlock:^(ResponseInfo *response) {
        if (response && response.success) {
            MKBlockExec(block, response);
        }else{
            MKBlockExec(block, nil);
        }
    }];
}

/** 支付VIP会员报名数订单 */
- (void)payVipApplyJobNumOrder:(PayJobInfoModel *)param block:(MKBlock)block{
    RequestInfo *request = [[RequestInfo alloc] initWithService:@"shijianke_payVipApplyJobNumOrder" andContent:[param getContent]];
    request.isShowLoading = YES;
    [request sendRequestWithResponseBlock:^(ResponseInfo *response) {
        if (response && response.success) {
            MKBlockExec(block, response);
        }else{
            MKBlockExec(block, nil);
        }
    }];
}

/** 雇主查询人才列表 */
- (void)entQueryTalentList:(QueryTalentParam *)model queryParam:(QueryParamModel *)queryParam isShowLoading:(BOOL)isShowLoading block:(MKBlock)block{
    NSString *content = [NSString stringWithFormat:@"%@, %@", [model getContent], [queryParam getContent]];
    RequestInfo *request = [[RequestInfo alloc] initWithService:@"shijianke_entQueryTalentList" andContent:content];
    request.isShowLoading = isShowLoading;
    [request sendRequestWithResponseBlock:^(ResponseInfo *response) {
        if (response && response.success) {
            MKBlockExec(block, response);
        }else{
            MKBlockExec(block, nil);
        }
    }];
}

/** 雇主查询已联系的兼客列表 */
- (void)entQueryContactResumeList:(QueryParamModel *)param block:(MKBlock)block{
    RequestInfo *request = [[RequestInfo alloc] initWithService:@"shijianke_entQueryContactResumeList" andContent:[param getContent]];
    [request sendRequestWithResponseBlock:^(ResponseInfo *response) {
        if (response && response.success) {
            MKBlockExec(block, response);
        }else{
            MKBlockExec(block, nil);
        }
    }];
}

/** 雇主获取收藏的兼客列表 */
- (void)getCollectedStudentList:(QueryParamModel *)param block:(MKBlock)block{
    RequestInfo *request = [[RequestInfo alloc] initWithService:@"shijianke_getCollectedStudentList" andContent:[param getContent]];
    [request sendRequestWithResponseBlock:^(ResponseInfo *response) {
        if (response && response.success) {
            MKBlockExec(block, response);
        }else{
            MKBlockExec(block, nil);
        }
    }];
}

/** 查询简历数套餐列表 */
- (void)queryAccountResumeNumPackageList:(BOOL)isShowLoading block:(MKBlock)block{
    RequestInfo *request = [[RequestInfo alloc] initWithService:@"shijianke_queryAccountResumeNumPackageList" andContent:nil];
    request.isShowLoading = isShowLoading;
    [request sendRequestWithResponseBlock:^(ResponseInfo *response) {
        if (response && response.success) {
            MKBlockExec(block, response);
        }else{
            MKBlockExec(block, nil);
        }
    }];
}

/** 雇主购买简历数套餐 */
- (void)rechargeResumeNumPackageWithId:(NSNumber *)packageId totalAmount:(NSNumber *)totalAmount block:(MKBlock)block{
    NSString *content = [NSString stringWithFormat:@"total_amount:%@, package_id:%@", totalAmount, packageId];
    RequestInfo *request = [[RequestInfo alloc] initWithService:@"shijianke_rechargeResumeNumPackage" andContent:content];
    request.isShowLoading = YES;
    [request sendRequestWithResponseBlock:^(ResponseInfo *response) {
        if (response && response.success) {
            MKBlockExec(block, response);
        }else{
            MKBlockExec(block, nil);
        }
    }];
}

/** 雇主支付简历数订单 */
- (void)payResumeNumOrder:(PayJobInfoModel *)param block:(MKBlock)block{
    RequestInfo *request = [[RequestInfo alloc] initWithService:@"shijianke_payResumeNumOrder" andContent:[param getContent]];
    request.isShowLoading = YES;
    [request sendRequestWithResponseBlock:^(ResponseInfo *response) {
        if (response && response.success) {
            MKBlockExec(block, response);
        }else{
            MKBlockExec(block, nil);
        }
    }];
}

/** 雇主获取兼客联系方式 */
- (void)entGetResumeContact:(NSNumber *)resumeId block:(MKBlock)block{
    NSString *content = [NSString stringWithFormat:@"resume_id:%@", [NSString stringNoneNullFromValue:resumeId]];
    RequestInfo *request = [[RequestInfo alloc] initWithService:@"shijianke_entGetResumeContact" andContent:content];
    request.isShowLoading = YES;
    [request sendRequestWithResponseBlock:^(ResponseInfo *response) {
        if (response && response.success) {
            MKBlockExec(block, response.content);
        }else{
            MKBlockExec(block, nil);
        }
    }];
}
/** 雇主联系兼客反馈结果*/
- (void)entContactResumeFeedback:(NSNumber *)resumeId contactResultType:(NSNumber *)contactResultType contactRemark:(NSString *)contactRemark block:(MKBlock)block{
    NSString *content = [NSString stringWithFormat:@"\"ent_contact_resume_log_id\":\"%@\"",[NSString stringNoneNullFromValue:resumeId]];
    if (contactResultType) {
        content = [content stringByAppendingString:[NSString stringWithFormat:@",\"contact_result_type\":\"%@\"",[NSString stringNoneNullFromValue:contactResultType]]];
    }
    
    if (contactRemark) {
        content = [content stringByAppendingString:[NSString stringWithFormat:@",\"contact_remark\":\"%@\"",contactRemark]];
    }
    
    RequestInfo *request = [[RequestInfo alloc]initWithService:@"shijianke_entContactResumeFeedback" andContent:content];
    request.isShowLoading = YES;
    [request sendRequestWithResponseBlock:^(ResponseInfo *response) {
        if (response && response.success ) {
            [UIHelper toast:@"提交完成"];
            MKBlockExec(block,response);
        }else{
            MKBlockExec(block,nil);
        }
    }];


}
/** 雇主收藏兼客简历 */
- (void)collectStudent:(NSNumber *)accountId block:(MKBlock)block{
    NSString *content = [NSString stringWithFormat:@"\"stu_account_id\":\"%@\"", accountId];
    RequestInfo *request = [[RequestInfo alloc] initWithService:@"shijianke_collectStudent" andContent:content];
    [request sendRequestWithResponseBlock:^(ResponseInfo *response) {
        if (response && response.success) {
            MKBlockExec(block, response);
        }else{
            MKBlockExec(block, nil);
        }
    }];
}

/** 取消收藏兼客 */
- (void)cancelCollectedStudent:(NSNumber *)accountId block:(MKBlock)block{
    NSString *content = [NSString stringWithFormat:@"\"stu_account_id\":\"%@\"", accountId];
    RequestInfo *request = [[RequestInfo alloc] initWithService:@"shijianke_cancelCollectedStudent" andContent:content];
    [request sendRequestWithResponseBlock:^(ResponseInfo *response) {
        if (response && response.success) {
            MKBlockExec(block, response);
        }else{
            MKBlockExec(block, nil);
        }
    }];
}

/** 查询包代招信息列表 */
- (void)queryArrangedAgentVasInfoList:(MKBlock)block{
    RequestInfo *request = [[RequestInfo alloc] initWithService:@"shijianke_queryArrangedAgentVasInfoList" andContent:nil];
    request.isShowLoading = YES;
    [request sendRequestWithResponseBlock:^(ResponseInfo *response) {
        if (response && response.success) {
            MKBlockExec(block, response);
        }else{
            MKBlockExec(block, nil);
        }
    }];
}

/** 查询包代招报名数各岗位消耗情况列表 */
- (void)queryJobListByArrangedAgentVasOrder:(NSNumber *)orderId queryParam:(QueryParamModel *)queryParam block:(MKBlock)block{
    NSString *content = [NSString stringWithFormat:@"arranged_agent_vas_order_id: %@, %@", orderId, [queryParam getContent]];
    RequestInfo *request = [[RequestInfo alloc] initWithService:@"shijianke_queryJobListByArrangedAgentVasOrder" andContent:content];
    [request sendRequestWithResponseBlock:^(ResponseInfo *response) {
        if (response && response.success) {
            MKBlockExec(block, response);
        }else{
            MKBlockExec(block, nil);
        }
    }];
}

/** 查询包代招岗位报名列表 */
- (void)queryApplyListByArrangedAgentVasOrder:(NSNumber *)orderId jobId:(NSNumber *)jobId queryParam:(QueryParamModel *)queryParam block:(MKBlock)block{
    NSString *content = [NSString stringWithFormat:@"arranged_agent_vas_order_id: %@, %@, job_id: %@", orderId, [queryParam getContent], jobId];
    RequestInfo *request = [[RequestInfo alloc] initWithService:@"shijianke_queryApplyListByArrangedAgentVasOrder" andContent:content];
    [request sendRequestWithResponseBlock:^(ResponseInfo *response) {
        if (response && response.success) {
            MKBlockExec(block, response);
        }else{
            MKBlockExec(block, nil);
        }
    }];
}

#pragma mark - ***** 弃用 ******
/** 获取广告,兼客头条,雇主头条 */
- (void)getAdvertisementListWithAdSiteId:(NSString *)adSiteId cityId:(NSString *)cityId block:(MKBlock)block{
    NSString *content = [NSString stringWithFormat:@"ad_site_id:%@, city_id:%@", adSiteId, cityId];
    RequestInfo *request = [[RequestInfo alloc] initWithService:@"shijianke_getAdvertisementList" andContent:content];
    [request sendRequestWithResponseBlock:^(ResponseInfo *response) {
        MKBlockExec(block,response);
    }];
}

@end


