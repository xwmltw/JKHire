 //
//  JianKeAppreciation_VC.m
//  jianke
//
//  Created by fire on 16/9/23.
//  Copyright © 2016年 xianshijian. All rights reserved.
//

#import "JianKeAppreciation_VC.h"
#import "JKAppreciteCell.h"
#import "PaySelect_VC.h"
#import "JKAppreciteCell_Job.h"
#import "AppreciateChooseJob_VC.h"
#import "PostJob_VC.h"
#import "JobModel.h"
#import "WebView_VC.h"

@interface JianKeAppreciation_VC () <UIPickerViewDataSource, UIPickerViewDelegate, JKAppreciteCell_JobDelegate>

@property (nonatomic, strong) JobVasModel *selectedModel;   /*!< 需要支付的模型 */
@property (nonatomic, assign) NSInteger leftDays;   //推广可用剩余天数/次数
@property (nonatomic, assign) NSInteger canBuyleftDays;   //置顶推广可用剩余天数(考虑岗位到期的 可能并非真实推广剩余天数)
@property (nonatomic, strong) NSMutableArray *pickerDataSource;   //弹窗天数
@property (nonatomic, copy) NSString *selectedDay;
@property (nonatomic, copy) NSNumber *job_dead_time;    //岗位结束时间
@property (nonatomic, copy) NSString *job_title;    //岗位标题
@property (nonatomic, weak) UIButton *btn;

@property (nonatomic, copy) NSArray *jobList;
@property (nonatomic, assign) BOOL isEditable;  //是否可编辑

@end

@implementation JianKeAppreciation_VC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [WDNotificationCenter addObserver:self selector:@selector(backAction) name:WDNotification_backFromMoneyBag object:nil];
    self.isEditable = (self.jobId) ? NO: YES;
    [self addObserver:self forKeyPath:@"selectedModel" options:NSKeyValueObservingOptionNew context:nil];
    
    if (self.serviceType == Appreciation_stick_Type) {
        self.title = @"置顶推广";
    }else if (self.serviceType == Appreciation_push_Type){
        self.title = @"推送推广";
    }else if (self.serviceType == Appreciation_Refresh_Type){
        self.title = @"刷新推广";
    }
    
    self.pickerDataSource = [NSMutableArray array];
    self.tableViewStyle = UITableViewStyleGrouped;
    self.btntitles = @[@"去付款"];
    self.marginTopY = 48;
    self.marginTop = 48;
    [self initUIWithType:DisplayTypeTableViewAndLeftRightBottom];
    self.bottomView.hidden = YES;
    [self setupBotViews];
    self.refreshType = RefreshTypeHeader;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerNib:nib(@"JKAppreciteCell") forCellReuseIdentifier:@"JKAppreciteCell"];
    [self.tableView registerNib:nib(@"JKAppreciteCell_Job") forCellReuseIdentifier:@"JKAppreciteCell_Job"];

    [self initWithNoDataViewWithStr:@"数据加载失败，请下拉重试~" onView:self.tableView];
    self.viewWithNoData.y += 50;
    [self getData:YES];
}

- (void)setupBotViews{
    self.bottomView.backgroundColor = [UIColor whiteColor];
    
    UILabel *lab = [UILabel labelWithText:@"*" textColor:[UIColor XSJColor_middelRed] fontSize:12.0f];
    UILabel *lab1 = [UILabel labelWithText:@"购买套餐即表示已阅读并同意" textColor:[UIColor XSJColor_tGrayDeepTransparent32] fontSize:12.0f];
    UIButton *btn = [UIButton buttonWithTitle:@"《增值服务协议》" bgColor:nil image:nil target:self sector:@selector(btnOnClick:)];
    NSAttributedString *arrStr = [[NSAttributedString alloc] initWithString:@"《增值服务协议》" attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:12.0f], NSForegroundColorAttributeName: [UIColor XSJColor_tGrayDeepTransparent80], NSUnderlineStyleAttributeName: @(NSUnderlineStyleSingle)}];
    [btn setAttributedTitle:arrStr forState:UIControlStateNormal];
    
    [self.bottomView addSubview:lab];
    [self.bottomView addSubview:lab1];
    [self.bottomView addSubview:btn];
    
    [lab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bottomView).offset(16);
        make.top.equalTo(self.bottomView).offset(16);
    }];
    
    [lab1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(lab.mas_right);
        make.centerY.equalTo(lab);
    }];
    
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(lab1.mas_right);
        make.centerY.equalTo(lab1);
    }];
    
    [self.bottomView addBorderInDirection:BorderDirectionTypeTop borderWidth:0.7f borderColor:[UIColor XSJColor_clipLineGray] isConstraint:YES];
}

