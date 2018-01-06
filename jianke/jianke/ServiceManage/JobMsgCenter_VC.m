//
//  JobMsgCenter_VC.m
//  JKHire
//
//  Created by yanqb on 2017/1/5.
//  Copyright © 2017年 xianshijian. All rights reserved.
//

#import "JobMsgCenter_VC.h"
#import "CitySelectController.h"
#import "WaitPassJob_VC.h"
#import "ChoosePostJobType_VC.h"
#import "HireOffJob_VC.h"
#import "MyInsuranceList_VC.h"
#import "SalaryJobGuide_VC.h"
#import "PostJob_VC.h"
#import "HiringJobList_VC.h"
#import "ChooseJobTypeList_VC.h"
#import "JobManage_VC.h"

#import "JobMsgHeaderView.h"
#import "GuideMaskView.h"

#import "ImDataManager.h"
#import "AccountMoneyModel.h"
#import "CityTool.h"
#import "RegiseterGuide_VC.h"
#import "HireServiceIntro_VC.h"
#import "JobVasOrder_VC.h"
#import "WebView_VC.h"
#import "GuideUIManager.h"
#import "JKHomeModel.h"

#define TableViewTag 100

@interface JobMsgCenter_VC () <UIScrollViewDelegate, JobMsgHeaderViewDelegate, UIAlertViewDelegate, JobManage_VCDelegate, WaitPassJob_VCDelegate, HireOffJob_VCDelegate> {
    EPModel *_epInfo;  //雇主信息
    NSArray* _adArrayData;       /*!< 广告条数据 */
}

@property (nonatomic, assign) CGFloat scrollViewHeight; //scrollview当前高度
@property (nonatomic, assign) CGFloat scrollViewOrignHeight;    //scrollview初始高度
@property (nonatomic, assign) CGFloat scrollViewY;  //headerview高度 or scrollview的初始Y坐标
@property (nonatomic, assign) CGFloat currectScrollViewOffsetY;   //scrollview当前的Y坐标

@property (nonatomic, strong) RecruitJobNumInfo *recruitJobNumInfo; //在招岗位数情况
@property (nonatomic, assign) BtnOnClickActionType currentActionType;

@property (nonatomic, weak) UIButton *leftBarbutton;

@property (nonatomic, weak) JobMsgHeaderView *headerView;

//待审核-招聘中-已结束 业务
@property (nonatomic, weak) UIScrollView *scrollView;
@property (nonatomic, weak) WaitPassJob_VC *waitVC;
@property (nonatomic, weak) UIView *waitView;   /*!< 待审核 */
@property (nonatomic, weak) JobManage_VC *hireVC;
@property (nonatomic, weak) UIView *hireView;   /*!< 招聘中 */
@property (nonatomic, weak) HireOffJob_VC *endVC;
@property (nonatomic, weak) UIView *endView;    /*!< 已结束 */

@end

@implementation JobMsgCenter_VC

- (void)viewDidLoad {
    self.isRootVC = YES;
    [super viewDidLoad];
    self.navigationItem.title = @"首页";
    [self setupViews];
    [self setupData];
    [self addNotification];
    [self autoLogin];
    [[XSJRequestHelper sharedInstance] postThirdPushPlatInfo];  //向服务端发送极光ID
    self.currentActionType = BtnOnClickActionType_hire;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if ([[UserData sharedInstance] isUpdateWithEPHeaderView]) {
        [self loadDataOfTopViewWithIsResetTableviewTop:NO];
        [[UserData sharedInstance] setIsUpdateWithEPHeaderView:NO];
    }
}

