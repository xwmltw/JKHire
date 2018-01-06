//
//  ResponseInfo.h
//  jianke
//
//  Created by xiaomk on 15/9/7.
//  Copyright (c) 2015年 xianshijian. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "ParamModel.h"
#import "TeamJobModel.h"
#import "EPModel.h"

@interface ResponseInfo : NSObject

@property (nonatomic, copy) NSString *errMsg;
@property (nonatomic, copy) NSNumber *errCode;
@property (nonatomic, copy) NSDictionary *content;
@property (nonatomic, copy) NSDictionary *originData;

- (BOOL)success;

@end


@interface GetPublicKeyModel : NSObject
@property (nonatomic, copy) NSString *pub_key_exp;
@property (nonatomic, copy) NSString *expire_time;
@property (nonatomic, copy) NSString *modulus;
@property (nonatomic, copy) NSString *pub_key_base64;
@end

@interface ShockHand2Model : NSObject
@property (nonatomic, copy) NSNumber *seq;
@property (nonatomic, copy) NSNumber *expire_time;
@property (nonatomic, copy) NSString *server_random;
@property (nonatomic, copy) NSString *token;

@end

@interface CreatSessionModel : NSObject
@property (nonatomic, copy) NSString *challenge;
@property (nonatomic, copy) NSString *pub_key_base64;
@property (nonatomic, copy) NSString *pub_key_modulus;
@property (nonatomic, copy) NSString *pub_key_exp;
@property (nonatomic, copy) NSString *sessionId;
@property (nonatomic, copy) NSString *userToken;

@end

@interface PunchResponseModel : NSObject
@property (nonatomic, copy) NSString *punch_the_clock_request_id;
@property (nonatomic, copy) NSNumber *create_time;
@property (nonatomic, strong) NSNumber *need_punch_count;
@property (nonatomic, strong) NSNumber *has_punch_count;
@property (nonatomic, strong) NSNumber *request_status;
@end


//“apply_job_id”:// 申请岗位id
//“stu_account_id”:// 兼客账号id
//“true_name”:// 兼客姓名
//“user_profile_url” : // 兼客头像
//“sex”:// 性别
//“telphone”:// 手机号，即登录账号

@interface PunchClockModel : NSObject
@property (nonatomic, copy) NSArray *punch_request_list;    /** 模型数组 */
@property (nonatomic, strong) QueryParamModel *query_param; /** 分页模型 */
@property (nonatomic, copy) NSNumber *punch_request_list_history_count;   /** 历史记录数 */
@end

@interface QueryClockRecordList : PunchClockModel
//@property(nonatomic,copy)NSArray *punch_the_clock_list;
@end

@interface AcctVirtualModel : NSObject

@property (nonatomic, copy) NSString *detail_list_id;   /** 流水记录id */
@property (nonatomic, copy) NSString *account_money_id; /** 帐户id */
@property (nonatomic, copy) NSNumber *actual_amount;    /**  <int>明细产生的金额，单位为分，不包含小数 */
@property (nonatomic, copy) NSNumber *small_red_point;  /**  <int>是否呈现小红点，1表示是，0表示否 */
@property (nonatomic, copy) NSString *virtual_money_detail_type;    /** 流水类型 */
@property (nonatomic, copy) NSString *virtual_money_detail_title;   /** 流水标题 */
@property (nonatomic, copy) NSNumber *aggregation_number;   /** <int>流水的聚合次数（仅对于企业为兼客支付工资有效，数字表示支付次数） */
@property (nonatomic, copy) NSNumber *create_time;  /** <long> 从1970年1月1日至今的秒数 */
@property (nonatomic, copy) NSNumber *update_time;  /**  <long> 从1970年1月1日至今的秒数 */
@property (nonatomic, copy) NSString *job_id;   /** <long>如果此明细与岗位有关，本字段不为空 */
@property (nonatomic, copy) NSString *task_id;  /** <long>如果此明细与宅任务有关，本字段不为空 */

