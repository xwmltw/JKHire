//
//  NewBuyInsuranceCell.m
//  JKHire
//
//  Created by yanqb on 2016/11/18.
//  Copyright © 2016年 xianshijian. All rights reserved.
//

#import "NewBuyInsuranceCell.h"
#import "WDConst.h"

@interface NewBuyInsuranceCell () <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *utfTel;
@property (weak, nonatomic) IBOutlet UITextField *utfName;
@property (weak, nonatomic) IBOutlet UITextField *utfCard;
@property (weak, nonatomic) IBOutlet UILabel *labDay;
@property (weak, nonatomic) IBOutlet UILabel *labMoney;
@property (weak, nonatomic) IBOutlet UIButton *btnAddDay;
@property (weak, nonatomic) IBOutlet UIButton *btnDelete;

- (IBAction)utfTelOnChange:(UITextField *)sender;
- (IBAction)utfNameOnChange:(UITextField *)sender;
- (IBAction)utfCardOnChange:(UITextField *)sender;



@end

@implementation NewBuyInsuranceCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.utfTel.keyboardType = UIKeyboardTypeDecimalPad;
    self.utfTel.tag = 100;
    self.utfTel.delegate = self;
    self.utfName.tag = 101;
    self.utfName.delegate = self;
    self.utfCard.tag = 102;
    self.utfCard.delegate = self;

    [self.labDay setCornerValue:2.0f];
    [self.labDay setBorderWidth:1.0f andColor:[UIColor XSJColor_tGrayHistoyTransparent]];
    
    [self.labMoney setCornerValue:2.0f];
    [self.labMoney setBorderWidth:1.0f andColor:[UIColor XSJColor_tGrayHistoyTransparent]];

    self.btnAddDay.tag = BtnOnClickActionType_addDay;
    self.btnDelete.tag = BtnOnClickActionType_delete;
    [self.btnAddDay addTarget:self action:@selector(btnOnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.btnDelete addTarget:self action:@selector(btnOnClick:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)setInsurancePolicyModel:(InsurancePolicyParamModel *)insurancePolicyModel{
    _insurancePolicyModel = insurancePolicyModel;
    
    self.utfTel.text = insurancePolicyModel.insured_telephone.length ? insurancePolicyModel.insured_telephone : @"";
    self.utfName.text = insurancePolicyModel.insured_true_name.length ? insurancePolicyModel.insured_true_name : @"";
    self.utfCard.text = insurancePolicyModel.insured_id_card_num.length ? insurancePolicyModel.insured_id_card_num : @"";
    
    if (insurancePolicyModel.isBuyForJK) {
        self.utfTel.userInteractionEnabled = NO;
        self.utfName.userInteractionEnabled = NO;
        self.utfCard.userInteractionEnabled = NO;
        if (insurancePolicyModel.insured_id_card_num.length > 7) {
            NSMutableString *string = [[NSMutableString alloc] initWithString:insurancePolicyModel.insured_id_card_num];
            for (NSInteger i = 3; i < string.length; i++) {
                if (i >= 3 && i < string.length - 4) {
                    [string replaceCharactersInRange:NSMakeRange(i, 1) withString:@"*"];
                }
            }
            self.utfCard.text = [string copy];
        }else{
            self.utfTel.userInteractionEnabled = YES;
            self.utfName.userInteractionEnabled = YES;
            self.utfCard.userInteractionEnabled = YES;
            self.utfCard.text = insurancePolicyModel.insured_id_card_num;
        }
    }else{
        self.utfTel.userInteractionEnabled = YES;
        self.utfName.userInteractionEnabled = YES;
        self.utfCard.userInteractionEnabled = YES;
    }
    
    self.labDay.hidden = YES;
    self.labMoney.hidden = YES;
    NSInteger allDays = insurancePolicyModel.insurance_date_list.count;
    if (allDays) {
        self.labDay.text = [NSString stringWithFormat:@"共%ld天", allDays];
        self.labMoney.text = [NSString stringWithFormat:@"￥%.2f", insurancePolicyModel.all_pay_money_for_insurance];
        self.labDay.hidden = NO;
        self.labMoney.hidden = NO;
    }
}

- (void)btnOnClick:(UIButton *)sender{
    if ([self.delegate respondsToSelector:@selector(NewBuyInsuranceCell:actionType:atIndexPath:)]) {
        [self.delegate NewBuyInsuranceCell:self actionType:sender.tag atIndexPath:_indexPath];
    }
}

- (IBAction)utfTelOnChange:(UITextField *)sender {
    self.insurancePolicyModel.insured_telephone = sender.text;
}

- (IBAction)utfNameOnChange:(UITextField *)sender {
    self.insurancePolicyModel.insured_true_name = sender.text;
}

- (IBAction)utfCardOnChange:(UITextField *)sender {
     self.insurancePolicyModel.insured_id_card_num = sender.text;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if (textField.tag == 100) {
        if (range.location >= 11) { //置换最后一位
            return NO;
            return YES;
        }
    }else if (textField.tag == 101){
        if (range.location >= 20) { //置换最后一位
            return NO;
            return YES;
        }
    }else if (textField.tag == 102){
        if (range.location >= 18) { //置换最后一位
            return NO;
            return YES;
        }
    }
    return YES;
}

@end
