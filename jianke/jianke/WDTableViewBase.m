//
//  WDTableViewBase.m
//  jianke
//
//  Created by xiaomk on 15/9/9.
//  Copyright (c) 2015年 xianshijian. All rights reserved.
//

#import "WDTableViewBase.h"
#import "WDConst.h"
#import "ParamModel.h"
#import "JobModel.h"
#import "DataBaseTool.h"


@interface WDTableViewBase(){
    BOOL _init;
    BOOL _isGetLast;
    BOOL _isFirst;
}

@end

@implementation WDTableViewBase

- (void)viewDidAppear{
    if (!_init) {
        _init = YES;
        if ((_refreshType & WdTableViewRefreshTypeHeader) == WdTableViewRefreshTypeHeader) {
            [self.tableView.header beginRefreshing];
            
        }
    }
}

- (instancetype)init{
    self = [super init];
    if (self) {
        _isGetLast = NO;
        self.requestParam = [[RequestParamWrapper alloc]init];
        self.requestParam.queryParam = [[QueryParamModel alloc] init];
        self.requestParam.queryParam.page_size = [NSNumber numberWithInt:30];
        
        _refreshType = WdTableViewRefreshTypeNone;
        self.arrayData = [[NSMutableArray alloc] init];
        
        _isFirst = YES;
        ELog("===========WDTableViewBase init ok")
    }
    return self;
}

- (void)setTableView:(UITableView *)tableView{
    _tableView = tableView;
    tableView.delegate = self;
    tableView.dataSource = self;

    // 无数据
    NSString* str;
    if (self.isInvitingForJob) {
        str = @"您还没有发布任何岗位，请点击右上角的{+}按钮进行发布";
        
    }else{
        str = @"没有数据，请下拉刷新";
    }
    
    self.noDataView = [UIHelper noDataViewWithTitle:str image:@"v3_public_nodata"];
    [self.tableView addSubview:self.noDataView];
    self.noDataView.frame = CGRectMake(0, 80, self.noDataView.size.width, self.noDataView.size.height);
    self.noDataView.hidden = YES;
    
    //无信号
    self.noSignalView = [UIHelper noDataViewWithTitle:@"啊噢,网络不见了" image:@"v3_public_nowifi"];
    [self.tableView addSubview:self.noSignalView];
    self.noSignalView.frame = CGRectMake(0, 80, self.noDataView.size.width, self.noDataView.size.height);
    self.noSignalView.hidden = YES;
}

- (void)setRefreshType:(WDTableViewRefreshType)refreshType{
    _refreshType = refreshType;
    NSAssert(self.tableView, @"tableView 未指定");
    if (self.isInvitingForJob) {
        if (![[UserData sharedInstance] isLogin]) {
            return;
        }
    }
    
    if ((refreshType & WdTableViewRefreshTypeHeader) == WdTableViewRefreshTypeHeader) {
        self.tableView.header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(showLatest)];
        if (self.isJKHomeVC) {
            self.tableView.header.ignoredScrollViewContentInsetTop = 64;
        }
    }
    
    if ((refreshType & WdTableViewRefreshTypeFooter) == WdTableViewRefreshTypeFooter) {
        self.tableView.footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(showMore)];
//        self.tableView.footer.ignoredScrollViewContentInsetBottom = 80;
    }
}

- (void)reloadTableView{
    [self.tableView reloadData];
}

- (void)showLatest{
    _isGetLast = YES;
    self.requestParam.queryParam = nil;
    self.requestParam.queryParam = [[QueryParamModel alloc]init];
    self.requestParam.queryParam.page_size = [NSNumber numberWithInt:30];
    [self sendRequest];
}

- (void)showMore{
    _isGetLast = NO;
    [self sendRequest];
}

- (void)headerBeginRefreshing{
//    [self.tableView.header beginRefreshing];
    [self showLatest];
}

