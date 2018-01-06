//
//  JobManage_VC.m
//  JKHire
//
//  Created by yanqb on 2016/12/17.
//  Copyright © 2016年 xianshijian. All rights reserved.
//

#import "JobManage_VC.h"
#import "JobModel.h"
#import "InvitingForJobCell.h"
#import "CompleteForJobCell.h"
#import "JobDetail_VC.h"
#import "ShareHelper.h"
#import "RefreshLeftCountModel.h"
#import "ShareToGroupController.h"
#import "CityTool.h"
#import "ScrollNewsView.h"
#import "JKNewsModel.h"
#import "NewsBtn.h"
#import "WebView_VC.h"
#import "JKHomeModel.h"
#import "XSJRequestHelper.h"
#import "UIView+MKException.h"
#import "ApplyJKController.h"
#import "JKManage_NewVC.h"
#import "JianKeAppreciation_VC.h"
#import "SalaryRecord_VC.h"
#import "RequestParamWrapper.h"
#import "PushOrder_VC.h"
#import "PaySelect_VC.h"
#import "JobAutoRefresh_VC.h"
#import "ManualAddPerson_VC.h"
#import "FindTalent_VC.h"

@interface JobManage_VC ()<InvitingForJobDelegate>

@property (nonatomic, assign) ManagerType managerType; /*!< ManagerTypeEP | ManagerTypeBD */
@property (nonatomic, strong) GetEnterpriscJobModel *reqModel;
@property (nonatomic, strong) NSDate *lastUpdateDate;   /*!< 数据最后刷新时间 影响保证金金额 */

@end

@implementation JobManage_VC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.managerType = ManagerTypeEP;
    [self addNotification];
    self.reqModel = [[GetEnterpriscJobModel alloc] init];
    self.reqModel.query_param = [[QueryParamModel alloc] init];
    self.reqModel.query_type = @4;
    
    [self initUIWithType:DisplayTypeOnlyTableView];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.estimatedRowHeight = 199;

    self.tableView.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        if ([self.delegate respondsToSelector:@selector(jobManage_VC:actionType:)]) {
            [self.delegate jobManage_VC:self actionType:VCActionType_HeaderView];
        }
        [self headerRefresh];
    }];
    
    self.tableView.footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [self footerRefresh];
    }];
    
    [self setNodataViewWithLoginSatus];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if ([[UserData sharedInstance] isUpdateWithEPHome]) {
        [[UserData sharedInstance] setIsUpdateWithEPHome:NO];
        [self getLastestJobListForEP];
    }
}

- (void)addNotification{
    ELog(@"====ep addNotification");
    [WDNotificationCenter addObserver:self selector:@selector(updateMainTV) name:IMNotification_EPMainUpdate object:nil];
    [WDNotificationCenter addObserver:self selector:@selector(loginSuccessNotifi) name:WDNotifi_LoginSuccess object:nil];
    [WDNotificationCenter addObserver:self selector:@selector(loginFailNotifi) name:WDNotification_userLoginFail object:nil];
}

- (void)setNodataViewWithLoginSatus{
    WEAKSELF
    [[UserData sharedInstance] getUserStatus:^(UserLoginStatus loginStatus) {
        switch (loginStatus) {
            case UserLoginStatus_loginFail:{    //登录失败
                self.dataSource = [NSMutableArray array];
                if (weakSelf.tableView) {
                    [weakSelf.tableView reloadData];
                }
            }
            case UserLoginStatus_needManualLogin:{  //需要手动登录
                //显示登录提醒界面
                [self setNoDataViewWithstr:@"您还没有登录" withBtn:@"登录"];
                self.viewWithNoData.hidden = NO;
            }
                break;
            case UserLoginStatus_canAutoLogin:{     //可自动登录
                //显示缓存
                self.dataSource = [[[UserData sharedInstance] getEPJobList] mutableCopy];
                [self setNoDataViewWithstr:@"没有正在招聘的兼职" withBtn:nil];
            }
                break;
            case UserLoginStatus_loginSuccess:{     //已经登录成功
                [self setNoDataViewWithstr:@"没有正在招聘的兼职" withBtn:nil];
                [weakSelf.tableView.header beginRefreshing];
            }
                break;
            default:
                break;
        }
    }];
}

