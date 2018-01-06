//
//  MyOrderList_VC.m
//  JKHire
//
//  Created by fire on 16/10/24.
//  Copyright © 2016年 xianshijian. All rights reserved.
//

#import "MyOrderList_VC.h"
#import "MyOrderDetail_VC.h"

#import "HistoryTeamJobCell.h"

@interface MyOrderList_VC ()

@property (nonatomic, strong) QueryParamModel *queryParam;

@end

@implementation MyOrderList_VC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"服务订单";
    self.queryParam = [[QueryParamModel alloc] init];
    [self initUIWithType:DisplayTypeOnlyTableView];
    self.refreshType = RefreshTypeAll;
    [self.tableView registerNib:nib(@"HistoryTeamJobCell") forCellReuseIdentifier:@"HistoryTeamJobCell"];
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self initWithNoDataViewWithLabColor:nil imgName:nil onView:self.tableView strArgs:@"暂无订单", @"完善服务信息后订单变多哦", nil];
    [self.tableView.header beginRefreshing];
}

- (void)headerRefresh{
    self.queryParam.page_num = @1;
    WEAKSELF
    [[XSJRequestHelper sharedInstance] queryServiceTeamJobApplyListWithListType:@1 queryParam:self.queryParam block:^(ResponseInfo *response) {
        [weakSelf.tableView.header endRefreshing];
        if (response) {
            NSArray *array = [TeamCompanyModel objectArrayWithKeyValuesArray:[response.content objectForKey:@"service_team_job_apply_list"]];
            if (array.count) {
                weakSelf.viewWithNoData.hidden = YES;
                weakSelf.dataSource = [array mutableCopy];
                weakSelf.queryParam.page_num = @2;
                [weakSelf.tableView reloadData];
            }else{
                weakSelf.viewWithNoData.hidden = NO;
            }
        }
    }];
}

- (void)footerRefresh{
    WEAKSELF
    [[XSJRequestHelper sharedInstance] queryServiceTeamJobApplyListWithListType:@1 queryParam:self.queryParam block:^(ResponseInfo *response) {
        [weakSelf.tableView.footer endRefreshing];
        if (response) {
            NSArray *array = [TeamCompanyModel objectArrayWithKeyValuesArray:[response.content objectForKey:@"service_team_job_apply_list"]];
            if (array.count) {
                [weakSelf.dataSource addObjectsFromArray:array];
                weakSelf.queryParam.page_num = @(weakSelf.queryParam.page_num.integerValue + 1);
                [weakSelf.tableView reloadData];
            }
        }
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    HistoryTeamJobCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HistoryTeamJobCell" forIndexPath:indexPath];
    TeamCompanyModel *model = [self.dataSource objectAtIndex:indexPath.row];
    [cell setTeamCompanyModel:model];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 107.0f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    TeamCompanyModel *model = [self.dataSource objectAtIndex:indexPath.row];
    MyOrderDetail_VC *viewCtrl = [[MyOrderDetail_VC alloc] init];
    viewCtrl.service_team_job_apply_id = model.id;
    [self.navigationController pushViewController:viewCtrl animated:YES];
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
