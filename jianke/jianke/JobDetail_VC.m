//
//  JobDetail_VC.m
//  jianke
//
//  Created by xiaomk on 16/3/15.
//  Copyright © 2016年 xianshijian. All rights reserved.
//

#import "JobDetail_VC.h"
#import "JobDetailCell_jobName.h"
#import "JobDetailCell_info.h"
#import "JobDetailCell_introduce.h"
#import "JobDetailCell_bus.h"
#import "JobDetailCell_contact.h"
#import "JobDetailCell_manage.h"
#import "JobDetailCell_apply.h"
#import "JobDetailCell_listApply.h"
#import "JobDetailCell_QA.h"
#import "JobDetailCell_baoZhaoIntro.h"
#import "JobDetailCell_rmwIntro.h"
#import "PushOrder_VC.h"

#import "WDConst.h"
#import "BusMap_VC.h"
#import "ImDataManager.h"
#import "WDChatView_VC.h"
#import "XHPopMenu.h"
#import "CityTool.h"
#import "RefreshLeftCountModel.h"
#import "ShareToGroupController.h"
#import "LookupEPInfo_VC.h"
#import "JobQAInfoModel.h"
#import "JobApplyConditionController.h"
#import "DateSelectView.h"
#import "LookupApplyJKListController.h"
#import "IdentityCardAuth_VC.h"
#import "MoneyBag_VC.h"

#import "JobRefreshHeader.h"
#import "JobRefreshBackFooter.h"
#import "NSObject+SYAddForProperty.h"
#import "NSDate+DateTools.h"
#import "WelfareModel.h"
#import "JobClassifyInfoModel.h"
#import "XSJRequestHelper.h"

#import "ApplySuccess_VC.h"
#import "MKAlertView.h"
#import "GuideUIManager.h"
#import "JobQA_VC.h"
#import "JobExpressCell.h"
#import "UILabel+MKExtension.h"
#import "SpecialButton.h"
#import "WebView_VC.h"
#import "PhoneRecallCourse_VC.h"
#import "JianKeAppreciation_VC.h"
#import "PaySelect_VC.h"
#import "BuyJobNum_VC.h"
#import "PostJob_VC.h"
#import "JobAutoRefresh_VC.h"

#import "XZTool.h"


@interface JobDetail_VC ()<UITableViewDelegate, UITableViewDataSource, UIAlertViewDelegate, UIActionSheetDelegate>{
    NSMutableArray* _sectionTypeArray;
    
    NSMutableArray* _sectionAry_jobBase;
    NSMutableArray* _sectionAry_address;
    NSMutableArray* _sectionAry_workTime;
    NSMutableArray* _sectionAry_workDetail;
    NSMutableArray* _sectionAry_contactInfo;
    NSMutableArray* _sectionAry_suggestJob;

    NSArray* _welfareArray;
    
    NSMutableArray *_qaCellArray;        /*!< 雇主答疑Cell数组, 存放JobQACellModel模型 */
    
    BOOL _hasCollected;  //是否收藏该岗位
}


@property (nonatomic, strong) UIImageView *jobStateImageView; /*!< 企业认证状态图标 */
@property (nonatomic, strong) XHPopMenu *epPopMenu; /*!< 雇主视角,右上角pop菜单 */
@property (nonatomic, strong) UIButton *guideForSocialActivistBtn; /*!< 人脉王遮罩引导 */

@property (nonatomic, strong) JobModel* jobModel;
@property (nonatomic, strong) JobQAInfoModel *qaAnswerModel; /*!< 雇主回复兼客的提问 */

@property (nonatomic, strong) NSMutableArray *workTime; /*!< 工作时间 */

@property (nonatomic, assign) BOOL noCallJobVcFinishBlock; /*!< 不再调用JobDetailMgr_VC的回调 */
@property (nonatomic, weak) UIAlertView *alertView;

@end

@implementation JobDetail_VC

#pragma mark - 引导图
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];

    // 显示引导图
    if (self.isFromSocialActivistBroadcast) {
        JKModel *jkModel = [[UserData sharedInstance] getJkModelFromHave];
        NSString *key = [NSString stringWithFormat:@"WDUserDefault_SocialActivist_Guide_%@", jkModel.account_id.stringValue];
        BOOL isRead = [WDUserDefaults boolForKey:key];
        if (!isRead) {
            [self showGuideForSocialActivist];
            [WDUserDefaults setBool:YES forKey:key];
        }
    }
}

// 显示人脉王引导遮罩
- (void)showGuideForSocialActivist{
    if (!self.guideForSocialActivistBtn) {
        UIButton *bgBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        bgBtn.backgroundColor = MKCOLOR_RGBA(0, 0, 0, 0.3);
        [bgBtn addTarget:self action:@selector(hideGuideForSocialActivist) forControlEvents:UIControlEventTouchUpInside];
        self.guideForSocialActivistBtn = bgBtn;
        
        UIView *dotView = [[UIView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 30, 40, 10, 10)];
        dotView.backgroundColor = [UIColor whiteColor];
        dotView.layer.cornerRadius = 5;
        dotView.layer.masksToBounds = YES;
        [bgBtn addSubview:dotView];
        
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 26, 50, 3, 100)];
        lineView.backgroundColor = [UIColor whiteColor];
        [bgBtn addSubview:lineView];
        
        UIView *containerView = [[UIView alloc] initWithFrame:CGRectMake(16, 150, SCREEN_WIDTH - 32, 140)];
        containerView.backgroundColor = [UIColor whiteColor];
        containerView.layer.cornerRadius = 3;
        containerView.layer.masksToBounds = YES;
        [bgBtn addSubview:containerView];
        
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 20, containerView.width - 40, 20)];
        titleLabel.font = [UIFont systemFontOfSize:18];
        titleLabel.text = @"分享得赏金";
        [containerView addSubview:titleLabel];
        
        UILabel *contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 50, containerView.width - 40, 70)];
        contentLabel.font = [UIFont systemFontOfSize:17];
        contentLabel.textColor = MKCOLOR_RGB(54, 54, 54);
        contentLabel.text = @"点击分享生成伯乐链接, 通过你的伯乐链接招录每一名完工兼客记作你的一份伯乐赏金哦~";
        contentLabel.numberOfLines = 0;
        [containerView addSubview:contentLabel];
    }
    
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    [keyWindow addSubview:self.guideForSocialActivistBtn];
}

// 隐藏人脉王引导遮罩
- (void)hideGuideForSocialActivist{
    [self.guideForSocialActivistBtn removeFromSuperview];
}

#pragma mark - ***** viewDidLoad ******
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"岗位详情";
    self.view.backgroundColor = [UIColor whiteColor];
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSelectionStyleNone;
    self.tableView.estimatedRowHeight = 44;
    [self.view addSubview:self.tableView];
    WEAKSELF
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(weakSelf.view);
    }];
    
    self.jobStateImageView = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-72, 50, 72, 79)];
    self.jobStateImageView.image = [UIImage imageNamed:@"job_xq_veryed"];
    [self.tableView addSubview:self.jobStateImageView];
    self.jobStateImageView.hidden = YES;
   
    //初始化数据
    _sectionTypeArray = [[NSMutableArray alloc] init];
    _sectionAry_jobBase = [[NSMutableArray alloc] init];
    _sectionAry_address = [[NSMutableArray alloc] init];
    _sectionAry_workTime = [[NSMutableArray alloc] init];
    _sectionAry_workDetail = [[NSMutableArray alloc] init];
    _sectionAry_contactInfo = [[NSMutableArray alloc] init];
    _sectionAry_suggestJob = [[NSMutableArray alloc] init];
    
    _qaCellArray = [[NSMutableArray alloc] init];
    
    if (!self.userType) {
        self.userType = [[UserData sharedInstance] getLoginType].intValue;
    }
    
    // 添加上拉下拉刷新
    [self setupReflush];
    [self getData];
}

- (void)setupReflush{
    if (self.isFromJobViewController) {
        WEAKSELF
        self.tableView.header = [JobRefreshHeader headerWithRefreshingBlock:^{
            if (weakSelf.headerReflushBlock) {
                weakSelf.headerReflushBlock(nil);
            }
        }];
        self.tableView.footer = [JobRefreshBackFooter footerWithRefreshingBlock:^{
            if (weakSelf.footerReflushBlock) {
                weakSelf.footerReflushBlock(nil);
            }
        }];
    }
}

#pragma mark - ***** 数据交互 ******
/** 获取数据 */
- (void)getData{
    NSInteger isFromSAB;
    if (self.isFromSocialActivistBroadcast) {
        isFromSAB = 1;
    }else{
        isFromSAB = 0;
    }
    WEAKSELF
    if (self.jobUuid) {
        [[UserData sharedInstance] getJobDetailWithJobUuid:self.jobUuid isShowLoding:self.isFirstShowJob block:^(JobDetailModel *model) {
            [weakSelf dealJobDetailModelBlockWithJobDetailModel:model];
        }];
        
    } else if (self.jobId) {
        [[UserData sharedInstance] getJobDetailWithJobId:self.jobId andIsFromSAB:isFromSAB isShowLoding:self.isFirstShowJob Block:^(JobDetailModel *model) {
            [weakSelf dealJobDetailModelBlockWithJobDetailModel:model];
        }];
    }
}

- (void)dealJobDetailModelBlockWithJobDetailModel:(JobDetailModel *)model{
    if (!model) {
        [UIHelper toast:@"获取岗位详情失败"];
        // 加载完成回调(用于上下拉查看上一个,下一个)
        if (self.loadFinishBlock && !self.noCallJobVcFinishBlock) {
            self.noCallJobVcFinishBlock = YES;
            self.loadFinishBlock(nil);
        }
        [self.navigationController popViewControllerAnimated:YES];
        return;
    }
    
    if (self.jobUuid) {
        self.jobId = model.parttime_job.job_id.stringValue;
    }
    
    self.jobDetailModel = model;
    _welfareArray = [NSArray arrayWithArray:self.jobDetailModel.parttime_job.job_tags];
    _qaCellArray = [NSMutableArray arrayWithArray:self.jobDetailModel.job_question_answer];

    // 发送访问日志
    [self sendLog];

    [self setupData];
    
    // 猜你喜欢
    if (self.userType == WDLoginType_JianKe) {
        [self getSuggestJobList];
    }
}

/** 猜你喜欢  获取数据 */
- (void)getSuggestJobList{
    
    CityModel *nowCity = [[UserData sharedInstance] city];
    LocalModel *localModel = [[UserData sharedInstance] local];

    GetJobLikeParam *param = [[GetJobLikeParam alloc] initWithjobId:_jobId andCityId:nowCity.id andCityModel:localModel];
    WEAKSELF
    [[XSJRequestHelper sharedInstance] getJobListGuessYouLike:param block:^(NSArray *result) {
        if (result.count > 0) {
            _sectionAry_suggestJob = [[NSMutableArray alloc] initWithArray:result];
            [weakSelf.tableView reloadData];
        }
        // 加载完成回调(用于上下拉查看上一个,下一个)
        if (weakSelf.loadFinishBlock && !weakSelf.noCallJobVcFinishBlock) {
            weakSelf.noCallJobVcFinishBlock = YES;
            weakSelf.loadFinishBlock(@(1));
        }
    }];
}

/** 雇主答疑 数据 */
- (void)getQAListDataScrollToBottom:(BOOL)isToBot{
    QueryParamModel *queryParam = [[QueryParamModel alloc] initWithPageSize:@3 pageNum:@1];
    QueryJobQAParam *param = [[QueryJobQAParam alloc] init];
    param.query_param = queryParam;
    param.job_id = self.jobId;
    WEAKSELF
    [[UserData sharedInstance] queryJobQAWithParam:param isShowLoding:self.isFirstShowJob block:^(NSArray *qaArray) {
        [_qaCellArray removeAllObjects];
        [_qaCellArray addObjectsFromArray:qaArray];
        [weakSelf.tableView reloadData];
    }];
}

- (void)setupData{
    self.jobModel = self.jobDetailModel.parttime_job;

    // 企业认证状态
    if (self.jobModel.enterprise_verified.integerValue == 3) {
        if (self.jobModel.enable_recruitment_service.integerValue == 1) {
            CGRect tempFrame = self.jobStateImageView.frame;
            tempFrame.origin.y = 104;
            self.jobStateImageView.frame = tempFrame;
        }
        
        self.jobStateImageView.hidden = NO;
    }
   
    UIBarButtonItem *epDropDownMenuBtn = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"job_xq_more_0"] style:UIBarButtonItemStylePlain target:self action:@selector(epDropDownMenuClick:)];
    [epDropDownMenuBtn setBackgroundImage:[UIImage imageNamed:@"job_xq_more_1"] forState:UIControlStateHighlighted barMetrics:UIBarMetricsDefault];


    if (self.jobDetailModel.parttime_job.status.integerValue == 2 || self.jobDetailModel.parttime_job.status.integerValue == 0) { // 审核中
        self.navigationItem.rightBarButtonItems = @[epDropDownMenuBtn];
    }else if(self.jobDetailModel.parttime_job.status.integerValue == 3){
        UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"快捷发布" style:UIBarButtonItemStylePlain target:self action:@selector(rightItemOnClick)];
        self.navigationItem.rightBarButtonItems = @[item];
    }else if(self.jobDetailModel.parttime_job.status.integerValue == 1){
        UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"关闭岗位" style:UIBarButtonItemStylePlain target:self action:@selector(rightItemOnClick)];
        self.navigationItem.rightBarButtonItems = @[item];
    }else{
        self.navigationItem.rightBarButtonItems = nil;
    }
    
    [_sectionTypeArray removeAllObjects];
    [_sectionAry_contactInfo removeAllObjects];
    [_sectionAry_jobBase removeAllObjects];
    [_sectionAry_address removeAllObjects];
    [_sectionAry_workTime removeAllObjects];
    [_sectionAry_workDetail removeAllObjects];
    [_sectionAry_suggestJob removeAllObjects];
    
    /** 初始化 section  */
    [_sectionTypeArray addObject:@(JDGroupType_jobBase)];   //岗位名称
    [_sectionTypeArray addObject:@(JDGroupType_address)];  //公交
    [_sectionTypeArray addObject:@(JDGroupType_workTime)];  //工作时间
    [_sectionTypeArray addObject:@(JDGroupType_workDetail)];  //工作详情
    if (self.userType == WDLoginType_JianKe) { //兼客视角
        [_sectionTypeArray addObject:@(JDGroupType_contactInfo)];  //联系信息
    }else{
        if (self.jobModel.status.intValue == 2 && self.jobModel.has_been_filled.intValue != 1) {// 已发布 && 未报满
            [_sectionAry_contactInfo addObject:@(JDCellType_apply)];
        }
    }
