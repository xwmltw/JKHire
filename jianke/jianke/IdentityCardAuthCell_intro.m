//
//  IdentityCardAuthCell_intro.m
//  jianke
//
//  Created by xiaomk on 16/4/28.
//  Copyright © 2016年 xianshijian. All rights reserved.
//

#import "IdentityCardAuthCell_intro.h"

@implementation IdentityCardAuthCell_intro

+ (instancetype)cellWithTableView:(UITableView *)tableView{
    static NSString *identifier = @"IdentityCardAuthCell_intro";
    IdentityCardAuthCell_intro *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (!cell) {
        static UINib* _nib;
        if (!_nib) {
            _nib = [UINib nibWithNibName:@"IdentityCardAuthCell_intro" bundle:nil];
        }
        
        if (_nib) {
            cell = [[_nib instantiateWithOwner:nil options:nil] objectAtIndex:0];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        
    }
    return cell;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
