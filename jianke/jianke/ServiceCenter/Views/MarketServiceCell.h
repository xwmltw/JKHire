//
//  MarketServiceCell.h
//  JKHire
//
//  Created by fire on 16/10/11.
//  Copyright © 2016年 xianshijian. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, ActionType) {
    ActionType_ZhongBao,
    ActionType_XiongDitui,
};

@protocol MarketServiceCellDelegate <NSObject>

- (void)BtnOnClick:(ActionType)actionType;

@end

@interface MarketServiceCell : UITableViewCell

@property (nonatomic, weak) id<MarketServiceCellDelegate> delegate;

@end
