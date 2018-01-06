//
//  WaitPassJob_VC.h
//  JKHire
//
//  Created by yanqb on 2017/1/10.
//  Copyright © 2017年 xianshijian. All rights reserved.
//

#import "BottomViewControllerBase.h"
#import "MyEnum.h"
@class WaitPassJob_VC;
@protocol WaitPassJob_VCDelegate <NSObject>

- (void)waitPassJob:(WaitPassJob_VC *)viewCtrl scrollViewOffset:(CGPoint)offset;
- (void)waitPassJob:(WaitPassJob_VC *)viewCtrl actionType:(VCActionType)actionType;
//- (void)jobStatueOnChangeWithWaitPassJob:(WaitPassJob_VC *)viewCtrl;

@end

@interface WaitPassJob_VC : BottomViewControllerBase

@property (nonatomic, weak) id<WaitPassJob_VCDelegate> delegate;

- (void)setTableViewTop;

@end
