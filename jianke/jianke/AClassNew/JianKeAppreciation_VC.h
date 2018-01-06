//
//  JianKeAppreciation_VC.h
//  jianke
//
//  Created by fire on 16/9/23.
//  Copyright © 2016年 xianshijian. All rights reserved.
//

#import "BottomViewControllerBase.h"
#import "MyEnum.h"

@class JobModel;
@interface JianKeAppreciation_VC : BottomViewControllerBase

@property (nonatomic, assign) AppreciationType serviceType;
@property (nonatomic, copy) NSString *jobId;
@property (nonatomic, weak) UIViewController *popToVC;

@end
