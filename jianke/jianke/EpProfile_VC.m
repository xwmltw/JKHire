//
//  EpProfile_VC.m
//  JKHire
//
//  Created by fire on 16/11/5.
//  Copyright © 2016年 xianshijian. All rights reserved.
//

#import "EpProfile_VC.h"
#import "XZTabBarCtrl.h"
#import "EpProfileHeadeView.h"
#import "WDConst.h"
#import "EpProfileCell.h"
#import "EpProfileCell_summary.h"
#import "JobExpressCell.h"
#import "JobModel.h"
#import "EditEmployerInfo_VC.h"
#import "EpPostedJobList_VC.h"
#import "JobDetail_VC.h"
#import "EprofileCaseCell.h"
#import "WebView_VC.h"
#import "EPVerity_VC.h"
#import "PictureBrowser.h"

#define TableViewTag 100
static int clickNum = 0;

@interface EpProfile_VC () <EpProfileHeadeViewDelegate, EpProfileCellDelegate,UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, weak) EpProfileHeadeView *topView;
@property (nonatomic, weak) UIScrollView *scrollview;

@property (nonatomic, strong) UIView *jobTableViewWithNoData;
@property (nonatomic, strong) UIView *caseTableViewWithNoData;

@property (nonatomic, weak) UITableView *indexTableView;
@property (nonatomic, strong) NSMutableArray *firstArr;

@property (nonatomic, weak) UITableView *jobTableView;
@property (nonatomic, strong) NSMutableArray *secondArr;

@property (nonatomic, weak) UITableView *caseTableView;
@property (nonatomic, strong) NSMutableArray *thirdArr;

@property (nonatomic, weak) UIButton *botBtn;

@property (nonatomic, assign) BOOL isFirstRefreshJobTableview;
@property (nonatomic, assign) CGFloat topViewHeight;
@property (nonatomic, assign) CGFloat scrollViewHeight;

@end

@implementation EpProfile_VC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadDatas];
    [self setupViews];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    WEAKSELF
    [[UserData sharedInstance] getEPModelWithBlock:^(EPModel *result) {
        if (result) {
            weakSelf.epModel = result;
            [weakSelf.indexTableView reloadData];
            [weakSelf.topView setEpModel:result];
            if (weakSelf.epModel.is_apply_service_team.integerValue == 1) {
                self.scrollview.contentSize = CGSizeMake(SCREEN_WIDTH * 3 , self.view.height - 64 - self.topViewHeight);
            }
        }
    }];
}

- (void)loadDatas{
    self.isFirstRefreshJobTableview = YES;
    self.firstArr = [NSMutableArray array];
    [self.firstArr addObject:@(EpProfileCellType_hireCity)];
    [self.firstArr addObject:@(EpProfileCellType_industry)];
    [self.firstArr addObject:@(EpProfileCellType_commpany)];
    [self.firstArr addObject:@(EpProfileCellType_shortCommpany)];
    [self.firstArr addObject:@(EpProfileCellType_summary)];
    self.secondArr = [NSMutableArray array];
    self.thirdArr = [NSMutableArray array];
}

- (void)setupViews{
    // topview
    EpProfileHeadeView *topView = [[EpProfileHeadeView alloc] init];
    topView.delegate = self;
    _topView = topView;
    [self.view addSubview:topView];
    self.topViewHeight = 188.0f;
    self.scrollViewHeight = self.view.height - 64 - self.topViewHeight;
    [topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.view);
        make.height.equalTo(@(self.topViewHeight));
    }];
    
    [self.scrollview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.topView.mas_bottom);
        make.left.bottom.right.equalTo(self.view);
    }];
    
    if (self.isLookForJK) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setTitle:@"+加关注" forState:UIControlStateNormal];
        [button setTitleColor:[UIColor XSJColor_tGrayDeepTinge] forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:15.0f];
        [button addTarget:self action:@selector(borBtnOnClick:) forControlEvents:UIControlEventTouchUpInside];
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.equalTo(self.view);
            make.height.equalTo(@49);
        }];
    }else{
        NSAssert(self.epModel, @"雇主视角请为epModel赋值!!");
        [self.topView setEpModel:_epModel];
//        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"编辑" style:UIBarButtonItemStylePlain target:self action:@selector(editAction)];
    }
    self.indexTableView.hidden = NO;
    [self.indexTableView registerNib:nib(@"EpProfileCell") forCellReuseIdentifier:@"EpProfileCell"];
    [self.indexTableView registerNib:nib(@"EpProfileCell_summary") forCellReuseIdentifier:@"EpProfileCell_summary"];
}

