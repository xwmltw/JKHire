//
//  MyTalentToolBar.h
//  JKHire
//
//  Created by 徐智 on 2017/6/2.
//  Copyright © 2017年 xianshijian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyEnum.h"

@class MyTalentToolBar;
@protocol MyTalentToolBarDelegate <NSObject>

- (void)MyTalentToolBar:(MyTalentToolBar *)toolBar actiontype:(BtnOnClickActionType)actionType;

@end

@interface MyTalentToolBar : UIView

@property (nonatomic, weak) id<MyTalentToolBarDelegate> delegate;

- (void)setContactedNum:(NSNumber *)contactedNum;
- (void)setOffsetOfLineWithIndex:(NSInteger)index;
@end
