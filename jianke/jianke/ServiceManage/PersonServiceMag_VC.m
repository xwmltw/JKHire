//
//  PersonServiceMag_VC.m
//  JKHire
//
//  Created by xuzhi on 16/10/16.
//  Copyright © 2016年 xianshijian. All rights reserved.
//

#import "PersonServiceMag_VC.h"
#import "PersonPostedJobCell.h"
#import "PersonSerMagCenter_VC.h"

@interface PersonServiceMag_VC ()

@property (nonatomic, strong) NSMutableArray *currentArr;   /*!< 正在发布中需求列表 */
@property (nonatomic, strong) NSMutableArray *historyArr;   /*!< 历史发布的需求列表 */
@property (nonatomic, strong) QueryParamModel *queryParam;
@property (nonatomic, strong) UIView *sectionFooterView;
@property (nonatomic, weak) UIButton *historyButton;
@property (nonatomic, assign) BOOL isFirstPush;

@end

@implementation PersonServiceMag_VC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.isFirstPush = YES;
    self.queryParam = [[QueryParamModel alloc] init];
    self.currentArr = [NSMutableArray array];
    self.historyArr = [NSMutableArray array];
    self.dataSource = [NSMutableArray arrayWithObjects:_currentArr, _historyArr, nil];
    self.tableViewStyle = UITableViewStyleGrouped;
    [self initUIWithType:DisplayTypeOnlyTableView];
    self.refreshType = RefreshTypeAll;
    [self.tableView registerNib:nib(@"PersonPostedJobCell") forCellReuseIdentifier:@"PersonPostedJobCell"];
    [self initWithNoDataViewWithLabColor:[UIColor XSJColor_base] imgName:@"v3_public_nobill" onView:self.tableView strArgs:@"您还没有邀约过哦",@"到首页右上角处开始第一次邀约吧", nil];
    self.tableView.estimatedRowHeight = 139.0f;
    [self.tableView.header beginRefreshing];
    self.sectionFooterView.hidden = NO;
    [WDNotificationCenter addObserver:self selector:@selector(refreshData) name:IMPushServicePersonalNotification object:nil];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if ([UserData sharedInstance].hasPostPersonalService) {
        [UserData sharedInstance].hasPostPersonalService = NO;
        [self headerRefresh];
    }
}

- (void)notifyAction{
    
}

- (void)refreshData{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self headerRefresh];
    });
}

- (void)headerRefresh{
    WEAKSELF
    [[XSJRequestHelper sharedInstance] entQueryServicePersonalJobList:nil withAccountId:nil inHistory:@(0) queryParam:nil listType:nil block:^(ResponseInfo *response) {
        if (response) {
            weakSelf.queryParam.page_num = @1;
            NSArray *array = [JobModel objectArrayWithKeyValuesArray:[response.content objectForKey:@"service_personal_job_list"]];
            if (array.count) { //有正在招聘中的需求
                [weakSelf.tableView.header endRefreshing];
                [self setHistoryBtnEnable:YES];
                [weakSelf.currentArr removeAllObjects];
                [weakSelf.currentArr addObjectsFromArray:array];
                [weakSelf.historyArr removeAllObjects];
                [weakSelf.tableView reloadData];
                [weakSelf judgeIsNoData];
            }else{
                [weakSelf getHistoryDataWithNoData:YES];
            }
            [weakSelf setHistoryBtnWithNumber:[response.content objectForKey:@"history_service_personal_job_list_count"]];
        }else{
            [weakSelf.tableView.header endRefreshing];
        }
    }];
}

- (void)getHistoryDataWithNoData:(BOOL)hasNoData{
    WEAKSELF
    [[XSJRequestHelper sharedInstance] entQueryServicePersonalJobList:nil withAccountId:nil inHistory:@(1) queryParam:self.queryParam listType:nil block:^(ResponseInfo *response) {
        [weakSelf.tableView.header endRefreshing];
        [weakSelf.tableView.footer endRefreshing];
        if (response) {
            NSArray *array = [JobModel objectArrayWithKeyValuesArray:[response.content objectForKey:@"service_personal_job_list"]];
            if (hasNoData) {
                [weakSelf.currentArr removeAllObjects];
            }
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

- (void)footerRefresh{
    [self getHistoryDataWithNoData:NO];
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
    PersonPostedJobCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PersonPostedJobCell" forIndexPath:indexPath];
    cell.isFromPersonManage = YES;
    JobModel *model = [[self.dataSource objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    [cell setModel:model];
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    if (section == 0 && (self.currentArr.count || self.historyArr.count)) {
        return self.sectionFooterView;
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    JobModel *model = [[self.dataSource objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    return model.cellHeight;
//    return 139.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.1f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section == 0) {
        return 50.0f;
    }
    return 0.1f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    JobModel *model = [[self.dataSource objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    model.accept_apply_small_red_point = @0;
    [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
    PersonSerMagCenter_VC *viewCtrl = [[PersonSerMagCenter_VC alloc] init];
    viewCtrl.service_personal_job_id = model.service_personal_job_id;
    viewCtrl.service_type = model.service_type;
    viewCtrl.platform_invite_accept_num = model.platform_invite_accept_num;
    WEAKSELF
    viewCtrl.block = ^(id result){
        ELog(@"哈哈哈哈哈哈");
//        switch (actionType) {
//            case 1:{    //刷新指定数据
//                [weakSelf headerRefresh];
//            }
//                break;
//            case 2:{    //订单结束，刷新整个列表
                [weakSelf headerRefresh];
//            }
//                break;
//            default:
//                break;
//        }
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
