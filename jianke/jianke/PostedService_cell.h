//
//  PostedService_cell.h
//  JKHire
//
//  Created by yanqb on 16/11/8.
//  Copyright © 2016年 xianshijian. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ServiceTeamApplyModel;
@protocol PostedService_cellDelegate <NSObject>

- (void)editOnClickWithModel:(ServiceTeamApplyModel *)serviceModel;

@end

@interface PostedService_cell : UITableViewCell

@property (nonatomic,weak) id<PostedService_cellDelegate> delegate;
- (void)setModel:(id)model;

@end
