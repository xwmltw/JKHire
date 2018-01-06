//
//  MyInsurancehistoryCell.m
//  JKHire
//
//  Created by yanqb on 2016/11/19.
//  Copyright © 2016年 xianshijian. All rights reserved.
//

#import "MyInsurancehistoryCell.h"
#import "BaseButton.h"
#import "ParamModel.h"
#import "WDConst.h"

@interface MyInsurancehistoryCell ()

@property (weak, nonatomic) IBOutlet UILabel *labTitle;
@property (weak, nonatomic) IBOutlet BaseButton *btnDay;
@property (weak, nonatomic) IBOutlet UIImageView *imgFail;

- (IBAction)btnDay:(UIButton *)sender;

@end

@implementation MyInsurancehistoryCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    [self.btnDay setMarginForImg:-1 marginForTitle:0];
}

- (void)setModel:(InsurancePolicyParamModel *)model{
    _model = model;
    self.labTitle.text = model.insured_true_name;
    self.labTitle.textColor = (model.insured_sex.integerValue == 1) ? [UIColor XSJColor_base] : [UIColor XSJColor_middelRed];
    [self.btnDay setTitle:[NSString stringWithFormat:@"已投保%ld天", model.insurance_date_list.count] forState:UIControlStateNormal];
    if (model.insurance_close_status.integerValue == 2) {
        self.btnDay.hidden = YES;
        self.imgFail.hidden = NO;
    }else{
        self.btnDay.hidden = NO;
        self.imgFail.hidden = YES;
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)btnDatOnClick:(UIButton *)sender {
}
- (IBAction)btnDay:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(MyInsurancehistoryCell:withModel:)]) {
        [self.delegate MyInsurancehistoryCell:self withModel:_model];
    }
}
@end
