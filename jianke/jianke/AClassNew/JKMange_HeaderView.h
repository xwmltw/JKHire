//
//  JKMange_HeaderView.h
//  JKHire
//
//  Created by yanqb on 2017/4/7.
//  Copyright © 2017年 xianshijian. All rights reserved.
//

#import <UIKit/UIKit.h>

@class JKMange_HeaderView;
@protocol JKMange_HeaderViewDelegate <NSObject>

- (void)JKMange_HeaderView:(JKMange_HeaderView *)cell;

@end

@interface JKMange_HeaderView : UIView

@property(nonatomic, weak) id <JKMange_HeaderViewDelegate> delegate;
- (void)setData:(id)model;

@end
