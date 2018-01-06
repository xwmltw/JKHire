//
//  SpreadOrderCell.m
//  JKHire
//
//  Created by fire on 16/10/22.
//  Copyright © 2016年 xianshijian. All rights reserved.
//

#import "SpreadOrderCell.h"
#import "ResponseInfo.h"
#import "DateHelper.h"

@interface SpreadOrderCell ()

@property (weak, nonatomic) IBOutlet UILabel *labTitle;
@property (weak, nonatomic) IBOutlet UILabel *labDate;


@end

@implementation SpreadOrderCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
}

- (void)setModel:(SpreadOrderModel *)model{
    self.labTitle.text = model.productName ? model.productName : @"" ;
    self.labDate.text = [NSString stringWithFormat:@"订单创建于: %@", [DateHelper getDateFromTimeNumber:model.createTime withFormat:@"yyyy/M/dd"]];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
