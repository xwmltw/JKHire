//
//  MarketServiceMag_VC.m
//  JKHire
//
//  Created by xuzhi on 16/10/16.
//  Copyright © 2016年 xianshijian. All rights reserved.
//

#import "MarketServiceMag_VC.h"
#import "SpreadOrderCell.h"
#import "WebView_VC.h"

@interface MarketServiceMag_VC ()

@property (nonatomic, strong) QueryParamModel *queryParam;

@end

@implementation MarketServiceMag_VC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"推广服务";
    self.queryParam = [[QueryParamModel alloc] init];
    [self initUIWithType:DisplayTypeOnlyTableView];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerNib:nib(@"SpreadOrderCell") forCellReuseIdentifier:@"SpreadOrderCell"];
    [self initWithNoDataViewWithLabColor:[UIColor XSJColor_base] imgName:@"v3_public_nobill" onView:self.tableView strArgs:@"您还没有推广过哦", nil];
    self.refreshType = RefreshTypeAll;
    [self.tableView.header beginRefreshing];
}

- (void)headerRefresh{
    self.queryParam.page_num = @1;
    WEAKSELF
    [[XSJRequestHelper sharedInstance] getSpreadOrderWithParam:self.queryParam block:^(ResponseInfo *response) {
        [weakSelf.tableView.header endRefreshing];
        if (response) {
            NSArray *array = [SpreadOrderModel objectArrayWithKeyValuesArray:[response.content objectForKey:@"spread_order_list"]];
            if (array.count) {
                weakSelf.viewWithNoData.hidden = YES;
                weakSelf.queryParam.page_num = @2;
                weakSelf.dataSource = [array mutableCopy];
                [weakSelf.tableView reloadData];
            }else{
                weakSelf.viewWithNoData.hidden = NO;
            }
        }
    }];
}

- (void)footerRefresh{
    WEAKSELF
    [[XSJRequestHelper sharedInstance] getSpreadOrderWithParam:self.queryParam block:^(ResponseInfo *response) {
        [weakSelf.tableView.footer endRefreshing];
        if (response) {
            NSArray *array = [SpreadOrderModel objectArrayWithKeyValuesArray:[response.content objectForKey:@"spread_order_list"]];
            if (array.count) {
                weakSelf.queryParam.page_num = @(weakSelf.queryParam.page_num.integerValue + 1);
                [weakSelf.dataSource addObjectsFromArray:array];
                [weakSelf.tableView reloadData];
            }
        }
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    SpreadOrderCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SpreadOrderCell" forIndexPath:indexPath];
    SpreadOrderModel *model = [self.dataSource objectAtIndex:indexPath.row];
    [cell setModel:model];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 83.0f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    SpreadOrderModel *model = [self.dataSource objectAtIndex:indexPath.row];
    NSString *url;
    switch (model.orderType.integerValue) {
        case 1: //众包
            url = [NSString stringWithFormat:@"%@%@%@", URL_HttpServer, KUrl_ZhongbaoDemandDetail, model.spreadId];
            break;
        case 2: //熊地推
            url = [NSString stringWithFormat:@"%@%@%@", URL_HttpServer, KUrl_XdtDemandDetail, model.spreadId];
            break;
        default:
            return;
    }
    WebView_VC *viewCtrl = [[WebView_VC alloc] init];
    viewCtrl.url = url;
    viewCtrl.hidesBottomBarWhenPushed = YES;
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
