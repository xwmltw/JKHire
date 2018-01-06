//
//  PostedService_cell.m
//  JKHire
//
//  Created by yanqb on 16/11/8.
//  Copyright © 2016年 xianshijian. All rights reserved.
//

#import "PostedService_cell.h"
#import "ResponseInfo.h"
#import "WDConst.h"

@interface PostedService_cell (){
    ServiceTeamApplyModel *_model;
}

@property (weak, nonatomic) IBOutlet UIImageView *imghead;
@property (weak, nonatomic) IBOutlet UILabel *labTitle;
@property (weak, nonatomic) IBOutlet UILabel *labCase;
@property (weak, nonatomic) IBOutlet UILabel *labAddress;
@property (weak, nonatomic) IBOutlet UILabel *labTime;
@property (weak, nonatomic) IBOutlet UIButton *btnEdite;
@property (weak, nonatomic) IBOutlet UIImageView *imgPushIcon;

@property (weak, nonatomic) IBOutlet UIImageView *imgStatus;

- (IBAction)btnEditOnClick:(UIButton *)sender;


@end

@implementation PostedService_cell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self.imghead setCornerValue:25.0f];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)setModel:(ServiceTeamApplyModel *)model{
    _model = model;
    [self.imghead sd_setImageWithURL:[NSURL URLWithString:model.service_classify_img_url] placeholderImage:[UIHelper getDefaultImage]];
    self.labTitle.text = model.service_classify_name.length ? model.service_classify_name : @"";
    self.labCase.text = [NSString stringWithFormat:@"%@条成功案例", model.experience_count];
    self.labAddress.text = [DateHelper getDateFromTimeNumber:model.create_time withFormat:@"M/dd"];
    self.labTime.text = [DateHelper getDateFromTimeNumber:model.create_time withFormat:@"HH:mm"];
    self.btnEdite.hidden = NO;
    self.imgPushIcon.hidden = NO;
    switch (model.status.integerValue) { // 状态 1申请中 2已通过 3未通过
        case 1:{
            self.btnEdite.hidden = YES;
            self.imgStatus.image = [UIImage imageNamed:@"allpy_service_status_ing"];
        }
            break;
        case 2:{
            self.imgStatus.image = [UIImage imageNamed:@"allpy_service_status_post"];
        }
            break;
        case 3:{
            self.imgStatus.image = [UIImage imageNamed:@"allpy_service_status_no"];
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

- (IBAction)btnEditOnClick:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(editOnClickWithModel:)]) {
        [self.delegate editOnClickWithModel:_model];
    }
}
@end
