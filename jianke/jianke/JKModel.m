//
//  JKModel.m
//  jianke
//
//  Created by fire on 15/9/15.
//  Copyright (c) 2015年 xianshijian. All rights reserved.
//  兼客简历模型

#import "JKModel.h"
#import "MKCommonHelper.h"
#import "DateHelper.h"

@implementation JKModel
MJCodingImplementation

//- (void)getNameFirstPinyin{
//    self.pinyinFirstLetter = [MKCommonHelper getChineseNameFirstPinyinWithName:self.true_name];
//}

- (NSDictionary *)objectClassInArray{
    return @{@"resume_experience_list" : [ResumeExperience class]};
}

- (NSString *)getEducationStr{
    switch (self.education.integerValue) {
        case 1:
            return @"大专";
        case 2:
            return @"本科";
        case 3:
            return @"硕士";
        case 4:
            return @"博士";
        case 5:
            return @"其他";
        default:
            break;
    }
    return @"";
}

- (NSString *)getAgeStr{
    if (self.birthday.length) {
        NSDate *date = [DateHelper getDateFromStr:self.birthday formatter:@"yyyy-MM-dd"];
        NSInteger birthDayInt = [DateHelper compareYearsFromDate:date toDate:[NSDate date]];
        return [NSString stringWithFormat:@"%ld岁", birthDayInt + 1];
    }
    return @"";
}

@end

@implementation StuPunckClockInfoModel
@end

@implementation ResumeExperience
MJCodingImplementation
@end

@implementation SoonExpiredResume
@end

