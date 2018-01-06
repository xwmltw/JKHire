//
//  HiringJobNumCell.m
//  JKHire
//
//  Created by yanqb on 2017/2/8.
//  Copyright © 2017年 xianshijian. All rights reserved.
//

#import "HiringJobNumCell.h"
#import "ResponseInfo.h"
#import "DateHelper.h"
#import "UserData.h"

@interface HiringJobNumCell ()

@property (weak, nonatomic) IBOutlet UILabel *labTitle;
@property (weak, nonatomic) IBOutlet UILabel *labTitleNum;
@property (weak, nonatomic) IBOutlet UILabel *labFreeNum;
@property (weak, nonatomic) IBOutlet UIButton *btnVip;
@property (weak, nonatomic) IBOutlet UIButton *btnQuestion;
@property (weak, nonatomic) IBOutlet UILabel *labBuyNum;
@property (weak, nonatomic) IBOutlet UILabel *labFreeDes;
@property (weak, nonatomic) IBOutlet UIButton *btnBuy;
@property (weak, nonatomic) IBOutlet UIButton *btnDrop;

- (IBAction)btnQuestionOnClick:(id)sender;
- (IBAction)btnOnClick:(id)sender;
- (IBAction)btnVipOnClick:(id)sender;

@end

@implementation HiringJobNumCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.backgroundColor = [UIColor whiteColor];
    self.clipsToBounds = YES;
    
    self.btnVip.tag =  BtnOnClickActionType_Vip;
    self.btnBuy.tag = BtnOnClickActionType_recruitJobHistory;
    self.btnDrop.tag = BtnOnClickActionType_dropAction;
    
    [self.btnDrop setImage:[UIImage imageNamed:@"jiantou_up_icon_16"] forState:UIControlStateSelected];
    [self.btnDrop addTarget:self action:@selector(btnDropOnClick:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)setModel:(RecruitJobNumInfo *)model{
    self.labTitle.text = [NSString stringWithFormat:@"您在%@拥有的在招岗位总数：", [UserData sharedInstance].city.name];
    self.labTitleNum.text = [NSString stringWithFormat:@"%ld个", model.all_recruit_job_num.integerValue];
    
    if (!model.vip_recruit_job_num_info || !model.vip_recruit_job_num_info.vip_type) {
        self.btnVip.hidden = YES;
        self.btnQuestion.hidden = NO;
        self.labFreeDes.text = @"免费在招岗位数：";
        self.labFreeNum.text = [NSString stringWithFormat:@"%ld个", model.free_recruit_job_num.integerValue];
    }else{
        self.labFreeDes.text = @"VIP特权享受的在招岗位数：";
        self.labFreeNum.text = [NSString stringWithFormat:@"%ld个", (model.vip_recruit_job_num_info.all_vip_recruit_job_num.integerValue + model.free_recruit_job_num.integerValue)];
        self.btnVip.hidden = NO;
        self.btnQuestion.hidden = YES;
    }
    
    if (!model.recharge_recruit_job_num_info || model.recharge_recruit_job_num_info.all_recharge_recruit_job_num.integerValue == 0) {
        self.labBuyNum.text = @"0个";
        self.btnBuy.hidden = YES;
    }else{
        self.btnBuy.hidden = NO;
        self.labBuyNum.text = [NSString stringWithFormat:@"%ld个", model.recharge_recruit_job_num_info.all_recharge_recruit_job_num.integerValue];
    }
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)btnQuestionOnClick:(id)sender {
    [MKAlertView alertWithTitle:nil message:@"每个城市免费赠送1个在招岗位" cancelButtonTitle:nil confirmButtonTitle:@"知道啦" completion:^(UIAlertView *alertView, NSInteger buttonIndex) {
        
    }];
}

- (IBAction)btnOnClick:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(HiringJobNumCell:actionType:)]) {
        [self.delegate HiringJobNumCell:self actionType:sender.tag];
    }
}

- (IBAction)btnVipOnClick:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(HiringJobNumCell:actionType:)]) {
        [self.delegate HiringJobNumCell:self actionType:sender.tag];
    }
}

- (void)btnDropOnClick:(UIButton *)sender{
    sender.selected = !sender.selected;
    if ([self.delegate respondsToSelector:@selector(HiringJobNumCell:isDropDownDirect:)]) {
        [self.delegate HiringJobNumCell:self isDropDownDirect:sender.selected];
    }
}

@end
