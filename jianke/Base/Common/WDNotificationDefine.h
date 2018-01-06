//
//  WDNotification.h
//  jianke
//
//  Created by admin on 15/9/2.
//  Copyright (c) 2015年 xianshijian. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

/*
 *====================================================================================================
 *=====Notification=====通知 NSString 全部加在这里  用全局 静态常量
 *命名规范 WDNotification_xxxxxx
 *列：
 *static NSString * const WDNotification_UserLogin = @"WDNotification_UserLogin";
 *====================================================================================================
 */

// 微博登陆时获取code后发送通知
static NSString * const WBLoginGetRespNotification = @"WBLoginGetRespNotification";
static NSString * const WBLoginGetRespInfo = @"WBLoginGetRespInfo";

// 微信登陆时获取code后发送通知
static NSString * const WXLoginGetCodeNotification = @"WXLoginGetCodeNotification";
static NSString * const WXLoginGetCodeInfo = @"WXLoginGetCodeInfo";

// 微信取钱时获取code后发送通知
static NSString * const WXGetMoneyGetCodeNotification = @"WXGetMoneyGetCodeNotification";
static NSString * const WXGetMoneyGetCodeInfo = @"WXGetMoneyGetCodeInfo";

// 微信支付回调 获取code后发通知
static NSString * const WXPayGetCodeNotification = @"WXPayGetCodeNotification";
static NSString * const WXPayGetCodeInfo = @"WXPayGetCodeInfo";

// 雇主绑定微信时获取微信code后发送通知
static NSString * const EPGetWXCodeNotification = @"EPGetWXCodeNotification";
static NSString * const EPGetWXCodeInfo = @"EPGetWXCodeInfo";

// 兼客绑定微信时获取微信code后发送通知
static NSString * const JKGetWXCodeNotification = @"JKGetWXCodeNotification";
static NSString * const JKGetWXCodeInfo = @"JKGetWXCodeInfo";

// 支付宝支付回调通知
static NSString * const AlipayResponseNotification = @"AlipayResponseNotification";
static NSString * const AlipayGetResultInfo = @"AlipayGetResultInfo";



/** 我的报名,cell展开通知 */
static NSString * const JKApplyJobCellMiddleViewOpenNotification = @"JKApplyJobCellMiddleViewOpenNotification";
static NSString * const JKApplyJobCellMiddleViewOpenNotificationIndex = @"index";

/** 我的报名,取消报名通知 */
static NSString * const JKApplyJobCancellApplyNotification = @"JKApplyJobCancellApplyNotification";
static NSString * const JKApplyJobCancellApplyInfo = @"JKApplyJobCancellApplyInfo";

/** 我的报名,有问题通知 */
static NSString * const JKApplyJobHasQuestionNotification = @"JKApplyJobHasQuestionNotification";
static NSString * const JKApplyJobHasQuestionInfo = @"JKApplyJobHasQuestionInfo";

/** 我的报名,给雇主发送消息通知 */
static NSString * const JKApplyJobChatWithEPNotification = @"JKApplyJobChatWithEPNotification";
static NSString * const JKApplyJobChatWithEPInfo = @"JKApplyJobChatWithEPInfo";


/** 发布岗位,cell刷新通知 */
static NSString *const PostJobTableViewShouldReflushNotification = @"PostJobTableViewShouldReflushNotification";
static NSString *const PostJobTableViewShouldReflushInfo = @"PostJobTableViewShouldReflushInfo";

//被踢下线通知 刷新 个人中心UI
static NSString *const WDNotifi_setLoginOut = @"WDNotifi_setLoginOut";
static NSString *const WDNotifi_LoginSuccess = @"WDNotifi_LoginSuccess";
static NSString *const WDNotifi_updateEPResume = @"WDNotifi_updateEPResume";
static NSString *const WDNotifi_JkrzVerifyFaild = @"WDNotifi_JkrzVerifyFaild";

/***************************IM推送小红点通知************************/
static NSString * const IMPushWalletNotification = @"IMPushWalletNotification"; // 钱袋子通知小红点通知

