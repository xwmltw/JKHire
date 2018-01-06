//
//  InvitingForJobCell.m
//  jianke
//
//  Created by xiaomk on 15/9/15.
//  Copyright (c) 2015年 xianshijian. All rights reserved.
//

#import "InvitingForJobCell.h"
#import "JobModel.h"
#import "UIHelper.h"
#import "WDConst.h"
#import "ApplyJobResumeModel.h"

@interface InvitingForJobCell() <UIScrollViewDelegate>
{
    NSMutableArray *_applyJKArray;
    BOOL _isShowBtnView;
    JobModel* _jobModel;
    NSIndexPath *_indexPath;
    NSArray* _dataArray;
    NSInteger _nowSelect;   //首页显示的 当前天 如果没有当前天 就显示下一天
    int _todayNum;    //精确的 是否是当天 ，否则为 -1；
    CGFloat _pageWidth;
    NSMutableArray* _labArray;
}


@property (weak, nonatomic) IBOutlet NSLayoutConstraint *layoutTitleLeft;
@property (weak, nonatomic) IBOutlet UILabel *labTitle;
@property (weak, nonatomic) IBOutlet UIImageView *imgDaifa;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *layoutImgDaifaLeft;


@property (weak, nonatomic) IBOutlet UIView *viewMid;
@property (weak, nonatomic) IBOutlet UILabel *labAddress;   /*!< 地址 */
@property (weak, nonatomic) IBOutlet UILabel *labDate;      /*!< 时间 */


@property (weak, nonatomic) IBOutlet UIButton *btnApplyHead_1;
@property (weak, nonatomic) IBOutlet UIButton *btnApplyHead_2;
@property (weak, nonatomic) IBOutlet UIButton *btnApplyHead_3;


@property (weak, nonatomic) IBOutlet UIView *samll_red_point_1;
@property (weak, nonatomic) IBOutlet UIView *samll_red_point_2;
@property (weak, nonatomic) IBOutlet UIView *samll_red_point_3;


@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *headArray;
@property (nonatomic, copy) NSArray *btnApplyArray;
@property (nonatomic, copy) NSArray *redPointArray;

@property (strong, nonatomic) IBOutletCollection(UIView) NSArray *smallRedPointArray;
@property (weak, nonatomic) IBOutlet UILabel *applyNumLab;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *layoutApplyNumLeftConstraint;


@property (weak, nonatomic) IBOutlet UILabel *hireNumLab;
@property (weak, nonatomic) IBOutlet UIImageView *spamLab;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *layoutTitleRightConstraint;
@property (weak, nonatomic) IBOutlet UIButton *moreActionBtn;

@property (weak, nonatomic) IBOutlet UILabel *labGuarantee;
@property (weak, nonatomic) IBOutlet UILabel *topTagLab;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *layoutSpamLeftConstraint;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *layoutMiddleViewHeight;    //75 or 52
@property (weak, nonatomic) IBOutlet UIButton *btnClose;
@property (weak, nonatomic) IBOutlet UIButton *btnRefresh;
@property (weak, nonatomic) IBOutlet UIButton *btnStick;


- (IBAction)btnShowSheet:(id)sender;

@property (weak, nonatomic) IBOutlet UILabel *salaryLabel;

@end
@implementation InvitingForJobCell


