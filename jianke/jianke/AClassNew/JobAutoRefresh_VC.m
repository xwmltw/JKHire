//
//  JobAutoRefresh_VC.m
//  JKHire
//
//  Created by yanqb on 2017/4/19.
//  Copyright © 2017年 xianshijian. All rights reserved.
//

#import "JobAutoRefresh_VC.h"
#import "JKAppreciteCell.h"
#import "JobVasCell_Three.h"
#import "PaySelect_VC.h"
#import "JKAppreciteCell_Job.h"
#import "AppreciateChooseJob_VC.h"
#import "PostJob_VC.h"
#import "JobModel.h"
#import "WebView_VC.h"

@interface JobAutoRefresh_VC () <UIPickerViewDataSource, UIPickerViewDelegate, JKAppreciteCell_JobDelegate>

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

@implementation JobAutoRefresh_VC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [WDNotificationCenter addObserver:self selector:@selector(backAction) name:WDNotification_backFromMoneyBag object:nil];
    self.isEditable = (self.jobId) ? NO: YES;
    [self addObserver:self forKeyPath:@"selectedModel" options:NSKeyValueObservingOptionNew context:nil];
    self.title = @"刷新推广";
    
    self.pickerDataSource = [NSMutableArray array];
    self.tableViewStyle = UITableViewStyleGrouped;
    self.btntitles = @[@"去付款"];
    self.marginTopY = 48;
    self.marginTop = 48;
    [self initUIWithType:DisplayTypeTableViewAndLeftRightBottom];
    self.bottomView.hidden = YES;
    
    self.refreshType = RefreshTypeHeader;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerNib:nib(@"JKAppreciteCell") forCellReuseIdentifier:@"JKAppreciteCell"];
    [self.tableView registerNib:nib(@"JKAppreciteCell_Job") forCellReuseIdentifier:@"JKAppreciteCell_Job"];
    [self.tableView registerNib:nib(@"JobVasCell_Three") forCellReuseIdentifier:@"JobVasCell_Three"];
    
    [self initWithNoDataViewWithStr:@"数据加载失败，请下拉重试~" onView:self.tableView];
    self.viewWithNoData.y += 50;
    [self getData:YES];
}

