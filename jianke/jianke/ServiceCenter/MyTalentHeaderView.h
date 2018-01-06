//
//  MyTalentHeaderView.h
//  JKHire
//
//  Created by 徐智 on 2017/6/2.
//  Copyright © 2017年 xianshijian. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MyTalentHeaderView;
@protocol MyTalentHeaderViewDelegate <NSObject>

- (void)MyTalentHeaderView:(MyTalentHeaderView *)headerView;

@end

@interface MyTalentHeaderView : UIView

@property (nonatomic, weak) id<MyTalentHeaderViewDelegate> delegate;
- (void)setLeftNum:(NSNumber *)leftNum;

@end
