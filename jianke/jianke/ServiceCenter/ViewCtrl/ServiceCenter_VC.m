//
//  ServiceCenter_VC.m
//  JKHire
//
//  Created by xuzhi on 16/10/11.
//  Copyright © 2016年 xianshijian. All rights reserved.
//

#import "ServiceCenter_VC.h"
#import "CitySelectController.h"
#import "ChoosePostJobType_VC.h"
#import "PersonalList_VC.h"
#import "TeamServiceList_VC.h"
#import "WebView_VC.h"
#import "TopicJobList_VC.h"
#import "JobDetail_VC.h"
#import "ImDataManager.h"
#import "MutilScrollBase_VC.h"
#import "PostJob_VC.h"
#import "ApplyService_VC.h"
#import "SalaryJobGuide_VC.h"
#import "HiringJobList_VC.h"
#import "ChooseJobTypeList_VC.h"

#import "PersonalServiceCell.h"
#import "MarketServiceCell.h"
//#import "TeamServiceCell.h"
#import "TeamEnableServiceCell.h"
#import <SDCycleScrollView/SDCycleScrollView.h>
#import "TeamServiceNewCell.h"

#import "EPModel.h"
#import "JKHomeModel.h"
#import "AccountMoneyModel.h"

#import "CityTool.h"
#import "ModelManage.h"

@interface ServiceCenter_VC () <PersonalServiceCellDelegate, MarketServiceCellDelegate, SDCycleScrollViewDelegate, UIAlertViewDelegate> {
    EPModel *_epInfo;  //雇主信息
    NSArray* _adArrayData;       /*!< 广告条数据 */
}

@property (nonatomic, strong) SDCycleScrollView *cycleBannerSV; /*!< banner 广告 */
@property (nonatomic, copy) NSArray *menuBtnModelArr;   /*!< 服务商服务入口 */
@property (nonatomic, strong) UIView *tableHeaderView;

@end

@implementation ServiceCenter_VC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"找服务";
    [self setupViews];
    [WDNotificationCenter addObserver:self selector:@selector(serviceMsgUpdate) name:WDNotification_ServiceMsgUpdate object:nil];
    [self setupData];
}

#pragma mark - 初始化工作
- (void)setupViews{
    self.tableViewStyle = UITableViewStyleGrouped;
    [self initUIWithType:DisplayTypeOnlyTableView];
    self.tableView.backgroundColor = MKCOLOR_RGB(255, 255, 255);
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.sectionHeaderHeight = 28.0f;
    self.refreshType = RefreshTypeHeader;
    [self.tableView registerNib:nib(@"PersonalServiceCell") forCellReuseIdentifier:@"ServiceCenterPersonalServiceCell"];
    [self.tableView registerNib:nib(@"MarketServiceCell") forCellReuseIdentifier:@"ServiceCenterMarketServiceCell"];
    [self.tableView registerNib:nib(@"TeamServiceNewCell") forCellReuseIdentifier:@"TeamServiceNewCell"];
    [self.tableView registerNib:nib(@"TeamEnableServiceCell") forCellReuseIdentifier:@"TeamEnableServiceCell"];

    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithTitle:@"发布需求" style:UIBarButtonItemStylePlain target:self action:@selector(postJobAction)];
    self.navigationItem.rightBarButtonItems =  @[rightItem];
}


- (void)postJobAction{
    WEAKSELF
    [[UserData sharedInstance] userIsLoginWithNeedUpdateEpInfo:YES block:^(id obj) {
        if (obj) {
            [weakSelf pushToChooseJobVC];
        }
    }];
}

- (void)setupData{
    CityModel *ctModel = [[UserData sharedInstance] city];
    [self initUIWithCity:ctModel updateCityModel:NO];  //加载首页数据
}

- (void)initUIWithCity:(CityModel *)cityModel updateCityModel:(BOOL)isUpdateCModel{
    if (isUpdateCModel) {
        [self loadDataWithCityModel:cityModel];
        WEAKSELF
        [CityTool getCityModelWithCityId:cityModel.id block:^(CityModel *cModel) {
            if (cModel) {
                [[UserData sharedInstance] setCity:cModel];
            }
            [weakSelf loadDataWithCityModel:cModel];
        }];
    }else{
        [self loadDataWithCityModel:cityModel];
    }
    
}