//    [_sectionTypeArray addObject:@(JDGroupType_apply)];  //联系信息
    if (self.jobModel.source.integerValue != 1) {
        [_sectionTypeArray addObject:@(JDGroupType_epQA)];  //雇主答疑
    }
    
    if (self.userType == WDLoginType_JianKe) {
        [_sectionTypeArray addObject:@(JDGroupType_jkLike)];    //猜你喜欢
    }
    //=====1
    if (self.jobModel.enable_recruitment_service.integerValue == 1) {
        [_sectionAry_jobBase addObject:@(JDCellType_baozhaoIntro)];
    }else if (self.jobModel.is_social_activist_job.integerValue == 1){  //人脉王岗位
        [_sectionAry_jobBase addObject:@(JDCellType_rmwIntro)];
        [GuideUIManager showGuideWithType:GuideUIType_jobDetailRMW block:nil];
    }
    [_sectionAry_jobBase addObject:@(JDCellType_jobName)];
    [_sectionAry_jobBase addObject:@(JDCellType_peopleNum)];
    [_sectionAry_jobBase addObject:@(JDCellType_payWay)];
    [_sectionAry_jobBase addObject:@(JDCellType_payTime)];
    if (self.jobModel.apply_limit_arr.count > 0) {
        [_sectionAry_jobBase addObject:@(JDCellType_condition)];
    }
    if (_welfareArray.count > 0) {
        [_sectionAry_jobBase addObject:@(JDCellType_welfare)];
    }
    
    //======2
    [_sectionAry_address addObject:@(JDCellType_bus)];


    //======3
    [_sectionAry_workTime addObject:@(JDCellType_date)];
    
    if (self.jobModel.work_start_end_hours_str.length) {
        [_sectionAry_workTime addObject:@(JDCellType_time)];
    }
    
    [_sectionAry_workTime addObject:@(JDCellType_endDate)];
    
    
    //======4
    [_sectionAry_workDetail addObject:@(JDCellType_introduce)];
    
//    if (self.jobDetailModel.parttime_job.source.integerValue == 1) {    //采集
//        if (self.jobDetailModel.contact_apply_job_resumes_count.integerValue > 0) {
//            [_sectionAry_workDetail addObject:@(JDCellType_listApply)];
//        }
//    }else{
//        if (self.jobDetailModel.apply_job_resumes_count.integerValue > 0) {
//            [_sectionAry_workDetail addObject:@(JDCellType_listApply)];
//        }
//    }


    //======5
    [_sectionAry_contactInfo addObject:@(JDCellType_contactEp)];
    [_sectionAry_contactInfo addObject:@(JDCellType_epAuth)];
    [_sectionAry_contactInfo addObject:@(JDCellType_respondTime)];
    [_sectionAry_contactInfo addObject:@(JDCellType_lastSeeTime)];

//    [_sectionAry_contactInfo addObject:@(JDCellType_contact)];
//    [_sectionAry_contactInfo addObject:@(JDCellType_manage)];
    
    if (self.jobModel) {
        [self.tableView reloadData];
    }

    
    // 弹窗
    if (self.userType == WDLoginType_Employer) { // 雇主视图
        // 审核未通过 || 已下架
        if (self.jobDetailModel.parttime_job.job_close_reason.integerValue == 3 || self.jobDetailModel.parttime_job.job_close_reason.integerValue == 4) {
            NSString *title = nil;
            NSString *message = @"🐷是怎么死的?";
            if (self.jobDetailModel.parttime_job.job_close_reason.integerValue == 3) {
                title = @"岗位下架原因";
            }
            if (self.jobDetailModel.parttime_job.job_close_reason.integerValue == 4) {
                title = @"岗位审核未通过原因";
            }
            if (self.jobDetailModel.parttime_job.revoke_reason) {
                message = self.jobDetailModel.parttime_job.revoke_reason;
            }
            UIAlertView *closeAlertView = [[UIAlertView alloc] initWithTitle:title message:message delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [closeAlertView show];
        }
    } else {
        // 审核未通过 || 已下架
        if (self.jobDetailModel.parttime_job.job_close_reason.integerValue == 3 || self.jobDetailModel.parttime_job.job_close_reason.integerValue == 4) {
            NSString *title = @"岗位已下架";
            NSString *message = @"对不起，该岗位已下架，看看其他合适的岗位吧";
            WEAKSELF
            [UIHelper showConfirmMsg:message title:title cancelButton:@"确定" completion:^(DLAVAlertView *alertView, NSInteger buttonIndex) {
                [weakSelf.navigationController popViewControllerAnimated:YES];
            }];
        }
    }
}

- (JDCellType)getSectionTypeWithIndexPath:(NSIndexPath *)indexPath{
    JDGroupType groupType = [_sectionTypeArray[indexPath.section] integerValue];
    NSMutableArray *sectionArray;
    switch (groupType) {
        case JDGroupType_jobBase:
            sectionArray = _sectionAry_jobBase;
            break;
        case JDGroupType_address:
            sectionArray = _sectionAry_address;
            break;
        case JDGroupType_workTime:
            sectionArray = _sectionAry_workTime;
            break;
        case JDGroupType_workDetail:
            sectionArray = _sectionAry_workDetail;
            break;
        case JDGroupType_contactInfo:
            sectionArray = _sectionAry_contactInfo;
            break;
        case JDGroupType_epQA:
            return JDCellType_QA;
        case JDGroupType_apply:
            return JDCellType_apply;
        case JDGroupType_jkLike:
            return JDCellType_jkLike;
            break;
        default:
            break;
    }
    
    if (!sectionArray || sectionArray.count == 0 || indexPath.row >= sectionArray.count) {
        return 0;
    }
    
    JDCellType sectionType = [[sectionArray objectAtIndex:indexPath.row] integerValue];
    return sectionType;
}

