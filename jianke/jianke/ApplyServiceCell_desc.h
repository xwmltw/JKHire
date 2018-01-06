//
//  ApplyServiceCell_desc.h
//  JKHire
//
//  Created by fire on 16/11/5.
//  Copyright © 2016年 xianshijian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyEnum.h"

@class EPModel;
@interface ApplyServiceCell_desc : UITableViewCell

@property (nonatomic, copy) NSString *placeHolder;
@property (nonatomic, assign) NSInteger maxLength;
@property (nonatomic, copy) MKBlock block;
- (void)setEpModel:(id)epModel cellType:(ApplySerciceCellType)cellType;

@end
