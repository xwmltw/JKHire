//
//  Regist_VC.h
//  jianke
//
//  Created by xiaomk on 15/9/18.
//  Copyright (c) 2015年 xianshijian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WDViewControllerBase.h"

@interface Regist_VC : WDViewControllerBase

@property (nonatomic, assign) BOOL isFromNewFrature;    //来至首屏的注册
@property (nonatomic, assign) BOOL isToRegister;        //来至个人中心的 注册
@property (nonatomic, copy) MKBlock block;

@end
