//
//  MyInfoCell_2.m
//  JKHire
//
//  Created by fire on 16/10/22.
//  Copyright © 2016年 xianshijian. All rights reserved.
//

#import "MyInfoCell_2.h"
#import "WDConst.h"

@interface MyInfoCell_2 ()

@property (weak, nonatomic) IBOutlet UIButton *btnApply;


@end

@implementation MyInfoCell_2

+ (instancetype)cellWithTableView:(UITableView *)tableView{
    static NSString *identifier = @"MyInfoCell_2";
    MyInfoCell_2 *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (!cell) {
        UINib *_nib = [UINib nibWithNibName:@"MyInfoCell_2" bundle:nil];
        if (_nib) {
            cell = [[_nib instantiateWithOwner:nil options:nil] objectAtIndex:0];
        }
    }
    return cell;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    [self.btnApply setCornerValue:10.0f];
    [self.btnApply setBorderWidth:1.0f andColor:[UIColor XSJColor_base]];
    [self.btnApply addTarget:self action:@selector(btnApplyOnClick:) forControlEvents:UIControlEventTouchUpInside];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)btnApplyOnClick:(UIButton *)sender{
//    if ([self.delegat]) {
//        <#statements#>
//    }
    [self.delegate btnOnClickWithMyInfoCell:self];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