- (void)setupViews{
    
    //位置按钮
    UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    leftBtn.frame = CGRectMake(0, 0, 120, 44);
    leftBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [leftBtn setImage:[UIImage imageNamed:@"v3_home_location"] forState:UIControlStateNormal];
    [leftBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
    leftBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [leftBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [leftBtn addTarget:self action:@selector(citySelectAction:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:leftBtn];
    self.leftBarbutton = leftBtn;
    self.navigationItem.leftBarButtonItem = leftItem;
    [self updateLeftBarButton];

    //主页面
    CGFloat heightOfHead = 149.0f;
    self.scrollViewOrignHeight = SCREEN_HEIGHT - 64 - 49 - heightOfHead;
    self.scrollViewHeight = self.scrollViewOrignHeight;
    
    JobMsgHeaderView *headerView = [[JobMsgHeaderView alloc] init];
    headerView.delegate = self;
    _headerView = headerView;
    
    UIScrollView *scrollView = [[UIScrollView alloc] init];
    scrollView.backgroundColor = [UIColor XSJColor_newGray];
    scrollView.contentSize = CGSizeMake(SCREEN_WIDTH * 3, self.scrollViewOrignHeight);
    scrollView.pagingEnabled = YES;
    scrollView.delegate = self;
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.tag = 666;
    _scrollView = scrollView;
    
    [self.view addSubview:headerView];
    [self.view addSubview:scrollView];
    
    headerView.frame = CGRectMake(0, 0, SCREEN_WIDTH, heightOfHead);
    self.scrollViewY = heightOfHead;
    scrollView.frame = CGRectMake(0, heightOfHead, SCREEN_WIDTH, self.scrollViewOrignHeight);
    [scrollView setContentOffset:CGPointMake(SCREEN_WIDTH, 0) animated:NO];

    self.hireView.hidden = NO;
}

- (void)citySelectAction:(UIButton *)sender{
    CitySelectController *viewCtrl = [[CitySelectController alloc] init];
    viewCtrl.isPushAction = YES;
    viewCtrl.hidesBottomBarWhenPushed = YES;
    WEAKSELF
    viewCtrl.didSelectCompleteBlock = ^(CityModel *area){
        if (area && [area isKindOfClass:[CityModel class]]) {
            [[UserData sharedInstance] setCity:area];
            [self reInitGlobalObj];
            [weakSelf updateLeftBarButton];
            weakSelf.recruitJobNumInfo= nil;
            [UserData sharedInstance].recruitJobNumInfo = nil;
            [weakSelf reloadVipUI];
//            [weakSelf reloadVipInfo:area];
            [WDNotificationCenter postNotificationName:RefreshMyInfoTabeleViewNotification object:nil];
            [WDNotificationCenter postNotificationName:RefreshFindTalentNotification object:nil];
        }
    };
    [self.navigationController pushViewController:viewCtrl animated:YES];
}

- (void)reInitGlobalObj{
    [[XSJRequestHelper sharedInstance] getClientGlobalInfoMust:YES withBlock:^(id result) {
        if (result) {
            [WDNotificationCenter postNotificationName:WDNotification_ServiceMsgUpdate object:nil];
        }
    }];
}

- (void)reInitCityObjWith:(CityModel *)ctModel{
    WEAKSELF
    [CityTool getCityModelWithCityId:ctModel.id block:^(CityModel *cModel) {
        if (cModel) {
            [[UserData sharedInstance] setCity:cModel];
            [weakSelf reloadVipUI];
        }
    }];
}

- (void)reloadVipUI{
    [self loadDataOfTopViewWithIsResetTableviewTop:YES];
}

- (void)loadDataOfTopViewWithIsResetTableviewTop:(BOOL)isResetTableViewTop{
    if ([[UserData sharedInstance] isEnableVipService] && [[UserData sharedInstance] isLogin]) {
        WEAKSELF
        [[XSJRequestHelper sharedInstance] entQueryRecruitJobNumInfo:[UserData sharedInstance].city.id isShowLoading:NO block:^(ResponseInfo *response) {
            if (response) {
                RecruitJobNumInfo *model = [RecruitJobNumInfo objectWithKeyValues:response.content];
                weakSelf.recruitJobNumInfo = model;
            }
        }];
    }
    if (isResetTableViewTop) {
        [self resetTableViewTop];
    }
}

- (void)resetTableViewTop{
    _scrollViewOrignHeight = SCREEN_HEIGHT - 64 - 49 - self.scrollViewY;
    self.headerView.height = self.scrollViewY;
    [self clearHeaderPosition];
    switch (_currentActionType) {
        case BtnOnClickActionType_waitToPass:{
            [self.waitVC setTableViewTop];
        }
            break;
        case BtnOnClickActionType_hire:{
            [self.hireVC setTableViewTop];
        }
            break;
        case BtnOnClickActionType_HireOff:{
            [self.endVC setTableViewTop];
        }
            break;
        default:
            break;
    }
}

- (void)setupData{
    [self setupCity];   //城市选择相关
    [self showComment];
    [self initUIWithData];
}

- (void)showComment{
    [UserData delayTask:3 onTimeEnd:^{
        [[XSJUIHelper sharedInstance] showCommentAlertWithVC:self];
    }];
}

- (void)setupCity{
    CityModel *ctModel = [[UserData sharedInstance] city];
    if (!ctModel) {
        //缓存中没有城市,进入城市选择页面
        CitySelectController *viewCtrl = [[CitySelectController alloc] init];
        WEAKSELF
        viewCtrl.didSelectCompleteBlock = ^(CityModel *area){
            if (area && [area isKindOfClass:[CityModel class]]) {
                [[UserData sharedInstance] setCity:area];
                [weakSelf reInitGlobalObj];
                [weakSelf updateLeftBarButton];
                [weakSelf reloadVipUI];
                [self showAd];
                [weakSelf showGuide];
//                [weakSelf reloadVipInfo:area];
                [WDNotificationCenter postNotificationName:RefreshMyInfoTabeleViewNotification object:nil];
                [WDNotificationCenter postNotificationName:RefreshFindTalentNotification object:nil];
            }
        };
        MainNavigation_VC *nav = [[MainNavigation_VC alloc] initWithRootViewController:viewCtrl];
        [self presentViewController:nav animated:YES completion:nil];
    }else{
        //如果有,则直接加载数据
        [self updateLeftBarButton]; //刷新按钮文字
        [self reInitCityObjWith:ctModel];   //刷新城市相关数据
//        [self reloadVipInfo:ctModel];
        [WDNotificationCenter postNotificationName:RefreshMyInfoTabeleViewNotification object:nil];
//        [self reInitGlobalObj]; //  刷新全局数据
        [self showAd];
    }
}

- (void)updateLeftBarButton{
    CityModel *ctModel = [[UserData sharedInstance] city];
    if (ctModel) {
        [self.leftBarbutton setTitle:ctModel.name forState:UIControlStateNormal];
    }
}

- (void)addNotification{
    [WDNotificationCenter addObserver:self selector:@selector(loginSuccessNotifi) name:WDNotifi_LoginSuccess object:nil];
    [WDNotificationCenter addObserver:self selector:@selector(updateMsgNum:) name:WDNotification_EP_homeUpdateMsgNum object:nil];
    [WDNotificationCenter addObserver:self selector:@selector(walletNotify) name:IMPushWalletNotification object:nil];
    [WDNotificationCenter addObserver:self selector:@selector(updateHeaderView:) name:IMNotification_EPMainHeaderViewUpdate object:nil];
    [WDNotificationCenter addObserver:self selector:@selector(appEnterForeground) name:WDNotification_ApplicationWillEnterForeground object:nil];
    
    
    
    [self addObserver:self forKeyPath:@"scrollViewHeight" options:NSKeyValueObservingOptionNew context:nil];
    [self addObserver:self forKeyPath:@"scrollViewY" options:NSKeyValueObservingOptionNew context:nil];
    [self addObserver:self forKeyPath:@"scrollViewOrignHeight" options:NSKeyValueObservingOptionNew context:nil];
}

- (void)autoLogin{
    WEAKSELF
    [[XSJRequestHelper sharedInstance] activateAutoLoginWithBlock:^(ResponseInfo *result) {
        if ([[UserData sharedInstance] isLogin]) {
            [WDNotificationCenter postNotificationName:WDNotifi_LoginSuccess object:nil];
            [[UserData sharedInstance] getEPModelWithBlock:^(EPModel* obj) {
                _epInfo = obj;
                [weakSelf loginIm];
                [weakSelf setWallet];
            }];
            
            NSString *trueName = [result.content objectForKey:@"true_name"];
            if (!trueName.length) {
                [weakSelf showRegisterGuideVC:^(id result) {
                    [weakSelf showGuide];
                }];
            }else{
                [weakSelf showGuide];
            }
        }else{
            if ([UserData sharedInstance].city) {
                [weakSelf showGuide];
            }
        }
    }];
}

- (void)showRegisterGuideVC:(MKBlock)block{
    UIViewController *vc = [MKUIHelper getTopViewController];
    
    RegiseterGuide_VC *viewCtrl = [[RegiseterGuide_VC alloc] init];
//    viewCtrl.isNotRergistAction = YES;
    viewCtrl.hidesBottomBarWhenPushed = YES;
    
    MainNavigation_VC *nav = [[MainNavigation_VC alloc] initWithRootViewController:viewCtrl];
    
    if (!vc || !vc.navigationController) {
        vc = self;
    }
    
    @try {
        viewCtrl.block = ^(id result){
            [vc dismissViewControllerAnimated:YES completion:nil];
            MKBlockExec(block, nil);
        };
        [vc presentViewController:nav animated:YES completion:nil];
    } @catch (NSException *exception) {
        
    } @finally {
        
    }
}

/** 设置钱袋子小红点 */
- (void)setWallet{
    if ([[UserData sharedInstance] isLogin]) {
        WEAKSELF
        [[XSJRequestHelper sharedInstance] queryAccountMoneyWithBlock:^(ResponseInfo *response) {
            if (response && response.success) {
                AccountMoneyModel *account = [AccountMoneyModel objectWithKeyValues:response.content[@"account_money_info"]];
                if (account.money_bag_small_red_point.integerValue > 0) {
                    [XSJUserInfoData sharedInstance].isShowMoneyBadRedPoint = YES;
                    [weakSelf walletNotify];
                }else{
                    [XSJUserInfoData sharedInstance].isShowMoneyBadRedPoint = NO;
                }
            }
        }];
    }
}

- (void)loginIm{
    if ([[UserData sharedInstance] isLogin]) {
        if (![[ImDataManager sharedInstance] isUserLogin]) {
            [[ImDataManager sharedInstance] tryLogin];
        }
    }
}

- (void)loginSuccessNotifi{
    ELog(@"===ep loginSuccessNotifi");
    [self initUIWithData];
    [self loginIm];
    [self reloadVipUI];
//    [self reloadVipInfo:[UserData sharedInstance].city];
}

- (void)initUIWithData{
    if ([[UserData sharedInstance] isLogin]) {
        [[UserData sharedInstance] getEPModelWithBlock:^(EPModel* obj) {
        }];
    }
}

- (void)updateMsgNum:(NSNotification *)notification{
    NSNumber* msgCount = notification.userInfo[@"msgCount"];
    ELog(@"EP====msgCount:%@",msgCount);
    dispatch_async(dispatch_get_main_queue(), ^{
        
        UITabBarItem *item = [self.navigationController.tabBarController.tabBar.items objectAtIndex:2];
        if (msgCount.intValue <= 0) {
            item.badgeValue = nil;
        }else{
            NSString* numStr;
            if (msgCount.integerValue > 99) {
                numStr = @"99+";
            }else{
                numStr = msgCount.stringValue;
            }
            item.badgeValue = numStr;
        }
    });
}

/** 钱袋子小红点通知 */
- (void)walletNotify{
    dispatch_async(dispatch_get_main_queue(), ^{
        if ([[XSJUserInfoData sharedInstance] getIsShowMyInfoTabBarSmallRedPoint]) {
            [self.tabBarController.tabBar showSmallBadgeOnItemIndex:3];
        }
    });
}

- (void)updateHeaderView:(NSNotification *)notification{
    dispatch_async(dispatch_get_main_queue(), ^{
        if (notification.object) {
            [[UserData sharedInstance] getEPModelWithBlock:^(EPModel* obj) {
                _epInfo = obj;
                [self loadDataOfTopViewWithIsResetTableviewTop:NO];
            }];
        }else{
            [self loadDataOfTopViewWithIsResetTableviewTop:NO];
        }
        
    });
}

- (void)appEnterForeground{
    [self loadDataOfTopViewWithIsResetTableviewTop:NO];
}

#pragma mark - 待审核业务
- (void)waitPassJob:(WaitPassJob_VC *)viewCtrl scrollViewOffset:(CGPoint)offset{
    if (_currentActionType == BtnOnClickActionType_waitToPass) {
        [self scrollViewOffset:offset];
    }
}

- (void)waitPassJob:(WaitPassJob_VC *)viewCtrl actionType:(VCActionType)actionType{
    switch (actionType) {
        case VCActionType_HeaderView:{
            [self loadDataOfTopViewWithIsResetTableviewTop:NO];
        }
            break;
        default:
            break;
    }
}

#pragma mark - 招聘中业务
- (void)JobManage_VC:(JobManage_VC *)viewCtrl scrollViewOffset:(CGPoint)offset{
    if (_currentActionType == BtnOnClickActionType_hire) {
        [self scrollViewOffset:offset];
    }
}

- (void)jobManage_VC:(JobManage_VC *)viewCtrl actionType:(VCActionType)actionType{
    switch (actionType) {
        case VCActionType_HeaderView:{
            [self loadDataOfTopViewWithIsResetTableviewTop:NO];
        }
            break;
        default:
            break;
    }
}

#pragma mark - 已结束业务
- (void)hireOffJob:(HireOffJob_VC *)viewCtrl scrollViewOffset:(CGPoint)offset{
    if (_currentActionType == BtnOnClickActionType_HireOff) {
        [self scrollViewOffset:offset];
    }
}

- (void)closeJobWithHireOffJob:(HireOffJob_VC *)viewCtrl{
    [self loadDataOfTopViewWithIsResetTableviewTop:NO];
}

- (void)scrollViewOffset:(CGPoint)offset{
    CGFloat maxOffset = self.scrollViewY - 42;
    
    offset.y = (offset.y > maxOffset) ? maxOffset : (offset.y <= 0) ? 0 : offset.y;
    if (offset.y >= 0) {
        self.scrollViewHeight = (self.scrollViewOrignHeight + offset.y);
        self.scrollView.y = (self.scrollViewY - offset.y);
        self.currectScrollViewOffsetY = offset.y;
    }
    
    self.headerView.y = - (offset.y);
}

#pragma mark - uiscrollview delegate

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    NSInteger index = scrollView.contentOffset.x / SCREEN_WIDTH;
    [self.headerView updateBtnStatusAtIndex:index];
    switch (index) {
        case 0:{
            self.waitView.hidden = NO;
            [self clearChangeWithActionType:BtnOnClickActionType_waitToPass];
        }
            break;
        case 1:{
            self.hireView.hidden = NO;
            [self clearChangeWithActionType:BtnOnClickActionType_hire];
        }
            break;
        case 2:{
            self.endView.hidden = NO;
            [self clearChangeWithActionType:BtnOnClickActionType_HireOff];
        }
            break;
        default:
            break;
    }
}

#pragma mark - JobMsgHeaderView delegate

- (void)jobMsgHeaderView:(JobMsgHeaderView *)headerView actionType:(BtnOnClickActionType)actionType{
    switch (actionType) {
        case BtnOnClickActionType_hireTool:{   //招人神器
            [self postSalaryJob];
        }
            break;
        case BtnOnClickActionType_postJob:{ //发布兼职
            [self actionOnClick:^(id result) {
                [headerView reload];
            }];
        }
            break;
        case BtnOnClickActionType_insurance:{   //兼职保险
            [self viewInsuranceList];
        }
            break;
        case BtnOnClickActionType_waitToPass:{  //待审核
            self.waitView.hidden = NO;
            [self.scrollView setContentOffset:CGPointMake(0, 0) animated:NO];
            [self clearChangeWithActionType:actionType];
        }
            break;
        case BtnOnClickActionType_hire:{    //招聘中
            self.hireView.hidden = NO;
            if (self.hireVC.dataSource.count) {
                [self showGuideManage];
            }
            [self.scrollView setContentOffset:CGPointMake(SCREEN_WIDTH, 0) animated:NO];
            [self clearChangeWithActionType:actionType];
        }
            break;
        case BtnOnClickActionType_HireOff:{ //已结束
            self.endView.hidden = NO;
            [self.scrollView setContentOffset:CGPointMake(SCREEN_WIDTH * 2, 0) animated:NO];
            [self clearChangeWithActionType:actionType];
        }
            break;
        case BtnOnClickActionType_Vip:{ //vip 在招岗位数
            [self enterRecuitVC];
        }
        default:
            break;
    }
}

- (void)clearChangeWithActionType:(BtnOnClickActionType)type{
    if (_currentActionType == type) {
        return;
    }
    _currentActionType = type;
    switch (type) {
        case BtnOnClickActionType_waitToPass:{  //待审核
            [self setNormalPosition];
            [self.waitVC setTableViewTop];
        }
            break;
        case BtnOnClickActionType_hire:{    //招聘中
            [self setNormalPosition];
            [self.hireVC setTableViewTop];
        }
            break;
        case BtnOnClickActionType_HireOff:{ //已结束
            [self setNormalPosition];
            [self.endVC setTableViewTop];
        }
            break;
        default:
            break;
    }
}

- (void)setNormalPosition{
    if (self.headerView.y == 0) {
        return;
    }
    [self clearHeaderPosition];
}

- (void)clearHeaderPosition{
    self.scrollViewHeight = self.scrollViewOrignHeight;
    self.scrollView.contentSize = CGSizeMake(SCREEN_WIDTH * 3, self.scrollViewHeight);
    [UIView animateWithDuration:0.2f animations:^{
        self.headerView.y = 0;
        self.scrollView.height = self.scrollViewHeight;
        self.scrollView.y = self.scrollViewY;
        self.currectScrollViewOffsetY = 0;
    }];
}

#pragma mark - 发布岗位业务方法

- (void)actionOnClick:(MKBlock)block{
    WEAKSELF
    [[UserData sharedInstance] userIsLogin:^(id obj){
        if (obj) {
            MKBlockExec(block, nil);
            [weakSelf pushToPostJobVC];
        }
    }];
}

- (void)pushToPostJobVC{
    PostJob_VC* vc = [[PostJob_VC alloc] init];
    vc.postJobType = PostJobType_common;
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)postSalaryJob{
    [TalkingData trackEvent:@"首页_招人神器"];
    [[UserData sharedInstance] userIsLogin:^(id result) {
        if (result) {
            if (![XSJUserInfoData isReviewAccount]) {
                if (![[UserData sharedInstance] isEnableVipService]) {
                    JobVasOrder_VC *vc = [[JobVasOrder_VC alloc] init];
                    vc.isShowZhaoRenTitle = YES;
                    vc.hidesBottomBarWhenPushed = YES;
                    [self.navigationController pushViewController:vc animated:YES];
                }else{
                    HireServiceIntro_VC *vc = [[HireServiceIntro_VC alloc] init];
                    vc.hidesBottomBarWhenPushed = YES;
                    [self.navigationController pushViewController:vc animated:YES];
                }
            }else{
                WebView_VC *viewCtrl = [[WebView_VC alloc] init];
                NSString *url = [NSString stringWithFormat:@"%@%@", URL_HttpServer, KUrl_toPostServiceInfoPage];
                viewCtrl.url = url;
                viewCtrl.isPopToRootVC = YES;
                viewCtrl.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:viewCtrl animated:YES];
            }
        }
    }];
    
}

- (void)viewInsuranceList{
    [[UserData sharedInstance] userIsLogin:^(id result) {
        if (result) {
            MyInsuranceList_VC *viewCtrl = [[MyInsuranceList_VC alloc] init];
            viewCtrl.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:viewCtrl animated:YES];
        }
    }];
}

