//
//  MyInfoCell_3.m
//  JKHire
//
//  Created by fire on 16/10/22.
//  Copyright © 2016年 xianshijian. All rights reserved.
//

#import "MyInfoCell_3.h"

@implementation MyInfoCell_3

+ (instancetype)cellWithTableView:(UITableView *)tableView{
    static NSString *identifier = @"MyInfoCell_3";
    MyInfoCell_3 *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (!cell) {
        UINib *_nib = [UINib nibWithNibName:@"MyInfoCell_3" bundle:nil];
        if (_nib) {
            cell = [[_nib instantiateWithOwner:nil options:nil] objectAtIndex:0];
        }
    }
    return cell;
}


- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
