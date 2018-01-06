//
//  JobMsgHeaderView.h
//  JKHire
//
//  Created by yanqb on 2017/1/10.
//  Copyright © 2017年 xianshijian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyEnum.h"

@class JobMsgHeaderView;
@protocol JobMsgHeaderViewDelegate <NSObject>

- (void)jobMsgHeaderView:(JobMsgHeaderView *)headerView actionType:(BtnOnClickActionType)actionType;

@end

@interface JobMsgHeaderView : UIView

@property (nonatomic, weak) id<JobMsgHeaderViewDelegate> delegate;

- (void)updateBtnStatusAtIndex:(NSInteger)index;

- (void)reload;

//- (void)setModel:(id)model;

//- (void)resetVipContainView;

@end
