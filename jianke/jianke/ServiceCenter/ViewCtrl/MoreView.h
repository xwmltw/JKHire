//
//  MoreView.h
//  JKHire
//
//  Created by fire on 16/11/2.
//  Copyright © 2016年 xianshijian. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MoreViewDelegate <NSObject>

- (void)moreViewOnTouch;

@end

@interface MoreView : UIView

@property (nonatomic, assign) CGFloat maxVisibleCol;    /*!< 内容高度 */
@property (nonatomic, weak) id<MoreViewDelegate> delegate;
@property (nonatomic, weak) UICollectionView *collectView;

- (void)showMoreView;
- (void)hidesMoreView;

@end
