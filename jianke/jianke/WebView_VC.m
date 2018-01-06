    //
//  WebView_VC.m
//  jianke
//
//  Created by xiaomk on 15/9/17.
//  Copyright (c) 2015年 xianshijian. All rights reserved.
//

#import "WebView_VC.h"
#import "NJKWebViewProgress.h"
#import "NJKWebViewProgressView.h"
#import "LookupResume_VC.h"
#import "IdentityCardAuth_VC.h"
#import <JavaScriptCore/JavaScriptCore.h>
#import "JobDetail_VC.h"
#import "WDConst.h"
#import "HelpCenterSearch_VC.h"
#import "ShareHelper.h"
#import "MKActionSheet.h"
#import "MoneyBag_VC.h"
#import "PostPersonalJob_VC.h"
#import "PaySelect_VC.h"
#import "PushOrder_VC.h"
#import "PostSalaryJob_VC.h"
#import "MKOpenUrlHelper.h"
#import "MarketServiceMag_VC.h"
#import <WebKit/WebKit.h>
#import <JavaScriptCore/JavaScriptCore.h>
#import <AlipaySDK/AlipaySDK.h>
#import <MediaPlayer/MediaPlayer.h>
#import <AVKit/AVKit.h>
#import "AVPlay_VC.h"

typedef NS_ENUM(NSInteger, GestureStateType) {
    GestureStateType_start = 1,
    GestureStateType_move = 2,
    GestureStateType_end = 3,
};

@interface WebView_VC ()<WKNavigationDelegate, WKScriptMessageHandler, WKUIDelegate, UIGestureRecognizerDelegate>{

    NSURLRequest* _request; /*!< 请求连接 */
    
    NSString* _firstRelativePath;   /*!< 首页 */
    NSString* _nowRelativePath;     /*!< 当前页 */
    NSString* _nowRequestUrl;       /*!< 当前的URL 分享用 */
    NSString* _webTitle;            /*!< 标题 */
    
    NSString* _imgURL;              /*!< 图片URL */
    NSString* _shareUrl;            /*!< 分享URl */
    
    NSString * _pageUrlOfShare;     /*!< 具有分享交互的web页面链接 */
}

@property (nonatomic, strong) WKWebView* webView;
@property (nonatomic, strong) UIButton* btnBack;
@property (nonatomic, strong) UIBarButtonItem* rightItemMShare;
@property (nonatomic, strong) ShareInfoModel *shareModel;
@property (nonatomic, strong) UIProgressView *progressView;

@end

//#define kk
#define kTouchJavaScriptString [NSString stringWithFormat:@"\
                                                JKAPP = new Object();\
                                                JKAPP.WebViewPaySucc = function(){\
                                                document.location=\"myweb:jump:MoneyBag\";};\
                                                window.getAppIntVersion=function(){return %d;};\
                                                window.triggerAppMethod=function(obj1, obj2){\
                                                    var json = JSON.stringify({\
                                                        'flg':obj1,\
                                                        'val':obj2\
                                                    });\
                                                    window.webkit.messageHandlers.AppModel.postMessage(json)\
                                                };\
                                                window.appShare=function(share_img_url, share_title, share_url, share_content){\
                                                    var json = JSON.stringify({\
                                                        'share_img_url':share_img_url,\
                                                        'share_title':share_title,\
                                                        'share_url':share_url,\
                                                        'share_content':share_content,\
                                                    });\
                                                    window.webkit.messageHandlers.ShareAppModel.postMessage(json)\
                                                };"\
                                                ,[MKDeviceHelper getAppIntVersion]]



static NSString* const kZhaiTaskMainUrl = @"zhongbao";
static NSString* const kZhaiTaskUrl = @"/task/";     /*!< 识别宅任务URL */

@implementation WebView_VC

