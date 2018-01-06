//
//  JobClassifyInfoModel.m
//  jianke
//
//  Created by xiaomk on 16/4/19.
//  Copyright © 2016年 xianshijian. All rights reserved.
//

#import "JobClassifyInfoModel.h"

@implementation JobClassifyInfoModel
- (void)setDiselect{
    _isSelect = NO;
}

+ (NSArray *)getPersonalTypeList{
    NSArray *names = @[@"模特人员", @"礼仪人员", @"商演人员", @"主持人员"];
    NSArray *jobIds = @[@1, @2, @4, @3];
    NSMutableArray *array = [NSMutableArray array];
    JobClassifyInfoModel *model;
    NSString *name;
    NSNumber *jobId;
    for (NSInteger index = 0; index < names.count; index++) {
        model = [[JobClassifyInfoModel alloc] init];
        model.job_classfier_name = names[index];
        model.job_classfier_id = jobIds[index];
        [array addObject:model];
    }
    return [array copy];
}

//@property (nonatomic, copy) NSNumber *job_classfier_id;         /*!< 岗位分类id */
//@property (nonatomic, copy) NSString *job_classfier_name;       /*!< 岗位分类名称 */
//@property (nonatomic, copy) NSString *job_classfier_spelling;   /*!< 名称拼音 */
//@property (nonatomic, copy) NSString *job_classfier_img_url;    /*!< 岗位分类图片url */

//@property (nonatomic, copy) NSNumber *service_classify_id;  //分类Id
//@property (nonatomic, copy) NSString *service_classify_name;   //分类名称
//@property (nonatomic, copy) NSString *service_classify_img_url;    //分类URL

/** 团队服务需求专用 */
- (void)convertTeamClassify{
    self.job_classfier_id = (self.service_classify_id) ? self.service_classify_id : self.job_classfier_id;
    self.job_classfier_name = (self.service_classify_name) ? self.service_classify_name : self.job_classfier_name;
    self.job_classfier_img_url = (self.service_classify_img_url) ? self.service_classify_img_url : self.job_classfier_img_url;
}

@end

@implementation JobClassifierLabelModel




@end