@end

@interface AcctVirtualResponseModel : NSObject

@property (nonatomic, strong) QueryParamModel *query_param; /** 分页模型 */
@property (nonatomic, copy) NSNumber *recruitment_amount; /** <int>账户招聘余额 */
@property (nonatomic, copy) NSNumber *recruitment_frozen_amount; /** <int>账户招聘冻结款余额 */
@property (nonatomic, copy) NSNumber *has_set_bag_pwd;  /**  <int>是否设置过钱袋子密码 */
@property (nonatomic, copy) NSArray *detail_list;    /** 招聘余额明细模型数组 */

@end

@interface DetailItemResponseMolde : NSObject

@property (nonatomic, strong) QueryParamModel *query_param;
@property (nonatomic, copy) NSString *detail_item_count;
@property (nonatomic, copy) NSArray *stu_list;

@end

@interface ToadyPublishedJobNumRM : NSObject
@property (nonatomic, copy) NSNumber *max_published_today;                  /*!< 认证雇主每日岗位限制发布数 */
@property (nonatomic, copy) NSNumber *authenticated_publish_job_num;        /*!< 认证雇主今日已发布岗位数 */
@property (nonatomic, copy) NSNumber *authenticated_status;                 /*!< 认证转态 */
@property (nonatomic, copy) NSNumber *not_authenticated_can_publish_num;    /*!< 未认证剩余可发布数量 */
@end

@class CityModel;
@interface StuSubscribeModel : MKBaseModel

@property (nonatomic, strong) NSArray *job_classify_id_list;    /*!< 岗位分类id */
@property (nonatomic, strong) NSArray *address_area_id_list;    /*!< 工作区域id */
@property (nonatomic, strong) NSArray *job_classifier_list; /*!< 岗位类型   JobClassifyInfoModel  */
@property (nonatomic, strong) NSArray *child_area;  /*!< 城市子区域列表 CityModel */
@property (nonatomic, assign) long work_time;  /*!< 工作时间 */
@property (nonatomic, strong) CityModel *city_info; /*!< 城市模型 */
@property (nonatomic, copy) NSNumber *city_id;  /*!< 订阅城市id */

@end

@interface UpdateStuSubscribeModel : MKBaseModel

@property (nonatomic, copy) NSArray* job_classify_id_list;
@property (nonatomic, copy) NSArray* address_area_id_list;
@property (nonatomic, assign) NSUInteger work_time;
@property (nonatomic, strong) NSNumber* is_reset_subscribe;
@property (nonatomic, copy) NSNumber *city_id;

@end

@interface SocialActivistTaskListModel : MKBaseModel
@property (nonatomic, copy) NSArray *task_list; /*!< 人脉王岗位列表 */
@property (nonatomic, copy) NSNumber *all_receive_reward; /*!< 所获得总赏金 */
@property (nonatomic, copy) NSNumber *is_receive_social_activist_push; /*!< 是否接收人脉王推送  1：是 0：否 */
@property (nonatomic, copy) NSNumber *in_history_task_list_count; /*!< 历史记录条数 */
@property (nonatomic, copy) NSNumber *job_topic_id; /*!< 人脉王专题id */

@end

@interface JobVasModel : MKBaseModel
@property (nonatomic, copy) NSNumber *id;    /*!< 服务ID */
@property (nonatomic, copy) NSNumber *price;    /*!< 服务价格,单位为分 */
@property (nonatomic, copy) NSNumber *promotion_price;  /*!< 服务促销价格,单位为分 */
@property (nonatomic, copy) NSNumber *top_days; /*!< 置顶天数 */
@property (nonatomic, copy) NSNumber *push_num; /*!< 推送人数 */

