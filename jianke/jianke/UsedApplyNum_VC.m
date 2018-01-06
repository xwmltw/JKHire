//
//  UsedApplyNum_VC.m
//  JKHire
//
//  Created by yanqb on 2017/5/11.
//  Copyright © 2017年 xianshijian. All rights reserved.
//

#import "UsedApplyNum_VC.h"
#import "UsedApplyNUm_Cell.h"

@interface UsedApplyNum_VC ()

@property (nonatomic, strong) QueryParamModel *queryParam;

@end

@implementation UsedApplyNum_VC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"已消耗报名数";
    self.queryParam = [[QueryParamModel alloc] init];
    [self initUIWithType:DisplayTypeOnlyTableView];
    self.tableView.backgroundColor = [UIColor XSJColor_newWhite];
    [self initWithNoDataViewWithStr:@"暂无相关数据" onView:self.tableView];
    self.refreshType = RefreshTypeAll;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerNib:nib(@"UsedApplyNUm_Cell") forCellReuseIdentifier:@"UsedApplyNUm_Cell"];
    [self.tableView.header beginRefreshing];
}

- (void)headerRefresh{
    switch (self.fromType) {
        case UsedApplyNumType_vip:{
            [self getDataFroVip];
        }
            break;
        case UsedApplyNumType_baozhao:{
            [self getDataForBaoZhao];
        }
            break;
        default:
            break;
    }
}

- (void)getDataFroVip{
    self.queryParam.page_num = @1;
    WEAKSELF
    [[XSJRequestHelper sharedInstance] queryJobListByVipOrder:self.vip_order_id queryParam:self.queryParam block:^(ResponseInfo *response) {
        [weakSelf.tableView.header endRefreshing];
        if (response) {
            NSArray *array = [VipJobListModel objectArrayWithKeyValuesArray:[response.content objectForKey:@"job_list"]];
            weakSelf.dataSource = [array mutableCopy];
            if (array.count) {
                weakSelf.viewWithNoData.hidden = YES;
                weakSelf.queryParam.page_num = @2;
            }else{
                weakSelf.viewWithNoData.hidden = NO;
            }
            [weakSelf.tableView reloadData];
        }
    }];
}

- (void)getDataForBaoZhao{
    self.queryParam.page_num = @1;
    WEAKSELF
    [[XSJRequestHelper sharedInstance] queryJobListByArrangedAgentVasOrder:self.arranged_agent_vas_order_id queryParam:self.queryParam block:^(ResponseInfo *result) {
        [weakSelf.tableView.header endRefreshing];
        if (result) {
            NSArray *array = [VipJobListModel objectArrayWithKeyValuesArray:[result.content objectForKey:@"job_list"]];
            if (array.count) {
                weakSelf.queryParam.page_num = @2;
                weakSelf.viewWithNoData.hidden = YES;
            }else{
                weakSelf.viewWithNoData.hidden = NO;
            }
            weakSelf.dataSource = [array mutableCopy];
            [weakSelf.tableView reloadData];
        }
    }];
}

- (void)footerRefresh{
    switch (self.fromType) {
        case UsedApplyNumType_vip:{
            [self getMoreDataForVip];
        }
            break;
        case UsedApplyNumType_baozhao:{
            [self getMoreDaraFroBaoZhao];
        }
            break;
        default:
            break;
    }
}

- (void)getMoreDataForVip{
    WEAKSELF
    [[XSJRequestHelper sharedInstance] queryJobListByVipOrder:self.vip_order_id queryParam:self.queryParam block:^(ResponseInfo *response) {
        [weakSelf.tableView.footer endRefreshing];
        if (response) {
            NSArray *array = [VipJobListModel objectArrayWithKeyValuesArray:[response.content objectForKey:@"job_list"]];
            if (array.count) {
                [weakSelf.dataSource addObjectsFromArray:array];
                weakSelf.queryParam.page_num = @(weakSelf.queryParam.page_num.integerValue + 1);
                [weakSelf.tableView reloadData];
            }
        }
    }];
}

- (void)getMoreDaraFroBaoZhao{
    WEAKSELF
    [[XSJRequestHelper sharedInstance] queryJobListByArrangedAgentVasOrder:self.arranged_agent_vas_order_id queryParam:self.queryParam block:^(ResponseInfo *result) {
        [weakSelf.tableView.footer endRefreshing];
        if (result) {
            NSArray *array = [VipJobListModel objectArrayWithKeyValuesArray:[result.content objectForKey:@"job_list"]];
            if (array.count) {
                weakSelf.queryParam.page_num = @(weakSelf.queryParam.page_num.integerValue + 1);
                [weakSelf.dataSource addObjectsFromArray:array];
                [weakSelf.tableView reloadData];
            }
        }
    }];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.dataSource.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UsedApplyNUm_Cell *cell = [tableView dequeueReusableCellWithIdentifier:@"UsedApplyNUm_Cell" forIndexPath:indexPath];
    VipJobListModel *model = [self.dataSource objectAtIndex:indexPath.section];
    cell.model = model;
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [UIColor XSJColor_newWhite];
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 54.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return 16.0f;
    }
    return 8.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    VipJobListModel *model = [self.dataSource objectAtIndex:indexPath.section];
    if (model.curr_used_apply_num.integerValue) {
        UsedApplyNumDetail_VC *vc = [[UsedApplyNumDetail_VC alloc] init];
        vc.title = [NSString stringWithFormat:@"%@-%@-%@",model.job_city_name, model.job_title, [model getStatusStr]];
        vc.vip_order_id = self.vip_order_id;
        vc.arranged_agent_vas_order_id = self.arranged_agent_vas_order_id;
        vc.fromType = self.fromType;
        vc.jobId = model.job_id;
        [self.navigationController pushViewController:vc animated:YES];
    }
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
