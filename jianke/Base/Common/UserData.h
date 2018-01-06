//
//  UserData.h
//  jianke
//
//  Created by xiaomk on 15/9/8.
//  Copyright (c) 2015年 xianshijian. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WDConst.h"
#import "LocalModel.h"
#import "CityModel.h"
#import "EPModel.h"
#import "ParamModel.h"
#import "JKModel.h"
#import "EQRMsgModel.h"
#import "ClientGlobalInfoRM.h"  
#import "XSJUserInfoData.h"
#import "ResponseInfo.h"


typedef NS_ENUM(NSInteger, UserLoginStatus) {
    UserLoginStatus_needManualLogin,    /*!< 需要手动登录 */
    UserLoginStatus_canAutoLogin,   /*!< 可自动登录 */
    UserLoginStatus_loginSuccess,   /*!< 已经登录 */
    UserLoginStatus_loginFail,  /*!< 登录失败 */
};

typedef NS_ENUM(NSInteger, GlobalRMUrlType) {
    GlobalRMUrlType_postServicePersonalJob = 1,   //发布个人通告
    GlobalRMUrlType_memberCenter = 2,   //会员中心
    GlobalRMUrlType_queryServicePersonalJobList,    //通告管理页面
    GlobalRMUrlType_addServiceAgreement,    //增值服务协议
};

typedef void(^ StatusBlock)(UserLoginStatus loginStatus) ;

@interface UserData : NSObject
//@property (nonatomic, assign) BOOL isLogoutActive;  //是否主动退出 登录
@property (nonatomic, assign) BOOL isUpdateWithEPHome;  //控制返回雇主首页-招聘中是否刷新；
@property (nonatomic, assign) BOOL isUpdateWithEPWaitJob;  //控制返回雇主首页-待审核是否刷新；
@property (nonatomic, assign) BOOL isUpdateWithEPEndJob;  //控制返回雇主首页-已结束是否刷新；
@property (nonatomic, assign) BOOL isUpdateWithEPHeaderView;  //控制返回雇主首页-在招岗位情况是否刷新；
@property (nonatomic, assign) BOOL isUpdateWithMyInfo;  //控制我的页面刷新；
@property (nonatomic, assign) BOOL isUpdateWithMyInfoRecuit;    //控制 我 - 在招岗位数的 刷新
@property (nonatomic, assign) BOOL isUpdateWithRefresh;    //控制 我 单纯刷新
@property (nonatomic, assign) BOOL isUpdateMyConactedReume; //控制 我的人才-我联系的兼客
@property (nonatomic, assign) BOOL isUpdateMyCollectedJK;   //控制 我的人才-收藏的简历
@property (nonatomic, assign) BOOL isWXBinding;  //微信是否绑定；
@property (nonatomic, strong) CityModel* localCity; /*!< 当前定位的城市 */  //与用户主动选择的城市可能不同， 不要用错
//@property (nonatomic, assign) BOOL isAccoutVip; /*!< 对应城市是否是VIP用户-我使用 */
@property (nonatomic, strong) RecruitJobNumInfo *recruitJobNumInfo; //在招岗位数情况
@property (nonatomic, strong) ToadyPublishedJobNumRM *publishJobNumModel;    //发布岗位数量信息

@property (nonatomic, copy) NSString *jobUuid; /*!< 用于app唤醒时跳转的jobUuid */

@property (nonatomic, strong) id apns;

@property (nonatomic, assign) BOOL hiddenNewFeature;    /*!< 是否显示app新特性页 */
@property (nonatomic, copy) NSString *registrationID;   /*!< 极光推送registrationID */

// 刷新相关

@property (nonatomic, assign) BOOL refreshApplyJobList; /*!< 是否刷新JK待办页面 */
@property (nonatomic, assign) BOOL hasPostPersonalService;  /*!< 发布了个人服务需求 刷新服务管理 - 个人服务列表 用的 */

//控制登录相关
@property (nonatomic, assign) BOOL loginFail;   /*!< 登录失败 */

