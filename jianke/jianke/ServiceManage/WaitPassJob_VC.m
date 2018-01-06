//
//  WaitPassJob_VC.m
//  JKHire
//
//  Created by yanqb on 2017/1/10.
//  Copyright © 2017年 xianshijian. All rights reserved.
//

#import "WaitPassJob_VC.h"
#import "JobDetail_VC.h"
#import "SalaryRecord_VC.h"
#import "PostJob_VC.h"
#import "BuyJobNum_VC.h"
#import "VipInfoCenter_VC.h"
#import "VipIPacket_VC.h"
#import "InvitingForJobCell.h"

#import "JobModel.h"

@interface WaitPassJob_VC () <InvitingForJobDelegate>

@property (nonatomic, strong) GetEnterpriscJobModel *reqModel;
@property (nonatomic, weak) UIAlertView *alertView;


@end

@implementation WaitPassJob_VC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addNotification];
    self.reqModel = [[GetEnterpriscJobModel alloc] init];
    self.reqModel.query_param = [[QueryParamModel alloc] init];
    self.reqModel.query_type = @8;
    
    [self initUIWithType:DisplayTypeOnlyTableView];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.estimatedRowHeight = 130;
    
    self.tableView.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        if ([self.delegate respondsToSelector:@selector(waitPassJob:actionType:)]) {
            [self.delegate waitPassJob:self actionType:VCActionType_HeaderView];
        }
        [self headerRefresh];
    }];
    
    self.tableView.footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [self footerRefresh];
    }];
    
    [self setNodataViewWithLoginSatus];
    [self updatePostNum];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if ([[UserData sharedInstance] isUpdateWithEPWaitJob]) {
        [[UserData sharedInstance] setIsUpdateWithEPWaitJob:NO];
        [self getLastestJobListForEP];
    }
}

- (void)addNotification{
    ELog(@"====ep addNotification");
    [WDNotificationCenter addObserver:self selector:@selector(updateMainTV) name:IMNotification_EPMainWaitJobUpdate object:nil];
    [WDNotificationCenter addObserver:self selector:@selector(loginSuccessNotifi) name:WDNotifi_LoginSuccess object:nil];
    [WDNotificationCenter addObserver:self selector:@selector(appEnterForeground) name:WDNotification_ApplicationWillEnterForeground object:nil];
}

- (void)updatePostNum{
    if ([[UserData sharedInstance] isLogin]) {
        [[UserData sharedInstance] getPublishedJobNumWithIsSearchToday:@(1) block:^(ResponseInfo *response) {
            if (response && response.success) {
                ToadyPublishedJobNumRM *model = [ToadyPublishedJobNumRM objectWithKeyValues:response.content];
                [UserData sharedInstance].publishJobNumModel = model;
            }
        }];
    }
}