- (void)headerRefresh{
    [self getData:NO];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (!self.dataSource.count) {
        return 0;
    }
    NSInteger count = self.dataSource.count;
    return count + 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 1;
    }
    NSArray *array = self.dataSource[section - 1];
    return array.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.section) {
        case 0:{
            JKAppreciteCell_Job *cell = [tableView dequeueReusableCellWithIdentifier:@"JKAppreciteCell_Job" forIndexPath:indexPath];
            cell.delegate = self;
            [cell setModel:self.job_title cellType:Appreciation_Refresh_Type isEditable:self.isEditable ];
            return cell;
        }
        case 3:{
            NSArray *array = [self.dataSource objectAtIndex:indexPath.section - 1];
            JobVasModel *model = [array objectAtIndex:indexPath.row];
            JobVasCell_Three *cell = [tableView dequeueReusableCellWithIdentifier:@"JobVasCell_Three" forIndexPath:indexPath];
            [cell setData:model];
            return cell;
        }
        default:
            break;
    }
    
    NSArray *array = [self.dataSource objectAtIndex:indexPath.section - 1];
    JKAppreciteCell *cell = [tableView dequeueReusableCellWithIdentifier:@"JKAppreciteCell" forIndexPath:indexPath];
    JobVasModel *model = [array objectAtIndex:indexPath.row];
    [cell setData:model];
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    switch (section) {
        case 1:{
            UIView *view = [[UIView alloc] init];
            view.backgroundColor = [UIColor XSJColor_newGray];
            UILabel *lab = [UILabel labelWithText:@"建议使用智能刷新" textColor:[UIColor XSJColor_tGrayDeepTransparent48] fontSize:18.0f];
            
            UILabel *labSubTitle = [UILabel labelWithText:@"方案一：每天1次，定点刷新" textColor:[UIColor XSJColor_base] fontSize:16.0f];
            UILabel *labDate = [UILabel labelWithText:@"以购买时间为准，系统到点自动刷新" textColor:[UIColor XSJColor_tGrayDeepTransparent48] fontSize:13.0f];
            labDate.numberOfLines = 0;

            [view addSubview:lab];
            [view addSubview:labSubTitle];
            [view addSubview:labDate];
            
            [lab mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(view).offset(16);
                make.top.equalTo(view).offset(16);
            }];
            
            [labSubTitle mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(lab.mas_bottom).offset(16);
                make.left.equalTo(view).offset(16);
                make.right.equalTo(view).offset(-16);
            }];
            
            [labDate mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(labSubTitle.mas_bottom).offset(8);
                make.left.equalTo(view).offset(16);
                make.right.equalTo(view).offset(-16);
            }];
            return view;
        }
        case 2:{
            UIView *view = [[UIView alloc] init];
            view.backgroundColor = [UIColor XSJColor_newGray];
            
            UILabel *labSubTitle = [UILabel labelWithText:@"方案二：每天2次，提高刷新频率" textColor:[UIColor XSJColor_base] fontSize:16.0f];
            UILabel *labDate = [UILabel labelWithText:@"购买之后立即执行第一次刷新，隔6小时刷新第二次" textColor:[UIColor XSJColor_tGrayDeepTransparent48] fontSize:13.0f];
            labDate.numberOfLines = 0;
            
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            [button setImage:[UIImage imageNamed:@"tanhao_icon"] forState:UIControlStateNormal];
            [button addTarget:self action:@selector(questionMoreOnClick:) forControlEvents:UIControlEventTouchUpInside];
            
            [view addSubview:labSubTitle];
            [view addSubview:labDate];
            [view addSubview:button];
            
            [labSubTitle mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(view).offset(20);
                make.left.equalTo(view).offset(16);
                make.right.equalTo(view).offset(-16);
            }];
            
            [labDate mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(labSubTitle.mas_bottom).offset(8);
                make.left.equalTo(view).offset(16);
                make.right.equalTo(view).offset(-32);
            }];
            
            [button mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(labSubTitle.mas_bottom).offset(8);
                make.right.equalTo(view).offset(-16);
            }];
            return view;
        }
        case 3:{
            UIView *view = [[UIView alloc] init];
            return view;
        }
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 1) {
        return 121.0f;
    }else if (section == 2){
        return 98.0f;
    }
    return 0.01f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
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
    [self.dataSource enumerateObjectsUsingBlock:^(NSArray*  _Nonnull array, NSUInteger idx, BOOL * _Nonnull stop) {
        [array enumerateObjectsUsingBlock:^(JobVasModel*  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            obj.selected = NO;
        }];
    }];
    self.selectedModel = [[self.dataSource objectAtIndex:indexPath.section - 1] objectAtIndex:indexPath.row];
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

            [self showAlertForPay];
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
    
    WEAKSELF
    [[XSJRequestHelper sharedInstance] entRechargeJobVas:self.jobId totalAmount:self.selectedModel.rechargePrice orderType:self.selectedModel.serviceType oderId:self.selectedModel.id block:^(ResponseInfo *result) {
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
    [MKAlertView alertWithTitle:nil message:@"确认使用刷新推广特权吗？" cancelButtonTitle:@"确认" confirmButtonTitle:@"取消" completion:^(UIAlertView *alertView, NSInteger buttonIndex) {
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
    self.selectedDay = @"1";
    if (self.selectedModel.serviceType.integerValue == 4 && self.selectedModel.refresh_days.integerValue) {
        if (self.selectedModel.refresh_type.integerValue == 1) {
            self.selectedDay = self.selectedModel.refresh_days.description;
        }else if (self.selectedModel.refresh_type.integerValue == 2){
            self.selectedDay = [NSString stringWithFormat:@"%ld", self.selectedModel.refresh_days.integerValue * 2];
        }
    }
    [[XSJRequestHelper sharedInstance] entUseJobVipSpreadWithJobId:self.jobId spreadType:self.selectedModel.serviceType spreadNum:self.selectedDay classfyId:nil idList:nil vasOrderVasId:self.selectedModel.id block:^(ResponseInfo *response) {
        if (response) {
            [UIHelper toast:@"推广成功"];
            [WDNotificationCenter postNotificationName:WDNotification_backFromMoneyBag object:nil];
        }
    }];
}

#pragma mark  - 其他



- (void)getData:(BOOL)isShowLoding{
    WEAKSELF
    [[XSJRequestHelper sharedInstance] queryJobVasListLoading:isShowLoding cityId:[UserData sharedInstance].city.id jobId:self.jobId block:^(ResponseInfo *response) {
        [weakSelf.tableView.header endRefreshing];
        [weakSelf setTableHeaderViewWithResponse:response];
        if (response) {
            weakSelf.job_title = [response.content objectForKey:@"job_title"];
            weakSelf.viewWithNoData.hidden = YES;
            NSArray *result = [JobVasModel objectArrayWithKeyValuesArray:[response.content objectForKey:@"job_refresh_vas_list"]];
            [result setValue:@(Appreciation_Refresh_Type) forKey:@"serviceType"];
            
            NSArray *autoArrResult = [JobVasModel objectArrayWithKeyValuesArray:[response.content objectForKey:@"job_intelligent_refresh_vas_list"]];
            [autoArrResult setValue:@(Appreciation_autoRefresh_Type) forKey:@"serviceType"];
            
            [weakSelf.dataSource removeAllObjects];
            [weakSelf filterArrWith:autoArrResult block:^(NSArray* array) {
                [weakSelf.dataSource addObjectsFromArray:array];
            }];
            [weakSelf.dataSource addObject:result];
            [weakSelf.dataSource enumerateObjectsUsingBlock:^(NSArray*  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if (obj.count) {
                    weakSelf.selectedModel = obj.firstObject;
                    *stop = YES;
                    return;
                }
            }];
            weakSelf.selectedModel.selected = YES;
            [weakSelf.tableView reloadData];
        }else{
            self.viewWithNoData.hidden = NO;
        }
    }];
}

- (void)filterArrWith:(NSArray *)array block:(MKBlock)block{
    NSPredicate *preciate2 = [NSPredicate predicateWithFormat:@"refresh_type = 2"];
    NSArray *refreshType2Arr = [array filteredArrayUsingPredicate:preciate2];
    
    NSPredicate *preciate1 = [NSPredicate predicateWithFormat:@"refresh_type = 1"];
    NSArray *refreshType1Arr = [array filteredArrayUsingPredicate:preciate1];
    
    NSMutableArray *mutiArr = [NSMutableArray array];
    [mutiArr addObject:refreshType1Arr];
    [mutiArr addObject:refreshType2Arr];
    MKBlockExec(block, mutiArr);
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

- (void)setTabeleHeaderViewWithIsCanUseVip:(BOOL)isCanUseVipSpread withResponse:(ResponseInfo *)response{
    NSString *titleOfTableHeaderView = @"";
    NSMutableAttributedString *attStr = nil;
    [self getPickerDataSource];
    if (isCanUseVipSpread) {
        NSDictionary *vipInfo = [response.content objectForKey:@"vip_spread_info"];
        self.btntitles = @[@"直接购买", @"使用特权推广"];
        [self setupBotViews];
        self.leftDays = [[vipInfo objectForKey:@"can_refresh_num"] integerValue];
        titleOfTableHeaderView = [NSString stringWithFormat:@"您还有%ld次刷新推广特权。推荐使用智能刷新！", [[vipInfo objectForKey:@"can_refresh_num"] integerValue]];
        attStr = [[NSMutableAttributedString alloc] initWithString:titleOfTableHeaderView attributes:@{NSForegroundColorAttributeName: [UIColor XSJColor_base], NSFontAttributeName: [UIFont systemFontOfSize:14.0f]}];
        [attStr addAttributes:@{NSForegroundColorAttributeName: [UIColor XSJColor_middelRed]} range:[titleOfTableHeaderView rangeOfString:[NSString stringWithFormat:@"%ld", [[vipInfo objectForKey:@"can_refresh_num"] integerValue]]]];
    }else{
        self.btntitles = @[@"去付款"];
        [self setupBotViews];
        self.btn = self.bottomBtns[0];
        titleOfTableHeaderView = @"推荐使用智能刷新，重复工作由系统代劳！省时省力更省钱，岗位更新快，效果更明显！";
        attStr = [[NSMutableAttributedString alloc] initWithString:titleOfTableHeaderView attributes:@{NSForegroundColorAttributeName: [UIColor XSJColor_base], NSFontAttributeName: [UIFont systemFontOfSize:14.0f]}];
        [attStr addAttributes:@{NSForegroundColorAttributeName: MKCOLOR_RGB(240, 170, 21)} range:[titleOfTableHeaderView rangeOfString:@"更省钱"]];
        [attStr addAttributes:@{NSForegroundColorAttributeName: MKCOLOR_RGB(240, 170, 21)} range:[titleOfTableHeaderView rangeOfString:@"更新快"]];
        [attStr addAttributes:@{NSForegroundColorAttributeName: MKCOLOR_RGB(240, 170, 21)} range:[titleOfTableHeaderView rangeOfString:@"更明显"]];
    }
    
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
    UILabel *label = [UILabel labelWithText:titleOfTableHeaderView textColor:[UIColor XSJColor_base] fontSize:14.0f];
    label.attributedText = attStr;
    label.numberOfLines = 0;
    
    [bgView addSubview:label];
    [topView addSubview:imgHead];
    [topView addSubview:lab];
    [topView addSubview: bgView];
    
    if (isCanUseVipSpread) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setImage:[UIImage imageNamed:@"tanhao_icon"] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(helpOnClick:) forControlEvents:UIControlEventTouchUpInside];
        [bgView addSubview:button];
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(bgView).offset(6);
            make.right.equalTo(bgView).offset(-2);
        }];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(bgView).offset(2);
            make.right.equalTo(bgView).offset(-18);
            make.top.equalTo(bgView).offset(8);
        }];
        height += ([label contentSizeWithWidth:SCREEN_WIDTH - 54].height + 24);
    }else{
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(bgView).offset(2);
            make.right.equalTo(bgView).offset(-2);
            make.top.equalTo(bgView).offset(8);
        }];
        height += ([label contentSizeWithWidth:SCREEN_WIDTH - 38].height + 24);
    }
    
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
    
    
    
    
    topView.height = height;
    
    self.tableView.tableHeaderView = topView;
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

- (void)questionMoreOnClick:(UIButton *)sender{
    [MKAlertView alertWithTitle:@"提示" message:@"刷新规则：\n1.购买之后立即执行第一次刷新，隔6小时刷新第二次。\n2.如购买多天，则按照第一天的时间点重复进行。例：\n您在2017.04.01  11:00 购买了3天，刷新时间如下：\n2017.04.01  11:00    第一次\n2017.04.01  17:00    第二次\n 2017.04.02  11:00    第三次\n 2017.04.02  17:00    第四次\n 2017.04.03  11:00    第五次\n2017.04.03  17:00    第六次\n3.系统会以您购买的刷新次数为依据，次数使用完后，刷新动作停止。如购买时间超过18:00，会顺延至第二日执行第二次刷新。" cancelButtonTitle:nil confirmButtonTitle:@"我知道了" completion:nil];
}

- (void)helpOnClick:(UIButton *)sender{
    [MKAlertView alertWithTitle:nil message:@"推荐使用智能刷新，重复工作由系统代劳！省时省力更省钱，岗位更新快，效果更明显！" cancelButtonTitle:nil confirmButtonTitle:@"我知道了" completion:nil];
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
