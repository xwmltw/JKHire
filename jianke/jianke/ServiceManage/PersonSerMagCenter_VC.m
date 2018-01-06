//
//  PersonSerMagCenter_VC.m
//  JKHire
//
//  Created by fire on 16/10/19.
//  Copyright © 2016年 xianshijian. All rights reserved.
//

#import "PersonSerMagCenter_VC.h"
#import "PersonalList_VC.h"
#import "PersonServiceDetail_VC.h"
#import "PaySelect_VC.h"
#import "WebView_VC.h"

#import "PersonSmcHeaderView.h"
#import "PersonSmcCell.h"

#import "PersonServiceModel.h"

@interface PersonSerMagCenter_VC () <PersonSmcHeaderViewDelegate, PersonSmcCellDelegate>

@property (nonatomic, weak) PersonSmcHeaderView *headerView;
@property (nonatomic, weak) UIScrollView *scrollView;
@property (nonatomic, weak) UITableView *firstTableView;
@property (nonatomic, weak) UITableView *subTableView;
@property (nonatomic, strong) UIView *firNoDataWithView;
@property (nonatomic, strong) UIView *secNoDataWithView;

@property (nonatomic, strong) NSMutableArray *firstArr;
@property (nonatomic, strong) NSMutableArray *secondArr;

@property (nonatomic, strong) QueryParamModel *firstParam;
@property (nonatomic, strong) QueryParamModel *secondParam;

@property (nonatomic, copy) NSNumber *service_personal_price;   /*!< 获取联系方式支付金额 */
@property (nonatomic, strong) PersonServiceModel *serviceDetailModel;

@property (nonatomic, assign) BOOL isRefreshFirTableView;
@property (nonatomic, assign) BOOL isRerefreshSecTableView;

@property (nonatomic, assign) BOOL isFirstPush;

@end

@implementation PersonSerMagCenter_VC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"个人服务管理";
    self.isFirstPush = YES;
    self.isRefreshFirTableView = YES;
    self.isRerefreshSecTableView = YES;
    self.firstArr = [NSMutableArray array];
    self.secondArr = [NSMutableArray array];
    self.firstParam = [[QueryParamModel alloc] init];
    self.secondParam = [[QueryParamModel alloc] init];
    [self setupViews];
    [self.firstTableView.header beginRefreshing];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"结束订单" style:UIBarButtonItemStylePlain target:self action:@selector(closeOrder)];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self getHeaderData];
    if (!self.isFirstPush) {
        [self getLastestData:1];
        [self getLastestData:2];
    }
    self.isFirstPush = NO;
}

- (void)setupViews{
    PersonSmcHeaderView *headerView = [[[NSBundle mainBundle] loadNibNamed:@"PersonSmcHeaderView" owner:nil options:nil] lastObject];
    headerView.delegate = self;
    _headerView = headerView;
    
    CGFloat headerViewHeight = (self.platform_invite_accept_num.integerValue) ? 258 : 209;
    CGFloat tableViewHeight = self.view.height - headerViewHeight - 64;
    CGFloat tableViewWidth = SCREEN_WIDTH;
    
    UIScrollView *scrollView = [[UIScrollView alloc] init];
    scrollView.delegate = self;
    scrollView.tag = 10;
    scrollView.pagingEnabled = YES;
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.showsVerticalScrollIndicator = NO;
    scrollView.contentSize = CGSizeMake(tableViewWidth, tableViewHeight);
    _scrollView = scrollView;
    
    
    [self.view addSubview:headerView];
    [self.view addSubview:scrollView];
    
    _firstTableView = [UIHelper createTableViewWithStyle:UITableViewStylePlain delegate:self onView:scrollView];
    _firstTableView.tag = 1;
    _firstTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.firNoDataWithView = [UIHelper noDataViewWithTitle:@"暂无已邀约数据" titleColor:nil image:@"v3_public_nodata"];
    self.firNoDataWithView.userInteractionEnabled = YES;
    self.firNoDataWithView.frame = CGRectMake(0, 80, self.firNoDataWithView.size.width, self.firNoDataWithView.size.height);
    self.firNoDataWithView.hidden = YES;
    [_firstTableView addSubview:self.firNoDataWithView];
    
    [self.headerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.view);
        make.height.equalTo(@(headerViewHeight));
    }];
    
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.headerView.mas_bottom);
        make.left.right.bottom.equalTo(self.view);
    }];
    
    self.firstTableView.frame = CGRectMake(0, 0, tableViewWidth, tableViewHeight);
    
    [self.firstTableView registerNib:nib(@"PersonSmcCell") forCellReuseIdentifier:@"PersonSmcCell"];
    
    if (self.platform_invite_accept_num.integerValue) {
        scrollView.contentSize = CGSizeMake(tableViewWidth * 2, tableViewHeight);
        self.subTableView.frame = CGRectMake(tableViewWidth, 0, tableViewWidth, tableViewHeight);
    }
    
    self.firstTableView.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self getLastestData:1];
        [self getHeaderData];
    }];
    
    self.firstTableView.footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [self getMoreData:1];
        [self getHeaderData];
    }];
}