- (void)headerRefresh{
    [self getData:NO];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (!self.dataSource.count) {
        return 0;
    }
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 1;
    }
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.section) {
        case 0:{
            JKAppreciteCell_Job *cell = [tableView dequeueReusableCellWithIdentifier:@"JKAppreciteCell_Job" forIndexPath:indexPath];
            cell.delegate = self;
            [cell setModel:self.job_title cellType:self.serviceType isEditable:self.isEditable ];
            return cell;
        }
        default:
            break;
    }
    JKAppreciteCell *cell = [tableView dequeueReusableCellWithIdentifier:@"JKAppreciteCell" forIndexPath:indexPath];
    JobVasModel *model = [self.dataSource objectAtIndex:indexPath.row];
    [cell setData:model];
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section == 1) {
        UIView *view = [[UIView alloc] init];
        view.backgroundColor = [UIColor XSJColor_newGray];
        NSString *title = nil;
        switch (self.serviceType) {
            case Appreciation_stick_Type:
                title = @"岗位置顶价格(必选项)";
                break;
            case Appreciation_Refresh_Type:
                title = @"岗位刷新价格(必选项)";
                break;
            default:
                break;
        }
        UILabel *lab = [UILabel labelWithText:title textColor:[UIColor XSJColor_tGrayDeepTransparent48] fontSize:18.0f];
        [view addSubview:lab];
        [lab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(view).offset(16);
            make.centerY.equalTo(view);
        }];
        return view;
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 1) {
        return 65.0f;
    }
    return 0.01f;
}

#pragma mark - uitableview delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        if (self.job_title) {
            return 120.0f;
        }else{
            return 52.0f;
        }
    }
    return 70.0f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return;
    }
    
    NSArray *result = [self.dataSource filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"selected == YES"]];
        
    [result setValue:[[NSNumber alloc] initWithBool:NO] forKey:@"selected"];
    self.selectedModel = [self.dataSource objectAtIndex:indexPath.row];
    self.selectedModel.selected = YES;
    [self.tableView reloadData];
}

#pragma mark - uipickerview datasource

// returns the number of 'columns' to display.
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}

// returns the # of rows in each component..
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return self.pickerDataSource.count;
}

- (nullable NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    NSString *title = [self.pickerDataSource objectAtIndex:row];
    return title;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    NSString *title = [self.pickerDataSource objectAtIndex:row];
    self.selectedDay = title;
}

#pragma mark - JKAppreciteCell_JobDelegate
- (void)jkAppreciteCell:(JKAppreciteCell_Job *)cell{
    
    WEAKSELF
    [self getJobList:^(NSArray *dataList) { //获取并筛选岗位
        if (!dataList.count) {  //弹窗引导发布
            [self showAlertForPostJob];
        }else{
            weakSelf.jobList = dataList;
            AppreciateChooseJob_VC *vc = [[AppreciateChooseJob_VC alloc] init];
            if ([self.title isEqualToString:@"置顶推广"]) {
                vc.iszhiding = YES;
            }
            [vc.dataSource addObjectsFromArray:dataList];
            if (self.jobId) {
                vc.jobId = @(self.jobId.integerValue);
            }
            WEAKSELF
            vc.block = ^(JobModel *jobModel){
                if (jobModel) {
                    weakSelf.jobId = jobModel.job_id.description;
                    weakSelf.job_title = jobModel.job_title;
                    [weakSelf.tableView reloadData];
                }
            };
            [self.navigationController pushViewController:vc animated:YES];
        }
    }];
    
   
}

