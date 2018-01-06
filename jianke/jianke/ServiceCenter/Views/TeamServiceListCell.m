//
//  TeamServiceListCell.m
//  JKHire
//
//  Created by fire on 16/10/14.
//  Copyright © 2016年 xianshijian. All rights reserved.
//

#import "TeamServiceListCell.h"
#import "ResponseInfo.h"
//#import "UIImageView+WebCache.h"
#import "WDConst.h"

@interface TeamServiceListCell ()

@property (weak, nonatomic) IBOutlet UIImageView *imgProfile;
@property (weak, nonatomic) IBOutlet UILabel *lanTitle;
@property (weak, nonatomic) IBOutlet UILabel *labLeft;
@property (weak, nonatomic) IBOutlet UILabel *labright;
@property (weak, nonatomic) IBOutlet UILabel *labOrder;


@end

@implementation TeamServiceListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    [self.imgProfile setCornerValue:26.0f];
}

- (void)setModel:(ServiceTeamModel *)model{
    model.cellHeight = 102.0f;
    [self.imgProfile sd_setImageWithURL:[NSURL URLWithString:model.service_profile_url] placeholderImage:[UIHelper getDefaultHead]];
    self.lanTitle.text = model.ent_name;
    self.labLeft.text = model.experience_count ? [NSString stringWithFormat:@"%ld条成功案例", (long)model.experience_count.integerValue] : @"0条成功案例";
    self.labright.text = model.city_name;
    self.labOrder.hidden = (model.ordered_count.integerValue == 0);
    if (model.ordered_count.integerValue) {
        model.cellHeight += 30;
    }
    self.labOrder.text = [NSString stringWithFormat:@"%@人预约过", model.ordered_count.description];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