@property (nonatomic, weak) UIViewController *popViewCtrl;  /*!< 跳转VC */
@property (nonatomic, weak) UIViewController *popManageViewCtrl;  /*!< 跳转VC */

@property (nonatomic, assign) BOOL isHasInAppWithAD; /*!< 是否已经进入app */

+ (instancetype)sharedInstance;
//=====实用类方法

+ (NSString*)getMoneyFormatWithNum:(NSNumber*)num;
+ (void)delayTask:(float)time onTimeEnd:(void(^)(void))block;

//=====设置付费推广 岗位相关 之弹窗一次
- (BOOL)isHasAlertWithJobId:(NSString *)jobId;
- (void)setHasAlertWithJobId:(NSString *)jobId;

//====第一次打开app-涉及用户登录
- (BOOL)isHasOpenYet;
- (void)setHasOpenYet;

//====第一次打开app-涉及发布岗位小红点
- (BOOL)isHasOpenYetWithPostJob;
- (void)setHasOpenYetWithPostJob;

//=================全局变量链接处理
- (void)handleGlobalRMUrlWithType:(GlobalRMUrlType)type block:(MKBlock)block;

//=========检查更新
+ (void)checkVersion;
//    if (isFirstOpenApp) {
//        isFirstOpenApp = NO;
//        NSString *version = [[NSBundle mainBundle].infoDictionary objectForKey:@"CFBundleShortVersionString"];
//        NSArray *array = [version componentsSeparatedByString:@"."];
//        NSMutableString *mutStr = [NSMutableString string];
//        for (NSString *ct in array) {
//            [mutStr appendString:ct];
//        }
//        int versionInt = mutStr.intValue;
//        [[UserData sharedInstance] getClientVersionWithVersion:versionInt block:^(ClientVersionModel *result) {
//            if (result.version.intValue > versionInt) {
//                if (result.need_force_update.integerValue == 1) {
//                    [MKAlertView alertWithTitle:@"提示" message:@"有新的版本啦，请更新到最新版本吧！" cancelButtonTitle:@"更新" confirmButtonTitle:nil completion:^(UIAlertView *alertView, NSInteger buttonIndex) {
//                        if (buttonIndex == 0) {
//                            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[result.url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] ]];
//                        }
//                    }];
//                }else{
//                    [MKAlertView alertWithTitle:@"发现新版本" message:@"您要下载新版本吗?" cancelButtonTitle:@"暂不更新" confirmButtonTitle:@"更新" completion:^(UIAlertView *alertView, NSInteger buttonIndex) {
//                        if (buttonIndex == 1) {
//                            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[result.url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] ]];
//                        }
//                    }];
//                }
//
//            }
//
//        }];
//    }
//
//}

//=====实用类方法 end

//====获取用户登录状态
- (void)getUserStatus:(StatusBlock)statusBlock;

//=================用户数据
- (void)loginOutUpdateData; //退出登录必须调此方法，初始化一些数据
- (void)setLogoutActive:(BOOL)isActive;
- (BOOL)getIsLogoutActive;


- (BOOL)isFirstLogin;               //是否第一次登录
- (void)setFirstLoginStatusToNO;    //第一次登录后 设置成 不是第一次登录

- (BOOL)isLogin;                    //是否登录
- (void)setLoginStatus:(BOOL)bStatus;   // 设置登录状态

- (void)userIsLogin:(MKBlock)block;   //是否登录  回调用法   没登陆提示去登录
- (void)userIsLoginWithNeedUpdateEpInfo:(BOOL)isUpdateEpInfo block:(MKBlock)block;

- (void)setLoginType:(NSNumber *)loginType;  //设置 登录类型
- (NSNumber*)getLoginType;                  //获取登录类型

- (void)setUserId:(NSNumber*)userId;
- (NSNumber*)getUserId;

- (void)userNameIsExact:(MKBlock)block;

- (void)setUserTureName:(NSString*)name;
- (NSString*)getUserTureName;

- (void)setUserIdentity:(NSString*)identity;
- (NSString*)getUserIdentity;

