//
//  HireOffJob_VC.m
//  JKHire
//
//  Created by yanqb on 2017/1/10.
//  Copyright © 2017年 xianshijian. All rights reserved.
//

#import "HireOffJob_VC.h"
#import "JobDetail_VC.h"
#import "SalaryRecord_VC.h"
#import "JKManage_NewVC.h"
#import "PostJob_VC.h"
#import "ManualAddPerson_VC.h"

#import "InvitingForJobCell.h"

#import "JobModel.h"

@interface HireOffJob_VC () <InvitingForJobDelegate>

@property (nonatomic, strong) GetEnterpriscJobModel *reqModel;

@end

@implementation HireOffJob_VC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addNotification];
    self.reqModel = [[GetEnterpriscJobModel alloc] init];
    self.reqModel.query_param = [[QueryParamModel alloc] init];
    self.reqModel.query_type = @2;
    
    [self initUIWithType:DisplayTypeOnlyTableView];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.refreshType = RefreshTypeAll;
    self.tableView.estimatedRowHeight = 153;
    
    [self setNodataViewWithLoginSatus];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if ([[UserData sharedInstance] isUpdateWithEPEndJob]) {
        [[UserData sharedInstance] setIsUpdateWithEPEndJob:NO];
        [self getLastestJobListForEP];
    }
}

- (void)addNotification{
    ELog(@"====ep addNotification");
    [WDNotificationCenter addObserver:self selector:@selector(updateMainTV) name:IMNotification_EPMainEndJobUpdate object:nil];
    [WDNotificationCenter addObserver:self selector:@selector(loginSuccessNotifi) name:WDNotifi_LoginSuccess object:nil];
}

- (void)setNodataViewWithLoginSatus{
    WEAKSELF
    [[UserData sharedInstance] getUserStatus:^(UserLoginStatus loginStatus) {
        switch (loginStatus) {
            case UserLoginStatus_loginFail:
            case UserLoginStatus_needManualLogin:{  //需要手动登录
                //显示登录提醒界面
                [self setNoDataViewWithstr:@"您还没有登录" withBtn:@"登录"];
                self.viewWithNoData.hidden = NO;
            }
                break;
            case UserLoginStatus_canAutoLogin:{     //可自动登录
                //显示缓存
                [self setNoDataViewWithstr:@"没有已结束的岗位" withBtn:nil];
            }
                break;
            case UserLoginStatus_loginSuccess:{     //已经登录成功
                [self setNoDataViewWithstr:@"没有已结束的岗位" withBtn:nil];
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
                [weakSelf.tableView reloadData];
            }else{
                weakSelf.viewWithNoData.hidden = NO;
            }
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
        vc.isOverJob = YES;
        vc.jobId = model.job_id.stringValue;
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (((scrollView.contentOffset.y + scrollView.height) <= scrollView.contentSize.height)) {
        //        ELog(@"jobmanage offset:%f", scrollView.contentOffset.y);
        if ([self.delegate respondsToSelector:@selector(hireOffJob:scrollViewOffset:)]) {
            [self.delegate hireOffJob:self scrollViewOffset:scrollView.contentOffset];
        }
    }
    
}

#pragma mark -InvitingForJobDelegate
- (void)cell_btnBotOnClick:(JobModel *)model actionType:(JobOpreationType)actionType atIndexPath:(NSIndexPath *)indexPath{
    switch (actionType) {
        case JobOpreationType_FastPost:{    //快捷发布
            [self fastPostJobWith:model];
        }
            break;
        case JobOpreationType_jobDaifa:{
            ManualAddPerson_VC *viewCtrl = [[ManualAddPerson_VC alloc] init];
            viewCtrl.title = @"添加发放对象";
            viewCtrl.job_id = model.job_id.description;
            viewCtrl.fromViewType = FromViewType_PayRecord;
            viewCtrl.block = ^(id result){
                [self.navigationController popToRootViewControllerAnimated:YES];
            };
            viewCtrl.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:viewCtrl animated:YES];
        }
            break;
        default:
            break;
    }
}

- (void)fastPostJobWith:(JobModel *)jobModel{
    PostJob_VC *viewCtrl = [[PostJob_VC alloc] init];
    viewCtrl.postJobType = PostJobType_common;
    viewCtrl.myPostJobModel = [NSKeyedUnarchiver unarchiveObjectWithData:[NSKeyedArchiver archivedDataWithRootObject:jobModel]];
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
    [self setNoDataViewWithstr:@"没有已结束的岗位" withBtn:nil];
    [self headerRefresh];
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