- (void)enterRecuitVC{
    HiringJobList_VC *viewCtrl = [[HiringJobList_VC alloc] init];
    viewCtrl.model = self.recruitJobNumInfo;
    viewCtrl.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:viewCtrl animated:YES];
}

#pragma mark - KVO
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    if ([keyPath isEqualToString:@"scrollViewY"]) {
        self.headerView.height = self.scrollViewY;
        self.scrollView.contentSize = CGSizeMake(SCREEN_WIDTH * 3, self.scrollViewOrignHeight);
    }
    if ([keyPath isEqualToString:@"scrollViewOrignHeight"]) {
        self.scrollView.contentSize = CGSizeMake(SCREEN_WIDTH * 3, self.scrollViewOrignHeight);
        self.scrollView.y = self.scrollViewY;
    }
    
    if ([keyPath isEqualToString:@"scrollViewHeight"]) {
        self.scrollView.contentSize = CGSizeMake(SCREEN_WIDTH * 3, self.scrollViewHeight);
        self.scrollView.height = self.scrollViewHeight;
        if (_endView) {
            _endView.height = self.scrollViewHeight;
        }
        if (_waitView) {
            _waitView.height = self.scrollViewHeight;
        }
        
        if (_hireView) {
            _hireView.height = self.scrollViewHeight;
        }
    }
}