/**  设置是否首次进入 (发布引导) */
- (void)sethasShowPostJobGuide;
- (BOOL)isHasShowPostJobGuide;

/**  设置是否首次进入 (管理引导) */
- (void)sethasShowJobManageGuide;
- (BOOL)isHasShowJobManageGuide;

/** 获取/设置IM铃声开关状态 */
- (BOOL)getUserImNoticeQuietState;
- (void)setUserImNoticeQuietState:(BOOL)isQuiet;

/** 获取/设置IM会话列表是否显示帮助条 */
- (BOOL)getUserHideHelpState;
- (void)setUserHideHelpState:(BOOL)isShow;

/** 获取/设置雇主首页是否显示雇主头条(滚动新闻) */
- (BOOL)getEpHideNewsViewStateWithAdId:(NSNumber *)adId;
- (void)setEpHideNewsViewState:(BOOL)isShow adId:(NSNumber *)adId;

//=================用户数据


/** 获取兼客简历模型 */
- (void)getJKModelWithBlock:(MKBlock)block;
- (void)getJKModelWithResumeId:(NSString *)resumeId block:(MKBlock)block;
- (void)getJKModelWithResumeId:(NSString *)resumeId readResumePage:(NSNumber *)readResumePage block:(MKBlock)block;
- (void)getJKModelWithAccountId:(NSString*)accountId block:(MKBlock)block;
- (void)getJKModelWithAccountId:(NSString *)accountId ResumeId:(NSString *)resumeId readResumePage:(NSNumber *)readResumePage block:(MKBlock)block;
- (void)getJKModelWithAccountId:(NSString *)accountId ResumeId:(NSString *)resumeId readResumePage:(NSNumber *)readResumePage AppleyJobId:(NSNumber *)appleyJobId block:(MKBlock)block;
- (JKModel*)getJkModelFromHave;

/** 获取雇主简历模型 */
- (void)getEPModelIsNeedUpdate:(BOOL)isUpdate block:(MKBlock)block;
- (void)getEPModelWithBlock:(MKBlock)block;
- (void)getEPModelWithShowLoading:(BOOL)isShowLoading block:(MKBlock)block;
- (void)getEPModelWithEpid:(NSString *)epid block:(MKBlock)block;
- (void)getEPModelWithEpAccount:(NSString*)account block:(MKBlock)block;
- (EPModel*)getEpModelFromHave;

- (void)saveJKModel:(JKModel*)jkmodel;
- (void)saveEPModel:(EPModel*)epmodel;

- (void)setLocal:(LocalModel *)local; /** 保存定位信息 */
- (LocalModel *)local; /** 获取当前定位信息 */

- (void)setCity:(CityModel *)city; /** 保存当前城市 */
- (CityModel *)city; /** 获取当前城市 */

/*!< 当前城市是否开通个人服务 */
- (BOOL)isEnablePersonalService;

/*!< 当前城市是否开通团队服务 */
- (BOOL)isEnableTeamService;

/** 是否正在使用包代招 */
- (BOOL)isArrangedAgentEnabled;

/*!< 当前城市是否开通VIP服务 */
- (BOOL)isEnableVipService;

/*!< 当前是免审用户 */
- (BOOL)isJobExamVip;

/*!< 当前是否是VIP账号 */
- (BOOL)isAccoutVip;

/*!< 获取当前账号VIP图标 */
- (NSString *)getStatusImgWithAccout;

/** 获取岗位分类列表 */
- (void)getJobClassifierListWithBlock:(MKBlock)block;


/** 获取岗位详情 */
- (void)getJobDetailWithJobId:(NSString *)jobId Block:(MKBlock)block;
- (void)getJobDetailWithJobId:(NSString *)jobId andIsFromSAB:(NSInteger)isFormSAB isShowLoding:(BOOL)isShowLoding Block:(MKBlock)block;
- (void)getJobDetailWithJobUuid:(NSString *)jobUuid isShowLoding:(BOOL)isShowLoding block:(MKBlock)block;

