//
//  UsedApplyNumDetail_VC.m
//  JKHire
//
//  Created by yanqb on 2017/5/11.
//  Copyright © 2017年 xianshijian. All rights reserved.
//

#import "UsedApplyNumDetail_VC.h"
#import "UsedApplyNumDetail_Cell.h"

@interface UsedApplyNumDetail_VC ()

@property (nonatomic, strong) QueryParamModel *queryModel;

@end

@implementation UsedApplyNumDetail_VC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.queryModel = [[QueryParamModel alloc] init];
    [self initUIWithType:DisplayTypeOnlyTableView];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.refreshType = RefreshTypeAll;
    [self.tableView registerNib:nib(@"UsedApplyNumDetail_Cell") forCellReuseIdentifier:@"UsedApplyNumDetail_Cell"];
    [self.tableView.header beginRefreshing];
}

- (void)headerRefresh{
    switch (self.fromType) {
        case UsedApplyNumType_vip:{
            [self getDataForVip];
        }
            break;
        case UsedApplyNumType_baozhao:{
            [self getDataForBZ];
        }
            break;
        default:
            break;
    }
}

- (void)footerRefresh{
    switch (self.fromType) {
        case UsedApplyNumType_vip:{
            [self getMoreDataForVip];
        }
            break;
        case UsedApplyNumType_baozhao:{
            [self getMoreDataForBZ];
        }
            break;
        default:
            break;
    }
}

- (void)getDataForVip{
    self.queryModel.page_num = @1;
    WEAKSELF
    [[XSJRequestHelper sharedInstance] queryApplyJobListByVipOrderJob:self.jobId orderId:self.vip_order_id queryParam:self.queryModel block:^(ResponseInfo *response) {
        [weakSelf.tableView.header endRefreshing];
        if (response) {
            NSArray *array = [ApplyJobListStu objectArrayWithKeyValuesArray:[response.content objectForKey:@"vip_order_apply_job_list"]];
            weakSelf.dataSource = [array mutableCopy];
            if (array.count) {
                weakSelf.queryModel.page_num = @2;
            }
            [weakSelf.tableView reloadData];
        }
    }];
}

- (void)getMoreDataForVip{
    WEAKSELF
    [[XSJRequestHelper sharedInstance] queryApplyJobListByVipOrderJob:self.jobId orderId:self.vip_order_id queryParam:self.queryModel block:^(ResponseInfo *response) {
        [weakSelf.tableView.footer endRefreshing];
        if (response) {
            NSArray *array = [ApplyJobListStu objectArrayWithKeyValuesArray:[response.content objectForKey:@"vip_order_apply_job_list"]];
            if (array.count) {
                [weakSelf.dataSource addObjectsFromArray:array];
                weakSelf.queryModel.page_num = @(weakSelf.queryModel.page_num.integerValue + 1);
                [weakSelf.tableView reloadData];
            }
        }
    }];
}

- (void)getDataForBZ{
    self.queryModel.page_num = @1;
    WEAKSELF
    [[XSJRequestHelper sharedInstance] queryApplyListByArrangedAgentVasOrder:self.arranged_agent_vas_order_id jobId:self.jobId queryParam:self.queryModel block:^(ResponseInfo *response) {
        [weakSelf.tableView.header endRefreshing];
        if (response) {
            NSArray *array = [ApplyJobListStu objectArrayWithKeyValuesArray:[response.content objectForKey:@"vip_order_apply_job_list"]];
            if (array.count) {
                [weakSelf.dataSource addObjectsFromArray:array];
                weakSelf.queryModel.page_num = @(weakSelf.queryModel.page_num.integerValue + 1);
                [weakSelf.tableView reloadData];
            }
        }
    }];
}

- (void)getMoreDataForBZ{
    WEAKSELF
    [[XSJRequestHelper sharedInstance] queryApplyListByArrangedAgentVasOrder:self.arranged_agent_vas_order_id jobId:self.jobId queryParam:self.queryModel block:^(ResponseInfo *response) {
        [weakSelf.tableView.footer endRefreshing];
        if (response) {
            NSArray *array = [ApplyJobListStu objectArrayWithKeyValuesArray:[response.content objectForKey:@"vip_order_apply_job_list"]];
            if (array.count) {
                [weakSelf.dataSource addObjectsFromArray:array];
                weakSelf.queryModel.page_num = @(weakSelf.queryModel.page_num.integerValue + 1);
                [weakSelf.tableView reloadData];
            }
        }
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UsedApplyNumDetail_Cell *cell = [tableView dequeueReusableCellWithIdentifier:@"UsedApplyNumDetail_Cell" forIndexPath:indexPath];
    ApplyJobListStu *model = [self.dataSource objectAtIndex:indexPath.row];
    cell.model = model;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 40.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 20.0f;
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