- (void)setNoDataViewWithstr:(NSString *)strTitle withBtn:(NSString *)strBtn{
    [self initWithNoDataViewWithStr:strTitle labColor:nil imgName:@"v3_public_nobill" button:strBtn onView:self.tableView];
}

- (void)headerRefresh{
    [self getLastestJobListForEP];
}

- (void)footerRefresh{
    [self getMoreJobListForEP];
}

- (void)getLastestJobListForEP{
    if (![[UserData sharedInstance] isLogin]) {
        [self.tableView.header endRefreshing];
        return;
    }
    
    self.reqModel.query_param.page_num = @1;
    WEAKSELF
    [[XSJRequestHelper sharedInstance] getEnterpriseSelfJobList:self.reqModel block:^(ResponseInfo *response) {
        [weakSelf.tableView.header endRefreshing];
        if (response) {
            weakSelf.lastUpdateDate = [NSDate date];
            NSArray *dataList = [JobModel objectArrayWithKeyValuesArray:response.content[@"job_list"]];
            if (dataList.count) {
                weakSelf.viewWithNoData.hidden = YES;
                weakSelf.dataSource = [dataList mutableCopy];
                weakSelf.reqModel.query_param.page_num = @2;
            }else{
                [weakSelf.dataSource removeAllObjects];
                weakSelf.viewWithNoData.hidden = NO;
            }
            [[UserData sharedInstance] saveEPJobListWithArray:weakSelf.dataSource];
            [weakSelf.tableView reloadData];
        }
    }];

}

- (void)getMoreJobListForEP{
    if (![[UserData sharedInstance] isLogin] || self.reqModel.query_param.page_num.integerValue <= 1) {
        [self.tableView.footer endRefreshing];
        return;
    }
    WEAKSELF
    [[XSJRequestHelper sharedInstance] getEnterpriseSelfJobList:self.reqModel block:^(ResponseInfo *response) {
        [weakSelf.tableView.footer endRefreshing];
        if (response) {
            NSArray *dataList = [JobModel objectArrayWithKeyValuesArray:response.content[@"job_list"]];
            if (dataList.count) {
                weakSelf.reqModel.query_param.page_num = @(weakSelf.reqModel.query_param.page_num.integerValue + 1);
                [weakSelf.dataSource addObjectsFromArray:dataList];
                [weakSelf.tableView reloadData];
            }
        }
    }];
}

- (void)getJobLists{
    if (!self.dataSource.count) {
        return;
    }
    GetEnterpriscJobModel *paramModel = [[GetEnterpriscJobModel alloc] init];
    paramModel.query_param = [[QueryParamModel alloc] init];
    paramModel.query_param.page_num = @1;
    paramModel.query_param.page_size = @(self.dataSource.count);
    paramModel.query_type = self.reqModel.query_type;
    WEAKSELF
    [[XSJRequestHelper sharedInstance] getEnterpriseSelfJobList:paramModel block:^(ResponseInfo *response) {
        if (response) {
            weakSelf.lastUpdateDate = [NSDate date];
            NSArray *dataList = [JobModel objectArrayWithKeyValuesArray:response.content[@"job_list"]];
            weakSelf.dataSource = [dataList mutableCopy];
            [weakSelf.tableView reloadData];
            if (dataList.count) {
                weakSelf.viewWithNoData.hidden = YES;
            }else{
                weakSelf.viewWithNoData.hidden = NO;
            }
        }
    }];
}

