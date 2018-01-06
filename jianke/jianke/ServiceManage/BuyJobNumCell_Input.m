//
//  BuyJobNumCell_Input.m
//  JKHire
//
//  Created by yanqb on 2017/2/8.
//  Copyright © 2017年 xianshijian. All rights reserved.
//

#import "BuyJobNumCell_Input.h"
#import "WDConst.h"

@interface BuyJobNumCell_Input (){

    RechargeRecruitParam *_paramModel;
    
}

@property (nonatomic, assign) BuyJobNumCelltype cellType;

@property (weak, nonatomic) IBOutlet UITextField *utf;
@property (weak, nonatomic) IBOutlet UILabel *labUnit;
- (IBAction)utfOnChange:(UITextField *)sender;


@end

@implementation BuyJobNumCell_Input

- (void)awakeFromNib {
    [super awakeFromNib];
    self.backgroundColor = [UIColor XSJColor_newGray];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.utf.keyboardType = UIKeyboardTypeASCIICapableNumberPad;
}

- (void)setModel:(RechargeRecruitParam *)model cellType:(BuyJobNumCelltype)cellType isCanModify:(BOOL)isCanModify{
    _paramModel = model;
    self.cellType = cellType;
    self.utf.userInteractionEnabled = YES;
    switch (cellType) {
        case BuyJobNumCelltype_jobNum:{
            self.utf.placeholder = @"输入在招岗位数量";
            self.labUnit.text = @"个";
            self.utf.text = (model.recruit_job_num.integerValue) ? model.recruit_job_num.description : nil;
            self.utf.userInteractionEnabled = isCanModify;
        }
            break;
        case BuyJobNumCelltype_jobTimeLong:{
            self.utf.placeholder = @"输入招聘时长";
            self.labUnit.text = @"个月";
            self.utf.text = (model.recruit_keep_months.integerValue) ? model.recruit_keep_months.description : nil;
        }
            break;
        default:
            break;
    }
}

- (IBAction)utfOnChange:(UITextField *)sender {
    switch (self.cellType) {
        case BuyJobNumCelltype_jobNum:{
            _paramModel.recruit_job_num = @(sender.text.integerValue);
        }
            break;
        case BuyJobNumCelltype_jobTimeLong:{
            _paramModel.recruit_keep_months = @(sender.text.integerValue);
        }
            break;
        default:
            break;
    }
    
    if ([self.delegate respondsToSelector:@selector(valueOnChage)]) {
        [self.delegate valueOnChage];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}
@end