#pragma mark - UITableView delegate
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    JDCellType sectionType = [self getSectionTypeWithIndexPath:indexPath];
    switch (sectionType) {
        case JDCellType_baozhaoIntro:{
            JobDetailCell_baoZhaoIntro* cell = [JobDetailCell_baoZhaoIntro cellWithTableView:tableView];
            return cell;
        }
        case JDCellType_rmwIntro:{
            JobDetailCell_rmwIntro* cell = [JobDetailCell_rmwIntro cellWithTableView:tableView];
            NSNumber *reward = self.jobModel.social_activist_reward ? @(self.jobModel.social_activist_reward.integerValue/100.0f): @(0);
            NSString *unit = @"元/人/天";
            if (self.jobModel.social_activist_reward_unit.integerValue == 1) {
                unit = @"元/人";
            }
            cell.labRmwIntro.text = [NSString stringWithFormat:@"人脉王推广佣金: %.2f%@",reward.floatValue, unit];
            return cell;
        }
        case JDCellType_jobName:{
            JobDetailCell_jobName* cell = [JobDetailCell_jobName cellWithTableView:tableView];
            cell.frame = CGRectMake(0, 0, SCREEN_WIDTH, 72);
            if (!self.jobModel.job_type || self.jobModel.job_type.intValue) {   // 普通兼职
                cell.imgViewSeize.hidden = YES;
                cell.LayoutImgSeizeRightEdge.constant = 16;
            }else{
                cell.imgViewSeize.hidden = NO;
                cell.LayoutImgSeizeRightEdge.constant = 40;
            }
            cell.labJobTitle.text = self.jobModel.job_title;
            
            NSString *moneyStr = [NSString stringWithFormat:@"￥%@", [NSString stringWithFormat:@"%.2f", self.jobModel.salary.value.floatValue]];
            cell.labMoney.text = moneyStr;

            NSString *unitStr = [self.jobModel.salary.unit_value stringByReplacingOccurrencesOfString:@"小时" withString:@"时"];
            unitStr = [unitStr stringByReplacingOccurrencesOfString:@"元" withString:@""];
            cell.labUnit.text = unitStr;
            
            cell.labSeeTime.text = [NSString stringWithFormat:@"%@次 浏览",self.jobModel.view_count];
            NSString *updataTime = [DateHelper getShortDateFromTimeNumber:self.jobModel.create_time];
            cell.labPostDate.text = [NSString stringWithFormat:@"%@ 发布",updataTime];

            CGSize labSize = [cell.labJobTitle contentSizeWithWidth:SCREEN_WIDTH-133-cell.LayoutImgSeizeRightEdge.constant];
            CGRect cellFrame = cell.frame;
            cellFrame.size.height = labSize.height + 50;
            cell.frame = cellFrame;
            return cell;
        }
        case JDCellType_payWay:
        case JDCellType_payTime:
        case JDCellType_date:
        case JDCellType_time:
        case JDCellType_peopleNum:
        case JDCellType_address:
        case JDCellType_condition:
        case JDCellType_endDate:
        case JDCellType_welfare:
        {
            JobDetailCell_info* cell = [JobDetailCell_info cellWithTableView:tableView];
            cell.frame = CGRectMake(0, 0, SCREEN_WIDTH, 38);
            switch (sectionType) {
                case JDCellType_peopleNum:{
                    cell.labText.text = @"招聘人数:";
                    cell.labTitle.text = [NSString stringWithFormat:@"共%@人", self.jobModel.recruitment_num];
                }
                    break;
                case JDCellType_payWay:{
                    cell.labText.text = @"付款方式:";
                    SalaryModel *salary = self.jobModel.salary;
                    if (salary.pay_type.integerValue == 1) { // 没有付款方式
                        cell.labTitle.text = @"在线支付";
                    }else{
                        cell.labTitle.text = @"现金支付";
                    }
                }
                    break;
                case JDCellType_payTime:{
                    cell.labText.text = @"发薪时间:";
                    cell.labTitle.text = self.jobModel.salary.settlement_value;
                }
                    break;
                case JDCellType_condition:{
                    cell.labText.text = @"限制条件:";
                    // 条件限制
                    if (self.jobModel.apply_limit_arr.count) {
                        NSString *limitStr = [self.jobModel.apply_limit_arr componentsJoinedByString:@"，"];
                        cell.labTitle.text = limitStr;
                    }
                }
                    break;
                case JDCellType_welfare:{
                    cell.labText.text = @"岗位福利:";
                    NSMutableString *welfareStr = [NSMutableString stringWithString:@"提供 "];
                    for (NSInteger i = 0; i < _welfareArray.count; i++) {
                        WelfareModel* jogTag = _welfareArray[i];
                        [welfareStr insertString:[NSString stringWithFormat:@"「%@」",jogTag.tag_title] atIndex:[welfareStr length]];
                    }
                    cell.labTitle.text = welfareStr;
                }
                    break;

                    
                case JDCellType_date:{
                    cell.labText.text = @"工作日期:";
                    // 日期
                    NSString *startDate = [DateHelper getDateWithNumber:@(self.jobModel.working_time_start_date.longLongValue * 0.001)];
                    NSString *endDate = [DateHelper getDateWithNumber:@(self.jobModel.working_time_end_date.longLongValue * 0.001)];
                    cell.labTitle.text = [NSString stringWithFormat:@"%@ 至 %@", startDate, endDate];
                }
                    break;
                case JDCellType_time:{
                    cell.labText.text = @"工作时段:";

                    // 时间段
//                    WorkTimePeriodModel *workTimeRange = self.jobModel.working_time_period;
//                    NSString *timeRangeStr = nil;
//                    if (workTimeRange.f_start && workTimeRange.f_end) {
//                        NSString *startTimeStr = [DateHelper getTimeWithNumber:@(workTimeRange.f_start.longLongValue * 0.001)];
//                        NSString *endTimeStr = [DateHelper getTimeWithNumber:@(workTimeRange.f_end.longLongValue * 0.001)];
//                        timeRangeStr = [NSString stringWithFormat:@"%@~%@", startTimeStr, endTimeStr];
//                    }
//                    if (workTimeRange.s_start && workTimeRange.s_end) {
//                        NSString *startTimeStr = [DateHelper getTimeWithNumber:@(workTimeRange.s_start.longLongValue * 0.001)];
//                        NSString *endTimeStr = [DateHelper getTimeWithNumber:@(workTimeRange.s_end.longLongValue * 0.001)];
//                        timeRangeStr = [NSString stringWithFormat:@"%@, %@~%@", timeRangeStr, startTimeStr, endTimeStr];
//                    }
//                    if (workTimeRange.t_start && workTimeRange.t_end) {
//                        NSString *startTimeStr = [DateHelper getTimeWithNumber:@(workTimeRange.t_start.longLongValue * 0.001)];
//                        NSString *endTimeStr = [DateHelper getTimeWithNumber:@(workTimeRange.t_end.longLongValue * 0.001)];
//                        timeRangeStr = [NSString stringWithFormat:@"%@, %@~%@", timeRangeStr, startTimeStr, endTimeStr];
//                    }
                    cell.labTitle.text = self.jobModel.work_start_end_hours_str;
                }
                    break;

              
                case JDCellType_endDate:{
                    cell.labText.text = @"报名截止:";
                    // 报名截止日期
                    NSString *applyEndDateStr = [DateHelper getDateWithNumber:@(self.jobModel.apply_dead_time.longLongValue * 0.001)];
                    cell.labTitle.text = [NSString stringWithFormat:@"%@日", applyEndDateStr];
                }
                    break;
                    
                case JDCellType_address:{
                    cell.labText.text = @"工作地址:";
                    NSString *areaStr = self.jobModel.address_area_name;
                    NSString *placeStr = self.jobModel.working_place;
                    
                    NSMutableString *addressStr = [NSMutableString stringWithFormat:@""];
                    if (areaStr && areaStr.length > 0) {
                        [addressStr appendString:areaStr];
                        
                        if (placeStr && placeStr.length > 0) {
                            [addressStr appendString:[NSString stringWithFormat:@"·%@", placeStr]];
                        }
                    } else if (placeStr && placeStr.length > 0) {
                        [addressStr appendString:placeStr];
                    }
                    cell.labTitle.text = addressStr;
                }
                    break;
                default:
                    break;
            }
            CGSize labSize = [cell.labTitle contentSizeWithWidth:SCREEN_WIDTH-98];
            CGRect cellFrame = cell.frame;
            cellFrame.size.height = labSize.height + 16 > cellFrame.size.height ? labSize.height + 16 : cellFrame.size.height;
            cell.frame = cellFrame;
            return cell;
        }
            

        case JDCellType_bus:{
            JobDetailCell_bus* cell = [JobDetailCell_bus cellWithTableView:tableView];
            cell.frame = CGRectMake(0, 0, SCREEN_WIDTH, 60);

            [cell.btnBus addTarget:self action:@selector(btnBusOnclick:) forControlEvents:UIControlEventTouchUpInside];
            cell.labAddress.text = self.jobModel.working_place;
            return cell;
        }
        case JDCellType_introduce:{
            JobDetailCell_introduce* cell = [JobDetailCell_introduce cellWithTableView:tableView];
            cell.frame = CGRectMake(0, 0, SCREEN_WIDTH, 30+18);

            // 岗位描述
            NSString *jobDsc = @"";
            if (self.jobModel.job_type && self.jobModel.job_type.integerValue == 2) { // 抢单兼职
                jobDsc = [self.jobModel.job_label componentsJoinedByString:@","];
            } else { // 普通兼职
                if (self.jobModel.job_type_label && self.jobModel.job_type_label.count > 0) {
                    NSArray* tempArray = [self.jobModel.job_type_label valueForKey:@"label_name"];
//                NSArray* jtlArray = [JobClassifierLabelModel objectArrayWithKeyValuesArray:self.jobModel.job_type_label];
                    NSString* tagStr = [tempArray componentsJoinedByString:@","];
                    jobDsc = [NSString stringWithFormat:@"条件要求:%@\n\n",tagStr];
                }
                if (self.jobModel.job_desc.length) {
                    jobDsc = [jobDsc stringByAppendingString:self.jobModel.job_desc];
                }
            }
            if (self.jobModel.soft_content && self.jobModel.soft_content.length > 0) {
                jobDsc = [jobDsc stringByAppendingString:[NSString stringWithFormat:@"\n\n%@",self.jobModel.soft_content]];
            }
            cell.labJobDetail.text = jobDsc;
            
            CGSize labSize = [cell.labJobDetail contentSizeWithWidth:SCREEN_WIDTH-32];
            
            CGRect cellFrame = cell.frame;
            cellFrame.size.height = labSize.height + 32 + 36 + 6;
            if (self.userType == WDLoginType_Employer) {
                cellFrame.size.height = labSize.height + 32 + 18;
                cell.warnLab.hidden = YES;
            }
            
            cell.frame = cellFrame;

            return cell;
        }
            
        case JDCellType_listApply:{
            JobDetailCell_listApply* cell = [JobDetailCell_listApply cellWithTableView:tableView];
            cell.frame = CGRectMake(0, 0, SCREEN_WIDTH, 48);
            
            NSInteger count = 0;
            NSArray *resumes;
            if (self.jobModel.source.integerValue == 1) {    //采集岗位
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                cell.labApplyNum.text = [NSString stringWithFormat:@"%@人电话咨询", self.jobDetailModel.contact_apply_job_resumes_count];
                cell.layoutpushWidthConstraint.constant = 1;
                count = self.jobDetailModel.contact_apply_job_resumes_count.integerValue;
                resumes = self.jobDetailModel.contact_apply_job_resumes;
            }else{  //非采集岗位
                cell.selectionStyle = UITableViewCellSelectionStyleDefault;
                // 已报名兼客名单
                count = self.jobDetailModel.apply_job_resumes_count.integerValue;
                cell.labApplyNum.text = [NSString stringWithFormat:@"%@人已报名", self.jobDetailModel.apply_job_resumes_count];
                cell.layoutpushWidthConstraint.constant = 24;
                resumes = self.jobDetailModel.apply_job_resumes;
            }
            
            if (count != 0 ) {

                // 已报名兼客头像列表
                NSInteger maxCount = (SCREEN_WIDTH-140)/35;
                if (maxCount > 10) {
                    maxCount = 10;
                }
                if (count > maxCount) {
                    count = maxCount;
                }
                for (NSInteger i = 0; i < count; i++) {
                    UIImageView *img = (UIImageView*)[cell viewWithTag:i+100];
                    ApplyJobResumeModel *applyJobResume = resumes[i];
                    [img sd_setImageWithURL:[NSURL URLWithString:applyJobResume.user_profile_url] placeholderImage:[UIHelper getDefaultHeadRect]];
                    [img setCornerWithCorners:UIRectCornerAllCorners cornerRadii:CGSizeMake(2, 0)];
                }
            }
            
            return cell;
        }
            
            
        case JDCellType_contactEp:       /*!< 联系商家 */
        case JDCellType_epAuth:          /*!< 企业名称 */
        case JDCellType_respondTime:     /*!< 处理用时 */
        case JDCellType_lastSeeTime:     /*!< 查看简历 */
        {
            JobDetailCell_info* cell = [JobDetailCell_info cellWithTableView:tableView];
            cell.frame = CGRectMake(0, 0, SCREEN_WIDTH, 48);
            cell.lineView.hidden = NO;
            cell.layoutLabTextToTop.constant = 12;
            switch (sectionType) {
                case JDCellType_contactEp:       /*!< 联系商家 */
                {
                    cell.labText.text = @"联系商家:";
                    cell.labTitle.text = self.jobModel.contact.name;
//                    self.jobModel.source = @1;
                    if (self.jobModel.source.integerValue != 1) {
                        UIButton *btnPhone = (UIButton *)[cell viewWithTag:301];
                        UIButton *btnMsg = (UIButton *)[cell viewWithTag:302];
                        if (!btnPhone) {
                            btnPhone = [UIButton buttonWithType:UIButtonTypeCustom];
                            [btnPhone setImage:[UIImage imageNamed:@"v3_job_call_0"] forState:UIControlStateNormal];
                            [btnPhone setImage:[UIImage imageNamed:@"v3_job_call_2"] forState:UIControlStateDisabled];
                            [btnPhone addTarget:self action:@selector(btnCallPhoneOnclick:) forControlEvents:UIControlEventTouchUpInside];
                            btnPhone.tag = 301;
                            [cell addSubview:btnPhone];
                            
                            [btnPhone mas_makeConstraints:^(MASConstraintMaker *make) {
                                make.centerY.equalTo(cell);
                                make.right.equalTo(cell.mas_right).offset(-16);
                            }];
                        }
                        if (!btnMsg) {
                            btnMsg = [UIButton buttonWithType:UIButtonTypeCustom];
                            [btnMsg setImage:[UIImage imageNamed:@"v3_job_msg_0"] forState:UIControlStateNormal];
                            [btnMsg addTarget:self action:@selector(chatWithEPClick:) forControlEvents:UIControlEventTouchUpInside];
                            btnMsg.tag = 302;
                            [cell addSubview:btnMsg];
                            
                            [btnMsg mas_makeConstraints:^(MASConstraintMaker *make) {
                                make.centerY.equalTo(cell);
                                make.right.equalTo(btnPhone.mas_left).offset(-24);
                            }];
                        }
                    }
                    
                    
                    
//                    if (self.jobModel.student_applay_status.intValue == 1 || self.jobModel.student_applay_status.intValue == 2){ // 已报名过
//                        btnPhone.enabled = YES;
//                    }else{
//                        btnPhone.enabled = NO;
//                    }
                }
                    break;
                case JDCellType_epAuth:          /*!< 企业名称 */
                {
                    cell.labText.text = @"企业名称:";
                    if (self.jobModel.enterprise_info.enterprise_name && self.jobModel.enterprise_info.enterprise_name.length) {
                        cell.labTitle.text = self.jobModel.enterprise_info.enterprise_name;
                    }else{
                        cell.labTitle.text = self.jobModel.enterprise_info.true_name;
                    }
                    
                    if (self.jobModel.enterprise_info.verifiy_status.integerValue == 3) {
                        cell.imgPush.hidden = NO;
                    }else{
                        cell.imgPush.hidden = YES;
                    }
                    
                }
                    break;
                case JDCellType_respondTime:     /*!< 处理用时 */
                {
                    cell.labText.text = @"处理用时:";
                    cell.labTitle.text = self.jobModel.enterprise_info.deal_resume_used_time_avg_desc;
                }
                    break;
                case JDCellType_lastSeeTime:     /*!< 查看简历 */
                {
                    cell.labText.text = @"查看简历:";
                    cell.labTitle.text = self.jobModel.enterprise_info.last_read_resume_time_desc;
                }
                    break;
                default:
                    break;
            }
            return cell;
        }
            break;
            
        case JDCellType_QA:{
            JobDetailCell_QA* cell = [JobDetailCell_QA cellWithTableView:tableView];

            JobQAInfoModel* model = _qaCellArray[indexPath.row];
            model.cellHeight = 68 ;
            
            [cell.btnReport addTarget:self action:@selector(btnReportOnclick:) forControlEvents:UIControlEventTouchUpInside];
            [cell.btnAnswer addTarget:self action:@selector(btnAnswerOnclick:) forControlEvents:UIControlEventTouchUpInside];
            cell.btnAnswer.tag = indexPath.row;
            if (self.userType == WDLoginType_Employer) {
                cell.btnAnswer.hidden = NO;
            }else{
                cell.btnAnswer.hidden = YES;
            }
            
            // 头像
            [cell.imgHead sd_setImageWithURL:[NSURL URLWithString:model.question_user_profile_url] placeholderImage:[UIHelper getDefaultHeadRect]];
            // 姓名
            if (model.question_user_true_name && model.question_user_true_name.length) {
                cell.labJKName.text = model.question_user_true_name;
            } else {
                cell.labJKName.text = @"兼客用户";
            }
            
            // 问题
            cell.labQuestion.text = model.question;
            // 提问时间
            cell.labQuestionTime.text = [DateHelper getTimeRangeWithSecond:model.question_time];
            
            CGSize labQuestionSize = [cell.labQuestion contentSizeWithWidth:SCREEN_WIDTH-120];
            if (labQuestionSize.height > 17) {
                model.cellHeight = model.cellHeight - 17 + labQuestionSize.height;
            }
            
            // 回复
            if (model.answer.length > 0) {
                cell.labEpRevert.hidden = NO;
                cell.labAnswer.hidden = NO;
                cell.labAnswerTime.hidden = NO;
                cell.btnAnswer.hidden = YES;
                
                cell.labAnswerTime.text = [DateHelper getTimeRangeWithSecond:model.answer_time];
                cell.labAnswer.text = model.answer;
                CGSize labAnswerSize = [cell.labAnswer contentSizeWithWidth:SCREEN_WIDTH - 160];
                model.cellHeight = model.cellHeight + 38 - 17 + labAnswerSize.height;

            }else{
                if ([[UserData sharedInstance] getLoginType].integerValue == WDLoginType_Employer) {
                    cell.labEpRevert.hidden = YES;
                    cell.labAnswer.hidden = YES;
                    cell.labAnswerTime.hidden = YES;
                    cell.btnAnswer.hidden = NO;
                    model.cellHeight = model.cellHeight + 38;
                }else{
                    cell.viewAnswer.hidden = YES;
                }
              
            }
            return cell;
        }
        case JDCellType_jkLike:{
            JobExpressCell *cell = [JobExpressCell cellWithTableView:tableView];
            JobModel *jobModel = _sectionAry_suggestJob[indexPath.row];
            [cell refreshWithData:jobModel andSearchStr:nil];
            return cell;
        }
#pragma mark - ***** 弃用cell ******
        case JDCellType_contact:{
            JobDetailCell_contact* cell = [JobDetailCell_contact cellWithTableView:tableView];
            cell.frame = CGRectMake(0, 0, SCREEN_WIDTH, 126);
     
//            [cell setBorderWidth:0.5 andColor:MKCOLOR_RGB(227, 227, 227)];
            [cell.viewColorBg setBorderWidth:0.5 andColor:MKCOLOR_RGB(227, 227, 227)];
            [cell.btnCallPhone addTarget:self action:@selector(btnCallPhoneOnclick:) forControlEvents:UIControlEventTouchUpInside];
            [cell.btnIMMsg addTarget:self action:@selector(chatWithEPClick:) forControlEvents:UIControlEventTouchUpInside];
            cell.btnCallPhone.enabled = self.userType == WDLoginType_JianKe;
            cell.btnIMMsg.enabled = self.userType == WDLoginType_JianKe;
            
//            if (self.jobModel.enterprise_info.enterprise_name && self.jobModel.enterprise_info.enterprise_name.length) {
//                cell.labPerson.text = self.jobModel.enterprise_info.enterprise_name;
//            } else
            if (self.jobModel.contact.name && self.jobModel.contact.name.length) {
                cell.labPerson.text = self.jobModel.contact.name;
            }
            
            if (self.jobModel.student_applay_status.intValue == 1 || self.jobModel.student_applay_status.intValue == 2){ // 已报名过
                [cell.btnCallPhone setImage:[UIImage imageNamed:@"v3_job_call_0"] forState:UIControlStateNormal];
                if (self.jobModel.contact.phone_num && self.jobModel.contact.phone_num.length == 11) {
                    cell.labPhone.text = self.jobModel.contact.phone_num;
                }
            } else {
                [cell.btnCallPhone setImage:[UIImage imageNamed:@"v240_phone"] forState:UIControlStateNormal];
                if (self.jobModel.contact.phone_num && self.jobModel.contact.phone_num.length == 11) {
                    cell.labPhone.text = [NSString stringWithFormat:@"%@%@%@", [self.jobModel.contact.phone_num substringToIndex:3], @"****", [self.jobModel.contact.phone_num substringFromIndex:7]];
                }
            }
            
            if (self.jobModel.enterprise_info.enterprise_name && self.jobModel.enterprise_info.enterprise_name.length) {
                cell.labEpName.text = self.jobModel.enterprise_info.enterprise_name;
            }else{
                cell.labEpName.text = self.jobModel.enterprise_info.true_name;
            }
            if (self.jobModel.enterprise_info.verifiy_status.integerValue == 3) {
                cell.imgEpAuth.hidden = NO;
                cell.imgNext.hidden = NO;
                cell.btnShowEpInfo.enabled = YES;
                cell.layoutEpNameLeft.constant = 40;
                [cell.btnShowEpInfo addTarget:self action:@selector(lookupEPResumeClick:) forControlEvents:UIControlEventTouchUpInside];
            }else{
                cell.imgEpAuth.hidden = YES;
                cell.imgNext.hidden = YES;
                cell.btnShowEpInfo.enabled = NO;
                cell.layoutEpNameLeft.constant = 12;
            }

            return cell;
        }
        case JDCellType_manage:{
            JobDetailCell_manage* cell = [JobDetailCell_manage cellWithTableView:tableView];
            cell.frame = CGRectMake(0, 0, SCREEN_WIDTH, 78);
     
            // 处理简历用时 & 上次查看简历 & 付款方式 & 发薪时间
            cell.labDealTime.text = self.jobModel.enterprise_info.deal_resume_used_time_avg_desc;
            cell.labLastLookTime.text = self.jobModel.enterprise_info.last_read_resume_time_desc;
            
            SalaryModel *salary = self.jobModel.salary;
            cell.labPayTime.text = salary.settlement_value;
            
            if (!salary.pay_type) { // 没有付款方式
                cell.labPayWay.text = @"无";
            }else{
                cell.labPayWay.text = salary.pay_type.integerValue == 1 ? @"在线支付" : @"现金支付";
            }
            return cell;
        }
        case JDCellType_apply:{
            JobDetailCell_apply* cell = [JobDetailCell_apply cellWithTableView:tableView];
            cell.frame = CGRectMake(0, 0, SCREEN_WIDTH, 60);
//            cell.btnApply.enabled = YES;
            
//            [cell.btnComplain addTarget:self action:@selector(btnComplainOnclick:) forControlEvents:UIControlEventTouchUpInside];
            [cell.btnApply addTarget:self action:@selector(applyClick:) forControlEvents:UIControlEventTouchUpInside];
            
            if (self.userType == WDLoginType_Employer) {    //雇主视角
                [cell.btnApply setTitle:@"邀请人才" forState:UIControlStateNormal];
                if (self.jobModel.status.intValue == 2 && self.jobModel.has_been_filled.intValue != 1) {// 已发布 && 未报满
                    cell.btnApply.enabled = YES;
                }else{
                    cell.btnApply.enabled = NO;
                }
            }else{      //兼客视角
                // 扫码补录过来的..
                if (self.jobModel.source.integerValue == 1) {   //采集岗位
                    if (self.jobModel.status.integerValue == 1) {
                        cell.btnApply.enabled = NO;
                        [cell.btnApply setTitle:@" 待审核" forState:UIControlStateNormal];
                    }else if (self.jobModel.status.integerValue == 2){
                        if (self.jobModel.student_contact_status.integerValue == 1) {
                            [cell.btnApply setTitle:@"已联系" forState:UIControlStateNormal];
                            cell.btnApply.enabled = NO;
                        }else{
                            [cell.btnApply setTitle:@"电话联系报名" forState:UIControlStateNormal];
                            cell.btnApply.enabled = YES;
                        }
                    }else if (self.jobModel.status.integerValue == 3){
                        cell.btnApply.enabled = NO;
                        if (self.jobModel.job_close_reason.intValue == 1 || self.jobModel.job_close_reason.intValue == 2 ){
                            [cell.btnApply setTitle:@" 已过期" forState:UIControlStateNormal];
                        }else if(self.jobModel.job_close_reason.intValue == 3){
                            [cell.btnApply setTitle:@" 已下架" forState:UIControlStateNormal];
                        }else if(self.jobModel.job_close_reason.intValue == 4){
                            [cell.btnApply setTitle:@" 审核未通过" forState:UIControlStateNormal];
                        }
                    }                    
                }else{  //非采集岗位
                    if (self.isFromQrScan) {
                        if (self.jobModel.student_applay_status.intValue == 1 || self.jobModel.student_applay_status.intValue == 2){ // 已报名过
                            [cell.btnApply setTitle:@"已报名" forState:UIControlStateNormal];
                            cell.btnApply.enabled = NO;
                            if (self.jobModel.trade_loop_status.integerValue == 2){
                                [cell.btnApply setTitle:@"已录用" forState:UIControlStateNormal];
                                cell.btnApply.enabled = NO;
                            }else if (self.jobModel.trade_loop_finish_type.integerValue == 2){
                                [cell.btnApply setTitle:@"已拒绝" forState:UIControlStateNormal];
                                cell.btnApply.enabled = NO;
                            }
                        } else {
                            if (self.jobModel.job_type && self.jobModel.job_type.integerValue == 2) { // 抢单兼职
                                [cell.btnApply setTitle:@"立即抢单" forState:UIControlStateNormal];
                            } else { // 普通兼职
                                [cell.btnApply setTitle:@"报名" forState:UIControlStateNormal];
                            }
                            cell.btnApply.enabled = YES;
                        }
                    }else{
                        if (self.jobModel.status.intValue == 1) { // 待审核
                            cell.btnApply.enabled = NO;
                            [cell.btnApply setTitle:@" 待审核" forState:UIControlStateNormal];
                        }else if(self.jobModel.status.intValue == 2){ // 已发布
                            if (self.jobModel.student_applay_status.intValue == 0) { // 未报名
                                if (self.jobModel.has_been_filled.intValue == 0) {
                                    [cell.btnApply setTitle:@"报名" forState:UIControlStateNormal];
                                    cell.btnApply.enabled = YES;
                                }else if (self.jobModel.has_been_filled.intValue == 1){ // 已报满
                                    [cell.btnApply setTitle:@"已报满" forState:UIControlStateNormal];
                                    cell.btnApply.enabled = NO;
                                }
                            }else if (self.jobModel.student_applay_status.intValue == 1 || self.jobModel.student_applay_status.intValue == 2){ // 已报名过
                                [cell.btnApply setTitle:@"已报名" forState:UIControlStateNormal];
                                cell.btnApply.enabled = NO;
                                if (self.jobModel.trade_loop_status.integerValue == 2){
                                    [cell.btnApply setTitle:@"已录用" forState:UIControlStateNormal];
                                    cell.btnApply.enabled = NO;
                                }else if (self.jobModel.trade_loop_finish_type.integerValue == 2){
                                    [cell.btnApply setTitle:@"已拒绝" forState:UIControlStateNormal];
                                    cell.btnApply.enabled = NO;
                                }
                                
                            }
                        }else if(self.jobModel.status.intValue == 3){ // 已结束
                            cell.btnApply.enabled = NO;
                            if (self.jobModel.job_close_reason.intValue == 1 || self.jobModel.job_close_reason.intValue == 2 ){
                                [cell.btnApply setTitle:@" 已过期" forState:UIControlStateNormal];
                            }else if(self.jobModel.job_close_reason.intValue == 3){
                                [cell.btnApply setTitle:@" 已下架" forState:UIControlStateNormal];
                            }else if(self.jobModel.job_close_reason.intValue == 4){
                                [cell.btnApply setTitle:@" 审核未通过" forState:UIControlStateNormal];
                            }
                        }
                    }
                }

            }
            return cell;
        }
 
        default:
        {
            static NSString* cellIdentifier = @"cell";
            UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
            if (!cell) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
            }
            cell.textLabel.text = @"xxxx";
            return cell;
        }
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    JDCellType sectionType = [self getSectionTypeWithIndexPath:indexPath];
    switch (sectionType) {
        case JDCellType_rmwIntro:{
            WebView_VC *vc = [[WebView_VC alloc] init];
            vc.url = [NSString stringWithFormat:@"%@%@",URL_HttpServer ,KUrl_SocialAcIntrol];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case JDCellType_listApply:{
            /** 查看已报名兼客列表 */
            if (self.jobModel.source.integerValue != 1) {
                LookupApplyJKListController *vc = [[LookupApplyJKListController alloc] init];
                vc.jobId = self.jobId;
                [self.navigationController pushViewController:vc animated:YES];
            }
        }
            break;
        case JDCellType_epAuth:{
            // 判读是否登录
            if (self.jobModel.enterprise_info.verifiy_status.integerValue == 3) {
                WEAKSELF
                [[UserData sharedInstance] userIsLogin:^(id obj) {
                    if (obj) {
                        [TalkingData trackEvent:@"岗位详情_雇主信息入口"];
                        LookupEPInfo_VC* vc = [UIHelper getVCFromStoryboard:@"EP" identify:@"sid_lookupEPInfo"];
                        vc.lookOther = YES;
                        vc.enterpriseId = [NSString stringWithFormat:@"%@",self.jobDetailModel.parttime_job.enterprise_info.enterprise_id];
                        [weakSelf.navigationController pushViewController:vc animated:YES];
                    }
                }];
            }
            break;
        }
        case JDCellType_jkLike:{
            JobModel *model = [_sectionAry_suggestJob objectAtIndex:indexPath.row];
            JobDetail_VC *viewCtrl = [[JobDetail_VC alloc] init];
            viewCtrl.jobId = model.job_id.stringValue;
            [self.navigationController pushViewController:viewCtrl animated:YES];
        }
            break;
        default:
            break;
    }
            
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    JDGroupType groupType = [_sectionTypeArray[section] integerValue];
    switch (groupType) {
        case JDGroupType_jobBase:
            return _sectionAry_jobBase.count ? _sectionAry_jobBase.count : 0;
        case JDGroupType_address:
            return _sectionAry_address.count ? _sectionAry_address.count : 0;

        case JDGroupType_workTime:
            return _sectionAry_workTime.count ? _sectionAry_workTime.count : 0;

        case JDGroupType_workDetail:
            return _sectionAry_workDetail.count ? _sectionAry_workDetail.count : 0;
        
        case JDGroupType_contactInfo:
            return _sectionAry_contactInfo.count ? _sectionAry_contactInfo.count : 0;

        case JDGroupType_epQA:
            return _qaCellArray.count < 3 ? _qaCellArray.count : 3; //待修改

        case JDGroupType_apply:
            return 1;
        case JDGroupType_jkLike:
            return _sectionAry_suggestJob ? _sectionAry_suggestJob.count : 0;
        default:
            break;
    }
    
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    JDCellType sectionType = [self getSectionTypeWithIndexPath:indexPath];
    switch (sectionType) {
        case JDCellType_baozhaoIntro:
            return 54;
        case JDCellType_rmwIntro:
            return 50;
        case JDCellType_QA:{
            JobQAInfoModel* model = _qaCellArray[indexPath.row];
            return model.cellHeight;
        }
        case JDCellType_jkLike:
            return 94;
        default:
            break;
    }
    
    UITableViewCell* cell = [self tableView:tableView cellForRowAtIndexPath:indexPath];
    if (cell) {
        return cell.frame.size.height;
    }
    return 0;
}

- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{

    JDGroupType sectionType = [_sectionTypeArray[section]integerValue];
    if (sectionType == JDGroupType_epQA) {
        UIView *view = [[UIView alloc] init];
        
        UIView* viewHead = [[UIView alloc] initWithFrame:CGRectMake(0, 12, SCREEN_WIDTH, 48)];
        viewHead.backgroundColor = [UIColor whiteColor];
        [view addSubview:viewHead];
        
        UILabel* labTitle = [UILabel labelWithText:@"雇主答疑" textColor:[UIColor XSJColor_tBlackTinge] fontSize:15.0f];
        [viewHead addSubview:labTitle];
        
        UIButton* btnQuestion = [UIButton buttonWithType:UIButtonTypeCustom];
        btnQuestion.titleLabel.font = [UIFont systemFontOfSize:15];
        [btnQuestion setTitle:@"提问题" forState:UIControlStateNormal];
        [btnQuestion setTitleColor:[UIColor XSJColor_tBlue] forState:UIControlStateNormal];
        [viewHead addSubview:btnQuestion];
        [btnQuestion addTarget:self action:@selector(btnQuestionOnclick:) forControlEvents:UIControlEventTouchUpInside];
        
        [labTitle mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(viewHead).offset(16);
            make.centerY.equalTo(viewHead);
        }];
        
        [btnQuestion mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(labTitle);
            make.right.equalTo(viewHead).offset(-16);
        }];
        
        btnQuestion.hidden = self.userType == WDLoginType_Employer;
        
        return view;
    }else if (sectionType == JDGroupType_jkLike) {
        UIView *view = [[UIView alloc] init];
        
        UIView *viewHead = [[UIView alloc] initWithFrame:CGRectMake(0, 12, SCREEN_WIDTH, 48)];
        viewHead.backgroundColor = [UIColor whiteColor];
        [view addSubview:viewHead];
        
        UILabel* labTitle = [UILabel labelWithText:@"猜你喜欢" textColor:[UIColor XSJColor_tBlackTinge] fontSize:15.0f];
        [viewHead addSubview:labTitle];

        [labTitle mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(viewHead);
            make.left.equalTo(viewHead).offset(16);
        }];
        return view;
    }
    return nil;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    JDGroupType sectionType = [_sectionTypeArray[section]integerValue];
    if (sectionType == JDGroupType_epQA || sectionType == JDGroupType_jkLike) {
        return 60;
    }else if (sectionType == JDGroupType_jobBase){
        return 1;
    }
    return 12;
}