#pragma mark - 引导业务
- (void)showGuide{
    if ([[UserData sharedInstance] isHasShowPostJobGuide]) {
        return;
    }
    [[UserData sharedInstance] sethasShowPostJobGuide];
    
    WEAKSELF
    GuideMaskView *maskView = [[GuideMaskView alloc] initWithTitle:@"由此开始兼职招聘" content:@"马上发布兼职岗位，等待海量兼客来报名" cancel:@"取消" commit:@"马上试试" block:^(NSInteger index) {
        switch (index) {
            case 0:{
                ELog(@"阿标是阿傻,傻逼叫阿彪!");
            }
                break;
            case 1:{
                [weakSelf actionOnClick:nil];
            }
                break;
            default:
                break;
        }
    }];
    
    UIView *leftLine = [[UIView alloc] init];
    leftLine.backgroundColor = [UIColor whiteColor];
    
    UIView *botLine = [[UIView alloc] init];
    botLine.backgroundColor = [UIColor whiteColor];
    
    UIView *roundLine = [[UIView alloc] init];
    roundLine.backgroundColor = [UIColor whiteColor];
    [roundLine setCornerValue:5.0f];
    
    [maskView addSubview:leftLine];
    [maskView addSubview:botLine];
    [maskView addSubview:roundLine];
    [maskView sendSubviewToBack:leftLine];
    
    [leftLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(maskView).offset((SCREEN_WIDTH / 3));
        make.top.equalTo(maskView).offset(64 + 35);
        make.width.equalTo(@2);
        make.bottom.equalTo(maskView.mas_centerY);
    }];
    
    [botLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(leftLine);
        make.width.equalTo(@(SCREEN_WIDTH / 6));
        make.height.equalTo(@2);
    }];
    
    
    [roundLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(botLine.mas_right).offset(-10);
        make.centerY.equalTo(botLine);
        make.width.height.equalTo(@10);
    }];
    
    [maskView show];

}

