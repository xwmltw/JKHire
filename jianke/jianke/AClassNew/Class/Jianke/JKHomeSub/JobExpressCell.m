//
//  JobExpressCell.m
//  jianke
//
//  Created by xiaomk on 15/9/10.
//  Copyright (c) 2015年 xianshijian. All rights reserved.
//

#import "JobExpressCell.h"
#import "JobModel.h"
#import "WDConst.h"
#import "UIImageView+WebCache.h"

@interface JobExpressCell(){
    JobModel* _jobModel;
    
}
@property (weak, nonatomic) IBOutlet UIImageView *imgJobType;
@property (weak, nonatomic) IBOutlet UIImageView *imgIsAuth;
@property (weak, nonatomic) IBOutlet UILabel *labJobTItle;
@property (weak, nonatomic) IBOutlet UILabel *labSalaryValue;
@property (weak, nonatomic) IBOutlet UILabel *labSalaryUnit;
@property (weak, nonatomic) IBOutlet UILabel *labDate;
@property (weak, nonatomic) IBOutlet UILabel *labAddress;
@property (weak, nonatomic) IBOutlet UIImageView *imgHot;
@property (weak, nonatomic) IBOutlet UIImageView *imgApplyFull;
@property (weak, nonatomic) IBOutlet UIView *botLine;

@property (weak, nonatomic) IBOutlet UIImageView *iconImgView;

@property (weak, nonatomic) IBOutlet UIView *welfareView;
@property (strong, nonatomic) IBOutletCollection(UIImageView) NSArray *jobTagImageViewArray;

@property (weak, nonatomic) IBOutlet UIImageView *imgBao;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *layoutTitleLeft;
@property (weak, nonatomic) IBOutlet UIImageView *stcikImg;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *layoutStickLeft;

@end

@implementation JobExpressCell

+ (instancetype)cellWithTableView:(UITableView *)tableView{
    static NSString *identifier = @"JobExpressCell";
    JobExpressCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (!cell) {
        static UINib* _nib;
        if (!_nib) {
            _nib = [UINib nibWithNibName:@"JobExpressCell" bundle:nil];
        }
        
        if (_nib) {
            cell = [[_nib instantiateWithOwner:nil options:nil] objectAtIndex:0];
            for (UIImageView *imageView in cell.jobTagImageViewArray) {
                [imageView setCornerWithCorners:UIRectCornerAllCorners cornerRadii:CGSizeMake(2, 0)];
            }
        }
    }
    return cell;
}


- (void)refreshWithData:(JobModel*)model{
    [self refreshWithData:model andSearchStr:nil];
}