- (void)loadDataWithCityModel:(CityModel *)cityModel{
    
    [self showNodataWithCityModel:cityModel];   //无数据处理
    WEAKSELF
    [[XSJRequestHelper sharedInstance] getClientGlobalInfoMust:NO withBlock:^(id result) {
        [self.dataSource removeAllObjects];
        [weakSelf.tableView.header endRefreshing];
        if (result) {
            [weakSelf initTableHeaderView]; // 刷新headView
            ClientGlobalInfoRM* globaModel = [[XSJRequestHelper sharedInstance] getClientGlobalModel];
            if (globaModel.service_team_entry_list) {
                weakSelf.menuBtnModelArr = [MenuBtnModel objectArrayWithKeyValuesArray:globaModel.service_team_entry_list];
                if (weakSelf.menuBtnModelArr.count) {
                    //保存到本地做无网络显示
                    [[UserData sharedInstance] saveHomeQuickEntryListWithArray:self.menuBtnModelArr];
                }
            }
        }
        [weakSelf.dataSource addObject:@(Service_Center_Section_Type_Personal)];
        [weakSelf.dataSource addObject:@(Service_Center_Section_Type_Team)];
        [weakSelf.dataSource addObject:@(Service_Center_Section_Type_Marketing)];
        [weakSelf.tableView reloadData];
    }];
}

- (void)showNodataWithCityModel:(CityModel *)cityModel{
    [self.dataSource removeAllObjects];
    [self initTableHeaderView]; //滚动banner

    self.menuBtnModelArr = [[UserData sharedInstance] getHomeQuickEntryList];
    [self.dataSource addObject:@(Service_Center_Section_Type_Personal)];
    [self.dataSource addObject:@(Service_Center_Section_Type_Team)];
    [self.dataSource addObject:@(Service_Center_Section_Type_Marketing)];
    [self.tableView reloadData];
}

/** 加载首页数据 */
- (void)initUIWithCity:(CityModel *)cityModel{
    [self initUIWithCity:cityModel updateCityModel:NO];
}

- (void)initUIWithData{
    //    [self updateTableViewData];
    
    if ([[UserData sharedInstance] isLogin]) {
        [[UserData sharedInstance] getEPModelWithBlock:^(EPModel* obj) {
            _epInfo = obj;
        }];
    }
}

/** 刷新banner */
- (void)initTableHeaderView{
    [self.tableHeaderView removeFromSuperview];
    self.tableHeaderView = nil;
    
    self.tableHeaderView = [[UIView alloc] init];
    
    CGFloat bannerH = SCREEN_WIDTH*(154.00/600.00);
    self.cycleBannerSV.frame = CGRectMake(0, 0, SCREEN_WIDTH, bannerH);
    [self.tableHeaderView addSubview:self.cycleBannerSV];
    
    ClientGlobalInfoRM* globaModel = [[XSJRequestHelper sharedInstance] getClientGlobalModel];
    if (globaModel) {
        if (globaModel.banner_ad_list && globaModel.banner_ad_list.count > 0) {
            _adArrayData = [AdModel objectArrayWithKeyValuesArray:globaModel.banner_ad_list];
            if (_adArrayData || _adArrayData.count > 0) {
                [[UserData sharedInstance] saveHomeADListWithArray:_adArrayData];
                [self refreshBannerWithArray:_adArrayData];
            }
        }
    }else{
        _adArrayData = [[UserData sharedInstance] getHomeADList];
        if (_adArrayData && _adArrayData.count > 0) {
            [self refreshBannerWithArray:_adArrayData];
        }
    }
    
    //初始化完成  设置tableViewheader
    self.tableHeaderView.frame = CGRectMake(0, 0, SCREEN_WIDTH, bannerH);
    self.tableView.tableHeaderView = self.tableHeaderView;
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

#pragma mark - uitableview datasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.dataSource ? self.dataSource.count : 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ServiceCenterSectionType type = ((NSNumber *)[self.dataSource objectAtIndex:indexPath.section]).integerValue;
    switch (type) {
        case Service_Center_Section_Type_Team:{
            TeamServiceNewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TeamServiceNewCell" forIndexPath:indexPath];
            return cell;
        }
        case Service_Center_Section_Type_Personal:{
            PersonalServiceCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ServiceCenterPersonalServiceCell" forIndexPath:indexPath];
            cell.delegate = self;
            return cell;
        }
        case Service_Center_Section_Type_Marketing:{
            MarketServiceCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ServiceCenterMarketServiceCell" forIndexPath:indexPath];
            cell.delegate = self;
            return cell;
        }
        default:
            break;
    }
    
    return nil;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (self.dataSource.count <= 0) {
        return nil;
    }
    UIView *view = [[UIView alloc] init];
    UILabel *label = [[UILabel alloc] init];
    label.textColor = MKCOLOR_RGBA(34, 58, 80, 0.32);
    label.font = [UIFont systemFontOfSize:13.0f];
    NSString *title;
    ServiceCenterSectionType type = ((NSNumber *)[self.dataSource objectAtIndex:section]).integerValue;
    switch (type) {
        case Service_Center_Section_Type_Team:
            title = @"找团队服务商";
            break;
        case Service_Center_Section_Type_Personal:
            title = @"定制专业兼职人员";
            break;
        case Service_Center_Section_Type_Marketing:
            title = @"企业线上线下产品推广";
            break;
        default:
            break;
    }
    label.text = title;
    [view addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(view);
        make.left.equalTo(view).offset(16);
    }];
    return view;
}

