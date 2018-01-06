//
//  VipInfoCenter_Cell.m
//  JKHire
//
//  Created by yanqb on 2017/7/31.
//  Copyright © 2017年 xianshijian. All rights reserved.
//

#import "VipInfoCenter_Cell.h"
#import "WDConst.h"

@implementation VipInfoCenter_Cell

- (void)awakeFromNib{
    [super awakeFromNib];
    self.layer.masksToBounds = YES;
    self.layer.borderWidth = 1.0f;
    self.layer.borderColor = MKCOLOR_RGB(233, 233, 235).CGColor;
    
    
    
}
- (void)setModel:(AccountVipInfo *)model{
    
    model.cellHeight = 195.0f;
    
    self.labNum1.text = model.national_general_vip_refresh_privilege.all_refresh_num ? model.national_general_vip_refresh_privilege.all_refresh_num.description : @"0";
    self.labNum2.text = model.national_general_vip_refresh_privilege.left_can_refresh_num ? model.national_general_vip_refresh_privilege.left_can_refresh_num.description : @"0";
    self.labNum3.text = model.national_general_vip_refresh_privilege.soon_expired_refresh_num ? model.national_general_vip_refresh_privilege.soon_expired_refresh_num.description : @"0";
    
    self.labDate1.text = model.national_general_vip_top_privilege.all_top_num ? model.national_general_vip_top_privilege.all_top_num.description : @"0";
    self.labDate2.text = model.national_general_vip_top_privilege.left_can_top_num ? model.national_general_vip_top_privilege.left_can_top_num.description : @"0";
    self.labDate3.text = model.national_general_vip_top_privilege.soon_expired_top_num ? model.national_general_vip_top_privilege.soon_expired_top_num.description : @"0";
    
    self.labRen1.text = model.national_general_vip_push_privilege.all_push_num ? model.national_general_vip_push_privilege.all_push_num.description : @"0";
    self.labRen2.text = model.national_general_vip_push_privilege.left_can_push_num ? model.national_general_vip_push_privilege.left_can_push_num.description : @"0";
    self.labRen3.text = model.national_general_vip_push_privilege.soon_expired_push_num ? model.national_general_vip_push_privilege.soon_expired_push_num.description : @"0";
   
        self.labFen1.text = model.national_general_vip_resume_num_privilege.all_resume_num ? model.national_general_vip_resume_num_privilege.all_resume_num.description : @"0";
        self.labFen2.text = model.national_general_vip_resume_num_privilege.left_resume_num ? model.national_general_vip_resume_num_privilege.left_resume_num.description : @"0";
        self.labFen3.text = model.national_general_vip_resume_num_privilege.soon_expired_resume_num ? model.national_general_vip_resume_num_privilege.soon_expired_resume_num.description : @"0";
    
    
}

@end
