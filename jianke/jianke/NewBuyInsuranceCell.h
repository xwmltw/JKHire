//
//  NewBuyInsuranceCell.h
//  JKHire
//
//  Created by yanqb on 2016/11/18.
//  Copyright © 2016年 xianshijian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyEnum.h"

@class NewBuyInsuranceCell, InsurancePolicyParamModel;
@protocol NewBuyInsuranceCellDelegate <NSObject>

- (void)NewBuyInsuranceCell:(NewBuyInsuranceCell *)cell actionType:(BtnOnClickActionType)actionType atIndexPath:(NSIndexPath *)indexPath;

@end


@interface NewBuyInsuranceCell : UITableViewCell

@property (nonatomic, weak) id<NewBuyInsuranceCellDelegate> delegate;
@property (nonatomic, strong) InsurancePolicyParamModel *insurancePolicyModel;
@property (nonatomic, strong) NSIndexPath *indexPath;

@end
