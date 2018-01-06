//
//  PersonSmcHeaderView.h
//  JKHire
//
//  Created by fire on 16/10/19.
//  Copyright © 2016年 xianshijian. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, PersonSmcBtnActionType) {
    PersonSmcBtnActionType_titleOnClick,
    PersonSmcBtnActionType_inviteOnClick,
    PersonSmcBtnActionType_sliderLeftBtnOnClick,
    PersonSmcBtnActionType_sliderRightBtnOnClick
};

@protocol PersonSmcHeaderViewDelegate <NSObject>

- (void)btnOnClickWithActionType:(PersonSmcBtnActionType)actionType;

@end

@interface PersonSmcHeaderView : UIView

@property (nonatomic, weak) id<PersonSmcHeaderViewDelegate> delegate;

- (void)setModel:(id)model;
- (void)setBottomLineHorizoneOffset:(CGFloat)offset;
- (void)makeBtnSelectedStatus:(PersonSmcBtnActionType)actionType;

@end
