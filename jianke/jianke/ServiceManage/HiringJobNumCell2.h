//
//  HiringJobNumCell2.h
//  JKHire
//
//  Created by yanqb on 2017/4/1.
//  Copyright © 2017年 xianshijian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyEnum.h"

@class HiringJobNumCell2;
@protocol HiringJobNumCell2Delegate <NSObject>

- (void)hiringJobNumCell2:(HiringJobNumCell2 *)cell actionType:(BtnOnClickActionType)actionType;

@end

@interface HiringJobNumCell2 : UITableViewCell

@property (nonatomic, weak) id<HiringJobNumCell2Delegate> delegate;

@end
