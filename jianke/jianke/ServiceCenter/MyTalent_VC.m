//
//  MyTalent_VC.m
//  JKHire
//
//  Created by yanqb on 2017/5/31.
//  Copyright © 2017年 xianshijian. All rights reserved.
//

#import "MyTalent_VC.h"
#import "BuyResume_VC.h"
#import "LookupResume_VC.h"
#import "WDChatView_VC.h"
#import "MyTalentHeaderView.h"
#import "MyTalentToolBar.h"
#import "PostJobSuccess_Cell1.h"
#import "WQLPaoMaView.h"



@interface MyTalent_VC () <MyTalentToolBarDelegate, MyTalentHeaderViewDelegate, PostJobSuccess_Cell1Delegate>{
    BOOL _isFirst;
    
}

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UITableView *leftTableView;
@property (nonatomic, strong) UITableView *rightTableView;
@property (nonatomic, strong) MyTalentHeaderView *headerView;
@property (nonatomic, strong) MyTalentToolBar *toolBar;

@property (nonatomic, strong) NSMutableArray *leftArray;
@property (nonatomic, strong) QueryParamModel *leftQueryParam;
@property (nonatomic, strong) UIView *leftNoDataView;
@property (nonatomic, strong) NSMutableArray *rightArray;
@property (nonatomic, strong) QueryParamModel *rightQueryParam;
@property (nonatomic, strong) UIView *rightNoDataView;
@property (nonatomic, strong) NSMutableArray *timeArray;
@property (nonatomic, strong) WQLPaoMaView *paoMaView;

@property (nonatomic, copy) NSNumber *left_resume_num;  //剩余简历数

@end



@implementation MyTalent_VC

static CGFloat paoMaViewHeight = 1;



- (void)viewDidLoad {
    [super viewDidLoad];
    _isFirst = YES;
    [TalkingData trackEvent:@"人才库_我的人才"];
    self.leftArray = [NSMutableArray array];
    self.rightArray = [NSMutableArray array];
    self.leftQueryParam = [[QueryParamModel alloc] init];
    self.rightQueryParam = [[QueryParamModel alloc] init];

    [self getData];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (!_isFirst) {
        _isFirst = NO;
        if ([UserData sharedInstance].isUpdateMyConactedReume) {
            [UserData sharedInstance].isUpdateMyConactedReume = NO;
            [self getDataForContact];
        }
        if ([UserData sharedInstance].isUpdateMyCollectedJK) {
            [UserData sharedInstance].isUpdateMyCollectedJK = NO;
            if (_rightTableView) {
                [self getDataForCollect];
            }
        }
    }else{
        _isFirst = NO;
    }
}