- (NSArray *)fileterJobList:(NSArray *)jobList{
    if (!jobList) {
        return jobList;
    }
    NSPredicate *preciate = [NSPredicate predicateWithFormat:@"job_type == 1"];
    NSArray *array = [jobList filteredArrayUsingPredicate:preciate];
    return array;
}

- (void)getJobList:(MKBlock)block{
    
    if (self.jobList) {
        MKBlockExec(block, self.jobList);
        return;
    }
    
    GetEnterpriscJobModel *reqModel= [[GetEnterpriscJobModel alloc] init];
    reqModel.query_param = [[QueryParamModel alloc] init];
    reqModel.query_type = @4;
    reqModel.job_type = @1;
    WEAKSELF
    [[XSJRequestHelper sharedInstance] getEnterpriseSelfJobList:reqModel block:^(ResponseInfo *response) {
        [weakSelf.tableView.header endRefreshing];
        if (response) {
            NSArray *dataList = [JobModel objectArrayWithKeyValuesArray:response.content[@"job_list"]];
            NSArray *array = [self fileterJobList:dataList];
            MKBlockExec(block, array);
        }
    }];
}

- (void)showAlertForPostJob{
    [MKAlertView alertWithTitle:nil message:@"暂无在招岗位" cancelButtonTitle:@"取消" confirmButtonTitle:@"去发布岗位" completion:^(UIAlertView *alertView, NSInteger buttonIndex) {
        if (buttonIndex == 1) {
            [self postJobAction];
        }
    }];
}

- (void)postJobAction{
    PostJob_VC* vc = [[PostJob_VC alloc] init];
    vc.postJobType = PostJobType_common;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - 重写方法

- (void)clickOnview:(UIView *)bottomView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    switch (buttonIndex) {
        case 0:{
//            [self showPickerView];
            [self makeBuy];
        }
            break;
        case 1:{
            if (!self.jobId) {
                [UIHelper toast:@"请选择要推广的岗位"];
                return;
            }
            
            if (self.leftDays <= 0) {
                [UIHelper toast:@"特权已用完"];
                return;
            }
            
            if ([self jobIsDeadWith:self.job_dead_time]) {
                [UIHelper toast:@"岗位已结束,无法使用推广服务"];
                return;
            }
            
            if (self.serviceType == Appreciation_stick_Type) {
                [self showPickerView];
            }else if(self.serviceType == Appreciation_Refresh_Type){
//                [self showAlertForPay];
                [self payForJobVipSpread];
            }
        }
            break;
        default:
            break;
    }
}

- (void)makeBuy{
    
    if (!self.selectedModel.selected) {
        [UIHelper toast:@"未选择服务套餐"];
        return;
    }
    
    if (!self.jobId) {
        [UIHelper toast:@"请选择要推广的岗位"];
        return;
    }
    
    if (self.serviceType == Appreciation_stick_Type) {
        [[UserData sharedInstance] setIsUpdateWithEPHome:YES];  //置顶付费时要刷新首页
    }
    
    WEAKSELF
    [[XSJRequestHelper sharedInstance] entRechargeJobVas:self.jobId totalAmount:self.selectedModel.rechargePrice orderType:@(self.serviceType) oderId:self.selectedModel.id block:^(ResponseInfo *result) {
        if (result) {
            PaySelect_VC *viewCtrl = [[PaySelect_VC alloc] init];
            viewCtrl.fromType = PaySelectFromType_JobVasOrder;
            viewCtrl.job_vas_order_id = [result.content objectForKey:@"job_vas_order_id"];
            viewCtrl.needPayMoney = weakSelf.selectedModel.rechargePrice.intValue;
            [weakSelf.navigationController pushViewController:viewCtrl animated:YES];
        }
    }];
}