//刷新相关
@property (nonatomic, copy) NSNumber *discount_rate;    /*!< 价格折扣率 */
@property (nonatomic, copy) NSNumber *refresh_days; /*!< 智能刷新天数 */
@property (nonatomic, copy) NSNumber *refresh_type; /*!< 智能刷新类型: 1单日定点刷新1次 2单日定点刷新2次 */

//自定义字段
@property (nonatomic, copy) NSNumber *serviceType; /*!< 增值服务类型 */
@property (nonatomic, assign) BOOL selected;    /*!< 是否被选中 */
@property (nonatomic, copy) NSNumber *rechargePrice;    /*!< 支付价格 */
@end

@interface JobVasResponse : MKBaseModel

@property (nonatomic, copy) NSNumber *top_dead_time;    /*!< 置顶截止时间 */
@property (nonatomic, copy) NSNumber *last_refresh_time;    /*!< 上次岗位刷新时间 */
@property (nonatomic, copy) NSNumber *last_push_time;   /*!< 上次岗位推送时间 */
@property (nonatomic, copy) NSString *last_push_desc;   /*!< 上次岗位推送描述 */

@end

@interface ServicePersonalStuModel : MKBaseModel
@property (nonatomic, copy) NSNumber *stu_account_id;  // 账号id
@property (nonatomic, copy) NSString *true_name;    // 姓名
@property (nonatomic, copy) NSString *sex; // 性别
@property (nonatomic, copy) NSNumber *id_card_verify_status;    // 身份认证状态
@property (nonatomic, copy) NSString *desc_after_true_name; // 姓名后面显示的描述信息
@property (nonatomic, copy) NSArray *service_personal_info_list;    //key-value键值
@property (nonatomic, copy) NSArray *work_photos_list; //经历图片数组

@property (nonatomic, copy) NSNumber *id;   /*!< 投递id */
@property (nonatomic, copy) NSNumber *apply_status; /*!< //邀约状态 1：待回复 2：已报名 3：已拒绝 4：待沟通 5：不合适 6：已沟通 7：已取消 */
@property (nonatomic, copy) NSNumber *contact_telephone;    /*!< 联系手机号（注：只有已支付状态才有联系手机号字段） */
@property (nonatomic, copy) NSString *profile_url;  /*!< 兼客头像 */
@property (nonatomic, copy) NSNumber *service_personal_job_apply_id;    /*!< 个人服务需求申请Id */
@property (nonatomic, copy) NSNumber *is_be_invited;    /*!< 是否已经邀约  1：是  0:否 */
@property (nonatomic, copy) NSNumber *invite_type;  /*!< 1：雇主邀约 2：系统邀约 3：自主报名 */
@property (nonatomic, copy) NSNumber *expected_salary;  /*!< 期望薪资 */
@property (nonatomic, assign) CGFloat cellHeight;

@end

@interface ServiceTeamModel : MKBaseModel
@property (nonatomic, copy) NSNumber *service_apply_id; /*!< 服务商记录id */
@property (nonatomic, copy) NSNumber *service_classify_id;  /*!< 服务类型id */
@property (nonatomic, copy) NSString *service_classify_img_url; /*!< 服务分类图片url */
@property (nonatomic, copy) NSString *ent_name; /*!< 企业名称 */
@property (nonatomic, copy) NSNumber *experience_count; /*!< 成功案例个数 */
@property (nonatomic, copy) NSString *city_name;    /*!< 城市名称 */
@property (nonatomic, copy) NSNumber *ordered_count;    /*!< 被预约数 */
@property (nonatomic, copy) NSString *service_profile_url;  /*!< 服务商头像 */
@property (nonatomic, assign) CGFloat cellHeight;
@end

@interface TeamCompanyModel : MKBaseModel