#pragma mark - uitableview datasource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    switch (tableView.tag) {
        case TableViewTag:{
            return self.firstArr.count;
        }
        case TableViewTag + 1:{
            return self.secondArr.count;
        }
        case TableViewTag + 2:{
            return self.thirdArr.count;
        }
        default:
            break;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView.tag == TableViewTag) {
        EpProfileCellType cellType = [[self.firstArr objectAtIndex:indexPath.row] integerValue];
        switch (cellType) {
            case EpProfileCellType_hireCity:
            case EpProfileCellType_industry:
            case EpProfileCellType_commpany:
            case EpProfileCellType_shortCommpany:{
                EpProfileCell *cell = [tableView dequeueReusableCellWithIdentifier:@"EpProfileCell" forIndexPath:indexPath];
                cell.delegate = self;
                [cell setEpModel:_epModel cellType:cellType];
                return cell;
            }
            case EpProfileCellType_summary:{
                EpProfileCell_summary *cell = [tableView dequeueReusableCellWithIdentifier:@"EpProfileCell_summary" forIndexPath:indexPath];
                [cell setModel:self.epModel];
                return cell;
            }
        }
    }else if (tableView.tag == TableViewTag + 1){
        JobExpressCell* cell = [JobExpressCell cellWithTableView:tableView];
        JobModel* model = self.secondArr[indexPath.row];
        cell.isFromEpProfile = YES;
        cell.indexPath = indexPath;
        [cell refreshWithData:model];
        cell.selectedBackgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"v210_pressed_background"]];
        return cell;
    }else if (tableView.tag == TableViewTag + 2){
        EprofileCaseCell *cell = [tableView dequeueReusableCellWithIdentifier:@"EprofileCaseCell" forIndexPath:indexPath];
        ServiceTeamApplyModel *model = [self.thirdArr objectAtIndex:indexPath.row];
        [cell setModel:model];
        return cell;
    }
    
    return nil;
}

#pragma mark - uitableview delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView.tag == TableViewTag) {
        EpProfileCellType cellType = [[self.firstArr objectAtIndex:indexPath.row] integerValue];
        switch (cellType) {
            case EpProfileCellType_commpany:
            case EpProfileCellType_shortCommpany:
            case EpProfileCellType_industry:
            case EpProfileCellType_hireCity:
                return 49.0f;
            case EpProfileCellType_summary:{
                return self.epModel.cellHeight;
            }
        }
        
    }else if (tableView.tag == TableViewTag + 1){
        return 94.0f;
    }else if (tableView.tag == TableViewTag + 2){
        return 49.0f;
    }
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    if (tableView.tag == TableViewTag +1 && self.secondArr.count >= 5) {
        UIView *view = [[UIView alloc] init];
        
        UIButton *button = [UIButton buttonWithTitle:@"查看更多 >" bgColor:[UIColor XSJColor_grayTinge] image:nil target:self sector:@selector(viewMoreAction:)];
        [button setTitleColor:[UIColor XSJColor_tGrayDeepTinge] forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:16.0f];
        [view addSubview:button];
        
        UIView *line = [[UIView alloc] init];
        line.backgroundColor = [UIColor XSJColor_clipLineGray];
        [view addSubview:line];
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.equalTo(view);
            make.height.equalTo(@0.7);
        }];
        
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(view);
        }];
        return view;
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (tableView.tag == TableViewTag + 1 && self.secondArr.count >= 5) {
        return 44.0f;
    }
    return 0.1f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.1f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    switch (tableView.tag) {
        case TableViewTag:{
//            if (indexPath.row == 2) {
//                clickNum ++;
//                if (clickNum == 3) {
//                    NSDictionary *userInfo = [WDUserDefaults objectForKey:@"jiguangtuisong"];
//                    [NSString stringWithFormat:@"flg:%@ **** url:%@", [userInfo objectForKey:@"flg"], [userInfo objectForKey:@"url"]];
//                    [MKAlertView alertWithTitle:@"提示" message:[NSString stringWithFormat:@"flg:%@ **** url:%@ **** %@", [userInfo objectForKey:@"flg"], [userInfo objectForKey:@"url"], userInfo] cancelButtonTitle:@"11" confirmButtonTitle:@"22" completion:^(UIAlertView *alertView, NSInteger buttonIndex) {
//                        
//                    }];
//                
//                    clickNum = 0;
//                }
//            }
        }
            break;
        case TableViewTag + 1:{
            clickNum = 0;
            DLog(@"跳转到岗位详情");
            JobModel *jobModel = [self.secondArr objectAtIndex:indexPath.row];
            JobDetail_VC* vc = [[JobDetail_VC alloc] init];
            vc.jobId = jobModel.job_id.description;
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case TableViewTag + 2:{
            clickNum = 0;
            ServiceTeamApplyModel *model = [self.thirdArr objectAtIndex:indexPath.row];
            WebView_VC *viewCtrl = [[WebView_VC alloc] init];
            NSString *url = [NSString stringWithFormat:@"%@%@%@", URL_HttpServer, KUrl_toTeamApplyCaseListPage, model.id];
            viewCtrl.url = url;
            [self.navigationController pushViewController:viewCtrl animated:YES];
        }
            break;
        default:
            break;
    }
}

