//
//  MyInfoCell_MoneyBag.h
//  JKHire
//
//  Created by yanqb on 2017/3/30.
//  Copyright © 2017年 xianshijian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyEnum.h"

@class MyInfoCell_MoneyBag;
@protocol MyInfoCell_MoneyBagDelegat <NSObject>

- (void)myinfoCell_MonyeBag:(MyInfoCell_MoneyBag *)cell actionType:(BtnOnClickActionType)actionType;

@end

@interface MyInfoCell_MoneyBag : UITableViewCell

- (void)setEpModel:(id)epModel;
@property (nonatomic, weak) id<MyInfoCell_MoneyBagDelegat> delegate;

@end
