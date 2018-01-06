//
//  MyInfo_VC.m
//  jianke
//
//  Created by xiaomk on 16/6/7.
//  Copyright © 2016年 xianshijian. All rights reserved.
//

#import "MyInfo_VC.h"
#import "XSJConst.h"
#import "MyInfoCell_0.h"
#import "MyInfoCell_MoneyBag.h"
#import "MyInfoCell_2.h"
#import "MyInfoCell_4.h"
#import "MyInfoCell_new.h"
#import "MyInfoCell_Vip.h"

#import "SettingController.h"
#import "HiringJobList_VC.h"

#import "MoneyBag_VC.h"
#import "WebView_VC.h"
#import "InterestJob_VC.h"

#import "LookupResume_VC.h"

#import "BDCheckManager_VC.h"
#import "BdOrderController.h"
#import "TalentPoolController.h"
#import "JobVasOrder_VC.h"
#import "ServiceCenter_VC.h"

#import "EditEmployerInfo_VC.h"
#import "LookupEPInfo_VC.h"

#import "AccountMoneyModel.h"
#import "Login_VC.h"
#import "CityTool.h"
#import "XSJUserInfoData.h"
#import "NetworkTest_VC.h"
#import "SocialActivist_VC.h"
#import "ZPSalary_VC.h"
#import "JobCollection_VC.h"
#import "NewSocialActivist_VC.h"
#import "MyOrderDetail_VC.h"
#import "MyOrderList_VC.h"
#import "MyFanseList_VC.h"
#import "ApplyService_VC.h"
#import "EpProfile_VC.h"
#import "PostedServiceList_VC.h"
#import "MyInsuranceList_VC.h"
#import "SalaryJobGuide_VC.h"
#import "MyInfoCell_SBNew.h"
#import "TeamPersonOrder_VC.h"
#import "MyVerities_VC.h"
#import "VipIPacket_VC.h"
#import "VipInfoCenter_VC.h"
#import "ArrangedAgent_VC.h"
#import "ImDataManager.h"

@interface MyInfo_VC ()<UITableViewDelegate, UITableViewDataSource, MyInfoCell_4Delegate, MyInfoCell_newDelegate, MyInfoCell_MoneyBagDelegat>{
    EPModel *_epInfo;
}

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *datasArray;

@end

@implementation MyInfo_VC

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
   
    [self updateUserModel];
    
    if ([UserData sharedInstance].isUpdateWithMyInfoRecuit) {
        [[UserData sharedInstance] setIsUpdateWithMyInfoRecuit:NO];
        [self updateRecuitModel];
    }
}

- (void)viewDidLoad {
    self.isRootVC = YES;
    [super viewDidLoad];
    self.navigationItem.title = @"我";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"设置" style:UIBarButtonItemStylePlain target:self action:@selector(settingAction)];
    
    //登录成功通知
    [WDNotificationCenter addObserver:self selector:@selector(loginSuccessNotifi) name:WDNotifi_LoginSuccess object:nil];
    [WDNotificationCenter addObserver:self selector:@selector(updateMoneyBagRedPoint) name:IMPushWalletNotification object:nil];
    [WDNotificationCenter addObserver:self selector:@selector(updateMyInfo) name:UpdateMyInfoNotification object:nil];
    [WDNotificationCenter addObserver:self selector:@selector(reloadTableView) name:RefreshMyInfoTabeleViewNotification object:nil];

    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.tableView];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    [self.tableView registerNib:nib(@"MyInfoCell_new") forCellReuseIdentifier:@"MyInfoCell_new"];
    [self.tableView registerNib:nib(@"MyInfoCell_Vip") forCellReuseIdentifier:@"MyInfoCell_Vip"];
    [self.tableView registerNib:nib(@"MyInfoCell_SBNew") forCellReuseIdentifier:@"MyInfoCell_SBNew"];
    [self.tableView registerNib:nib(@"MyInfoCell_MoneyBag") forCellReuseIdentifier:@"MyInfoCell_MoneyBag"];
    
    self.datasArray = [[NSMutableArray alloc] init];
    [self loadDatas];
    WEAKSELF
    CityModel *ctModel = [[UserData sharedInstance] city];
    [CityTool getCityModelWithCityId:ctModel.id block:^(CityModel* obj) {
        if (obj) {
            [[UserData sharedInstance] setCity:obj];
            [weakSelf loadDatas];
            [weakSelf initUserInfo];
        }
    }];
}