- (void)refreshWithData:(JobModel*)model andSearchStr:(NSString*)searchStr{
    if (model) {
        self.botLine.hidden = NO;
        if (self.isFromEpProfile && self.indexPath) {
            if (self.indexPath.row >= 4) {
                self.botLine.hidden = YES;
            }
        }
        
        _jobModel = model;
        self.layoutStickLeft.constant = 30;
        self.layoutTitleLeft.constant = 54;
        if (model.enable_recruitment_service.integerValue == 1) {
            self.imgBao.hidden = NO;
            if (model.stick.integerValue == 0) {
                self.stcikImg.hidden = YES;
                self.layoutTitleLeft.constant = 30;
            }else{
                self.stcikImg.hidden = NO;
            }
        }else{
            self.imgBao.hidden = YES;
            if (model.stick.integerValue == 0) {
                self.stcikImg.hidden = YES;
                self.layoutTitleLeft.constant = 8;
            }else{
                self.stcikImg.hidden = NO;
                self.layoutStickLeft.constant = 8;
                self.layoutTitleLeft.constant = 30;
            }
            
        }
        
        self.imgHot.hidden = model.hot.intValue != 1;
        self.imgIsAuth.hidden = model.job_post_ent_verify_status.intValue != 3;
        [self.imgJobType sd_setImageWithURL:[NSURL URLWithString:model.job_classfie_img_url] placeholderImage:[UIHelper getDefaultImage]];
        
        if (searchStr && searchStr.length > 0) {
            NSMutableAttributedString* attributeStr = [[NSMutableAttributedString alloc] initWithString:model.job_title];
            NSRange range = [model.job_title rangeOfString:searchStr];
            if (range.location != NSNotFound) {
                [attributeStr addAttribute:NSForegroundColorAttributeName value:[UIColor orangeColor] range:range];
                self.labJobTItle.attributedText = attributeStr;
            }else{
                self.labJobTItle.text = model.job_title;
            }
        }else{
            self.labJobTItle.text = model.job_title;
            if (model.isReaded) {
                self.labJobTItle.textColor = MKCOLOR_RGBA(42, 42, 42, 0.5);
            } else {
                self.labJobTItle.textColor = MKCOLOR_RGB(42, 42, 42);
            }
        }
 

        NSString *moneyStr = [NSString stringWithFormat:@"￥%.2f", model.salary.value.floatValue];
//        moneyStr = [moneyStr stringByReplacingOccurrencesOfString:@".0" withString:@""];
        
        NSMutableAttributedString *moneyAttrStr = [[NSMutableAttributedString alloc] initWithString:moneyStr attributes:@{NSFontAttributeName : [UIFont fontWithName:kFont_RSR size:20], NSForegroundColorAttributeName : MKCOLOR_RGB(255, 87, 34)}];
        [moneyAttrStr addAttribute:NSFontAttributeName value:[UIFont fontWithName:kFont_RSR size:12] range:NSMakeRange(0, 1)];
        [moneyAttrStr addAttribute:NSBaselineOffsetAttributeName value:@(6) range:NSMakeRange(0, 1)];
        
        self.labSalaryValue.attributedText = moneyAttrStr;
        self.labSalaryUnit.text = [NSString stringWithFormat:@"%@", model.salary.getTypeDesc];

        if (model.job_close_reason.integerValue == 3) {
            self.imgApplyFull.hidden = NO;
            self.imgApplyFull.image = [UIImage imageNamed:@"v3_tag_xiajia"];
        }else{
            self.imgApplyFull.image = [UIImage imageNamed:@"jk_home_applyfull"];
            self.imgApplyFull.hidden = model.has_been_filled.intValue != 1;
        }

        NSString* starTime = [DateHelper getDateWithNumber:model.work_time_start];
        NSString* endTime = [DateHelper getDateWithNumber:model.work_time_end];
        self.labDate.text = [NSString stringWithFormat:@"%@ 至 %@",starTime,endTime];
        self.labDate.font = [UIFont fontWithName:kFont_RSR size:14];
        
        if (model.distance) {
            int dis = model.distance.intValue;
            if (dis < 1000) {
                self.labAddress.text = [NSString stringWithFormat:@"%dm",dis];
            }else{
                float num = dis/1000;
                self.labAddress.text = [NSString stringWithFormat:@"%.1fkm",num];
            }
        }else{
            self.labAddress.text = model.working_place;
        }
        
        // 专题图标
        if (model.icon_status.integerValue == 1 && model.icon_url.length > 0) {
            [self.iconImgView sd_setImageWithURL:[NSURL URLWithString:model.icon_url]];
            self.iconImgView.hidden = NO;
        } else {
            self.iconImgView.hidden = YES;
        }
        
        // 福利保障View
        NSArray *jobTagList = [_jobModel.job_tags filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"check_status.integerValue == 1"]];
        if (jobTagList.count) {
            self.welfareView.hidden = NO;
            for (UIImageView *imageView in self.jobTagImageViewArray) {
                imageView.hidden = YES;
            }
            
            NSInteger count = jobTagList.count < self.jobTagImageViewArray.count ? jobTagList.count : self.jobTagImageViewArray.count;
            for (NSInteger i = self.jobTagImageViewArray.count ; i > 0; i--) {
                count --;
                if (count < 0) {
                    break;
                }
                WelfareModel* jobTagModel = jobTagList[count];
                UIImageView* imgView = self.jobTagImageViewArray[i-1];
                imgView.hidden = NO;
                [imgView sd_setImageWithURL:[NSURL URLWithString:jobTagModel.tag_img_url]];
            }
            
//            for (NSInteger i = 0; i < count; i++) {
//                WelfareModel *jobTag = jobTagList[i];
//                UIImageView *imageView = self.jobTagImageViewArray[i];
//                
//                imageView.hidden = NO;
//                [imageView sd_setImageWithURL:[NSURL URLWithString:jobTag.tag_img_url]];
//            }
        } else {
            self.welfareView.hidden = YES;
        }
    }
}

- (void)btnCloseSSPOnclick:(UIButton *)sender{
    [sender removeFromSuperview];
    if (self.delegate && [self.delegate respondsToSelector:@selector(jobExpressCell_closeSSPAD)]) {
        [self.delegate jobExpressCell_closeSSPAD];
    }
}

- (void)awakeFromNib {
    [super awakeFromNib];
    [self.imgJobType setCornerValue:25.0f];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
