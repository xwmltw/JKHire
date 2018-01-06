//
//  ManualAddPayCell.m
//  jianke
//
//  Created by xiaomk on 16/7/11.
//  Copyright © 2016年 xianshijian. All rights reserved.
//

#import "ManualAddPayCell.h"
#import "XSJConst.h"
#import "JKModel.h"

@interface ManualAddPayCell() <UIAlertViewDelegate> {
    JKModel *_jkModel;
    NSIndexPath *_indexPath;
}

@property (weak, nonatomic) IBOutlet UIView *viewWithSalary;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *layoutSexViewTop;

@property (weak, nonatomic) IBOutlet UITextField *tfPhone;
@property (weak, nonatomic) IBOutlet UITextField *tfName;
@property (weak, nonatomic) IBOutlet UITextField *tfPay;
@property (weak, nonatomic) IBOutlet UIButton *btnBoy;
@property (weak, nonatomic) IBOutlet UIButton *btnGirl;
@property (weak, nonatomic) IBOutlet UIButton *btnDelete;
@property (weak, nonatomic) IBOutlet UIButton *btnCheck;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *layoutSexLineForLeft;

@end

@implementation ManualAddPayCell

+ (instancetype)cellWithTableView:(UITableView *)tableView{
    static NSString *identifier = @"ManualAddPayCell";
    ManualAddPayCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        static UINib* _nib;
        if (!_nib) {
            _nib = [UINib nibWithNibName:@"ManualAddPayCell" bundle:nil];
        }
        
        if (_nib) {
            cell = [[_nib instantiateWithOwner:nil options:nil] objectAtIndex:0];
        }
        cell.backgroundColor = [UIColor whiteColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return cell;
}

- (void)setJkModel:(JKModel *)jkModel withIndexPath:(NSIndexPath*)indexPath isLastItem:(BOOL)isLastItem{
    
    [self.btnDelete addTarget:self action:@selector(btnDeleteOnclick:) forControlEvents:UIControlEventTouchUpInside];
    [self.tfPhone addTarget:self action:@selector(tfTelEditChange:) forControlEvents:UIControlEventEditingChanged];
    [self.tfPhone addTarget:self action:@selector(tfTelEditEnd:) forControlEvents:UIControlEventEditingDidEnd];
    [self.tfPay addTarget:self action:@selector(tfPayEidtEnd:) forControlEvents:UIControlEventEditingDidEnd];
    [self.tfPay addTarget:self action:@selector(tfPayEditChange:) forControlEvents:UIControlEventEditingChanged];
    [self.tfName addTarget:self action:@selector(tfNameEditEnd:) forControlEvents:UIControlEventEditingDidEnd];
    
    
    _jkModel = jkModel;
    _indexPath = indexPath;
    self.tfPhone.text = jkModel.telphone;
    
    
    [self setExactName];
    
    
    [self setSexIsBoy:jkModel.sex.integerValue == 1];
    self.btnDelete.hidden = isLastItem;
    
    if (self.isFromPayView) {
        self.viewWithSalary.hidden = NO;
        self.layoutSexViewTop.constant = 44;
        self.tfPay.text = jkModel.salary_num ? [[NSString stringWithFormat:@"%0.2f",jkModel.salary_num.doubleValue*0.01] stringByReplacingOccurrencesOfString:@".00" withString:@""]: nil;
    }else{
        self.viewWithSalary.hidden = YES;
        self.layoutSexViewTop.constant = 0;
    }
}

- (void)setExactName{
    if (_jkModel.isNeedCheck) {
        self.btnCheck.hidden = YES;
        if (_jkModel.isHasCheck) {
            self.tfName.text = _jkModel.true_name;
        }else{
            [self setNameLabelText:_jkModel.true_name];
        }
    }else{
        self.tfName.text = _jkModel.input_name;
        self.btnCheck.hidden = !_jkModel.isNeedCheck;
    }
}

- (void)setSexIsBoy:(BOOL)isBoy{
    self.btnBoy.selected = isBoy;
    self.btnGirl.selected = !isBoy;
    self.layoutSexLineForLeft.constant = isBoy ? 0 : SCREEN_WIDTH/2;
}

//获取手机号相关信息
- (void)tfTelEditChange:(UITextField *)textField{

    if (textField.text.length > 11) {
        textField.text = [textField.text substringToIndex:11];
    }
}

- (void)tfTelEditEnd:(UITextField *)sender {
    _jkModel.telphone = sender.text;
    
    if (sender.text.length != 11){
        [UIHelper toast:@"请输入正确的手机号码"];
        return;
    }
    
    if ([self.delegate respondsToSelector:@selector(queryAccountInfo:withIndexPath:)]) {
        [self.delegate queryAccountInfo:sender.text withIndexPath:_indexPath];
    }
}

- (void)tfPayEditChange:(UITextField *)sender{
    //修改金钱
    NSRange range = [sender.text rangeOfString:@"."];
    if (range.location != NSNotFound) { // 有小数点
        if (sender.text.length > 9) {
            sender.text = [sender.text substringToIndex:9];
        }
    } else { // 没有小数点
        if (sender.text.length > 6) {
            sender.text = [sender.text substringToIndex:6];
        }
    }
}

- (void)tfPayEidtEnd:(UITextField *)sender{
    if (sender.text.length > 0) {
        _jkModel.salary_num = @((NSInteger)(sender.text.doubleValue*100));
    }else{
        _jkModel.salary_num = nil;
    }

//    if (sender.text == nil || sender.text.doubleValue == 0) {
//        [UIHelper toast:@"代发工资金额不能为0"];
//    }
}



- (void)tfNameEditEnd:(UITextField *)sender {
        _jkModel.input_name = sender.text;

//    if (sender.text == nil || sender.text.length == 0) {
//        [UIHelper toast:@"请填写兼客真实姓名"];
//    }
}

/** 手动刷新cell内容 */
- (void)updateCell:(JKModel *)jkModel{
    [self setNameLabelText:jkModel.true_name];
}

/** 设置带星号姓名 */
- (void)setNameLabelText:(NSString *)name{
    if (name && name.length) {
        [self endEditing:YES];
        self.tfName.userInteractionEnabled = NO;
        NSMutableString *temp = [[NSMutableString alloc] initWithString:name];
        if (name.length == 1) {
            temp = [name copy];
            _jkModel.isHasCheck = YES;
            _btnCheck.hidden = YES;
            _jkModel.isNeedCheck = NO;
        }else{
            [temp replaceCharactersInRange:(NSRange){0,1} withString:@"*"];
            _jkModel.isHasCheck = NO;
            _btnCheck.hidden = NO;
            _jkModel.isNeedCheck = YES;
        }
        _tfName.text = [NSString stringWithFormat:@"%@",[temp copy]];
    }else{
        self.tfName.userInteractionEnabled = YES;
        _btnCheck.hidden = YES;
        _jkModel.isNeedCheck = NO;
    }
}

#pragma mark - ***** 按钮事件 ******
- (void)changeSexOnclick:(UIButton *)sender{
    if (sender.tag == 101) {
        [self setSexIsBoy:YES];
    }else if (sender.tag == 102){
        [self setSexIsBoy:NO];
    }
}

//删除操作
- (void)btnDeleteOnclick:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(deleteCellForIndexPath:)]) {
        [self.delegate deleteCellForIndexPath:_indexPath];  
    }
}

