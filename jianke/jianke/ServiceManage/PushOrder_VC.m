//
//  PushOrder_VC.m
//  JKHire
//
//  Created by yanqb on 2016/12/3.
//  Copyright © 2016年 xianshijian. All rights reserved.
//

#import "PushOrder_VC.h"
#import "JKAppreciteCell.h"
#import "ApplyServiceCell_1.h"
#import "PaySelect_VC.h"
#import "BaseButton.h"
#import "JobTypeList_VC.h"
#import "WebView_VC.h"
#import "JobVasOrder_VC.h"
#import "SuccessPushOrder_VC.h"
#import "AppreciateChooseJob_VC.h"
#import "JKAppreciteCell_Job.h"
#import "PostJob_VC.h"
#import "JobModel.h"
#import "MyEnum.h"
#import "WebView_VC.h"

@interface PushOrder_VC () <UIPickerViewDataSource, UIPickerViewDelegate, JKAppreciteCell_JobDelegate>

@property (nonatomic, strong) JobVasModel *selectedModel;   /*!< 需要支付的模型 */
@property (nonatomic, strong) NSMutableArray *tagList;
@property (nonatomic, strong) UIView *footerView;
@property (nonatomic, strong) UIView *tagView;
@property (nonatomic, weak) BaseButton *tagBtn;
@property (nonatomic, strong) JobClassifyInfoModel *jobClassifyInfoModel;

@property (nonatomic, assign) NSInteger leftNum;   //推送可用剩余人数
@property (nonatomic, copy) NSNumber *selectedNum;   //选择的推送人数
@property (nonatomic, strong) NSMutableArray *pickerDataSource;
@property (nonatomic, copy) NSNumber *job_dead_time;    //岗位结束时间
@property (nonatomic, weak) UIButton *btn;

@property (nonatomic, copy) NSString *job_title;    //岗位标题
@property (nonatomic, copy) NSArray *jobList;   //岗位列表
@property (nonatomic, assign) BOOL isEditable;  //是否可编辑

@end

@implementation PushOrder_VC

- (void)viewDidLoad {
    [super viewDidLoad];

    self.isEditable = (self.jobId) ? NO: YES;
    self.tagList = [NSMutableArray array];
    if (self.isShowHistory) {
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"推送记录" style:UIBarButtonItemStylePlain target:self action:@selector(pushToHistory)];
    }
    
    
    [self addObserver:self forKeyPath:@"selectedModel" options:NSKeyValueObservingOptionNew context:nil];
    
    self.pickerDataSource = [NSMutableArray array];
    self.tableViewStyle = UITableViewStyleGrouped;
    self.btntitles = @[@"去推送"];
    self.marginTopY = 48;
    self.marginTop = 48;
    [self initUIWithType:DisplayTypeTableViewAndLeftRightBottom];
    self.title = @"推送推广";
    self.bottomView.hidden = YES;
    self.tableView.tableHeaderView = [self newTopView:@"精准推送岗位信息给城市中的兼客，招聘效率提升2倍!"];
    self.refreshType = RefreshTypeHeader;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerNib:nib(@"JKAppreciteCell") forCellReuseIdentifier:@"JKAppreciteCell"];
    [self.tableView registerNib:nib(@"JKAppreciteCell_Job") forCellReuseIdentifier:@"JKAppreciteCell_Job"];
    [self initWithNoDataViewWithStr:@"数据加载失败，请下拉重试~" onView:self.tableView];
    self.viewWithNoData.y += 50;
    [self getData:YES];
}

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
            NSArray *result = [JobVasModel objectArrayWithKeyValuesArray:[response.content objectForKey:@"job_push_vas_list"]];
            NSArray *tagArr = [FeedbackParam objectArrayWithKeyValuesArray:[response.content objectForKey:@"job_push_label_list"]];
            if (result.count) {
                weakSelf.viewWithNoData.hidden = YES;
                if (result.count >= 2) {
                    weakSelf.selectedModel = result[1];
                    weakSelf.selectedModel.selected = YES;
                }else{
                    weakSelf.selectedModel = result.firstObject;
                    weakSelf.selectedModel.selected = YES;
                }
                [result setValue:@(Appreciation_push_Type) forKey:@"serviceType"];
                weakSelf.dataSource = [result mutableCopy];
                [weakSelf initFooterViewWithArr:tagArr];
                [weakSelf.tableView reloadData];
            }else{
                weakSelf.viewWithNoData.hidden = NO;
            }
        }
    }];
}