static NSString * const IMPushJKWaitTodoNotification = @"IMPushJKWaitTodoNotification"; // 兼客待办事项大红点通知
static NSString * const IMPushJKWorkHistoryNotification = @"IMPushJKWorkHistoryNotification"; // 兼客工作经历小红点通知

//首页刷新 （待审核-招聘中-已结束）
static NSString * const IMNotification_EPMainUpdate = @"IMNotification_EPMainUpdate";    //岗位通过审核 通知 雇主首页 刷新
static NSString * const IMNotification_EPMainWaitJobUpdate = @"IMNotification_EPMainWaitJobUpdate";    //岗位通过审核 通知 雇主首页-待审核 刷新
static NSString * const IMNotification_EPMainEndJobUpdate = @"IMNotification_EPMainEndJobUpdate";    //岗位通过审核 通知 雇主首页-已结束 刷新
static NSString * const IMNotification_EPMainHeaderViewUpdate = @"IMNotification_EPMainHeaderViewUpdate";    //雇主首页-已在招岗位情况 刷新
static NSString * const WDNotification_ServiceMsgUpdate = @"WDNotification_ServiceMsgUpdate";    //服务-tabbar 刷新
static NSString * const IMNotification_updateConversationList = @"IMNotification_updateConversationList";   //刷新会话列表
static NSString * const IMNotification_BDSendBillForPayToEP = @"IMNotification_BDSendBillForPayToEP";

static NSString * const WDNotification_updateRedPoint = @"WDNotification_updateRedPoint";   // 雇主首页 刷新 去除小红点

static NSString * const WDNotification_ApplicationWillEnterForeground = @"WDNotification_applicationWillEnterForeground";    //app进入前台

static NSString * const WDNotification_backFromMoneyBag = @"WDNotification_backFromMoneyBag";   //从钱袋子返回通知(支付用)
static NSString * const WDNotification_userLoginFail = @"WDNotification_userLoginFail";   //登录失败

/***************************IM消息对应通知**************************/
static NSString * const WDNotification_refreshPersonalServiceMsg = @"WDNotification_refreshPersonalServiceMsg";   //刷新个人服务管理页面(有新的兼客接单)

/***************************IM推送小红点通知************************/
//static NSString * const IMNotification_WeChatBindingSuccess = @"IMNotification_WeChatBindingSuccess";   // 雇主首页 刷新 去除小红点

static NSString * const JKWaitTodoHideRedDotNotification = @"JKWaitTodoHideRedDotNotification"; // 兼客待办事项大红点隐藏通知
static NSString * const JKWorkHistoryRedDotNotification = @"JKWorkHistoryRedDotNotification"; // 兼客工作经历小红点隐藏通知
/************************兼客优聘*****************************/
 static NSString * const RefreshPersonalManageNotification = @"RefreshPersonalManageNotification"; // 兼客待办事项大红点隐藏通知
 static NSString * const RefreshTeamManageNotification = @"RefreshTeamManageNotification"; // 兼客工作经历小红点隐藏通知
 static NSString * const RefreshPushManageNotification = @"RefreshPushManageNotification"; // 兼客工作经历小红点隐藏通知

static NSString * const IMPushServicePersonalNotification = @"IMPushServicePersonalNotification";  // 兼客同意个人服务邀约通知
static NSString * const IMPushJobManageNotification = @"IMPushJobManageNotification";// 兼客申请岗位(雇主)通知
static NSString * const IMPushPersonalServiceOrderBackouted = @"IMPushPersonalServiceOrderBackouted"; // 个人服务需求被下架
static NSString * const UpdateMyInfoNotification = @"UpdateMyInfoNotification"; // 刷新简历
static NSString * const RefreshMyInfoTabeleViewNotification = @"RefreshMyInfoTabeleViewNotification"; // 刷新我-单纯刷新tableview

static NSString * const RefreshFindTalentNotification = @"RefreshFindTalentNotification"; // 刷新发现人才