- (void)setupViews{
    self.headerView = [[MyTalentHeaderView alloc] init];
    self.headerView.delegate = self;
    self.toolBar = [[MyTalentToolBar alloc] init];
    self.toolBar.delegate = self;
    self.scrollView = [[UIScrollView alloc] init];
    self.scrollView.tag = 10010;
    self.scrollView.delegate = self;
    self.scrollView.pagingEnabled = YES;
    self.scrollView.showsVerticalScrollIndicator = NO;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    
    if (self.timeArray.count > 0) {
        paoMaViewHeight = (50*SCREEN_HEIGHT)/667;
    }
    
    self.paoMaView = [[WQLPaoMaView alloc]initWithFrame:CGRectMake(0, 57, SCREEN_WIDTH, paoMaViewHeight) withTitle:[self getSoonExpired]];
    UIView *line = [[UIView alloc]init];
    line.backgroundColor = MKCOLOR_RGB(233, 233, 235);
   
    [self.view addSubview:self.headerView];
    [self.view addSubview:self.toolBar];
    [self.view addSubview:self.scrollView];
    [self.view addSubview:self.paoMaView];
    [self.paoMaView addSubview:line];
    
    
   
    self.leftTableView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 107 - 64 - 49- paoMaViewHeight);
    self.headerView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 57);
    
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.paoMaView);
        make.height.mas_equalTo(1);
    }];
    
    [self.toolBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.paoMaView.mas_bottom);
        make.left.right.equalTo(self.view);
        make.height.equalTo(@50);
    }];
    
    self.scrollView.frame = CGRectMake(0, 107 + paoMaViewHeight, SCREEN_WIDTH, SCREEN_HEIGHT - 107 - 64 - paoMaViewHeight);
    self.scrollView.contentSize = CGSizeMake(SCREEN_WIDTH * 2, SCREEN_HEIGHT - 107 - 64 - paoMaViewHeight);
    
}
- (NSMutableAttributedString *)getSoonExpired{
    NSMutableAttributedString *content = [NSMutableAttributedString new];
    if (self.timeArray.count > 0) {
        
        NSDictionary *attDic = [NSDictionary dictionaryWithObjectsAndKeys:MKCOLOR_RGB(255, 97, 142),NSForegroundColorAttributeName, nil];
        
        for (SoonExpiredResume *model in self.timeArray) {
            
            NSMutableAttributedString *num = [[NSMutableAttributedString alloc]initWithString:model.soon_expired_num.description attributes:attDic];
            
            NSMutableAttributedString *fen = [[NSMutableAttributedString alloc]initWithString:@"份在" attributes:@{NSForegroundColorAttributeName:MKCOLOR_RGB(34, 58, 80)}];
            
            NSMutableAttributedString *time = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"%@",[DateHelper getDateFromTimeNumber:model.soon_expired_time withFormat:@"yyyy/MM/dd"]] attributes:attDic];
            
            NSMutableAttributedString *daoQi = [[NSMutableAttributedString alloc]initWithString:@"到期" attributes:@{NSForegroundColorAttributeName:MKCOLOR_RGB(34, 58, 80)}];
            
            [num appendAttributedString:fen];
            [num appendAttributedString:time];
            [num appendAttributedString:daoQi];
            [content appendAttributedString:num];
            
             NSMutableAttributedString *fuHao = [[NSMutableAttributedString alloc]initWithString:@"； " attributes:@{NSForegroundColorAttributeName:MKCOLOR_RGB(34, 58, 80)}];
            [content appendAttributedString:fuHao];
        }
        
        
    }
    return content;

}
#pragma mark - 网络部分
//过期数
- (void)getData{
    self.leftQueryParam.page_num = @1;
    WEAKSELF
    [[XSJRequestHelper sharedInstance] entQueryContactResumeList:self.leftQueryParam block:^(ResponseInfo *response) {
        
        if (response) {
            NSArray *timeArray = [SoonExpiredResume objectArrayWithKeyValuesArray:[response.content objectForKey:@"soon_expired_resume_num_arr"]];
            weakSelf.timeArray = [timeArray mutableCopy];
            [self setupViews];
        }
    }];
}


- (void)getDataForContact{
    self.leftQueryParam.page_num = @1;
    WEAKSELF
    [[XSJRequestHelper sharedInstance] entQueryContactResumeList:self.leftQueryParam block:^(ResponseInfo *response) {
        [weakSelf.leftTableView.header endRefreshing];
        if (response) {
            NSNumber *leftNum = [response.content objectForKey:@"left_resume_num"];
            weakSelf.left_resume_num = leftNum;
            [weakSelf.headerView setLeftNum:leftNum];
            
            NSNumber *totalReumeNum = [response.content objectForKey:@"total_resume_count"];
            [weakSelf.toolBar setContactedNum:totalReumeNum];
            
            NSArray *array = [JKModel objectArrayWithKeyValuesArray:[response.content objectForKey:@"resume_list"]];
            weakSelf.leftArray = [array mutableCopy];
            
            NSArray *timeArray = [SoonExpiredResume objectArrayWithKeyValuesArray:[response.content objectForKey:@"soon_expired_resume_num_arr"]];
            self.timeArray = [timeArray mutableCopy];
            
            [weakSelf.leftTableView reloadData];
            if (array.count) {
                weakSelf.leftNoDataView.hidden = YES;
                weakSelf.leftQueryParam.page_num = @2;
            }else{
                weakSelf.leftNoDataView.hidden = NO;
            }
        }
    }];
}

- (void)getMoredataForContact{
    WEAKSELF
    [[XSJRequestHelper sharedInstance] entQueryContactResumeList:self.leftQueryParam block:^(ResponseInfo *response) {
        [weakSelf.leftTableView.footer endRefreshing];
        if (response) {
            NSArray *array = [JKModel objectArrayWithKeyValuesArray:[response.content objectForKey:@"resume_list"]];
            if (array.count) {
                weakSelf.leftQueryParam.page_num = @(weakSelf.leftQueryParam.page_num.integerValue + 1);
                [weakSelf.leftArray addObjectsFromArray:array];
                [weakSelf.leftTableView reloadData];
            }
        }
    }];
}

