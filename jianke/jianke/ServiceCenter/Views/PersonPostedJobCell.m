//
//  PersonPostedJobCell.m
//  JKHire
//
//  Created by fire on 16/10/13.
//  Copyright © 2016年 xianshijian. All rights reserved.
//

#import "PersonPostedJobCell.h"
#import "DateHelper.h"
#import "WDConst.h"
#import "ModelManage.h"

@interface PersonPostedJobCell ()

@property (weak, nonatomic) IBOutlet UILabel *labTitle;
@property (weak, nonatomic) IBOutlet UILabel *labInvite;
@property (weak, nonatomic) IBOutlet UILabel *labSuggest;
@property (weak, nonatomic) IBOutlet UILabel *labCreate;
@property (weak, nonatomic) IBOutlet UIButton *btnInvite;
@property (weak, nonatomic) IBOutlet UIImageView *imgPush;
@property (weak, nonatomic) IBOutlet UILabel *labStatus;
@property (weak, nonatomic) IBOutlet UILabel *labTag;
@property (weak, nonatomic) IBOutlet UILabel *redPoint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *layoutLabTitleLeft;


- (IBAction)btnInviteOnClick:(UIButton *)sender;


@end

@implementation PersonPostedJobCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    [self.btnInvite setCornerValue:2.0f];
    [self.btnInvite setBorderWidth:1.0f andColor:[UIColor XSJColor_tGrayDeepTinge]];
    
    [self.labTag setCornerValue:2.0f];
    [self.labTag setBorderWidth:1.0f andColor:[UIColor XSJColor_base]];
    
    [self.redPoint setCornerValue:5.0f];
}

- (void)setModel:(JobModel *)model{
    _model = model;
    if (self.isFromPersonManage) {
        self.btnInvite.hidden = YES;
        self.imgPush.hidden = NO;
        self.labStatus.hidden = NO;
        self.labStatus.text = (model.status.integerValue == 1) ? @"招聘中" : @"已结束" ;
        self.labTag.text = [NSString stringWithFormat:@"  %@  ", [ModelManage getJobTagNameWithServiceType:model.service_type]];
        self.layoutLabTitleLeft.constant = [self.labTag contentSizeWithWidth:SCREEN_WIDTH].width + 20;
        self.redPoint.hidden = (model.accept_apply_small_red_point.integerValue != 1);
    }else{
        self.labTag.hidden = YES;
        self.redPoint.hidden = YES;
    }
    
    self.labTitle.text = model.service_title;
    self.labInvite.text = [NSString stringWithFormat:@"已邀约%@人,%@人接单", model.invite_num, model.accept_invite_num];
    if (model.platform_invite_accept_num.integerValue) {
        self.labSuggest.hidden = NO;
        self.labSuggest.text = [NSString stringWithFormat:@"平台推荐%@人", model.platform_invite_accept_num];
        model.cellHeight = 127.0f;
    }else{
        self.labSuggest.hidden = YES;
        model.cellHeight = 107.0f;
    }
    self.labCreate.text = [NSString stringWithFormat:@"订单创建于: %@", [DateHelper getDateFromTimeNumber:model.create_time withFormat:@"yyyy/M/dd"]];
    if (model.is_invite_this_stu.integerValue == 1) {
        [self.btnInvite setTitle:@"已邀约" forState:UIControlStateNormal];
        self.btnInvite.userInteractionEnabled = NO;
    }else{
        [self.btnInvite setTitle:@"邀约" forState:UIControlStateNormal];
        self.btnInvite.userInteractionEnabled = YES;
    }
}

- (IBAction)btnInviteOnClick:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(inviteActionWithJobModel:)]) {
        [self.delegate inviteActionWithJobModel:_model];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