- (void)showAlertForPay{
    [MKAlertView alertWithTitle:nil message:@"确认使用特权推广？" cancelButtonTitle:@"使用" confirmButtonTitle:@"不使用" completion:^(UIAlertView *alertView, NSInteger buttonIndex) {
        if (buttonIndex == 0) {
            [self payForJobVipSpread];
        }
    }];
}

- (void)showPickerView{
    
    if (!self.pickerDataSource.count) {
        [UIHelper toast:@"该岗位招聘时间不足，无法使用推广服务"];
        return;
    }
    
    DLAVAlertView *alertView = [[DLAVAlertView alloc] initWithTitle:@"选择置顶天数" message:nil delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alertView setMinContentWidth:250];
    
    UIView *containerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 250, 130)];
    
    //pickerView
    UIPickerView *pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 0, 250, 100)];
    pickerView.dataSource = self;
    pickerView.delegate = self;
    
    self.selectedDay = @"1";
    
    //日历下方的label
    UILabel *tipLab = [[UILabel alloc]initWithFrame:CGRectMake(8, 110, 200, 20)];
    tipLab.font = [UIFont systemFontOfSize:12];

    tipLab.text = [NSString stringWithFormat:@"还有%ld天置顶特权", self.leftDays];
    [containerView addSubview:tipLab];
    [containerView addSubview:pickerView];

    alertView.contentView = containerView;
    
    //alertView操作
    [alertView showWithCompletion:^(DLAVAlertView *alertView, NSInteger buttonIndex) {
        if (buttonIndex == 1) {
            [self payForJobVipSpread];
        }
    }];
}

- (BOOL)jobIsDeadWith:(NSNumber *)dateNum{
    if (!dateNum) {
        return NO;
    }
    
    NSDate *jobDate = [NSDate dateWithTimeIntervalSince1970:(dateNum.longLongValue / 1000)];
    NSDate *date = [NSDate date];
    
    if ([DateHelper isSameDay:jobDate date2:date]) {
        return NO;
    }else{
        if ([jobDate compare:date] == NSOrderedAscending) {
            return YES;
        }
    }
    
    return NO;
}

- (void)payForJobVipSpread{
    
    if (self.serviceType == Appreciation_stick_Type) {
        [[UserData sharedInstance] setIsUpdateWithEPHome:YES];  //置顶付费时要刷新首页
    }
    
    if (self.serviceType == Appreciation_Refresh_Type) {
        self.selectedDay = @"1";
    }
    
    [[XSJRequestHelper sharedInstance] entUseJobVipSpreadWithJobId:self.jobId spreadType:@(self.serviceType) spreadNum:self.selectedDay classfyId:nil idList:nil block:^(ResponseInfo *response) {
        if (response) {
            [UIHelper toast:@"推广成功"];
            [WDNotificationCenter postNotificationName:WDNotification_backFromMoneyBag object:nil];
        }
    }];
}

#pragma mark  - 其他

- (UIView *)newTopView:(NSString *)title{
    CGFloat height = 57.0f;
    
    UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 10)];
    topView.backgroundColor = MKCOLOR_RGBA(0, 118, 255, 0.03);
    
    UIImageView *imgHead = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"v320_firendly_icon"]];
    
    EPModel *epInfo = [[UserData sharedInstance] getEpModelFromHave];
    NSString *str = nil;
    if (epInfo.true_name.length) {
        str = [NSString stringWithFormat:@"您好，%@", epInfo.true_name];
    }else{
        str = @"您好，兼客";
    }
    UILabel *lab = [UILabel labelWithText:str textColor:[UIColor XSJColor_tGrayDeepTransparent2] fontSize:18.0f];
    
    UIView *bgView = [[UIView alloc] init];
    bgView.backgroundColor = MKCOLOR_RGB(231, 247, 250);
    UILabel *label = [UILabel labelWithText:title textColor:[UIColor XSJColor_base] fontSize:15.0f];
    label.numberOfLines = 0;    
    
    [bgView addSubview:label];
    [topView addSubview:imgHead];
    [topView addSubview:lab];
    [topView addSubview: bgView];
    
    [imgHead mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(topView).offset(16);
        make.centerY.equalTo(lab);
    }];
    
    [lab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(imgHead.mas_right).offset(2);
        make.top.equalTo(topView).offset(24);
    }];
    
    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lab.mas_bottom).offset(8);
        make.left.equalTo(topView).offset(16);
        make.right.equalTo(topView).offset(-16);
        make.bottom.equalTo(label).offset(12);
    }];
    
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(bgView).offset(2);
        make.right.equalTo(bgView).offset(-2);
        make.top.equalTo(bgView).offset(8);
    }];
    
    height += ([label contentSizeWithWidth:SCREEN_WIDTH - 38].height + 24);
    topView.height = height;
    
    return topView;
}