- (UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    JDGroupType sectionType = [_sectionTypeArray[section]integerValue];
    if (sectionType == JDGroupType_epQA && _qaCellArray.count >= 3) {
        SpecialButton *footView = [SpecialButton buttonWithType:UIButtonTypeCustom];
        footView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 44);
        [footView setTitle:@"查看更多" forState:UIControlStateNormal];
        [footView setBackgroundColor:[UIColor whiteColor]];
        [footView setImage:[UIImage imageNamed:@"job_icon_push"] forState:UIControlStateNormal];
        [footView addTarget:self action:@selector(pushMoreQA:) forControlEvents:UIControlEventTouchUpInside];
        footView.titleLabel.font = [UIFont systemFontOfSize:15.0f];
        [footView setTitleColor:[UIColor XSJColor_tBlackTinge] forState:UIControlStateNormal];
        return footView;
    }else if (sectionType == JDGroupType_contactInfo){
        UILabel *label = [UILabel labelWithText:@"联系我时,请说是在兼客兼职上看到的,谢谢!" textColor:[UIColor XSJColor_tGrayTinge] fontSize:15.0f];
        label.backgroundColor = [UIColor whiteColor];
        label.numberOfLines = 0;
        label.textAlignment = NSTextAlignmentCenter;
        return label;
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    JDGroupType sectionType = [_sectionTypeArray[section]integerValue];
    if ((sectionType == JDGroupType_epQA && _qaCellArray.count >= 3) || sectionType == JDGroupType_contactInfo) {
        return 44;
    }
    return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return _sectionTypeArray.count > 0 ? _sectionTypeArray.count : 0;
}


#pragma mark - 导航栏按钮
/** 缴纳保证金 */
- (void)payGuaranteeAmount{
    PaySelect_VC *viewCtrl = [[PaySelect_VC alloc] init];
    viewCtrl.fromType = PaySelectFromType_guaranteeAmount;
    viewCtrl.needPayMoney = (int)ceilf(self.jobModel.guarante_amount_pay_money.floatValue);
    viewCtrl.jobId = self.jobModel.job_id;
    viewCtrl.hidesBottomBarWhenPushed = YES;
    WEAKSELF
    viewCtrl.updateDataBlock = ^(id result){
        weakSelf.epPopMenu = nil;
        weakSelf.jobModel.guarantee_amount_status = @1;
    };
    [self.navigationController pushViewController:viewCtrl animated:YES];
}

/** 雇主分享岗位 */
- (void)shareClick{
    [self share];
}

- (void)share{
    WEAKSELF
    if ( self.jobModel.is_social_activist_job.integerValue == 1 ){  //人脉王岗位
        [[UserData sharedInstance] userIsLogin:^(id result) {
            [weakSelf shareJob];
        }];
    }else{
        [self shareJob];
    }
}

- (void)shareJob{
    WEAKSELF
    [ShareHelper platFormShareWithVc:weakSelf info:weakSelf.jobDetailModel.parttime_job.share_info_not_sms block:^(NSNumber *obj) {
        switch (obj.integerValue) {
            case ShareTypeInvitePerson: // 分享到人才库
            {
                [[UserData sharedInstance] entShareJobToTalentPoolWithJobId:weakSelf.jobId];
            }
                break;
            case ShareTypeIMGroup: // 分享到IM群组
            {
                ShareToGroupController *vc = [[ShareToGroupController alloc] init];
                vc.jobModel = weakSelf.jobDetailModel.parttime_job;
                [weakSelf.navigationController pushViewController:vc animated:YES];
            }
                break;
            default:
                break;
        }
        if (self.jobModel.is_social_activist_job.integerValue == 1 ){  //人脉王岗位
            [weakSelf sendShareRequest];
        }
    }];

}

- (void)sendShareRequest{
    NSString *content = [NSString stringWithFormat:@"job_id:%@",self.jobId];
    RequestInfo *request = [[RequestInfo alloc] initWithService:@"shijianke_shareSocialActivistJob" andContent:content];
    [request sendRequestWithResponseBlock:^(ResponseInfo *response) {
        ELog(@"分享请求成功");
    }];
}

- (void)addCollectionAction{
    
    [[UserData sharedInstance] userIsLogin:^(id result) {
        ELog(@"收藏");
        if (result) {
            if (self.jobModel.student_collect_status.integerValue == 1) {
                [self updateCollectStatus:NO];
                [[XSJRequestHelper sharedInstance] cancelCollectedJob:self.jobId block:^(id result) {
                    if (result) {
                        [UIHelper toast:@"成功取消收藏"];
                    }else{
                        [self updateCollectStatus:YES];
                    }
                }];
            }else if (self.jobModel.student_collect_status.integerValue == 0) {
                [self updateCollectStatus:YES];
                [[XSJRequestHelper sharedInstance] collectJob:self.jobId block:^(id result) {
                    if (result) {
                        [UIHelper toast:@"收藏成功"];
                    }else{
                        [self updateCollectStatus:NO];
                    }
                }];
            }
        }
    }];
    
    
}

/** 置顶/刷新/推送 */
- (void)pushAppreciteVC:(AppreciationType)type{
    JianKeAppreciation_VC *viewCtrl = [[JianKeAppreciation_VC alloc] init];
    viewCtrl.jobId = self.jobId;
    viewCtrl.serviceType = type;
    viewCtrl.popToVC = self;
    viewCtrl.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:viewCtrl animated:YES];
}

- (void)pushRefresh{
    JobAutoRefresh_VC *viewCtrl = [[JobAutoRefresh_VC alloc] init];
    viewCtrl.jobId = self.jobId;
    viewCtrl.popToVC = self;
    viewCtrl.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:viewCtrl animated:YES];
}

/** 雇主刷新岗位 */
- (void)reflushClick{
    ELog(@"进入刷新");
//    JobModel *model = self.jobDetailModel.parttime_job;
//    
//    WEAKSELF
//    [self getJobRefreshLeftCount:^(RefreshLeftCountModel* select) {
//        if (select.busi_power_gift_limit.intValue + select.busi_power_limit.intValue > 0) {
//            NSInteger leftCount = select.busi_power_gift_limit.intValue + select.busi_power_limit.intValue;
//            NSString* leftCountStr = [NSString stringWithFormat:@"今天还剩%ld次刷新岗位机会，是否确定刷新", (long)leftCount];
//            
//            [UIHelper showConfirmMsg:leftCountStr completion:^(DLAVAlertView *alertView, NSInteger buttonIndex) {
//                if (buttonIndex == 0) {
//                    return;
//                }else{
//                    [weakSelf updateParttimeJobRanking:model.job_id];
//                }
//            }];
//        }else{
//            [UIHelper showConfirmMsg:@"您今天已用完该权限...明天再来试试吧" title:@"提示" cancelButton:@"取消" completion:^(DLAVAlertView *alertView, NSInteger buttonIndex) {
//            }];
//        }
//    }];
}

/** 获取刷新次数 */
- (void)getJobRefreshLeftCount:(WdBlock_Id)block{
    NSString* content = @"";
    RequestInfo* request = [[RequestInfo alloc] initWithService:@"shijianke_getJobRefreshLeftCount" andContent:content];
    request.isShowLoading = NO;
    request.loadingMessage = @"数据加载中...";
    [request sendRequestWithResponseBlock:^(ResponseInfo *response) {
        if (response && [response success]) {
            if (block) {
                RefreshLeftCountModel *model=[RefreshLeftCountModel objectWithKeyValues:response.content];
                block(model);
            }
        }
    }];
}

/** 刷新岗位 */
- (void)updateParttimeJobRanking:(NSNumber *)jobId{
    NSString* content = [NSString stringWithFormat:@"job_id:%@", jobId];
    RequestInfo* request = [[RequestInfo alloc] initWithService:@"shijianke_updateParttimeJobRanking" andContent:content];
    request.isShowLoading = YES;
    request.loadingMessage = @"刷新中...";
    [request sendRequestWithResponseBlock:^(ResponseInfo *response) {
        if (response && [response success]) {
            ELog(@"刷新成功");
            [UserData delayTask:0.3 onTimeEnd:^{
                [UIHelper toast:@"刷新成功"];
            }];
        }
    }];
}

/** 雇主点击导航栏右侧下拉菜单 */
- (void)epDropDownMenuClick:(UIButton *)sender{
    if (self.epPopMenu) {
        [self.epPopMenu showMenuAtPoint:CGPointMake(self.view.width - 130, 55)];
    }
}

