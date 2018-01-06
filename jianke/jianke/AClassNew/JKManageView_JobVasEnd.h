//
//  JKManageView_JobVasEnd.h
//  JKHire
//
//  Created by yanqb on 2017/4/7.
//  Copyright © 2017年 xianshijian. All rights reserved.
//

#import <UIKit/UIKit.h>

@class JKManageView_JobVasEnd;

@protocol JKManageView_JobVasEndDelegate <NSObject>

- (void)JKManageView_JobVasEnd:(JKManageView_JobVasEnd *)view;

@end

@interface JKManageView_JobVasEnd : UIView

@property (nonatomic, weak) id<JKManageView_JobVasEndDelegate> delegate;

- (void)setModel:(id)model;

@end
