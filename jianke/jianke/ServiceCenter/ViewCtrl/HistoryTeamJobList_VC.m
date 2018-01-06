//
//  HistoryTeamJobList_VC.m
//  JKHire
//
//  Created by fire on 16/10/15.
//  Copyright © 2016年 xianshijian. All rights reserved.
//

#import "HistoryTeamJobList_VC.h"
#import "HistoryTeamJobCell.h"
#import "WebView_VC.h"

#import "JobModel.h"

@interface HistoryTeamJobList_VC () <HistoryTeamJobCellDelegate>

@property (nonatomic, strong) QueryParamModel *queryParam;

@end

@implementation HistoryTeamJobList_VC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我发布的需求";
    self.queryParam = [[QueryParamModel alloc] init];
    self.tableViewStyle = UITableViewStyleGrouped;
    [self initUIWithType:DisplayTypeOnlyTableView];
    [self.tableView registerNib:nib(@"HistoryTeamJobCell") forCellReuseIdentifier:@"HistoryTeamJobCell"];
    [self initWithNoDataViewWithStr:@"您还没有发布过团队服务需求哦" onView:self.tableView];
    self.refreshType = RefreshTypeAll;
    [self.tableView.header beginRefreshing];
}

- (void)headerRefresh{
    self.queryParam.page_num = @1;
    WEAKSELF
    [[XSJRequestHelper sharedInstance] entQueryServiceTeamJobList:self.service_classify_id inHistory:nil queryParam:self.queryParam serviceApplyId:self.service_apply_id listType:@1 block:^(ResponseInfo *response) {
        [weakSelf.tableView.header endRefreshing];
        weakSelf.viewWithNoNetwork.hidden = YES;
        if (response) {
            NSArray *result = [JobModel objectArrayWithKeyValuesArray:[response.content objectForKey:@"service_team_job_list"]];
            if (result.count) {
                weakSelf.viewWithNoData.hidden = YES;
                weakSelf.dataSource = [result mutableCopy];
                weakSelf.queryParam.page_num = @2;
                [weakSelf.tableView reloadData];
            }else{
                weakSelf.viewWithNoData.hidden = NO;
            }
        }else{
            weakSelf.viewWithNoNetwork.hidden = NO;
        }
    }];
}

- (void)footerRefresh{
    WEAKSELF
    [[XSJRequestHelper sharedInstance] entQueryServiceTeamJobList:self.service_classify_id inHistory:nil queryParam:self.queryParam serviceApplyId:self.service_apply_id listType:@1 block:^(ResponseInfo *response) {
        [weakSelf.tableView.footer endRefreshing];
        if (response) {
            NSArray *result = [JobModel objectArrayWithKeyValuesArray:[response.content objectForKey:@"service_team_job_list"]];
            if (result.count) {
                [weakSelf.dataSource addObjectsFromArray:result];
                weakSelf.queryParam.page_num = @(weakSelf.queryParam.page_num.integerValue + 1);
                [weakSelf.tableView reloadData];
                
            }
        }
    }];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.dataSource ? self.dataSource.count : 0 ;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    HistoryTeamJobCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HistoryTeamJobCell" forIndexPath:indexPath];
    cell.delegate = self;
    JobModel *model = [self.dataSource objectAtIndex:indexPath.section];
    cell.isFromHitoryJob = YES;
    [cell setModel:model atIndexPath:indexPath];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 121.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 20.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.1f;
}

#pragma mark - HistoryTeamJobCell delegate

- (void)btnInviteOnClickAtIndexpath:(NSIndexPath *)indexPath{
    JobModel *model = [self.dataSource objectAtIndex:indexPath.section];
    WEAKSELF
    [[XSJRequestHelper sharedInstance] entOrderServiceTeam:self.service_apply_id teamJobId:model.service_team_job_id block:^(id result) {
        if (result) {
            WebView_VC *viewCtrl = [[WebView_VC alloc] init];
            viewCtrl.isFromTeamPost = YES;
            NSString *url = [NSString stringWithFormat:@"%@%@?service_apply_id=%@", URL_HttpServer, KUrl_ServiceTeamDetail, weakSelf.service_apply_id];
            url = (model.service_team_job_id) ? [url stringByAppendingFormat:@"&service_team_job_id=%@", model.service_team_job_id] : url ;
            viewCtrl.url = url;
            [self.navigationController pushViewController:viewCtrl animated:YES];
        }
    }];
}

#pragma mark - HistoryTeamJobCellDelegate

- (void)btnInviteOnClick{
    
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