- (XHPopMenu *)epPopMenu{
    if (!_epPopMenu) {
        XHPopMenu *epPopMenu = nil;
        if (self.jobModel.status.integerValue == 2) {
            if (self.jobModel.guarantee_amount_status.integerValue == 0) {
                if (self.jobModel.job_type.integerValue == 5) {
                    XHPopMenuItem *popMenuCloseItem5 = [[XHPopMenuItem alloc] initWithImage:nil title:@"缴纳保证金"];
                    XHPopMenuItem *popMenuCloseItem0 = [[XHPopMenuItem alloc] initWithImage:nil title:@"分享岗位"];
                    XHPopMenuItem *popMenuCloseItem4 = [[XHPopMenuItem alloc] initWithImage:nil title:@"关闭岗位"];
                    epPopMenu = [[XHPopMenu alloc] initWithMenus:@[popMenuCloseItem5, popMenuCloseItem0, popMenuCloseItem4]];
                    
                    WEAKSELF
                    epPopMenu.popMenuDidSlectedCompled = ^(NSInteger index, XHPopMenuItem *menuItem){
                        switch (index) {
                            case 0:{
                                [weakSelf payGuaranteeAmount];
                            }
                                break;
                            case 1:{
                                [weakSelf shareClick];
                            }
                                break;
                            case 2:
                                [weakSelf closeJob];
                                break;
                            default:
                                break;
                        }
                    };
                }else{
                    XHPopMenuItem *popMenuCloseItem5 = [[XHPopMenuItem alloc] initWithImage:nil title:@"缴纳保证金"];
                    XHPopMenuItem *popMenuCloseItem0 = [[XHPopMenuItem alloc] initWithImage:nil title:@"分享岗位"];
                    XHPopMenuItem *popMenuCloseItem1 = [[XHPopMenuItem alloc] initWithImage:nil title:@"置顶"];
                    XHPopMenuItem *popMenuCloseItem2 = [[XHPopMenuItem alloc] initWithImage:nil title:@"刷新"];
                    XHPopMenuItem *popMenuCloseItem3 = [[XHPopMenuItem alloc] initWithImage:nil title:@"推送"];
                    XHPopMenuItem *popMenuCloseItem4 = [[XHPopMenuItem alloc] initWithImage:nil title:@"关闭岗位"];
                    epPopMenu = [[XHPopMenu alloc] initWithMenus:@[popMenuCloseItem5, popMenuCloseItem0, popMenuCloseItem1, popMenuCloseItem2, popMenuCloseItem3, popMenuCloseItem4]];
                    
                    WEAKSELF
                    epPopMenu.popMenuDidSlectedCompled = ^(NSInteger index, XHPopMenuItem *menuItem){
                        switch (index) {
                            case 0:{
                                [weakSelf payGuaranteeAmount];
                            }
                                break;
                            case 1:{
                                [weakSelf shareClick];
                            }
                                break;
                            case 2:
                                if (self.jobDetailModel.parttime_job.stick.integerValue == 1) {
                                    [UIHelper toast:@"岗位已处于置顶状态"];
                                    return;
                                }
                                [weakSelf pushAppreciteVC:Appreciation_stick_Type];
                                break;
                            case 3:
                                [weakSelf pushRefresh];
                                break;
                            case 4:
                                [weakSelf promoteJob];
                                break;
                            case 5:
                                [weakSelf closeJob];
                                break;
                            default:
                                break;
                        }
                    };
                }
                
            }else{
                if (self.jobModel.job_type.integerValue == 5) {
                    XHPopMenuItem *popMenuCloseItem0 = [[XHPopMenuItem alloc] initWithImage:nil title:@"分享岗位"];
                    XHPopMenuItem *popMenuCloseItem4 = [[XHPopMenuItem alloc] initWithImage:nil title:@"关闭岗位"];
                    
                    epPopMenu = [[XHPopMenu alloc] initWithMenus:@[popMenuCloseItem0, popMenuCloseItem4]];
                    WEAKSELF
                    epPopMenu.popMenuDidSlectedCompled = ^(NSInteger index, XHPopMenuItem *menuItem){
                        switch (index) {
                            case 0:{
                                [weakSelf shareClick];
                            }
                                break;
                            case 1:
                                [weakSelf closeJob];
                                break;
                            default:
                                break;
                        }
                    };
                }else{
                    XHPopMenuItem *popMenuCloseItem0 = [[XHPopMenuItem alloc] initWithImage:nil title:@"分享岗位"];
                    XHPopMenuItem *popMenuCloseItem1 = [[XHPopMenuItem alloc] initWithImage:nil title:@"置顶"];
                    XHPopMenuItem *popMenuCloseItem2 = [[XHPopMenuItem alloc] initWithImage:nil title:@"刷新"];
                    XHPopMenuItem *popMenuCloseItem3 = [[XHPopMenuItem alloc] initWithImage:nil title:@"推送"];
                    XHPopMenuItem *popMenuCloseItem4 = [[XHPopMenuItem alloc] initWithImage:nil title:@"关闭岗位"];
                    
                    epPopMenu = [[XHPopMenu alloc] initWithMenus:@[popMenuCloseItem0, popMenuCloseItem1, popMenuCloseItem2, popMenuCloseItem3, popMenuCloseItem4]];
                    WEAKSELF
                    epPopMenu.popMenuDidSlectedCompled = ^(NSInteger index, XHPopMenuItem *menuItem){
                        switch (index) {
                            case 0:{
                                [weakSelf shareClick];
                            }
                                break;
                            case 1:
                                if (self.jobDetailModel.parttime_job.stick.integerValue == 1) {
                                    [UIHelper toast:@"岗位已处于置顶状态"];
                                    return;
                                }
                                [weakSelf pushAppreciteVC:Appreciation_stick_Type];
                                break;
                            case 2:
                                [weakSelf pushAppreciteVC:Appreciation_Refresh_Type];
                                break;
                            case 3:
                                [weakSelf promoteJob];
                                break;
                            case 4:
                                [weakSelf closeJob];
                                break;
                            default:
                                break;
                        }
                    };
                }
                
            }
        }else if (self.jobModel.status.integerValue == 0){
            XHPopMenuItem *popMenuCloseItem0 = [[XHPopMenuItem alloc] initWithImage:nil title:@"编辑岗位"];
            XHPopMenuItem *popMenuCloseItem1 = [[XHPopMenuItem alloc] initWithImage:nil title:@"上架岗位"];
            
            epPopMenu = [[XHPopMenu alloc] initWithMenus:@[popMenuCloseItem0, popMenuCloseItem1]];

            WEAKSELF
            epPopMenu.popMenuDidSlectedCompled = ^(NSInteger index, XHPopMenuItem *menuItem){
                switch (index) {
                    case 0:{
                        [weakSelf editJob:YES];
                    }
                        break;
                    case 1:
                        [weakSelf rePostJob];
                        break;
                    default:
                        break;
                }
            };
        }
        
        _epPopMenu = epPopMenu;
    }
    return _epPopMenu;
}

- (void)editJob:(BOOL)isEdit{
    WEAKSELF
    [[XZTool sharedInstance] editJobWith:self.jobModel isEditAction:isEdit block:^(PostJob_VC *vc) {
        vc.block = ^(id result){
            [weakSelf getData];
        };
        [weakSelf.navigationController pushViewController:vc animated:YES];
    }];
}

- (void)rePostJob{
//    if (![[UserData sharedInstance] isEnableVipService]) {
//        if ([UserData sharedInstance].publishJobNumModel.authenticated_publish_job_num.integerValue >= 7) {  //非VIP 无权限发布了
//            [MKAlertView alertWithTitle:@"提示" message:@"今天您已经发布够多岗位，该岗位暂不上架显示招聘，等明天再来上架岗位吧" cancelButtonTitle:nil confirmButtonTitle:@"知道了" completion:nil];
//            return;
//        }
//    }
    
    WEAKSELF
    [[XSJRequestHelper sharedInstance] entJobSubmitAuditWithJobId:self.jobModel.job_id block:^(ResponseInfo *response) {
        if (response) {
            if (response.errCode.integerValue == 0) {   //提交成功
                [UIHelper toast:@"提交成功"];
                [UserData sharedInstance].isUpdateWithEPWaitJob = YES;
                [WDNotificationCenter postNotificationName:IMNotification_EPMainHeaderViewUpdate object:nil];
            }else if (response.errCode.integerValue == 87 && response.errMsg.length){ //有权限，但是时间不对
                [UIHelper toast:response.errMsg];
                [weakSelf editJob:NO];
            }else if (response.errCode.integerValue == 86 && response.errMsg.length){   //VIP城市，雇主没有提交审核权限
                [weakSelf showAlertWithLackOfCompetence:response.errMsg withJobId:weakSelf.jobModel.city_id];
            }else if (response.errMsg.length){
                [UIHelper toast:response.errMsg];
            }
        }
    }];
}

- (void)showAlertWithLackOfCompetence:(NSString *)message withJobId:(NSNumber *)cityId{
    
    [MKAlertView alertWithTitle:@"提示" message:message cancelButtonTitle:@"让顾问联系我" confirmButtonTitle:@"购买在招岗位数" supportCancelGesture:YES completion:^(UIAlertView *alertView, NSInteger buttonIndex) {
        if (buttonIndex == 1) {
            [self enterRecuitVC:cityId];
        }else if (buttonIndex == 0){
            [self enetrmemberCenter];
        }
    }];
    
}

- (void)enterRecuitVC:(NSNumber *)cityId{
    BuyJobNum_VC *viewCtrl = [[BuyJobNum_VC alloc] init];
    viewCtrl.recruit_city_id = cityId;
    viewCtrl.actionType = BuyJobNumActionType_ForReBuy;
    viewCtrl.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:viewCtrl animated:YES];
}

- (void)enetrmemberCenter{
    
    [[XSJRequestHelper sharedInstance] postSaleClueWithDesc:@"发布失败" isNeedContact:@0 isShowloading:YES block:^(id result) {
        if (result) {
            [UIHelper toast:@"信息已提交，请耐心等待顾问联系您~"];
        }
    }];

}

- (void)promoteJob{
    PushOrder_VC *viewCtrl = [[PushOrder_VC alloc] init];
    viewCtrl.jobId = self.jobId;
    viewCtrl.isFromJobManage = YES;
    viewCtrl.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:viewCtrl animated:YES];
}

/** 雇主关闭岗位 */
- (void)closeJob{
    JobModel *model = self.jobDetailModel.parttime_job;
    if (model.status.intValue == 2) {
        WEAKSELF
        [UIHelper showConfirmMsg:@"确定结束?" completion:^(DLAVAlertView *alertView, NSInteger buttonIndex) {
            if (buttonIndex == 0) {
                return;
            } else {
                [weakSelf closeJob:model.job_id];
            }
        }];
    }
}

/** 关闭岗位 **/
- (void)closeJob:(NSNumber *)jobId{
    NSString* content = [NSString stringWithFormat:@"job_id:%@", jobId];
    RequestInfo* request = [[RequestInfo alloc] initWithService:@"shijianke_closeJob" andContent:content];
    request.isShowLoading = NO;
    request.loadingMessage = @"数据加载中...";
    WEAKSELF
    [request sendRequestWithResponseBlock:^(ResponseInfo *response) {
        if (response && [response success]) {
            if (response.errCode.intValue==0) {
                [UIHelper toast:@"关闭成功"];
                [[UserData sharedInstance] setIsUpdateWithEPHome:YES];
                [[UserData sharedInstance] setIsUpdateWithEPEndJob:YES];
                [[UserData sharedInstance] setIsUpdateWithEPHeaderView:YES];
                [weakSelf.navigationController popViewControllerAnimated:YES];
            }
        }
    }];
}

