//
//  HistoryTeamJobCell.m
//  JKHire
//
//  Created by fire on 16/10/15.
//  Copyright © 2016年 xianshijian. All rights reserved.
//

#import "HistoryTeamJobCell.h"
#import "WDConst.h"
#import "TeamJobModel.h"
#import "ResponseInfo.h"

@interface HistoryTeamJobCell (){
    NSIndexPath *_indexPath;
}

@property (weak, nonatomic) IBOutlet UILabel *labTitle;
@property (weak, nonatomic) IBOutlet UILabel *labInvite;
@property (weak, nonatomic) IBOutlet UILabel *labView;
@property (weak, nonatomic) IBOutlet UIButton *btnInvite;
@property (weak, nonatomic) IBOutlet UIImageView *imgPush;
@property (weak, nonatomic) IBOutlet UILabel *labCreate;
@property (weak, nonatomic) IBOutlet UILabel *labTag;
@property (weak, nonatomic) IBOutlet UIView *botLine;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *layoutLabTitleLeft;

- (IBAction)BtnInviteOnClick:(UIButton *)sender;

@end

@implementation HistoryTeamJobCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self.btnInvite setCornerValue:2.0f];
    [self.btnInvite setBorderWidth:1.0f andColor:[UIColor XSJColor_tGrayDeepTinge]];
    [self.labTag setCornerValue:2.0f];
    [self.labTag setBorderWidth:1.0f andColor:[UIColor XSJColor_base]];
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)setModel:(TeamJobModel *)model atIndexPath:(NSIndexPath *)indexPath{
    _indexPath = indexPath;
    self.btnInvite.hidden = !self.isFromHitoryJob;
    self.labTitle.text = model.service_title.length ? model.service_title : model.service_classify_name;
    self.labInvite.text = [NSString stringWithFormat:@"已预约%@家服务商", model.order_count];
    NSString *dateStr = [DateHelper getDateFromTimeNumber:model.create_time withFormat:@"yyyy/M/dd"];
    self.labCreate.text = [NSString stringWithFormat:@"订单创建于: %@",dateStr];
    if (self.isFromHitoryJob) {
        self.imgPush.hidden = YES;
        self.labView.hidden = YES;
        self.labTag.hidden = YES;
    }else{
        self.labView.text = (model.status.integerValue == 1) ? @"招聘中" : @"已结束" ;
        self.labTag.text = [NSString stringWithFormat:@"  %@  ", model.service_classify_name];
        self.layoutLabTitleLeft.constant = [self.labTag contentSizeWithWidth:SCREEN_WIDTH].width + 20;
    }
    
    if (model.is_order_this_team.integerValue == 1) {
        [self.btnInvite setTitle:@"已预约" forState:UIControlStateNormal];
        self.btnInvite.userInteractionEnabled = NO;
    }else{
        [self.btnInvite setTitle:@"预约" forState:UIControlStateNormal];
        self.btnInvite.userInteractionEnabled = YES;
    }
}

- (void)setTeamCompanyModel:(TeamCompanyModel *)model{
    self.btnInvite.hidden = YES;
    self.labTag.hidden = YES;
    self.labTitle.text = model.service_team_job.service_title.length ? model.service_team_job.service_title : model.service_team_job.service_classify_name;
    self.labInvite.text = model.orderer_basic_info.enterprise_name;
    self.labView.text = (model.ordered_read_status.integerValue == 1) ? @"跟进中" : @"未查看" ;
    NSString *dateStr = [DateHelper getDateFromTimeNumber:model.service_team_job.create_time withFormat:@"yyyy/M/dd"];
    self.labCreate.text = [NSString stringWithFormat:@"订单创建于: %@",dateStr];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)BtnInviteOnClick:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(btnInviteOnClickAtIndexpath:)]) {
        [self.delegate btnInviteOnClickAtIndexpath:_indexPath];
    }
}
@end