- (void)viewDidLoad {
    self.isRootVC = YES;
    [super viewDidLoad];
    
    DLog(@"self.url:%@",self.url);
    [WDNotificationCenter addObserver:self selector:@selector(backAction) name:WDNotification_backFromMoneyBag object:nil];
    self.navigationController.interactivePopGestureRecognizer.delegate = self;
    
    NSRange rangeZB = [self.url rangeOfString:kZhaiTaskMainUrl];
    if (rangeZB.location != NSNotFound) {
        self.uiType = WebViewUIType_ZhaiTask;
    }
    
    
    self.webView = [[WKWebView alloc] initWithFrame:CGRectZero];
    NSString *jScript = [NSString stringWithFormat:@"%@", kTouchJavaScriptString];
    WKUserScript *wkUScript = [[WKUserScript alloc] initWithSource:jScript injectionTime:WKUserScriptInjectionTimeAtDocumentEnd forMainFrameOnly:YES];
    WKUserContentController *wkUController = [[WKUserContentController alloc] init];
    [wkUController addUserScript:wkUScript];
    
    WKWebViewConfiguration *wkWebConfig = [[WKWebViewConfiguration alloc] init];
    wkWebConfig.allowsInlineMediaPlayback = YES;
    wkWebConfig.userContentController = wkUController;
    
    self.webView = [[WKWebView alloc] initWithFrame:CGRectZero configuration:wkWebConfig];
    self.webView.navigationDelegate = self;
    [self.view addSubview:self.webView];
    [self addObserver];
    
    self.progressView = [[UIProgressView alloc] init];
    self.progressView.progress = 0;
    self.progressView.progressTintColor = [UIColor whiteColor];
    self.progressView.trackTintColor = [UIColor XSJColor_blackBase];
    [self.view addSubview:self.progressView];
    
    [self.webView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    [self.progressView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.view);
        make.height.equalTo(@2);
    }];
    
    if (self.fixednessTitle) {
        self.title = self.fixednessTitle;
    }
    
    //返回按钮
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = CGRectMake(0, 0, 36, 44);
    [backBtn setImage:[UIImage imageNamed:@"v3_public_img_back"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(btnBackOnclick:) forControlEvents:UIControlEventTouchUpInside];;
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    
    self.btnBack = [UIButton buttonWithType:UIButtonTypeCustom];
    self.btnBack.frame = CGRectMake(0, 0, 36, 44);
    [self.btnBack setImage:[UIImage imageNamed:@"v3_public_close"] forState:UIControlStateNormal];
    [self.btnBack addTarget:self action:@selector(backToLastView) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *closeItem = [[UIBarButtonItem alloc] initWithCustomView:self.btnBack];
    
    UIBarButtonItem *nevgativeSpaceLeft = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    nevgativeSpaceLeft.width = -14;
    self.navigationItem.leftBarButtonItems = @[nevgativeSpaceLeft,backItem,closeItem];
    
    if (self.uiType) {
        switch (self.uiType) {
            case WebViewUIType_ServiceDetail:{
                NSAssert(self.service_classify_id, @"uiType枚举类型为WebViewUIType_ServiceDetail时，service_classify_id不能为空");
            }
            case WebViewUIType_salaryGuide:
            case webViewUIType_myMarketOrder:
            case WebViewUIType_starManage:{
                self.navigationItem.rightBarButtonItem = [self getRightBarButtonItem];
            }
                break;
            case WebViewUIType_Banner:
            case WebViewUIType_Feature:
            case WebViewUIType_ZhaiTask:
            case WebViewUIType_PersonalServiceDetail:{
                UIButton* btnShare = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
                [btnShare setImage:[UIImage imageNamed:@"v3_job_share"] forState:UIControlStateNormal];
                [btnShare setImage:[UIImage imageNamed:@"v3_job_share"] forState:UIControlStateHighlighted];
                [btnShare addTarget:self action:@selector(btnShareOnclick:) forControlEvents:UIControlEventTouchUpInside];
                self.rightItemMShare = [[UIBarButtonItem alloc] initWithCustomView:btnShare];
                self.navigationItem.rightBarButtonItem = self.rightItemMShare;
            }
                break;
            default:
                break;
        }
    }
  
    [self loadRequestUrl];
}

- (void)loadRequestUrl{
    __block NSURL* requestUrl;
    if (self.urlCacheType) {        //显示本地
        switch (self.urlCacheType) {
            case WebViewURLCacheType_JianKeAgreement:
                requestUrl = [[NSBundle mainBundle] URLForResource:@"JianKeAgreement" withExtension:@".rtf"];
                break;
            default:
                break;
        }
        _request = [NSURLRequest requestWithURL:requestUrl];
        
        if (!self.isSocialActivist) {   //如果是人脉王界面 在 viewDidAppear 里请求
            [self.webView loadRequest:_request];
        }
    }else{
        __block NSString *urlStr;
        
        BOOL isNeedToken = NO;
        NSRange rangejk = [self.url rangeOfString:@"shijianke"];
        if (rangejk.location != NSNotFound) {
            isNeedToken = YES;
        }
        if (!isNeedToken) {
            rangejk = [self.url rangeOfString:@"jianke"];
            if (rangejk.location != NSNotFound) {
                isNeedToken = YES;  
            }
        }
        
        if (isNeedToken) {
            __block NSString *user_token;
            __block NSString *accountType;
            if ([[UserData sharedInstance] isLogin]) {
                [[XSJRequestHelper sharedInstance] checkUserLogin:^(id result) {
                    user_token = [XSJNetWork getToken];
                    if (!user_token || user_token.length == 0) {
                        user_token = @"0";
                    }
                    NSNumber *loginType = [[UserData sharedInstance] getLoginType];
                    accountType = loginType.stringValue;
                    NSNumber *cityId = [UserData sharedInstance].city.id ? [UserData sharedInstance].city.id : @211;
                    NSRange range = [self.url rangeOfString:@"?"];
                    if (range.location == NSNotFound){
                        urlStr = [NSString stringWithFormat:@"%@?app_user_token=%@&account_type=%@&is_from_app=1&client=ios&city_id=%@", self.url, user_token, accountType, cityId];
                    }else{
                        urlStr = [NSString stringWithFormat:@"%@&app_user_token=%@&account_type=%@&is_from_app=1&client=ios&city_id=%@", self.url, user_token, accountType, cityId];
                    };
                    
                    requestUrl = [NSURL URLWithString:urlStr];
                    _request = [NSURLRequest requestWithURL:requestUrl];
                    
                    if (!self.isSocialActivist) {   //如果是人脉王界面 在 viewDidAppear 里请求
                        [self.webView loadRequest:_request];
                    }
                }];
            }else{
                user_token = @"0";
                accountType = @"0";
                
                NSNumber *cityId = [UserData sharedInstance].city.id ? [UserData sharedInstance].city.id : @211;
                NSRange range = [self.url rangeOfString:@"?"];
                if (range.location == NSNotFound){
                    urlStr = [NSString stringWithFormat:@"%@?app_user_token=%@&account_type=%@&is_from_app=1&client=ios&city_id=%@", self.url, user_token, accountType, cityId];
                }else{
                    urlStr = [NSString stringWithFormat:@"%@&app_user_token=%@&account_type=%@&is_from_app=1&client=ios&city_id=%@", self.url, user_token, accountType, cityId];
                };
                requestUrl = [NSURL URLWithString:urlStr];
                _request = [NSURLRequest requestWithURL:requestUrl];
                
                if (!self.isSocialActivist) {   //如果是人脉王界面 在 viewDidAppear 里请求
                    [self.webView loadRequest:_request];
                }
            }

        }else{             urlStr = self.url;
            requestUrl = [NSURL URLWithString:urlStr];
            _request = [NSURLRequest requestWithURL:requestUrl];
            
            if (!self.isSocialActivist) {   //如果是人脉王界面 在 viewDidAppear 里请求
                [self.webView loadRequest:_request];
            }
        }

    }
}

- (void)addObserver{
    [self.webView addObserver:self
                   forKeyPath:@"loading"
                      options:NSKeyValueObservingOptionNew
                      context:nil];
    if (!self.fixednessTitle) {
        [self.webView addObserver:self
                       forKeyPath:@"title"
                          options:NSKeyValueObservingOptionNew
                          context:nil];
    }
    [self.webView addObserver:self
                   forKeyPath:@"estimatedProgress"
                      options:NSKeyValueObservingOptionNew
                      context:nil];
}

- (void)removeObserver{
    [self.webView removeObserver:self forKeyPath:@"estimatedProgress"];
    if (!self.fixednessTitle) {
        [self.webView removeObserver:self forKeyPath:@"title"];
    }
    
    [self.webView removeObserver:self forKeyPath:@"loading"];
}

- (void)addScriptMessageHandler{
    [self.webView.configuration.userContentController addScriptMessageHandler:self name:@"AppModel"];
    [self.webView.configuration.userContentController addScriptMessageHandler:self name:@"ShareAppModel"];
}

- (void)removeScriptMessageHandler{
    [self.webView.configuration.userContentController removeScriptMessageHandlerForName:@"AppModel"];
    [self.webView.configuration.userContentController removeScriptMessageHandlerForName:@"ShareAppModel"];
}

#pragma mark - view appear
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    // 添加KVO监听
    [WDNotificationCenter addObserver:self
                             selector:@selector(payUrlOrderCallBack:)
                                 name:AlipayResponseNotification object:nil];
    [self addScriptMessageHandler];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    if (_request && self.isSocialActivist) {
        [self.webView loadRequest:_request];
    }
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [WDNotificationCenter removeObserver:self name:AlipayResponseNotification object:nil];
    [self removeScriptMessageHandler];
}


