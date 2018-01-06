//
//  WebView_VC.h
//  jianke
//
//  Created by xiaomk on 15/9/17.
//  Copyright (c) 2015年 xianshijian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WDViewControllerBase.h"
#import "WDConst.h"

// 从本地获取 NSURL 显示WebViewUIType_ZhaiTask
typedef NS_ENUM(NSInteger, WebViewURLCacheType) {
    WebViewURLCacheType_JianKeAgreement = 1    //用户协议
    
};

typedef NS_ENUM(NSInteger, WebViewUIType) {
    WebViewUIType_ZhaiTask = 1,     //宅任务
    WebViewUIType_Feature = 2,      //兼客首页 特色入口
    WebViewUIType_Banner = 3,        //兼客首页 广告条
    WebViewUIType_ServiceDetail = 4,     //雇主查看自己的服务商详情
    WebViewUIType_PersonalServiceDetail = 5,        //兼客 个人服务详情
    WebViewUIType_salaryGuide = 6,  //引导代发工资页
    webViewUIType_myMarketOrder = 7,    //推广页面
    WebViewUIType_starManage = 8,   //通告管理
};

typedef NS_ENUM(NSInteger, JSFlagType) {
    JSFlagType_activePsersonalOrder = 1, //1、唤起发个人服务商订单（优聘）
    JSFlagType_payForTelphone = 2,  //2、支付查看个人服务商电话费用（优聘）
    JSFlagType_activeTeamOrder = 3, //3、唤起发团队服务商订单（优聘）
    JSFlagType_previewPhotos = 4, //4、图片预览（优聘）
    JSFlagType_PersonalSuccessInvited = 5, //5、个人服务商邀约成功调用js方法（优聘）
    JSFlagType_successContactWithTeam = 6, //6、联系团队服务商成功后调用js方法（优聘）
    JSFlagType_successPostedService = 8,    //8、发布服务成功后调用js方法（优聘）
    JSFlagType_webFinishLoadForShare = 9,   //9、	设置分享出去的内容，前端页面加载完成后调用（兼客兼职，兼客优聘）
    JSFlagType_callShareMethod = 10, //10、	调用客户端分享的方法（兼客兼职，兼客优聘）
    JSFlagType_playVideo =12,   //12、调用客户端播放视频方法 （兼客兼职，兼客优聘）
    JSFlagType_activeJobVasOrderForPush = 14, //14、推广记录再次推送推广（兼客优聘）
};

@interface WebView_VC : WDViewControllerBase

@property (nonatomic, copy) NSString* fixednessTitle;   /*!< 固定不变的 title, 否则会根据 web 的显示 改变title */
@property (nonatomic, copy) NSString* url;              /*!< 访问的URL */
@property (nonatomic, assign) WebViewURLCacheType urlCacheType; /*!< 显示本地界面类型 */
@property (nonatomic, assign) WebViewUIType uiType;     /*!< 显示界面类型 */
@property (nonatomic, assign) BOOL notScalesPageToFit;  /*!< 默认为 no */
@property (nonatomic, assign) BOOL isSocialActivist;    /*!< 是否是人脉王页面 */
@property (nonatomic, assign) BOOL isHelperCenter;      /*!< 帮助中心页面 */
@property (nonatomic, assign) BOOL isFromTeamPost;  /*!< 是否来自团队需求发布 pop用*/
@property (nonatomic, weak) UIViewController *popViewCtrl;
@property (nonatomic, assign) BOOL isPopToRootVC;   /*!< 是否返回到栈底VC */

@property (nonatomic,copy) NSNumber *service_classify_id;   /*!< 与WebViewUIType_ServiceDetail一起用 */

@property (nonatomic,copy) MKBlock competeBlock;
//@property (nonatomic,copy) MKDoubleBlock backBlock; /*!< 被交互折磨得哭死了😭 */

@end
