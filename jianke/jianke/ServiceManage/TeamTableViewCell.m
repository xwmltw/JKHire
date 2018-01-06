//
//  TeamTableViewCell.m
//  JKHire
//
//  Created by fire on 16/10/21.
//  Copyright © 2016年 xianshijian. All rights reserved.
//

#import "TeamTableViewCell.h"
#import "ResponseInfo.h"
#import "Masonry.h"

@implementation TeamTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        UIView *bottomLine = [[UIView alloc] init];
        bottomLine.backgroundColor = MKCOLOR_RGB(233, 233, 233);
        [self.contentView addSubview:bottomLine];
        [bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).offset(16);
            make.right.bottom.equalTo(self.contentView);
            make.height.equalTo(@.7);
        }];
    }
    return self;
}

- (void)setModel:(TeamCompanyModel *)model{
    self.textLabel.text = model.ordered_basic_info.service_name;
    
    /*!< 电话联系结果枚举：1谈妥合作 2未谈妥合作 3电话无法接通 4其他' */
    if (model.contact_status.integerValue == 1) {
        switch (model.contact_result_type.integerValue) {
            case 1:
                self.detailTextLabel.text = @"谈妥合作";
                break;
            case 2:
                self.detailTextLabel.text = @"未谈妥合作";
                break;
            case 3:
                self.detailTextLabel.text = @"电话无法接通";
                break;
            case 4:
                self.detailTextLabel.text = @"其他";
                break;
            default:
                break;
        }
    }else{
        self.detailTextLabel.text = @"未联系";
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
