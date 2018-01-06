//
//  JKManage_NewVC.m
//  JKHire
//
//  Created by yanqb on 2017/4/6.
//  Copyright © 2017年 xianshijian. All rights reserved.
//

#import "JKManage_NewVC.h"
#import "JobDetailModel.h"
#import "JobModel.h"
#import "ApplyJobModel.h"
#import "JKMange_HeaderView.h"
#import "JKMangeView_JobVasNormal.h"
#import "JKManageView_JobVasEnd.h"
#import "ApplyCell.h"
#import "JKMangeBannerView.h"
#import "JobDetail_VC.h"
#import "JobVasOrder_VC.h"
#import "JianKeAppreciation_VC.h"
#import "PushOrder_VC.h"
#import "WDChatView_VC.h"
#import "PostPersonalJob_VC.h"
#import "PostJob_VC.h"
#import "JKCallList_VC.h"
#import "JiankeCollection_VC.h"
#import "JKManageView_HeaderRestrict.h"
#import "WebView_VC.h"
#import "JobAutoRefresh_VC.h"
#import "LookupResume_VC.h"
#import "BaseButton.h"
#import "FindTalent_VC.h"
#import "GuideMaskView.h"

@interface JKManage_NewVC () <JKMange_HeaderViewDelegate, JKMangeView_JobVasNormalDelegate, JKManageView_JobVasEndDelegate, ApplyCellDelegate, JKMangeBannerViewDelegate, JKManageView_HeaderRestrictDelegate>

@property (nonatomic, strong) JobDetailModel *JobDetailModel;
@property (nonatomic, copy) NSArray *jkModelArray;
@property (nonatomic, weak) UITextField *emailTextField;
@property (nonatomic, weak) UIView *headerView;
@property (nonatomic, strong) id model;
@property (nonatomic, strong) UIView *blurView;
@property (nonatomic, strong) JKMangeBannerView *bannerView;
@property (nonatomic, strong) UIView *viewWithStrictJob;
@property (nonatomic, copy) NSNumber *unDealListPageNum;
@property (nonatomic, copy) NSNumber *hireListPageNum;

//简历处理
@property (nonatomic, copy) NSNumber *listType; //当前查看的简历列表类型 1：待处理 2：已录用 3：已拒绝

//业务参数
@property (nonatomic, strong) GetQueryApplyJobModel *paramModel;    //待处理
@property (nonatomic, strong) UIView *tableHeaderView;
@property (nonatomic, assign) CGFloat tableHeaderViewH;

//added by kizy
@property (nonatomic, strong) UIButton *btnBot;
@property (nonatomic, strong) UIButton *btnKey;

@end

@implementation JKManage_NewVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"兼职管理";
    self.listType = @1;
    [UserData sharedInstance].popManageViewCtrl = self;
    [self loadParamModels];
    
    self.btnBot = [UIButton buttonWithType:UIButtonTypeCustom];
    self.btnBot.titleLabel.font = [UIFont systemFontOfSize:14.0f];
    self.btnBot.backgroundColor = MKCOLOR_RGB(247, 253, 254);
    [self.btnBot setTitleColor:[UIColor XSJColor_base] forState:UIControlStateNormal];
    [self.btnBot setTitle:@"想要更快招到人？试试人才匹配" forState:UIControlStateNormal];
    [self.btnBot setImage:[UIImage imageNamed:@"job_icon_push"] forState:UIControlStateNormal];
    [self.btnBot addTarget:self action:@selector(btnMoreTalentOnClick:) forControlEvents:UIControlEventTouchUpInside];