@property (nonatomic, copy) NSNumber *id;   /*!< 投递id */
@property (nonatomic, strong) EPModel *ordered_basic_info;    /*!< 被预约者企业信息详情 */
@property (nonatomic, strong) EPModel *orderer_basic_info;  /*!< 预约者企业信息详情 */
@property (nonatomic, strong) TeamJobModel *service_team_job;   /*!< 团队服务需求 */
@property (nonatomic, copy) NSNumber *service_apply_id; /*!< 服务商记录id */
@property (nonatomic, copy) NSNumber *service_team_job_id;  /*!< 团队服务需求id */
@property (nonatomic, copy) NSNumber *be_order_account_id;  /*!< 被预约者账号id */
@property (nonatomic, copy) NSNumber *ordered_read_status;  /*!< 被预约者查看详情状态 1已查看 */
@property (nonatomic, copy) NSNumber *contact_status;   /*!< 电话联系状态：1 已电话联系 0 未联系 */
@property (nonatomic, copy) NSNumber *contact_time; /*!< 电话联系时间 */
@property (nonatomic, copy) NSNumber *contact_result_type;  /*!< 电话联系结果枚举：1谈妥合作 2未谈妥合作 3电话无法接通 4其他' */
@property (nonatomic, copy) NSNumber *create_time;  /*!< 创建时间 */

@property (nonatomic, assign) CGFloat cellHeight;

@end

@interface SpreadOrderModel : MKBaseModel

@property (nonatomic, copy) NSNumber *id;   /*!< 订单Id */
@property (nonatomic, copy) NSNumber *orderType;    /*!< 订单类型:1:众包 2:熊地推 */
@property (nonatomic, copy) NSNumber *spreadId; /*!< 推广id */
@property (nonatomic, copy) NSString *spreadAontent;    /*!< 需求说明 */
@property (nonatomic, copy) NSString *productName;  /*!< 产品名称 */
@property (nonatomic, copy) NSString *name; /*!< 联系人姓名 */
@property (nonatomic, copy) NSNumber *phonenumber;  /*!< 联系人电话 */
@property (nonatomic, copy) NSNumber *createTime;   /*!< 订单创建日期 */


@end

@interface ServiceTeamApplyModel : MKBaseModel

//雇主信息案例
@property (nonatomic,copy) NSNumber *account_id;   /*!< 账号Id */
@property (nonatomic,copy) NSNumber *id;    /*!< 申请Id */
@property (nonatomic,copy) NSNumber *create_time;   /*!< 创建时间 */
@property (nonatomic,copy) NSNumber *service_classify_id;   /*!< 服务类型id */
@property (nonatomic,copy) NSString *service_classify_img_url;  /*!< 服务分类图片url */
@property (nonatomic,copy) NSString *service_classify_name; /*!< 服务分类名称 */
@property (nonatomic,copy) NSNumber *experience_count;  /*!< 成功案例个数 */
@property (nonatomic,copy) NSNumber *status;    /*!< 状态 1申请中 2已通过 3未通过 */
@end

@interface InsuranceRecordModel : MKBaseModel

@property (nonatomic,copy) NSNumber *insurance_record_id;   /*!< 投保记录id */
@property (nonatomic,copy) NSNumber *insurance_count;  /*!< 投保人数 */
@property (nonatomic,copy) NSNumber *create_time;   /*!< 投保记录创建时间 */

@end

@interface VipRecruitJobNumInfo : MKBaseModel

@property (nonatomic, copy) NSNumber *vip_type; /*!< 会员类型 0试用版1标准版 2高级版 3钻石版 */
@property (nonatomic, copy) NSNumber *expired_time; /*!< 会员过期时间，时间戳 */
@property (nonatomic, copy) NSNumber *all_vip_recruit_job_num;  /*!< 会员的总在招岗位数 */

@end

@interface RechargeRecruitJobNumInfo : MKBaseModel

@property (nonatomic, copy) NSNumber *last_should_expired_time; /*!< 最近过期时间，时间戳 */
@property (nonatomic, copy) NSNumber *last_should_expired_num;  /*!< 最近待过期在招岗位数 */
@property (nonatomic, copy) NSNumber *all_recharge_recruit_job_num; /*!< 购买的总在招岗位数 */

