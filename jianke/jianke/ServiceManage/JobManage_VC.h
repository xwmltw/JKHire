//
//  JobManage_VC.h
//  JKHire
//
//  Created by yanqb on 2016/12/17.
//  Copyright © 2016年 xianshijian. All rights reserved.
//

#import "BottomViewControllerBase.h"
#import "MyEnum.h"
@class JobManage_VC;
@protocol JobManage_VCDelegate <NSObject>

- (void)JobManage_VC:(JobManage_VC *)viewCtrl scrollViewOffset:(CGPoint)offset;
- (void)jobManage_VC:(JobManage_VC *)viewCtrl actionType:(VCActionType)actionType;

@end

@interface JobManage_VC : BottomViewControllerBase

@property (nonatomic, weak) id<JobManage_VCDelegate> delegate;

- (void)setTableViewTop;

@end