//    [self.btnBot setMarginForImg:-16 marginForTitle:16];
    self.btnBot.hidden = YES;
    [self.view addSubview:self.btnBot];
    
    self.btnKey = [[UIButton alloc]init];
    self.btnKey.titleLabel.font = [UIFont systemFontOfSize:14.0f];
    [self.btnKey setTitle:@"一键录用" forState:UIControlStateNormal];
    [self.btnKey setTintColor:MKCOLOR_RGB(255, 255, 255)];
    [self.btnKey setBackgroundColor:MKCOLOR_RGB(0, 199, 225)];
    [self.btnKey addTarget:self action:@selector(btnEmploy:) forControlEvents:UIControlEventTouchUpInside];
    self.btnKey.hidden = YES;
    [self.view addSubview:self.btnKey];
    
    
    [self initUIWithType:DisplayTypeOnlyTableView];
    self.refreshType = RefreshTypeAll;
    self.viewWithNoData = [UIHelper noDataViewWithTitle:@"暂无报名的兼客" image:@"v3_public_nodata"];
    [self.tableView registerNib:nib(@"ApplyCell") forCellReuseIdentifier:@"ApplyCell"];
    self.bannerView.hidden = YES;
    [self.tableView.header beginRefreshing];
    
    [self.tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.view);
        make.bottom.equalTo(self.btnBot.mas_top);
    }];
    [self.btnBot mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.equalTo(self.view);
        make.height.equalTo(@52);
    }];
    [self.btnBot.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.btnBot);
        make.right.equalTo(self.btnBot).offset(-16);
    }];
    if (self.isOverJob) {
        [self.btnKey mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.equalTo(self.view);
            make.height.equalTo(@52);
            
        }];

    }else{
        [self.btnKey mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.bottom.equalTo(self.view);
            make.height.equalTo(@52);
            make.width.equalTo(@80);
        }];

    }
    
    [self uploadRecord];
}

- (void)loadParamModels{
    self.paramModel = [[GetQueryApplyJobModel alloc] init];
    self.paramModel.job_id = self.jobId;
    self.paramModel.query_param = [[QueryParamModel alloc] init];
    self.paramModel.list_type = @1;
}

- (void)newRightBarItem{
    UIButton* btnShare = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    [btnShare setImage:[UIImage imageNamed:@"v3_job_share"] forState:UIControlStateNormal];
    [btnShare setImage:[UIImage imageNamed:@"v3_job_share"] forState:UIControlStateHighlighted];
    [btnShare addTarget:self action:@selector(btnShareOnclick:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btnShare];
}

#pragma mark - 网络部分

- (void)headerRefresh{
    [self getData:NO];
}

- (void)footerRefresh{
    [self getMoreData];
}

- (void)getData:(BOOL)isShowLoading{
    WEAKSELF
    [[UserData sharedInstance] getJobDetailWithJobId:self.jobId andIsFromSAB:NO isShowLoding:isShowLoading Block:^(JobDetailModel *model) {
        if (model) {
            weakSelf.JobDetailModel = model;
            [weakSelf newRightBarItem];
            if (model.parttime_job.source.integerValue == 1) {
                [weakSelf.tableView.header endRefreshing];
                [self initTableHeaderView];
                [self initTableFooterView];
                [self.tableView reloadData];
            }else{
                [weakSelf getData:isShowLoading paramModel:self.paramModel];
            }
            if (model.parttime_job.job_type.integerValue == 5) {
                self.btnBot.hidden = YES;
                [self.btnBot mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.height.equalTo(@0.1);
                }];
            }else{
                if (!self.isOverJob) {
                    self.btnBot.hidden =NO;
                }
                
            }
        }
    }];
}

- (void)getJobDetail{
    WEAKSELF
    [[UserData sharedInstance] getJobDetailWithJobId:self.jobId andIsFromSAB:NO isShowLoding:NO Block:^(JobDetailModel *model) {
        if (model) {
            weakSelf.JobDetailModel = model;
        }
    }];
}