- (void)showGuideManage{
    if ([[UserData sharedInstance] isHasShowJobManageGuide]) {
        return;
    }
    [[UserData sharedInstance] sethasShowJobManageGuide];
    WEAKSELF
    GuideMaskView *maskView = [[GuideMaskView alloc] initWithTitle:@"由此开始管理" content:@"点击岗位列表，进入「兼职管理」" cancel:nil commit:@"我知道啦" block:^(NSInteger index) {
    }];
    
    UIView *leftLine = [[UIView alloc] init];
    leftLine.backgroundColor = [UIColor whiteColor];
    
    UIView *botLine = [[UIView alloc] init];
    botLine.backgroundColor = [UIColor whiteColor];
    
    UIView *roundLine = [[UIView alloc] init];
    roundLine.backgroundColor = [UIColor whiteColor];
    [roundLine setCornerValue:5.0f];
    
    [maskView addSubview:leftLine];
    [maskView addSubview:botLine];
    [maskView addSubview:roundLine];
    [maskView sendSubviewToBack:leftLine];
    
    [leftLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(maskView).offset((SCREEN_WIDTH / 16));
        make.height.equalTo(@2);
        make.width.equalTo(@(SCREEN_WIDTH / 16));
        make.centerY.equalTo(maskView);
    }];
    
    [botLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(leftLine);
        make.width.equalTo(@2);
        make.height.equalTo(@100);
    }];
    
    
    [roundLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(botLine.mas_bottom);
        make.centerX.equalTo(botLine);
        make.width.height.equalTo(@10);
    }];

    
    [maskView show];
}