- (void)updateHeaderView{
    CGFloat headerViewHeight = (self.platform_invite_accept_num.integerValue) ? 258 : 209;
    CGFloat tableViewHeight = self.view.height - headerViewHeight;
    CGFloat tableViewWidth = SCREEN_WIDTH;

    if (_scrollView) {
        _scrollView.contentSize = CGSizeMake(tableViewWidth, tableViewHeight);
    }

    [self.headerView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@(headerViewHeight));
    }];

    self.firstTableView.frame = CGRectMake(0, 0, tableViewWidth, tableViewHeight);
    
    if (self.platform_invite_accept_num.integerValue) {
        _scrollView.contentSize = CGSizeMake(tableViewWidth * 2, tableViewHeight);
        self.subTableView.frame = CGRectMake(tableViewWidth, 0, tableViewWidth, tableViewHeight);
    }

}

#pragma mark - lazy加载

- (UITableView *)subTableView{
    if (!_subTableView) {
        _subTableView = [UIHelper createTableViewWithStyle:UITableViewStylePlain delegate:self onView:self.scrollView];
        _subTableView.tag = 2;
        _subTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _subTableView.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            [self getLastestData:2];
        }];
        _subTableView.footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
            [self getMoreData:2];
        }];
       self.secNoDataWithView = [UIHelper noDataViewWithTitle:@"暂无平台推荐数据" titleColor:nil image:@"v3_public_nodata"];
        self.secNoDataWithView.hidden = YES;
        self.secNoDataWithView.userInteractionEnabled = YES;
        self.secNoDataWithView.frame = CGRectMake(0, 80, self.secNoDataWithView.size.width, self.secNoDataWithView.size.height);
        [_subTableView addSubview:self.secNoDataWithView];
        [_subTableView registerNib:nib(@"PersonSmcCell") forCellReuseIdentifier:@"PersonSmcCell"];
    }
    return _subTableView;
}

#pragma mark - 请求数据

- (void)getHeaderData{
    WEAKSELF
    [[XSJRequestHelper sharedInstance] getServicePersonalJobDetailWithJobId:self.service_personal_job_id isShowLoding:NO block:^(ResponseInfo *response) {
        if (response) {
            weakSelf.serviceDetailModel = [PersonServiceModel objectWithKeyValues:[response.content objectForKey:@"service_personal_job"]];
            weakSelf.platform_invite_accept_num = weakSelf.serviceDetailModel.platform_invite_accept_num;
            [weakSelf.headerView setModel:weakSelf.serviceDetailModel];
            [weakSelf updateHeaderView];
        }
    }];
}

