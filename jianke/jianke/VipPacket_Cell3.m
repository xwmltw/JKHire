//
//  VipPacket_Cell3.m
//  JKHire
//
//  Created by 徐智 on 2017/5/16.
//  Copyright © 2017年 xianshijian. All rights reserved.
//

#import "VipPacket_Cell3.h"

@interface VipPacket_Cell3 ()

@property (weak, nonatomic) IBOutlet UILabel *labTitke;
@property (weak, nonatomic) IBOutlet UILabel *labSubTitle;

@end

@implementation VipPacket_Cell3

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)setCellType:(VipPacketCellType)cellType{
    _cellType = cellType;
    self.labSubTitle.hidden = YES;
    switch (cellType) {
        case VipPacketCellType_chooseCityWithData:{
            self.labSubTitle.hidden = NO;
        }
            break;
        case VipPacketCellType_guize:{
            self.labTitke.text = @"了解VIP套餐适用规则";
        }
            break;
        default:
            break;
    }
    
}

- (void)setModel:(CityModel *)cityModel{
    switch (self.cellType) {
        case VipPacketCellType_chooseCityWithData:{
            self.labTitke.text = [NSString stringWithFormat:@"当前服务城市:%@", cityModel.name];
        }
            break;
            default:
            break;
    }
}

- (void)setSaleCode:(NSNumber *)saleCode{
    switch (_cellType) {
        case VipPacketCellType_qrcode:{
            self.labTitke.text = (saleCode) ? [NSString stringWithFormat:@"推荐码：%@", saleCode.description] : @"填写推荐码(选填)";
        }
            break;
            
        default:
            break;
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
