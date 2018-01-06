//
//  JKAppreciteCell_Job.m
//  JKHire
//
//  Created by yanqb on 2017/4/5.
//  Copyright © 2017年 xianshijian. All rights reserved.
//

#import "JKAppreciteCell_Job.h"
#import "WDConst.h"

@interface JKAppreciteCell_Job ()

@property (weak, nonatomic) IBOutlet UILabel *labTitle;
@property (weak, nonatomic) IBOutlet UIImageView *imgIcon;
@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UIButton *btn;
@property (weak, nonatomic) IBOutlet UILabel *labJob;
- (IBAction)btnOnClick:(id)sender;


@end

@implementation JKAppreciteCell_Job

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.clipsToBounds = YES;
    [self.bgView setCornerValue:2.0f];
    [self.bgView setBorderWidth:1.0f andColor:[UIColor XSJColor_tGrayDeepTransparent32]];
}

- (void)setModel:(NSString *)model cellType:(AppreciationType)cellType isEditable:(BOOL)isEditable{
    self.labJob.hidden = YES;
    if (model.length) {
        self.labJob.hidden = NO;
        self.labJob.text = model;
    }
    if (isEditable) {
        self.labTitle.textColor = [UIColor XSJColor_tGrayDeepTinge];
        self.imgIcon.hidden = NO;
        self.btn.userInteractionEnabled = YES;
        switch (cellType) {
            case Appreciation_push_Type:{
                self.labTitle.text = @"请选择要推送的岗位(必选项)";
            }
                break;
            case Appreciation_stick_Type:{
                self.labTitle.text = @"请选择要置顶的岗位(必选项)";
            }
                break;
            case Appreciation_Refresh_Type:
            case Appreciation_autoRefresh_Type:{
                self.labTitle.text = @"请选择要刷新的岗位(必选项)";
            }
                break;
            default:
                break;
        }
    }else{
        self.labTitle.textColor = [UIColor XSJColor_tGrayDeepTransparent48];
        self.imgIcon.hidden = YES;
        self.btn.userInteractionEnabled = NO;
        switch (cellType) {
            case Appreciation_push_Type:{
                self.labTitle.text = @"推送的岗位";
            }
                break;
            case Appreciation_stick_Type:{
                self.labTitle.text = @"置顶的岗位";
            }
                break;
            case Appreciation_Refresh_Type:{
                self.labTitle.text = @"刷新的岗位";
            }
                break;
            default:
                break;
        }
    }
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)btnOnClick:(id)sender {
    if ([self.delegate respondsToSelector:@selector(jkAppreciteCell:)]) {
        [self.delegate jkAppreciteCell:self];
    }
}
@end
