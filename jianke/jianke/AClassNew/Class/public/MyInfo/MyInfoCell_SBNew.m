//
//  MyInfoCell_SBNew.m
//  JKHire
//
//  Created by yanqb on 2017/3/21.
//  Copyright © 2017年 xianshijian. All rights reserved.
//

#import "MyInfoCell_SBNew.h"

@implementation MyInfoCell_SBNew

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
