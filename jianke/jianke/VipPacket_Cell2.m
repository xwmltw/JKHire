//
//  VipPacket_Cell2.m
//  JKHire
//
//  Created by yanqb on 2017/5/9.
//  Copyright © 2017年 xianshijian. All rights reserved.
//

#import "VipPacket_Cell2.h"
#import "ResponseInfo.h"
#import "CityModel.h"

@interface VipPacket_Cell2 ()

@property (weak, nonatomic) IBOutlet UILabel *labSubTitle;
@property (weak, nonatomic) IBOutlet UILabel *labCityName;
@property (weak, nonatomic) IBOutlet UILabel *labPromotion;
@property (weak, nonatomic) IBOutlet UILabel *labOffPrice;


@end

@implementation VipPacket_Cell2

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)setModel:(VipPackageEntryModel *)model{
    _model = model;
    self.labSubTitle.text = [NSString stringWithFormat:@"%ld个月", model.vip_keep_months.integerValue];
//    self.
    NSString *allStr = [NSString stringWithFormat:@"¥%.2f", model.total_price.integerValue * 0.01];
    allStr = [allStr stringByReplacingOccurrencesOfString:@".00" withString:@""];
    self.labPromotion.text = allStr;
    NSString *str = [NSString stringWithFormat:@"¥%.2f", model.promotion_price.integerValue * 0.01];
    str = [str stringByReplacingOccurrencesOfString:@".00" withString:@""];
    self.labOffPrice.text = str;
}

- (void)setCityModel:(CityModel *)cityModel{
    self.labCityName.text = cityModel.name;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
