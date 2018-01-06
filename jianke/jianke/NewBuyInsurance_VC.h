//
//  NewBuyInsurance_VC.h
//  JKHire
//
//  Created by yanqb on 2016/11/17.
//  Copyright © 2016年 xianshijian. All rights reserved.
//

#import "BottomViewControllerBase.h"

@interface NewBuyInsurance_VC : BottomViewControllerBase

@property (nonatomic, copy) NSString *jobId;
@property (nonatomic, assign) BOOL isBuyForJK;

@property (nonatomic, weak) UIViewController *popVC;
@property (nonatomic, copy) MKBlock block;

@end
