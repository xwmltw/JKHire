//
//  XSJRequestHelper.h
//  jianke
//
//  Created by xiaomk on 16/5/16.
//  Copyright © 2016年 xianshijian. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MKBaseModel.h"
#import "ClientGlobalInfoRM.h"
#import "ParamModel.h"
#import "PayJobInfoModel.h"
#import "EPModel.h"


typedef NS_ENUM(NSInteger, WdVarifyCodeOptType) {
    WdVarifyCodeOptTypeRegist = 1,                  //注册
    WdVarifyCodeOptTypeFindPassword = 2,            //找回密码
    WdVarifyCodeOptTypeChgPhoneNum = 3,             //修改手机号码
    WdVarifyCodeOptTypePerfectInfo = 4,             //第三方登录完善资料
    WdVarifyCodeOptTypeFindMoneyBagPwd = 5,         //找回钱袋子密码
    WdVarifyCodeOptTypeDynamicPwdLogin = 7,         //动态密码登录
};

typedef NS_ENUM(NSInteger, LoginPwdType) {
    LoginPwdType_commonPassword = 1,                /*!< 普通密码 */
    LoginPwdType_dynamicPassword,                   /*!< 动态密码 */
    LoginPwdType_dynamicSmsCode,                    /*!< 动态验证码 */
};

@class MKBaseModel, PostJobModel;

@interface XSJRequestHelper : NSObject


@property (nonatomic, assign) BOOL isLostNetwork;   /*!< 网络是否断开过 */

+ (instancetype)sharedInstance;


#pragma mark - ***** 网络端开后从新 连接上网络 ******
- (void)connectNetworkAgain;

#pragma mark - ***** 登录 & 自动登录 ******
- (void)activateAutoLoginWithBlock:(MKBlock)block;
/*!< 自动登录 */
- (void)autoLogin:(MKBlock)block;
/** 默认普通密码登录 */
- (void)loginWithUsername:(NSString *)userName pwd:(NSString *)password bolck:(MKBlock)block;
/** 根据密码类型登录 */
- (void)loginWithUsername:(NSString *)userName pwd:(NSString *)password loginPwdType:(LoginPwdType)loginPwdType bolck:(MKBlock)block;

- (void)loginWithUsername:(NSString *)userName pwd:(NSString *)password loginPwdType:(LoginPwdType)loginPwdType isShowNetworkErr:(BOOL)isShowNetworkErr isUpdateEpInfo:(BOOL)isUpdateEpInfo bolck:(MKBlock)block;

#pragma mark - ***** 获取验证码 ******
//"opt_type" :  操作类型  , 1 注册 , 2 找回密码 , 3 修改手机号码  -- 注册 (1) 判断 是否已经被注册 , (2): 判断 号码是否存在 , (3): 判断 是否已经被注册 .
//"user_type" : 用户类型 ,  1:企业 ，2:学生 , --}

- (void)getAuthNumWithPhoneNum:(NSString*)phoneNum andBlock:(MKBlock)block withOPT:(WdVarifyCodeOptType)optType userType:(NSNumber*)userType;


#pragma mark - ***** 获取全局配置信息 ******
/** 获取数据 */
- (void)getClientGlobalInfoWithBlock:(MKBlock)block;
/** 必须获取最新数据 */
- (void)getClientGlobalInfoMust:(BOOL)must withBlock:(MKBlock)block;
- (ClientGlobalInfoRM*)getClientGlobalModel;


/** 保存设备信息 */
- (void)postDeviceInfoWithBlock:(MKBlock)block;

/** 查询钱袋子账户信息 */
- (void)queryAccountMoneyWithBlock:(MKBlock)block;

/** 拨打免费电话 */
- (void)callFreePhoneWithCalled:(NSString *)called block:(MKBlock)block;

/** 雇主查询打卡请求接口 */
- (void)entQueryPunchRequestList:(EntQueryPunch *)punch block:(MKBlock)block;

/** 雇主发起点名接口 */
- (void)entIssuePunchRequest:(NSString *)job_id clockTime:(NSString *)date block:(MKBlock)block;

/** 雇主结束打卡接口 */
- (void)entClosePunchRequest:(NSString *)request_id block:(MKBlock)block;

/** 签到列表接口 */
- (void)entQueryStuPunchTheClockRecord:(EntQueryStuPunch *)param block:(MKBlock)block;

/** 修改支付列表接口 */
- (void)entChangeSalaryUnConfirmStu:(NSString *)itemId withTel:(NSString *)telphone withTrueName:(NSString *)name block:(MKBlock)block;

