//
//  TeamServiceList_VC.m
//  JKHire
//
//  Created by fire on 16/10/14.
//  Copyright © 2016年 xianshijian. All rights reserved.
//

#import "TeamServiceList_VC.h"
#import "PostPersonalJob_VC.h"
#import "WebView_VC.h"

#import "TeamServiceListCell.h"

@interface TeamServiceList_VC (){
    QueryParamModel *_queryParam;
    BOOL _isFirstPush;
}

@property (nonatomic, strong) UIView *headerView;

@end

@implementation TeamServiceList_VC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = self.service_classify_name ? self.service_classify_name : @"预约团队服务";
    _queryParam = [[QueryParamModel alloc] init];
    _isFirstPush = YES;
    [self initUIWithType:DisplayTypeOnlyTableView];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self initWithNoDataViewWithStr:@"暂无服务商列表" onView:self.tableView];
    [self.tableView registerNib:nib(@"TeamServiceListCell") forCellReuseIdentifier:@"TeamServiceListCell"];
    self.tableView.estimatedRowHeight = 102.0f;
    self.tableView.estimatedRowHeight = 132.0f;
    self.refreshType = RefreshTypeAll;
    [self.tableView.header beginRefreshing];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (!_isFirstPush) {
        [self headerRefresh];
    }
    _isFirstPush = NO;
}

- (void)headerRefresh{
    _queryParam.page_num = @1;
    WEAKSELF
    [[XSJRequestHelper sharedInstance] getServiceTeamList:self.cityId serviceId:self.service_classify_id queryParam:_queryParam block:^(NSArray *result) {
        [weakSelf.tableView.header endRefreshing];
        weakSelf.viewWithNoData.hidden = NO;
        if (result.count) {
            if (!weakSelf.service_classify_name) {
                weakSelf.tableView.tableHeaderView = self.headerView;
            }
            weakSelf.viewWithNoData.hidden = YES;
            weakSelf.dataSource = [result mutableCopy];
            _queryParam.page_num = @(_queryParam.page_num.integerValue + 1);
            [weakSelf.tableView reloadData];
        }
    }];
}

- (void)footerRefresh{;
    WEAKSELF
    [[XSJRequestHelper sharedInstance] getServiceTeamList:self.cityId serviceId:self.service_classify_id queryParam:_queryParam block:^(NSArray *result) {
        [weakSelf.tableView.footer endRefreshing];
        if (result.count) {
            [weakSelf.dataSource addObjectsFromArray:result];
            _queryParam.page_num = @(_queryParam.page_num.integerValue + 1);
            [weakSelf.tableView reloadData];
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
    TeamServiceListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TeamServiceListCell" forIndexPath:indexPath];
    ServiceTeamModel *model = [self.dataSource objectAtIndex:indexPath.section];
    [cell setModel:model];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    ServiceTeamModel *model = [self.dataSource objectAtIndex:indexPath.section];
    return model.cellHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [[UserData sharedInstance] userIsLogin:^(id result) {
        ServiceTeamModel *model = [self.dataSource objectAtIndex:indexPath.section];
        WebView_VC *viewCtrl = [[WebView_VC alloc] init];
        NSString *url = [NSString stringWithFormat:@"%@%@?service_apply_id=%@", URL_HttpServer, KUrl_ServiceTeamDetail, model.service_apply_id];
        url = (self.service_team_job_id) ? [url stringByAppendingFormat:@"&service_team_job_id=%@", self.service_team_job_id] : url ;
        viewCtrl.url = url;
        viewCtrl.competeBlock = self.block;
        [self.navigationController pushViewController:viewCtrl animated:YES];
    }];
}

#pragma mark - lazy加载

- (UIView *)headerView{
    if (!_headerView) {
        _headerView = [[UIView alloc] init];
        UILabel *label = [[UILabel alloc] init];
        label.text = @"以下是为您挑选的服务商,邀约后可查看对方联系方式";
        label.font = [UIFont systemFontOfSize:14.0f];
        label.textColor = [UIColor XSJColor_tGrayDeepTransparent];
        label.numberOfLines = 0;
        [_headerView addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_headerView).offset(16);
            make.right.equalTo(_headerView).offset(-16);
            make.top.bottom.equalTo(_headerView);
        }];
        _headerView.height = [label contentSizeWithWidth:SCREEN_WIDTH - 32].height + 10;
    }
    return _headerView;
}

#pragma mark - 重写方法

- (void)backToLastView{
    if (self.isPopToPrevious) {
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        if ([[UserData sharedInstance] popManageViewCtrl]) {
            [self.navigationController popToViewController:[[UserData sharedInstance] popManageViewCtrl] animated:YES];
        }else{
            [self.navigationController popToRootViewControllerAnimated:YES];
        }
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
