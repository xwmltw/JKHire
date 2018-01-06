//
//  PushOrder_VC.h
//  JKHire
//
//  Created by yanqb on 2016/12/3.
//  Copyright © 2016年 xianshijian. All rights reserved.
//

#import "BottomViewControllerBase.h"

@interface PushOrder_VC : BottomViewControllerBase

@property (nonatomic, copy) NSString *jobId;
//@property (nonatomic, weak) UIViewController *popToVC;
@property (nonatomic, assign) BOOL isShowHistory;  /*!< 是否显示推广记录 */
@property (nonatomic, assign) BOOL jumpBackOpen;  /*!< 非正常返回开关 */
//@property (nonatomic, copy) MKBlock block;
@property (nonatomic, assign) BOOL isFromJobManage; /*!< 是否来自岗位管理 */

@end
