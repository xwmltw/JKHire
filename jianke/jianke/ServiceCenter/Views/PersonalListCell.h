//
//  PersonalListCell.h
//  JKHire
//
//  Created by fire on 16/10/12.
//  Copyright © 2016年 xianshijian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyEnum.h"

@protocol PersonalListCellDelegate <NSObject>

- (void)personalListCellAtIndexPath:(NSIndexPath *)indexPath;

@end

@interface PersonalListCell : UITableViewCell

- (void)setModel:(id)model cellType:(ServicePersonType)servicePersonType atIndexPath:(NSIndexPath *)indexPath;

@property (nonatomic, weak) id<PersonalListCellDelegate> delegate;

@end
