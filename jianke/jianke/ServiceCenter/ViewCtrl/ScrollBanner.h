//
//  ScrollBanner.h
//  JKHire
//
//  Created by fire on 16/11/2.
//  Copyright © 2016年 xianshijian. All rights reserved.
//

#import <UIKit/UIKit.h>

#define topScrollViewHeight 42.0f
#define btnWith 87.0f
#define XZScrollViewBtnTag 100

@class ScrollBanner;
@protocol ScrollBannerDelegate <NSObject>

- (void)moreBtnOnClickWithButton:(UIButton *)sender;
- (void)scrollBanner:(ScrollBanner *)banner selectedIndex:(NSInteger)index;

@end

@interface ScrollBanner : UIView

@property (nonatomic, weak) id<ScrollBannerDelegate> delegate;
- (instancetype)initWithMenuModelArr:(NSArray *)menuModelArr;
- (void)setBtnStatus:(BOOL)selected;
- (void)reloadData;
- (void)setPositionWithOffsetX:(NSInteger)index;

@end
