//
//  PersonalList_VC.m
//  JKHire
//
//  Created by fire on 16/10/12.
//  Copyright © 2016年 xianshijian. All rights reserved.
//

#import "PersonalList_VC.h"
#import "PostPersonalJob_VC.h"
#import "WebView_VC.h"
#import "SuccessPostPerson_VC.h"
#import "TopicJobList_VC.h"

#import "XSJRequestHelper.h"
#import "ResponseInfo.h"

#import "PersonalListCell.h"
#import <SDCycleScrollView/SDCycleScrollView.h>
#import "JKHomeModel.h"

@interface PersonalList_VC () <PersonalListCellDelegate, SDCycleScrollViewDelegate>{
    NSNumber *_serviceType;
    BOOL _isFirstPush;
    NSArray *_adArrayData;
    BOOL _isInvited;    //回调用 刷新列表 优化性能 哈哈
}
@property (nonatomic, strong) QueryParamModel *queryParam;
@property (nonatomic, copy) NSNumber *cityId;
@property (nonatomic, strong) SDCycleScrollView *cycleBannerSV; /*!< banner 广告 */
@property (nonatomic, strong) UIView *tableFooterView;    /*!< 底部视图 */

@end

@implementation PersonalList_VC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupData];
    self.cityId = [UserData sharedInstance].city.id;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"frequent_icon_questionmark"] style:UIBarButtonItemStylePlain target:self action:@selector(showQA)];
    [UserData sharedInstance].popViewCtrl = self;
    self.tableViewStyle = UITableViewStyleGrouped;
    [self initUIWithType:DisplayTypeOnlyTableView];
//    [self initFooterView];
    [self.tableView registerNib:nib(@"PersonalListCell") forCellReuseIdentifier:@"PersonalListCell"];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.refreshType = RefreshTypeAll;
    [self initWithNoDataViewWithStr:@"暂时没有该类型的服务商" onView:self.tableView];
    self.viewWithNoData.y += 20;
    self.tableView.estimatedRowHeight = 109.0f;
    [self.tableView.header beginRefreshing];
}

- (void)initHeaderView{
    WEAKSELF
    ClientGlobalInfoRM* globaModel = [[XSJRequestHelper sharedInstance] getClientGlobalModel];
    if (globaModel) {
        if (globaModel.service_type_stu_banner_ad_list && globaModel.service_type_stu_banner_ad_list.count > 0) {
            UIView *tableHeaderView = [[UIView alloc] init];
            
            CGFloat bannerH = SCREEN_WIDTH*(76.00/359.00);
            self.cycleBannerSV.frame = CGRectMake(0, 12, SCREEN_WIDTH, bannerH);
            //初始化完成  设置tableViewheader
            tableHeaderView.frame = CGRectMake(0, 0, SCREEN_WIDTH, bannerH + 12);   //24为上下间距12 * 2
            [tableHeaderView addSubview:self.cycleBannerSV];
            _adArrayData = [AdModel objectArrayWithKeyValuesArray:globaModel.service_type_stu_banner_ad_list];
            [weakSelf refreshBannerWithArray:_adArrayData];
            self.tableView.tableHeaderView = tableHeaderView;
        }
    }
}

- (void)initFooterView{
    [self.tableFooterView removeFromSuperview];
    WEAKSELF
    [[XSJRequestHelper sharedInstance] getClientGlobalInfoWithBlock:^(ClientGlobalInfoRM *globalInfo) {
        if (globalInfo && globalInfo.is_show_adviser.integerValue == 1 && globalInfo.adviser_intro_url.length) {
//            [weakSelf.view addSubview:weakSelf.tableFooterView];
//            [weakSelf.tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
//                make.top.left.right.equalTo(weakSelf.view);
//                make.bottom.equalTo(weakSelf.tableFooterView.mas_top);
//            }];
//            [weakSelf.tableFooterView mas_makeConstraints:^(MASConstraintMaker *make) {
//                make.left.right.bottom.equalTo(weakSelf.view);
//                make.height.equalTo(@60);
//            }];
            weakSelf.tableView.tableFooterView = nil;
            weakSelf.tableView.tableFooterView = weakSelf.tableFooterView;
        }
    }];
    
}

