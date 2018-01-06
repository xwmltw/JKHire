//
//  ApplyServiceCell_0.m
//  JKHire
//
//  Created by fire on 16/11/5.
//  Copyright © 2016年 xianshijian. All rights reserved.
//

#import "ApplyServiceCell_0.h"
#import "EPModel.h"

@interface ApplyServiceCell_0 () <UITextFieldDelegate>

@property (nonatomic, strong) EPModel *epModel;
@property (nonatomic, assign) ApplySerciceCellType cellType;
@property (weak, nonatomic) IBOutlet UITextField *utf;
@property (weak, nonatomic) IBOutlet UIButton *authBtn;
- (IBAction)authBtnOnClick:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UILabel *subUtf;


@end

@implementation ApplyServiceCell_0

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self.utf addTarget:self action:@selector(utfOnChange:) forControlEvents:UIControlEventEditingChanged];
    self.utf.delegate = self;
    self.authBtn.tag = BtnOnClickActionType_idAuthAction;
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)setModel:(EPModel *)epModel cellType:(ApplySerciceCellType)cellType{
    _epModel = epModel;
    _cellType = cellType;
    self.authBtn.userInteractionEnabled = YES;
    self.utf.keyboardType = UIKeyboardTypeDefault;
    self.utf.userInteractionEnabled = YES;
    
    if (epModel) {
        self.authBtn.hidden = YES;
        self.subUtf.hidden = YES;
        switch (cellType) {
            case ApplySerciceCellType_serviceName:{
                self.authBtn.hidden = NO;
                self.utf.userInteractionEnabled = YES;
                self.utf.placeholder = @"服务商名称";
                self.utf.text = epModel.service_name.length ? epModel.service_name : @"";
                int verifyStatus = epModel.verifiy_status.intValue;
                switch (verifyStatus) {
                    case 1:{
                        [self.authBtn setImage:[UIImage imageNamed:@"info_auth_no"] forState:UIControlStateNormal];
                    }
                        break;
                    case 2:
                        [self.authBtn setImage:[UIImage imageNamed:@"info_auth_ing"] forState:UIControlStateNormal];
                        self.authBtn.userInteractionEnabled = NO;
                        self.utf.userInteractionEnabled = NO;
                        break;
                    case 3:
                        [self.authBtn setImage:[UIImage imageNamed:@"info_auth_ep_0"] forState:UIControlStateNormal];
                        self.authBtn.userInteractionEnabled = NO;
                        break;
                    case 4:
                        [self.authBtn setImage:[UIImage imageNamed:@"info_auth_no"] forState:UIControlStateNormal];
                        break;
                    default:
                        break;
                }
            }
                break;
            case ApplySerciceCellType_name:{
                self.utf.placeholder = @"负责人姓名";
                self.utf.text = epModel.service_contact_name.length ? epModel.service_contact_name : @"";
            }
                break;
            case ApplySerciceCellType_telphone:{
                self.utf.placeholder = @"负责人联系方式";
                self.utf.text = epModel.service_contact_tel.length ? epModel.service_contact_tel : @"";
                self.utf.keyboardType = UIKeyboardTypeASCIICapableNumberPad;
            }
                break;
            case ApplySerciceCellType_companyName:{
                self.subUtf.text = @"公司名称";
                self.subUtf.hidden = NO;
                self.utf.placeholder = @"输入营业执照上的公司全称";
                self.utf.text = epModel.enterprise_name.length ? epModel.enterprise_name : @"";
            }
                break;
            case ApplySerciceCellType_abbreviationName:{
                self.subUtf.text = @"公司简称";
                self.subUtf.hidden = NO;
                self.utf.placeholder = @"输入公司简称";
                self.utf.text = epModel.ent_short_name.length ? epModel.ent_short_name : @"";
            }
                break;
            case ApplySerciceCellType_email:{
                self.utf.placeholder = @"企业邮箱";
                self.utf.text = epModel.email.length ? epModel.email : @"";
            }
                break;
            case ApplySerciceCellType_trueName:{
                self.subUtf.text = @"姓名(必填)";
                self.subUtf.hidden = NO;
                self.utf.placeholder = @"输入真实姓名";
                self.utf.text = epModel.true_name.length ? epModel.true_name : @"";
                if (epModel.id_card_verify_status.integerValue == 2 || epModel.id_card_verify_status.integerValue == 3) {
                    self.utf.userInteractionEnabled = NO;
                }
            }
                break;
            case ApplySerciceCellType_industry:{
                self.subUtf.text = @"涉及行业(必选)";
                self.subUtf.hidden = NO;
                self.utf.userInteractionEnabled = NO;
                self.utf.text = (!epModel.industry_name) ? @"选择涉及的行业" : epModel.industry_name;
                self.authBtn.hidden = NO;
                self.authBtn.enabled = NO;
                [self.authBtn setImage:[UIImage imageNamed:@"job_icon_push"] forState:UIControlStateNormal];
            }
                break;
            case ApplySerciceCellType_hireCity:{
                self.subUtf.text = @"主要招聘城市(必选)";
                self.subUtf.hidden = NO;
                self.utf.userInteractionEnabled = NO;
                self.utf.text = (!epModel.city_name) ? @"选择招聘城市" : epModel.city_name;
                self.authBtn.hidden = NO;
                self.authBtn.enabled = NO;
                [self.authBtn setImage:[UIImage imageNamed:@"job_icon_push"] forState:UIControlStateNormal];
            }
                break;
            default:
                break;
        }
    }
}

- (IBAction)authBtnOnClick:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(applyServiceCell:actionType:)]) {
        [self.delegate applyServiceCell:self actionType:sender.tag];
    }
}

- (void)utfOnChange:(UITextField *)sender{
    switch (self.cellType) {
        case ApplySerciceCellType_serviceName:{
            self.epModel.service_name = sender.text;
        }
            break;
        case ApplySerciceCellType_name:{
            self.epModel.service_contact_name = sender.text;
        }
            break;
        case ApplySerciceCellType_telphone:{
            self.epModel.service_contact_tel = sender.text;
        }
            break;
        case ApplySerciceCellType_companyName:{
            self.epModel.enterprise_name = sender.text;
        }
            break;
        case ApplySerciceCellType_email:{
            self.epModel.email = sender.text;
        }
            break;
        case ApplySerciceCellType_trueName:{
            self.epModel.true_name = sender.text;
        }
            break;
        case ApplySerciceCellType_abbreviationName:{
            self.epModel.ent_short_name = sender.text;
        }
            break;
        default:
            break;
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if ([self isNumPadKeyBoard]) {
        if (range.location >= 11) { //置换最后一位
            return NO;
            return YES;
        }
    }
    return YES;
}

- (BOOL)isNumPadKeyBoard{
    return (self.cellType == ApplySerciceCellType_telphone);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
    
@end