- (void)getData:(BOOL)isShowLoding{
    WEAKSELF
    [[XSJRequestHelper sharedInstance] queryJobVasListLoading:isShowLoding cityId:[UserData sharedInstance].city.id jobId:self.jobId block:^(ResponseInfo *response) {
        [weakSelf.tableView.header endRefreshing];
        [weakSelf setTableHeaderViewWithResponse:response];
        if (response) {
            weakSelf.job_title = [response.content objectForKey:@"job_title"];
            weakSelf.viewWithNoData.hidden = YES;
            NSArray *result = nil;
            switch (weakSelf.serviceType) {
                case Appreciation_stick_Type:
                    result = [JobVasModel objectArrayWithKeyValuesArray:[response.content objectForKey:@"job_top_vas_list"]];
                    [result setValue:@(Appreciation_stick_Type) forKey:@"serviceType"];
                    break;
                case Appreciation_push_Type:
                    result = [JobVasModel objectArrayWithKeyValuesArray:[response.content objectForKey:@"job_push_vas_list"]];
                    [result setValue:@(Appreciation_push_Type) forKey:@"serviceType"];
                    break;
                case Appreciation_Refresh_Type:
                    result = [JobVasModel objectArrayWithKeyValuesArray:[response.content objectForKey:@"job_refresh_vas_list"]];
                    [result setValue:@(Appreciation_Refresh_Type) forKey:@"serviceType"];
                    break;
                default:
                    break;
            }
            weakSelf.selectedModel = result.firstObject;
            weakSelf.selectedModel.selected = YES;
            weakSelf.dataSource = [result mutableCopy];
            [weakSelf.tableView reloadData];
        }else{
            self.viewWithNoData.hidden = NO;
        }
    }];
}

- (void)setTableHeaderViewWithResponse:(ResponseInfo *)response{

    self.bottomView.hidden = NO;
    if (response) {
        NSDictionary *vipInfo = [response.content objectForKey:@"vip_spread_info"];
        if (vipInfo) {
            NSNumber *is_can_use_vip_spread = [vipInfo objectForKey:@"is_can_use_vip_spread"];
            [self setTabeleHeaderViewWithIsCanUseVip:(is_can_use_vip_spread.integerValue == 1) withResponse:response];
        }else{
            [self setTabeleHeaderViewWithIsCanUseVip:NO withResponse:response];
        }
    }else{
        [self setTabeleHeaderViewWithIsCanUseVip:NO withResponse:response];
    }
}

