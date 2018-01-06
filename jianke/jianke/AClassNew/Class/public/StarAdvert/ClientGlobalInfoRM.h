//
//  ClientGlobalInfoRM.h
//  jianke
//
//  Created by xiaomk on 16/5/16.
//  Copyright © 2016年 xianshijian. All rights reserved.
//

#import "MKBaseModel.h"
#import "ShareInfoModel.h"
#import "ClientVersionModel.h"

@class ShareModel,AdOnOffModel,WapUrlModel, CityRecruitJobNumPrice, IndustryInfoList;

@interface ClientGlobalInfoRM : MKBaseModel

@property (nonatomic, copy) NSNumber *current_time_millis;          /*!< 时间毫秒<整形数字> */
@property (nonatomic, copy) NSArray *service_team_entry_list;   //服务商服务入口信息
@property (nonatomic, copy) NSArray *banner_ad_list;                /*!< 客户端banner广告 */
@property (nonatomic, copy) NSString *alipay_withdraw_desc_youpin_v1;   /*!< 支付宝取现须知 */
@property (nonatomic, strong) WapUrlModel *wap_url_list;
@property (nonatomic, copy) NSString *withdraw_desc;                /*!< 取现须知 */
@property (nonatomic, copy) NSArray *feedback_classify_list;        /*!< 意见反馈类型 */
@property (nonatomic, copy) NSNumber *pingan_unit_price_ent;    /*!< 平安投保单价 */
@property (nonatomic, copy) NSArray *service_type_classify_list;    /*!< 个人服务二级分类 */
@property (nonatomic, copy) NSString *logo_url; /*!< 分享logo_url */
@property (nonatomic, copy) NSArray *service_type_stu_banner_ad_list;   /*!< 觅探分类列表banenr广告列表字段 */
@property (nonatomic, copy) NSNumber *is_show_adviser;  /*!< 是否显示兼客觅探顾问相关内容 */
@property (nonatomic, copy) NSString *adviser_telephone;    /*!< 兼客觅探顾问手机号码 */
@property (nonatomic, copy) NSString *adviser_intro_url;    /*!< 联系顾问url */

@property (nonatomic, copy) NSArray *industry_info_list; /*!< 行业信息 */

@property (nonatomic, strong) ClientVersionModel *version_info;     /*!< 版本更新信息 */
@property (nonatomic, strong) ShareModel *share_info;

@property (nonatomic, copy) NSNumber *is_use_third_party_open_screen_ad;    /*!< 是否使用第三方启动广告 */
@property (nonatomic, copy) NSArray *start_front_ad_list;           /*!< 客户端启动前景广告 */

@property (nonatomic, copy) NSArray *special_entry_list;            /*!< 特色入口信息 */


@property (nonatomic, copy) NSArray *stu_head_line_ad_list;         /*!< 兼客头条 */
@property (nonatomic, copy) NSArray *ent_head_line_ad_list;         /*!< 雇主头条 */
@property (nonatomic, copy) NSArray *ent_pop_up_ad_list;            /*!< 雇主首页 scrollView 广告 */


@property (nonatomic, copy) NSNumber *advance_salary_entry_enable;  /*!< 预付款入口，1开启，0不开启 */

@property (nonatomic, copy) NSNumber *alipay_sigle_withdraw_min_limit;  /*!< 支付宝取出最低限额 */


@property (nonatomic, copy) NSNumber *apply_job_limit_status;     /*!< 岗位投递限制开关，1开启，0不开启 */
@property (nonatomic, copy) NSNumber *apply_job_limit_enable;       /*!< 岗位投递限制开关，1开启，0不开启 */

@property (nonatomic, copy) NSString *borrowday_advance_salary_url; /*!< 菠萝代 预领工资URL */
@property (nonatomic, copy) NSString *zhai_task_wap_index_url;      /*!< m端宅任务首页链接地址 */

@property (nonatomic, strong) AdOnOffModel *ad_on_off;

@property (nonatomic, copy) NSString *service_personal_url; /*!< 个人服务url */
@property (nonatomic, strong) CityRecruitJobNumPrice *city_recruit_job_num_price;   /*!< 在招岗位数价格列表 */
@property (nonatomic, copy) NSString *consumer_hotline; /*!< 客服电话 */
@property (nonatomic, copy) NSArray *ent_contact_resume_feedback_list;/*!<雇主联系兼客反馈结果类型 */

@end

@interface ShareModel : MKBaseModel
@property (nonatomic, strong) ShareInfoModel *share_info;
@property (nonatomic, copy) NSString *sms_share_info;
@end

