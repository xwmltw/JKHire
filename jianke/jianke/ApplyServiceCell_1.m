//
//  ApplyServiceCell_1.m
//  JKHire
//
//  Created by fire on 16/11/5.
//  Copyright © 2016年 xianshijian. All rights reserved.
//

#import "ApplyServiceCell_1.h"
#import "WDConst.h"

@interface ApplyServiceCell_1 ()

@end

@implementation ApplyServiceCell_1

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.accessoryView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"job_icon_push"]];
        self.textLabel.font = [UIFont systemFontOfSize:17.0f];
        self.textLabel.textColor = [UIColor XSJColor_base];
        UIView *view = [[UIView alloc] init];
        view.backgroundColor = [UIColor XSJColor_clipLineGray];
        [self.contentView addSubview:view];
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).offset(16);
            make.right.bottom.equalTo(self.contentView);
            make.height.equalTo(@0.7);
        }];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

- (void)setModel:(EPModel *)epmodel{
    self.textLabel.text = (epmodel.city_name.length) ? epmodel.city_name : @"所在城市" ;
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
