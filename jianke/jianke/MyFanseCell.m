//
//  MyFanseCell.m
//  JKHire
//
//  Created by fire on 16/11/4.
//  Copyright © 2016年 xianshijian. All rights reserved.
//

#import "MyFanseCell.h"
#import "WDConst.h"

@implementation MyFanseCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.textLabel.font = [UIFont systemFontOfSize:18.0f];
        [self.imageView setCornerValue:25.0f];
        
        self.accessoryView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"job_icon_push"]];
        
        UIView *line = [[UIView alloc] init];
        line.backgroundColor = [UIColor XSJColor_clipLineGray];
        
        [self.contentView addSubview:line];
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self.contentView);
            make.bottom.equalTo(self.contentView.mas_bottom);
            make.height.equalTo(@0.7);
        }];
    }
    return self;
}

- (void)setModel:(JKModel *)model{
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:model.profile_url] placeholderImage:[UIHelper getDefaultHead]];
    self.textLabel.text = model.true_name.length ? model.true_name : @"";
    self.textLabel.textColor = (model.sex.integerValue == 1) ? [UIColor XSJColor_base] : [UIColor XSJColor_middelRed];
}

- (void)layoutSubviews{
    [super layoutSubviews];
    self.imageView.frame = CGRectMake(16, (self.height - 50) / 2, 50, 50);
    self.textLabel.x = CGRectGetMaxX(self.imageView.frame) + 12;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
