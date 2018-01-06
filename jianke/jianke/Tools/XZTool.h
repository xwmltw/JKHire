//
//  XZTool.h
//  JKHire
//
//  Created by fire on 16/11/4.
//  Copyright © 2016年 xianshijian. All rights reserved.
//

#import <Foundation/Foundation.h>

@class JobModel;

typedef void (^XZUIntegerBlock)(NSUInteger result);

@interface XZTool : NSObject

+ (instancetype)sharedInstance;

- (void)showRedPointWithVCInTabBar:(UIViewController *)viewCtrl;
- (void)hidesRedPointWithVCInTabBar:(UIViewController *)viewCtrl;

//编辑/上架失败跳转编辑岗位操作
- (void)editJobWith:(JobModel *)jobModel isEditAction:(BOOL)isEdit block:(MKBlock)block;

//快捷发布
- (void)fastPostModel:(JobModel *)jobModel block:(MKBlock)block;
@end
