//
//  ApplyServiceCell_0.h
//  JKHire
//
//  Created by fire on 16/11/5.
//  Copyright © 2016年 xianshijian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyEnum.h"

@class ApplyServiceCell_0;
@protocol ApplyServiceCell_0Delegate <NSObject>

- (void)applyServiceCell:(ApplyServiceCell_0 *)cell actionType:(BtnOnClickActionType)actionType;

@end

@interface ApplyServiceCell_0 : UITableViewCell

@property (nonatomic, assign) BOOL isShowAuthBtn;   /*!< 是否显示右边btn */
@property (nonatomic, weak) id<ApplyServiceCell_0Delegate> delegate;

- (void)setModel:(id)epModel cellType:(ApplySerciceCellType)cellType;

@end
