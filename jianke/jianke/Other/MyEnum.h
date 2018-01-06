//
//  MyEnum.h
//  JKHire
//
//  Created by fire on 16/10/11.
//  Copyright © 2016年 xianshijian. All rights reserved.
//

#ifndef MyEnum_h
#define MyEnum_h

/** 服务大厅 */
typedef NS_ENUM(NSUInteger, ServiceCenterSectionType) {
    Service_Center_Section_Type_Team,   //团队服务开启
    Service_Center_Section_Type_Team_disable,    //团队服务关闭
    Service_Center_Section_Type_Personal,   //个人服务开启
    Service_Center_Section_Type_Personal_disable,   //个人服务关闭
    Service_Center_Section_Type_Marketing,  //推广服务
};


typedef NS_ENUM(NSInteger, PostJobCellType) {
    PostJobCellType_title           = 1,
    PostJobCellType_jobType,
    PostJobCellType_date,               //选择 开始 结束日期
    PostJobCellType_time,
    PostJobCellType_applyEndDate,
    PostJobCellType_maxTime,
    PostJobCellType_jobTag,
    PostJobCellType_restrict,
    PostJobCellType_welfare,
    PostJobCellType_detail,
    PostJobCellType_area,
    PostJobCellType_concentrate,
    PostJobCellType_contact,
    PostJobCellType_maxJKCount,         //总人数
    PostJobCellType_payMoney,
    PostJobCellType_payType,
    PostJobCellType_JobDetail,
    PostJobCellType_Gender,
    PostJobCellType_FuLi,
    PostJobCellType_MoreCondition,
    PostJobCellType_send,
    PostJobCellType_remind,
    PostJobCellType_chooseJob,
    PostJobCellType_chooseCity,
    PostJobCellType_payPreMoney,
    PostJobCellType_nextStep,
    PostJobCellType_jobClassify,
    PostJobCellType_chooseSex,
    PostJobCellType_NewGuide,
    PostJobCellType_Name,
    PostJobCellType_salaryJobtitle,
    PostJobCellType_salaryJobArea,
    PostJobCellType_workAddress,
};

typedef NS_ENUM(NSInteger, ServicePersonType) {
    ServicePersonType_Lady = 100,  //礼仪
    ServicePersonType_model,
    ServicePersonType_teacher,
    ServicePersonType_delegate,
    ServicePersonType_actor,
    ServicePersonType_reporter,
    ServicePersonType_saler,
};

/** 页面来源 */
typedef NS_ENUM(NSInteger, ViewSourceType) {
    ViewSourceType_PostPersonalJob = 1, //个人服务发布页
    ViewSourceType_PostTeamJob, //团队服务发布页
    ViewSourceType_PostNormalJob,   //普通需求发布页
    ViewSourceType_InvitePersonalJob,   //邀约发布页
    ViewSourceType_InviteTeamJob,    //邀约发布页
    ViewSourceType_SuccessInviteJob,   //发送成功
    ViewSourceType_PersonManage,    //管理页面进入
};

/** 按钮action类型 */
typedef NS_ENUM(NSInteger, BtnOnClickActionType) {
    BtnOnClickActionType_payForPhoneNum = 200,     //获取联系方式
    BtnOnClickActionType_makeCall,   //打电话,
    BtnOnClickActionType_makeIm,       //联系客服
    BtnOnClickActionType_sliderLeft,    //切换 && 左按钮
    BtnOnClickActionType_sliderRight,   //切换 && 右按钮
    BtnOnClickActionType_idAuthAction,  //信息认证
    BtnOnClickActionType_editInfoIndex, //雇主信息编辑
    BtnOnClickActionType_epInfoIndex,  //雇主信息- 主页 按钮
    BtnOnClickActionType_epInfoJob,  //雇主信息- 岗位 按钮
    BtnOnClickActionType_epInfoCase,  //雇主信息- 案例 按钮
    BtnOnClickActionType_uploadHeadImg,  //雇主信息 - 头像上传
    BtnOnClickActionType_addDay,    //投保日期选择按钮
    BtnOnClickActionType_delete,    //删除按钮
    BtnOnClickActionType_confirmContact,    //确认已沟通按钮
    BtnOnClickActionType_payAction, //付款
    BtnOnClickActionType_pushHistory,   //推广记录
    BtnOnClickActionType_postSalaryJob, //首页-代发工资 弃用
    BtnOnClickActionType_postJob,   //首页-发布岗位
    BtnOnClickActionType_insurance, //首页-兼职保险
    BtnOnClickActionType_hireTool,  //首页-招人神器
    BtnOnClickActionType_waitToPass,    //首页 - 待审核
    BtnOnClickActionType_hire,  //首页 - 招聘中
    BtnOnClickActionType_HireOff, //首页 - 已结束
    BtnOnClickActionType_Vip, //首页 - vip banner
    BtnOnClickActionType_buyVip, //在招岗位底部按钮 - 购买vip or 个人中心 - VIP按钮
    BtnOnClickActionType_recruitJobHistory, //在招岗位 - 查看购买的在招岗位记录
    BtnOnClickActionType_dropAction,    //上下拉更多按钮
    BtnOnClickActionType_buyPostJobNumber,   //在招岗位底部按钮 - 购买岗位数
    BtnOnClickActionType_idCardVerityNO,  //未实名认证按钮
    BtnOnClickActionType_idCardVerityIng,  //正在实名认证中按钮
    BtnOnClickActionType_idCardVerityYES,  //已实名认证按钮
    BtnOnClickActionType_epVerityNO,  //未企业认证按钮
    BtnOnClickActionType_epVerityYES,  //已企业认证按钮
    BtnOnClickActionType_epVerityIng,  //正在企业认证中按钮
    BtnOnClickActionType_verity,    //我 - 认证
    BtnOnClickActionType_moneyBag,  //我 - 钱袋子
    BtnOnClickActionType_refreshJob,    //兼职管理-刷新岗位
    BtnOnClickActionType_stickJob,  //兼职管理-置顶岗位
    BtnOnClickActionType_pushJob,   //兼职管理-推送岗位
    BtnOnClickActionType_jobVas,    //兼职管理-付费推广页面
    BtnOnClickActionType_viewMoreMange, //兼职管理-更多管理
    BtnOnClickActionType_applyForWait,  //兼职管理-待处理简历
    BtnOnClickActionType_applyForHired, //兼职管理-已录用简历
    BtnOnClickActionType_applyForRejected,  //兼职管理-已拒绝简历
    BtnOnClickActionType_qCode, //VIP会员-填写推荐码
    BtnOnClickActionType_chooseCity,    //VIP会员-切换城市
    BtnOnClickActionType_vipCities, //VIP会员-开通多个VIP城市
    BtnOnClickActionType_moreJobService,    //VIP会员-更多岗位服务
    BtnOnClickActionType_usedApplyNum,  //VIP会员中心 - 消耗报名数
    BtnOnClickActionType_buyApplyNum,   //VIP会员中心 - 报名数购买
    BtnOnClickActionType_contactedJK,   //我的人才 - 联系过兼客
    BtnOnClickActionType_collectedJK,   //我的人才 - 我收藏的简历
    BtnOnClickActionType_sendMsg,   //我的人才 - IM消息
    BtnOnClickActionType_collectJK, //我的人才 - 收藏简历
    BtnOnClickActionType_arragedLeftApply,  //包代招 - 剩余报名数
    BtnOnClickActionType_arragedUsedApply,  //包代招 - 已消耗报名数
};

