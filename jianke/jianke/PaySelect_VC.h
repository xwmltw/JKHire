//
//  PaySelect_VC.h
//  
//
//  Created by xiaomk on 15/10/9.
//
//

#import <UIKit/UIKit.h>
//#import "QueryAccountMoneyModel.h"
//#import "PaySalaryModel.h"
#import "MKBaseTableViewController.h"
#import "PayJobInfoModel.h"


typedef NS_ENUM(NSInteger, PaySelectFromType) {
    PaySelectFromType_noType                = 0,
    PaySelectFromType_epPay,                    /*!< 雇主直接支付 */
    PaySelectFromType_jobBill,                  /*!< 账单支付 */
    PaySelectFromType_insurance,                /*!< 保险支付 */
    PaySelectFromType_partnerPostJob,           /*!< 合伙人发布岗位  */
    PaySelectFromType_inviteBalance,            /*!< 个人中心招聘余额 */
    PaySelectFromType_JobVasOrder,               /*!< 岗位增值服务订单(置顶/刷新/推送) */
    PaySelectFromType_ServicePersonalOrder,    /*!< 雇主支付个人服务订单(联系方式) */
    PaySelectFromType_pinganInsurance,      /*!< 平安保险(非岗位) */
    PaySelectFromType_JobVasPushOrder,   /*!< 推广付费 -- 从兼职管理进去的 */
    PaySelectFromType_JobVasPushOrderFromJobManage,   /*!< 推广付费 -- 从岗位管理进去的 */
    PaySelectFromType_payOtherSalary,   /*!< 代发工资 */
    PaySelectFromType_RecruitJobNum,   /*!< 雇主购买在招岗位数 */
    PaySelectFromType_guaranteeAmount,   /*!< 雇主购买保证金 */
    PaySelectFromType_payGuaranteeAmountForPostJob,   /*!< 雇主购买保证金(发布成功页面) */
    PaySelectFromType_payVipOrder,   /*!< 雇主支付vip套餐 */
    PaySelectFromType_payVipApplyJobNumOrder,   /*!< 支付VIP会员报名数订单 */
    PaySelectFromType_payResumeNumOrder, /*!< 雇主支付简历数订单 */
};

@interface PaySelect_VC : MKBaseTableViewController

@property (nonatomic, assign) int needPayMoney;                 /*!< 支付的金额 单位分*/
@property (nonatomic, copy, nullable) NSArray* arrayData;       /*!< 支付列表 */

@property (nonatomic, copy, nullable) NSNumber *job_bill_id;    /*!< 岗位账单id */
@property (nonatomic, copy, nullable) NSNumber *jobId;          /*!< 岗位ID */

@property (nonatomic, copy, nullable) NSNumber* isAccurateJob;  /*!< 是否为精确岗位 */

@property (nonatomic, copy, nullable) NSString *on_board_time;  /*!< 上岗日期0点毫秒 精确岗位 单天 添加发放对象 支付用*/
@property (nonatomic, assign) PaySelectFromType fromType;       /*!< 来源 必传 */

@property (nonatomic, copy, nullable) NSNumber *job_vas_order_id; /*!< 岗位增值服务订单id */
@property (nonatomic, copy, nullable) NSNumber *service_personal_order_id;  /*!< 个人服务订单id */
@property (nonatomic, copy, nullable) NSNumber *insurance_record_id;    /*!<  投保记录id */
@property (nonatomic, copy, nullable) NSNumber *recruit_job_num_order_id; /*!< 在线购买岗位订单id */

@property (nonatomic, copy, nullable) NSNumber *push_num; /*!< 推送人数 推送付费 成功页面用*/
@property (nonatomic, copy, nullable) NSNumber *vip_order_id;  /*!< 雇主购买VIP套餐订单id */
@property (nonatomic, copy, nullable) NSNumber *vip_apply_job_num_order_id;   /*!< 报名数订单id */
@property (nonatomic, copy, nullable) NSNumber *resume_num_order_id;    /*!< 简历数订单id */

@property (nonatomic, copy, nullable) MKBlock partnerPostJobPayBlock;

@property (nonatomic, copy, nullable) MKBlock updateDataBlock;


@end