- (void)getDataForCollect{
    self.rightQueryParam.page_num = @1;
    WEAKSELF
    [[XSJRequestHelper sharedInstance] getCollectedStudentList:self.rightQueryParam block:^(ResponseInfo *response) {
        [weakSelf.rightTableView.header endRefreshing];
        if (response) {
            NSNumber *leftNum = [response.content objectForKey:@"left_resume_num"];
            weakSelf.left_resume_num = leftNum;
            [weakSelf.headerView setLeftNum:leftNum];
            NSArray *array = [JKModel objectArrayWithKeyValuesArray:[response.content objectForKey:@"resume_list"]];
            weakSelf.rightArray = [array mutableCopy];
            [weakSelf.rightTableView reloadData];
            if (array.count) {
                weakSelf.rightNoDataView.hidden = YES;
                weakSelf.rightQueryParam.page_num = @2;
            }else{
                weakSelf.rightNoDataView.hidden = NO;
            }
        }
    }];
}

- (void)getMoreDataForCollect{
    WEAKSELF
    [[XSJRequestHelper sharedInstance] getCollectedStudentList:self.rightQueryParam block:^(ResponseInfo *response) {
        [weakSelf.rightTableView.footer endRefreshing];
        if (response) {
            NSArray *array = [JKModel objectArrayWithKeyValuesArray:[response.content objectForKey:@"resume_list"]];
            if (array.count) {
                weakSelf.rightQueryParam.page_num = @(weakSelf.rightQueryParam.page_num.integerValue + 1);
                [weakSelf.rightArray addObjectsFromArray:array];
                [weakSelf.rightTableView reloadData];
            }
        }
    }];
}

