//
//  HireOffJob_VC.h
//  JKHire
//
//  Created by yanqb on 2017/1/10.
//  Copyright © 2017年 xianshijian. All rights reserved.
//

#import "BottomViewControllerBase.h"
@class HireOffJob_VC;
@protocol HireOffJob_VCDelegate <NSObject>

- (void)hireOffJob:(HireOffJob_VC *)viewCtrl scrollViewOffset:(CGPoint)offset;
//- (void)closeJobWithHireOffJob:(HireOffJob_VC *)viewCtrl;


@end

@interface HireOffJob_VC : BottomViewControllerBase

@property (nonatomic, weak) id<HireOffJob_VCDelegate> delegate;

- (void)setTableViewTop;

@end