- (void)setTabeleHeaderViewWithIsCanUseVip:(BOOL)isCanUseVipSpread withResponse:(ResponseInfo *)response{
    NSString *titleOfTableHeaderView = @"";
    [self getPickerDataSource];
    if (isCanUseVipSpread) {
        NSDictionary *vipInfo = [response.content objectForKey:@"vip_spread_info"];
        self.btntitles = @[@"直接购买", @"使用特权推广"];
        [self setupBotViews];
        if (self.serviceType == Appreciation_stick_Type) {
            self.leftDays = [[vipInfo objectForKey:@"can_top_days"] integerValue];
            titleOfTableHeaderView = [NSString stringWithFormat:@"您还有%ld天置顶推广特权", self.leftDays];
            NSNumber *dateNum = [response.content objectForKey:@"job_dead_time"];
            self.job_dead_time = [response.content objectForKey:@"job_dead_time"];
            self.canBuyleftDays = [self getDaysFromzerDateWithDateNum:dateNum];
            [self getPickerDataSource];
        }else if (self.serviceType == Appreciation_push_Type){
            titleOfTableHeaderView = [NSString stringWithFormat:@"您还有%ld人推送推广特权", [[vipInfo objectForKey:@"can_push_num"] integerValue]];
        }else if (self.serviceType == Appreciation_Refresh_Type){
            self.leftDays = [[vipInfo objectForKey:@"can_refresh_num"] integerValue];
            titleOfTableHeaderView = [NSString stringWithFormat:@"您还有%ld次刷新推广特权", [[vipInfo objectForKey:@"can_refresh_num"] integerValue]];
        }
    }else{
        self.btntitles = @[@"去付款"];
        [self setupBotViews];
        self.btn = self.bottomBtns[0];
        if (self.serviceType == Appreciation_stick_Type) {
            titleOfTableHeaderView = @"置顶岗位排名在首页，曝光效果提升5倍，快来试试吧!";
        }else if (self.serviceType == Appreciation_push_Type){
            titleOfTableHeaderView = @"精准推送岗位信息给城市中的兼客，招聘效率提升2倍!";
        }else if (self.serviceType == Appreciation_Refresh_Type){
            titleOfTableHeaderView = @"刷新岗位，排名靠前，时间显示最新。获得更多浏览机会!";
        }
    }
    
    self.tableView.tableHeaderView = [self newTopView:titleOfTableHeaderView];
}

- (NSInteger)getDaysFromzerDateWithDateNum:(NSNumber *)dateNum{
    NSDate *jobDeadDete = [NSDate dateWithTimeIntervalSince1970:dateNum.longLongValue / 1000];
    NSDate *zeroDate = [DateHelper zeroTimeOfToday];
    long long canBuyLeftDays = [jobDeadDete timeIntervalSinceDate:zeroDate];
    NSInteger canBuyDays = 0;
    canBuyDays = (canBuyLeftDays / (24 * 60 * 60));
    canBuyDays += 1;
    return (self.leftDays > canBuyDays) ? canBuyDays : self.leftDays ;
}

- (void)getPickerDataSource{
    [self.pickerDataSource removeAllObjects];
    if (self.canBuyleftDays) {
        NSInteger day = 1;
        for (NSInteger index = 0; index < self.canBuyleftDays; index++) {
            [self.pickerDataSource addObject:[NSString stringWithFormat:@"%ld", day]];
            day += 1;
        }
    }
}

- (void)backAction{
    [self.navigationController popToViewController:self.popToVC animated:YES];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    if ([keyPath isEqualToString:@"selectedModel"] && self.btn) {
        JobVasModel *model = [change objectForKey:NSKeyValueChangeNewKey];
        if (model.promotion_price.floatValue > 0) {
            [self.btn setTitle:[NSString stringWithFormat:@"去付款(¥%.2f)", model.promotion_price.floatValue / 100] forState:UIControlStateNormal];
        }else{
            [self.btn setTitle:[NSString stringWithFormat:@"去付款(¥%.2f)", model.price.floatValue / 100] forState:UIControlStateNormal];
        }
    }
}

- (void)btnOnClick:(UIButton *)sender{
    WebView_VC* vc = [[WebView_VC alloc] init];
    vc.url = [NSString stringWithFormat:@"%@%@", URL_HttpServer, KUrl_toValueAddServiceAgreementPage];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)dealloc{
    ELog(@"%@消失了", [self class]);
    [WDNotificationCenter removeObserver:self];
    [self removeObserver:self forKeyPath:@"selectedModel"];
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