/** 猜你喜欢接口 */
- (void)getJobListGuessYouLike:(GetJobLikeParam *)param block:(MKBlock)block;

/** 招聘余额接口 */
- (void)queryAcctVirtualDetailList:(QueryParamModel *)param block:(MKBlock)block;

/** 招聘余额转入接口 */
- (void)rechargeRecruitmentAmount:(PayJobInfoModel *)param block:(MKBlock)block;

/** 用户虚拟账户流水明细查询 */
- (void)queryAcctVirtualDetailItem:(DetailItmeParam *)param block:(MKBlock)block;

/** 收藏岗位 */
- (void)collectJob:(NSString *)jobId block:(MKBlock)block;

/** 取消收藏岗位 loading */
- (void)cancelCollectedJob:(NSString *)jobId isShowLoding:(BOOL)isShowLoding block:(MKBlock)block;

/** 取消收藏岗位 */
- (void)cancelCollectedJob:(NSString *)jobId block:(MKBlock)block;

/** 查询收藏岗位列表 */
- (void)getCollectedJobList:(QueryParamModel *)queryParam block:(MKBlock)block;

/** 兼客获取自己的最新认证信息 */
- (void)getLatestVerifyInfo:(MKBlock)block;

/** 账户交易流水查询 */
- (void)queryAccDetail:(QueryParamModel *)queryParam moneyDetailType:(NSNumber *)moneyDetailType withJobId:(NSString *)jobId block:(MKBlock)block;

/** 广告点击日志接口 */
- (void)queryAdClickLogRecordWithADId:(NSNumber *)AdId;

/** 人脉王岗位推送开关 */
- (void)openSocialActivistJobPush:(NSString *)optType block:(MKBlock)block;

/** 获取人脉王任务列表 */
- (void)getSocialActivistTaskList:(NSString *)inHistory queryParam:(QueryParamModel *)param block:(MKBlock)block;

/** 记录图文消息点击日志 */
- (void)graphicPushLogClickRecord:(NSString *)contentId block:(MKBlock)block;

/** 兼客联系岗位申请 */
- (void)postStuContactApplyJob:(NSString *)jobId resultType:(NSNumber *)resultType remark:(NSString *)remakr block:(MKBlock)block;

/** 查询电话联系岗位的兼客列表 */
- (void)queryContactApplyJobResumeList:(QueryParamModel *)queryParam jobId:(NSString *)jobId block:(MKBlock)block;

/** 记录通知栏消息点击日志 */
- (void)noticeBoardPushLogClickRecord:(NSString *)messageId block:(MKBlock)block;

/** 记录搜索关键字 */
- (void)recordSearchKeyWord:(NSString *)keyWord cityId:(NSNumber *)cityId block:(MKBlock)block;

/** 查询增值服务列表 */
- (void)queryJobVasListLoading:(BOOL)isShowLoding block:(MKBlock)block;

/** 雇主购买岗位增值服务 */
- (void)entRechargeJobVas:(NSString *)jobId totalAmount:(NSNumber *)totalAmount orderType:(NSNumber *)orderType oderId:(NSNumber *)orderId block:(MKBlock)block;
- (void)entRechargeJobVas:(NSString *)jobId classifyId:(NSNumber *)classifyId tagIds:(NSArray *)tagIds totalAmount:(NSNumber *)totalAmount orderType:(NSNumber *)orderType oderId:(NSNumber *)orderId block:(MKBlock)block;
/** 支付岗位增值服务订单 */
- (void)payJobVasOrder:(PayJobInfoModel *)model block:(MKBlock)block;

/** 查询岗位订阅增值服务信息 */
- (void)queryJobVasInfo:(NSString *)jobId block:(MKBlock)block;

#pragma mark - ********兼客优聘********相关接口********

/** 获取个人服务兼客列表 */
- (void)getServicePersonalStuList:(NSNumber *)serviceType cityId:(NSNumber *)cityId jobId:(NSNumber *)jobId param:(QueryParamModel *)param block:(MKBlock)block;

/** 雇主获取个人服务需求列表 */
- (void)entQueryServicePersonalJobList:(NSNumber *)serviceType queryParam:(QueryParamModel *)param listType:(NSNumber *)listType block:(MKBlock)block;

/** 雇主获取个人服务需求列表 */
- (void)entQueryServicePersonalJobList:(NSNumber *)serviceType withAccountId:(NSNumber *)accountId inHistory:(NSNumber *)inHistory queryParam:(QueryParamModel *)param listType:(NSNumber *)listType block:(MKBlock)block;

/** 发布个人服务需求 */
- (void)postServicePersonalJob:(id)postJobModel block:(MKBlock)block;

