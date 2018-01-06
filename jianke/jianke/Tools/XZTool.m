//
//  XZTool.m
//  JKHire
//
//  Created by fire on 16/11/4.
//  Copyright © 2016年 xianshijian. All rights reserved.
//

#import "XZTool.h"
#import "UITabBar+MKExtension.h"
#import "PostJob_VC.h"
#import "JobModel.h"

@implementation XZTool
Impl_SharedInstance(XZTool);

- (void)showRedPointWithVCInTabBar:(UIViewController *)viewCtrl{
    [self checkExactWithVC:viewCtrl block:^(NSUInteger index) {
        [viewCtrl.tabBarController.tabBar showSmallBadgeOnItemIndex:(int)index];
    }];
}

- (void)hidesRedPointWithVCInTabBar:(UIViewController *)viewCtrl{
    [self checkExactWithVC:viewCtrl block:^(NSUInteger index) {
        [viewCtrl.tabBarController.tabBar hideSmallBadgeOnItemIndex:(int)index];
    }];
}

- (void)checkExactWithVC:(UIViewController *)viewCtrl block:(XZUIntegerBlock)block{
    NSUInteger index = [viewCtrl.tabBarController.viewControllers indexOfObject:viewCtrl];
    if (index != NSNotFound) {
        block(index);
    }
}

#pragma mark - 岗位操作
- (void)editJobWith:(JobModel *)jobModel isEditAction:(BOOL)isEdit block:(MKBlock)block{
    PostJob_VC *viewCtrl = [[PostJob_VC alloc] init];
    viewCtrl.jobId = jobModel.job_id;
    viewCtrl.isUpload = YES;
    viewCtrl.postJobType = PostJobType_common;
    viewCtrl.myPostJobModel = [NSKeyedUnarchiver unarchiveObjectWithData:[NSKeyedArchiver archivedDataWithRootObject:jobModel]];
    
    if (isEdit) {
        viewCtrl.isEditAction = YES;
        viewCtrl.jobId = jobModel.job_id;
    }
    viewCtrl.hidesBottomBarWhenPushed = YES;
    MKBlockExec(block, viewCtrl);
}

- (void)fastPostModel:(JobModel *)jobModel block:(MKBlock)block{
    PostJob_VC *viewCtrl = [[PostJob_VC alloc] init];
    viewCtrl.postJobType = PostJobType_common;
    viewCtrl.myPostJobModel = [NSKeyedUnarchiver unarchiveObjectWithData:[NSKeyedArchiver archivedDataWithRootObject:jobModel]];
    viewCtrl.hidesBottomBarWhenPushed = YES;
    MKBlockExec(block, viewCtrl);
}

@end