- (void)sendRequest{
    if (self.requestParam == nil) {
        NSAssert(NO, @"requestParam请求参数不存在");
        return;
    }
    
    RequestInfo* info = [[RequestInfo alloc] initWithService:self.requestParam.serviceName andContent:self.requestParam.content];
    info.isShowLoading = NO;
    WEAKSELF
    [info sendRequestWithResponseBlock:^(ResponseInfo* response) {
        if (response && [response success]) {
            weakSelf.noDataView.hidden = YES;
            weakSelf.noSignalView.hidden = YES;
            
            NSDictionary* query_param = [response.content objectForKey:@"query_param"];
            if (query_param) {
                weakSelf.requestParam.queryParam = [QueryParamModel objectWithKeyValues:query_param];
                weakSelf.requestParam.queryParam.page_num = @(weakSelf.requestParam.queryParam.page_num.intValue + 1);
            }
            
            NSArray* dataList = [response.content objectForKey:weakSelf.requestParam.arrayName];
            if (dataList == nil) {
                NSAssert(dataList,@"======self.requestParam.arrayName=%@,response.content=%@",self.requestParam.arrayName, response.content);
            }
            
            if (_isGetLast) {
                [weakSelf.arrayData removeAllObjects];
            }
            
            if (dataList.count < 1) {
                weakSelf.tableView.footer.state = MJRefreshStateNoMoreData;

                if (weakSelf.arrayData.count > 0) {
                    if (weakSelf.showNoDataView) {
                        weakSelf.noDataView.hidden = YES;
                    }
                }else{
                    if (weakSelf.showNoDataView) {
                        weakSelf.noDataView.hidden = NO;
                    }
                }
                [weakSelf.tableView reloadData];
            
                [weakSelf scrollToTop];
                // 请求结束回调方法
                if ([weakSelf.delegate respondsToSelector:@selector(requestDidFinish:)]) {
                    [weakSelf.delegate requestDidFinish:(weakSelf.arrayData)];
                }
                [weakSelf.tableView.header endRefreshing];
                return;
            }
            
            NSArray *readedJobIdArray = [DataBaseTool readedJobIdArray];
            for (NSDictionary* data in dataList) {
                id obj = [weakSelf.requestParam.typeClass objectWithKeyValues:data];                
                // 设置岗位已读/未读状态
                if ([obj isKindOfClass:[JobModel class]]) {
                    [obj checkReadStateWithReadedJobIdArray:readedJobIdArray];
                }
                
                [weakSelf.arrayData addObject:obj];
            }

            //保存数据到本地 做无网络显示
            if (weakSelf.arrayData.count > 0 && _isGetLast) {
                [[UserData sharedInstance] saveHomeJobListWithArray:weakSelf.arrayData];
            }
            
            if (_isGetLast && self.isJKHomeVC && self.arrayData.count >= 10) {
                if ([XSJADHelper getAdIsShowWithType:XSJADType_homeJobList]) {
                    JobModel *adModel = [[JobModel alloc] init];
                    adModel.isSSPAd = YES;
                    [self.arrayData insertObject:adModel atIndex:10];
                }
            }

            [weakSelf.tableView reloadData];
            [weakSelf scrollToTop];

        }else{
            //失败也要回调
            if (!weakSelf.arrayData || weakSelf.arrayData.count <= 0) {
                NSArray* jobAry = [[UserData sharedInstance] getHomeJobList];
                if (jobAry && jobAry.count > 0) {
                    weakSelf.arrayData = [[NSMutableArray alloc] initWithArray:jobAry];
                }
                
                JobModel *adModel = [[JobModel alloc] init];
                adModel.isSSPAd = YES;
                [self.arrayData insertObject:adModel atIndex:10];
            }
            
            [weakSelf.tableView reloadData];
            [weakSelf scrollToTop];
            
            weakSelf.noDataView.hidden = YES;
            if (weakSelf.arrayData.count > 0) {
                weakSelf.noSignalView.hidden = YES;
            }else{
                weakSelf.noSignalView.hidden = NO;
            }
        }
        // 请求结束回调方法
        if ([weakSelf.delegate respondsToSelector:@selector(requestDidFinish:)]) {
            [weakSelf.delegate requestDidFinish:(weakSelf.arrayData)];
        }
        [weakSelf.tableView.footer endRefreshing];
        [weakSelf.tableView.header endRefreshing];
    }];
}


- (void)scrollToTop{
    if (_isGetLast && _isFirst && self.isJKHomeVC) {
        _isFirst = NO;
        [self.tableView setContentOffset:CGPointMake(0,-64) animated:YES];
    }
}

#pragma mark - TableView Delegate
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSAssert(NO, @"这个方法必须要实现...");
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
//    DLog(@"=====> %@", NSStringFromCGRect(self.tableView.frame));
//    DLog(@"=====> %@", NSStringFromUIEdgeInsets(self.tableView.contentInset));
    
    return self.arrayData ? self.arrayData.count : 0;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [[UIApplication sharedApplication] sendAction:@selector(resignFirstResponder) to:nil from:nil forEvent:nil];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //取消选中
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

//处理下面多余的线
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.1;
}


@end