#pragma mark - tableView delegate
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    InvitingForJobCell* cell = [InvitingForJobCell cellWithTableView:tableView];
    cell.delegate = self;
    cell.managerType = self.managerType;
    JobModel* model = [self.dataSource objectAtIndex:indexPath.section];
    [cell refreshWithData:model atIndexPath:indexPath];
    return cell;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.dataSource.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    JobModel *jobModel = [self.dataSource objectAtIndex:indexPath.section];
    return jobModel.cellHeight;
    //    return 176.0f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    ELog(@"=========didSelectRowAtIndexPath:%ld",(long)indexPath.section);
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    JobModel* model = [self.dataSource objectAtIndex:indexPath.section];
    if ((model.status.intValue == 1 || model.job_close_reason.integerValue == 3 || model.job_close_reason.integerValue == 4) && model.job_type.integerValue != 3) {
        JobDetail_VC* vc = [[JobDetail_VC alloc] init];
        vc.jobId = model.job_id.description;
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }else if(model.job_type.integerValue == 3){
        SalaryRecord_VC *viewCtrl = [[SalaryRecord_VC alloc] init];
        viewCtrl.jobId = model.job_id.description;
        viewCtrl.isAddPay = YES;
        viewCtrl.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:viewCtrl animated:YES];
    }else {
        ELog(@"跳转到兼客管理");
        
        JKManage_NewVC *vc = [[JKManage_NewVC alloc] init];
        vc.jobId = model.job_id.stringValue;
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (((scrollView.contentOffset.y + scrollView.height) <= scrollView.contentSize.height)) {
//        ELog(@"jobmanage offset:%f", scrollView.contentOffset.y);
        if ([self.delegate respondsToSelector:@selector(JobManage_VC:scrollViewOffset:)]) {
            [self.delegate JobManage_VC:self scrollViewOffset:scrollView.contentOffset];
        }
    }
    
}

#pragma mark - 正在招人  业务逻辑

- (void)cell_btnBotOnClick:(JobModel *)model atIndexPath:(NSIndexPath *)indexPath{
    if (![XSJUserInfoData isReviewAccount]) {
        [self showActionSheetWithModel:model isGuarance:(model.guarantee_amount_status.integerValue == 0) atIndexPath:indexPath];
    }else{
        [MKActionSheet sheetWithTitle:nil buttonTitleArray:@[@"结束招聘"] block:^(MKActionSheet *actionSheet, NSInteger buttonIndex) {
            switch (buttonIndex) {
                case 0:{    //置顶
                    [self closeJob:model atIndexPath:indexPath];
                }
                    break;
                default:
                    break;
            }
        }];
    }
    
}

- (void)cell_btnBotOnClick:(JobModel *)model actionType:(JobOpreationType)actionType atIndexPath:(NSIndexPath *)indexPath{
    switch (actionType) {
        case JobOpreationType_payForPush:{   //推送岗位
            [self pushJobWith:model];
        }
            break;
        case JobOpreationType_Refresh:{ //刷新岗位
//            [self pushAppreciteVC:Appreciation_Refresh_Type jobModel:model];
            JobAutoRefresh_VC *viewCtrl = [[JobAutoRefresh_VC alloc] init];
            viewCtrl.jobId = model.job_id.description;
            viewCtrl.popToVC = self.parentViewController;
            viewCtrl.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:viewCtrl animated:YES];
        }
            break;
        case JobOpreationType_ViewApplyJK:{ //查看简历
            [self viewJKApplyWith:model];
        }
            break;
        case JobOpreationType_payForStick:{ //置顶
            ELog(@"进入置顶");
            if (model.stick.integerValue == 0) {
                [self pushAppreciteVC:Appreciation_stick_Type jobModel:model];
            }else{
                [UIHelper toast:@"岗位已处于置顶状态"];
            }
        }
            break;
        case JobOpreationType_jobDaifa:{
            ManualAddPerson_VC *viewCtrl = [[ManualAddPerson_VC alloc] init];
            viewCtrl.title = @"添加发放对象";
            viewCtrl.job_id = model.job_id.description;
            viewCtrl.fromViewType = FromViewType_PayRecord;
            viewCtrl.hidesBottomBarWhenPushed = YES;
            viewCtrl.block = ^(id result){
                [self.navigationController popToRootViewControllerAnimated:YES];
            };
            [self.navigationController pushViewController:viewCtrl animated:YES];
        }
            break;
        case JobOpreationType_payForTelentMatch:{   //人才匹配
            [TalkingData trackEvent:@"首页_岗位列表_人才匹配"];
            [self enterFindTalent:model];
        }
            break;
        default:
            break;
    }
}

