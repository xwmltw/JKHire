//
//  PersonSmcCell.h
//  JKHire
//
//  Created by fire on 16/10/19.
//  Copyright © 2016年 xianshijian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyEnum.h"

@class ServicePersonalStuModel;
@protocol PersonSmcCellDelegate <NSObject>

- (void)btnOnClickWithActionType:(BtnOnClickActionType)actionType withModel:(ServicePersonalStuModel *)model;

@end

@interface PersonSmcCell : UITableViewCell

@property (nonatomic, weak) id<PersonSmcCellDelegate> delegate;

- (void)setModel:(ServicePersonalStuModel *)model withServiceType:(NSNumber *)serviceType;

@end
