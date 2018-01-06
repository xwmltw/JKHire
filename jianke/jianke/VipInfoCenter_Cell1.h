//
//  VipInfoCenter_Cell1.h
//  JKHire
//
//  Created by yanqb on 2017/5/10.
//  Copyright © 2017年 xianshijian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyEnum.h"

@class VipInfoCenter_Cell1, CityVipInfo;;
@protocol VipInfoCenter_Cell1Delegate <NSObject>

- (void)vipInfoCenter_Cell1:(VipInfoCenter_Cell1 *)cell actionType:(BtnOnClickActionType)actionType model:(CityVipInfo *)model;

@end

@interface VipInfoCenter_Cell1 : UITableViewCell

@property (nonatomic, weak) id<VipInfoCenter_Cell1Delegate> delegate;
@property (nonatomic, strong) CityVipInfo *model;

@end
