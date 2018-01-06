//
//  PayJobInfoModel.m
//  jianke
//
//  Created by xiaomk on 16/7/12.
//  Copyright © 2016年 xianshijian. All rights reserved.
//

#import "PayJobInfoModel.h"
#import "ParamModel.h"
#import "BuyInsuranceModel.h"

@implementation PayJobInfoModel

- (NSDictionary *)objectClassInArray{
    return @{
             @"payment_list" : [PaymentPM class],
             @"add_payment_list" : [AddPaymentModel class],
             @"insurance_policy_list" : [InsuranceDataListModel class]
             };
}
@end

@implementation AddPaymentModel
@end