- (void)reInitFooterView{
    [self.tableFooterView removeFromSuperview];
    WEAKSELF
    [[XSJRequestHelper sharedInstance] getClientGlobalInfoWithBlock:^(ClientGlobalInfoRM *globalInfo) {
        if (globalInfo && globalInfo.is_show_adviser.integerValue == 1 && globalInfo.adviser_intro_url.length) {
//            [weakSelf.tableFooterView removeFromSuperview];
//            weakSelf.tableFooterView = nil;
            //    [self.tableFooterView removeConstraints:self.tableFooterView.constraints];
//            [weakSelf.tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
//                make.edges.equalTo(weakSelf.view);
//            }];
//            weakSelf.tableView.tableFooterView = weakSelf.tableFooterView;

            [weakSelf.view addSubview:weakSelf.tableFooterView];
            [weakSelf.tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.top.left.right.equalTo(weakSelf.view);
                make.bottom.equalTo(weakSelf.tableFooterView.mas_top);
            }];
            [weakSelf.tableFooterView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.right.bottom.equalTo(weakSelf.view);
                make.height.equalTo(@60);
            }];
        }
    }];

}

/** 刷新广告条 */
- (void)refreshBannerWithArray:(NSArray*)dataArray{
    NSMutableArray* imgArray = [[NSMutableArray alloc] init];
    for (AdModel* model in dataArray) {
        if (model.img_url) {
            [imgArray addObject:model.img_url];
        }
    }
    if (dataArray.count == 1) {
        _cycleBannerSV.autoScrollTimeInterval = 3600;
    }else{
        _cycleBannerSV.autoScrollTimeInterval = 3;
    }
    _cycleBannerSV.imageURLStringsGroup = imgArray;
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (!_isFirstPush) {
        [self headerRefresh];
    }
    _isFirstPush = NO;
}

- (void)setupData{
    self.queryParam = [[QueryParamModel alloc] init];
    _isFirstPush = YES;
    switch (self.servicePersonType) {
        case ServicePersonType_Lady:
            _serviceType = @(2);
            self.title = @"找礼仪";
            break;
        case ServicePersonType_model:
            _serviceType = @(1);
            self.title = @"找模特";
            break;
        case ServicePersonType_teacher:
            _serviceType = @(5);
            self.title = @"找家教";
            break;
        case ServicePersonType_delegate:
            _serviceType = @(6);
            self.title = @"找代理";
            break;
        case ServicePersonType_actor:
            _serviceType = @(4);
            self.title = @"找商演";
            break;
        case ServicePersonType_reporter:
            _serviceType = @(3);
            self.title = @"找主持";
            break;
        case ServicePersonType_saler:
            _serviceType = @(7);
            self.title = @"找促销";
            break;
        default:
            _serviceType = @(0);
            break;
    }
}

- (void)headerRefresh{
    self.queryParam.page_num = @1;
    WEAKSELF
    [[XSJRequestHelper sharedInstance] getServicePersonalStuList:_serviceType cityId:self.cityId jobId:self.service_personal_job_id param:self.queryParam block:^(NSArray *result) {
        [weakSelf.tableView.header endRefreshing];
        if (result) {
            weakSelf.viewWithNoData.hidden = YES;
            if (result.count) {
                [self initHeaderView];
                [weakSelf initFooterView];
                weakSelf.viewWithNoData.hidden = YES;
                [weakSelf.dataSource removeAllObjects];
                [weakSelf.dataSource addObjectsFromArray:result];
                weakSelf.queryParam.page_num = @2;
                [weakSelf.tableView reloadData];
            }else{
                weakSelf.viewWithNoData.hidden = NO;
                [weakSelf reInitFooterView];
            }
        }else{
            weakSelf.viewWithNoNetwork.hidden = NO;
        }

    }];
}

- (void)footerRefresh{
    WEAKSELF
    [[XSJRequestHelper sharedInstance] getServicePersonalStuList:_serviceType cityId:self.cityId jobId:self.service_personal_job_id param:self.queryParam block:^(NSArray *result) {
        [weakSelf.tableView.footer endRefreshing];
        if (result) {
            if (result.count) {
                [weakSelf.dataSource addObjectsFromArray:result];
                weakSelf.queryParam.page_num = @(weakSelf.queryParam.page_num.integerValue + 1);
                [weakSelf.tableView reloadData];
            }
        }
        
    }];
}

#pragma mark - uitableview datasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.dataSource ? self.dataSource.count : 0 ;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    PersonalListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PersonalListCell" forIndexPath:indexPath];
    cell.delegate = self;
    ServicePersonalStuModel *model = [self.dataSource objectAtIndex:indexPath.section];
    [cell setModel:model cellType:self.servicePersonType atIndexPath:indexPath];
    return cell;
}