- (void)getLastestData:(NSInteger)type{
    QueryParamModel *param;
    if (type == 1) {
        self.firstParam.page_num = @1;
        param = self.firstParam;
        self.isRefreshFirTableView = NO;
    }else{
        self.secondParam.page_num = @1;
        param = self.secondParam;
        self.isRerefreshSecTableView = NO;
    }
    WEAKSELF
    [[XSJRequestHelper sharedInstance] entQueryServicePersonalJobApplyListWithApplyType:@(type) jobId:self.service_personal_job_id queryParam:param isShowLoding:NO block:^(ResponseInfo *response){
        [self.firstTableView.header endRefreshing];
        if (type == 2) {
            [self.subTableView.header endRefreshing];
        }
        if (response) {
            NSArray *result = [ServicePersonalStuModel objectArrayWithKeyValuesArray:[response.content objectForKey:@"service_personal_job_apply_list"]];
            if (result.count) { //无数据情况还未处理 记得要处理哦~~
                weakSelf.service_personal_price = [response.content objectForKey:@"service_personal_price"];
                [weakSelf dealResultWithApplyType:type withResult:result];
            }else{
                if (type == 1) {
                    self.firNoDataWithView.hidden = NO;
                }else if (type == 2){
                    self.secNoDataWithView.hidden = NO;
                }
            }
        }
    }];
}

- (void)dealResultWithApplyType:(NSInteger)applyType withResult:(NSArray *)array{
    if (applyType == 1) {
        self.firNoDataWithView.hidden = YES;
        self.firstArr = [array mutableCopy];
        self.firstParam.page_num = @2;
        [self.firstTableView reloadData];
    }else if (applyType == 2){
        self.secNoDataWithView.hidden = YES;
        self.secondArr = [array mutableCopy];
        self.secondParam.page_num = @2;
        [self.subTableView reloadData];
    }
}

- (void)getMoreData:(NSInteger)type{
    QueryParamModel *param;
    if (type == 1) {
        param = self.firstParam;
    }else{
        param = self.secondParam;
    }
    WEAKSELF
    [[XSJRequestHelper sharedInstance] entQueryServicePersonalJobApplyListWithApplyType:@(type) jobId:self.service_personal_job_id queryParam:param isShowLoding:NO block:^(ResponseInfo *response) {
        [self.firstTableView.footer endRefreshing];
        if (type == 2) {
            [self.subTableView.footer endRefreshing];
        }
        if (response) {
            NSArray *result = [ServicePersonalStuModel objectArrayWithKeyValuesArray:[response.content objectForKey:@"service_personal_job_apply_list"]];
            if (result.count) { //无数据情况还未处理 记得要处理哦~~
                [weakSelf dealMoreResultWithApplyType:type withResult:result];
            }
        }

    }];
}

- (void)dealMoreResultWithApplyType:(NSInteger)type withResult:(NSArray *)result{
    if (type == 1) {
        [self.firstArr addObject:result];
        [self.firstTableView reloadData];
    }else{
        [self.secondArr addObject:result];
        [self.subTableView reloadData];
    }
}

#pragma mark - uitableview datasource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView.tag == 1) {
        return self.firstArr.count;
    }else if (tableView.tag == 2){
        return self.secondArr.count;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    PersonSmcCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PersonSmcCell" forIndexPath:indexPath];
    cell.delegate = self;
    if (tableView.tag == 1) {   //已邀约的tableView
        ServicePersonalStuModel *model = [self.firstArr objectAtIndex:indexPath.row];
        [cell setModel:model withServiceType:self.service_type];
    }else if (tableView.tag == 2){  //平台推荐的tableView
        ServicePersonalStuModel *model = [self.secondArr objectAtIndex:indexPath.row];
        [cell setModel:model withServiceType:self.service_type];
    }
    return cell;
}

