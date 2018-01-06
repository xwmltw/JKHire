//
//  MyVerities_Cell.m
//  JKHire
//
//  Created by yanqb on 2017/3/31.
//  Copyright © 2017年 xianshijian. All rights reserved.
//

#import "MyVerities_Cell.h"
#import "Masonry.h"
#import "EPModel.h"
#import "WDConst.h"
#import "ResponseInfo.h"

@interface MyVerities_Cell ()

@property (nonatomic, weak) UIImageView *imgView;
@property (nonatomic, weak) UILabel *labSource;

@end

@implementation MyVerities_Cell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = MKCOLOR_RGB(245, 246, 247);
        [self setupViews];
    }
    return self;
}

- (void)setupViews{
    UIImageView *imgView = [[UIImageView alloc] init];
    _imgView = imgView;
    
    UILabel *lab = [[UILabel alloc] init];
    lab.font = [UIFont systemFontOfSize:13.0f];
    lab.textColor = [UIColor XSJColor_middelRed];
    lab.backgroundColor = MKCOLOR_RGB(254, 242, 245);
    lab.numberOfLines = 0;
    _labSource = lab;
    
    [self.contentView addSubview:imgView];
    [self.contentView addSubview:lab];
    
    [imgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(self.contentView);
        make.left.equalTo(self.contentView).offset(IMGMarginX);
        make.right.equalTo(self.contentView).offset(-IMGMarginX);
    }];
    
    [lab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.contentView).offset(-12);
        make.left.equalTo(self.contentView).offset(26);
        make.right.equalTo(self.contentView).offset(-26);
        make.height.greaterThanOrEqualTo(@20);
    }];
    
}

- (void)setEpInfo:(LatestVerifyInfo *)epInfo{
    _epInfo = epInfo;
    self.labSource.hidden = YES;
    switch (_cellType) {
        case MyVeritiesCellType_idCardVerity:{
            if (epInfo.account_info.id_card_verify_status.integerValue == 1) {
                self.imgView.image = [UIImage imageNamed:@"id_card_verity_no"];
            }else if (epInfo.account_info.id_card_verify_status.integerValue == 2){
                self.imgView.image = [UIImage imageNamed:@"id_card_verity_ing"];
            }else if (epInfo.account_info.id_card_verify_status.integerValue == 3){
                self.imgView.image = [UIImage imageNamed:@"id_card_verity_yes"];
            }else{
                if (epInfo.last_id_card_verify_info.reject_reason.length) {
                    self.labSource.hidden = NO;
                    self.labSource.text = [NSString stringWithFormat:@"认证不通过,原因:%@", epInfo.last_id_card_verify_info.reject_reason];
                }
                self.imgView.image = [UIImage imageNamed:@"id_card_verity_fail"];
            }
        }
            break;
        case MyVeritiesCellType_enterpriseVerity:{
            if (epInfo.account_info.verifiy_status.integerValue == 1) {
                self.imgView.image = [UIImage imageNamed:@"ep_card_verity_no"];
            }else if (epInfo.account_info.verifiy_status.integerValue == 2){
                self.imgView.image = [UIImage imageNamed:@"ep_card_verity_ing"];
            }else if (epInfo.account_info.verifiy_status.integerValue == 3){
                self.imgView.image = [UIImage imageNamed:@"ep_card_verity_yes"];
            }else{
                if (epInfo.last_business_licence_verify_info.reject_reason.length) {
                    self.labSource.hidden = NO;
                    self.labSource.text = [NSString stringWithFormat:@"认证不通过,原因:%@", epInfo.last_business_licence_verify_info.reject_reason];
                }
                self.imgView.image = [UIImage imageNamed:@"ep_card_verity_fail"];
            }
        }
            break;
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