#pragma mark - uiscrollview delegate

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    if (scrollView.tag == 669) {
        NSInteger page = scrollView.contentOffset.x / SCREEN_WIDTH;
        [self.scrollview setContentOffset:CGPointMake(SCREEN_WIDTH * page, 0) animated:YES];
        [self.topView updateBtnStatusAtIndex:page];
        switch (page) {
            case 0:{
//                if (!_indexTableView) {
//                    [self.indexTableView.header beginRefreshing];
//                }
            }
                break;
            case 1:{
                if (!_jobTableView) {
                    [self.jobTableView.header beginRefreshing];
                }
            }
                break;
            case 2:{
                if (!_caseTableView) {
                    [self.caseTableView.header beginRefreshing];
                }
            }
                break;
            default:
                break;
        }
    }
}

#pragma mark - epProfileHeadeView delegate

- (void)epProfileHeadeView:(EpProfileHeadeView *)headerView actionType:(BtnOnClickActionType)actionType{
    switch (actionType) {
        case BtnOnClickActionType_epInfoIndex:{
//            if (!_indexTableView) {
//                [self.indexTableView.header beginRefreshing];
//            }
            [self.scrollview setContentOffset:CGPointMake(0, 0) animated:NO];
        }
            break;
        case BtnOnClickActionType_epInfoJob:{
            if (!_jobTableView) {
                [self.jobTableView.header beginRefreshing];
            }
            [self.scrollview setContentOffset:CGPointMake(SCREEN_WIDTH, 0) animated:NO];
        }
            break;
        case BtnOnClickActionType_epInfoCase:{
            if (!_caseTableView) {
                [self.caseTableView.header beginRefreshing];
            }
            [self.scrollview setContentOffset:CGPointMake(SCREEN_WIDTH * 2, 0) animated:NO];
        }
            break;
        default:
            break;
    }
}

- (void)viewHeadImg:(UIImageView *)imageView{
    if (imageView) {
        [PictureBrowser showImage:imageView];
    }
}

#pragma mark - EpProfileCellDelegate