#pragma mark - uitableview delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    ServiceCenterSectionType type = ((NSNumber *)[self.dataSource objectAtIndex:indexPath.section]).integerValue;
    switch (type) {
        case Service_Center_Section_Type_Team:{
            if ([UserData sharedInstance].city.enableTeamService.integerValue == 1 && self.menuBtnModelArr.count) {
                [self pushToTeamListVC];
            }else{
                [self showAlert];
            }
        }
        default:
            break;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    ServiceCenterSectionType type = ((NSNumber *)[self.dataSource objectAtIndex:indexPath.section]).integerValue;
    switch (type) {
        case Service_Center_Section_Type_Team:
            return 77.0f;
        case Service_Center_Section_Type_Personal:
            return 156.0f;
        case Service_Center_Section_Type_Marketing:
            return 82.0f;
        default:
            break;
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 28.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.1f;
}

#pragma mark - PersonalServiceCellDelegate

- (void)personalServiceCell:(PersonalServiceCell *)cell actionType:(ServicePersonType)actionType{
    if (![[UserData sharedInstance] isEnablePersonalService]) {
        [self postNormalJob];
        return;
    }
    WEAKSELF
    [[UserData sharedInstance] userIsLogin:^(id result) {
        if (result) {
            ClientGlobalInfoRM* globaModel = [[XSJRequestHelper sharedInstance] getClientGlobalModel];
            if (globaModel.wap_url_list.find_service_personal_stu_list_url.length) {
                WebView_VC *viewCtrl = [[WebView_VC alloc] init];
                if ([globaModel.wap_url_list.find_service_personal_stu_list_url rangeOfString:@"?"].location == NSNotFound) {
                    viewCtrl.url = [NSString stringWithFormat:@"%@?service_type=%@", globaModel.wap_url_list.find_service_personal_stu_list_url, [ModelManage getServiceTypeWithEnmu:actionType]];
                }else{
                    viewCtrl.url = [NSString stringWithFormat:@"%@&service_type=%@", globaModel.wap_url_list.find_service_personal_stu_list_url, [ModelManage getServiceTypeWithEnmu:actionType]];
                }
                viewCtrl.uiType = WebViewUIType_starManage;
                viewCtrl.hidesBottomBarWhenPushed = YES;
                [weakSelf.navigationController pushViewController:viewCtrl animated:YES];
            }
        }
    }];
    
}

#pragma mark - MarketServiceCellDelegate

- (void)BtnOnClick:(ActionType)actionType{
    ClientGlobalInfoRM* globaModel = [[XSJRequestHelper sharedInstance] getClientGlobalModel];
    if (!globaModel.wap_url_list) {
        return;
    }
    NSString *url;
    switch (actionType) {
        case ActionType_ZhongBao:{
            url = globaModel.wap_url_list.zhongbao_demand_url;
        }
            break;
        case ActionType_XiongDitui:{
            url = globaModel.wap_url_list.xdt_demand_url;
        }
            break;
        default:
            break;
    }
    WEAKSELF
    [[UserData sharedInstance] userIsLogin:^(id result) {
        if (result) {
            WebView_VC *viewCtrl = [[WebView_VC alloc] init];
            viewCtrl.url = url;
            viewCtrl.uiType = webViewUIType_myMarketOrder;
            viewCtrl.hidesBottomBarWhenPushed = YES;
            [weakSelf.navigationController pushViewController:viewCtrl animated:YES];
        }
    }];
}

#pragma mark - button event

- (void)showAlert{
    
    [MKAlertView alertWithTitle:@"提示" message:@"您所在城市还没有足够多的团队服务商入驻,您可以发布普通岗位等待兼客报名,还可以抢先发布服务,让雇主找您合作" cancelButtonTitle:@"发布岗位" confirmButtonTitle:@"发布服务" supportCancelGesture:YES completion:^(UIAlertView *alertView, NSInteger buttonIndex) {
        switch (buttonIndex) {
            case 0:{
                [self checkPostStatus];
            }
                break;
            case 1:{
                [self postService];
            }
                break;
            default:
                break;
        }
    }];
}

- (void)checkPostStatus{
    [[UserData sharedInstance] userIsLogin:^(id result) {
        if (result) {
//            [self checkTrueName:^(id result) {
            [self postNormalJob];
//            }];
        }
    }];
}

#pragma mark - VIP发布相关业务


//获取在招岗位情况
- (void)getRecruitModel:(MKBlock)block{
    WEAKSELF
    
    [[XSJRequestHelper sharedInstance] entQueryRecruitJobNumInfo:[UserData sharedInstance].city.id isShowLoading:YES block:^(ResponseInfo *response) {
        if (response) {
            RecruitJobNumInfo *model = [RecruitJobNumInfo objectWithKeyValues:response.content];
            MKBlockExec(block, model);
        }else{
            [weakSelf getRecruitModel:block];
        }
    }];
}

- (void)enterRecuitVC{
    HiringJobList_VC *viewCtrl = [[HiringJobList_VC alloc] init];
    viewCtrl.model = [UserData sharedInstance].recruitJobNumInfo;
    viewCtrl.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:viewCtrl animated:YES];
}

