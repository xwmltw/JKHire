//
//  EditEmployerHeaderView.h
//  JKHire
//
//  Created by yanqb on 2017/3/7.
//  Copyright © 2017年 xianshijian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyEnum.h"

@class EditEmployerHeaderView;
@protocol EditEmployerHeaderViewDelegate <NSObject>

- (void)editEmployerHeaderView:(EditEmployerHeaderView *)headView actionType:(BtnOnClickActionType)actionType;

@end

@interface EditEmployerHeaderView : UIView
@property (nonatomic, strong) UIImageView *headImgView;
@property (nonatomic, strong) UITextField *utf;
@property (nonatomic, strong) UIButton *autnBtn;
@property (nonatomic, strong) UIImageView *iconImgView;
@property (nonatomic, strong) UILabel *labName;
@property (nonatomic, weak) UIView *botLine;
@property (nonatomic, weak) UIView *leftLine;
@property (nonatomic, weak) id<EditEmployerHeaderViewDelegate> delegate;
- (void)setEpModel:(id)epModel;

@end