- (void)getData:(BOOL)isShowLoading paramModel:(GetQueryApplyJobModel *)paramModel{
    if (!self.JobDetailModel || self.JobDetailModel.parttime_job.source.integerValue == 1) {
        [self.tableView.header endRefreshing];
        return;
    }
    paramModel.query_param.page_num = @1;
    WEAKSELF
    [[UserData sharedInstance] entQueryApplyJobListWith:paramModel isShowLoading:isShowLoading block:^(ResponseInfo *response) {
        weakSelf.bannerView.hidden = NO;
        [weakSelf.tableView.header endRefreshing];
        if (response) {
            NSArray *array = [JKModel objectArrayWithKeyValuesArray:[response.content objectForKey:@"apply_job_resume_list"]];
            weakSelf.dataSource = [array mutableCopy];
            weakSelf.unDealListPageNum = [response.content objectForKey:@"undeal_list_page_num"];
            weakSelf.hireListPageNum = [response.content objectForKey:@"hire_list_page_count"];
            if (array.count) {
                paramModel.query_param.page_num = @2;
                weakSelf.tableView.tableFooterView = nil;
            }else{
                //显示无数据视图
                [weakSelf initTableFooterView];
            }
            //判断一键
            if(array.count>=2 && [self.listType  isEqual: @(1)]){
                self.btnKey.hidden = NO;
                
                [self.btnBot mas_remakeConstraints:^(MASConstraintMaker *make) {
                    make.bottom.right.equalTo(self.view);
                    make.left.equalTo(self.btnKey.mas_right);
                    make.height.equalTo(@52);
                }];
         
            }else{
                self.btnKey.hidden = YES;
                
                [self.btnBot mas_remakeConstraints:^(MASConstraintMaker *make) {
                    make.left.bottom.right.equalTo(self.view);
                    make.height.equalTo(@52);
                }];
                
            }
            
            [self initTableHeaderView];
            self.viewWithNoData.y = self.tableHeaderViewH + 97 + 50;
            [weakSelf.tableView reloadData];
        }else{
            [weakSelf.dataSource removeAllObjects];
            [weakSelf.tableView reloadData];
            [weakSelf initTableFooterView];
        }
    }];
}

- (void)getMoreData{
    if (!self.JobDetailModel || self.JobDetailModel.parttime_job.source.integerValue == 1) {
        [self.tableView.footer endRefreshing];
        return;
    }
    WEAKSELF
    [[UserData sharedInstance] entQueryApplyJobListWith:self.paramModel isShowLoading:NO block:^(ResponseInfo *response) {
        [weakSelf.tableView.footer endRefreshing];
        if (response) {
            NSArray *array = [JKModel objectArrayWithKeyValuesArray:[response.content objectForKey:@"apply_job_resume_list"]];
            if (array.count) {
                [weakSelf.dataSource addObjectsFromArray:array];
                weakSelf.paramModel.query_param.page_num = @(weakSelf.paramModel.query_param.page_num.integerValue + 1);
                if(array.count>=2 && [self.listType isEqual:@1]){
                    self.btnKey.hidden = NO;
                }
                [weakSelf.tableView reloadData];
            }
            

        }
    }];
}

#pragma mark - uitableview datasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ApplyCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ApplyCell" forIndexPath:indexPath];
    cell.delegate = self;
    cell.jobId = self.jobId;
    switch (self.listType.integerValue) {
        case 1:
            cell.cellType = ApplyCellType_jobManageForNormal;
            break;
        case 2:
            cell.cellType = ApplyCellType_jobManageForHire;
            break;
        case 3:
            cell.cellType = ApplyCellType_jobManageForRejected;
        default:
            
            break;
    }
    
    cell.cellModel = self.dataSource[indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    [self.bannerView setModel:self.unDealListPageNum.description hireNum:self.hireListPageNum];
    return self.bannerView;
}

#pragma mark - uitableview delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [self getRowHeight:indexPath];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (self.JobDetailModel.parttime_job.source.integerValue == 1) {
        return 0;
    }
    return 97.0f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    // 跳转
//    if (self.listType.integerValue == 1) {
        JKModel *jkModel = self.dataSource[indexPath.row];
        LookupResume_VC *vc = [[LookupResume_VC alloc] init];
        vc.resumeId = jkModel.resume_id;
        vc.jobId = jkModel.apply_job_id;
        vc.isFromToLookUpResume = 3;
        vc.jobTitle = self.JobDetailModel.parttime_job.job_title;
        [self.navigationController pushViewController:vc animated:YES];
//    }
}

#pragma mark - 其他业务方法

- (void)btnShareOnclick:(UIButton *)sender{
    WEAKSELF
    [ShareHelper platFormShareWithVc:weakSelf info:self.JobDetailModel.parttime_job.share_info_not_sms block:^(NSNumber *obj) {
        
    }];
}

