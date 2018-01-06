//
//  MyInfoCell_new.m
//  JKHire
//
//  Created by fire on 16/11/4.
//  Copyright © 2016年 xianshijian. All rights reserved.
//

#import "MyInfoCell_new.h"
#import "EPModel.h"
#import "WDConst.h"

@interface MyInfoCell_new ()
@property (weak, nonatomic) IBOutlet UIImageView *imgIcon;

@end

@implementation MyInfoCell_new

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    [self.btnIM addTarget:self action:@selector(btnOnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.btnCall addTarget:self action:@selector(btnOnClick:) forControlEvents:UIControlEventTouchUpInside];
    self.btnIM.tag = BtnOnClickActionType_makeIm;
    self.btnCall.tag = BtnOnClickActionType_makeCall;
}

- (void)setEpInfo:(EPModel *)epInfo{
    _epInfo = epInfo;
    self.labNum.hidden = YES;
    self.labNum.textColor = [UIColor XSJColor_tGrayDeepTransparent3];
    self.btnCall.hidden = YES;
    self.btnIM.hidden = YES;
    self.imgIcon.hidden = NO;
    switch (_cellType) {
        case EPMyInfoCellType_myFans:{
            self.labTitle.text = @"我的粉丝";
            if (_epInfo && _epInfo.stu_fans_count.integerValue != 0) {
                self.labNum.hidden = NO;
                self.labNum.text = _epInfo.stu_fans_count.description;
            }
        }
            break;
        case EPMyInfoCellType_QACenter:{
            self.labTitle.text = @"教程攻略";
        }
            break;
        case EPMyInfoCellType_editService:{
            self.labTitle.text = @"服务商信息";
        }
            break;
        case EPMyInfoCellType_reciveServiceOrder:{
            self.labTitle.text = @"收到订单";
            if (_epInfo) {
                self.labNum.hidden = NO;
                self.labNum.text = _epInfo.service_team_apply_ordered_count.description;
            }
        }
            break;
        case EPMyInfoCellType_postedServiceList:{
            self.labTitle.text = @"发布的服务";
            if (_epInfo) {
                self.labNum.hidden = NO;
                self.labNum.text = _epInfo.service_team_apply_count.description;
            }
        }
            break;
        case EPMyinfoCellType_aboutApp:{
            self.labTitle.text = @"关于优聘";
        }
            break;
        case EPMyInfoCellType_contact:{
            self.labTitle.text = @"联系客服";
//            NSString *telphone = [[XSJRequestHelper sharedInstance] getClientGlobalModel].consumer_hotline;
//            if (telphone.length) {
//                NSAttributedString *attStr = [[NSAttributedString alloc] initWithString:telphone attributes:@{NSUnderlineStyleAttributeName: @(NSUnderlineStyleSingle), NSUnderlineColorAttributeName: [UIColor XSJColor_base], NSFontAttributeName: [UIFont systemFontOfSize:15.0f], NSForegroundColorAttributeName: [UIColor XSJColor_base]}];
//                [self.btnCall setAttributedTitle:attStr forState:UIControlStateNormal];
                self.btnCall.hidden = NO;
                self.btnIM.hidden = NO;
//            }
            self.imgIcon.hidden = YES;
        }
            break;
        case EPMyInfoCellType_vip:{
            self.btnCall.tag = BtnOnClickActionType_makeCall;
            self.labTitle.text = @"VIP会员";
            self.labNum.hidden = NO;
            self.labNum.text = @"招聘效果提升370%";
            self.labNum.textColor = [UIColor XSJColor_middelRed];
        }
            break;
        case EPMyInfoCellType_vasService:{
            self.labTitle.text = @"付费推广";
            self.labNum.text = @"曝光量提升2-5倍";
            self.labNum.textColor = [UIColor XSJColor_middelRed];
            self.labNum.hidden = NO;
        }
            break;
        case EPMyInfoCellType_RecruitJob:{
            self.labTitle.text = @"在招岗位数";
            if ([UserData sharedInstance].recruitJobNumInfo) {
                self.labNum.hidden = NO;
                self.labNum.text = [UserData sharedInstance].recruitJobNumInfo.all_recruit_job_num.description;
            }
        }
            break;
        case EPMyInfoCellType_EPService:{
            self.labTitle.text = @"服务商入口";
        }
            break;
        case EPMyInfoCellType_switchToJK:{
            self.labTitle.text = @"找兼职入口";
        }
            break;
        case EPMyInfoCellType_baozhao:{
            self.labTitle.text = @"包代招";
            self.labNum.text = @"解决招聘难题";
            self.labNum.textColor = [UIColor XSJColor_middelRed];
            self.labNum.hidden = NO;
        }
            break;
        case EPMyInfoCellType_CustomeService:{
            self.labTitle.text = @"定制服务";
            self.labNum.text = @"兼客众包、熊地推";
            self.labNum.hidden = NO;
        }
            break;
        default:
            break;
    }
}

- (void)btnOnClick:(UIButton *)sender{
    if ([self.delegate respondsToSelector:@selector(myInfoCellNew:actionType:)]) {
        [self.delegate myInfoCellNew:self actionType:sender.tag];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
