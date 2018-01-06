//
//  EpProfile_VC.h
//  JKHire
//
//  Created by fire on 16/11/5.
//  Copyright © 2016年 xianshijian. All rights reserved.
//

#import "WDViewControllerBase.h"

@interface EpProfile_VC : WDViewControllerBase

@property (nonatomic, assign) BOOL isLookForJK; /*!< 是否是兼客视角 */
@property (nonatomic, strong) EPModel *epModel;
@property (nonatomic, copy) NSNumber *entId;

@end