//校验姓名弹窗
- (void)btnCheckOnClick:(UIButton *)sender{
    [self endEditing:YES];
    [self showAlertView];
}

- (void)showAlertView{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请补全对方姓名，确保资金安全" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    alertView.alertViewStyle = UIAlertViewStylePlainTextInput;
    UITextField *utf = [alertView textFieldAtIndex:0];
    utf.rightViewMode = UITextFieldViewModeAlways;
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 25)];
    label.textAlignment = NSTextAlignmentRight;
    label.textColor = [UIColor XSJColor_tGrayDeepTinge];
    label.font = [UIFont systemFontOfSize:12.0f];
    label.text = [self getAlertNameWithName:_jkModel.true_name];
    utf.rightView = label;
    alertView.delegate = self;
    [alertView show];
}

- (NSString *)getAlertNameWithName:(NSString *)name{
    if (name.length <= 1) {
        return name;
    }else{
        NSString *tmp = [name substringFromIndex:1];
        return tmp;
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    [self endEditing:YES];
    if (buttonIndex == 1) {
        UITextField *utf = [alertView textFieldAtIndex:0];
        UILabel *label = (UILabel *)utf.rightView;
        NSString *strName = [NSString stringWithFormat:@"%@%@", utf.text, label.text];
        if ([self checkNameExact:strName]) {
            [UIHelper toast:@"校验成功"];
            _jkModel.isHasCheck = YES;
            [self setExactName];
        }else{
            [UIHelper toast:@"账号与姓名不匹配，请核对"];
            [self showAlertView];
            _jkModel.isHasCheck = NO;
        }
    }
}

- (BOOL)checkNameExact:(NSString *)name{
    return [_jkModel.true_name isEqualToString:name];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    [self.btnCheck addTarget:self action:@selector(btnCheckOnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.btnCheck setCornerValue:2.0f];
    [self.btnCheck setBorderWidth:1.0f andColor:[UIColor XSJColor_tGrayDeepTinge]];
    self.btnCheck.hidden = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