/** 兼客针对岗位提出疑问 */
- (void)stuJobQuestionWithJobId:(NSString *)jobId quesiton:(NSString *)question block:(MKBlock)block;

/** 雇主针对疑问进行解答 */
- (void)entJobAnswerWithJobId:(NSString *)jobId quesitonId:(NSString *)questionId answer:(NSString *)answer block:(MKBlock)block;

/** 兼客/雇主查询岗位提问和答复 */
- (void)queryJobQAWithJobId:(NSString *)jobId isShowLoding:(BOOL)isShowLoding block:(MKBlock)block;

/** 兼客/雇主查询岗位提问和答复 --支持分页*/
- (void)queryJobQAWithParam:(QueryJobQAParam *)param isShowLoding:(BOOL)isShowLoding block:(MKBlock)block;

/** 查询报名岗位的兼客列表 */
- (void)queryApplyJobResumeListWithJobId:(NSString *)jobId block:(MKBlock)block;

/** 获取指定城市的抢单岗位分类 */
- (void)getGrabJobClassListOfCity:(CityModel *)city block:(MKBlock)block;

/** 雇主查询报名的兼客列表, 只返回response, 数据需要自己解析 */
- (void)entQueryApplyJobListWithJobId:(NSString *)jobId listType:(NSNumber *)type queryParam:(QueryParamModel *)param block:(MKBlock)block;
- (void)entQueryApplyJobListWithJobId:(NSString *)jobId listType:(NSNumber *)type boardDate:(NSNumber*)boardDate queryParam:(QueryParamModel *)param block:(MKBlock)block;
- (void)entQueryApplyJobListWithJobId:(NSString *)jobId listType:(NSNumber *)type boardDate:(NSNumber*)boardDate queryParam:(QueryParamModel *)param isShowLoading:(BOOL)isShowLoading block:(MKBlock)block;
- (void)entQueryApplyJobListWith:(GetQueryApplyJobModel *)paramModel isShowLoading:(BOOL)isShowLoading block:(MKBlock)block;

/** 企业确认/批量确认工作完成 */
- (void)entConfirmWorkCompleteWithApplyJobIdList:(NSArray *)list block:(MKBlock)block;
/** 企业确认/确认完成: 完成一天的 */
- (void)entConfirmWorkCompleteWithApplyJobIdList:(NSArray *)list andDate:(NSString*)dateStr block:(MKBlock)block;

/** 全部完工 */
- (void)entConfirmWorkCompleteWithJobId:(NSString *)jobId block:(MKBlock)block;
/** 完工一天 */
- (void)entConfirmWorkCompleteWithJobId:(NSString *)jobId andDate:(NSString*)dateStr block:(MKBlock)block;


/** 企业确认兼客未到岗：已沟通一致 */
- (void)entConfirmStuNotCompleteWorkWithApplyJobId:(NSString *)jobId andDate:(NSString*)dateStr block:(MKBlock)block;
- (void)entConfirmStuNotCompleteWorkWithApplyJobId:(NSString *)jobId block:(MKBlock)block;

/** 企业确认兼客未到岗：放鸽子 */
- (void)entConfirmStuBreakPromiseWithApplyJobId:(NSString *)jobId andDate:(NSString*)dateStr block:(MKBlock)block;
- (void)entConfirmStuBreakPromiseWithApplyJobId:(NSString *)jobId block:(MKBlock)block;

/** 雇主对兼客工作情况评分 */
- (void)entScoreStuApplyJobWithApplyJobId:(NSString *)jobId evaluLevel:(NSNumber *)level block:(MKBlock)block;

/** 雇主对兼客工作情况进行评论 */
- (void)entCommetStuApplyJobWithApplyJobId:(NSString *)jobId evaluContent:(NSString *)evaluContent block:(MKBlock)block;

