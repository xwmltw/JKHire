//
//  PersonSmcCell.m
//  JKHire
//
//  Created by fire on 16/10/19.
//  Copyright © 2016年 xianshijian. All rights reserved.
//

#import "PersonSmcCell.h"
#import "ResponseInfo.h"
#import "WDConst.h"

@interface PersonSmcCell (){
    NSIndexPath *_indexPath;
    ServicePersonalStuModel *_model;
}

@property (weak, nonatomic) IBOutlet UIImageView *imgPhoto;
@property (weak, nonatomic) IBOutlet UILabel *labName;
@property (weak, nonatomic) IBOutlet UILabel *labStatus;
@property (weak, nonatomic) IBOutlet UIButton *btnAskPhone;
@property (weak, nonatomic) IBOutlet UIButton *btnPhoneIcon;
@property (weak, nonatomic) IBOutlet UIButton *btnConfirm;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *layoutLabNameLeft;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *layoutBtnPhoneRight;

@end

@implementation PersonSmcCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    [self.btnAskPhone setCornerValue:2.0f];
    [self.btnAskPhone setBorderWidth:1.0f andColor:[UIColor XSJColor_tGrayDeepTinge]];
    [self.btnConfirm setCornerValue:2.0f];
    [self.btnConfirm setBorderWidth:1.0f andColor:[UIColor XSJColor_tGrayDeepTinge]];
    [self.imgPhoto setCornerValue:25.5f];
    self.btnAskPhone.tag = BtnOnClickActionType_payForPhoneNum;
    self.btnPhoneIcon.tag = BtnOnClickActionType_makeCall;
    self.btnConfirm.tag = BtnOnClickActionType_confirmContact;
    [self.btnAskPhone addTarget:self action:@selector(btnOnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.btnPhoneIcon addTarget:self action:@selector(btnOnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.btnConfirm addTarget:self action:@selector(btnOnClick:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)setModel:(ServicePersonalStuModel *)model withServiceType:(NSNumber *)serviceType{
    _model = model;
    
    self.labName.text = model.true_name;
    self.labName.textColor = (model.sex.integerValue == 0 ) ? [UIColor XSJColor_middelRed] : [UIColor XSJColor_base];
    self.btnAskPhone.hidden = YES;
    self.btnPhoneIcon.hidden = YES;
    self.btnConfirm.hidden = YES;
    switch (model.apply_status.integerValue) {
        case 1:{    //待回复
            self.labStatus.text = @"待对方报名";
        }
            break;
        case 2:{    //已报名
            self.labStatus.text = @"待付款";
            if (![XSJUserInfoData isReviewAccount]) {
                self.btnAskPhone.hidden = NO;
            }
        }
            break;
        case 3:{    //已拒绝
            self.labStatus.text = @"对方已拒绝";
        }
            break;
        case 4:{    //已支付
            self.labStatus.text = @"待沟通";
            self.btnConfirm.hidden = NO;
            self.btnPhoneIcon.hidden = NO;
            self.layoutBtnPhoneRight.constant = 114;
        }
            break;
        case 5:{
            self.labStatus.text = @"超时已取消";
        }
            break;
        case 6:{
            self.labStatus.text = @"已沟通";
            self.btnPhoneIcon.hidden = NO;
            self.layoutBtnPhoneRight.constant = 16;
        }
            break;
        case 7:{
            self.labStatus.text = @"已取消";
        }
            break;
        default:
            self.labStatus.hidden = YES;
            break;
    }
    if (serviceType.integerValue < 3) { //模特/礼仪需求
        self.imgPhoto.hidden = NO;
        [self.imgPhoto sd_setImageWithURL:[NSURL URLWithString:model.profile_url] placeholderImage:[UIHelper getDefaultHead]];
    }else{
        self.imgPhoto.hidden = YES;
        self.layoutLabNameLeft.constant = 16;
    }
}

- (void)btnOnClick:(UIButton *)sender{
    if ([self.delegate respondsToSelector:@selector(btnOnClickWithActionType:withModel:)]) {
        [self.delegate btnOnClickWithActionType:sender.tag withModel:_model];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
