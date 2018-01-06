//
//  ServicePersonalJobModel.h
//  JKHire
//
//  Created by fire on 16/10/12.
//  Copyright © 2016年 xianshijian. All rights reserved.
//

#import "ParamModel.h"

@interface ServicePersonalJobModel : ParamModel

@property (nonatomic, copy) NSNumber *service_personal_job_id;  // 个人服务需求id
@property (nonatomic, copy) NSString *service_title;    // 服务名称
@property (nonatomic, copy) NSNumber *service_type;  // 服务类型  1：模特 2：礼仪3：主持  4：商演 5：家教 6：校园代理
@property (nonatomic, copy) NSString *working_place; // 工作地点
@property (nonatomic, copy) NSNumber *working_time_start_date;  //<long>工作时间的开始日期，1970年1月1日至今的毫秒数

//“working_time_end_date”: <long>工作结束的日期，1970年1月1日至今的毫秒数，
//“working_time_period”:{
//    “f_start”: <long>第一段开始时间的毫秒数
//    “f_end”: <long>第二段结束时间的毫秒数
//    “s_start”: <long>第二段开始时间的毫秒数
//    “s_end”: <long>第二段结束时间的毫秒数
//    “t_start”: <long>第三段开始时间的毫秒数
//    “t_end”: <long>第三段结束时间的毫秒数
//},
//“service_desc”:xx , // 服务描述
//“city_id” : xx , // 城市ID, 整形数字 ,
//“address_area_id” : xx , // 区域ID , 整形数字
//“area_code”: 城市区号
//“admin_code”: 区域行政区号
//“status”:// 状态  1：已发布 2：已结束
//“salary”: {  // 薪水
//    “value”: xxx,  // 工资
//    “unit”: xxx, // 工资计算方式：按小时计算或者按天计算，具体定义与数据字典一致
//},

@end