- (void)showAd{
    if ([UserData sharedInstance].isHasInAppWithAD) {
        return;
    }
    [UserData sharedInstance].isHasInAppWithAD = YES;
    [GuideUIManager showGuideWithType:GuideUIType_EPHomeScrollAd block:^(GuideView *guideView, AdModel *model) {
        if (guideView && model) {
            if (model.ad_detail_url || model.ad_detail_url.length > 4) {
                [[XSJRequestHelper sharedInstance] queryAdClickLogRecordWithADId:model.ad_id];
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:model.ad_detail_url]];
            }
            
            // 1:应用内打开链接 2:岗位广告  3:浏览器打开链接 4:专题类型
            switch (model.ad_type.intValue) {
                case 1:{
                    if (model.ad_detail_url == nil || model.ad_detail_url.length < 5) {
                        return;
                    }
                    model.ad_detail_url = [model.ad_detail_url stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
                    WebView_VC* vc = [[WebView_VC alloc] init];
                    vc.url = model.ad_detail_url;
                    vc.title = model.ad_name;
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
                default:
                    break;
            }
        }
    }];
}

#pragma mark - 懒加载

- (UIView *)waitView{
    if (!_waitView) {
        WaitPassJob_VC *viewCtrl = [[WaitPassJob_VC alloc] init];
        [self addChildViewController:viewCtrl];
        [self.scrollView addSubview:viewCtrl.view];
        viewCtrl.delegate = self;
        _waitVC = viewCtrl;
        
        _waitView = viewCtrl.view;
        _waitView.frame = CGRectMake(0, 0, SCREEN_WIDTH, self.scrollViewHeight);

    }
    return _waitView;
}

