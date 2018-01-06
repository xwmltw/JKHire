//
//  MyInfoCell_4.m
//  JKHire
//
//  Created by fire on 16/10/24.
//  Copyright © 2016年 xianshijian. All rights reserved.
//

#import "MyInfoCell_4.h"
#import "EPModel.h"
#import "UserData.h"

@interface MyInfoCell_4 ()

@property (weak, nonatomic) IBOutlet UILabel *labName;
@property (weak, nonatomic) IBOutlet UIButton *btn2;
@property (weak, nonatomic) IBOutlet UIButton *btn1;
@property (weak, nonatomic) IBOutlet UIImageView *imgHead;
@property (weak, nonatomic) IBOutlet UIButton *btn3;
@property (weak, nonatomic) IBOutlet UIImageView *imgIcon;

@end

@implementation MyInfoCell_4

+ (instancetype)cellWithTableView:(UITableView *)tableView{
    static NSString *identifier = @"MyInfoCell_4";
    MyInfoCell_4 *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (!cell) {
        UINib *_nib = [UINib nibWithNibName:@"MyInfoCell_4" bundle:nil];
        if (_nib) {
            cell = [[_nib instantiateWithOwner:nil options:nil] objectAtIndex:0];
        }
        [cell.btn1 addTarget:cell action:@selector(btnOnClick:) forControlEvents:UIControlEventTouchUpInside];
        [cell.btn2 addTarget:cell action:@selector(btnOnClick:) forControlEvents:UIControlEventTouchUpInside];
        [cell.btn3 addTarget:cell action:@selector(btnOnClick:) forControlEvents:UIControlEventTouchUpInside];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell.imgHead setCornerValue:30.0f];
    }
    return cell;
}


- (void)awakeFromNib {
    [super awakeFromNib];
    self.backgroundColor = [UIColor XSJColor_blackBase];
}

- (void)setModel:(EPModel *)model{
    self.labName.text = model.enterprise_name.length ? model.enterprise_name : model.true_name;
    
    [self.imgHead sd_setImageWithURL:[NSURL URLWithString:model.profile_url] placeholderImage:[UIHelper getDefaultHead]];
    
    int verifyStatus = model.verifiy_status.intValue;
    int nameVerityStatus = model.id_card_verify_status.intValue;
    
    //注意btnauth 和 btnvip不一定指认证 和 VIP
    
    self.btn1.hidden = YES;
    self.btn2.hidden = YES;
    self.btn3.hidden = YES;
    self.imgIcon.hidden = YES;
    if ([[UserData sharedInstance] isLogin]) {
        self.imgIcon.hidden = NO;
        
        if ([[UserData sharedInstance] isEnableVipService]) {
            self.btn1.tag = BtnOnClickActionType_Vip;
            self.btn1.hidden = NO;
            if ([XSJUserInfoData isReviewAccount]) {
                self.btn1.hidden = YES;
            }
            [self.btn1 setImage:[UIImage imageNamed:[[UserData sharedInstance] getStatusImgWithAccout]] forState:UIControlStateNormal];
            
            if (verifyStatus == 3 && nameVerityStatus == 3) {
                self.btn2.hidden = NO;
                self.btn3.hidden = NO;
                [self setEpStatus:self.btn2 status:verifyStatus];
                [self setIdCardStatus:self.btn3 status:nameVerityStatus];
            }else if (verifyStatus == 3){
                self.btn2.hidden = NO;
                [self setEpStatus:self.btn2 status:verifyStatus];
            }else if (nameVerityStatus == 3){
                self.btn2.hidden = NO;
                [self setIdCardStatus:self.btn2 status:nameVerityStatus];
            }else{
                self.btn2.hidden = NO;
                [self setIdCardStatus:self.btn2 status:verifyStatus];
            }
            
        }else{
            if (verifyStatus == 3 && nameVerityStatus == 3) {
                self.btn1.hidden = NO;
                self.btn2.hidden = NO;
                [self setEpStatus:self.btn1 status:verifyStatus];
                [self setIdCardStatus:self.btn1 status:nameVerityStatus];
            }else if (verifyStatus == 3){
                self.btn1.hidden = NO;
                [self setEpStatus:self.btn1 status:verifyStatus];
            }else if (nameVerityStatus == 3){
                self.btn1.hidden = NO;
                [self setIdCardStatus:self.btn1 status:nameVerityStatus];
            }else{
                self.btn1.hidden = NO;
                [self setIdCardStatus:self.btn1 status:verifyStatus];
            }
        }
    }
}

//实名认证
- (void)setIdCardStatus:(UIButton *)button status:(int)status{
    
    switch (status) {
        case 1:{
            [button setImage:[UIImage imageNamed:@"v320_id_verity_no"] forState:UIControlStateNormal];
            button.tag = BtnOnClickActionType_idCardVerityNO;
        }
            break;
        case 2:
            [button setImage:[UIImage imageNamed:@"v320_id_verity_no"] forState:UIControlStateNormal];
            button.tag = BtnOnClickActionType_idCardVerityIng;
            break;
        case 3:
            [button setImage:[UIImage imageNamed:@"v320_id_verity_yes"] forState:UIControlStateNormal];
            button.tag = BtnOnClickActionType_idCardVerityYES;
            break;
        case 4:
            [button setImage:[UIImage imageNamed:@"v320_id_verity_no"] forState:UIControlStateNormal];
            button.tag = BtnOnClickActionType_idCardVerityNO;
            break;
        default:
            break;
    }
}

    //企业认证
- (void)setEpStatus:(UIButton *)button status:(int)status{

    switch (status) {
        case 1:{
            [button setImage:[UIImage imageNamed:@"v320_id_verity_no"] forState:UIControlStateNormal];
            button.tag = BtnOnClickActionType_epVerityNO;
        }
            break;
        case 2:
            [button setImage:[UIImage imageNamed:@"v320_id_verity_no"] forState:UIControlStateNormal];
            button.tag = BtnOnClickActionType_epVerityIng;
            break;
        case 3:
            [button setImage:[UIImage imageNamed:@"v320_ep_verity_yes"] forState:UIControlStateNormal];
            button.tag = BtnOnClickActionType_epVerityYES;
            break;
        case 4:
            [button setImage:[UIImage imageNamed:@"v320_id_verity_no"] forState:UIControlStateNormal];
            button.tag = BtnOnClickActionType_epVerityNO;
            break;
        default:
            break;
    }
}

- (void)btnOnClick:(UIButton *)sender{
    if ([self.delegate respondsToSelector:@selector(MyInfoCell_4:actionType:)]) {
        [self.delegate MyInfoCell_4:self actionType:sender.tag];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
