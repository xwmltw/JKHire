//
//  HiringJobNumCell1.m
//  JKHire
//
//  Created by yanqb on 2017/4/1.
//  Copyright © 2017年 xianshijian. All rights reserved.
//

#import "HiringJobNumCell1.h"
#import "UILabel+MKExtension.h"
#import "UIColor+Extension.h"
#import "Masonry.h"
#import "ResponseInfo.h"
#import "UserData.h"

@interface HiringJobNumCell1 ()

@property (nonatomic, strong) UILabel *labTitle;
@property (nonatomic, strong) UILabel *labNum;

@end

@implementation HiringJobNumCell1

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor whiteColor];
        [self setupViews];
    }
    return self;
}

- (void)setupViews{
    
    self.labTitle = [UILabel labelWithText:@"您在福州已经使用的在招岗位数：" textColor:[UIColor XSJColor_tGrayDeepTinge] fontSize:16.0f];
    
    self.labNum = [UILabel labelWithText:@"0个" textColor:[UIColor XSJColor_middelRed] fontSize:16.0f];
    [self.contentView addSubview:self.labTitle];
    [self.contentView addSubview:self.labNum];
    
    [self.labTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(16);
        make.centerY.equalTo(self.contentView);
    }];
    
    [self.labNum mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.labTitle.mas_right);
        make.centerY.equalTo(self.labTitle);
    }];
}

- (void)setModel:(RecruitJobNumInfo *)model{
    switch (_cellType) {
        case hiringJobCellType_usedJobNum:{
            self.labTitle.text = [NSString stringWithFormat:@"您在%@已经使用的在招岗位数：", [UserData sharedInstance].city.name];
            self.labNum.text = [NSString stringWithFormat:@"%ld个", model.userd_recruit_job_num.integerValue];
        }
            break;
        case hiringJobCellType_leftJobNum:{
            NSInteger leftNum = model.all_recruit_job_num.integerValue - model.userd_recruit_job_num.integerValue;
            self.labTitle.text = [NSString stringWithFormat:@"您在%@剩余的在招岗位数：", [UserData sharedInstance].city.name];
            self.labNum.text = [NSString stringWithFormat:@"%ld个", leftNum];
        }
        default:
            break;
    }
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
