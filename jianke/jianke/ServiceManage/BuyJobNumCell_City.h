//
//  BuyJobNumCell_City.h
//  JKHire
//
//  Created by yanqb on 2017/2/8.
//  Copyright © 2017年 xianshijian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyEnum.h"

@class CityModel;
@interface BuyJobNumCell_City : UITableViewCell

@property (nonatomic, assign) BuyJobNumCelltype cellType;
@property (nonatomic, assign) BuyJobNumActionType actionType;

- (void)setCityModel:(CityModel *)cityModel paramModel:(id)model;

@end