//- (void)cell_btnPaySalaryOnClick:(JobModel *)model{
//    SalaryRecord_VC *viewCtrl = [[SalaryRecord_VC alloc] init];
//    viewCtrl.jobId = model.job_id.description;
//    viewCtrl.isAddPay = YES;
//    viewCtrl.hidesBottomBarWhenPushed = YES;
//    [self.navigationController pushViewController:viewCtrl animated:YES];
//}

- (void)showActionSheetWithModel:(JobModel *)model isGuarance:(BOOL)isGurance atIndexPath:(NSIndexPath *)indexPath{
    if (isGurance) {
        if (model.job_type.integerValue == 5) {
            [MKActionSheet sheetWithTitle:nil buttonTitleArray:@[@"缴纳保证金", @"分享岗位", @"关闭岗位"] block:^(MKActionSheet *actionSheet, NSInteger buttonIndex) {
                switch (buttonIndex) {
                    case 0:{
                        [self payGuaranteeAmountWith:model];
                    }
                        break;
                    case 1:{
                        [self shareJob:model];
                    }
                        break;
                    case 2:{
                        [self closeJob:model atIndexPath:indexPath];
                    }
                        break;
                    default:
                        break;
                }
            }];
        }else{
            [MKActionSheet sheetWithTitle:nil buttonTitleArray:@[@"推送", @"缴纳保证金", @"分享岗位", @"关闭岗位"] block:^(MKActionSheet *actionSheet, NSInteger buttonIndex) {
                switch (buttonIndex) {
                    case 0:{
                        [self pushJobWith:model];
                    }
                        break;
                    case 1:{
                        [self payGuaranteeAmountWith:model];
                    }
                        break;
                    case 2:{
                        [self shareJob:model];
                    }
                        break;
                    case 3:{    //
                        
                        [self closeJob:model atIndexPath:indexPath];
                    }
                        break;
                    default:
                        break;
                }
            }];
        }
    }else{
        if (model.job_type.integerValue == 5) {
            [MKActionSheet sheetWithTitle:nil buttonTitleArray:@[@"分享岗位", @"关闭岗位"] block:^(MKActionSheet *actionSheet, NSInteger buttonIndex) {
                switch (buttonIndex) {
                    case 0:{
                        [self shareJob:model];
                    }
                        break;
                    case 1:{    //置顶
                        [self closeJob:model atIndexPath:indexPath];
                    }
                        break;
                    default:
                        break;
                }
            }];
        }else{
            [MKActionSheet sheetWithTitle:nil buttonTitleArray:@[@"推送", @"分享岗位", @"关闭岗位"] block:^(MKActionSheet *actionSheet, NSInteger buttonIndex) {
                switch (buttonIndex) {
                    case 0:{
                        [self pushJobWith:model];
                    }
                        break;
                    case 1:{
                        [self shareJob:model];
                    }
                        break;
                    case 2:{    //置顶
                        [self closeJob:model atIndexPath:indexPath];
                    }
                        break;
                    default:
                        break;
                }
            }];
        }
    }
}

#pragma mark - 底部弹窗按钮操作
/** 缴纳保证金 */
- (void)payGuaranteeAmountWith:(JobModel *)jobModel{
    if (!self.lastUpdateDate || ![DateHelper isSameDay:self.lastUpdateDate date2:[NSDate date]]) {
        [self getJobDetailWith:jobModel.job_id.description block:^(NSNumber *guaranteAmount) {
            [self enterPayselectForGuaranteeWith:jobModel.job_id withGuaranteeAmount:guaranteAmount];
        }];
    }else{
        [self enterPayselectForGuaranteeWith:jobModel.job_id withGuaranteeAmount:jobModel.guarante_amount_pay_money];
    }

}

