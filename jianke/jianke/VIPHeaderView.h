//
//  VIPHeaderView.h
//  JKHire
//
//  Created by yanqb on 2017/5/9.
//  Copyright © 2017年 xianshijian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ImgTextButton.h"

@class VIPHeaderView;
@protocol VIPHeaderViewDelegate <NSObject>

- (void)VIPHeaderView:(VIPHeaderView *)headerView index:(NSInteger)index;

@end

@interface VIPHeaderView : UIView

- (instancetype)initWithVipList:(NSArray *)vipList;
@property (nonatomic, weak) id<VIPHeaderViewDelegate> delegate;

@end

@interface VIPTitleView : UIView

@property (nonatomic, copy) NSString *identifier;
@property (nonatomic, strong, readonly) ImgTextButton *button;
@property (nonatomic, copy) MKBlock block;

@end