#pragma mark - uitableview delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    ServicePersonalStuModel *model = [self.dataSource objectAtIndex:indexPath.section];
    return model.cellHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 20.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    ELog(@"进入个人需求详情页");
    [[UserData sharedInstance] userIsLogin:^(id result) {
        ServicePersonalStuModel *model = [self.dataSource objectAtIndex:indexPath.section];
        WebView_VC *viewCtrl = [[WebView_VC alloc] init];
        viewCtrl.popViewCtrl = self;
        NSString *url = [NSString stringWithFormat:@"%@%@?service_type=%@&stu_account_id=%@", URL_HttpServer, KUrl_ServicePersonalDetail, _serviceType, model.stu_account_id];
        url = (self.service_personal_job_id) ? [url stringByAppendingFormat:@"&service_personal_job_id=%@", self.service_personal_job_id] : url ;
        viewCtrl.url = url;
        viewCtrl.uiType = WebViewUIType_PersonalServiceDetail;
        viewCtrl.competeBlock = ^(id result){
            _isInvited = YES;
        };
        [self.navigationController pushViewController:viewCtrl animated:YES];
    }];
}

//- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
//    CGFloat offsetY = scrollView.contentOffset.y + scrollView.height;
//    ELog(@"******offsetY:%f", offsetY);
//    ELog(@"******scrollView.contentSize.height:%f", scrollView.contentSize.height);
//    ELog(@"分割线-------------分割线");
//    if (offsetY > scrollView.height && offsetY >= scrollView.contentSize.height) {
//        if (self.dataSource.count < 3) {
//            return;
//        }
//        if (self.tableView.tableFooterView == nil) {
//            [self reInitFooterView];
//        }
//    }
//}

#pragma mark - PersonalListCellDelegate

- (void)personalListCellAtIndexPath:(NSIndexPath *)indexPath{
    ServicePersonalStuModel *model = [self.dataSource objectAtIndex:indexPath.section];
    if (model.is_be_invited.integerValue == 1) {
        return;
    }
    if (self.sourceType != ViewSourceType_InvitePersonalJob) {
        WEAKSELF
        [[XSJRequestHelper sharedInstance] entInviteServicePersonal:model.stu_account_id serviceJobId:self.service_personal_job_id block:^(id result) {
            if (result) {
                if (weakSelf.sourceType == ViewSourceType_PostPersonalJob) {
                    ELog(@"进入成功页，如果我是产品经理，我一定把出这版需求的产品给炒了，完全没任何交互可言！！");
                    ELog(@"进入邀约成功页");
                    SuccessPostPerson_VC *successViewCtrl = [[SuccessPostPerson_VC alloc] init];
                    successViewCtrl.personServiceType = _serviceType;
                    successViewCtrl.service_personal_job_id = weakSelf.service_personal_job_id;
                    [weakSelf.navigationController pushViewController:successViewCtrl animated:YES];
                }else{
                    [UIHelper toast:@"邀约成功"];
                    _isInvited = YES;
                    model.is_be_invited = @1;
                    model.invite_type = @1;
                    [weakSelf.tableView reloadData];
                }
            }
        }];
        return;
    }
    [[UserData sharedInstance] userIsLogin:^(id result) {
        ELog(@"进入需求发布页");
        PostPersonalJob_VC *viewCtrl = [[PostPersonalJob_VC alloc] init];
        viewCtrl.sourceType = ViewSourceType_InvitePersonalJob;
        viewCtrl.stu_account_id = model.stu_account_id;
        viewCtrl.serviceType = _serviceType;
        [self.navigationController pushViewController:viewCtrl animated:YES];
    }];
}

#pragma mark - SDCycleScrollViewDelegate

- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index{
    ELog(@"---点击了第%ld张图片", (long)index);
    if (_adArrayData.count <= 0) {
        return;
    }
//    NSString *numBanner = [NSString stringWithFormat:@"%ld",index + 1];
//    [TalkingData trackEvent:@"兼职快讯_Banner" label:numBanner];
    
    AdModel* model = _adArrayData[index];
    // 1:应用内打开链接 2:岗位广告  3:浏览器打开链接 4:专题类型
    [[XSJRequestHelper sharedInstance] queryAdClickLogRecordWithADId:model.ad_id];
    
    switch (model.ad_type.intValue) {
        case 1:{
            if (model.ad_detail_url == nil || model.ad_detail_url.length < 5) {
                return;
            }
            model.ad_detail_url = [model.ad_detail_url stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
            WebView_VC* vc = [[WebView_VC alloc] init];
            vc.url = model.ad_detail_url;
            vc.title = model.ad_name;
            vc.uiType = WebViewUIType_Banner;
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 2:{
            if (model.ad_detail_id == nil || model.ad_detail_id.intValue == 0) {
                return;
            }
//            //进入岗位详情
//            JobDetail_VC* vc = [[JobDetail_VC alloc] init];
//            vc.jobId = [NSString stringWithFormat:@"%@",model.ad_detail_id];
//            vc.hidesBottomBarWhenPushed = YES;
//            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 3:{
            if (model.ad_detail_url == nil || model.ad_detail_url.length < 5) {
                return;
            }
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:model.ad_detail_url]];
        }
            break;
        case 4:{
            TopicJobList_VC *vc = [[TopicJobList_VC alloc] init];
            vc.adDetailId = model.ad_detail_id.stringValue;
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        default:
            break;
    }
    
}

#pragma mark - other

- (void)showQA{
    WebView_VC *viewCtrl = [[WebView_VC alloc] init];
    viewCtrl.url = KUrl_hireHelp;
    [self.navigationController pushViewController:viewCtrl animated:YES];
}

- (void)backToLastView{
    if (_isInvited) {
        MKBlockExec(self.block, nil);
    }
    if (self.isPopToPrevious) {
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        if ([self popBackToView] == nil) {
            [self.navigationController popToRootViewControllerAnimated:YES];
        }
    }
    
}

- (void)btnPhoneOnClick:(UIButton *)sender{
//    WEAKSELF
    [[XSJRequestHelper sharedInstance] getClientGlobalInfoWithBlock:^(ClientGlobalInfoRM *globalInfo) {
        if (globalInfo && globalInfo.adviser_intro_url.length) {
            WebView_VC *viewCtrl = [[WebView_VC alloc] init];
            viewCtrl.url = globalInfo.adviser_intro_url;
            [self.navigationController pushViewController:viewCtrl animated:YES];
        }
    }];
}

#pragma mark - ***** lazy ****
- (SDCycleScrollView *)cycleBannerSV{
    if (!_cycleBannerSV) {
        _cycleBannerSV = [SDCycleScrollView cycleScrollViewWithFrame:CGRectZero imageURLStringsGroup:nil];
        _cycleBannerSV.pageControlAliment = SDCycleScrollViewPageContolAlimentRight;
        _cycleBannerSV.pageControlStyle = SDCycleScrollViewPageContolStyleClassic;
        _cycleBannerSV.delegate = self;
        _cycleBannerSV.currentPageDotColor = [UIColor whiteColor];
        _cycleBannerSV.pageDotColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.1];
        _cycleBannerSV.placeholderImage = [UIImage imageNamed:@"v3_public_banner"];
    }
    return _cycleBannerSV;
}

- (UIView *)tableFooterView{
    if (!_tableFooterView) {
        UIView *tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 60)];
        tableFooterView.backgroundColor = [UIColor XSJColor_newWhite];
        UIButton *btnPhone = [UIButton buttonWithType:UIButtonTypeCustom];
        btnPhone.backgroundColor = [UIColor clearColor];
        [btnPhone addTarget:self action:@selector(btnPhoneOnClick:) forControlEvents:UIControlEventTouchUpInside];
        
        UIImageView *imgPhone = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"make_call_Icon_Copy"]];
        
        UILabel *lab = [UILabel labelWithText:@"联系顾问帮忙招人" textColor:[UIColor XSJColor_tGrayDeepTinge] fontSize:16.0f];
        
        
        UIImageView *imgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"frequent_icon_forward"]];
        
        [tableFooterView addSubview:imgPhone];
        [tableFooterView addSubview:lab];
        [tableFooterView addSubview:imgView];
        [tableFooterView addSubview:btnPhone];
        
        [imgPhone mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(tableFooterView).offset(24);
            make.centerY.equalTo(tableFooterView);
        }];
        
        [lab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(imgPhone.mas_right).offset(16);
            make.centerY.equalTo(tableFooterView);
        }];
        
        [imgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(tableFooterView).offset(-24);
            make.centerY.equalTo(tableFooterView);
        }];
        
        [btnPhone mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(tableFooterView);
        }];
        
        _tableFooterView = tableFooterView;
    }
    return _tableFooterView;
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