#pragma mark - *****  按钮事件 ******
/** 分享 按钮 */
- (void)btnShareOnclick:(UIButton*)sender{
    if (self.shareModel) {
        [ShareHelper platFormShareWithVc:self info:self.shareModel block:^(id obj) {
        }];
    }else{
        if (self.uiType == WebViewUIType_ZhaiTask && _nowRequestUrl.length > 0) {    //宅任务
            ShareInfoModel* model = [[ShareInfoModel alloc] init];
            model.share_title = self.fixednessTitle ? self.fixednessTitle : _webTitle;
            model.share_content = [NSString stringWithFormat:@"我正在看【%@】，分享给你，一起看吧!",_webTitle];
            NSRange range = [self.url rangeOfString:@"?"];
            if (range.location == NSNotFound) {
                model.share_url = [self.url stringByAppendingString:@"?is_share=1"];
            }else{
                model.share_url = [self.url stringByAppendingString:@"&is_share=1"];
            }
            [ShareHelper platFormShareWithVc:self info:model block:^(id obj) {
            }];
        }else{  //不是宅任务
            if (!_webTitle.length && !self.fixednessTitle.length) {
                _webTitle = @" ";
            }
            ShareInfoModel* model = [[ShareInfoModel alloc] init];
            model.share_title = self.fixednessTitle ? self.fixednessTitle : _webTitle;
            NSRange range = [self.url rangeOfString:@"?"];
            if (range.location == NSNotFound) {
                model.share_url = [self.url stringByAppendingString:@"?is_share=1"];
            }else{
                model.share_url = [self.url stringByAppendingString:@"&is_share=1"];
            }
            
            model.share_content = [NSString stringWithFormat:@"我正在看【%@】，分享给你，一起看吧!",_webTitle];
            [ShareHelper platFormShareWithVc:self info:model block:^(id obj) {
            }];
        }
    }
    
}

