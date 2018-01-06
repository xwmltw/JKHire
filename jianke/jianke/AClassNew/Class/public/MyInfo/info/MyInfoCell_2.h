//
//  MyInfoCell_2.h
//  JKHire
//
//  Created by fire on 16/10/22.
//  Copyright © 2016年 xianshijian. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MyInfoCell_2;
@protocol MyInfoCell_2Delegate <NSObject>

- (void)btnOnClickWithMyInfoCell:(MyInfoCell_2 *)cell;

@end

@interface MyInfoCell_2 : UITableViewCell

@property (nonatomic, weak) id<MyInfoCell_2Delegate> delegate;
+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end