- (CGFloat)getRowHeight:(NSIndexPath *)indexPath{
    switch (self.listType.integerValue) {
        case 1:{
            JKModel *jkModel = [self.dataSource objectAtIndex:indexPath.row];
            if (jkModel.school_name.length) {
                return 187.0f;
            }else{
                return 167.0f;
            }
        }
        case 2:
        case 3:{
            return 82.0f;
        }
        default:
            break;
    }
    return 0;
}

- (void)uploadRecord{
    [[XSJRequestHelper sharedInstance] recordPageVisitLogWithVisitPageId:@3 block:nil];
}

- (void)initTableFooterView{
    self.tableView.tableFooterView = nil;
    if (self.JobDetailModel.parttime_job.source.integerValue == 1) {
        self.tableView.tableFooterView = self.blurView;
    }else{
        NSString *strNoData = nil;
        switch (self.listType.integerValue) {
            case 1:
                strNoData = @"暂无已报名的兼客";
                break;
            case 2:
                strNoData = @"暂无已录用的兼客";
                break;
            case 3:
                strNoData = @"暂无被拒绝的兼客";
                break;
            default:
                break;
        }
        UIView *view = [UIHelper noDataViewWithTitle:strNoData image:@"v3_public_nodata"];
        view.height = 150;
        view.hidden = NO;
        UIImageView *noDataImgView = [view viewWithTag:110];
        [noDataImgView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(view.mas_centerX);
            make.top.equalTo(view.mas_top).offset(16);
        }];
        self.tableView.tableFooterView = view;
    }
}

- (void)initTableHeaderView{
    self.tableView.tableHeaderView = nil;
    self.tableHeaderViewH = 0;
    self.tableHeaderView = nil;
    self.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, self.tableHeaderViewH)];
    [self initJKManageViewHeader];
    if (self.JobDetailModel.parttime_job.status.integerValue == 2 && self.JobDetailModel.parttime_job.job_type.integerValue != 5) {
        //正在发布中
        [self initJKManageViewJobVasNormal];
    }else if (self.JobDetailModel.parttime_job.status.integerValue == 3 && self.JobDetailModel.parttime_job.job_last_vas_push_str.length  && self.JobDetailModel.parttime_job.job_type.integerValue != 5){
        [self initJKManageViewJobVasEnd];
    }
    self.tableHeaderView.height = self.tableHeaderViewH;
    self.tableView.tableHeaderView = self.tableHeaderView;
}

- (void)initJKManageViewHeader{
    if (self.JobDetailModel.parttime_job.source.integerValue == 1) {
        JKManageView_HeaderRestrict *headerView = [[JKManageView_HeaderRestrict alloc] init];
        headerView.delegate = self;
        [headerView setData:self.JobDetailModel];
        headerView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 168.0f);
        [self.tableHeaderView addSubview:headerView];
        self.tableHeaderViewH += 168.0f;
        return;
    }
    JKMange_HeaderView *view = [[JKMange_HeaderView alloc] init];
    view.delegate = self;
    [view setData:self.JobDetailModel];
    view.frame = CGRectMake(0, 0, SCREEN_WIDTH, 168.0f);
    [self.tableHeaderView addSubview:view];
    self.tableHeaderViewH += 168.0f;
}

- (void)initJKManageViewJobVasNormal{
    JKMangeView_JobVasNormal *view = [[JKMangeView_JobVasNormal alloc] init];
    view.delegate = self;
    view.frame = CGRectMake(0, self.tableHeaderViewH, SCREEN_WIDTH, 150.0f);
    [self.tableHeaderView addSubview:view];
    self.tableHeaderViewH += 150.0f;
}

- (void)initJKManageViewJobVasEnd{
    JKManageView_JobVasEnd *view = [[JKManageView_JobVasEnd alloc] init];
    view.delegate = self;
    [view setModel:self.JobDetailModel.parttime_job];
    view.frame = CGRectMake(0, self.tableHeaderViewH, SCREEN_WIDTH, 122.0f);
    [self.tableHeaderView addSubview:view];
    self.tableHeaderViewH += 122.0f;
}