@interface AdOnOffModel : MKBaseModel
@property (nonatomic, copy) NSNumber *job_list_third_party_ad_open;             /*!< 岗位列表广告是否开启  1：开启 0：关闭 */
@property (nonatomic, copy) NSNumber *job_detail_third_party_ad_open;           /*!< 岗位详情第三方广告是否开始 1：开启 0：关闭 */
@property (nonatomic, copy) NSNumber *job_apply_success_third_party_ad_open;    /*!< 岗位报名成功页面第三方广告是否开启  1：开启 0：关闭 */

@end

@interface WapUrlModel : MKBaseModel

@property (nonatomic, copy) NSString *zhongbao_demand_url;  /*!< 众包介绍页面 */
@property (nonatomic, copy) NSString *xdt_demand_url;   /*!< 熊地推介绍页面 */
@property (nonatomic, copy) NSString *query_service_personal_apply_job_list_url;    /*!< 我的通告列表页面 */
@property (nonatomic, copy) NSString *find_service_personal_job_list_url;   /*!< 找通告列表页面 */
@property (nonatomic, copy) NSString *find_service_personal_stu_list_url;   /*!< 找艺人页面url */
@property (nonatomic, copy) NSString *post_service_personal_job_url;    /*!< 发布通告 url */
@property (nonatomic, copy) NSString *jkjz_vip_center_url;  /*!< 会员中心入口 */
@property (nonatomic, copy) NSString *query_service_personal_job_list_url;  /*!< 兼客通告通告管理页面 */

@end

@interface serviceTypeClassify : MKBaseModel

@property (nonatomic, copy) NSNumber *key;   /*!< 个人服务类型 */
@property (nonatomic, copy) NSArray *value; /*!< 二级服务数组 */

@end

@interface CityRecruitJobNumPrice : MKBaseModel

@property (nonatomic, copy) NSNumber *first_level;  /*!< 一线城市价格，单位为分 */
@property (nonatomic, copy) NSNumber *second_level; /*!< 二线城市价格，单位为分 */

@end

@interface IndustryInfoList : MKBaseModel

@property (nonatomic, copy) NSString *industry_desc;    /*!< 行业描述 */
@property (nonatomic, copy) NSNumber *industry_id;  /*!< 行业Id */
@property (nonatomic, copy) NSNumber *industry_order;   /*!< 行业排序 */
@property (nonatomic, copy) NSString *industry_name;    /*!< 行业名称 */

@end



//“current_time_millis”: xxx //时间毫秒<整形数字>
//“advance_salary_entry_enable”: xxx//预付款入口，1开启，0不开启
//“apply_job_limit_status”: xxx //岗位投递限制开关，1开启，0不开启
//“stu_head_line_ad_list”:[] 兼客头条
//“ent_head_line_ad_list”: [] 雇主头条
//“special_entry_list” : [] 特色入口信息
//“is_use_third_party_open_screen_ad” : xxx // 是否使用第三方启动广告
//“start_front_ad_list” : [] // 客户端启动前景广告
//“banner_ad_list” : [] // 客户端banner广告
//“alipay_withdraw_desc” : xxx // 支付宝取现须知
//“zhai_task_wap_index_url”:xxx // m端宅任务首页链接地址
//点击广告数据结构



//content = {
//    advance_salary_entry_enable = 1,
//    alipay_sigle_withdraw_min_limit = 1,
//    current_time_millis = 1463380265106,
//    share_info = {
//        share_info = {
//            share_img_url = http://wodan-idc.oss-cn-hangzhou.aliyuncs.com/develop/Upload/shijianke-mgr/share/2015-06-16/c981e6a463ce4adb9c38b1fd3eb478c0.shareImg,
//            share_url = http://localhost:8080/shijianke-server/shorturl/app/STUDENT/,
//            share_title = 找兼职上兼客 想干就干,
//            share_content = 想找份兼职赚点零花钱？兼客，一个专门找兼职的APP，赶紧试试吧！
//        },
//        sms_share_info = 想找份兼职赚点零花钱？兼客，一个专门找兼职的APP，赶紧试试吧！http://localhost:8080/shijianke-server/shorturl/app/STUDENT/
//    },
//    zhai_task_wap_index_url = http://zhongbao.shijianke.com,
//    version_info = {
//    },
//    alipay_withdraw_desc = 提现须知,
//    is_use_third_party_open_screen_ad = 1,
//    apply_job_limit_enable = 1
//},

    