- (void)loadDatas{
    [self.datasArray removeAllObjects];

    NSMutableArray *array1 = [NSMutableArray array];
    
    [array1 addObject:@(EPMyInfoCellType_login)];
    [array1 addObject:@(EPMyInfoCellType_moneyBag)];
    
    NSMutableArray *array2 = [NSMutableArray array];
    if ([[UserData sharedInstance] isEnableVipService] && ![XSJUserInfoData isReviewAccount]) {
        [array2 addObject:@(EPMyInfoCellType_vip)];
    }
    
    if (![XSJUserInfoData isReviewAccount]) {
        [array2 addObject:@(EPMyInfoCellType_vasService)];
    }
    
    if ([[UserData sharedInstance] isEnableVipService] && ![XSJUserInfoData isReviewAccount]) {
        [array2 addObject:@(EPMyInfoCellType_RecruitJob)];
    }
    
    if ([[UserData sharedInstance] isArrangedAgentEnabled]) {
        [array2 addObject:@(EPMyInfoCellType_baozhao)];
    }
    
    NSMutableArray *array3 = [NSMutableArray array];
    [array3 addObject:@(EPMyInfoCellType_myFans)];
    [array3 addObject:@(EPMyInfoCellType_QACenter)];
    [array3 addObject:@(EPMyInfoCellType_contact)];

    NSMutableArray *array4 = [NSMutableArray array];
    [array4 addObject:@(EPMyInfoCellType_CustomeService)];
    [array4 addObject:@(EPMyInfoCellType_EPService)];
    [array4 addObject:@(EPMyInfoCellType_switchToJK)];
    
    [self.datasArray addObject:array1];
    [self.datasArray addObject:array2];
    [self.datasArray addObject:array3];
    [self.datasArray addObject:array4];
    
    MKDispatch_main_async_safe(^{
        [self.tableView reloadData];
    });
}

- (void)initUserInfo{
    if ([[UserData sharedInstance] isLogin]) {
        _epInfo = [[UserData sharedInstance] getEpModelFromHave];
        if (_epInfo) {
            [self loadDatas];
        }else{
            [self updateUserModel];
        }
    }
}

- (void)updateUserModel{
    if ([[UserData sharedInstance] isLogin]) {
        WEAKSELF
        [[UserData sharedInstance] getEPModelWithBlock:^(EPModel *result) {
            _epInfo = result;
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf loadDatas];
            });
        }];
    }
}

#pragma mark - ***** 通知处理 ******
- (void)loginSuccessNotifi{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self updateUserModel];
        [self updateRecuitModel];
    });
}

- (void)updateMoneyBagRedPoint{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self updateUserModel];
    });
}

- (void)updateMyInfo{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self updateUserModel];
    });
}

- (void)updateRecuitModel{
    if ([[UserData sharedInstance] isEnableVipService] && [[UserData sharedInstance] isLogin]) {
        WEAKSELF
        [[XSJRequestHelper sharedInstance] entQueryRecruitJobNumInfo:[UserData sharedInstance].city.id isShowLoading:NO block:^(ResponseInfo *response) {
            if (response) {
                [weakSelf.tableView reloadData];
            }
        }];
    }
}

- (void)reloadTableView{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self loadDatas];
    });
}

