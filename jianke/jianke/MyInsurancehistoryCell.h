//
//  MyInsurancehistoryCell.h
//  JKHire
//
//  Created by yanqb on 2016/11/19.
//  Copyright © 2016年 xianshijian. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MyInsurancehistoryCell, InsurancePolicyParamModel;
@protocol MyInsurancehistoryCellDelegate <NSObject>

- (void)MyInsurancehistoryCell:(MyInsurancehistoryCell *)cell withModel:(InsurancePolicyParamModel *)model;

@end

@interface MyInsurancehistoryCell : UITableViewCell


@property (nonatomic, weak) id<MyInsurancehistoryCellDelegate> delegate;
@property (nonatomic, strong) InsurancePolicyParamModel *model;

@end