#pragma mark - uitableview delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 84.0f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    ELog(@"进入个人需求详情页");
    ServicePersonalStuModel *model;
    if (tableView.tag == 1) {
        model = [self.firstArr objectAtIndex:indexPath.row];
    }else{
        model = [self.secondArr objectAtIndex:indexPath.row];
    }
    
    WebView_VC *viewCtrl = [[WebView_VC alloc] init];
    viewCtrl.popViewCtrl = self;
    NSString *url = [NSString stringWithFormat:@"%@%@?service_type=%@&stu_account_id=%@", URL_HttpServer, KUrl_ServicePersonalDetail, self.serviceDetailModel.service_type, model.stu_account_id];
    url = (self.service_personal_job_id) ? [url stringByAppendingFormat:@"&service_personal_job_id=%@", self.service_personal_job_id] : url ;
    viewCtrl.url = url;
    viewCtrl.uiType = WebViewUIType_PersonalServiceDetail;
    WEAKSELF
    viewCtrl.competeBlock = ^(id result){
        [weakSelf.navigationController popToViewController:weakSelf animated:NO];
        WebView_VC *viewCtrl = [[WebView_VC alloc] init];
        NSString *url = [NSString stringWithFormat:@"%@%@?service_type=%@&stu_account_id=%@", URL_HttpServer, KUrl_ServicePersonalDetail, self.serviceDetailModel.service_type, model.stu_account_id];
        url = (weakSelf.service_personal_job_id) ? [url stringByAppendingFormat:@"&service_personal_job_id=%@", weakSelf.service_personal_job_id] : url ;
        viewCtrl.url = url;
        viewCtrl.uiType = WebViewUIType_PersonalServiceDetail;
        [weakSelf.navigationController pushViewController:viewCtrl animated:YES];
    };
    
    [self.navigationController pushViewController:viewCtrl animated:YES];
}

#pragma mark - uiscrollview delegate

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    if (scrollView.tag == 10) {
        CGFloat offset = scrollView.contentOffset.x;
        NSInteger page = offset / SCREEN_WIDTH;
        [self.headerView setBottomLineHorizoneOffset:SCREEN_WIDTH / 2 * page];
        [self makeTableViewRefreshWithPage:page];
        [self.headerView makeBtnSelectedStatus:(offset == 0) ? PersonSmcBtnActionType_sliderLeftBtnOnClick : PersonSmcBtnActionType_sliderRightBtnOnClick];
    }
}

#pragma mark - PersonSmcHeaderViewDelegate

- (void)btnOnClickWithActionType:(PersonSmcBtnActionType)actionType{
    switch (actionType) {
        case PersonSmcBtnActionType_titleOnClick:{
            ELog(@"进入个人服务需求详情页");
            PersonServiceDetail_VC *viewCtrl = [[PersonServiceDetail_VC alloc] init];
            viewCtrl.block = self.block;
            viewCtrl.service_personal_job_id = self.service_personal_job_id;
            [self.navigationController pushViewController:viewCtrl animated:YES];
        }
            break;
        case PersonSmcBtnActionType_inviteOnClick:{ //继续邀约
            ELog(@"进入个人服务商列表");
            PersonalList_VC *viewCtrl = [[PersonalList_VC alloc] init];
            viewCtrl.block = self.block;
            viewCtrl.service_personal_job_id = self.service_personal_job_id;
            viewCtrl.servicePersonType = [self.serviceDetailModel getServiceTypeEnum];
            viewCtrl.sourceType = ViewSourceType_PersonManage;
            viewCtrl.isPopToPrevious = YES;
            [self.navigationController pushViewController:viewCtrl animated:YES];
        }
            break;
        case PersonSmcBtnActionType_sliderLeftBtnOnClick:{
            [self makeTableViewRefreshWithPage:0];
            [self.scrollView setContentOffset:CGPointMake(0, 0) animated:NO];
        }
            break;
        case PersonSmcBtnActionType_sliderRightBtnOnClick:{
            [self makeTableViewRefreshWithPage:1];
            [self.scrollView setContentOffset:CGPointMake(SCREEN_WIDTH, 0) animated:NO];
        }
            break;
        default:
            break;
    }
}

#pragma mark  - PersonSmcCellDelegate