#pragma mark - JKMange_HeaderViewDelegate

- (void)JKMange_HeaderView:(JKMange_HeaderView *)cell{
    JobDetail_VC *viewCtrl = [[JobDetail_VC alloc] init];
    viewCtrl.jobId = self.JobDetailModel.parttime_job.job_id.description;
    [self.navigationController pushViewController:viewCtrl animated:YES];
}

#pragma mark - JKManageView_HeaderRestrictDelegate

- (void)JKManageView_HeaderRestrict:(JKManageView_HeaderRestrict *)view{
    JobDetail_VC *viewCtrl = [[JobDetail_VC alloc] init];
    viewCtrl.jobId = self.JobDetailModel.parttime_job.job_id.description;
    [self.navigationController pushViewController:viewCtrl animated:YES];
}

#pragma mark - JKMangeView_JobVasNormalDelegate

- (void)JKMangeView_JobVasNormal:(JKMangeView_JobVasNormal *)cell actionType:(BtnOnClickActionType)actionType{
    switch (actionType) {
        case BtnOnClickActionType_jobVas:{
            [self pushJobVas];
        }
            break;
        case BtnOnClickActionType_refreshJob:{
            [self pushRefresh];
        }
            break;
        case BtnOnClickActionType_stickJob:{
            [self pushAppreciate:Appreciation_stick_Type];
        }
            break;
        case BtnOnClickActionType_pushJob:{
            [self pushJobVasForPush];
        }
            break;
        default:
            break;
    }
}

#pragma mark - JKManageView_JobVasEndDelegate

- (void)JKManageView_JobVasEnd:(JKManageView_JobVasEnd *)view{
    [self pushHistoryBtnOnClick];
}

#pragma mark - ApplyCellDelegate

- (void)applyCell:(ApplyCell *)cell cellModel:(JKModel *)cellModel actionType:(ActionType)actionType{
    switch (actionType) {
        case ActionTypeFire:
        case ActionTypeHire:{
            [self getData:YES paramModel:self.paramModel];
            [[UserData sharedInstance] setIsUpdateWithEPHome:YES];
        }
            break;
        case ActionTypeIM:{
            [self chatWithJk:cellModel];
        }
            break;
        case ActionTypeCall:{
            [[MKOpenUrlHelper sharedInstance] makeCallWithPhone:cellModel.telphone];
        }
            break;
        default:
            break;
    }
}

#pragma mark - JKMangeBannerViewDelegate

- (void)JKMangeBannerView:(JKMangeBannerView *)view actionType:(BtnOnClickActionType)actionType{
    switch (actionType) {
        case BtnOnClickActionType_applyForWait:{
            self.paramModel.list_type = @1;
            self.listType = @1;
            [self getData:YES paramModel:self.paramModel];
        }
            break;
        case BtnOnClickActionType_applyForHired:{
            self.paramModel.list_type = @2;
            self.listType = @2;
            [self getData:YES paramModel:self.paramModel];
        }
            break;
        case BtnOnClickActionType_applyForRejected:{
            self.paramModel.list_type = @3;
            self.listType = @3;
            [self getData:YES paramModel:self.paramModel];
        }
            break;
        case BtnOnClickActionType_viewMoreMange:{
            [self pushOldJKManage];
        }
            break;
        default:
            break;
    }
}

#pragma mark - 业务方法

- (void)pushHistoryBtnOnClick{
    WebView_VC* vc = [[WebView_VC alloc] init];
    vc.url = [NSString stringWithFormat:@"%@%@%@", URL_HttpServer, KUrl_jobPushOrderList, self.jobId];
    [self.navigationController pushViewController:vc animated:YES];
}