#pragma mark - 按钮点击
#pragma mark - JDCellType_bus
/** 公交线路按钮点击 */
- (void)btnBusOnclick:(UIButton *)sender{
    BusMap_VC* vc = [UIHelper getVCFromStoryboard:@"Public" identify:@"sid_busMap"];
    vc.workPlace = self.jobDetailModel.parttime_job.working_place;
    vc.city = self.jobDetailModel.parttime_job.city_name;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - JDCellType_contact
/** 兼客拨打雇主电话 */
- (void)btnCallPhoneOnclick:(UIButton *)sender{
    JobModel *jobModel = self.jobDetailModel.parttime_job;
    if (jobModel.student_applay_status.intValue == 1 || jobModel.student_applay_status.intValue == 2){ // 已报名过
        [self phoneClick:sender];
    } else {
        [MKAlertView alertWithTitle:@"报名后，才可以拨打雇主电话" message:nil cancelButtonTitle:@"我知道了" confirmButtonTitle:nil completion:nil];
    }
}


/** 查看更多问题 */
- (void)pushMoreQA:(UIButton *)sender{
    JobQA_VC *viewCtrl = [[JobQA_VC alloc] init];
    viewCtrl.jobId = self.jobId;
    [self.navigationController pushViewController:viewCtrl animated:YES];
}

- (void)phoneClick:(UIButton *)sender{
    WEAKSELF
    [[UserData sharedInstance] userIsLogin:^(id obj) {
        if (obj) {
            [[MKOpenUrlHelper sharedInstance] makeAlertCallWithPhone:weakSelf.jobDetailModel.parttime_job.contact.phone_num block:^(id result) {
                [WDNotificationCenter addObserver:weakSelf selector:@selector(showSheet) name:UIApplicationWillResignActiveNotification object:nil];
            }];
        }
    }];
}

/** 兼客与雇主聊天 */
- (void)chatWithEPClick:(UIButton *)sender{
    // 判读是否登录
    WEAKSELF
    [[UserData sharedInstance] userIsLogin:^(id obj) {
        if (obj) {
            if (weakSelf.jobDetailModel.im_open_status && weakSelf.jobDetailModel.im_open_status.integerValue == 1) { // 有开通IM
                NSString *jobTitle = weakSelf.jobDetailModel.parttime_job.job_title;
                NSString* content = [NSString stringWithFormat:@"\"accountId\":\"%@\"", weakSelf.jobDetailModel.account_id];
                RequestInfo* request = [[RequestInfo alloc] initWithService:@"shijianke_im_getUserPublicInfo" andContent:content];
                request.isShowLoading = NO;
                [request sendRequestToImServer:^(ResponseInfo* response) {
                    if (response && [response success]) {
                        [WDChatView_VC openPrivateChatOn:weakSelf accountId:weakSelf.jobDetailModel.account_id withType:WDImUserType_Employer jobTitle:jobTitle jobId:weakSelf.jobId];
                    }
                }];
            } else {
                [UIHelper toast:@"对不起,该用户未开通IM功能"];
            }
        }
    
    }];
}

/** 兼客查看雇主简历 */
- (void)lookupEPResumeClick:(UIButton *)sender{
    // 判读是否登录
    WEAKSELF
    [[UserData sharedInstance] userIsLogin:^(id obj) {
        if (obj) {
            [TalkingData trackEvent:@"岗位详情_雇主信息入口"];
            
            LookupEPInfo_VC* vc = [UIHelper getVCFromStoryboard:@"EP" identify:@"sid_lookupEPInfo"];
            vc.lookOther = YES;
            vc.enterpriseId = [NSString stringWithFormat:@"%@",self.jobDetailModel.parttime_job.enterprise_info.enterprise_id];
            [weakSelf.navigationController pushViewController:vc animated:YES];
        }
 
    }];
}


#pragma mark - JDCellType_apply
//快捷举报
- (void)btnComplainOnclick:(UIButton *)sender {
    UIAlertView *informAlertView = [[UIAlertView alloc] initWithTitle:@"举报雇主" message:@"请选择您的举报原因。经查证如不属实将影响您的信用度!" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"岗位已过期", @"收费/虚假信息", @"到岗不予录用", @"联系客服", nil];
    informAlertView.tag = 129;
    [informAlertView show];
}


- (void)applyClick:(UIButton*)sender{
    // 判读是否登录
    WEAKSELF
    [[UserData sharedInstance] userIsLogin:^(id obj) {
        if (obj) {
            if (weakSelf.userType == WDLoginType_JianKe) {
                if (weakSelf.jobModel.source.integerValue == 1) {   //采集岗位 (未登录时如何处理??)
                    [[UserData sharedInstance] userIsLogin:^(id result) {
                        [weakSelf phoneClick:sender];
                    }];
                }else{
                    [weakSelf applyEvent];
                }
                
            }else if (weakSelf.userType == WDLoginType_Employer){    //邀请人才
                [[UserData sharedInstance] entShareJobToTalentPoolWithJobId:weakSelf.jobId];
            }
        }

    }];
}

- (void)applyEvent{
    JobModel *jobModel = self.jobDetailModel.parttime_job;
    
    if (jobModel.job_type.integerValue == 2) { // 抢单
        // 判断抢单资格
        JKModel *jkModel = [[UserData sharedInstance] getJkModelFromHave];
        // 认证中 && 不是第一次抢单
        if (jkModel.id_card_verify_status.integerValue == 2 && !jkModel.is_first_grab_single) {
            [XSJUIHelper showAlertWithTitle:@"认证中" message:@"您的认证正在进行中...请耐心等待客服审核完成再来抢单!" okBtnTitle:@"确定"];
            return;
        }
        // 不是已认证 && 不是第一次抢单
        if (jkModel.id_card_verify_status.integerValue != 3 && !jkModel.is_first_grab_single) {
            // 提示去认证
            [MKAlertView alertWithTitle:@"认证提示" message:@"抢单资格不足，您要花几分钟时间认证身份证。" cancelButtonTitle:@"取消" confirmButtonTitle:@"确定" completion:^(UIAlertView *alertView, NSInteger buttonIndex) {
                if (buttonIndex == 1) {
                    IdentityCardAuth_VC *verifyVc = [[IdentityCardAuth_VC alloc] init];
                    [self.navigationController pushViewController:verifyVc animated:YES];
                }
            }];
        }
        // 不是已认证 && 是第一次抢单 && 未完善名字
        if (jkModel.id_card_verify_status.integerValue != 3 && jkModel.is_first_grab_single && (!jkModel.true_name || (jkModel.true_name && jkModel.true_name.length < 1))) {
            // 弹出完善提示
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"完善姓名" message:@"请填写真实姓名" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
            alertView.alertViewStyle = UIAlertViewStylePlainTextInput;
            alertView.tag = 121;
            UITextField *nameTextField = [alertView textFieldAtIndex:0];
            nameTextField.placeholder = @"真实姓名";
            [alertView show];
            return;
        }
        
        // 具备抢单资格了..
        NSString *startDateStr = [DateHelper getDateFromTimeNumber:@(jobModel.work_time_start.longValue * 1000)];
        NSString *endDateStr = [DateHelper getDateFromTimeNumber:@(jobModel.work_time_end.longValue * 1000)];
        if ([startDateStr isEqualToString:endDateStr]) { // 只有一天
            // 弹框确定报名
            [self checkApplyJob];
        } else {
            // 弹出选择日期控件
            [self selectWorkDate];
        }
    }else { // 普通        if (jobModel.job_type.integerValue == 1 || jobModel.job_type.integerValue == 4)
        // 检测是否完善了姓名
        NSString *trueName = [[UserData sharedInstance] getUserTureName];
        
        if (!trueName || trueName.length < 1) {
            WEAKSELF
            [[UserData sharedInstance] getJKModelWithBlock:^(JKModel *jkModel) {
                if (!jkModel || jkModel.true_name.length < 1) {
                    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"完善姓名" message:@"请填写真实姓名" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
                    alertView.alertViewStyle = UIAlertViewStylePlainTextInput;
                    alertView.tag = 121;
                    UITextField *nameTextField = [alertView textFieldAtIndex:0];
                    nameTextField.placeholder = @"真实姓名";
                    [alertView show];
                }else{
                    [weakSelf judgeAboutAccurateJob];
                }
            }];
        }else{
            [self judgeAboutAccurateJob];
        }
    }
}

- (void)judgeAboutAccurateJob{
    if (self.jobDetailModel.parttime_job.is_accurate_job.integerValue == 1) {   //精确岗位
        NSString *startDateStr = [DateHelper getDateFromTimeNumber:@(self.jobDetailModel.parttime_job.work_time_start.longValue * 1000)];
        NSString *endDateStr = [DateHelper getDateFromTimeNumber:@(self.jobDetailModel.parttime_job.work_time_end.longValue * 1000)];
        if ([startDateStr isEqualToString:endDateStr]) { // 只有一天
            NSDate *workDate = [NSDate dateWithTimeIntervalSince1970:self.jobDetailModel.parttime_job.working_time_start_date.longLongValue * 0.001];
            workDate = [DateHelper zeroTimeOfDate:workDate];
            self.workTime = [NSMutableArray arrayWithObject:@(workDate.timeIntervalSince1970)];
            // 弹框确定报名
            [self checkApplyJob];
        } else {
            // 弹出选择日期控件
            [self selectWorkDate];
        }
    }else{  //松散岗位
        // 弹框确定报名
        [self checkApplyJob];
    }
}

/** 弹框确定报名 */
- (void)checkApplyJob{
    // 有报名限制就进入报名限制页面
    if ([self isSetCondition] && !self.isFromQrScan) {
        NSString *startDateStr = [DateHelper getDateFromTimeNumber:@(self.jobDetailModel.parttime_job.work_time_start.longValue * 1000)];
        NSString *endDateStr = [DateHelper getDateFromTimeNumber:@(self.jobDetailModel.parttime_job.work_time_end.longValue * 1000)];
        
        if ([startDateStr isEqualToString:endDateStr]) { // 只有一天
            [self goToConditionVcWithCalendar:YES];
        } else {
            [self goToConditionVcWithCalendar:NO];
        }
        return;
    }
    // 弹框确定报名
    [MKAlertView alertWithTitle:@"报名确认" message:@"确定报名吗? 上岗后要努力工作唷~" cancelButtonTitle:@"取消" confirmButtonTitle:@"确定" completion:^(UIAlertView *alertView, NSInteger buttonIndex) {
        if (buttonIndex == 1) {
            if (self.jobDetailModel.parttime_job.job_type.integerValue == 1) { // 普通
                // 发送报名请求
                [self applyJobWithJobId:self.jobId workTime:self.workTime];
            } else { // 抢单
                // 判断余额是否够支付保证金
                [self checkMoney];
            }
        }
    }];
}

// 弹出选择日期控件
- (void)selectWorkDate{
    // 有报名限制就进入报名限制页面
    if ([self isSetCondition] && !self.isFromQrScan) {
        [self goToConditionVcWithCalendar:YES];
        return;
    }
    
    // 精确岗位,请求可报名日期
    if (self.jobDetailModel.parttime_job.is_accurate_job && self.jobDetailModel.parttime_job.is_accurate_job.integerValue == 1 && !self.isFromQrScan) {
        
        WEAKSELF
        [[UserData sharedInstance] queryJobCanApplyDateWithJobId:self.jobDetailModel.parttime_job.job_id resumeId:nil block:^(ResponseInfo *response) {
            
            NSArray *numArray = response.content[@"job_can_apply_date"];
            
            NSMutableArray *dateArray = [NSMutableArray array];
            for (NSString *num in numArray) {
                NSDate *date = [NSDate dateWithTimeIntervalSince1970:num.longLongValue * 0.001];
                [dateArray addObject:date];
            }
            
            NSMutableArray *canApplyDateArray = [NSMutableArray array];
            NSDate *today = [NSDate date]; // 转化成今天0点0分
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            formatter.dateFormat = @"yyyy-MM-dd";
            NSString *todayStr = [formatter stringFromDate:today];
            formatter.dateFormat = @"yyyy-MM-dd HH-mm-ss";
            todayStr = [NSString stringWithFormat:@"%@ 00:00:00", todayStr];
            today = [formatter dateFromString:todayStr];
            
            for (NSDate *date in dateArray) {
                if ([date isLaterThanOrEqualTo:today]) {
                    [canApplyDateArray addObject:date];
                }
            }
            [weakSelf showDateSelectViewWithDateArray:canApplyDateArray];
        }];
    } else {
        [self showDateSelectViewWithDateArray:nil];
    }
}

- (void)showDateSelectViewWithDateArray:(NSArray *)dateArray{
    DLAVAlertView *dateSelectAlertView = [[DLAVAlertView alloc] initWithTitle:@"请选择兼职日期" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 260, 300)];
    
    DateSelectView *dateView = [[DateSelectView alloc] initWithFrame:CGRectMake(0, 0, 260, 260)];
    NSDate *startDate = [NSDate dateWithTimeIntervalSince1970:self.jobDetailModel.parttime_job.work_time_start.longValue];
    NSDate *endDate = [NSDate dateWithTimeIntervalSince1970:self.jobDetailModel.parttime_job.work_time_end.longValue];
    if (startDate.timeIntervalSince1970 < [NSDate date].timeIntervalSince1970) {
        startDate = [NSDate date];
    }
    
    if (!dateArray) {
        dateView.startDate = startDate;
        dateView.endDate = endDate;
    } else {
        dateView.canSelDateArray = dateArray;
    }
    
    [contentView addSubview:dateView];
    
    // 全选按钮
    UIButton *selectBtn = [[UIButton alloc] initWithFrame:CGRectMake(200, 260, 90, 32)];
    [selectBtn setTitle:@"全选" forState:UIControlStateNormal];
    [selectBtn setImage:[UIImage imageNamed:@"pay_btn_select_0"] forState:UIControlStateNormal];
    [selectBtn setImage:[UIImage imageNamed:@"pay_btn_select_1"] forState:UIControlStateSelected];
    [selectBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [selectBtn addTarget:self action:@selector(selectBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    selectBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
    selectBtn.contentEdgeInsets = UIEdgeInsetsMake(0, -25, 0, 0);
    selectBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    selectBtn.layer.cornerRadius = 15;
    selectBtn.layer.borderColor = MKCOLOR_RGB(200, 199, 204).CGColor;
    selectBtn.layer.borderWidth = 0.5;
    selectBtn.layer.masksToBounds = YES;
    selectBtn.tagObj = dateView;
    [contentView addSubview:selectBtn];
    
    dateSelectAlertView.contentView = contentView;
    dateSelectAlertView.contentMode = UIViewContentModeCenter;
    WEAKSELF
    [dateSelectAlertView showWithCompletion:^(DLAVAlertView *alertView, NSInteger buttonIndex) {
        if (buttonIndex == 1) {
            if (dateView.datesSelected.count < 1) {
                [UIHelper toast:@"必须至少选择一天才能报名"];
                return;
            }
            // 保存报名数组
            weakSelf.workTime = [NSMutableArray array];
            for (NSDate *date in dateView.datesSelected) {
                [weakSelf.workTime addObject:@([date timeIntervalSince1970])];
            }
            
            // 日期排序
            NSArray *tmpWorkTime = [weakSelf.workTime sortedArrayUsingComparator:^NSComparisonResult(NSNumber *obj1, NSNumber *obj2) {
                if (obj1.longLongValue < obj2.longLongValue) {
                    return NSOrderedAscending;
                } else {
                    return NSOrderedDescending;
                }
            }];
            weakSelf.workTime = [NSMutableArray arrayWithArray:tmpWorkTime];
            // 弹框确定报名
            [weakSelf checkApplyJob];
        }
    }];
}

/** 日历全选点击 */
- (void)selectBtnClick:(UIButton *)btn{
    DateSelectView *dateView = (DateSelectView *)btn.tagObj;
    
    NSArray *allDateArray;
    if (dateView.canSelDateArray) {
        allDateArray = dateView.canSelDateArray;
    } else {
        allDateArray = [DateHelper dateRangeArrayBetweenBeginDate:dateView.startDate endDate:dateView.endDate];
    }

    if (!allDateArray.count) {
        return;
    }
    
    if (!btn.selected) {
        dateView.datesSelected = [NSMutableArray arrayWithArray:allDateArray];
    } else {
        dateView.datesSelected = [NSMutableArray array];
    }
    
    btn.selected = !btn.selected;
    [dateView setNeedsLayout];
}

/** 进入条件限制页面 */
- (void)goToConditionVcWithCalendar:(BOOL)isShowCalendar{
    JobApplyConditionController *vc = [[JobApplyConditionController alloc] init];
    vc.showCalendar = isShowCalendar;
    vc.jobModel = self.jobDetailModel.parttime_job;
    vc.jobDetailVC = self;
    [self.navigationController pushViewController:vc animated:YES];
}

/** 是否进行条件筛选 */
- (BOOL)isSetCondition{
    JobModel *jobModel = self.jobDetailModel.parttime_job;
    if (jobModel.sex) {
        return YES;
    }
    if (jobModel.age && jobModel.age.intValue != 0) {
        return YES;
    }
    if (jobModel.height && jobModel.height.intValue != 0) {
        return YES;
    }
    if (jobModel.rel_name_verify && jobModel.rel_name_verify.intValue != 0) {
        return YES;
    }
    if (jobModel.life_photo && jobModel.life_photo.intValue != 0) {
        return YES;
    }
    if (jobModel.apply_job_date) {
        return YES;
    }
    if (jobModel.health_cer && jobModel.health_cer.intValue != 0) {
        return YES;
    }
    if (jobModel.stu_id_card && jobModel.stu_id_card.intValue != 0) {
        return YES;
    }
    return NO;
}

#pragma mark - JDGroupType_QA
- (void)btnQuestionOnclick:(UIButton*)sender{
    // 判读是否登录
    [[UserData sharedInstance] userIsLogin:^(id obj) {
        if (obj) {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提问" message:@"有什么问题要问雇主呢?" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
            alertView.alertViewStyle = UIAlertViewStylePlainTextInput;
            alertView.tag = 141;
            [alertView show];
        }
    }];
}

- (void)btnAnswerOnclick:(UIButton*)sender{
    JobQAInfoModel *model = [_qaCellArray objectAtIndex:sender.tag];
    if (model) {
        self.qaAnswerModel = model;
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"回复" message:@"回复兼客提问" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        alertView.alertViewStyle = UIAlertViewStylePlainTextInput;
        alertView.tag = 142;
        [alertView show];
    }
}

- (void)btnReportOnclick:(UIButton*)sender{
    [UIHelper toast:@"举报成功"];
}

#pragma mark - UIAlert delegate
- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex{
    [self.view endEditing:YES];
    
    if (alertView.tag == 121) {
        if (buttonIndex == 1) {
            UITextField *nameTextField = [alertView textFieldAtIndex:0];
            if (!nameTextField.text || nameTextField.text.length < 2 || nameTextField.text.length > 5) {
                [UIHelper toast:@"请填写真实姓名"];
                [alertView show];
                return;
            }
            
            // 发送完善姓名的请求
            WEAKSELF
            [[UserData sharedInstance] stuUpdateTrueName:nameTextField.text block:^(ResponseInfo *response) {
                if (response && response.success) {
                    // 保存姓名
                    [[UserData sharedInstance] setUserTureName:nameTextField.text];
                    if (weakSelf.jobDetailModel.parttime_job.job_type.integerValue == 1) {
                        // 弹出选择日期控件
                        [weakSelf selectWorkDate];
                    } else {
                        // 具备抢单资格了..
                        NSString *startDateStr = [DateHelper getDateFromTimeNumber:@(weakSelf.jobDetailModel.parttime_job.work_time_start.longValue * 1000)];
                        NSString *endDateStr = [DateHelper getDateFromTimeNumber:@(weakSelf.jobDetailModel.parttime_job.work_time_end.longValue * 1000)];
                        if ([startDateStr isEqualToString:endDateStr]) { // 只有一天
                            // 弹框确定报名
                            [weakSelf checkApplyJob];
                        } else {
                            // 弹出选择日期控件
                            [weakSelf selectWorkDate];
                        }
                    }
                }
            }];
        }
    }else if (alertView.tag == 124 && buttonIndex == 1){
        // 跳转到钱袋子
        MoneyBag_VC *moneyVc = [UIHelper getVCFromStoryboard:@"JK" identify:@"sid_moneybag"];
        [self.navigationController pushViewController:moneyVc animated:YES];
    }
    else if (alertView.tag == 129) {
        NSString *reason;
        switch (buttonIndex) {
            case 1: // 岗位已过期
            {
                reason = @"岗位已过期";
                [self informEpWithReason:reason];
            }
                break;
            case 2: // 收费/虚假信息
            {
                reason = @"收费/虚假信息";
                [self informEpWithReason:reason];
            }
                break;
            case 3: // 到岗不予录用
            {
                reason = @"到岗不予录用";
                [self informEpWithReason:reason];
            }
                break;
            case 4: // 联系客服
            {
//                reason = @"联系客服";
                [[UserData sharedInstance] userIsLogin:^(id obj) {
                    if (obj) {
                        UIViewController *chatViewController = [ImDataManager getKeFuChatVC];
                        [self.navigationController pushViewController:chatViewController animated:YES];
                    }
                }];
            }
                break;
                
            default:
                break;
        }
    }else if (alertView.tag == 141){
        if (buttonIndex == 1) {
            UITextField *textField = [alertView textFieldAtIndex:0];
            if (textField.text.length < 1) {
                [UIHelper toast:@"提问内容不能为空"];
                [alertView show];
                return;
            }
            WEAKSELF
            [[UserData sharedInstance] stuJobQuestionWithJobId:self.jobId quesiton:textField.text block:^(id obj) {
                [UIHelper toast:@"发送成功"];
                [weakSelf getQAListDataScrollToBottom:YES];
            }];
            
        }
    }else if (alertView.tag == 142){    //回复
        if (buttonIndex == 1) {
            UITextField *textField = [alertView textFieldAtIndex:0];
            if (textField.text.length < 1) {
                [UIHelper toast:@"回复内容不能为空"];
                [alertView show];
                return;
            }
            WEAKSELF
            [[UserData sharedInstance] entJobAnswerWithJobId:self.jobId quesitonId:[self.qaAnswerModel.qa_id description] answer:textField.text block:^(id obj) {
                if (obj) {
                    [UIHelper toast:@"发送成功"];
                    [weakSelf getQAListDataScrollToBottom:YES];
                }
            }];
        }
    }
}

/** 判断余额是否够支付保证金 */
- (void)checkMoney{
    JKModel *jkModel = [[UserData sharedInstance] getJkModelFromHave];
    if (jkModel.bond.doubleValue > jkModel.acct_amount.doubleValue) { // 余额不足
        // 弹框提示充值
        NSString *message = [NSString stringWithFormat:@"当前岗位需要支付%.2f元保证金,但您目前的余额不足以支付保证金，立即充值?", jkModel.bond.doubleValue * 0.01];
        UIAlertView *moneyAlertView = [[UIAlertView alloc] initWithTitle:@"余额不足" message:message delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        moneyAlertView.tag = 124;
        [moneyAlertView show];
    } else { // 余额充足
        if (jkModel.bond && jkModel.bond.doubleValue > 0) { // 保证金大于0
            // 弹框提醒扣款
            NSString *message = [NSString stringWithFormat:@"高薪职位抢单要先扣%.2f诚信金，只要您不放鸽子，平台立即返还全额。如果临时有事，您也别担心，可以和雇主协商后退回诚信金", (double)jkModel.bond.doubleValue * 0.01];
            WEAKSELF
            [UIHelper showConfirmMsg:@"提醒" title:message cancelButton:@"取消" okButton:@"确定" completion:^(DLAVAlertView *alertView, NSInteger buttonIndex) {
                if (buttonIndex == 1) {
                    // 发送报名请求
                    [weakSelf applyJobWithJobId:self.jobDetailModel.parttime_job.job_id.description workTime:self.workTime];
                }
            }];
         
        } else {
            // 发送报名请求
            [self applyJobWithJobId:self.jobDetailModel.parttime_job.job_id.description workTime:self.workTime];
        }
    }
}

/** 报名 */
- (void)applyJobWithJobId:(NSString *)jobId workTime:(NSArray *)workTime{
    NSNumber *isFromQrCodeScan = @(0);
    if (self.isFromQrScan) {
        isFromQrCodeScan = @(1);
    }
    WEAKSELF
    [[UserData sharedInstance] candidateApplyJobWithJobId:jobId workTime:workTime isFromQrCodeScan:isFromQrCodeScan block:^(ResponseInfo *response) {
        if (response && response.success) {
            [UIHelper toast:@"报名成功"];
            ApplySuccess_VC *vc = [[ApplySuccess_VC alloc] init];
            vc.jobModel = weakSelf.jobModel;
            [weakSelf.navigationController pushViewController:vc animated:YES];
        }
    }];
}

/** 举报 */
- (void)informEpWithReason:(NSString *)reason{
    NSNumber *feedback_type = @(3);
    NSString *desc = reason;
    NSNumber *job_id = self.jobDetailModel.parttime_job.job_id;
    
    NSString *content = [NSString stringWithFormat:@"feedback_type:\"%lu\", desc:\"%@\", job_id:\"%lu\"", (unsigned long)feedback_type.unsignedIntegerValue, desc, (unsigned long)job_id.unsignedIntegerValue];
    RequestInfo *request = [[RequestInfo alloc] initWithService:@"shijianke_submitFeedback_v2" andContent:content];
    request.isShowLoading = NO;
    request.loadingMessage = @"数据发送中...";
    
    WEAKSELF
    [request sendRequestWithResponseBlock:^(ResponseInfo *response) {
        if (response && response.success) {
            [UIHelper toast:@"举报成功"];
            weakSelf.jobDetailModel.is_complainted = @(1);
            [weakSelf.tableView reloadData];
        }
    }];
}


#pragma mark - other
- (void)backToLastView{
    if (self.isFromQrScan) {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
}

//发送日志
- (void)sendLog{
    CityModel* cityModel = [[UserData sharedInstance] city];
    NSString *content = [NSString stringWithFormat:@"\"job_id\":\"%@\",\"city_id\":\"%@\",\"access_client_type\":\"%@\"", self.jobId, cityModel? cityModel.id : @"211",[XSJUserInfoData getClientType]];
    RequestInfo *request = [[RequestInfo alloc] initWithService:@"shijianke_jobAccessLogRecord" andContent:content];
    request.isShowLoading = self.isFirstShowJob;
    [request sendRequestWithResponseBlock:^(ResponseInfo *response) {
        if (response && response.success) {
            ELog(@"====log 发送成功");
        }
    }];
}

- (void)updateCollectStatus:(BOOL)isCollect{
    UIButton *button;
    if(self.isFromJobViewController){
        UIBarButtonItem *item = [self.parentViewController.navigationItem.rightBarButtonItems lastObject];
        button = (UIButton *)item.customView;
    }else{
        UIBarButtonItem *item = [self.navigationItem.rightBarButtonItems lastObject];
        button = (UIButton *)item.customView;
    }
    if (!isCollect) {
        button.selected = NO;
        self.jobModel.student_collect_status= @0;
    }else{
        button.selected = YES;
        self.jobModel.student_collect_status= @1;
    }

}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
}

- (void)dealloc{
    ELog(@"jobDetail dealloc");
//    [WDNotificationCenter removeObserver:self];
}

- (void)showSheet{
    ELog(@"打完电话");
    [WDNotificationCenter removeObserver:self name:UIApplicationWillResignActiveNotification object:nil];
    NSArray *titles = @[@"报名成功", @"没被录用", @"岗位已招满", @"电话无法接通", @"其他"];
    [MKActionSheet sheetWithTitle:@"电话联系雇主后，报名成功了吗？" buttonTitleArray:titles isNeedCancelButton:NO maxShowButtonCount:5 block:^(MKActionSheet *actionSheet, NSInteger buttonIndex) {
        self.jobModel.student_contact_status = @1;
        if (buttonIndex == 3) {
            self.jobModel.student_contact_status = @0;
        }else if (buttonIndex == 4) {
            self.jobModel.student_contact_status = @0;
            [self pushOtherVC:@(5)];
            return;
        }
        NSNumber *type = @(buttonIndex + 1);
        WEAKSELF
        [[XSJRequestHelper sharedInstance] postStuContactApplyJob:weakSelf.jobDetailModel.parttime_job.job_id.stringValue resultType:type remark:nil block:^(ResponseInfo *response) {
            if (response && response.success) {
                [weakSelf.tableView reloadData];
            }else{
                self.jobModel.student_contact_status = @0;
            }
        }];
    }];
}

- (void)pushOtherVC:(NSNumber *)type{
    PhoneRecallCourse_VC *viewCtrl = [[PhoneRecallCourse_VC alloc] init];
    viewCtrl.jobId = self.jobId;
    viewCtrl.type = type;
    viewCtrl.block = ^(BOOL contactStatus){
        self.jobModel.student_contact_status = contactStatus ? @1 : @0 ;
        [self.tableView reloadData];
    };
    [self.navigationController pushViewController:viewCtrl animated:YES];
}

- (void)rightItemOnClick{
    if (self.jobDetailModel.parttime_job.status.integerValue == 1) {
        [self closeWaitJob];
    }else{
        WEAKSELF
        [[XZTool sharedInstance] fastPostModel:self.jobDetailModel.parttime_job block:^(UIViewController *result) {
            [weakSelf.navigationController pushViewController:result animated:YES];
        }];
    }
}

- (void)closeWaitJob{
    
    [UIHelper showConfirmMsg:@"确定关闭岗位?" completion:^(DLAVAlertView *alertView, NSInteger buttonIndex) {
        if (buttonIndex == 0) {
            return;
        } else {
            NSString* content = [NSString stringWithFormat:@"job_id:%@", self.jobDetailModel.parttime_job.job_id];
            RequestInfo* request = [[RequestInfo alloc] initWithService:@"shijianke_closeJob" andContent:content];
            request.isShowLoading = NO;
            request.loadingMessage = @"数据加载中...";
            WEAKSELF
            [request sendRequestWithResponseBlock:^(ResponseInfo *response) {
                if (response && [response success]) {
                    if (response.errCode.intValue==0) {
                        [UIHelper toast:@"关闭成功"];
                        [[UserData sharedInstance] setIsUpdateWithEPWaitJob:YES];
                        [[UserData sharedInstance] setIsUpdateWithEPEndJob:YES];
                        [[UserData sharedInstance] setIsUpdateWithEPHeaderView:YES];
                        [self.navigationController popToRootViewControllerAnimated:YES];
                    }
                }
            }];
        }
    }];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