/** 企业聘用/拒绝聘用申请岗位处理 */
- (void)entEmployApplyJobWithWithApplyJobIdList:(NSArray *)list jobId:(NSString *)jobId employStatus:(NSNumber *)status employMemo:(NSString *)memo block:(MKBlock)block;
/** 企业批量聘用/拒绝聘用申请岗位处理 */
- (void)entEmployApplyJobWithWithJobId:(NSString *)jobId employStatus:(NSNumber *)status employMemo:(NSString *)memo block:(MKBlock)block;

/** 兼客查询兼客的工作经历 */
- (void)stuQueryWorkExpericeWithQueryParam:(QueryParamModel *)param block:(MKBlock)block;

/** 获取学校列表(可按条件查询) */
- (void)querySchoolListWithAreaId:(NSString *)areaId cityId:(NSString *)cityId schoolName:(NSString *)schoolName block:(MKBlock)block;

/** 发布岗位 */
- (void)postParttimeJobWithContent:(NSString *)content block:(MKBlock)block;

/** 完善简历姓名 */
- (void)stuUpdateTrueName:(NSString *)name block:(MKBlock)block;

/** 统计企业已发布的岗位数 */
- (void)getPublishedJobNumWithIsSearchToday:(NSNumber *)isSearchToday block:(MKBlock)block;

/** 兼客申请工作 */
- (void)candidateApplyJobWithJobId:(NSString *)jobId workTime:(NSArray *)workTime isFromQrCodeScan:(NSNumber *)isFromQrCodeScan block:(MKBlock)block;

/** 查询专题列表 */
- (void)getJobTopicListWithBlock:(MKBlock)block;

/** 获取分享信息 */
- (void)getAppShareInfoWithBlock:(MKBlock)block;

/** 雇主发起打卡请求 */
- (void)entIssuePunchRequestWithJobId:(NSString *)jobId time:(NSNumber *)time block:(MKBlock)block;

/** 雇主导出岗位录用明细到邮箱 */
- (void)entExportJobApplyDetailToEmailWithJobId:(NSString *)jobId email:(NSString *)email block:(MKBlock)block;

/** 雇主查询人才库列表 */
- (void)entQueryTalentPoolWithContent:(NSString *)content block:(MKBlock)block;

/** 修改人才库状态 state 1：未删除；2：被删除*/
- (void)changeTalentResumeStatusWithTalentPoolId:(NSString *)talentPoolId talentPoolState:(NSNumber *)state block:(MKBlock)block;

/** 分享岗位到人才库 */
- (void)entShareJobToTalentPoolWithJobId:(NSString *)jobId action:(NSNumber *)action block:(MKBlock)block;

/** 分享到人才库 */
- (void)entShareJobToTalentPoolWithJobId:(NSString *)jobId;

/** 雇主查询岗位的打卡列表 */
- (void)entQueryStuPunchTheClockRecord:(NSString *)content block:(MKBlock)block;

/** 兼客应答打卡请求 */
- (void)stuPunchTheClockWithJobId:(NSString *)jobId punchId:(NSString *)punchId punchTime:(NSString *)punchTime punchLat:(NSString *)punchLat punchLng:(NSString *)punchLng punchLocation:(NSString *)punchLocation block:(MKBlock)block;

/** 生成/刷新岗位二维码 */
- (void)entRefreshJobQrCodeWithJobId:(NSString *)jobId block:(MKBlock)block;
- (void)creatMakeupUrlWithJobId:(NSString *)jobId block:(MKBlock)block;

/** 扫描岗位二维码 */
- (void)stuScanJobQrCodeWith:(NSString *)qrCode block:(MKBlock)block;

/** 账户流水明细查询(v3) */
- (void)queryAcctDetailItemWithQueryParam:(QueryParamModel *)queryParam detailListId:(NSString *)detailListId block:(MKBlock)block;

/** 查询人脉王奖金 */
- (void)queryAcctSocialActivistBonusWithQueryParam:(QueryParamModel *)queryParam jobId:(NSString *)jobId detailID:(NSString *)detailID block:(MKBlock)block;

/** 调整兼客上岗日期 */
- (void)entChangeStuOnBoardDateWithApplyJobId:(NSNumber *)applyJobId dayArray:(NSArray *)dayArray block:(MKBlock)block;

