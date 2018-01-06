//
//  BuyJobNumCell_Input.h
//  JKHire
//
//  Created by yanqb on 2017/2/8.
//  Copyright © 2017年 xianshijian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyEnum.h"

@protocol BuyJobNumCell_InputDelegate <NSObject>

- (void)valueOnChage;

@end

@interface BuyJobNumCell_Input : UITableViewCell

@property (nonatomic, weak) id<BuyJobNumCell_InputDelegate> delegate;

- (void)setModel:(id)model cellType:(BuyJobNumCelltype)cellType isCanModify:(BOOL)isCanModify;

@end
