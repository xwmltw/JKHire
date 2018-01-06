//
//  ResponseInfo.m
//  jianke
//
//  Created by xiaomk on 15/9/7.
//  Copyright (c) 2015年 xianshijian. All rights reserved.
//

#import "ResponseInfo.h"
#import "ReportRecordModel.h"
#import "PayDetailModel.h"
#import "JobClassifyInfoModel.h"
#import "CityModel.h"
#import "SociaAcitvistModel.h"

@implementation ResponseInfo

- (BOOL)success{
    return self.errCode.intValue == 0;
}

@end

@implementation GetPublicKeyModel
@end

@implementation ShockHand2Model
@end

@implementation CreatSessionModel
@end

@implementation PunchResponseModel
@end

@implementation PunchClockModel
- (NSDictionary *)objectClassInArray{
    return @{@"punch_request_list" : [PunchResponseModel class]};
}
@end

@implementation QueryClockRecordList

- (NSDictionary *)objectClassInArray{
    return @{@"punch_the_clock_list" : [ReportRecordModel class]};
}

@end

@implementation AcctVirtualModel
@end

@implementation AcctVirtualResponseModel

- (NSDictionary *)objectClassInArray{
    return @{@"detail_list" : [AcctVirtualModel class]};
}

@end

@implementation DetailItemResponseMolde

- (NSDictionary *)objectClassInArray{
    return @{@"detail_list" : [PayDetailModel class]};
}

@end

@implementation ToadyPublishedJobNumRM

@end

@implementation StuSubscribeModel

- (NSDictionary *)objectClassInArray{
    return @{@"child_area" : [CityModel class] , @"job_classifier_list" : [JobClassifyInfoModel class]};
}

@end

@implementation UpdateStuSubscribeModel

@end

@implementation SocialActivistTaskListModel

- (NSDictionary *)objectClassInArray{
    return @{@"task_list" : [SociaAcitvistModel class]};
}

@end

@implementation JobVasModel
@end

@implementation JobVasResponse
@end

@implementation ServicePersonalStuModel
@end

@implementation ServiceTeamModel
@end

@implementation TeamCompanyModel
@end

@implementation SpreadOrderModel
@end

@implementation ServiceTeamApplyModel
@end

@implementation InsuranceRecordModel
@end

@implementation VipRecruitJobNumInfo
@end

@implementation RechargeRecruitJobNumInfo
@end

@implementation RecruitJobNumInfo

- (NSDictionary *)objectClassInArray{
    return @{@"vip_recruit_job_num_info" : [VipRecruitJobNumInfo class] , @"recharge_recruit_job_num_info" : [RechargeRecruitJobNumInfo class]};
}


@end

@implementation RecruitJobNumRecord
@end

@implementation VipSpreadInfo
@end

@implementation JobVasListModel

- (NSDictionary *)objectClassInArray{
    return @{@"job_top_vas_list" : [JobVasModel class], @"job_push_vas_list" : [JobVasModel class], @"job_refresh_vas_list" : [JobVasModel class]};
}

@end

@implementation LatestVerifyInfo
@end

@implementation VipPackageEntryModel

- (NSDictionary *)objectClassInArray{
    return @{@"package_item_arr" : [PackageItem class]};
}

@end

@implementation PackageItem
@end

@implementation vipRefreshPrivilege
@end

@implementation vipPushPrivilege
@end

@implementation vipTopPrivilege
@end

@implementation vipResumePrivilege
@end

@implementation CityVipInfo
@end

@implementation VipApplyJobNumObj
@end

@implementation AccountVipInfo

- (NSDictionary *)objectClassInArray{
    return @{@"city_vip_info" : [CityVipInfo class]};
}

- (BOOL)isNullWithGeneralVip{
    if (!self.national_general_vip_top_privilege && !self.national_general_vip_refresh_privilege && !self.national_general_vip_push_privilege) {
        return YES;
    }
    
    if (!self.national_general_vip_push_privilege.all_push_num.integerValue && !self.national_general_vip_refresh_privilege.all_refresh_num.integerValue && !self.national_general_vip_top_privilege.all_top_num.integerValue) {
        return YES;
    }
    return NO;
}

@end

@implementation VipJobListModel

- (NSString *)getStatusStr{
    switch (self.job_status.integerValue) {
        case 1:
            return @"待审核";
        case 2:
            return @"已发布";
        case 3:
            return @"已结束";
        default:
            break;
    }
    return @"";
}

@end

@implementation ApplyJobListStu
@end

@implementation VipApplyPackage
@end

@implementation ResumeNumPackage
@end

@implementation ArrangedAgentVas
@end

@implementation ArrangedAgentVasInfo

- (NSDictionary *)objectClassInArray{
    return @{@"arranged_agent_vas_list" : [ArrangedAgentVas class]};
}

@end
