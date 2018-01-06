//
//  VipInfoCenter_CellNil.m
//  JKHire
//
//  Created by yanqb on 2017/8/8.
//  Copyright © 2017年 xianshijian. All rights reserved.
//

#import "VipInfoCenter_CellNil.h"

@implementation VipInfoCenter_CellNil

- (void)setModel:(AccountVipInfo *)model{
    
    model.cellHeight = 155.0f;
    
    self.labNum1.text = model.national_general_vip_refresh_privilege.all_refresh_num ? model.national_general_vip_refresh_privilege.all_refresh_num.description : @"0";
    self.labNum2.text = model.national_general_vip_refresh_privilege.left_can_refresh_num ? model.national_general_vip_refresh_privilege.left_can_refresh_num.description : @"0";
    self.labNum3.text = model.national_general_vip_refresh_privilege.soon_expired_refresh_num ? model.national_general_vip_refresh_privilege.soon_expired_refresh_num.description : @"0";
    
    self.labDate1.text = model.national_general_vip_top_privilege.all_top_num ? model.national_general_vip_top_privilege.all_top_num.description : @"0";
    self.labDate2.text = model.national_general_vip_top_privilege.left_can_top_num ? model.national_general_vip_top_privilege.left_can_top_num.description : @"0";
    self.labDate3.text = model.national_general_vip_top_privilege.soon_expired_top_num ? model.national_general_vip_top_privilege.soon_expired_top_num.description : @"0";
    
    self.labRen1.text = model.national_general_vip_push_privilege.all_push_num ? model.national_general_vip_push_privilege.all_push_num.description : @"0";
    self.labRen2.text = model.national_general_vip_push_privilege.left_can_push_num ? model.national_general_vip_push_privilege.left_can_push_num.description : @"0";
    self.labRen3.text = model.national_general_vip_push_privilege.soon_expired_push_num ? model.national_general_vip_push_privilege.soon_expired_push_num.description : @"0";
}

@end