- (void)btnOnClickWithActionType:(BtnOnClickActionType)actionType withModel:(ServicePersonalStuModel *)model{
    switch (actionType) {
        case BtnOnClickActionType_payForPhoneNum:{  //获取联系方式 跳转支付
            [self pushToPaySelectWithModel:model];
        }
            break;
        case BtnOnClickActionType_makeCall:{    //拨打电话
            
            [[MKOpenUrlHelper sharedInstance] makeAlertCallWithPhone:model.contact_telephone.description block:^(id result) {

            }];
        }
            break;
        case BtnOnClickActionType_confirmContact:{  //确认沟通
            WEAKSELF
            [MKAlertView alertWithTitle:nil message:@"是否已电话联系对方?" cancelButtonTitle:@"已联系" confirmButtonTitle:@"未联系" completion:^(UIAlertView *alertView, NSInteger buttonIndex) {
                if (buttonIndex == 0) {
                    [[XSJRequestHelper sharedInstance] entContactWithStuWithApplyId:model.service_personal_job_apply_id block:^(id result) {
                        if (result) {
                            model.apply_status = @6;
                            [weakSelf.firstTableView reloadData];
                            if (_subTableView) {
                                [weakSelf.subTableView reloadData];
                            }
                        }
                    }];
                }
            }];
        }
            break;
        default:
            break;
    }
}

#pragma mark - 自定义方法

- (void)makeTableViewRefreshWithPage:(NSInteger)page{
    if (page == 0) {
        if (self.isRefreshFirTableView) {
            [self.firstTableView.header beginRefreshing];
            self.isRefreshFirTableView = NO;
        }
    }else if (page == 1){
        if (self.isRerefreshSecTableView) {
            [self.subTableView.header beginRefreshing];
            self.isRerefreshSecTableView = NO;
        }
    }
}

- (void)pushToPaySelectWithModel:(ServicePersonalStuModel *)model{
    WEAKSELF
    NSString *message = [NSString stringWithFormat:@"%@将资料托付在兼客平台,你需要为获取联系方式支付%.2f元", model.true_name, self.service_personal_price.floatValue * 0.01];
    [MKAlertView alertWithTitle:nil message:message cancelButtonTitle:@"暂不招聘" confirmButtonTitle:@"去支付" completion:^(UIAlertView *alertView, NSInteger buttonIndex) {
        if (buttonIndex == 1) {
            [[XSJRequestHelper sharedInstance] entRechargeServicePersonalWithJobApplyId:model.service_personal_job_apply_id block:^(ResponseInfo *result) {
                if (result) {
                    PaySelect_VC *viewCtrl = [[PaySelect_VC alloc] init];
                    viewCtrl.service_personal_order_id = [result.content objectForKey:@"service_personal_order_id"];
                    viewCtrl.needPayMoney = weakSelf.service_personal_price.intValue;
                    viewCtrl.fromType = PaySelectFromType_ServicePersonalOrder;
                    viewCtrl.updateDataBlock = ^(id result){
                        [weakSelf.navigationController popToViewController:weakSelf animated:NO];
                        WebView_VC *viewCtrl = [[WebView_VC alloc] init];
                        NSString *url = [NSString stringWithFormat:@"%@%@?service_type=%@&stu_account_id=%@", URL_HttpServer, KUrl_ServicePersonalDetail, self.serviceDetailModel.service_type, model.stu_account_id];
                        url = (weakSelf.service_personal_job_id) ? [url stringByAppendingFormat:@"&service_personal_job_id=%@", weakSelf.service_personal_job_id] : url ;
                        viewCtrl.url = url;
                        viewCtrl.uiType = WebViewUIType_PersonalServiceDetail;
                        [weakSelf.navigationController pushViewController:viewCtrl animated:YES];
                    };
                    [weakSelf.navigationController pushViewController:viewCtrl animated:YES];
                }
            }];
        }
    }];
    
}

- (void)closeOrder{
    if (self.service_personal_job_id) {
        WEAKSELF
        [MKAlertView alertWithTitle:nil message:@"结束个人服务需求？" cancelButtonTitle:@"取消" confirmButtonTitle:@"结束" completion:^(UIAlertView *alertView, NSInteger buttonIndex) {
            if (buttonIndex == 1) {
                [[XSJRequestHelper sharedInstance] entCloseServicePersonalJobWithJobId:weakSelf.service_personal_job_id block:^(id result) {
                    if (result) {
                        [UIHelper toast:@"已结束"];
                        [weakSelf getLastestData:1];
                        [weakSelf getLastestData:2];
                        MKBlockExec(weakSelf.block, nil);
//                        [weakSelf.navigationController popViewControllerAnimated:YES];
                        
                    }
                }];
            }
        }];
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
