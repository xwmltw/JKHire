//
//  MyInsuranceCell.m
//  JKHire
//
//  Created by yanqb on 2016/11/17.
//  Copyright © 2016年 xianshijian. All rights reserved.
//

#import "MyInsuranceCell.h"
#import "ResponseInfo.h"
#import "DateHelper.h"

@interface MyInsuranceCell ()

@property (weak, nonatomic) IBOutlet UILabel *labTitle;
@property (weak, nonatomic) IBOutlet UILabel *labSubTitle;


@end

@implementation MyInsuranceCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setModel:(InsuranceRecordModel *)model{
    self.labTitle.text = [NSString stringWithFormat:@"投保人数: %@人", model.insurance_count.description];
    NSString *dateStr = [DateHelper getDateFromTimeNumber:model.create_time withFormat:@"yyyy/M/dd"];
    self.labSubTitle.text = [NSString stringWithFormat:@"订单创建于: %@",dateStr];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
