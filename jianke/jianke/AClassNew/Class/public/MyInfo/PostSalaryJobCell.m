//
//  PostSalaryJobCell.m
//  JKHire
//
//  Created by yanqb on 2016/12/6.
//  Copyright © 2016年 xianshijian. All rights reserved.
//

#import "PostSalaryJobCell.h"
#import "UILabel+MKExtension.h"
#import "UIColor+Extension.h"
#import "Masonry.h"

@interface PostSalaryJobCell ()

@property (nonatomic,strong) UILabel *labLeft;
@property (nonatomic, strong) UILabel *labRight;
@property (nonatomic, strong) UIImageView *imgView;

@end

@implementation PostSalaryJobCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupViews];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupViews];
    }
    return self;
}

- (void)setupViews{
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    self.labLeft = [UILabel labelWithText:@"1. 创建代发岗位" textColor:[UIColor XSJColor_tGrayHistoyTransparent] fontSize:15.0f];
    self.labRight = [UILabel labelWithText:@"2. 代发工资" textColor:[UIColor XSJColor_tGrayDeepTransparent2] fontSize:15.0f];
    self.imgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"frequent_icon_forward"]];
    
    [self.contentView addSubview:self.labLeft];
    [self.contentView addSubview:self.labRight];
    [self.contentView addSubview:self.imgView];
    
    [self.labLeft mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(16);
        make.centerY.equalTo(self.contentView);
    }];
    
    [self.imgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.labLeft.mas_right).offset(16);
        make.centerY.equalTo(self.contentView);
    }];
    
    [self.labRight mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.imgView.mas_right).offset(16);
        make.centerY.equalTo(self.contentView);
    }];
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