/** 编辑服务商信息cell type */
typedef NS_ENUM(NSInteger, ApplySerciceCellType) {
    ApplySerciceCellType_serviceName,
    ApplySerciceCellType_city,
    ApplySerciceCellType_name,
    ApplySerciceCellType_telphone,
    ApplySerciceCellType_summary,
    ApplySerciceCellType_companyName,   //以下 引导注册页面 加入
    ApplySerciceCellType_email,
    ApplySerciceCellType_trueName,
    ApplySerciceCellType_abbreviationName,
    ApplySerciceCellType_commanySummary,
    ApplySerciceCellType_hireCity,
    ApplySerciceCellType_industry,
    ApplySerciceCellType_industryDesc,
};

/** 编辑服务商信息cell type */
typedef NS_ENUM(NSInteger, EpProfileCellType) {
    EpProfileCellType_commpany,
    EpProfileCellType_shortCommpany,
    EpProfileCellType_summary,    
    EpProfileCellType_industry,
    EpProfileCellType_hireCity,
};

/** 付费推广类型 */
typedef NS_ENUM(NSInteger, AppreciationType){
    Appreciation_stick_Type = 1,
    Appreciation_Refresh_Type,
    Appreciation_push_Type,
    Appreciation_autoRefresh_Type,  //智能刷新
};

/** 在招岗位数列表cell类型 */
typedef NS_ENUM(NSInteger, hiringJobCellType) {
    hiringJobCellType_freeJobNum,  //免费岗位数 @deprecated V1.1.2
    hiringJobCellType_vipJobNum,    //@deprecated V1.1.2
    hiringJobCellType_buyJobNum,    //@deprecated  V1.1.2
    hiringJobCellType_allJobBum,    //总在招岗位数
    hiringJobCellType_usedJobNum,   //已使用~
    hiringJobCellType_leftJobNum,   //剩余在招~
    hiringJobCellType_vipInfo,  //VIP购买 etc
};

/** 在招岗位数购买/续费cell类型 */
typedef NS_ENUM(NSInteger, BuyJobNumCelltype) {
    BuyJobNumCelltype_city,
    BuyJobNumCelltype_jobNum,
    BuyJobNumCelltype_jobTimeLong
};

/** 首页招聘中-待审核-已结束页面刷新类型 */
typedef NS_ENUM(NSInteger, VCActionType) {
    VCActionType_HeaderView,   //目前只有刷新首页headerview
};

/** 在招岗位数购买类型 */
typedef NS_ENUM(NSInteger, BuyJobNumActionType) {
    BuyJobNumActionType_ForBuy = 1, //购买
    BuyJobNumActionType_ForRenew,    //续费
    BuyJobNumActionType_ForReBuy,   //首页-上架岗位 无权限 数据填充岗位相关城市
};


typedef NS_ENUM(NSInteger, VipPacketCellType) {
    VipPacketCellType_service,   //服务
    VipPacketCellType_chooseCity,   //选择城市(无数据)
    VipPacketCellType_qrcode,   //推荐码
    VipPacketCellType_guize,    //规则
    VipPacketCellType_chooseCityWithData,   //选择城市 有数据
};

#endif /* MyEnum_h */
