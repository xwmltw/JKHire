//
//  EPModel.m
//  jianke
//
//  Created by fire on 15/9/18
//  Copyright (c) 2015年 xianshijian. All rights reserved.
//

#import "EPModel.h"

@implementation EPModel
MJCodingImplementation

- (NSString *)getImgOfAccountVipType{
    switch (self.account_vip_type.integerValue) {
        case 0:{
            return @"pay_vip_icon";
        }
        case 1:{
            return @"v320_vip_zuanshi";
        }
        case 2:{
            return @"v320_vip_bojin";
        }
        case 3:{
            return @"v320_vip_gold";
        }
        case 4:{
            return @"v320_vip_baiying";
        }
        case 5:{
            return @"v320_vip_qingtong";
        }
        default:
            break;
    }
    return @"";
}

@end