#pragma mark - uitableviewdatasource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView.tag == 10086) {
        return self.leftArray.count;
    }else{
        return self.rightArray.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    PostJobSuccess_Cell1 *cell = [tableView dequeueReusableCellWithIdentifier:@"PostJobSuccess_Cell1" forIndexPath:indexPath];
    
    cell.delegate = self;
    if (tableView.tag == 10086) {
        cell.sourceType = FromSourceType_myTalent;
        JKModel *model = [self.leftArray objectAtIndex:indexPath.row];
        cell.model = model;
    }else{
        cell.sourceType = FromSourceType_myTalenForCollect;
        JKModel *model = [self.rightArray objectAtIndex:indexPath.row];
        cell.model = model;
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    JKModel *model = nil;
    if (tableView.tag == 10086) {
        model = [self.leftArray objectAtIndex:indexPath.row];
    }else{
        model = [self.rightArray objectAtIndex:indexPath.row];
    }
    return model.cellHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSArray *array = nil;
    if (tableView.tag == 10086) {
        array = self.leftArray;
    }else{
        array = self.rightArray;
    }
    JKModel *model = [array objectAtIndex:indexPath.row];
    LookupResume_VC *vc = [[LookupResume_VC alloc] init];
    vc.hidesBottomBarWhenPushed = YES;
    vc.resumeId = model.resume_id;
    vc.isFromToLookUpResume = 1;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - uiscrollview delegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    if (scrollView.tag == 10010) {
        NSInteger page = scrollView.contentOffset.x / SCREEN_WIDTH;
        [self.toolBar setOffsetOfLineWithIndex:page];
        switch (page) {
            case 0:{
                self.leftTableView.hidden = NO;
            }
                break;
            case 1:{
                self.rightTableView.hidden = NO;
            }
                break;
            default:
                break;
        }
    }
}

#pragma mark - MyTalentHeaderViewDelegate
- (void)MyTalentHeaderView:(MyTalentHeaderView *)headerView{
    [TalkingData trackEvent:@"人才库_我的人才_去购买"];
    BuyResume_VC *vc = [[BuyResume_VC alloc] init];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - MyTalentToolBarDelegate
- (void)MyTalentToolBar:(MyTalentToolBar *)toolBar actiontype:(BtnOnClickActionType)actionType{
    switch (actionType) {
        case BtnOnClickActionType_contactedJK:{
            [self.scrollView setContentOffset:CGPointMake(0, 0)];
            self.leftTableView.hidden = NO;
        }
            break;
        case BtnOnClickActionType_collectedJK:{
            [self.scrollView setContentOffset:CGPointMake(SCREEN_WIDTH, 0)];
            self.rightTableView.hidden = NO;
        }
            break;
        default:
            break;
    }
}

#pragma mark - PostJobSuccess_Cell1Delegate
- (void)PostJobSuccess_Cell1:(PostJobSuccess_Cell1 *)cell actionType:(BtnOnClickActionType)actionType model:(JKModel *)model{
    switch (actionType) {
        case BtnOnClickActionType_makeCall:{
            [self makeCall:model];
        }
            break;
        case BtnOnClickActionType_sendMsg:{
            [self sendMsg:model];
        }
            break;
        case BtnOnClickActionType_collectJK:{
            [self cancelCollect:model];
        }
            break;
        default:
            break;
    }
}

#pragma mark - 业务方法
- (void)makeCall:(JKModel *)model{
    if (model.telphone.length) {
        [[MKOpenUrlHelper sharedInstance] callWithPhone:model.telphone];
    }else{
        [UIHelper toast:@"暂无联系电话"];
    }
}

- (void)sendMsg:(JKModel *)jkModel{
    if (jkModel.account_im_open_status) { // 有开通IM
        NSString* content = [NSString stringWithFormat:@"\"accountId\":\"%@\"", jkModel.account_id];
        RequestInfo* request = [[RequestInfo alloc] initWithService:@"shijianke_im_getUserPublicInfo" andContent:content];
        request.isShowLoading = NO;
        WEAKSELF
        [request sendRequestToImServer:^(ResponseInfo* response) {
            if (response && [response success]) {
                int type = [[UserData sharedInstance] getLoginType].integerValue == WDLoginType_JianKe ? WDLoginType_Employer : WDLoginType_JianKe;
                [WDChatView_VC openPrivateChatOn:weakSelf accountId:jkModel.account_id.description withType:type jobTitle:nil jobId:nil resumeId:jkModel.resume_id.description hideTabBar:YES];
            }
        }];
    } else {
        [UIHelper toast:@"对不起,该用户未开通IM功能"];
    }
}

- (void)cancelCollect:(JKModel *)model{
    [[XSJRequestHelper sharedInstance] cancelCollectedStudent:model.account_id block:^(id result) {
        if (result) {
            [UIHelper toast:@"取消收藏"];
            NSInteger row = [self.rightArray indexOfObject:model];
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:row inSection:0];
            [self.rightArray removeObject:model];
            [self.rightTableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
            
//            [self.rightTableView reloadData];
            if (!self.rightArray.count) {
                self.rightNoDataView.hidden = NO;
            }
        }
    }];
}

#pragma mark - lazy
- (UITableView *)leftTableView{
    if (!_leftTableView) {
        _leftTableView = [UIHelper createTableViewWithStyle:UITableViewStylePlain delegate:self onView:self.scrollView];
        _leftTableView.estimatedRowHeight = 170.0f;
        _leftTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _leftTableView.tag = 10086;
        _leftTableView.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            [self getDataForContact];
        }];
        _leftTableView.footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
            [self getMoredataForContact];
        }];
        [_leftTableView registerNib:nib(@"PostJobSuccess_Cell1") forCellReuseIdentifier:@"PostJobSuccess_Cell1"];
        self.leftNoDataView = [UIHelper noDataViewWithTitle:@"您还未主动联系过兼客"];
        self.leftNoDataView.y = 50;
        self.leftNoDataView.hidden = YES;
        [_leftTableView addSubview:self.leftNoDataView];
        [_leftTableView.header beginRefreshing];
    }
    return _leftTableView;
}

- (UITableView *)rightTableView{
    if (!_rightTableView) {
        _rightTableView = [UIHelper createTableViewWithStyle:UITableViewStylePlain delegate:self onView:self.scrollView];
        _rightTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _rightTableView.estimatedRowHeight = 170.0f;
        _rightTableView.tag = 10000;
        _rightTableView.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            [self getDataForCollect];
        }];
        _rightTableView.footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
            [self getMoreDataForCollect];
        }];
        _rightTableView.frame = CGRectMake(SCREEN_WIDTH, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 107 - 64 - 49 -paoMaViewHeight);
        [_rightTableView registerNib:nib(@"PostJobSuccess_Cell1") forCellReuseIdentifier:@"PostJobSuccess_Cell1"];
        self.rightNoDataView = [UIHelper noDataViewWithTitle:@"暂无收藏过的简历"];
        self.rightNoDataView.y = 50;
        self.rightNoDataView.hidden = YES;
        [_rightTableView addSubview:self.rightNoDataView];
        [_rightTableView.header beginRefreshing];
    }
    return _rightTableView;
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