/** 分享 */
- (void)shareJob:(JobModel *)jobModel{
    WEAKSELF
    [ShareHelper platFormShareWithVc:weakSelf info:jobModel.share_info_not_sms block:^(NSNumber *obj) {
        
    }];
    
}

/** 置顶/刷新/推送 */
- (void)pushAppreciteVC:(AppreciationType)type jobModel:(JobModel *)jobModel{
    JianKeAppreciation_VC *viewCtrl = [[JianKeAppreciation_VC alloc] init];
    viewCtrl.serviceType = type;
    viewCtrl.jobId = jobModel.job_id.description;
    viewCtrl.popToVC = self.parentViewController;
    viewCtrl.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:viewCtrl animated:YES];
}

- (void)pushRefresh:(JobModel *)jobModel{
    JobAutoRefresh_VC *viewCtrl = [[JobAutoRefresh_VC alloc] init];
    viewCtrl.jobId = jobModel.job_id.description;
    viewCtrl.popToVC = self.parentViewController;
    viewCtrl.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:viewCtrl animated:YES];
}

/** 刷新 */
- (void)refreshJob:(JobModel *)model{
    [self getJobRefreshLeftCount:^(RefreshLeftCountModel* select) {
        if (select.busi_power_gift_limit.intValue + select.busi_power_limit.intValue > 0) {
            NSInteger leftCount = select.busi_power_gift_limit.intValue + select.busi_power_limit.intValue;
            NSString* leftCountStr = [NSString stringWithFormat:@"今天还剩%ld次刷新岗位机会，是否确定刷新", (long)leftCount];
            
            [UIHelper showConfirmMsg:leftCountStr completion:^(DLAVAlertView *alertView, NSInteger buttonIndex) {
                if (buttonIndex == 0) {
                    return;
                }else{
                    [self updateParttimeJobRanking:model.job_id];
                }
            }];
        }else{
            [UIHelper showConfirmMsg:@"您今天已用完该权限...明天再来试试吧" title:@"提示" cancelButton:@"取消" completion:^(DLAVAlertView *alertView, NSInteger buttonIndex) {
            }];
        }
    }];
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

/** 雇主分享岗位 */

- (void)share:(JobModel *)jobModel{
    
}

/** 结束招聘 */

- (void)closeJob:(JobModel *)jobModel atIndexPath:(NSIndexPath *)indexPath{
    if (jobModel.status.integerValue == 1 || jobModel.status.integerValue == 3) { // 待审核 || 已结束
        return;
    }
    NSString *str;
    if (jobModel.stick.integerValue == 1) {
        str = @"当前岗位处于置顶状态，若关闭岗位，剩余置顶天数将作废且不可恢复。请谨慎操作！";
    }else if (jobModel.is_left_job_vas_intelligent_refresh.integerValue == 1) {
        str = @"当前岗位处于智能刷新中，若关闭岗位，剩余刷新次数将作废且不可恢复。请谨慎操作！";
    }else{
        str = @"确定关闭该岗位？";
    }
   
    [ UIHelper showConfirmMsg:str title:nil cancelButton:@"在考虑下" okButton:@"确定关闭" completion:^(DLAVAlertView *alertView, NSInteger buttonIndex) {
        if (buttonIndex == 0) {
            return;
        } else if(buttonIndex == 1){
            NSString* content = [NSString stringWithFormat:@"job_id:%@", jobModel.job_id];
            RequestInfo* request = [[RequestInfo alloc] initWithService:@"shijianke_closeJob" andContent:content];
            request.isShowLoading = NO;
            request.loadingMessage = @"数据加载中...";
            WEAKSELF
            [request sendRequestWithResponseBlock:^(ResponseInfo *response) {
                if (response && [response success]) {
                    if (response.errCode.intValue==0) {
                        [UIHelper toast:@"关闭成功"];
                        [weakSelf getJobLists];
                        [WDNotificationCenter postNotificationName:IMNotification_EPMainEndJobUpdate object:nil];
                        [WDNotificationCenter postNotificationName:IMNotification_EPMainHeaderViewUpdate object:nil];
                    }
                }
            }];
        }
    }];
    
}

#pragma mark - 保证金业务
/** 查询岗位详情 考虑保证金金额问题 */
- (void)getJobDetailWith:(NSString *)jobId block:(MKBlock)block{
    WEAKSELF
    [[UserData sharedInstance] getJobDetailWithJobId:jobId andIsFromSAB:0 isShowLoding:YES Block:^(JobDetailModel *model) {
        if (model) {
            MKBlockExec(block, model.parttime_job.guarante_amount_pay_money);
        }else{
            [weakSelf getJobDetailWith:jobId block:block];
        }
    }];
}

- (void)enterPayselectForGuaranteeWith:(NSNumber *)jobId withGuaranteeAmount:(NSNumber *)guaranteeAmount{
    PaySelect_VC *viewCtrl = [[PaySelect_VC alloc] init];
    viewCtrl.fromType = PaySelectFromType_guaranteeAmount;
    viewCtrl.needPayMoney = guaranteeAmount.intValue;
    viewCtrl.jobId = jobId;
    viewCtrl.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:viewCtrl animated:YES];
}