- (void)setNodataViewWithLoginSatus{
    WEAKSELF
    [[UserData sharedInstance] getUserStatus:^(UserLoginStatus loginStatus) {
        switch (loginStatus) {
            case UserLoginStatus_loginFail:{    //登录失败
            }
            case UserLoginStatus_needManualLogin:{  //需要手动登录
                //显示登录提醒界面
                [self setNoDataViewWithstr:@"您还没有登录" withBtn:@"登录"];
                self.viewWithNoData.hidden = NO;
            }
                break;
            case UserLoginStatus_canAutoLogin:{     //可自动登录
                //显示缓存
                [self setNoDataViewWithstr:@"没有待审核的岗位" withBtn:nil];
            }
                break;
            case UserLoginStatus_loginSuccess:{     //已经登录成功
                [self setNoDataViewWithstr:@"没有待审核的岗位" withBtn:nil];
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
            NSArray *dataList = [JobModel objectArrayWithKeyValuesArray:response.content[@"job_list"]];
            if (dataList.count) {
                weakSelf.viewWithNoData.hidden = YES;
                weakSelf.reqModel.query_param.page_num = @2;
                weakSelf.dataSource = [dataList mutableCopy];
            }else{
                [weakSelf.dataSource removeAllObjects];
                weakSelf.viewWithNoData.hidden = NO;
            }
            [weakSelf.tableView reloadData];
        }
    }];
    
}

- (void)getMoreJobListForEP{
    if (![[UserData sharedInstance] isLogin]) {
        [self.tableView.footer endRefreshing];
        return;
    }
    if (self.reqModel.query_param.page_num.integerValue == 1) {
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

#pragma mark - tableView delegate
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    InvitingForJobCell* cell = [InvitingForJobCell cellWithTableView:tableView];
    cell.delegate = self;
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
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    ELog(@"=========didSelectRowAtIndexPath:%ld",(long)indexPath.section);
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    JobModel* model = [self.dataSource objectAtIndex:indexPath.section];
    if (model.job_type.integerValue != 3) {
        JobDetail_VC* vc = [[JobDetail_VC alloc] init];
        vc.jobId = model.job_id.description;
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }else{
        SalaryRecord_VC *viewCtrl = [[SalaryRecord_VC alloc] init];
        viewCtrl.jobId = model.job_id.description;
        viewCtrl.isAddPay = YES;
        viewCtrl.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:viewCtrl animated:YES];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (((scrollView.contentOffset.y + scrollView.height) <= scrollView.contentSize.height)) {
        //        ELog(@"jobmanage offset:%f", scrollView.contentOffset.y);
        if ([self.delegate respondsToSelector:@selector(waitPassJob:scrollViewOffset:)]) {
            [self.delegate waitPassJob:self scrollViewOffset:scrollView.contentOffset];
        }
    }
    
}

#pragma mark - InvitingForJobDelegate
- (void)cell_btnBotOnClick:(JobModel *)model actionType:(JobOpreationType)actionType atIndexPath:(NSIndexPath *)indexPath{
    switch (actionType) {
        case JobOpreationType_Close:{   //关闭岗位
            [self closeJob:model atIndexPath:indexPath];
        }
            break;
        case JobOpreationType_Upload:{  //上架岗位
            [self submitJobWith:model];
        }
            break;
        case JobOpreationType_EditJob:{ //编辑岗位
            [self editJobWith:model];
        }
            break;
        default:
            break;
    }
}

#pragma mark - 岗位相关业务方法

- (void)closeJob:(JobModel *)jobModel atIndexPath:(NSIndexPath *)indexPath{

    [UIHelper showConfirmMsg:@"确定关闭岗位?" completion:^(DLAVAlertView *alertView, NSInteger buttonIndex) {
        if (buttonIndex == 0) {
            return;
        } else {
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

- (void)submitJobWith:(JobModel *)jobModel{
//    if (![[UserData sharedInstance] isEnableVipService]) {
//        if ([UserData sharedInstance].publishJobNumModel.authenticated_publish_job_num.integerValue >= 7) {  //非VIP 无权限发布了
//            [MKAlertView alertWithTitle:@"提示" message:@"今天您已经发布够多岗位，该岗位暂不上架显示招聘，等明天再来上架岗位吧" cancelButtonTitle:nil confirmButtonTitle:@"知道了" completion:nil];
//            return;
//        }
//    }
    
    WEAKSELF
    [[XSJRequestHelper sharedInstance] entJobSubmitAuditWithJobId:jobModel.job_id block:^(ResponseInfo *response) {
        if (response) {
            if (response.errCode.integerValue == 0) {   //提交成功
                [UIHelper toast:@"提交成功"];
                [weakSelf getJobLists];
                [WDNotificationCenter postNotificationName:IMNotification_EPMainHeaderViewUpdate object:nil];
            }else if (response.errCode.integerValue == 87 && response.errMsg.length){ //有权限，但是时间不对
                [UIHelper toast:response.errMsg];
                [weakSelf enterPostJobVCWithJob:jobModel isEditAction:NO];
            }else if (response.errCode.integerValue == 86 && response.errMsg.length){   //VIP城市，雇主没有提交审核权限
                [weakSelf showAlertWithLackOfCompetence:response.errMsg withJobId:jobModel.city_id];
            }else if (response.errMsg.length){
                [UIHelper toast:response.errMsg];
            }
        }
    }];
}

- (void)editJobWith:(JobModel *)jobModel{
    [self enterPostJobVCWithJob:jobModel isEditAction:YES];
}

- (void)showAlertWithLackOfCompetence:(NSString *)message withJobId:(NSNumber *)cityId{
    [MKAlertView alertWithTitle:@"提示" message:message cancelButtonTitle:@"开通VIP会员" confirmButtonTitle:@"购买在招岗位数" supportCancelGesture:YES completion:^(UIAlertView *alertView, NSInteger buttonIndex) {
        if (buttonIndex == 1) {
            [self enterRecuitVC:cityId];
        }else if (buttonIndex == 0){
            [self enetrmemberCenter];
        }
    }];
}

- (void)enetrmemberCenter{
    
    [self enterVipCenter:[[UserData sharedInstance] isAccoutVip]];

//    [[XSJRequestHelper sharedInstance] postSaleClueWithDesc:@"发布失败" isNeedContact:@0 isShowloading:YES block:^(id result) {
//        if (result) {
//            [UIHelper toast:@"信息已提交，请耐心等待顾问联系您~"];
//        }
//    }];
//    [[XSJRequestHelper sharedInstance] postSaleClueWithDesc:@"发布失败" isNeedContact:@0 block:nil];
}
- (void)enterVipCenter:(BOOL)isVip{
    if (isVip) {
        VipInfoCenter_VC *vc = [[VipInfoCenter_VC alloc] init];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }else{
        VipIPacket_VC *vc = [[VipIPacket_VC alloc] init];
        WEAKSELF
        vc.block = ^(id result){
            [weakSelf.navigationController popViewControllerAnimated:NO];
            [weakSelf enterVipCenter:YES];
        };
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }
    
}

- (void)enterRecuitVC:(NSNumber *)cityId{
    BuyJobNum_VC *viewCtrl = [[BuyJobNum_VC alloc] init];
    viewCtrl.recruit_city_id = cityId;
    viewCtrl.actionType = BuyJobNumActionType_ForReBuy;
    viewCtrl.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:viewCtrl animated:YES];
}

- (void)enterPostJobVCWithJob:(JobModel *)jobModel isEditAction:(BOOL)isEdite{
    PostJob_VC *viewCtrl = [[PostJob_VC alloc] init];
    viewCtrl.jobId = jobModel.job_id;
    viewCtrl.isUpload = YES;
    viewCtrl.postJobType = PostJobType_common;
    viewCtrl.myPostJobModel = [NSKeyedUnarchiver unarchiveObjectWithData:[NSKeyedArchiver archivedDataWithRootObject:jobModel]];
    
    if (isEdite) {
        viewCtrl.isEditAction = YES;
        viewCtrl.jobId = jobModel.job_id;
    }
    viewCtrl.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:viewCtrl animated:YES];
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
    [self setNoDataViewWithstr:@"没有待审核的岗位" withBtn:nil];
    [self updatePostNum];
    [self headerRefresh];
}

- (void)appEnterForeground{
    dispatch_async(dispatch_get_main_queue(), ^{
       [self updatePostNum];
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

@end
