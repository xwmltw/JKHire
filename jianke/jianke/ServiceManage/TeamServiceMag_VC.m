//
//  TeamServiceMag_VC.m
//  JKHire
//
//  Created by xuzhi on 16/10/16.
//  Copyright © 2016年 xianshijian. All rights reserved.
//

#import "TeamServiceMag_VC.h"
#import "TeamSerMagCenter_VC.h"

#import "HistoryTeamJobCell.h"

#import "TeamJobModel.h"

@interface TeamServiceMag_VC ()

@property (nonatomic, strong) NSMutableArray *currentArr;   /*!< 正在发布中需求列表 */
@property (nonatomic, strong) NSMutableArray *historyArr;   /*!< 历史发布的需求列表 */
@property (nonatomic, strong) QueryParamModel *queryParam;
@property (nonatomic, strong) UIView *sectionFooterView;
@property (nonatomic, weak) UIButton *historyButton;

@end

@implementation TeamServiceMag_VC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的预约单";
    self.queryParam = [[QueryParamModel alloc] init];
    self.currentArr = [NSMutableArray array];
    self.historyArr = [NSMutableArray array];
    self.dataSource = [NSMutableArray arrayWithObjects:_currentArr, _historyArr, nil];
    self.tableViewStyle = UITableViewStyleGrouped;
    [self initUIWithType:DisplayTypeOnlyTableView];
    self.refreshType = RefreshTypeAll;
    [self.tableView registerNib:nib(@"HistoryTeamJobCell") forCellReuseIdentifier:@"HistoryTeamJobCell"];
    [self initWithNoDataViewWithLabColor:[UIColor XSJColor_base] imgName:@"v3_public_nobill" onView:self.tableView strArgs:@"您还没有预约过哦", nil];
    [self.tableView.header beginRefreshing];
    self.sectionFooterView.hidden = NO;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

- (void)headerRefresh{
    self.queryParam.page_num = @1;
    WEAKSELF
    [[XSJRequestHelper sharedInstance] entQueryServiceTeamJobList:nil inHistory:@(0) queryParam:nil serviceApplyId:nil listType:nil block:^(ResponseInfo *response) {
        if (response) {
            weakSelf.queryParam.page_num = @1;
            NSArray *array = [TeamJobModel objectArrayWithKeyValuesArray:[response.content objectForKey:@"service_team_job_list"]];
            if (array.count) { //有正在招聘中的需求
                [weakSelf.tableView.header endRefreshing];
                [self setHistoryBtnEnable:YES];
                [weakSelf.currentArr removeAllObjects];
                [weakSelf.currentArr addObjectsFromArray:array];
                [weakSelf.historyArr removeAllObjects];
                [weakSelf.tableView reloadData];
                [weakSelf judgeIsNoData];
            }else{
                [weakSelf footerRefresh];
            }
            [weakSelf setHistoryBtnWithNumber:[response.content objectForKey:@"history_service_team_job_list_count"]];
        }else{
            [weakSelf.tableView.header endRefreshing];
        }
    }];
}

- (void)footerRefresh{
    WEAKSELF
    [[XSJRequestHelper sharedInstance] entQueryServiceTeamJobList:nil inHistory:@(1) queryParam:self.queryParam serviceApplyId:nil listType:nil block:^(ResponseInfo *response) {
        [weakSelf.tableView.header endRefreshing];
        [weakSelf.tableView.footer endRefreshing];
        if (response) {
            NSArray *array = [TeamJobModel objectArrayWithKeyValuesArray:[response.content objectForKey:@"service_team_job_list"]];
            if (array.count) {
                if (weakSelf.queryParam.page_num.integerValue == 1) {
                    [weakSelf.historyArr removeAllObjects];
                }
                [weakSelf.historyArr addObjectsFromArray:array];
                weakSelf.queryParam.page_num = @(weakSelf.queryParam.page_num.integerValue + 1);
                [weakSelf.tableView reloadData];
            }
            [weakSelf setHistoryBtnEnable:NO];
        }
        [weakSelf judgeIsNoData];
    }];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.dataSource.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return self.currentArr.count;
    }else if (section == 1){
        return self.historyArr.count;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    HistoryTeamJobCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HistoryTeamJobCell" forIndexPath:indexPath];
    TeamJobModel *model = [[self.dataSource objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    [cell setModel:model atIndexPath:indexPath];
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    if (section == 0 && (self.currentArr.count || self.historyArr.count)) {
        return self.sectionFooterView;
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 107.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.1f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section == 0) {
        return 42.0f;
    }
    return 0.1f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    TeamJobModel *model = [[self.dataSource objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    TeamSerMagCenter_VC *viewCtrl = [[TeamSerMagCenter_VC alloc] init];
    viewCtrl.service_team_job_id = model.service_team_job_id;
    WEAKSELF
    viewCtrl.block = ^(id result){
        [weakSelf headerRefresh];
    };
    viewCtrl.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:viewCtrl animated:YES];
}

#pragma mark - 自定义方法

- (void)judgeIsNoData{
    if (!(self.currentArr.count || self.historyArr.count)) {
        self.viewWithNoData.hidden = NO;
    }else{
        self.viewWithNoData.hidden = YES;
    }
}

- (UIView *)sectionFooterView{
    if (!_sectionFooterView) {
        UIView *view = [[UIView alloc] init];
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        [button setTitle:@"历史记录" forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:14.0f];
        [button setCornerValue:2.0f];
        [button addTarget:self action:@selector(historyBtnOnClick:) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:button];
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(view);
            make.width.greaterThanOrEqualTo(@120);
            make.height.equalTo(@30);
        }];
        _historyButton = button;
        _sectionFooterView = view;
        [self setHistoryBtnEnable:YES];
    }
    return _sectionFooterView;
}

- (void)historyBtnOnClick:(UIButton *)sender{
    self.queryParam.page_num = @1;
    [self.tableView.footer beginRefreshing];
}

- (void)setHistoryBtnWithNumber:(NSNumber *)titleNum{
    [self.historyButton setTitle:[NSString stringWithFormat:@"历史记录(%@)", titleNum] forState:UIControlStateNormal];
}

- (void)setHistoryBtnEnable:(BOOL)enable{
    self.historyButton.enabled = enable;
    if (enable) {
        [self.historyButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.historyButton setImage:[UIImage imageNamed:@"v3_public_history_white"] forState:UIControlStateNormal];
        self.historyButton.backgroundColor = [UIColor XSJColor_tGrayHistoyTransparent];
    }else{
        [self.historyButton setTitleColor:[UIColor XSJColor_tGrayTinge] forState:UIControlStateNormal];
        [self.historyButton setImage:[UIImage imageNamed:@"v3_public_history"] forState:UIControlStateNormal];
        self.historyButton.backgroundColor = [UIColor clearColor];
    }
}

- (void)dealloc{
    [WDNotificationCenter removeObserver:self];
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
