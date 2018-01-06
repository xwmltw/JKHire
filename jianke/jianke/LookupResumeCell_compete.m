//
//  LookupResumeCell_compete.m
//  jianke
//
//  Created by yanqb on 2017/5/23.
//  Copyright © 2017年 xianshijian. All rights reserved.
//

#import "LookupResumeCell_compete.h"
#import "WDConst.h"

@interface LookupResumeCell_compete ()

@property (weak, nonatomic) IBOutlet UILabel *labTitle;
@property (weak, nonatomic) IBOutlet UIButton *btnResumeOpen;


@end

@implementation LookupResumeCell_compete

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    [self.btnResumeOpen setCornerValue:16.0f];
    self.btnResumeOpen.hidden = YES;
    [self.btnResumeOpen setTitle:@"简历公开" forState:UIControlStateNormal];
    [self.btnResumeOpen setTitleColor:[UIColor XSJColor_base] forState:UIControlStateNormal];
    [self.btnResumeOpen setImage:[UIImage imageNamed:@"v324_unlock_icon"] forState:UIControlStateNormal];
    
    [self.btnResumeOpen setTitle:@"简历保密" forState:UIControlStateSelected];
    [self.btnResumeOpen setTitleColor:[UIColor XSJColor_middelRed] forState:UIControlStateSelected];
    [self.btnResumeOpen setImage:[UIImage imageNamed:@"v324_lock_icon"] forState:UIControlStateSelected];
    [self.btnResumeOpen addTarget:self action:@selector(btnOnClick:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)setModel:(JKModel *)model{
    if (model) {
        if (model.complete) {
            self.labTitle.text = [NSString stringWithFormat:@"简历完整度%@%%", model.complete];
        }else{
            self.labTitle.text = [NSString stringWithFormat:@"简历完整度0%%"];
        }
        self.btnResumeOpen.hidden = NO;
        if (model.is_public.integerValue == 1) {
            self.labTitle.textColor = [UIColor XSJColor_base];
            self.btnResumeOpen.selected = NO;
            [self.btnResumeOpen setTitle:@"简历公开" forState:UIControlStateNormal];
            self.btnResumeOpen.backgroundColor = MKCOLOR_RGB(231, 247, 250);
        }else{
            self.labTitle.textColor = [UIColor XSJColor_middelRed];
            self.btnResumeOpen.selected = YES;
            self.btnResumeOpen.backgroundColor = MKCOLOR_RGBA(255, 97, 142, 0.08);
        }
    }
}

- (void)btnOnClick:(UIButton *)sender{
    if ([self.delegate respondsToSelector:@selector(LookupResumeCell_compete:)]) {
        [self.delegate LookupResumeCell_compete:self];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