@end

@interface RecruitJobNumInfo : MKBaseModel

@property (nonatomic, copy) NSNumber *all_recruit_job_num;  /*!< 总在招岗位数 */
@property (nonatomic, copy) NSNumber *userd_recruit_job_num;    /*!< 已使用在招岗位数 */
@property (nonatomic, copy) NSNumber *free_recruit_job_num;     /*!< 免费在招岗位数 */
@property (nonatomic, strong) VipRecruitJobNumInfo *vip_recruit_job_num_info;
@property (nonatomic, strong) RechargeRecruitJobNumInfo *recharge_recruit_job_num_info;

@end

@interface RecruitJobNumRecord : MKBaseModel

@property (nonatomic, copy) NSNumber *id;   /*!< 记录id */
@property (nonatomic, copy) NSString *record_title; /*!< 记录标题 */
@property (nonatomic, copy) NSNumber *begin_time;   /*!< 在招岗位数开始时间，时间戳 */
@property (nonatomic, copy) NSNumber *end_time;  /*!< 在招岗位数过期时间，时间戳 */
@property (nonatomic, copy) NSNumber *recruit_city_id;  /*!< 招聘城市id */
@property (nonatomic, copy) NSNumber *recruit_job_num;  /*!< 在招岗位数 */

@end

@interface  VipSpreadInfo : MKBaseModel

@property (nonatomic, copy) NSNumber *is_can_use_vip_spread;    /*!< 是否可以使用特权推广 1是 0否, */
@property (nonatomic, copy) NSNumber *can_top_days; /*!< 剩余置顶天数 */
@property (nonatomic, copy) NSNumber *can_push_num; /*!< 剩余推送人数 */
@property (nonatomic, copy) NSNumber *can_refresh_num;    /*!< 剩余刷新次数 */
@end

@interface JobVasListModel : MKBaseModel

@property (nonatomic, strong) VipSpreadInfo *vip_spread_info;   /*!< 特权推广信息 */
@property (nonatomic, copy) NSNumber *job_dead_time;    /*!< 岗位截止时间，有上传job_id时有 */
@property (nonatomic, copy) NSArray *job_top_vas_list;    /*!< 置顶服务信息 */
@property (nonatomic, copy) NSArray *job_push_vas_list;   /*!< 推送服务信息 */
@property (nonatomic, copy) NSArray *job_refresh_vas_list;    /*!< 刷新服务信息 */
@property (nonatomic, strong) FeedbackParam *job_push_label_list;   /*!< 岗位推送标签 */

@end

@interface LatestVerifyInfo : MKBaseModel

@property (nonatomic, strong) PostIdcardAuthInfoPM *last_id_card_verify_info;
@property (nonatomic, strong) PostIdcardAuthInfoPM *last_business_licence_verify_info;
@property (nonatomic, strong) PostIdcardAuthInfoPM *account_info;

@end

@interface VipPackageEntryModel : MKBaseModel

@property (nonatomic, copy) NSNumber *package_id;   /*!< 套餐id */
@property (nonatomic, copy) NSNumber *vip_type; /*!< 对应会员类型 */
@property (nonatomic, copy) NSString *package_name; /*!< 套餐名称 */
@property (nonatomic, copy) NSString *package_entry_icon;   /*!< 套餐入口图标 */
@property (nonatomic, copy) NSString *package_entry_identifier; /*!< 套餐运营标识 */
@property (nonatomic, copy) NSNumber *total_price;  /*!< 套餐总价，单位为分 */
@property (nonatomic, copy) NSNumber *promotion_price;  /*!< 套餐优惠价，单位为分 */
@property (nonatomic, copy) NSNumber *vip_keep_months;  /*!< 持续月份 */
@property (nonatomic, copy) NSString *package_order_desc;
@property (nonatomic, copy) NSArray *package_item_arr;  /*!< 套餐细项说明 */

@end

