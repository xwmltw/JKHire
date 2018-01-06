//
//  CitySelectController.h
//  jianke
//
//  Created by fire on 15/9/11.
//  Copyright (c) 2015年 xianshijian. All rights reserved.
//  城市选择控制器

#import <UIKit/UIKit.h>
#import "WDViewControllerBase.h"

typedef NS_ENUM(NSInteger, CitySelectControllerShowType) {
    CitySelectControllerShowType_default,   //默认呈现方式（首页城市选择页面）
    CitySelectControllerShowType_filterVip, //筛选出VIP服务城市的页面
};

@interface CitySelectController : WDViewControllerBase

@property (nonatomic, copy) MKBlock didSelectCompleteBlock;
@property (nonatomic, assign, getter=isShowSubArea) BOOL showSubArea;
@property (nonatomic, assign, getter=isShowParentArea) BOOL showParentArea;

//added by kizy from v1.1.5 与showParentArea功能类似，但是应用场景不太一样-发布岗位用
@property (nonatomic, assign) BOOL showCityWide;

@property (nonatomic, assign) BOOL isPushAction;
@property (nonatomic, assign) CitySelectControllerShowType showType;

@end



/**
 Usage
 CitySelectController *vc = [[CitySelectController alloc] init];
 vc.showSubArea = YES;
 vc.showParentArea = NO;
 vc.didSelectCompleteBlock = ^(CityModel *area){
 

 };
 MainNavigation_VC *nav = [[MainNavigation_VC alloc] initWithRootViewController:vc];
 [self.postJobCellModel.tableViewController presentViewController:nav animated:YES completion:nil];
 */