/** 获取团队服务商列表 */
- (void)getServiceTeamList:(NSNumber *)cityId serviceId:(NSNumber *)serviceClassifyId queryParam:(QueryParamModel *)queryParam block:(MKBlock)block;

/** 查询服务商服务类别列表 */
- (void)getServiceClassifyInfoList:(MKBlock)block;

/** 发布团队服务需求 */
- (void)postServiceTeamJobWithModel:(id)postJobModel block:(MKBlock)block;

/** 雇主获取团队服务需求列表 */
- (void)entQueryServiceTeamJobList:(NSNumber *)classifyId queryParam:(QueryParamModel *)queryParam block:(MKBlock)block;

/** 雇主获取团队服务需求列表 */
- (void)entQueryServiceTeamJobList:(NSNumber *)classifyId inHistory:(NSNumber *)inHistory queryParam:(QueryParamModel *)queryParam serviceApplyId:(NSNumber *)serviceApplyId listType:(NSNumber *)listType block:(MKBlock)block;

/** 雇主邀约兼客 */
- (void)entInviteServicePersonal:(NSNumber *)stuAccountId serviceJobId:(NSNumber *)serviceJobId block:(MKBlock)block;

/** 雇主预约团队服务商 */
- (void)entOrderServiceTeam:(NSNumber *)serviceApplyId teamJobId:(NSNumber *)teamJobId block:(MKBlock)block;

/** 获取个人服务需求邀约列表 */
- (void)entQueryServicePersonalJobApplyListWithApplyType:(NSNumber *)applyType jobId:(NSNumber *)jobId queryParam:(QueryParamModel *)queryParam block:(MKBlock)block;

- (void)entQueryServicePersonalJobApplyListWithApplyType:(NSNumber *)applyType jobId:(NSNumber *)jobId queryParam:(QueryParamModel *)queryParam isShowLoding:(BOOL)isShowLoding block:(MKBlock)block;

/** 获取个人服务需求详情 */
- (void)getServicePersonalJobDetailWithJobId:(NSNumber *)personaJobId block:(MKBlock)block;

- (void)getServicePersonalJobDetailWithJobId:(NSNumber *)personaJobId isShowLoding:(BOOL)isShowLoding block:(MKBlock)block;

/** 雇主购买个人服务联系方式 */
- (void)entRechargeServicePersonalWithJobApplyId:(NSNumber *)jobApplyId block:(MKBlock)block;

/** 雇主支付个人服务订单 */
- (void)payServicePersonalOrder:(PayJobInfoModel *)model block:(MKBlock)block;

/** 获取团队服务需求详情 */
- (void)getServiceTeamJobDetail:(NSNumber *)serviceJobId block:(MKBlock)block;

/** 雇主获取团队服务需求预约列表 */
- (void)entQueryServiceTeamJobApplyListWithJobId:(NSNumber *)teamJobId param:(QueryParamModel *)queryParam block:(MKBlock)block;

/** 推广订单 */
- (void)getSpreadOrderWithParam:(QueryParamModel *)queryParam block:(MKBlock)block;

/** 获取团队服务需求预约列表 */
- (void)queryServiceTeamJobApplyListWithListType:(NSNumber *)listType queryParam:(QueryParamModel *)queryParam block:(MKBlock)block;

/** 获取团队服务需求预约详情 */
- (void)getServiceTeamJobApplyDetailWithApplyId:(NSNumber *)applyId block:(MKBlock)block;

/** 雇主获取关注的粉丝列表 */
- (void)entQueryFocusFansListWithQueryParam:(QueryParamModel *)param block:(MKBlock)block;

/** 雇主填写企业服务商基本信息 */
- (void)postEnterpriseServiceBasicInfo:(EPModel *)epmodl block:(MKBlock)block;

/** 获取已申请的团队服务列表 */
- (void)queryServiceTeamApplyListWithEntID:(NSNumber *)entId status:(NSNumber *)status block:(MKBlock)block;

/** 查询投保记录列表 */
- (void)queryInsuranceRecordList:(QueryParamModel *)queryParam block:(MKBlock)block;

/** 查询已成功投保的日期列表 */
- (void)getSuccessInsuredDateListWithIdCard:(NSString *)idCard block:(MKBlock)block;

/** 投保人投保(购买保单) */
- (void)rechargeInsuranceWithTotalAmount:(NSNumber *)totalAmount insuranceList:(NSArray *)insuranceList block:(MKBlock)block;