- (void)pushOldJKManage{
    JiankeCollection_VC *vc = [[JiankeCollection_VC alloc] init];
    vc.jobId = self.jobId;
    vc.jobModel = self.JobDetailModel.parttime_job;
    WEAKSELF
    vc.block = ^(id result){
        [weakSelf getData:YES];
    };
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)chatWithJk:(JKModel *)jkModel{
    NSString *jobTitle = self.JobDetailModel.parttime_job.job_title;
    if (jkModel.account_im_open_status) { // 有开通IM
        
        NSString* content = [NSString stringWithFormat:@"\"accountId\":\"%@\"", jkModel.account_id];
        RequestInfo* request = [[RequestInfo alloc] initWithService:@"shijianke_im_getUserPublicInfo" andContent:content];
        request.isShowLoading = NO;
        [request sendRequestToImServer:^(ResponseInfo* response) {
            if (response && [response success]) {
                [WDChatView_VC openPrivateChatOn:self accountId:jkModel.account_id.description withType:WDImUserType_Jianke jobTitle:jobTitle jobId:self.jobId];
            }
        }];
    } else {
        [UIHelper toast:@"对不起,该用户未开通IM功能"];
    }
}

- (void)pushJobVas{
    JobVasOrder_VC *viewCtrl = [[JobVasOrder_VC alloc] init];
    viewCtrl.jobId = self.jobId;
    if (self.JobDetailModel.parttime_job.status.integerValue == 3) {
        viewCtrl.jobIsOver = YES;
    }
    viewCtrl.block = ^(id result){
        [self getJobDetail];
    };
    [self.navigationController pushViewController:viewCtrl animated:YES];
}

- (void)pushAppreciate:(AppreciationType)serviceType{
    if (serviceType == Appreciation_stick_Type && self.JobDetailModel.parttime_job.stick.integerValue == 1) {
        [UIHelper toast:@"岗位已处于置顶状态"];
        return;
    }
    
    JianKeAppreciation_VC *viewCtrl = [[JianKeAppreciation_VC alloc] init];
    viewCtrl.serviceType = serviceType;
    viewCtrl.jobId = self.jobId;
    viewCtrl.popToVC = self;
    [self.navigationController pushViewController:viewCtrl animated:YES];
}

- (void)pushRefresh{
    JobAutoRefresh_VC *viewCtrl = [[JobAutoRefresh_VC alloc] init];
    viewCtrl.jobId = self.jobId;
    viewCtrl.popToVC = self;
    [self.navigationController pushViewController:viewCtrl animated:YES];
}

- (void)pushJobVasForPush{
    PushOrder_VC *viewCtrl = [[PushOrder_VC alloc] init];
    viewCtrl.jobId = self.jobId;
    [self.navigationController pushViewController:viewCtrl animated:YES];
}

- (void)noDataButtonAction:(UIButton *)sender{
    JKCallList_VC *viewCtrl = [[JKCallList_VC alloc] init];
    viewCtrl.jobId = self.jobId;
    [self.navigationController pushViewController:viewCtrl animated:YES];
}

- (void)noDataBtnOnClick:(UIButton *)sender{
    [self pushToPostVC];
}

