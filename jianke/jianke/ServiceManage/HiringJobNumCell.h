//
//  HiringJobNumCell.h
//  JKHire
//
//  Created by yanqb on 2017/2/8.
//  Copyright © 2017年 xianshijian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyEnum.h"

@class HiringJobNumCell;
@protocol HiringJobNumCellDelegate <NSObject>

- (void)HiringJobNumCell:(HiringJobNumCell *)cell actionType:(BtnOnClickActionType)actionType;
- (void)HiringJobNumCell:(HiringJobNumCell *)cell isDropDownDirect:(BOOL)isDropDownDirect;

@end

@interface HiringJobNumCell : UITableViewCell

@property (nonatomic, weak) id<HiringJobNumCellDelegate> delegate;
- (void)setModel:(id)model;

@end