- (void)editServiceDetail{
    WebView_VC *viewCtrl = [[WebView_VC alloc] init];
    NSString *url = [NSString stringWithFormat:@"%@%@?classifyId=%@", URL_HttpServer, KUrl_toPostServiceInfoPage, self.service_classify_id];
    viewCtrl.url = url;
    viewCtrl.competeBlock = self.competeBlock;
    [self.navigationController pushViewController:viewCtrl animated:YES];
}

- (void)postSalaryJob{
    PostSalaryJob_VC *viewCtrl = [[PostSalaryJob_VC alloc] init];
    [self.navigationController pushViewController:viewCtrl animated:YES];
}

- (void)viewMyMarketorder{
    MarketServiceMag_VC *viewCtrl = [[MarketServiceMag_VC alloc] init];
    [self.navigationController pushViewController:viewCtrl animated:YES];
}

- (void)starManage{
    [[UserData sharedInstance] handleGlobalRMUrlWithType:GlobalRMUrlType_queryServicePersonalJobList block:^(UIViewController *vc) {
        [self.navigationController pushViewController:vc animated:YES];
    }];
}

#pragma mark - ***** UIWebView delegate ******

- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler{
    
    NSString *urlStr = navigationAction.request.URL.absoluteString;
    _nowRequestUrl = [urlStr copy];
    ELog(@"requestURL:%@",urlStr);
    
    NSURL *url = navigationAction.request.URL;
    if ([url.scheme isEqualToString:@"tel"])
    {
        [[MKOpenUrlHelper sharedInstance] callWithPhoneUrl:url];
        decisionHandler(WKNavigationActionPolicyCancel);
        return;
    }
    if ([url.absoluteString containsString:@"itunes.apple.com"])
    {
        [[MKOpenUrlHelper sharedInstance] openItunesWithUrl:url];
        decisionHandler(WKNavigationActionPolicyCancel);
        return;
    }
    
    if (!self.uiType && self.rightItemMShare) {
        self.rightItemMShare = nil;
        self.navigationItem.rightBarButtonItem = nil;
    }
    
    if (self.uiType == WebViewUIType_starManage) {
        ClientGlobalInfoRM *gloablRM = [[XSJRequestHelper sharedInstance] getClientGlobalModel];
        if (gloablRM.wap_url_list.query_service_personal_job_list_url.length) {
//            if ([urlStr hasPrefix:gloablRM.wap_url_list.query_service_personal_job_list_url]) {
                self.navigationItem.rightBarButtonItem = [self getRightBarButtonItem];
//            }
        }
    }
    
    //alipay支付
    NSString *orderInfo = [[AlipaySDK defaultService] fetchOrderInfoFromH5PayUrl:urlStr];
    if (orderInfo.length > 0) {
        NSString* fromScheme = @"JKHireapp";
        WEAKSELF
        [[AlipaySDK defaultService] payUrlOrder:orderInfo fromScheme:fromScheme callback:^(NSDictionary *resultDic) {
            [weakSelf handelPayOrderResult:resultDic];
        }];
        decisionHandler(WKNavigationActionPolicyCancel);
        return;
    }
    
    NSString* relativePathStr = navigationAction.request.mainDocumentURL.relativePath;
    if (!_firstRelativePath) {
        _firstRelativePath = [relativePathStr copy];
    }
    _nowRelativePath = [relativePathStr copy];
  
    //人脉王 认证
    if ([relativePathStr isEqualToString:@"/IDCardAuth"]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            IdentityCardAuth_VC* vc = [[IdentityCardAuth_VC alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        });
        decisionHandler(WKNavigationActionPolicyCancel);
        return;
    }
    
    //岗位详情 跳转 原生界面
    if (relativePathStr.length > 5) {
        NSArray* paramAry = [relativePathStr componentsSeparatedByString:@"/"];
    
        if (paramAry.count >= 3) {
            NSString* funName = [[NSString alloc] initWithString:paramAry[1]];
            if ([funName isEqualToString:@"job"]) {
                NSMutableString* funParam = [[NSMutableString alloc] initWithString:paramAry[2]];
                NSRange subStr;
                subStr = [funParam rangeOfString:@".html"];
                if (subStr.location != NSNotFound) {
                    [funParam deleteCharactersInRange:subStr];
                    ELog(@"funParam:%@",funParam);
                    [self pushToJobDetailWithJobUuid:funParam];
                    decisionHandler(WKNavigationActionPolicyCancel);
                    return;
                }else{
                    ELog(@"=====参数错误");
                }
            }
        }
    }
    if ([urlStr hasPrefix:@"jiankeapp://"]) {
        decisionHandler(WKNavigationActionPolicyCancel);
        return;
    }
    decisionHandler(WKNavigationActionPolicyAllow);
}


- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error{
     ELog(@"=====error:%@",error);
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(null_unspecified WKNavigation *)navigation{
//    [webView evaluateJavaScript:kTouchJavaScriptString completionHandler:^(id _Nullable obj, NSError * _Nullable error) {
//        
//    }];
//    [self makeJsMothod];
//    [webView evaluateJavaScript:@"var obj = window.getAppIntVersion();window.location.href= obj;" completionHandler:^(id _Nullable obj, NSError * _Nullable error) {
//        if (error) {
//            ELog(@"error:%@", [error localizedDescription]);
//        }
//    }];
}

- (void)webView:(WKWebView *)webView didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition disposition, NSURLCredential *__nullable credential))completionHandler {
    completionHandler(NSURLSessionAuthChallengePerformDefaultHandling, nil);
}

- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message{
    
    if ([message.name isEqualToString:@"AppModel"]) {
        if (!message.body) {
            return;
        }
        NSDictionary *messagDic = [self convertJsonFromStr:message.body];
        
        NSString *flag = [messagDic objectForKey:@"flg"];
        NSDictionary *jsVal = [self convertJsonFromStr:[messagDic objectForKey:@"val"]];
        NSDictionary *dic = [jsVal objectForKey:@"param"];
//        NSDictionary *dic = [resultDic objectForKey:@"param"];
        switch (flag.integerValue) {
            case JSFlagType_activePsersonalOrder:{ //唤起个人服务商订单
                PostPersonalJob_VC *viewCtrl = [[PostPersonalJob_VC alloc] init];
                viewCtrl.serviceType = [dic objectForKey:@"service_type"];
                viewCtrl.stu_account_id = [dic objectForKey:@"stu_account_id"];
                viewCtrl.sourceType = ViewSourceType_InvitePersonalJob;
                [self.navigationController pushViewController:viewCtrl animated:YES];
            }
                break;
            case JSFlagType_payForTelphone:{
                int needPatMoney = [[dic objectForKey:@"pay_money"] intValue];
                NSNumber *orderId = [dic objectForKey:@"service_personal_job_apply_id"];
                WEAKSELF
                [[XSJRequestHelper sharedInstance] entRechargeServicePersonalWithJobApplyId:orderId block:^(ResponseInfo *result) {
                    if (result) {
                        PaySelect_VC *viewCtrl = [[PaySelect_VC alloc] init];
                        viewCtrl.service_personal_order_id = [result.content objectForKey:@"service_personal_order_id"];
                        viewCtrl.needPayMoney = needPatMoney;
                        viewCtrl.fromType = PaySelectFromType_ServicePersonalOrder;
                        viewCtrl.updateDataBlock = weakSelf.competeBlock;
                        [weakSelf.navigationController pushViewController:viewCtrl animated:YES];
                    }
                }];
            }
                break;
            case JSFlagType_activeTeamOrder:{
//                NSDictionary *dic = [resultDic objectForKey:@"param"];
                PostPersonalJob_VC *viewCtrl = [[PostPersonalJob_VC alloc] init];
                viewCtrl.service_classify_id = [dic objectForKey:@"service_classify_id"];
                viewCtrl.service_apply_id = [dic objectForKey:@"service_apply_id"];
                viewCtrl.service_classify_name = [dic objectForKey:@"service_classify_name"];
                viewCtrl.sourceType = ViewSourceType_InviteTeamJob;
                [self.navigationController pushViewController:viewCtrl animated:YES];
            }
                break;
            case JSFlagType_PersonalSuccessInvited:{
                MKBlockExec(self.competeBlock, nil);
            }
                break;
            case JSFlagType_successContactWithTeam:{
                MKBlockExec(self.competeBlock, nil);
            }
                break;
            case JSFlagType_successPostedService:{
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (self.isPopToRootVC) {
                        [self.navigationController popToRootViewControllerAnimated:YES];
                    }else{
                        MKBlockExec(self.competeBlock, nil);
                        [self.navigationController popViewControllerAnimated:YES];
                    }
                });
            }
                break;
            case JSFlagType_webFinishLoadForShare:{
                if (!self.rightItemMShare) {
                    UIButton* btnShare = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
                    [btnShare setImage:[UIImage imageNamed:@"v3_job_share"] forState:UIControlStateNormal];
                    [btnShare setImage:[UIImage imageNamed:@"v3_job_share"] forState:UIControlStateHighlighted];
                    [btnShare addTarget:self action:@selector(btnShareOnclick:) forControlEvents:UIControlEventTouchUpInside];
                    self.rightItemMShare = [[UIBarButtonItem alloc] initWithCustomView:btnShare];
                    self.navigationItem.rightBarButtonItem = self.rightItemMShare;
                }

                self.shareModel = [ShareInfoModel objectWithKeyValues:dic];
            }
                break;
            case JSFlagType_callShareMethod:{
                ShareInfoModel *shareModel = [ShareInfoModel objectWithKeyValues:dic];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [ShareHelper platFormShareWithVc:self info:shareModel block:^(id obj) {
                    }];
                });
            }
                break;
            case JSFlagType_activeJobVasOrderForPush:{
                PushOrder_VC *viewCtrl = [[PushOrder_VC alloc] init];
                viewCtrl.jobId = dic[@"job_id"];
                viewCtrl.jumpBackOpen = YES;
                [self.navigationController pushViewController:viewCtrl animated:YES];
            }
                break;
            case JSFlagType_playVideo:{
                [self callJSCallBackWithplayVideo:dic];
            }
                break;
            default:
                break;
        }
        //        NSString *flg =
        ELog(@"可以被点击");
    }else if ([message.name isEqualToString:@"ShareAppModel"]){
        if (!message.body) {
            return;
        }
        
        NSDictionary *resultDic = [self convertJsonFromStr:message.body];
        ShareInfoModel* model = [[ShareInfoModel alloc] init];
        
        model.share_img_url = [resultDic objectForKey:@"share_img_url"];
        model.share_title = [resultDic objectForKey:@"share_title"];
        model.share_url = [resultDic objectForKey:@"share_url"];
        model.share_content = [resultDic objectForKey:@"share_content"];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [ShareHelper platFormShareWithVc:self info:model block:^(id obj) {
            }];
        });
    }

}