- (void)pushToPostVC{
    if ([[UserData sharedInstance] isEnableTeamService]) {
        PostPersonalJob_VC *viewCtrl = [[PostPersonalJob_VC alloc] init];
        viewCtrl.sourceType = ViewSourceType_PostTeamJob;
        [self.navigationController pushViewController:viewCtrl animated:YES];
    }else{
        PostJob_VC* vc = [[PostJob_VC alloc] init];
        vc.postJobType = PostJobType_common;
        vc.isShowTip = YES;
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

#pragma mark - lazy

- (JKMangeBannerView *)bannerView{
    if (!_bannerView) {
        _bannerView = [[JKMangeBannerView alloc] init];
        _bannerView.delegate = self;
    }
    return _bannerView;
}

- (UIView *)blurView{
    if (!_blurView) {
        _blurView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 350)];
        self.viewWithStrictJob = [UIHelper noDataViewWithTitle:@"当前岗位为采集岗位,只有平台内发布的岗位才能进行管理哦~" titleColor:nil image:@"v3_public_nodata" button:@"查看咨询的兼客"];
        [_blurView addSubview:self.viewWithStrictJob];
        self.viewWithStrictJob.userInteractionEnabled = YES;
        self.viewWithStrictJob.frame = CGRectMake(0, 0, SCREEN_WIDTH, 350);
        self.viewWithStrictJob.hidden = NO;

        self.viewWithStrictJob.backgroundColor = [UIColor clearColor];


        UIButton *btnWithNoData = (UIButton *)[self.viewWithStrictJob viewWithTag:998];
        [btnWithNoData addTarget:self action:@selector(noDataButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [btnWithNoData setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        btnWithNoData.backgroundColor = [UIColor XSJColor_base];
        [btnWithNoData setCornerValue:2.0f];
        
//        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
//        [button setTitle:@"试试付费推广 >" forState:UIControlStateNormal];
//        [button addTarget:self action:@selector(payBtnOnClick:) forControlEvents:UIControlEventTouchUpInside];
//        [button setTitleColor:[UIColor XSJColor_tGrayHistoyTransparent] forState:UIControlStateNormal];
//        button.titleLabel.font = [UIFont systemFontOfSize:14.0f];
//        [self.viewWithNoData addSubview:button];
//        [button mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.top.equalTo(self.btnWithNoData.mas_bottom);
//            make.centerX.height.equalTo(self.btnWithNoData);
//        }];
//        
        BaseButton *baseButton = [BaseButton buttonWithType:UIButtonTypeCustom];
        [baseButton setTitle:@"•找不到人?试试把项目外包给团队服务商吧" forState:UIControlStateNormal];
        [baseButton setTitleColor:[UIColor XSJColor_tGrayDeepTinge] forState:UIControlStateNormal];
        baseButton.titleLabel.font = [UIFont systemFontOfSize:13.0f];
        [baseButton setImage:[UIImage imageNamed:@"job_icon_push"] forState:UIControlStateNormal];
        [baseButton addTarget:self action:@selector(noDataBtnOnClick:) forControlEvents:UIControlEventTouchUpInside];
        [baseButton setMarginForImg:-16 marginForTitle:16];
        [self.viewWithStrictJob addSubview:baseButton];
        [baseButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(btnWithNoData.mas_bottom).offset(10);
            make.left.right.equalTo(self.viewWithStrictJob);
            make.height.equalTo(@40);
        }];
        [baseButton addBorderInDirection:BorderDirectionTypeTop borderWidth:0.7 borderColor:[UIColor XSJColor_clipLineGray] isConstraint:YES];
    }
    return _blurView;
}

- (void)btnMoreTalentOnClick:(UIButton *)sender{
    [TalkingData trackEvent:@"兼职管理_试试人才匹配"];
    FindTalent_VC *vc = [[FindTalent_VC alloc] init];
    vc.isBeginWithMJRefresh = YES;
    vc.age_limit = self.JobDetailModel.parttime_job.age;
    vc.city_id = self.JobDetailModel.parttime_job.city_id;
    vc.address_area_id = self.JobDetailModel.parttime_job.address_area_id;
    vc.job_classify_id = self.JobDetailModel.parttime_job.job_type_id;
    vc.city_name = self.JobDetailModel.parttime_job.city_name;
    vc.job_classfie_name = self.JobDetailModel.parttime_job.job_classfie_name;
    vc.address_area_name = self.JobDetailModel.parttime_job.address_area_name;
    vc.sex = self.JobDetailModel.parttime_job.sex;
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)btnEmploy:(UIButton *)sender{
    
    NSString *msg = [NSString stringWithFormat:@"确定录用这%d个求职者吗?",(int)self.dataSource.count];
    WEAKSELF
    GuideMaskView *maskView = [[GuideMaskView alloc] initWithTitle:@"提示" content:msg cancel:@"再考虑下" commit:@"确定录用" block:^(NSInteger index) {
        switch (index) {
            case 0:{
                
            }
                break;
            case 1:{
                [[UserData sharedInstance]entEmployApplyJobWithWithApplyJobIdList:nil jobId:self.jobId employStatus:@(1) employMemo:nil block:^(ResponseInfo *result) {
                    if (result) {
                        [UIHelper toast:result.errMsg];
                        [weakSelf.tableView.header beginRefreshing];
                    }
                }];
               
            }
                break;
            default:
                break;
        }
    }];
    [maskView show];
    
    
   
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