+ (instancetype)cellWithTableView:(UITableView *)tableView{
    static NSString *identifier = @"InvitingForJobCell";
    InvitingForJobCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (!cell) {
        static UINib* _nib;
        if (!_nib) {
            _nib = [UINib nibWithNibName:@"InvitingForJobCell" bundle:nil];
        }
        
        if (_nib) {
            cell = [[_nib instantiateWithOwner:nil options:nil] objectAtIndex:0];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return cell;
}

- (void)refreshWithData:(JobModel *)model atIndexPath:(NSIndexPath *)indexPath{
    if (model) {
        _jobModel = model;
        _indexPath = indexPath;
        _isShowBtnView = YES;

        //抢单 标记
        self.layoutTitleLeft.constant = 0;
        self.layoutSpamLeftConstraint.constant = 0;
        self.spamLab.hidden = YES;
        self.imgDaifa.hidden = YES;
        self.topTagLab.hidden = YES;
        self.topTagLab.text = @"";
        if (model.stick.integerValue == 1) {
            self.imgDaifa.hidden = NO;
//            self.spamLab.hidden = NO;
            self.layoutImgDaifaLeft.constant = 0;
            self.layoutTitleLeft.constant = 20;
        }else{
            if (model.job_type.integerValue == 3){  //代发
                
                self.layoutImgDaifaLeft.constant = 0;
                self.layoutTitleLeft.constant = 20;
            }
        }
        
        //标题
        self.labTitle.text = model.job_title;
        
        //薪水
        NSString *salaryStr = [NSString stringWithFormat:@"%.2f", model.salary.value.floatValue];
        salaryStr = [salaryStr stringByReplacingOccurrencesOfString:@".00" withString:@""];
        self.salaryLabel.text = [NSString stringWithFormat:@"%@元%@", salaryStr, [model.salary getTypeDesc]];
        
        //人数
        self.hireNumLab.text = [NSString stringWithFormat:@"%@人", model.recruitment_num];
        
        //时间
        NSString* dateStr = [NSString stringWithFormat:@"%@", [[model.dead_time_start_end_str stringByReplacingOccurrencesOfString:@"." withString:@"/"] stringByReplacingOccurrencesOfString:@"-" withString:@"至"]];
        self.labDate.text = dateStr;
        self.labDate.font = [UIFont fontWithName:kFont_RSR size:13];
        //地址
        self.labAddress.text = model.address_area_name.length ? model.address_area_name : model.city_name;
        if (model.address_area_name.length) {
            self.labAddress.text = [NSString stringWithFormat:@"%@%@", model.city_name, model.address_area_name];
        }else{
            self.labAddress.text = model.city_name;
        }
        
        [_btnApplyArray enumerateObjectsUsingBlock:^(UIButton*  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            obj.hidden = YES;
            obj.userInteractionEnabled = NO;
        }];
        
        [_redPointArray enumerateObjectsUsingBlock:^(UIView*  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            obj.hidden = YES;
        }];
        
        self.labGuarantee.hidden = YES;
        self.layoutMiddleViewHeight.constant = 48;
        self.layoutTitleRightConstraint.constant = 12;
        self.btnClose.hidden = NO;
        self.btnRefresh.hidden = NO;
        self.btnStick.hidden = NO;
        self.applyNumLab.hidden = YES;
        self.layoutApplyNumLeftConstraint.constant = 12;
        
        if (model.job_type.integerValue == 3) { //代发工资岗位
            self.moreActionBtn.hidden = YES;
            self.btnClose.hidden = YES;
            self.btnRefresh.hidden = YES;
//            [self.btnRefresh setTitle:@" 发工资 " forState:UIControlStateNormal];
//            self.btnRefresh.tag = JobOpreationType_jobDaifa;
            self.btnStick.hidden = YES;
        }else{
            if (model.status.integerValue == 2) {
                self.moreActionBtn.hidden = NO;
                self.layoutTitleRightConstraint.constant = 0;
            }else{
                self.moreActionBtn.hidden = YES;
            }
            if (model.status.intValue == 0) {
                ELog(@"待审核");
                self.btnStick.hidden = YES;
                [self.btnRefresh setTitle:@" 上架岗位 " forState:UIControlStateNormal];
                self.btnRefresh.tag = JobOpreationType_Upload;
                
                [self.btnClose setTitle:@" 编辑岗位 " forState:UIControlStateNormal];
                self.btnClose.tag = JobOpreationType_EditJob;
                
                self.topTagLab.hidden = NO;
                self.topTagLab.text = @" 未提交审核 ";
                self.layoutTitleLeft.constant = 4;
            }else if (model.status.intValue == 2) {
                if (model.job_type.integerValue == 5) {
                    self.btnStick.hidden = YES;
                    self.btnClose.hidden = YES;
                    self.btnRefresh.hidden = YES;
                }else{
                    [self.btnStick setTitle:@"  刷新  " forState:UIControlStateNormal];
                    self.btnStick.tag = JobOpreationType_Refresh;
                    
                    [self.btnClose setTitle:@"  置顶  " forState:UIControlStateNormal];
                    self.btnClose.tag = JobOpreationType_payForStick;
                    
                    [self.btnRefresh setTitle:@"  人才匹配  " forState:UIControlStateNormal];
                    self.btnRefresh.tag = JobOpreationType_payForTelentMatch;
                }
                
                [self showJKApplyBtn];
                
            }else if (model.status.integerValue == 1){
                self.topTagLab.hidden = NO;
                self.topTagLab.text = @" 正在审核 ";
                self.layoutTitleLeft.constant = 4;
                self.btnClose.hidden = YES;
                self.btnStick.hidden = YES;
                [self.btnRefresh setTitle:@" 关闭岗位 " forState:UIControlStateNormal];
                self.btnRefresh.tag = JobOpreationType_Close;
            }else if (model.status.integerValue == 3){  //岗位结束状态
                self.btnClose.hidden = YES;
                self.btnStick.hidden = YES;
                if (model.job_close_reason.integerValue == 4 && model.job_type.integerValue != 3) {
                    self.topTagLab.hidden = NO;
                    self.topTagLab.text = @" 审核未通过 ";
                    self.layoutTitleLeft.constant = 4;
                }
                [self.btnRefresh setTitle:@" 快捷发布 " forState:UIControlStateNormal];
                self.btnRefresh.tag = JobOpreationType_FastPost;
                [self showJKApplyBtn];
                if (model.source.integerValue == 1) {
                    if (model.contact_apply_num.integerValue != 0) {
                        self.applyNumLab.hidden = NO;
                        self.applyNumLab.text = [NSString stringWithFormat:@"%ld人已咨询", model.contact_apply_num.integerValue];
                    }
                }else{
                    if (model.deliver_count.integerValue != 0) {
                        self.applyNumLab.hidden = NO;
                        self.applyNumLab.text = [NSString stringWithFormat:@"%ld人已报名", model.deliver_count.integerValue];
                    }
                }
                [_btnApplyArray enumerateObjectsUsingBlock:^(UIButton*  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    obj.userInteractionEnabled = NO;
                }];
            }
            
            //保证金业务
            if (model.status.integerValue == 2 || model.status.integerValue == 3) {
                
                if (model.guarantee_amount_status.integerValue == 1) {
                    self.layoutMiddleViewHeight.constant = 71;
                    self.labGuarantee.hidden = NO;
                    self.labGuarantee.text = [NSString stringWithFormat:@"保证金:%.2f元", model.guarantee_amount.floatValue];
                }else if (model.guarantee_amount_status.integerValue == 2){
                    self.layoutMiddleViewHeight.constant = 71;
                    self.labGuarantee.hidden = NO;
                    self.labGuarantee.text = [NSString stringWithFormat:@"保证金:%.2f元(被冻结)", model.guarantee_amount.floatValue];
                }else if (model.guarantee_amount_status.integerValue == 3){
                    self.layoutMiddleViewHeight.constant = 71;
                    self.labGuarantee.hidden = NO;
                    self.labGuarantee.text = [NSString stringWithFormat:@"保证金:%.2f元(退回中,预计%@到账)", model.guarantee_amount.floatValue, [DateHelper getDateWithNumber:@(model.guarantee_amount_refund_time.longLongValue * 0.001)]];
                }
            }
        }
    }
    
    if (model.source.integerValue == 1) {
        [_btnApplyArray enumerateObjectsUsingBlock:^(UIButton*  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            obj.userInteractionEnabled = NO;
        }];
    }
    
    if (model.job_type.integerValue == 3) {
        model.cellHeight = 107;
    }else{
        if (model.status.integerValue == 2) {
            if (model.guarantee_amount_status.integerValue == 1 || model.guarantee_amount_status.integerValue == 2 || model.guarantee_amount_status.integerValue == 3){
                model.cellHeight = 157;
            }else if(model.job_type.integerValue == 5 && self.btnApplyHead_1.hidden){
                model.cellHeight = 107;
            }else{
                model.cellHeight = 134;
            }
        }else if (model.status.integerValue == 3){
            if (model.guarantee_amount_status.integerValue == 1 || model.guarantee_amount_status.integerValue == 2 || model.guarantee_amount_status.integerValue == 3){
                model.cellHeight = 161;
            }else{
                model.cellHeight = 134;
            }
        }else{
            model.cellHeight = 134;
        }
        
    }
    
    if ([XSJUserInfoData isReviewAccount]) {
        self.btnClose.hidden = YES;
        self.btnStick.hidden = YES;
        self.btnRefresh.hidden = YES;
    }

}

- (void)refreshWithData:(JobModel*)model{
    [self refreshWithData:model atIndexPath:_indexPath];
}

- (void)showJKApplyBtn{
    JobModel *model = _jobModel;
    _applyJKArray = [[NSMutableArray alloc] init];
    NSInteger showHeadNum = (int)((SCREEN_WIDTH-(72 + 72 + 8 + 12 + 12))/30);
    NSInteger maxNum = showHeadNum > 3 ? 3 : showHeadNum;
    if (model.source.integerValue == 1) {
        if (model.apply_job_contact_resumes && model.apply_job_contact_resumes.count){    //采集岗位电话咨询JK列表
            for (NSDictionary* data in model.apply_job_contact_resumes){
                ApplyJobResumeModel* model = [ApplyJobResumeModel objectWithKeyValues:data];
                [_applyJKArray addObject:model];
            }
            showHeadNum = (model.apply_job_contact_resumes.count < maxNum) ? model.apply_job_contact_resumes.count : maxNum ;
        }
    }else{
        if (model.apply_job_resumes && model.apply_job_resumes.count > 0){  //非采集岗位报名JK简历列表
            for (NSDictionary* data in model.apply_job_resumes){
                ApplyJobResumeModel* model = [ApplyJobResumeModel objectWithKeyValues:data];
                [_applyJKArray addObject:model];
            }
            showHeadNum = (model.apply_job_resumes.count < maxNum) ? model.apply_job_resumes.count : maxNum ;
        }
    }
    
    if (_applyJKArray && _applyJKArray.count) {
        
        for (int i = 0; i < showHeadNum; i++) {
            ApplyJobResumeModel* applyModel = [_applyJKArray objectAtIndex:i];
            switch (i) {
                case 0:{
                    self.btnApplyHead_1.hidden = NO;
                    [self.btnApplyHead_1 sd_setBackgroundImageWithURL:[NSURL URLWithString:applyModel.user_profile_url] forState:UIControlStateNormal placeholderImage:[UIHelper getDefaultHeadRect]];
                    if (applyModel.hiring_page_stu_small_red_point.integerValue == 1) {
                        self.samll_red_point_1.hidden = NO;
                        self.btnApplyHead_1.userInteractionEnabled = YES;
                    }
                    self.layoutApplyNumLeftConstraint.constant = 47;
                }
                    break;
                    
                case 1:{
                    self.btnApplyHead_2.hidden = NO;
                    [self.btnApplyHead_2 sd_setBackgroundImageWithURL:[NSURL URLWithString:applyModel.user_profile_url] forState:UIControlStateNormal placeholderImage:[UIHelper getDefaultHeadRect]];
                    if (applyModel.hiring_page_stu_small_red_point.integerValue == 1) {
                        self.samll_red_point_2.hidden = NO;
                        self.btnApplyHead_2.userInteractionEnabled = YES;
                    }
                    self.layoutApplyNumLeftConstraint.constant = 77;
                }
                    break;
                case 2:{
                    self.btnApplyHead_3.hidden = NO;
                    [self.btnApplyHead_3 sd_setBackgroundImageWithURL:[NSURL URLWithString:applyModel.user_profile_url] forState:UIControlStateNormal placeholderImage:[UIHelper getDefaultHeadRect]];
                    if (applyModel.hiring_page_stu_small_red_point.integerValue == 1) {
                        self.samll_red_point_3.hidden = NO;
                        self.btnApplyHead_3.userInteractionEnabled = YES;
                    }
                    self.layoutApplyNumLeftConstraint.constant = 107;
                }
                    break;
                default:
                    break;
            }
        }
    }

}

#pragma mark - 按钮事件
- (void)btnOnClick:(UIButton *)sender{
    if ([self.delegate respondsToSelector:@selector(cell_btnBotOnClick:actionType:atIndexPath:)]) {
        [self.delegate cell_btnBotOnClick:_jobModel actionType:sender.tag atIndexPath:_indexPath];
    }
}

- (void)awakeFromNib {
    [super awakeFromNib];
    [self.topTagLab setCornerValue:2.0f];
    [self.topTagLab setBorderWidth:1.0f andColor:[UIColor XSJColor_tGrayDeepTransparent2]];
    [self.btnRefresh addTarget:self action:@selector(btnOnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.btnClose addTarget:self action:@selector(btnOnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.btnStick addTarget:self action:@selector(btnOnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    _btnApplyArray = @[self.btnApplyHead_1, self.btnApplyHead_2, self.btnApplyHead_3];
    
    [_btnApplyArray enumerateObjectsUsingBlock:^(UIButton*  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj addTarget:self action:@selector(btnOnClick:) forControlEvents:UIControlEventTouchUpInside];
        obj.tag = JobOpreationType_ViewApplyJK;
    }];
    
    _redPointArray = @[self.samll_red_point_1, self.samll_red_point_2, self.samll_red_point_3];
    [_redPointArray enumerateObjectsUsingBlock:^(UIView*  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj setCornerValue:4.0f];
    }];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

//更多操作
- (IBAction)btnShowSheet:(id)sender {
    if (!_indexPath) {
        return;
    }
    if ([self.delegate respondsToSelector:@selector(cell_btnBotOnClick:atIndexPath:)]) {
        [self.delegate cell_btnBotOnClick:_jobModel atIndexPath:_indexPath];
    }
}

//- (IBAction)btnPaySalaryOnClick:(UIButton *)sender {
//    if ([self.delegate respondsToSelector:@selector(cell_btnPaySalaryOnClick:)]) {
//        [self.delegate cell_btnPaySalaryOnClick:_jobModel];
//    }
//}

@end