/** 查询岗位可报名的日期 */
- (void)queryJobCanApplyDateWithJobId:(NSNumber *)jobId resumeId:(NSNumber *)resumeId block:(MKBlock)block;

/** 7.1.6	企业阅读兼客简历 */
- (void)entReadApplyJobResumeWithApplyJobId:(NSString *)applyJobId block:(MKBlock)block;

/** 2.5	查询指定城市特色入口 */
- (void)getSpecialEntryListWithCityId:(NSNumber *)cityId block:(MKBlock)block;
/** 查询当前城市特色入口 */
- (void)getCurrentCitySpecialEntryListWithBlock:(MKBlock)block;

/** 2.5.2	根据特色入口id查询岗位列表 */
- (void)querySpecialEntryJobListWithSpecialEntryId:(NSNumber *)specialEntryId cityId:(NSNumber *)cityId queryParam:(QueryParamModel *)queryParam block:(MKBlock)block;
/** 根据特色入口id查询当前城市的岗位列表 */
- (void)querySpecialEntryJobListWithSpecialEntryId:(NSNumber *)specialEntryId queryParam:(QueryParamModel *)queryParam block:(MKBlock)block;

/** 获取、保存 IM常用语 */
- (void)getEqrMsgModelWithBlock:(MKBlock)block;
- (void)setEqrMsgModel:(EQRMsgModel*)model;
- (void)postClientCustomInfoWithEQRModel:(EQRMsgModel*)model isShowLoding:(BOOL)isShowLoding block:(MKBlock)block;

/** 兼客头条 */
- (void)getHeadlineNewsWithBlock:(MKBlock)block;

/** 雇主头条 */
- (void)getEpHeadlineNewsWithBlock:(MKBlock)block;

/** 获取岗位福利标签列表 */
- (void)getJobTagListWithBlock:(MKBlock)block;


/** 人脉王获取兼客列表 */
- (void)getSocialActivistApplyJobResumeListWithJobId:(NSString *)jobId listType:(NSNumber *)listType queryParam:(QueryParamModel *)queryParam block:(MKBlock)block;

- (void)getClientVersionWithVersion:(int)version block:(MKBlock)block;

/** 查询手机号对应账号信息接口 */
- (void)queryAccountInfo:(NSString *)telPhone block:(MKBlock)block;

/** 雇主手动补录人员接口 */
- (void)entMakeupStuBySelfWithJobId:(NSString *)job_id resumeList:(NSArray *)resume_list block:(MKBlock)block;

#pragma mark - IM相关接口
/** 4.5.1	获取群组资料 */
- (void)imGetGroupInfoWithGroupId:(NSString *)GroupId block:(MKBlock)block;
- (void)imGetGroupInfoWithGroupId:(NSString *)GroupId isSimple:(BOOL)isSimple block:(MKBlock)block;

/** 4.5.2	获取企业群组列表 */
- (void)imGetMgrGroupsWithBlock:(MKBlock)block;

/** 4.5.3	退出群组 */
- (void)imQuitGroupWithGroupId:(NSString *)groupId block:(MKBlock)block;

#pragma mark - 首页数据缓存
- (void)saveHomeADListWithArray:(NSArray*)list;
- (void)saveHomeQuickEntryListWithArray:(NSArray*)list;
- (void)saveHomeJobListWithArray:(NSArray*)list;

- (NSArray*)getHomeADList;
- (NSArray*)getHomeQuickEntryList;
- (NSArray*)getHomeJobList;

- (void)saveSearchHistoryWithArray:(NSArray*)list;
- (NSArray*)getSearchHistoty;

+ (void)debugWriteToCache:(NSString*)logStr;

#pragma mark - 优聘首页缓存
- (void)saveEPJobListWithArray:(NSArray*)list;
- (NSArray *)getEPJobList;

#pragma mark - 人才库数据缓存
- (void)saveFindTalentListWithArray:(NSArray*)list;
- (NSArray *)getFindTalentList;

@end