/** 查询投保记录详情列表 */
- (void)queryInsuranceRecordDetailList:(NSNumber *)recordId queryParam:(QueryParamModel *)queryParam block:(MKBlock)block;

/** 投保人支付投保保单 */
- (void)payInsurancePolicy:(PayJobInfoModel *)model block:(MKBlock)block;

/** 雇主联系个人服务商 */
- (void)entContactWithStuWithApplyId:(NSNumber *)applyId block:(MKBlock)block;

/** 记录app访问页面 */
- (void)recordPageVisitLogWithVisitPageId:(NSNumber *)visit_page_id block:(MKBlock)block;

/** 检测用户登陆状态 */
- (void)checkUserLogin:(MKBlock)block;

/** 雇主关闭个人服务需求 */
- (void)entCloseServicePersonalJobWithJobId:(NSNumber *)jobId block:(MKBlock)block;

/** 提交推送平台信息（极光推送） */
- (void)postThirdPushPlatInfo;
- (void)postThirdPushPlatInfo:(NSString *)push_id block:(MKBlock)block;

/** 支付代发工资 */
- (void)entPayforStuByAgency:(PayJobInfoModel *)payJobInfoModel block:(MKBlock)block;

/** 工资撤回 */
- (void)entCancelUnConfirmStuSalaryWithItemId:(NSString *)itemId block:(MKBlock)block;

/** 新增雇主查询可投保兼客简历列表 */
- (void)entQueryCanInsureApplyResumeListWithJobId:(NSString *)jobId block:(MKBlock)block;

/** 雇主获取自己发布的岗位 */
- (void)getEnterpriseSelfJobList:(GetEnterpriscJobModel *)paramModel block:(MKBlock)block;

/** 雇主购买在招岗位数 */
- (void)rechargeRecruitJobNum:(RechargeRecruitParam *)param block:(MKBlock)block;

/** 雇主查询在招岗位数相关信息 */
- (void)entQueryRecruitJobNumInfo:(NSNumber *)cityId block:(MKBlock)block;
- (void)entQueryRecruitJobNumInfo:(NSNumber *)cityId isShowLoading:(BOOL)isShowLoading block:(MKBlock)block;

/** 支付在招岗位数订单 */
- (void)payRecruitJobNumOrder:(PayJobInfoModel *)param block:(MKBlock)block;

/** 查询购买的在招岗位数记录 */
- (void)entQueryRecruitJobNumRecordList:(NSNumber *)cityId block:(MKBlock)block;

/** 雇主续费在招岗位数 */
- (void)renewRecruitJobNum:(RechargeRecruitParam *)param block:(MKBlock)block;

/** 查询增值服务信息列表 */
- (void)queryJobVasListLoading:(BOOL)isShowLoding cityId:(NSNumber *)cityId jobId:(NSString *)jobId block:(MKBlock)block;

/** 雇主使用岗位特权推广 */
- (void)entUseJobVipSpreadWithJobId:(NSString *)jobId spreadType:(NSNumber *)spreadType spreadNum:(NSString *)spreadNum classfyId:(NSNumber *)classfyId idList:(NSArray *)idList block:(MKBlock)block;
- (void)entUseJobVipSpreadWithJobId:(NSString *)jobId spreadType:(NSNumber *)spreadType spreadNum:(NSString *)spreadNum classfyId:(NSNumber *)classfyId idList:(NSArray *)idList vasOrderVasId:(NSNumber *)vasOrderVasId block:(MKBlock)block;

/** 记录销售线索 */
- (void)postSaleClueWithDesc:(NSString *)desc isNeedContact:(NSNumber *)isNeedContact block:(MKBlock)block;
- (void)postSaleClueWithDesc:(NSString *)desc isNeedContact:(NSNumber *)isNeedContact isShowloading:(BOOL)isShowLoading block:(MKBlock)block;

/** 保证金缴纳 */
- (void)payGuaranteeAmount:(PayJobInfoModel *)param block:(MKBlock)block;

/** 获取岗位类型 */
- (void)getJobClassifyInfoListWithCityId:(NSNumber *)cityId isShowLoading:(BOOL)isShowLoading block:(MKBlock)block;

/** 雇主提交岗位审核 */
- (void)entJobSubmitAuditWithJobId:(NSNumber *)jobId block:(MKBlock)block;

/** 雇主编辑岗位信息 */
- (void)editParttimeJobServiceWithJobId:(NSNumber *)jobId parttimeJob:(PostJobModel *)parttimeJob block:(MKBlock)block;

/** 获取附近求职者数量 */
- (void)getNearbyJobSeekerNumWithLongitude:(NSString *)longitude latitude:(NSString *)latitude block:(MKBlock)block;

