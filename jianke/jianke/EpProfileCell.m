//
//  EpProfileCell.m
//  JKHire
//
//  Created by fire on 16/11/7.
//  Copyright © 2016年 xianshijian. All rights reserved.
//

#import "EpProfileCell.h"
#import "EPModel.h"

@interface EpProfileCell ()


@property (weak, nonatomic) IBOutlet UILabel *labTitle;
@property (weak, nonatomic) IBOutlet UILabel *labDetail;
@property (weak, nonatomic) IBOutlet UIButton *btnRight;
- (IBAction)btnRightOnClick:(UIButton *)sender;


@end

@implementation EpProfileCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.btnRight.tag = BtnOnClickActionType_idAuthAction;
}

- (void)setEpModel:(EPModel *)epModel cellType:(EpProfileCellType)cellType{
    _btnRight.hidden = NO;
    switch (cellType) {
        case EpProfileCellType_commpany:{
            
           self.labDetail.text = epModel.enterprise_name.length ? epModel.enterprise_name : @"-";
            self.labTitle.text = @"公司名称:";
            if (epModel.verifiy_status.intValue == 1) {
                _btnRight.hidden = YES;
//                [_btnRight setImage:[UIImage imageNamed:@"info_auth_no"] forState:UIControlStateNormal];
//                _btnRight.userInteractionEnabled = YES;
//                _btnRight.tag = EpProfileCellType_commpany;
                
            } else if (epModel.verifiy_status.intValue == 2) {
                [_btnRight setImage:[UIImage imageNamed:@"info_auth_ing"] forState:UIControlStateNormal];
                _btnRight.userInteractionEnabled = NO;
            } else if (epModel.verifiy_status.intValue == 3){
                [_btnRight setImage:[UIImage imageNamed:@"info_auth_ep_0"] forState:UIControlStateNormal];
                _btnRight.userInteractionEnabled = NO;
            }
        }
            break;
        case EpProfileCellType_shortCommpany:{
            _btnRight.hidden = YES;
            self.labDetail.text = epModel.ent_short_name.length && ![epModel.ent_short_name isEqualToString:@" "] ? epModel.ent_short_name : @"-";
            self.labTitle.text = @"公司简称:";
        }
            break;
        case EpProfileCellType_industry:{
            _btnRight.hidden = YES;
            self.labTitle.text = @"涉及行业:";
            if (epModel.industry_name.length && [epModel.industry_name isEqualToString:@"其他行业"]) {
                self.labDetail.text = [NSString stringWithFormat:@"其他行业-%@",epModel.industry_desc];
            }else {
                self.labDetail.text = epModel.industry_name.length ? epModel.industry_name : @"-";
            
            }
            
        }
            break;
        case EpProfileCellType_hireCity:{
            
            _btnRight.hidden = NO;
            _btnRight.tag = EpProfileCellType_hireCity;
            [_btnRight.layer setMasksToBounds:YES];
            [_btnRight.layer setCornerRadius:12];
            [_btnRight setTitle:@"编辑" forState:UIControlStateNormal];
            [_btnRight setTitleColor: MKCOLOR_RGB(0, 188, 212)forState:UIControlStateNormal];
            [_btnRight setBackgroundColor:MKCOLOR_RGB(231, 247, 250)];
            
            
        
           self.labDetail.text = epModel.city_name.length ? epModel.city_name: @"-";
            self.labTitle.text = @"主要招聘城市:";
        }
            break;
        default:
            break;
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)btnRightOnClick:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(EpProfileCell:rightBtnActionType:)]) {
        [self.delegate EpProfileCell:self rightBtnActionType:sender.tag];
    }
}
@end