@interface PackageItem : MKBaseModel

@property (nonatomic, copy) NSNumber *package_item_id;  /*!< 套餐细项id */
@property (nonatomic, copy) NSString *package_item_desc; /*!< 套餐细项描述 */
@property (nonatomic, copy) NSNumber *package_item_num; /*!< 套餐细项数量 */
@property (nonatomic, copy) NSNumber *package_item_value;   /*!< 套餐细项价值，单位为分 */
@property (nonatomic, copy) NSString *package_item_title;   /*!< 套餐细项弹窗标题 */
@property (nonatomic, copy) NSString *package_item_icon;    /*!< 套餐细项弹窗图标 */
@property (nonatomic, copy) NSString *package_item_value_desc;  /*!< 套餐细项弹窗价值说明 */
@property (nonatomic, copy) NSString *package_item_content; /*!< 套餐细项弹窗优势描述文案 */
@property (nonatomic, copy) NSArray *package_item_privilege_desc;  /*!< 套餐细项特权描述 */

@property (nonatomic, assign) CGFloat cellHeight;

@end

@interface vipTopPrivilege : MKBaseModel

@property (nonatomic, copy) NSNumber *all_top_num;  /*!< 总置顶数 */
@property (nonatomic, copy) NSNumber *left_can_top_num; /*!< 剩余可用置顶数 */
@property (nonatomic, copy) NSNumber *soon_expired_top_num; /*!< 即将过期的置顶数 */

@end

@interface vipRefreshPrivilege : MKBaseModel

@property (nonatomic, copy) NSNumber *all_refresh_num;  /*!< 总刷新数 */
@property (nonatomic, copy) NSNumber *left_can_refresh_num; /*!< 剩余可用刷新数 */
@property (nonatomic, copy) NSNumber *soon_expired_refresh_num; /*!< 即将过期的刷新数 */

@end

@interface vipPushPrivilege : MKBaseModel

@property (nonatomic, copy) NSNumber *all_push_num;    /*!< 总推送数 */
@property (nonatomic, copy) NSNumber *left_can_push_num;    /*!< 剩余可用推送数 */
@property (nonatomic, copy) NSNumber *soon_expired_push_num;    /*!< 即将过期的推送数 */

@end

@interface vipResumePrivilege : MKBaseModel

@property (nonatomic, copy) NSNumber *all_resume_num;    /*!< 总推送数 */
@property (nonatomic, copy) NSNumber *left_resume_num;    /*!< 剩余可用推送数 */
@property (nonatomic, copy) NSNumber *soon_expired_resume_num;    /*!< 即将过期的推送数 */

@end

@interface VipApplyJobNumObj : MKBaseModel
@property (nonatomic, copy) NSNumber *vip_order_id; /*!< 会员订单id */
@property (nonatomic, copy) NSNumber *all_apply_job_num;    /*!< 总可用报名数, */
@property (nonatomic, copy) NSNumber *left_apply_job_num;   /*!< 剩余可用报名数 */
@property (nonatomic, copy) NSNumber *used_apply_job_num;   /*!< 已用报名数 */

@end

@interface CityVipInfo : MKBaseModel

@property (nonatomic, copy) NSString *vip_package_name; /*!< 套餐名称 */
@property (nonatomic, copy) NSNumber *vip_dead_time;    /*!< 过期时间,时间戳 */
@property (nonatomic, copy) NSNumber *vip_city_id;  /*!< 会员城市id */
@property (nonatomic, copy) NSString *vip_city_name;    /*!< 会员城市名称 */
@property (nonatomic, copy) NSNumber *recruit_job_num;  /*!< 在招岗位数, */
@property (nonatomic, copy) NSArray *vip_identity_privilege_desc_arr;   /*!< vip身份特权描述 */
@property (nonatomic, strong) VipApplyJobNumObj *vip_apply_job_num_obj;
@property (nonatomic, assign) CGFloat cellHeight;

@end

