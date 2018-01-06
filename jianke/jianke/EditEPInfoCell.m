//
//  EditEPInfoCell.m
//  jianke
//
//  Created by xiaomk on 16/3/2.
//  Copyright © 2016年 xianshijian. All rights reserved.
//

#import "EditEPInfoCell.h"
#import "EPModel.h"

@interface EditEPInfoCell ()<UITextFieldDelegate>

@property (nonatomic, strong) EPModel *epModel;

@end

@implementation EditEPInfoCell

+ (instancetype)cellWithTableView:(UITableView *)tableview{
    static NSString *idetifier = @"EditEPInfoCell";
    EditEPInfoCell *cell = [tableview dequeueReusableCellWithIdentifier:idetifier];
    if (!cell) {
        static UINib* _nib;
        if (_nib == nil) {
            _nib = [UINib nibWithNibName:@"EditEPInfoCell" bundle:nil];
        }
        if (_nib) {
            cell = [[_nib instantiateWithOwner:nil options:nil] objectAtIndex:0];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return cell;
}

- (void)setData:(EPModel *)epModel atIndexPath:(ApplySerciceCellType )type{
    _epModel = epModel;
    self.auth_image.hidden = YES;
    self.btnAuth.hidden = YES;
    self.btnNext.hidden = NO;
    self.btnNext.userInteractionEnabled = NO;
    self.tfText.userInteractionEnabled = YES;
    self.btnAuth.userInteractionEnabled = NO;
    [self.tfText addTarget:self action:@selector(tfTextOnClick:) forControlEvents:UIControlEventEditingChanged];
    self.tfText.delegate = self;
        switch (type) {
            case ApplySerciceCellType_trueName:{
                [self setBtnHidden:YES];
                self.labTitle.text = @"姓名(必填)";
                self.tfText.placeholder = @"输入真实姓名,限6个字";
                self.tfText.text = epModel.true_name ? epModel.true_name : @"";
                
                self.tfText.tag = EditEpCellType_Name;
                self.auth_image.tag = EditEpCellType_Name;
                    if (epModel.id_card_verify_status.integerValue == 1 || epModel.id_card_verify_status.integerValue == 4) {
                        
                    }else if (epModel.id_card_verify_status.integerValue == 2) {
                        self.auth_image.hidden = NO;
                        self.tfText.userInteractionEnabled = NO;
                    }else if (epModel.id_card_verify_status.integerValue == 3) {
                        self.tfText.userInteractionEnabled = NO;
                        self.auth_image.hidden = NO;
                    }
            }
                break;
            case ApplySerciceCellType_hireCity:{
                self.labTitle.text = @"主要招聘城市(必选)";
                self.tfText.text = @"主要招聘城市";
                self.tfText.userInteractionEnabled = NO;
                self.btnNext.userInteractionEnabled = NO;
                self.tfText.tag = EditEpCellType_hireCity;
                self.btnAuth.hidden = YES;
                self.btnAuth.tag = EditEpCellType_hireCity;
                self.btnNext.tag = EditEpCellType_hireCity;
                if (epModel.city_name.length) {
                    self.tfText.text = epModel.city_name;
                }
            }
                break;
            case ApplySerciceCellType_industry:{
                self.labTitle.text = @"涉及行业(必选)";
                self.tfText.text = @"选择涉及行业";
                self.tfText.userInteractionEnabled = NO;
                self.btnNext.userInteractionEnabled = NO;
                self.tfText.tag = EditEpCellType_Industry;
                self.btnAuth.hidden = YES;
                self.btnAuth.tag = EditEpCellType_Industry;
                self.btnNext.tag = EditEpCellType_Industry;
                if (epModel.industry_name.length) {
                    self.tfText.text = epModel.industry_name;
                }
            }
                break;
            case ApplySerciceCellType_companyName:{
                
                self.labTitle.text = @"公司名称";
                self.tfText.placeholder = @"输入营业执照上的公司全称,限30个字";
                self.tfText.userInteractionEnabled = NO;
                self.tfText.tag = EditEpCellType_Enterprase;
                self.btnAuth.tag = EditEpCellType_Enterprase;
                self.btnNext.hidden = YES;
                self.btnNext.tag = EditEpCellType_Enterprase;
                self.auth_image.tag = EditEpCellType_Enterprase;
                self.tfText.text = epModel.enterprise_name ? epModel.enterprise_name : @"";
                
                NSInteger verifyStatus = epModel.verifiy_status.integerValue;
                if (verifyStatus == 1 || verifyStatus == 4) {
                    [self.btnAuth setImage:[UIImage imageNamed:@"info_auth_no"] forState:UIControlStateNormal];
                    self.tfText.userInteractionEnabled = YES;
                }else if (verifyStatus == 2) {
                   [self.btnAuth setImage:[UIImage imageNamed:@"info_auth_ing"] forState:UIControlStateNormal];
                    self.btnNext.hidden = YES;
                    self.auth_image.hidden = NO;
                }else if (verifyStatus == 3) {
                    [self.btnAuth setImage:[UIImage imageNamed:@"info_auth_ep_0"] forState:UIControlStateNormal];
                    self.btnNext.hidden = YES;
                    self.auth_image.hidden = NO;
                }
            }
                break;
            case ApplySerciceCellType_abbreviationName:{
                self.labTitle.text = @"公司简称";
                self.tfText.placeholder = @"输入公司简称,限8个字";
                self.tfText.tag = EditEpCellType_shortEnterprase;
                self.tfText.text = epModel.ent_short_name && ![epModel.ent_short_name isEqualToString:@" "] ? self.epModel.ent_short_name : @"";
                [self setBtnHidden:YES];
                self.layoutBtnAutoWidth.constant = 1;
            }
                break;
            default:
                break;
        }
    
    
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    switch (textField.tag) {
        case EditEpCellType_Name:
            if (range.location > 6) {
                return NO;
            }
            break;
        case EditEpCellType_Enterprase:
            if (range.location > 30) {
                return NO;
            }
            break;
        case EditEpCellType_shortEnterprase:
            if (range.location > 8) {
                return NO;
            }
        break;
        default:
            break;
    }
    
    return YES;
}

- (void)setBtnHidden:(BOOL)hidden{
    self.btnAuth.hidden = hidden;
    self.btnNext.hidden = hidden;
}

- (void)btnAuthUserNameOnclick:(UIButton *)sender{
    [self.delegate pushAction:sender.tag];
}

- (void)tfTextOnClick:(UITextField *)sender{
    switch (sender.tag) {
        case EditEpCellType_Name:
            self.epModel.true_name = sender.text;
            break;
        case EditEpCellType_Enterprase:
            self.epModel.enterprise_name = sender.text;
            break;
        case EditEpCellType_shortEnterprase:
//            ELog(@"self.epModel.email:%@",sender.text);
            self.epModel.ent_short_name = sender.text;
            break;
    }
}
- (IBAction)bombBoxBtn:(UIButton *)sender {
    switch (sender.tag) {
        case EditEpCellType_Name:
             [self.delegate showBombBox:1];
            break;
        case EditEpCellType_Enterprase:
             [self.delegate showBombBox:2];
            break;
        default:
            break;
    }
   
}

@end
