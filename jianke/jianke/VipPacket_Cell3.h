//
//  VipPacket_Cell3.h
//  JKHire
//
//  Created by 徐智 on 2017/5/16.
//  Copyright © 2017年 xianshijian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyEnum.h"
#import "CityModel.h"

@interface VipPacket_Cell3 : UITableViewCell

@property (nonatomic, assign) VipPacketCellType cellType;

- (void)setModel:(CityModel *)cityModel;
- (void)setSaleCode:(NSNumber *)saleCode;

@end