#pragma mark - ***** UITableView delegate ******

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.datasArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSArray *array = [self.datasArray objectAtIndex:section];
    return array.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MyInfoCellType cellType = [[self.datasArray[indexPath.section] objectAtIndex:indexPath.row] integerValue];
    switch (cellType) {
        case EPMyInfoCellType_login:{
            MyInfoCell_4 *cell = [MyInfoCell_4 cellWithTableView:tableView];
            cell.delegate = self;
            [cell setModel:_epInfo];
            return cell;
        }
        case EPMyInfoCellType_moneyBag:{
            MyInfoCell_MoneyBag *cell = [tableView dequeueReusableCellWithIdentifier:@"MyInfoCell_MoneyBag" forIndexPath:indexPath];
            cell.delegate = self;
            [cell setEpModel:_epInfo];
            return cell;
        }
        case EPMyInfoCellType_myFans:
        case EPMyInfoCellType_QACenter:
        case EPMyInfoCellType_editService:
        case EPMyInfoCellType_reciveServiceOrder:
        case EPMyInfoCellType_postedServiceList:
        case EPMyinfoCellType_aboutApp:
        case EPMyInfoCellType_contact:
        case EPMyInfoCellType_vip:
        case EPMyInfoCellType_EPService:
        case EPMyInfoCellType_switchToJK:
        case EPMyInfoCellType_vasService:
        case EPMyInfoCellType_RecruitJob:
        case EPMyInfoCellType_baozhao:
        case EPMyInfoCellType_CustomeService:{
            MyInfoCell_new *cell = [tableView dequeueReusableCellWithIdentifier:@"MyInfoCell_new" forIndexPath:indexPath];
            cell.delegate = self;
            cell.cellType = cellType;
            [cell setEpInfo:_epInfo];
            return cell;
        }
        default:
            break;
    }
    
    return nil;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section == 1 || section == 2 || section == 3) {
        UIView *view = [[UIView alloc] init];
        view.backgroundColor = [UIColor XSJColor_clipLineGray];
        return view;
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 1 || section == 2 || section == 3) {
        return 0.7f;
    }
    return 0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    MyInfoCellType cellType = [[self.datasArray[indexPath.section] objectAtIndex:indexPath.row] integerValue];
    switch (cellType) {
        case EPMyInfoCellType_login:{
            if ([[UserData sharedInstance] isLogin]) {
                if ([self checkEpProfileCompleted]) {
                    EpProfile_VC* vc = [[EpProfile_VC alloc] init];
                    [XSJUserInfoData sharedInstance].isShowMoneyBadRedPoint = NO;
                    vc.epModel = [[UserData sharedInstance] getEpModelFromHave];
                    vc.hidesBottomBarWhenPushed = YES;
                    [self.navigationController pushViewController:vc animated:YES];
                }else{
                    EPModel *epModel = [[UserData sharedInstance] getEpModelFromHave];
                    EditEmployerInfo_VC* vc = [[EditEmployerInfo_VC alloc] init];
                    vc.epModel = [NSKeyedUnarchiver unarchiveObjectWithData:[NSKeyedArchiver archivedDataWithRootObject:epModel]];
                    vc.hidesBottomBarWhenPushed = YES;
                    [self.navigationController pushViewController:vc animated:YES];
                }
            }
        }
            break;
        case EPMyInfoCellType_myFans:{
            [self viewMyFanse];
        }
            break;
        case EPMyInfoCellType_QACenter:{
            [self viewInsuranceList];
        }
            break;
        case EPMyInfoCellType_editService:{
            [self editServiceAction:NO];
        }
            break;
        case EPMyInfoCellType_postedServiceList:{
            [self ViewPostedServiceList];
        }
            break;
        case EPMyInfoCellType_reciveServiceOrder:{
            [self viewAllOrder];
        }
            break;
        case EPMyinfoCellType_aboutApp:{
            [self accessGuidePage];
        }
            break;
        case EPMyInfoCellType_vip:{
            [TalkingData trackEvent:@"我_VIP会员"];
            [self enterVipCenter:[[UserData sharedInstance] isAccoutVip]];
        }
            break;
        case EPMyInfoCellType_EPService:{
            [self enterMyOrderList];
        }
            break;
        case EPMyInfoCellType_switchToJK:{
            [self swithToJKApp];
        }
            break;
        case EPMyInfoCellType_vasService:{  //付费推广
            [self pushVasOrder];
        }
            break;
        case EPMyInfoCellType_RecruitJob:{  //在招岗位数
            [self pushRecruit];
        }
            break;
        case EPMyInfoCellType_CustomeService:{
            [self enterService];
        }
            break;
        case EPMyInfoCellType_baozhao:{
            [self enterBaoZhao];
        }
            break;
        default:
            break;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    MyInfoCellType type = [[self.datasArray[indexPath.section] objectAtIndex:indexPath.row] integerValue];
    switch (type) {
        case EPMyInfoCellType_login:
            return 92;
        case EPMyInfoCellType_moneyBag:{
            return 96;
        }
        default:
            break;
    }
    return 56;
}

