//
//  TeamServiceDetailTitleCell.m
//  JKHire
//
//  Created by fire on 16/10/21.
//  Copyright © 2016年 xianshijian. All rights reserved.
//

#import "TeamServiceDetailTitleCell.h"

@interface TeamServiceDetailTitleCell ()

@property (weak, nonatomic) IBOutlet UILabel *labTitle;
@property (weak, nonatomic) IBOutlet UILabel *labSalary;
@property (weak, nonatomic) IBOutlet UILabel *labDate;
@property (weak, nonatomic) IBOutlet UILabel *labAddress;
@property (weak, nonatomic) IBOutlet UILabel *labInviteNum;


@end

@implementation TeamServiceDetailTitleCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