#pragma mark - ****** 客户端与web交互 ******

//视频播放
- (void)callJSCallBackWithplayVideo:(NSDictionary *)dic{
    NSString *videoUrlStr = [dic objectForKey:@"video_url"];
    if (!videoUrlStr.length) {
        [UIHelper toast:@"视频无法播放"];
        return;
    }
    WEAKSELF
    dispatch_async(dispatch_get_main_queue(), ^{
        AVPlay_VC *avPlayerVC = [[AVPlay_VC alloc] init];
        avPlayerVC.player = [AVPlayer playerWithURL:[NSURL URLWithString:videoUrlStr]];
        [weakSelf presentViewController:avPlayerVC animated:YES completion:^{
            
        }];
    });
}

#pragma mark - KVO
- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary<NSString *,id> *)change
                       context:(void *)context {
    if ([keyPath isEqualToString:@"loading"]) {
        ELog(@"loading");
    } else if ([keyPath isEqualToString:@"title"]) {
        _webTitle = self.webView.title;
        self.title = self.webView.title;
    } else if ([keyPath isEqualToString:@"estimatedProgress"]) {
        ELog(@"progress: %f", self.webView.estimatedProgress);
        self.progressView.progress = self.webView.estimatedProgress;
    }
    
    // 加载完成
    if (!self.webView.loading) {
        [UIView animateWithDuration:0.5 animations:^{
            self.progressView.alpha = 0;
        }];
    }else{
        self.progressView.alpha = 1;
    }
}

