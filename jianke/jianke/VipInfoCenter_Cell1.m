//
//  VipInfoCenter_Cell1.m
//  JKHire
//
//  Created by yanqb on 2017/5/10.
//  Copyright © 2017年 xianshijian. All rights reserved.
//

#import "VipInfoCenter_Cell1.h"
#import "ResponseInfo.h"
#import "WDConst.h"

@interface VipInfoCenter_Cell1 ()

@property (weak, nonatomic) IBOutlet UIView *viewMiddelContain;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *layoutViewMiddleHeight;
@property (weak, nonatomic) IBOutlet UILabel *labVipName;
@property (weak, nonatomic) IBOutlet UILabel *labVipDate;
@property (weak, nonatomic) IBOutlet UILabel *labVipCity;
@property (weak, nonatomic) IBOutlet UILabel *labLeftApplyNum;
@property (weak, nonatomic) IBOutlet UILabel *labUsedApplyNum;
@property (weak, nonatomic) IBOutlet UIButton *btnBuyApplyNum;
@property (weak, nonatomic) IBOutlet UIButton *btnUsedApplyNum;
@property (weak, nonatomic) IBOutlet UILabel *labApplyNum;
@property (weak, nonatomic) IBOutlet UILabel *labRecuitJobNum;

@property (weak, nonatomic) IBOutlet UILabel *labLeft1;
@property (weak, nonatomic) IBOutlet UILabel *labLeft2;
@property (weak, nonatomic) IBOutlet UILabel *labLeft3;
@property (weak, nonatomic) IBOutlet UILabel *labLeft4;
@property (weak, nonatomic) IBOutlet UILabel *labLeft5;

@property (nonatomic, copy) NSArray<UILabel *> *labArr;

@end

@implementation VipInfoCenter_Cell1

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.clipsToBounds = YES;
    self.btnUsedApplyNum.tag = BtnOnClickActionType_usedApplyNum;
    [self.btnUsedApplyNum addTarget:self action:@selector(btnOnClick:) forControlEvents:UIControlEventTouchUpInside];
    self.btnBuyApplyNum.tag = BtnOnClickActionType_buyApplyNum;
    [self.btnBuyApplyNum addTarget:self action:@selector(btnOnClick:) forControlEvents:UIControlEventTouchUpInside];
    self.labArr = @[self.labLeft1, self.labLeft2, self.labLeft3, self.labLeft4, self.labLeft5];
}

- (void)setModel:(CityVipInfo *)model{
    _model = model;
    
    self.btnUsedApplyNum.userInteractionEnabled = YES;
    self.labVipName.text = [NSString stringWithFormat:@"VIP套餐：%@", model.vip_package_name];
    self.labVipDate.text = [NSString stringWithFormat:@"到期时间：%@", [DateHelper getDateFromTimeNumber:model.vip_dead_time withFormat:@"yyyy-MM-dd"]];
    self.labVipCity.text = [NSString stringWithFormat:@"服务城市：%@", model.vip_city_name];
    
    self.labLeftApplyNum.text = [NSString stringWithFormat:@"%ld", model.vip_apply_job_num_obj.left_apply_job_num.integerValue];
    if (!model.vip_apply_job_num_obj.used_apply_job_num.integerValue) {
        self.btnUsedApplyNum.userInteractionEnabled = NO;
        self.labUsedApplyNum.text = [NSString stringWithFormat:@"%ld", model.vip_apply_job_num_obj.used_apply_job_num.integerValue];
    }else{
        NSAttributedString *attStr = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%ld", model.vip_apply_job_num_obj.used_apply_job_num.integerValue] attributes:@{NSUnderlineStyleAttributeName: @(NSUnderlineStyleSingle)}];
        self.labUsedApplyNum.attributedText = attStr;
    }
    
    self.viewMiddelContain.clipsToBounds = YES;
    if (model.vip_identity_privilege_desc_arr.count) {
        [self.labArr enumerateObjectsUsingBlock:^(UILabel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if (idx < model.vip_identity_privilege_desc_arr.count) {
                NSString *str = [model.vip_identity_privilege_desc_arr objectAtIndex:idx];
                obj.text = str;
                self.layoutViewMiddleHeight.constant = 33 * (idx + 1);
            }
        }];
    }else{
        self.layoutViewMiddleHeight.constant = 0;
    }
    self.labRecuitJobNum.text = [NSString stringWithFormat:@"%ld个", model.recruit_job_num.integerValue];
    self.labApplyNum.text = [NSString stringWithFormat:@"%ld个", model.vip_apply_job_num_obj.all_apply_job_num.integerValue];
    if (!model.vip_apply_job_num_obj || !model.vip_apply_job_num_obj.all_apply_job_num.integerValue) {
        model.cellHeight = 115 + self.layoutViewMiddleHeight.constant + 33 + 16 + 16;
    }else{
        model.cellHeight = 115 + self.layoutViewMiddleHeight.constant + 66 + 126;
    }
    
}

- (void)btnOnClick:(UIButton *)sender{
    if ([self.delegate respondsToSelector:@selector(vipInfoCenter_Cell1:actionType:model:)]) {
        [self.delegate vipInfoCenter_Cell1:self actionType:sender.tag model:self.model];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
