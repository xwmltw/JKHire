//
//  MyInfoCell_4.h
//  JKHire
//
//  Created by fire on 16/10/24.
//  Copyright © 2016年 xianshijian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyEnum.h"

@class MyInfoCell_4;
@protocol MyInfoCell_4Delegate <NSObject>

- (void)MyInfoCell_4:(MyInfoCell_4 *)cell actionType:(BtnOnClickActionType)actionType;

@end

@interface MyInfoCell_4 : UITableViewCell

@property (nonatomic, weak) id<MyInfoCell_4Delegate> delegate;
+ (instancetype)cellWithTableView:(UITableView *)tableView;

- (void)setModel:(id)model;

@end