#pragma mark - ******支付宝支付相关*******
- (void)loadWithUrlStr:(NSString *)urlStr{
    if (!urlStr.length) {
        return;
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        NSURLRequest *webRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:urlStr]
                                                    cachePolicy:NSURLRequestReturnCacheDataElseLoad
                                                timeoutInterval:30];
        [self.webView loadRequest:webRequest];
    });
}

//app支付回调通知
- (void)payUrlOrderCallBack:(NSNotification *)notification{
    dispatch_async(dispatch_get_main_queue(), ^{
        NSDictionary *resultDic = notification.userInfo;
        [self handelPayOrderResult:resultDic];
    });
}

//支付结果处理
- (void)handelPayOrderResult:(NSDictionary *)resultDic{
    if ([resultDic[@"isProcessUrlPay"] boolValue] && [resultDic[@"resultCode"] isEqualToString:@"9000"]) {
        // returnUrl 代表 第三方App需要跳转的成功页URL
//        [UIHelper toast:@"支付成功"];
//        [self.navigationController popViewControllerAnimated:NO];
//        MKBlockExec(self.block, nil);
        NSString* urlStr = resultDic[@"returnUrl"];
        [self loadWithUrlStr:urlStr];
        
    }else{
//        [UIHelper toast:@"支付失败"];
        if ([self.webView canGoBack]) {
            [self.webView goBack];
        }
    }
}

