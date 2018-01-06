//
//  EditEPInfoDetailCell.m
//  jianke
//
//  Created by xiaomk on 16/3/15.
//  Copyright © 2016年 xianshijian. All rights reserved.
//

#import "EditEPInfoDetailCell.h"

@implementation EditEPInfoDetailCell

+ (instancetype)new{
    static UINib* _nib;
    if (_nib == nil) {
        _nib = [UINib nibWithNibName:@"EditEPInfoDetailCell" bundle:nil];
        
        
        
    }
    EditEPInfoDetailCell* cell;
    if (_nib) {
        cell = [[_nib instantiateWithOwner:nil options:nil] objectAtIndex:0];
    }
    
    cell.labWriter.attributedText = [cell getMutableAttStrWith:cell.tfEPDetail.text];
    
    cell.tfEPDetail.block = ^(NSString *text){
        cell.labWriter.attributedText = [cell getMutableAttStrWith:text];
    };
    return cell;
}

- (NSMutableAttributedString *)getMutableAttStrWith:(NSString *)text{
    if (!text.length) {
        text = @"";
    }
    NSMutableAttributedString *mutableAttStr = [[NSMutableAttributedString alloc] initWithString:@"还能输入" attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:12.0f], NSForegroundColorAttributeName: MKCOLOR_RGBA(34, 58, 80, 0.32)}];
    NSString *str = [NSString stringWithFormat:@"%ld", self.tfEPDetail.maxLength - text.length];
    NSAttributedString *attStr1 = [[NSAttributedString alloc] initWithString:str attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:12.0f], NSForegroundColorAttributeName: [UIColor XSJColor_middelRed]}];
    NSAttributedString *attStr2 = [[NSAttributedString alloc] initWithString:@"字" attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:12.0f], NSForegroundColorAttributeName: MKCOLOR_RGBA(34, 58, 80, 0.32)}];
    [mutableAttStr appendAttributedString:attStr1];
    [mutableAttStr appendAttributedString:attStr2];
    return mutableAttStr;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
