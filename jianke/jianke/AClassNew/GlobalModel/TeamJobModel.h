//
//  TeamJobModel.h
//  JKHire
//
//  Created by fire on 16/10/22.
//  Copyright © 2016年 xianshijian. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TeamJobModel : NSObject

@property (nonatomic, copy) NSNumber *service_team_job_id;  /*!< 服务需求id */
@property (nonatomic, copy) NSString *service_title;    /*!< 团队服务名称 */
@property (nonatomic, copy) NSNumber *service_apply_id; /*!< 服务需求申请记录Id */
@property (nonatomic, copy) NSNumber *city_id;  /*!< 城市ID, 整形数字 , (需上传字段) */
@property (nonatomic, copy) NSNumber *recruitment_num;  /*!< 服务需求人数(需上传字段) */
@property (nonatomic, copy) NSNumber *service_classify_id;  /*!< 服务类型id   (需上传字段) */
@property (nonatomic, copy) NSString *service_classify_name;    /*!< 服务类型名称 */
@property (nonatomic, copy) NSNumber *budget_amount;    /*!< 总预算金额(需上传字段) */
@property (nonatomic, copy) NSNumber *working_time_start_date;  /*!< <long>工作时间的开始日期，1970年1月1日至今的毫秒数(需上传字段) */
@property (nonatomic, copy) NSNumber *working_time_end_date;    /*!< <long>工作结束的日期，1970年1月1日至今的毫秒数，  (需上传字段) */
@property (nonatomic, copy) NSString *city_name;    /*!< 城市名 */
@property (nonatomic, copy) NSNumber *status;   /*!< 状态  1：已发布 2：已结束 */
@property (nonatomic, copy) NSNumber *create_time;  /*!< 服务需求创建时间 */
@property (nonatomic, copy) NSNumber *read_count;   /*!< 服务需求浏览数 */
@property (nonatomic, copy) NSNumber *order_count;  /*!< 服务需求预约数 */
@property (nonatomic, copy) NSNumber *is_order_this_team;   /*!< 是否预约了该团队服务商 */

@property (nonatomic, assign) CGFloat cellHeight;

@end
