//
//  XZDropView.h
//  lottery
//
//  Created by yanqb on 2017/3/17.
//  Copyright © 2017年 xsj. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^xzDropViewBlock)(NSInteger selectedIndex);

@interface XZDropView : UIView

@property (nonatomic, strong) NSArray *dataSource;
@property (nonatomic, assign) CGRect showRect;
@property (nonatomic, strong) UIColor *dropBackgroundColor;
@property (nonatomic, strong) UIColor *titleColor;


+ (void)showDropViewWithItems:(NSArray <NSString *>*)items block:(xzDropViewBlock)block;
+ (void)showDropViewAtRect:(CGRect)rect withItems:(NSArray <NSString *>*)items block:(xzDropViewBlock)block;
- (void)shwoWithBlock:(xzDropViewBlock)block;

@end