#pragma mark MyInfoCell_2 delegate

- (void)btnOnClickWithMyInfoCell:(MyInfoCell_2 *)cell{
    
}

#pragma mark MyInfoCell_4 delegate

- (void)MyInfoCell_4:(MyInfoCell_4 *)cell actionType:(BtnOnClickActionType)actionType{
    switch (actionType) {
        case BtnOnClickActionType_Vip:{
            if ([[UserData sharedInstance] isAccoutVip]) {
                [TalkingData trackEvent:@"我_VIP会员按钮（青铜、白银等会员标识）"];
            }else{
                [TalkingData trackEvent:@"我_开通VIP按钮"];
            }
            [self enterVipCenter:[[UserData sharedInstance] isAccoutVip]];
        }
            break;
        case BtnOnClickActionType_idCardVerityYES:
        case BtnOnClickActionType_idCardVerityIng:
        case BtnOnClickActionType_idCardVerityNO:
        case BtnOnClickActionType_epVerityYES:
        case BtnOnClickActionType_epVerityIng:
        case BtnOnClickActionType_epVerityNO:{
            [self pushToAuth];
        }
        default:
            break;
    }
}

- (void)pushToAuth{
    ELog(@"进入认证集合页");
    [[UserData sharedInstance] userIsLogin:^(id result) {
        if (result) {
            MyVerities_VC *vc = [[MyVerities_VC alloc] init];
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
        }
    }];
    
}

#pragma mark - ***** 业务方法 ******

- (BOOL)checkEpProfileCompleted{
    EPModel *epModel = [[UserData sharedInstance] getEpModelFromHave];
    
    if (!epModel) {
        return NO;
    }
    
    if (!epModel.true_name.length) {
        return NO;
    }
    
    return YES;
}

#pragma mark - ***** 按钮事件 ******

- (void)viewMyFanse{
    [[UserData sharedInstance] userIsLogin:^(id result) {
        if (result) {
            MyFanseList_VC *viewCtrl = [[MyFanseList_VC alloc] init];
            viewCtrl.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:viewCtrl animated:YES];
        }
    }];
}

- (void)viewInsuranceList{
    WebView_VC* vc = [[WebView_VC alloc] init];
    vc.url = [NSString stringWithFormat:@"%@%@", URL_HttpServer, kUrl_helpCenter];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)editServiceAction:(BOOL)isPostAction{
    [[UserData sharedInstance] userIsLogin:^(id result) {
        if (result) {
            ApplyService_VC *viewCtrl = [[ApplyService_VC alloc] init];
            viewCtrl.hidesBottomBarWhenPushed = YES;
            viewCtrl.isPostAction = isPostAction;
            [self.navigationController pushViewController:viewCtrl animated:YES];
        }
    }];
}

- (void)ViewPostedServiceList{
    [[UserData sharedInstance] userIsLogin:^(id result) {
        if (result) {
            PostedServiceList_VC *viewCtrl = [[PostedServiceList_VC alloc] init];
            viewCtrl.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:viewCtrl animated:YES];
        }
    }];
}

- (void)viewAllOrder{
    ELog(@"查看更多订单");
    MyOrderList_VC *viewCtrl = [[MyOrderList_VC alloc] init];
    viewCtrl.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:viewCtrl animated:YES];
}

- (void)accessGuidePage{
    NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    WebView_VC *viewCtrl = [[WebView_VC alloc] init];
    viewCtrl.url = [NSString stringWithFormat:@"%@%@%@", URL_HttpServer, KUrl_aboutYouPin, version];
    viewCtrl.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:viewCtrl animated:YES];
}

- (void)contactQQ{
    [TalkingData trackEvent:@"雇主_个人中心_联系运营经理"];
    CityModel* city = [[UserData sharedInstance] city];
    [MKOpenUrlHelper openQQWithNumber:city.contactQQ onViewController:self block:^(BOOL bRet) {
        [UIHelper toast:@"你没有安装QQ"];
    }];
}

