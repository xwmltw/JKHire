//
//  BuyJobNumCell_City.m
//  JKHire
//
//  Created by yanqb on 2017/2/8.
//  Copyright © 2017年 xianshijian. All rights reserved.
//

#import "BuyJobNumCell_City.h"
#import "MyEnum.h"
#import "WDConst.h"
#import "CityModel.h"

@interface BuyJobNumCell_City ()

@property (weak, nonatomic) IBOutlet UILabel *labCity;
@property (weak, nonatomic) IBOutlet UIImageView *imgIcon;
@property (weak, nonatomic) IBOutlet UILabel *labLeftTitle;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *layoutLabCityRight;

@end

@implementation BuyJobNumCell_City

- (void)awakeFromNib {
    [super awakeFromNib];
    self.backgroundColor = [UIColor XSJColor_newGray];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)setCityModel:(CityModel *)cityModel paramModel:(RechargeRecruitParam *)model{
    self.imgIcon.hidden = NO;
    self.layoutLabCityRight.constant = 32;
    self.imgIcon.image = [UIImage imageNamed:@"jiantou_down_icon_16"];
    switch (_cellType) {
        case BuyJobNumCelltype_city:{
            self.imgIcon.image = [UIImage imageNamed:@"job_icon_push"];
            self.labLeftTitle.text = @"招聘城市";
            self.labCity.text = (cityModel.name.length) ? cityModel.name : nil;
            if (self.actionType == BuyJobNumActionType_ForRenew) {
                self.imgIcon.hidden = YES;
                self.layoutLabCityRight.constant = 16;
            }
        }
            break;
        case BuyJobNumCelltype_jobNum:{
            self.labLeftTitle.text = @"在招岗位数量";
            if (model.recruit_job_num.integerValue) {
                self.labCity.text = [NSString stringWithFormat:@"%@个", model.recruit_job_num.description];
            }else{
                self.labCity.text = nil;
            }
            if (self.actionType == BuyJobNumActionType_ForRenew) {
                self.imgIcon.hidden = YES;
                self.layoutLabCityRight.constant = 16;
            }
        }
            break;
        case BuyJobNumCelltype_jobTimeLong:{
            self.labLeftTitle.text = @"招聘时长";
            if (model.recruit_keep_months.integerValue) {
                self.labCity.text = [NSString stringWithFormat:@"%@个月", model.recruit_keep_months.description];
            }else{
                self.labCity.text = nil;
            }
        }
            break;
            
        default:
            break;
    }
}

- (void)setModel:(CityModel*)model isCanModify:(BOOL)isCanModify{
    
    self.labCity.text = (model.name.length) ? model.name : @"选择招聘城市";
    self.imgIcon.hidden = !isCanModify;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
