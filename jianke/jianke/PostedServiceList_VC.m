//
//  PostedServiceList_VC.m
//  JKHire
//
//  Created by yanqb on 16/11/8.
//  Copyright © 2016年 xianshijian. All rights reserved.
//

#import "PostedServiceList_VC.h"
#import "WebView_VC.h"
#import "PostedService_cell.h"
#import "ApplyService_VC.h"

@interface PostedServiceList_VC () <PostedService_cellDelegate>

@end

@implementation PostedServiceList_VC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"发布的服务";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"发布服务" style:UIBarButtonItemStylePlain target:self action:@selector(postServiceAction)];
    [self initUIWithType:DisplayTypeOnlyTableView];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerNib:nib(@"PostedService_cell") forCellReuseIdentifier:@"PostedService_cell"];
    [self initWithNoDataViewWithStr:@"您还没有发布的服务哦" onView:self.tableView];
    self.refreshType = RefreshTypeHeader;
    [self.tableView.header beginRefreshing];
}

- (void)headerRefresh{
    WEAKSELF
    [[XSJRequestHelper sharedInstance] queryServiceTeamApplyListWithEntID:nil status:nil block:^(ResponseInfo *response) {
        [weakSelf.tableView.header endRefreshing];
        if (response) {
            NSArray *array = [ServiceTeamApplyModel objectArrayWithKeyValuesArray:[response.content objectForKey:@"service_team_apply_list"]];
            if (array.count) {
                weakSelf.viewWithNoData.hidden = YES;
                weakSelf.dataSource = [array mutableCopy];
                [weakSelf.tableView reloadData];
            }else{
                weakSelf.viewWithNoData.hidden = NO;
            }
        }
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    PostedService_cell *cell = [tableView dequeueReusableCellWithIdentifier:@"PostedService_cell" forIndexPath:indexPath];
    cell.delegate = self;
    ServiceTeamApplyModel *model = [self.dataSource objectAtIndex:indexPath.row];
    [cell setModel:model];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 112.0f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    ServiceTeamApplyModel *model = [self.dataSource objectAtIndex:indexPath.row];

    WebView_VC *viewCtrl = [[WebView_VC alloc] init];
    NSString *url = [NSString stringWithFormat:@"%@%@?service_apply_id=%@&show_type=1", URL_HttpServer, KUrl_ServiceTeamDetail, model.id];
    viewCtrl.url = url;
    if (model.status.integerValue != 1) {
        viewCtrl.uiType = WebViewUIType_ServiceDetail;
        viewCtrl.service_classify_id = model.service_classify_id;
    }
    WEAKSELF
    viewCtrl.competeBlock = ^(id result){
        [weakSelf headerRefresh];
    };
    [self.navigationController pushViewController:viewCtrl animated:YES];

}

#pragma mark - PostedService_cellDelegate

- (void)editOnClickWithModel:(ServiceTeamApplyModel *)serviceModel{
    WebView_VC *viewCtrl = [[WebView_VC alloc] init];
    NSString *url = [NSString stringWithFormat:@"%@%@?classifyId=%@", URL_HttpServer, KUrl_toPostServiceInfoPage, serviceModel.service_classify_id];
    viewCtrl.url = url;
    WEAKSELF
    viewCtrl.competeBlock = ^(id result){
        [weakSelf headerRefresh];
    };
    [self.navigationController pushViewController:viewCtrl animated:YES];
}

- (void)postServiceAction{
    if (![self isEpModelImproved]) {
        ApplyService_VC *viewCtrl = [[ApplyService_VC alloc] init];
        viewCtrl.hidesBottomBarWhenPushed = YES;
        viewCtrl.isPostAction = YES;
        [self.navigationController pushViewController:viewCtrl animated:YES];
    }else{
        WebView_VC *viewCtrl = [[WebView_VC alloc] init];
        NSString *url = [NSString stringWithFormat:@"%@%@", URL_HttpServer, KUrl_toPostServiceInfoPage];
        viewCtrl.url = url;
        WEAKSELF
        viewCtrl.competeBlock = ^(id result){
            [weakSelf headerRefresh];
        };
        [self.navigationController pushViewController:viewCtrl animated:YES];
    }
}

- (BOOL)isEpModelImproved{
    EPModel *epModel = [[UserData sharedInstance] getEpModelFromHave];
    if (!epModel.service_name.length) {
        return NO;
    }
    if (!epModel.city_id) {
        return NO;
    }
    if (!epModel.service_contact_name.length) {
        return NO;
    }
    if (!epModel.service_contact_tel.length) {
        return NO;
    }
    if (!epModel.service_desc.length) {
        return NO;
    }
    return YES;
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
