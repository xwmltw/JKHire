//
//  VipPacket_Cell2.h
//  JKHire
//
//  Created by yanqb on 2017/5/9.
//  Copyright © 2017年 xianshijian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyEnum.h"

@class VipPackageEntryModel;
@interface VipPacket_Cell2 : UITableViewCell

@property (nonatomic, strong) VipPackageEntryModel *model;
- (void)setCityModel:(id)cityModel;

@end
