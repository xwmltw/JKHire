//
//  PersonalServiceCell.h
//  JKHire
//
//  Created by fire on 16/10/11.
//  Copyright © 2016年 xianshijian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyEnum.h"

@class PersonalServiceCell;
@protocol PersonalServiceCellDelegate <NSObject>

- (void)personalServiceCell:(PersonalServiceCell *)cell actionType:(ServicePersonType)actionType;

@end

@interface PersonalServiceCell : UITableViewCell

@property (nonatomic, weak) id<PersonalServiceCellDelegate> delegate;

@end