- (void)EpProfileCell:(EpProfileCell *)cell rightBtnActionType:(EpProfileCellType)actionType{
    switch (actionType) {
        case EpProfileCellType_commpany:{
            EPVerity_VC *vc=[[EPVerity_VC alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case EpProfileCellType_hireCity:{
            [self editAction];
        }
            break;
        default:
            break;
    }
}

#pragma mark - 网络请求

- (void)getJobList{
    WEAKSELF
    NSString* content;
    GetEnterpriscJobModel *reqModel = [[GetEnterpriscJobModel alloc] init];
    reqModel.query_type = @(7);
    QueryParamModel *queryParam = [[QueryParamModel alloc] init];
    queryParam.page_size = @5;
    reqModel.query_param = queryParam;
    content = [reqModel getContent];
    
    RequestInfo* request = [[RequestInfo alloc] initWithService:@"shijianke_getEnterpriseSelfJobList_v2" andContent:content];
    [request sendRequestWithResponseBlock:^(ResponseInfo* response) {
        [weakSelf.jobTableView.header endRefreshing];
        if (response && response.success) {
            NSArray *array = [JobModel objectArrayWithKeyValuesArray:[response.content objectForKey:@"job_list"]];
            if (array.count) {
                weakSelf.secondArr = [array mutableCopy];
                weakSelf.jobTableViewWithNoData.hidden = YES;
                [weakSelf.jobTableView reloadData];
            }else{
                weakSelf.jobTableViewWithNoData.hidden = NO;
            }
        }
    }];
}

- (void)getServiceList{
    WEAKSELF
    [[XSJRequestHelper sharedInstance] queryServiceTeamApplyListWithEntID:self.entId status:@(2) block:^(ResponseInfo *response) {
        [weakSelf.caseTableView.header endRefreshing];
        if (response) {
            NSArray *array = [ServiceTeamApplyModel objectArrayWithKeyValuesArray:[response.content objectForKey:@"service_team_apply_list"]];
            if (array.count) {
                weakSelf.caseTableViewWithNoData.hidden = YES;
                weakSelf.thirdArr = [array mutableCopy];
                [weakSelf.caseTableView reloadData];
            }else{
                weakSelf.caseTableViewWithNoData.hidden = NO;
            }
        }
    }];
}

#pragma mark - 按钮事件

- (void)borBtnOnClick:(UIButton *)sender{
    ELog(@"加关注");
}

- (void)viewMoreAction:(UIButton *)sender{
    ELog(@"查看更多岗位");
    EpPostedJobList_VC *viewCtrl = [[EpPostedJobList_VC alloc] init];
    [self.navigationController pushViewController:viewCtrl animated:YES];
}

- (void)editAction{
    [TalkingData trackEvent:@"雇主信息_编辑"];
    EditEmployerInfo_VC* vc = [[EditEmployerInfo_VC alloc] init];
    vc.epModel = [NSKeyedUnarchiver unarchiveObjectWithData:[NSKeyedArchiver archivedDataWithRootObject:self.epModel]];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - 懒加载

- (UITableView *)indexTableView{
    if (!_indexTableView) {
        UITableView *tableView = [UIHelper createTableViewWithStyle:UITableViewStylePlain delegate:self onView:self.scrollview];
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        tableView.backgroundColor = [UIColor whiteColor];
        tableView.tag = TableViewTag;
        _indexTableView = tableView;
        tableView.frame = CGRectMake(0, 0, SCREEN_WIDTH, self.scrollViewHeight);
    }
    return _indexTableView;
}

- (UITableView *)jobTableView{
    if (!_jobTableView) {
        UITableView *tableView = [UIHelper createTableViewWithStyle:UITableViewStyleGrouped delegate:self onView:self.scrollview];
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        tableView.backgroundColor = [UIColor whiteColor];
        tableView.tag = TableViewTag + 1;
        _jobTableView = tableView;
        tableView.frame = CGRectMake(SCREEN_WIDTH, 0, SCREEN_WIDTH, self.scrollViewHeight);
        self.jobTableViewWithNoData = [UIHelper noDataViewWithTitle:@"暂无已发布的岗位" titleColor:nil image:@"v3_public_nodata" button:nil];
        [tableView addSubview:self.jobTableViewWithNoData];
        self.jobTableViewWithNoData.frame = CGRectMake(0, 80, self.view.size.width, self.view.size.height);
        self.jobTableViewWithNoData.hidden = YES;
        tableView.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            [self getJobList];
        }];
    }
    return _jobTableView;
}

- (UITableView *)caseTableView{
    if (!_caseTableView) {
        UITableView *tableView = [UIHelper createTableViewWithStyle:UITableViewStylePlain delegate:self onView:self.scrollview];
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        tableView.backgroundColor = [UIColor whiteColor];
        tableView.tag = TableViewTag + 2;
        _caseTableView = tableView;
        tableView.frame = CGRectMake(SCREEN_WIDTH * 2, 0, SCREEN_WIDTH, self.scrollViewHeight);
        self.caseTableViewWithNoData = [UIHelper noDataViewWithTitle:@"暂无相关案例" titleColor:nil image:@"v3_public_nodata" button:nil];
        [tableView addSubview:self.caseTableViewWithNoData];
        self.caseTableViewWithNoData.frame = CGRectMake(0, 20, self.view.size.width, self.view.size.height);
        self.caseTableViewWithNoData.hidden = YES;
        tableView.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            [self getServiceList];
        }];
        [tableView registerNib:nib(@"EprofileCaseCell") forCellReuseIdentifier:@"EprofileCaseCell"];
    }
    return _caseTableView;
}

- (UIScrollView *)scrollview{
    if (!_scrollview) {
        UIScrollView *scrollView = [[UIScrollView alloc] init];
        scrollView.contentSize = CGSizeMake(SCREEN_WIDTH * 2 , self.scrollViewHeight);
        scrollView.delegate = self;
        scrollView.tag = 669;
        scrollView.pagingEnabled = YES;
        scrollView.showsHorizontalScrollIndicator = NO;
        _scrollview = scrollView;
        [self.view addSubview:scrollView];
        
    }
    return _scrollview;
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
