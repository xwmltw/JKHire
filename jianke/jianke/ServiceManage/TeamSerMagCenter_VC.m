//
//  TeamSerMagCenter_VC.m
//  JKHire
//
//  Created by fire on 16/10/21.
//  Copyright © 2016年 xianshijian. All rights reserved.
//

#import "TeamSerMagCenter_VC.h"
#import "TeamServiceList_VC.h"
#import "WebView_VC.h"

#import "TeamServiceHeaderView.h"
#import "TeamTableViewCell.h"

@interface TeamSerMagCenter_VC (){
    BOOL _isFirstPush;
}

@property (nonatomic, strong) TeamJobModel *teamJobModel;
@property (nonatomic, weak) TeamServiceHeaderView *headerView;
@property (nonatomic, strong) QueryParamModel *queryParam;

@end

@implementation TeamSerMagCenter_VC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"需求详情";
    _isFirstPush = YES;
    self.queryParam = [[QueryParamModel alloc] init];
    [self setupViews];
    [self.tableView.header beginRefreshing];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

- (void)setupViews{
    self.btntitles = @[@"继续预约"];
    [self initUIWithType:DisplayTypeTableViewAndTopBottom];
    self.refreshType = RefreshTypeAll;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self initWithNoDataViewWithStr:@"暂时没有预约的团队" onView:self.tableView];
    
    TeamServiceHeaderView *headerView = [[[NSBundle mainBundle] loadNibNamed:@"TeamServiceHeaderView" owner:nil options:nil] lastObject];
    _headerView = headerView;
    [self.topView addSubview:headerView];
    [headerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.topView);
    }];
    self.topView.height = 106.5;

}

- (void)headerRefresh{
    self.queryParam.page_num = @1;
    WEAKSELF
    [[XSJRequestHelper sharedInstance] entQueryServiceTeamJobApplyListWithJobId:self.service_team_job_id param:self.queryParam block:^(ResponseInfo *response) {
        [weakSelf.tableView.header endRefreshing];
        if (response) {
            weakSelf.teamJobModel = [TeamJobModel objectWithKeyValues:[response.content objectForKey:@"service_team_job"]];
             [weakSelf.headerView setModel:weakSelf.teamJobModel];
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
    [[XSJRequestHelper sharedInstance] entQueryServiceTeamJobApplyListWithJobId:self.service_team_job_id param:self.queryParam block:^(ResponseInfo *response) {
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

//目前没用到 估计以后会用到 已结束订单 按钮状态
- (void)reloadData{
    [self.headerView setModel:self.teamJobModel];
    if (self.teamJobModel.status.integerValue != 1) {
        [self.bottomBtns enumerateObjectsUsingBlock:^(UIButton *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            obj.enabled = NO;
            [obj setTitle:@"已结束" forState:UIControlStateNormal];
        }];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    TeamTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TeamTableViewCell"];
    if (!cell) {
        cell = [[TeamTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"TeamTableViewCell"];
        cell.accessoryView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"info_icon_push_2"]];
        cell.textLabel.textColor = [UIColor XSJColor_tGrayDeepTinge];
        cell.textLabel.font = [UIFont systemFontOfSize:18.0f];
        cell.detailTextLabel.textColor = [UIColor XSJColor_tGrayDeepTransparent];
        cell.detailTextLabel.font = [UIFont systemFontOfSize:14.0f];
    }
    TeamCompanyModel *model = [self.dataSource objectAtIndex:indexPath.row];
    [cell setModel:model];
    return cell;
}

#pragma mark - uitableview delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 83.0f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    ELog(@"进入团队服务商列表");
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    TeamJobModel *model = [self.dataSource objectAtIndex:indexPath.row];
    WebView_VC *viewCtrl = [[WebView_VC alloc] init];
    NSString *url = [NSString stringWithFormat:@"%@%@?service_apply_id=%@", URL_HttpServer, KUrl_ServiceTeamDetail, model.service_apply_id];
    url = (self.service_team_job_id) ? [url stringByAppendingFormat:@"&service_team_job_id=%@", self.service_team_job_id] : url ;
    WEAKSELF
    viewCtrl.competeBlock = ^(id result){
        [weakSelf headerRefresh];
        MKBlockExec(weakSelf.block , @"收到来自火星的一封鸡毛信!");
    };
    viewCtrl.url = url;
    [self.navigationController pushViewController:viewCtrl animated:YES];
}

#pragma mark - 重写方法

- (void)clickOnview:(UIView *)bottomView clickedButtonAtIndex:(NSInteger)buttonIndex{
    TeamServiceList_VC *viewCtrl = [[TeamServiceList_VC alloc] init];
    viewCtrl.cityId = self.teamJobModel.city_id;
    viewCtrl.service_classify_id = self.teamJobModel.service_classify_id;
    viewCtrl.service_team_job_id = self.service_team_job_id;
    viewCtrl.isPopToPrevious = YES;
    WEAKSELF
    viewCtrl.block = ^(id result){
        [weakSelf headerRefresh];
        MKBlockExec(weakSelf.block , @"收到来自火星的一封鸡毛信!");
    };
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
