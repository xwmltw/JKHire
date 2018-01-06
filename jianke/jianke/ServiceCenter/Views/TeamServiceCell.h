//
//  TeamServiceCell.h
//  JKHire
//
//  Created by fire on 16/10/11.
//  Copyright © 2016年 xianshijian. All rights reserved.
//

#import <UIKit/UIKit.h>
#define BtnHeight 99

@class TeamServiceCell;
@class MenuBtnModel;
@protocol TeamServiceCellDelegate <NSObject>

- (void)teamServiceCell:(TeamServiceCell *)cell btnModel:(MenuBtnModel *)btnModel;

@end

@interface TeamServiceCell : UITableViewCell

@property (nonatomic, weak) id <TeamServiceCellDelegate> delegate;

- (void)setModel:(id)model;

@end