- (UIView *)hireView{
    if (!_hireView) {
        JobManage_VC *viewCtrl = [[JobManage_VC alloc] init];
        [self addChildViewController:viewCtrl];
        [self.scrollView addSubview:viewCtrl.view];
        viewCtrl.delegate = self;
        _hireVC = viewCtrl;

        _hireView = viewCtrl.view;
        _hireView.frame = CGRectMake(SCREEN_WIDTH, 0, SCREEN_WIDTH, self.scrollViewHeight);
    }
    return _hireView;
}

- (UIView *)endView{
    if (!_endView) {
        HireOffJob_VC *viewCtrl = [[HireOffJob_VC alloc] init];
        [self addChildViewController:viewCtrl];
        [self.scrollView addSubview:viewCtrl.view];
        viewCtrl.delegate = self;
        _endVC = viewCtrl;

        _endView = viewCtrl.view;
        _endView.frame = CGRectMake(SCREEN_WIDTH * 2, 0, SCREEN_WIDTH, self.scrollViewHeight);
    }
    return _endView;
}

- (void)dealloc{
    [WDNotificationCenter removeObserver:self];
    [self removeObserver:self forKeyPath:@"scrollViewHeight"];
    [self removeObserver:self forKeyPath:@"scrollViewY"];
    [self removeObserver:self forKeyPath:@"scrollViewOrignHeight"];
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