- (void)headerRefresh{
    [self getData:NO];
}

- (void)jobTypeOnclick{
    WEAKSELF
    JobTypeList_VC* vc = [[JobTypeList_VC alloc] init];
    vc.postJobType = PostJobType_Push;
    vc.block = ^(JobClassifyInfoModel* model){
        if (model) {
            _jobClassifyInfoModel = model;
            [weakSelf reloadData];
        }
    };
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)reloadData{
    [self.tagBtn setTitle:_jobClassifyInfoModel.job_classfier_name forState:UIControlStateNormal];
}

- (void)initFooterViewWithArr:(NSArray *)tagArr{
    self.tableView.tableFooterView = nil;
    UIView *footerView = [[UIView alloc] init];
    footerView.backgroundColor = [UIColor XSJColor_newGray];
    
    BaseButton *btnType = [BaseButton buttonWithType:UIButtonTypeCustom];
    [btnType setTitle:@"选择和兼客相关联的岗位类型" forState:UIControlStateNormal];
    [btnType setImage:[UIImage imageNamed:@"job_icon_push"] forState:UIControlStateNormal];
    [btnType addTarget:self action:@selector(typeBtnOnClick:) forControlEvents:UIControlEventTouchUpInside];
    btnType.titleLabel.font = [UIFont systemFontOfSize:16.0f];
    [btnType setTitleColor:[UIColor XSJColor_tGrayDeepTinge] forState:UIControlStateNormal];
    [btnType setMarginForImg:-16 marginForTitle:16];
    _tagBtn = btnType;

    UIView *tagView = [[UIView alloc] init];
    UILabel *labTag = [UILabel labelWithText:@"选择您更倾向优先推送的兼客标签" textColor:[UIColor XSJColor_tGrayHistoyTransparent] fontSize:16.0f];
    [tagView addSubview:labTag];
    
    CGFloat width = (SCREEN_WIDTH - 40) / 3;
    CGFloat height = 44;
    UIButton *button = nil;
    NSInteger count = tagArr.count;
    NSInteger row;
    NSInteger column;
    FeedbackParam *tagModel;
    CGFloat tagViewH = 58;
    for (NSInteger index = 0; index < count; index++) {
        tagModel = tagArr[index];
        column = index % 3;
        row = index / 3;
        button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.tag = tagModel.id.integerValue;
        [button setTitle:tagModel.name forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:@"frequent_icon_black_unselected"] forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:@"frequent_icon_black_selected"] forState:UIControlStateSelected];
        [button setTitleColor:[UIColor XSJColor_tGrayDeepTinge] forState:UIControlStateNormal];
        button.backgroundColor = MKCOLOR_RGBA(34, 58, 80, 0.03);
        [button setCornerValue:2.0f];
        [button setBorderWidth:1.0f andColor:[UIColor XSJColor_newWhite]];
        button.titleLabel.font = [UIFont systemFontOfSize:14.0f];
        button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [button setImageEdgeInsets:UIEdgeInsetsMake(0, 8, 0, 0)];
        [button setTitleEdgeInsets:UIEdgeInsetsMake(0, 8, 0, 0)];
        button.frame = CGRectMake(16 + ((width + 4) * column), 58 + ((height + 4) * row), width, height);
        [button addTarget:self action:@selector(tagBtnOnClick:) forControlEvents:UIControlEventTouchUpInside];
        tagViewH = 58 + (height + 4) * row + 44;
        [tagView addSubview:button];
    }
    
    [labTag mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(tagView).offset(24);
        make.left.equalTo(tagView).offset(16);
        make.right.equalTo(tagView).offset(-16);
    }];
    
    [footerView addSubview:btnType];
    [footerView addSubview:tagView];
    [btnType mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(footerView);
        make.left.right.equalTo(footerView);
        make.height.equalTo(@53);
    }];
    
    [btnType addBorderInDirection:BorderDirectionTypeBottom borderWidth:0.7 borderColor:[UIColor XSJColor_clipLineGray] isConstraint:YES];
    
    tagView.frame = CGRectMake(0, 53, SCREEN_WIDTH, tagViewH);
    footerView.height = 53 + tagViewH + 6;
    self.tableView.tableFooterView = footerView;
}