/** 查询当前账号当前城市对应的VIP信息 */
- (void)getAccountVipInfo:(NSNumber *)cityId block:(MKBlock)block;

/**  获取城市vip套餐入口列表接口 */
- (void)getVipPackageEntryList:(NSNumber *)cityId isShowLoading:(BOOL)isShowLoading block:(MKBlock)block;

/** 雇主购买VIP会员套餐 */
- (void)rechargeVipPackageWithVipId:(NSNumber *)packetId totalAmount:(NSNumber *)totalAmount cityId:(NSNumber *)cityId saleManId:(NSNumber *)saleManId block:(MKBlock)block;

/** 支付VIP会员套餐订单 */
- (void)payVipOrder:(PayJobInfoModel *)param block:(MKBlock)block;

/** 推荐码查询后台账号是否存在 */
- (void)getAdminUserInfoWithSaleCode:(NSNumber *)saleCode block:(MKBlock)block;

/** 查询VIP会员信息 */
- (void)queryAccountVipInfo:(MKBlock)block;

/** 查询消耗报名数的岗位列表 */
- (void)queryJobListByVipOrder:(NSNumber *)vipOrderId queryParam:(QueryParamModel *)queryParam block:(MKBlock)block;

/** 查询消耗报名数的投递列表 */
- (void)queryApplyJobListByVipOrderJob:(NSNumber *)jobId orderId:(NSNumber *)orderId queryParam:(QueryParamModel *)queryParam block:(MKBlock)block;

/** 查询报名数套餐列表 */
- (void)queryVipApplyJobNumPackageList:(NSNumber *)cityId isShowLoading:(BOOL)isShowLoading block:(MKBlock)block;

/** 雇主购买VIP会员报名数套餐 */
- (void)rechargeVipApplyJobNumPackageWithOrderId:(NSNumber *)orderId packageId:(NSNumber *)packageId totalAmount:(NSNumber *)totalAmount block:(MKBlock)block;

/** 支付VIP会员报名数订单 */
- (void)payVipApplyJobNumOrder:(PayJobInfoModel *)param block:(MKBlock)block;

/** 雇主查询人才列表 */
- (void)entQueryTalentList:(QueryTalentParam *)model queryParam:(QueryParamModel *)queryParam isShowLoading:(BOOL)isShowLoading block:(MKBlock)block;

/** 雇主查询已联系的兼客列表 */
- (void)entQueryContactResumeList:(QueryParamModel *)param block:(MKBlock)block;

/** 雇主获取收藏的兼客列表 */
- (void)getCollectedStudentList:(QueryParamModel *)param block:(MKBlock)block;

/** 查询简历数套餐列表 */
- (void)queryAccountResumeNumPackageList:(BOOL)isShowLoading block:(MKBlock)block;

/** 雇主获取兼客联系方式 */
- (void)entGetResumeContact:(NSNumber *)resumeId block:(MKBlock)block;

/** 雇主联系兼客反馈结果*/
- (void)entContactResumeFeedback:(NSNumber *)resumeId contactResultType:(NSNumber *)contactResultType contactRemark:(NSString *)contactRemark block:(MKBlock)block;

/** 雇主购买简历数套餐 */
- (void)rechargeResumeNumPackageWithId:(NSNumber *)packageId totalAmount:(NSNumber *)totalAmount block:(MKBlock)block;

/** 雇主支付简历数订单 */
- (void)payResumeNumOrder:(PayJobInfoModel *)param block:(MKBlock)block;

/** 雇主收藏兼客简历 */
- (void)collectStudent:(NSNumber *)accountId block:(MKBlock)block;

/** 取消收藏兼客 */
- (void)cancelCollectedStudent:(NSNumber *)accountId block:(MKBlock)block;

/** 查询包代招信息列表 */
- (void)queryArrangedAgentVasInfoList:(MKBlock)block;

/** 查询包代招报名数各岗位消耗情况列表 */
- (void)queryJobListByArrangedAgentVasOrder:(NSNumber *)orderId queryParam:(QueryParamModel *)queryParam block:(MKBlock)block;

/** 查询包代招岗位报名列表 */
- (void)queryApplyListByArrangedAgentVasOrder:(NSNumber *)orderId jobId:(NSNumber *)jobId queryParam:(QueryParamModel *)queryParam block:(MKBlock)block;

#pragma mark - ***** 弃用 ******
/** 获取广告,兼客头条,雇主头条 */
- (void)getAdvertisementListWithAdSiteId:(NSString *)adSiteId cityId:(NSString *)cityId block:(MKBlock)block;

@end