#pragma mark - 发布相关业务

- (void)postNormalJob{
    [[UserData sharedInstance] userIsLogin:^(id result) {
        if (result) {
            PostJob_VC* vc = [[PostJob_VC alloc] init];
            vc.postJobType = PostJobType_common;
            vc.isShowTip = YES;
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
        }
    }];
}

- (void)postService{
    ELog(@"进入发布服务(此服务非彼服务)");
    WEAKSELF
    [[UserData sharedInstance] userIsLoginWithNeedUpdateEpInfo:YES block:^(id result) {
        if (result) {
            if ([weakSelf isEpModelImproved]) {
                WebView_VC *viewCtrl = [[WebView_VC alloc] init];
                NSString *url = [NSString stringWithFormat:@"%@%@", URL_HttpServer, KUrl_toPostServiceInfoPage];
                viewCtrl.url = url;
                viewCtrl.isPopToRootVC = YES;
                viewCtrl.hidesBottomBarWhenPushed = YES;
                [weakSelf.navigationController pushViewController:viewCtrl animated:YES];
            }else{
                ApplyService_VC *viewCtrl = [[ApplyService_VC alloc] init];
                viewCtrl.hidesBottomBarWhenPushed = YES;
                viewCtrl.isPostAction = YES;
                [weakSelf.navigationController pushViewController:viewCtrl animated:YES];
            }
        }
    }];
}

#pragma mark - custome method

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

- (void)pushToTeamListVC{
    MutilScrollBase_VC *viewCtrl = [[MutilScrollBase_VC alloc] init];
    viewCtrl.menuModelArr = [NSKeyedUnarchiver unarchiveObjectWithData:[NSKeyedArchiver archivedDataWithRootObject:self.menuBtnModelArr]];
    viewCtrl.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:viewCtrl animated:YES];
}

- (void)pushToChooseJobVC{
    ChoosePostJobType_VC* vc = [[ChoosePostJobType_VC alloc] init];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - SDCycleScrollViewDelegate

- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index{
    ELog(@"---点击了第%ld张图片", (long)index);
    if (_adArrayData.count <= 0) {
        return;
    }
    NSString *numBanner = [NSString stringWithFormat:@"%ld",index + 1];
    [TalkingData trackEvent:@"兼职快讯_Banner" label:numBanner];
    
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
            //进入岗位详情
            JobDetail_VC* vc = [[JobDetail_VC alloc] init];
            vc.jobId = [NSString stringWithFormat:@"%@",model.ad_detail_id];
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
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

#pragma mark - ***** lazy ****
- (SDCycleScrollView *)cycleBannerSV{
    if (!_cycleBannerSV) {
        _cycleBannerSV = [SDCycleScrollView cycleScrollViewWithFrame:CGRectZero imageURLStringsGroup:nil];
        _cycleBannerSV.pageControlAliment = SDCycleScrollViewPageContolAlimentCenter;
        _cycleBannerSV.pageControlStyle = SDCycleScrollViewPageContolStyleClassic;
        _cycleBannerSV.delegate = self;
        _cycleBannerSV.currentPageDotColor = [UIColor whiteColor];
        _cycleBannerSV.pageDotColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.1];
        _cycleBannerSV.placeholderImage = [UIImage imageNamed:@"v3_public_banner"];
    }
    return _cycleBannerSV;
}

#pragma mark - 重新方法

- (void)headerRefresh{
    //刷新
//    [self.tableView.header endRefreshing];
    CityModel *cityModel = [UserData sharedInstance].city;
    [self initUIWithCity:cityModel updateCityModel:YES];
}

#pragma mark - ******notification*******
- (void)serviceMsgUpdate{
    CityModel *cityModel = [[UserData sharedInstance] city];
    [self loadDataWithCityModel:cityModel];
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