#pragma mark - detail handel

- (void)pushToJobDetailWithJobUuid:(NSString*)jobUuid{
    WEAKSELF
    dispatch_async(dispatch_get_main_queue(), ^{
        JobDetail_VC* vc = [[JobDetail_VC alloc] init];
        vc.jobUuid = jobUuid;
        [weakSelf.navigationController pushViewController:vc animated:YES];
    });
}

- (NSDictionary *)convertJsonFromStr:(NSString *)jsonStr{
    if (!jsonStr.length) {
        return nil;
    }
    NSData *data = [jsonStr dataUsingEncoding:NSUTF8StringEncoding];
    NSError *error;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
    if (error) {
        ELog(@"解析错误:%@", [error localizedDescription]);
    }
    return dic;
}

/** 调用JS方法 */
- (void)callJs:(NSString *)jsFuncStr {
    dispatch_async(dispatch_get_main_queue(), ^{
        JSContext *context = [self.webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
        [context evaluateScript:jsFuncStr];
    });
}

- (UIBarButtonItem *)getRightBarButtonItem{
    NSAssert(self.uiType, @"uiType不能为空!!");
    NSString *title = @"";
    CGFloat width = 100;
    switch (self.uiType) {
        case webViewUIType_myMarketOrder:
            title = @"我的推广订单";
            width = 100;
            break;
        case WebViewUIType_salaryGuide:
            title = @"新建代发岗位";
            width = 100;
            break;
        case WebViewUIType_ServiceDetail:
            title = @"编辑";
            width = 40;
            break;
        case WebViewUIType_starManage:
            title = @"通告管理";
            width = 100;
            break;
        default:
            break;
    }
    
    UIButton *btnQrCode = [UIButton buttonWithType:UIButtonTypeCustom];
    btnQrCode.frame = CGRectMake(0, 0, width, 44);
    btnQrCode.titleLabel.font = [UIFont systemFontOfSize:16];
    [btnQrCode setTitle:title forState:UIControlStateNormal];
    [btnQrCode setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btnQrCode addTarget:self action:@selector(rightItemOnClick) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:btnQrCode];
    return rightItem;
}

- (void)rightItemOnClick{
    switch (self.uiType) {
        case webViewUIType_myMarketOrder:{
            [self viewMyMarketorder];
        }
            break;
        case WebViewUIType_salaryGuide:{
            [self postSalaryJob];
        }
            break;
        case WebViewUIType_ServiceDetail:{
            [self editServiceDetail];
        }
            break;
        case WebViewUIType_starManage:{
            [self starManage];
        }
            break;
        default:
            break;
    }
}

#pragma mark - ***** 返回 关闭 按钮 ******
- (void)btnBackOnclick:(UIButton*)sender{
    if (![self.webView canGoBack]) {
        if (self.isFromTeamPost) {
            [self.navigationController popToViewController:[[UserData sharedInstance] popViewCtrl] animated:YES];
        }else{
            [self.navigationController popViewControllerAnimated:YES];
        }
    }else if(self.isPopToRootVC){
        [self.navigationController popToRootViewControllerAnimated:YES];
    }else{
        [self.webView goBack];
    }
}

- (void)backToLastView{
    if (self.isFromTeamPost) {
        [self.navigationController popToViewController:[[UserData sharedInstance] popViewCtrl] animated:YES];
    }else if(self.isPopToRootVC){
        [self.navigationController popToRootViewControllerAnimated:YES];
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
}


#pragma mark - **** 通知返回 ****

- (void)backAction{
    if (self.popViewCtrl) {
        [self.navigationController popToViewController:self.popViewCtrl animated:YES];
    }
}

#pragma mark - ***** dealloc ******
- (void)dealloc{
    DLog(@"*** dealloc webView");
    [self removeObserver];
    [WDNotificationCenter removeObserver:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