- (void)typeBtnOnClick:(UIButton *)sender{
    [self jobTypeOnclick];
}

- (void)tagBtnOnClick:(UIButton *)sender{
    sender.selected = !sender.selected;
    if (sender.selected) {
        [sender setBorderColor:[UIColor XSJColor_tGrayDeepTinge]];
        [self.tagList addObject:@(sender.tag)];
    }else{
        [sender setBorderColor:[UIColor XSJColor_newWhite]];
        [self.tagList removeObject:@(sender.tag)];
    }
}

#pragma mark - uitableview datasource

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
            [cell setModel:self.job_title cellType:Appreciation_push_Type isEditable:self.isEditable ];
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
        UILabel *lab = [UILabel labelWithText:@"岗位推送价格(必选项)" textColor:[UIColor XSJColor_tGrayDeepTransparent48] fontSize:18.0f];
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
    return 0;
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
    NSString *title = [[self.pickerDataSource objectAtIndex:row] description];
    return title;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    NSNumber *num = [self.pickerDataSource objectAtIndex:row];
    self.selectedNum = num;
}

#pragma mark - 重写方法

- (void)clickOnview:(UIView *)bottomView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    switch (buttonIndex) {
        case 0:{
            //            [self showPickerView];
            self.tagList = [NSMutableArray array];
            [self makeBuy];
        }
            break;
        case 1:{
            [self showPickerView];
        }
            break;
        default:
            break;
    }
}

#pragma mark  - 其他

- (void)makeBuy{
    if (!self.jobId) {
        [UIHelper toast:@"请选择需要推广的岗位"];
        return;
    }
    
    if (!self.selectedModel.selected) {
        [UIHelper toast:@"未选择服务套餐"];
        return;
    }
    
    WEAKSELF
    [[XSJRequestHelper sharedInstance] entRechargeJobVas:self.jobId classifyId:_jobClassifyInfoModel.job_classfier_id tagIds:nil totalAmount:self.selectedModel.rechargePrice orderType:@(3) oderId:self.selectedModel.id block:^(ResponseInfo *result) {
        if (result) {
            PaySelect_VC *viewCtrl = [[PaySelect_VC alloc] init];
            viewCtrl.fromType = (weakSelf.isFromJobManage) ? PaySelectFromType_JobVasPushOrderFromJobManage : PaySelectFromType_JobVasPushOrder;
            viewCtrl.push_num = self.selectedModel.push_num;
            viewCtrl.jobId = @(self.jobId.longLongValue);
            viewCtrl.job_vas_order_id = [result.content objectForKey:@"job_vas_order_id"];
            viewCtrl.needPayMoney = weakSelf.selectedModel.rechargePrice.intValue;
            [weakSelf.navigationController pushViewController:viewCtrl animated:YES];
        }
    }];
}