#pragma mark- 查看简历
- (void)viewJKApplyWith:(JobModel *)jobModel{
    ApplyJKController *applyVC = [[ApplyJKController alloc] init];
    applyVC.jobId = jobModel.job_id.description;
    applyVC.isAccurateJob = jobModel.is_accurate_job;
    applyVC.managerType = ManagerTypeEP;
    applyVC.hidesBottomBarWhenPushed = YES;
    applyVC.blockBack = ^(BOOL isRefresh){
//        [self getLastestData:YES];[
        [self getLastestJobListForEP];
    };
    [self.navigationController pushViewController:applyVC animated:YES];
}

- (void)enterFindTalent:(JobModel *)model{
    FindTalent_VC *vc = [[FindTalent_VC alloc] init];
    vc.isBeginWithMJRefresh = YES;
    vc.age_limit = model.age;
    vc.city_id = model.city_id;
    vc.address_area_id = model.address_area_id;
    vc.job_classify_id = model.job_type_id;
    vc.city_name = model.city_name;
    vc.address_area_name = model.address_area_name;
    vc.job_classfie_name = model.job_classfie_name;
    vc.sex = model.sex;
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)pushJobWith:(JobModel *)model{
    PushOrder_VC *viewCtrl = [[PushOrder_VC alloc] init];
    viewCtrl.jobId = model.job_id.description;
    viewCtrl.isFromJobManage = YES;
    viewCtrl.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:viewCtrl animated:YES];
}

#pragma mark - 重写方法
- (void)noDataButtonAction:(UIButton *)sender{
    [UIHelper showLoginVCWithBlock:nil];
}

#pragma mark - notifation method 
- (void)updateMainTV{
    dispatch_async(dispatch_get_main_queue(), ^{
//        [self updateTableViewData];
        [self headerRefresh];
    });
}

- (void)loginSuccessNotifi{
    [self setNoDataViewWithstr:@"没有正在招聘的兼职" withBtn:nil];
    [self headerRefresh];
}

- (void)loginFailNotifi{
    dispatch_async(dispatch_get_main_queue(), ^{
        [UserData sharedInstance].loginFail = YES;
        [self setNodataViewWithLoginSatus];
    });
}

- (void)setTableViewTop{
    if (self.tableView) {
        [self.tableView setContentOffset:CGPointZero animated:NO];
    }
}

- (void)dealloc{
    [WDNotificationCenter removeObserver:self];
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