@interface AccountVipInfo : MKBaseModel

@property (nonatomic, strong) vipTopPrivilege *national_general_vip_top_privilege;  /*!< 置顶特权信息 */
@property (nonatomic, strong) vipRefreshPrivilege *national_general_vip_refresh_privilege;  /*!< 刷新特权信息 */
@property (nonatomic, strong) vipPushPrivilege *national_general_vip_push_privilege;    /*!< 推送特权信息 */
@property (nonatomic, strong) vipResumePrivilege *national_general_vip_resume_num_privilege;
@property (nonatomic, copy) NSArray *city_vip_info;

@property (nonatomic, assign) CGFloat cellHeight;

- (BOOL)isNullWithGeneralVip;

@end

@interface VipJobListModel : MKBaseModel

@property (nonatomic, copy) NSNumber *job_status;   /*!< 岗位状态:1待审核, 2已发布 , 3已结束, */
@property (nonatomic, copy) NSNumber *job_id;   /*!< 岗位id */
@property (nonatomic, copy) NSNumber *curr_used_apply_num;  /*!< 当前岗位已用报名数, */
@property (nonatomic, copy) NSString *job_title;    /*!< 岗位名称， */
@property (nonatomic, copy) NSString *job_city_name;    /*!< 岗位城市名称 */

- (NSString *)getStatusStr;

@end

@interface ApplyJobListStu : MKBaseModel

@property (nonatomic, copy) NSString *stu_true_name;    /*!< 兼客姓名, */
@property (nonatomic, copy) NSNumber *stu_apply_time;   /*!< 兼客报名时间，时间戳, */

@end

@interface VipApplyPackage : MKBaseModel

@property (nonatomic, copy) NSNumber *id;   /*!< 套餐id */
@property (nonatomic, copy) NSNumber *price;    /*!< 报名数套餐总价格，单位为分 */
@property (nonatomic, copy) NSNumber *unit_price;   /*!< 报名数套餐单价，单位为分, */
@property (nonatomic, copy) NSNumber *apply_job_num;    /*!< 报名数 */
@property (nonatomic, assign) BOOL isSelected;

@end

@interface ResumeNumPackage : MKBaseModel

@property (nonatomic, copy) NSNumber *id;   /*!< 套餐id, */
@property (nonatomic, copy) NSNumber *price;    /*!< 简历数套餐总价格，单位为分, */
@property (nonatomic, copy) NSNumber *promotion_price;  /*!< 简历数套餐促销价，单位为分, */
@property (nonatomic, copy) NSNumber *resume_num;   /*!< 简历数 */
@property (nonatomic, assign) BOOL isSelected;
@end

@interface ArrangedAgentVas : MKBaseModel

@property (nonatomic, copy) NSNumber *id;   /*!< 包代招订单id */
@property (nonatomic, copy) NSNumber *apply_num;    /*!< 购买报名数 */
@property (nonatomic, copy) NSNumber *start_time;   /*!< 开始时间 */
@property (nonatomic, copy) NSNumber *end_time; /*!< 结束时间 */
@property (nonatomic, copy) NSNumber *left_can_apply_num;   /*!< 剩余可报名数 */
@property (nonatomic, copy) NSNumber *curr_used_apply_num;  /*!< 已消耗报名数 */

@end

@interface ArrangedAgentVasInfo : MKBaseModel

@property (nonatomic, copy) NSArray *arranged_agent_vas_list;
@property (nonatomic, copy) NSString *enterprise_name;  /*!< 企业名称 */
@property (nonatomic, copy) NSString *true_name;    /*!< 企业账号真实姓名 */
@property (nonatomic, copy) NSNumber *account_vip_type; /*!< 企业账号对应的VIP会员类型 */
@property (nonatomic, copy) NSString *contacter_name;   /*!< 联系人姓名 */
@property (nonatomic, copy) NSString *contacter_tel;    /*!< 联系人电话 */

@end
