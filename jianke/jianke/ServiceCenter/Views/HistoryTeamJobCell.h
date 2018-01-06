//
//  HistoryTeamJobCell.h
//  JKHire
//
//  Created by fire on 16/10/15.
//  Copyright © 2016年 xianshijian. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol HistoryTeamJobCellDelegate <NSObject>

- (void)btnInviteOnClickAtIndexpath:(NSIndexPath *)indexPath;

@end

@interface HistoryTeamJobCell : UITableViewCell

@property (nonatomic, weak) id<HistoryTeamJobCellDelegate> delegate;
@property (nonatomic, assign) BOOL isFromHitoryJob; //是否来自历史发布模板

- (void)setModel:(id)model atIndexPath:(NSIndexPath *)indexPath;
- (void)setTeamCompanyModel:(id)model;

@end
