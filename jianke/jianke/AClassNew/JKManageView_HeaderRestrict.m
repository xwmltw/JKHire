
//
//  JKManageView_HeaderRestrict.m
//  JKHire
//
//  Created by xuzhi on 2017/4/10.
//  Copyright © 2017年 xianshijian. All rights reserved.
//

#import "JKManageView_HeaderRestrict.h"
#import "BaseButton.h"
#import "WDConst.h"
#import "JobDetailModel.h"

@interface JKManageView_HeaderRestrict ()

@property (weak, nonatomic)  UILabel *viewNumLab;
@property (weak, nonatomic)  UILabel *labUpForPush;
@property (weak, nonatomic)  UILabel *labBaoguang;
@property (weak, nonatomic)  UILabel *labBaoguangNum;
@property (weak, nonatomic)  BaseButton *titleBtn;

@end

@implementation JKManageView_HeaderRestrict

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupViews];
    }
    return self;
}

- (void)setupViews{
    BaseButton *titleBtn = [BaseButton buttonWithType:UIButtonTypeCustom];
    _titleBtn = titleBtn;
    titleBtn.titleLabel.font = [UIFont systemFontOfSize:16.0f];
    [titleBtn setTitleColor:[UIColor XSJColor_tGrayHistoyTransparent64] forState:UIControlStateNormal];
    [titleBtn setImage:[UIImage imageNamed:@"job_icon_push"] forState:UIControlStateNormal];
    [titleBtn addTarget:self action:@selector(btnOnClick:) forControlEvents:UIControlEventTouchUpInside];
    [titleBtn setMarginForImg:-16 marginForTitle:16];
    
    UIView *line = [[UIView alloc] init];
    line.backgroundColor = [UIColor XSJColor_clipLineGray];
    
    UILabel *labBaoguangNum = [UILabel labelWithText:@"" textColor:[UIColor XSJColor_tGrayDeepTinge] fontSize:32.0f];
    labBaoguangNum.textAlignment = NSTextAlignmentCenter;
    _labBaoguangNum = labBaoguangNum;
    UILabel *labBaoguang = [UILabel labelWithText:@"" textColor:[UIColor whiteColor] fontSize:12.0f];
    [labBaoguang setCornerValue:10.0f];
    _labBaoguang = labBaoguang;
    UILabel *labBaoguangDes = [UILabel labelWithText:@"曝光次数" textColor:[UIColor XSJColor_tGrayDeepTinge] fontSize:14.0f];
    
    UILabel *viewNumLab = [UILabel labelWithText:@"" textColor:[UIColor XSJColor_tGrayDeepTinge] fontSize:32.0f];
    viewNumLab.textAlignment = NSTextAlignmentCenter;
    _viewNumLab = viewNumLab;
    UILabel *labUpForPush = [UILabel labelWithText:@"" textColor:[UIColor whiteColor] fontSize:12.0f];
    [labUpForPush setCornerValue:10.0f];
    _labUpForPush = labUpForPush;
    UILabel *labViewNumDes = [UILabel labelWithText:@"浏览次数" textColor:[UIColor XSJColor_tGrayDeepTinge] fontSize:14.0f];
    
    [self addSubview:_titleBtn];
    [self addSubview:line];
    [self addSubview:labBaoguang];
    [self addSubview:labBaoguangNum];
    [self addSubview:labBaoguangDes];
    [self addSubview:viewNumLab];
    [self addSubview:labUpForPush];
    [self addSubview:labViewNumDes];
    
    [_titleBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self);
        make.height.equalTo(@57);
    }];
    
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_titleBtn.mas_bottom);
        make.left.right.equalTo(self);
        make.height.equalTo(@0.7);
    }];
    
    [labBaoguangNum mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(line.mas_bottom).offset(24);
        make.left.equalTo(self);
        make.width.equalTo(viewNumLab);
    }];
    
    [viewNumLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(labBaoguangNum);
        make.left.equalTo(labBaoguangNum.mas_right);
        make.right.equalTo(self);
    }];
    
    [labBaoguang mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(labBaoguangNum).offset(20);
        make.bottom.equalTo(labBaoguangNum.mas_top).offset(-7);
        make.height.equalTo(@21);
    }];
    
    [labUpForPush mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(viewNumLab).offset(20);
        make.bottom.equalTo(viewNumLab.mas_top).offset(-7);
        make.height.equalTo(@21);
    }];
    
    [labBaoguangDes mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(labBaoguangNum.mas_bottom);
        make.centerX.equalTo(labBaoguangNum);
    }];
    
    [labViewNumDes mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(labBaoguangDes);
        make.centerX.equalTo(viewNumLab);
    }];
    
}

- (void)setData:(JobDetailModel *)model{
    self.labUpForPush.hidden = YES;
    self.labBaoguang.hidden = YES;
    if (model) {
        [self.titleBtn setTitle:model.parttime_job.job_title forState:UIControlStateNormal];
        self.viewNumLab.text = model.parttime_job.view_count ? model.parttime_job.view_count.stringValue : @"0" ;
        self.labBaoguangNum.text = model.parttime_job.exposure_count ? model.parttime_job.exposure_count.description : @"0";
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

- (void)btnOnClick:(UIButton *)sender{
    if ([self.delegate respondsToSelector:@selector(JKManageView_HeaderRestrict:)]) {
        [self.delegate JKManageView_HeaderRestrict:self];
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
