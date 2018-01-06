//
//  JKMangeHeadView.m
//  jianke
//
//  Created by fire on 16/9/6.
//  Copyright © 2016年 xianshijian. All rights reserved.
//

#import "JKMangeHeadView.h"
#import "JobDetailModel.h"
#import "WDConst.h"

@interface JKMangeHeadView ()


@property (weak, nonatomic) IBOutlet UILabel *viewNumLab;
@property (weak, nonatomic) IBOutlet UILabel *accNumLab;
@property (weak, nonatomic) IBOutlet UILabel *labUpForPush;
@property (weak, nonatomic) IBOutlet UILabel *labBaoguang;
@property (weak, nonatomic) IBOutlet UILabel *labBaoguangNum;

- (IBAction)btnOnclick:(id)sender;

@end

@implementation JKMangeHeadView
- (void)awakeFromNib{
    [super awakeFromNib];
    [self.labUpForPush setCornerValue:10.0f];
    [self.labBaoguang setCornerValue:10.0f];
}

- (void)setData:(JobDetailModel *)model{
    self.labUpForPush.hidden = YES;
    self.labBaoguang.hidden = YES;
    if (model) {
        [self.titleBtn setTitle:model.parttime_job.job_title forState:UIControlStateNormal];
        self.viewNumLab.text = model.parttime_job.view_count ? model.parttime_job.view_count.stringValue : @"0" ;
        self.labBaoguangNum.text = model.parttime_job.exposure_count ? model.parttime_job.exposure_count.description : @"0";
        if (model.parttime_job.source.integerValue == 1) {
            self.accNumLab.text = @"0";
        }else{
            self.accNumLab.text = model.apply_job_resumes_count ? model.apply_job_resumes_count.stringValue : @"0" ;
        }
        if (model.parttime_job.is_show_vas_count.integerValue == 1) {
            if (model.parttime_job.job_vas_view_count.integerValue) {
                self.labUpForPush.hidden = NO;
                self.labUpForPush.text = [NSString stringWithFormat:@"+%ld↑", (long)model.parttime_job.job_vas_view_count.integerValue];
            }
        }
        if (model.parttime_job.job_vas_exposure_num.integerValue) {
            self.labBaoguang.hidden = NO;
            self.labBaoguang.text = [NSString stringWithFormat:@"+%ld↑", (long)model.parttime_job.job_vas_exposure_num.integerValue];
        }
    }
}

- (IBAction)btnOnclick:(id)sender {
    if ([self.delegate respondsToSelector:@selector(jkHeadView:btnOnClick:)]) {
        [self.delegate jkHeadView:self btnOnClick:sender];
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
