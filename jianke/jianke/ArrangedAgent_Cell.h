//
//  ArrangedAgent_Cell.h
//  JKHire
//
//  Created by 徐智 on 2017/6/5.
//  Copyright © 2017年 xianshijian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyEnum.h"

@class ArrangedAgentVas, ArrangedAgent_Cell;

@protocol ArrangedAgent_CellDelegate <NSObject>

- (void)ArrangedAgent_Cell:(ArrangedAgent_Cell *)cell actionType:(BtnOnClickActionType)actionType model:(ArrangedAgentVas *)model;

@end

@interface ArrangedAgent_Cell : UITableViewCell

@property (nonatomic, weak) id<ArrangedAgent_CellDelegate> delegate;
@property (nonatomic, strong) ArrangedAgentVas *model;

@end
