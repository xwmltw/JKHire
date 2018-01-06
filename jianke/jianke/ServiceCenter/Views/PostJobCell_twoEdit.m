//
//  PostJobCell_twoEdit.m
//  jianke
//
//  Created by xiaomk on 16/4/18.
//  Copyright © 2016年 xianshijian. All rights reserved.
//

#import "PostJobCell_twoEdit.h"
#import "PostJobModel.h"

@interface PostJobCell_twoEdit (){
    PostJobModel *_postJobModel;
}
@property (weak, nonatomic) IBOutlet UIView *leftLine;
@property (weak, nonatomic) IBOutlet UIView *rightLine;

@end

@implementation PostJobCell_twoEdit

- (void)awakeFromNib{
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

+ (instancetype)cellWithTableView:(UITableView *)tableView{
    static NSString *identifier = @"PostJobCell_twoEdit";
    PostJobCell_twoEdit *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (!cell) {
        static UINib* _nib;
        if (!_nib) {
            _nib = [UINib nibWithNibName:@"PostJobCell_twoEdit" bundle:nil];
        }
        
        if (_nib) {
            cell = [[_nib instantiateWithOwner:nil options:nil] objectAtIndex:0];
        }
        cell.backgroundColor = [UIColor whiteColor];
    }
    return cell;
}

- (void)setModel:(PostJobModel *)model cellType:(PostJobCellType)cellType{
    _postJobModel = model;
    [self.tfLeft addTarget:self action:@selector(tfTextEditEnd:) forControlEvents:UIControlEventEditingDidEnd];
    [self.tfLeft addTarget:self action:@selector(tfTextEditChange:) forControlEvents:UIControlEventEditingChanged];
    [self.btnRight addTarget:self action:@selector(btnSalaryUnitOnclick:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.tfRight addTarget:self action:@selector(tfTextEditEnd:) forControlEvents:UIControlEventEditingDidEnd];
    [self.tfRight addTarget:self action:@selector(tfTextEditChange:) forControlEvents:UIControlEventEditingChanged];
    
    self.btnLeft.hidden = YES;

    switch (cellType) {
        case PostJobCellType_contact:{
            self.btnRight.hidden = YES;
            self.imgXiaLeft.hidden = YES;
            self.imgXiaRight.hidden = YES;
            
            self.imgIcon.image = [UIImage imageNamed:@"v318_id_card"];
            self.tfLeft.placeholder = @"联系人";
            self.tfRight.placeholder = @"联系电话";
            self.tfLeft.tag = 1000;
            self.tfRight.tag = 1001;
            self.tfRight.keyboardType = UIKeyboardTypeNumberPad;
            
            
            if (_postJobModel.contact.name.length) {
                self.tfLeft.text = _postJobModel.contact.name;
            }
            if (_postJobModel.contact.phone_num.length) {
                self.tfRight.text = _postJobModel.contact.phone_num;
            }

        }
            break;
        default:{
            self.leftLine.hidden = YES;
            self.rightLine.hidden = YES;
            self.imgIcon.image = [UIImage imageNamed:@"v250_money"];
            self.imgXiaLeft.hidden = YES;
            self.tfRight.hidden = YES;
            
            self.tfLeft.placeholder = @"薪资金额";
            self.tfLeft.keyboardType = UIKeyboardTypeDecimalPad;
            self.tfLeft.tag = 1003;
            
            [self.btnRight setTitle:model.salary.unit_value forState:UIControlStateNormal];
            if (model.salary.value) {
                NSString *moneyStr = [NSString stringWithFormat:@"%.1f", model.salary.value.floatValue];
                self.tfLeft.text = [moneyStr stringByReplacingOccurrencesOfString:@".0" withString:@""];
            }
            self.btnRight.enabled = YES;
            self.imgXiaRight.hidden = NO;
        }
            break;
    }
    
}

- (void)setModel:(PostJobModel *)model{
    [self setModel:model cellType:0];

}

- (void)tfTextEditEnd:(UITextField *)sender{
    switch (sender.tag) {
        case 1000:  //联系人
            _postJobModel.contact.name = sender.text;
            break;
        case 1001:  //联系电话
            _postJobModel.contact.phone_num = sender.text;
            break;
        case 1003:  //薪资金额
            _postJobModel.salary.value = @(sender.text.floatValue);
            break;
    }
}

- (void)tfTextEditChange:(UITextField *)sender{
    NSInteger tag = sender.tag;
    switch (tag) {
        case 1000:
            _postJobModel.contact.name = sender.text;
            break;
        case 1001:
            if (sender.text.length > 11) {
                sender.text = [sender.text substringToIndex:11];
            }
            _postJobModel.contact.phone_num = sender.text;
            break;
        case 1003:
            [self constraintMoneyInputWithLength:6 textField:sender];
            _postJobModel.salary.value = @(sender.text.floatValue);
            ELog(@"num:%@",_postJobModel.salary.value);
            break;
        default:
            break;
    }
}

- (void)btnSalaryUnitOnclick:(UIButton *)sender{
    if ([self.delegate respondsToSelector:@selector(btnSalaryUnitOnclick)]) {
        [self.delegate btnSalaryUnitOnclick];
    }
}

/** 约束薪资输入 */
- (void)constraintMoneyInputWithLength:(NSInteger)length textField:(UITextField *)sender{
    NSRange range = [sender.text rangeOfString:@"."];
    if (range.location != NSNotFound) { // 有小数点
        if (sender.text.length == 1) {
            sender.text = @"";
            return;
        }
        if (sender.text.length > length + 2) {
            sender.text = [sender.text substringToIndex:length + 2];
        }
        if (range.location < sender.text.length - 1) {
            sender.text = [sender.text substringToIndex:range.location + 2];
        }
        sender.text = [sender.text stringByReplacingOccurrencesOfString:@".." withString:@"."];
        if ([sender.text rangeOfString:@"."].location == 0) {
            sender.text = [sender.text stringByReplacingOccurrencesOfString:@"." withString:@""];
        }
    } else { // 没有小数点
        if (sender.text.length > length) {
            sender.text = [sender.text substringToIndex:length];
        }
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