- (void)enterVipCenter:(BOOL)isVip{
    if (isVip) {
        VipInfoCenter_VC *vc = [[VipInfoCenter_VC alloc] init];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }else{
        VipIPacket_VC *vc = [[VipIPacket_VC alloc] init];
        WEAKSELF
        vc.block = ^(id result){
            [weakSelf.navigationController popViewControllerAnimated:NO];
            [weakSelf enterVipCenter:YES];
        };
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }
    
}

- (void)enterMyOrderList{
    WEAKSELF
    [[UserData sharedInstance] userIsLogin:^(id result) {
        if (result) {
            if (_epInfo.is_apply_service_team.integerValue ==1) {
                [weakSelf enterMyOrderVC];
            }else{
                if ([self isEpModelImproved]) {
                    WebView_VC *viewCtrl = [[WebView_VC alloc] init];
                    NSString *url = [NSString stringWithFormat:@"%@%@", URL_HttpServer, KUrl_toPostServiceInfoPage];
                    viewCtrl.url = url;
                    viewCtrl.isPopToRootVC = YES;
                    viewCtrl.hidesBottomBarWhenPushed = YES;
                    [weakSelf.navigationController pushViewController:viewCtrl animated:YES];
                }else{
                    [weakSelf editServiceAction:YES];
                }
            }
        }
    }];
}

- (void)pushVasOrder{
    WEAKSELF
    [[UserData sharedInstance] userIsLogin:^(id result) {
        if (result) {
            JobVasOrder_VC *vc = [[JobVasOrder_VC alloc] init];
            vc.hidesBottomBarWhenPushed = YES;
            [weakSelf .navigationController pushViewController:vc animated:YES];
        }
    }];
}

- (void)pushRecruit{
    WEAKSELF
    [[UserData sharedInstance] userIsLogin:^(id result) {
        if (result) {
            HiringJobList_VC *vc = [[HiringJobList_VC alloc] init];
            vc.hidesBottomBarWhenPushed = YES;
            [weakSelf.navigationController pushViewController:vc animated:YES];
        }
    }];
}

- (void)enterService{
    ServiceCenter_VC *vc =[[ServiceCenter_VC alloc] init];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)enterBaoZhao{
    ArrangedAgent_VC *vc = [[ArrangedAgent_VC alloc] init];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)swithToJKApp{
    if ([[UIDevice currentDevice] systemVersion].floatValue < 10.0) {
        if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"jiankeapp://"]]) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"jiankeapp://"]];
        }else{
            NSString *uri = [NSString stringWithFormat:@"%@", kUrl_aboutApp];
            WebView_VC *vc = [[WebView_VC alloc] init];
            vc.url = [NSString stringWithFormat:@"%@%@", URL_HttpServer, uri];
            [self.navigationController pushViewController:vc animated:YES];
        }
    }else{
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"jiankeapp://"] options:@{UIApplicationOpenURLOptionUniversalLinksOnly : @NO} completionHandler:^(BOOL success) {
            if (!success) {
                NSString *uri = [NSString stringWithFormat:@"%@", kUrl_aboutApp];
                WebView_VC *vc = [[WebView_VC alloc] init];
                vc.url = [NSString stringWithFormat:@"%@%@", URL_HttpServer, uri];
                [self.navigationController pushViewController:vc animated:YES];
            }
        }];
    }
}

- (void)enterMyOrderVC{
    TeamPersonOrder_VC *vc = [[TeamPersonOrder_VC alloc] init];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)postSalaryJob{
    [[UserData sharedInstance] userIsLogin:^(id result) {
        if (result) {
            SalaryJobGuide_VC *viewCtrl = [[SalaryJobGuide_VC alloc] init];
            viewCtrl.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:viewCtrl animated:YES];
        }
    }];
}