- (void)showPickerView{
    
    if (!self.jobId) {
        [UIHelper toast:@"请选择需要推广的岗位"];
        return;
    }
    
    if (self.leftNum < 100) {
        [UIHelper toast:@"特权已用完"];
        return;
    }
    
    if ([self jobIsDeadWith:self.job_dead_time]) {
        [UIHelper toast:@"岗位已结束，无法使用推广服务"];
        return;
    }
    
    DLAVAlertView *alertView = [[DLAVAlertView alloc] initWithTitle:@"选择推送人数" message:nil delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alertView setMinContentWidth:250];
    
    UIView *containerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 250, 130)];
    
    //pickerView
    UIPickerView *pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 0, 250, 100)];
    pickerView.dataSource = self;
    pickerView.delegate = self;
    
    self.selectedNum = @100;
    
    //日历下方的label
    UILabel *tipLab = [[UILabel alloc]initWithFrame:CGRectMake(8, 110, 200, 20)];
    tipLab.font = [UIFont systemFontOfSize:12];
    
    tipLab.text = [NSString stringWithFormat:@"还有%ld人推送推广特权", self.leftNum];
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

- (void)payForJobVipSpread{
    WEAKSELF
    [[XSJRequestHelper sharedInstance] entUseJobVipSpreadWithJobId:self.jobId spreadType:@(3) spreadNum:self.selectedNum.description classfyId:_jobClassifyInfoModel.job_classfier_id idList:self.tagList block:^(ResponseInfo *response) {
        if (response) {
            if (weakSelf.isFromJobManage) {
                [weakSelf.navigationController popToRootViewControllerAnimated:YES];
            }else{
                SuccessPushOrder_VC *viewCtrl = [[SuccessPushOrder_VC alloc] init];
                viewCtrl.push_num = weakSelf.selectedNum;
                viewCtrl.jobId = weakSelf.jobId;
                [self.navigationController pushViewController:viewCtrl animated:YES];
            }
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
    NSString *titleOfViewCtrl = @"推送推广";
    self.job_dead_time = [response.content objectForKey:@"job_dead_time"];
    if (isCanUseVipSpread) {
        NSDictionary *vipInfo = [response.content objectForKey:@"vip_spread_info"];
        self.btntitles = @[@"直接购买", @"使用特权推广"];
        [self setupBotViews];
        self.leftNum = [[vipInfo objectForKey:@"can_push_num"] integerValue];
        titleOfViewCtrl = @"推送推广";
        titleOfTableHeaderView = [NSString stringWithFormat:@"您还有%ld人推送推广特权", [[vipInfo objectForKey:@"can_push_num"] integerValue]];
        [self getPickerDataSource];
    }else{
        self.btntitles = @[@"去付款"];
        [self setupBotViews];
        self.btn = self.bottomBtns[0];
        titleOfViewCtrl = @"推送推广";
        titleOfTableHeaderView = @"精准推送岗位信息给城市中的兼客，招聘效率提升2倍!";
    }
    
    self.title = titleOfViewCtrl;
    self.tableView.tableHeaderView = [self newTopView:titleOfTableHeaderView];
}

- (void)getPickerDataSource{
    [self.pickerDataSource removeAllObjects];
    NSInteger count = self.leftNum / 100;
    NSInteger num = 100;
    for (NSInteger index = 0; index < count; index++) {
        [self.pickerDataSource addObject:@(num)];
        num += 100;
    }
}

- (void)pushToHistory{
    WebView_VC* vc = [[WebView_VC alloc] init];
    vc.url = [NSString stringWithFormat:@"%@%@%@", URL_HttpServer, KUrl_jobPushOrderList, self.jobId];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)backToLastView{
    if (self.jumpBackOpen) {
        for (UIViewController *viewCtrl in self.navigationController.childViewControllers) {
            if ([viewCtrl isKindOfClass:[JobVasOrder_VC class]]) {
                [self.navigationController popToViewController:viewCtrl animated:YES];
                return;
            }
        }
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        [self.navigationController popViewControllerAnimated:YES];
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
