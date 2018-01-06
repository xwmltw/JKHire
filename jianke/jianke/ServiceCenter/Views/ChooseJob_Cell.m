//
//  ChooseJob_Cell.m
//  JKHire
//
//  Created by fire on 16/10/27.
//  Copyright © 2016年 xianshijian. All rights reserved.
//

#import "ChooseJob_Cell.h"
#import "WDConst.h"

@implementation ChooseJob_Cell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)layoutSubviews{
    [super layoutSubviews];
    self.textLabel.y -= 2;
    self.detailTextLabel.y += 2;
}

@end
