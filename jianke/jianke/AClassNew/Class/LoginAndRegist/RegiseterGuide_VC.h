//
//  RegiseterGuide_VC.h
//  JKHire
//
//  Created by yanqb on 2016/12/20.
//  Copyright © 2016年 xianshijian. All rights reserved.
//

#import "BottomViewControllerBase.h"

@interface RegiseterGuide_VC : BottomViewControllerBase

@property (nonatomic, assign) BOOL isNotRergistAction;  /*!< 是否不是来自注册页面 */
@property (nonatomic, copy) MKBlock block;

@end