- (void)settingAction{
    SettingController *vc = [[SettingController alloc] init];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

- (BOOL)isEpModelImproved{
    if (!_epInfo.service_name.length) {
        return NO;
    }
    if (!_epInfo.city_id) {
        return NO;
    }
    if (!_epInfo.service_contact_name.length) {
        return NO;
    }
    if (!_epInfo.service_contact_tel.length) {
        return NO;
    }
    if (!_epInfo.service_desc.length) {
        return NO;
    }
    return YES;
}

#pragma mark - delegate

- (void)myinfoCell_MonyeBag:(MyInfoCell_MoneyBag *)cell actionType:(BtnOnClickActionType)actionType{
    switch (actionType) {
        case BtnOnClickActionType_verity:{
            ELog(@"进入认证页面");
            [self pushToAuth];
        }
            break;
        case BtnOnClickActionType_moneyBag:{
            ELog(@"进入钱袋子");
            if ([XSJUserInfoData sharedInstance].isShowMoneyBadRedPoint) {
                [XSJUserInfoData sharedInstance].isShowMoneyBadRedPoint = NO;
                [self.tableView reloadData];
            }
            [self pushMoneyBag];
        }
            break;
        default:
            break;
    }
}

- (void)myInfoCellNew:(MyInfoCell_new *)cell actionType:(BtnOnClickActionType)actionType{
    switch (actionType) {
        case BtnOnClickActionType_makeCall:{
            
            if ([self isweekDate]) {
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"客服上班时间是工作日09:00~18:00,你现在拨打电话可能无人接听.建议您使用消息留言,客服看到后会第一时间回复您" preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *call = [UIAlertAction actionWithTitle:@"继续拨打" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    
                    NSString *str = [[XSJRequestHelper sharedInstance] getClientGlobalModel].consumer_hotline;
                    [[MKOpenUrlHelper sharedInstance] callWithPhone:str];
                    
                } ];
                UIAlertAction *msg = [UIAlertAction actionWithTitle:@"消息留言" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    [[UserData sharedInstance] userIsLogin:^(id obj) {
                        if (obj) {
                            UIViewController *chatViewController = [ImDataManager getKeFuChatVC];
                            chatViewController.hidesBottomBarWhenPushed = YES;
                            [self.navigationController pushViewController:chatViewController animated:YES];
                        }
                    }];
        
                } ];
                [alert addAction:call];
                [alert addAction:msg];
                [self presentViewController:alert animated:NO completion:nil];

            }else{
                NSString *str = [[XSJRequestHelper sharedInstance] getClientGlobalModel].consumer_hotline;
                [[MKOpenUrlHelper sharedInstance] callWithPhone:str];
      
            }
        }
            break;
        case BtnOnClickActionType_makeIm:{
            [[UserData sharedInstance] userIsLogin:^(id obj) {
                if (obj) {
                    UIViewController *chatViewController = [ImDataManager getKeFuChatVC];
                    chatViewController.hidesBottomBarWhenPushed = YES;
                    [self.navigationController pushViewController:chatViewController animated:YES];
                }
            }];

        }
            break;
        default:
            break;
    }
}
//判断客服是否在工作期间
- (BOOL)isweekDate{
    NSDate*date = [NSDate date];
    
    NSCalendar *calender = [NSCalendar currentCalendar];
    calender.timeZone = [NSTimeZone systemTimeZone];
    NSInteger week = [[calender components:NSCalendarUnitWeekday fromDate:date]weekday];
    BOOL isWeek = (week == 1 || week ==7) ? YES : NO;
    
    if (!isWeek) {
        NSDateFormatter * formatter = [[NSDateFormatter alloc]init];
        [formatter setDateFormat:@"HH"];
        NSInteger dateTime = [[formatter stringFromDate:date]integerValue];
        
        if (dateTime >= 9 && dateTime < 18 ) {
            return NO;
        }else{
            return YES;
        }
    }
    
    return isWeek;
}
- (void)pushMoneyBag{
    WEAKSELF
    [[UserData sharedInstance] userIsLogin:^(id obj) {
        if (obj) {
            MoneyBag_VC* vc = [UIHelper getVCFromStoryboard:@"JK" identify:@"sid_moneybag"];
            vc.hidesBottomBarWhenPushed = YES;
            [weakSelf.navigationController pushViewController:vc animated:YES];
        }
        
    }];
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
