//
//  NewBuyInsurance_VC.m
//  JKHire
//
//  Created by yanqb on 2016/11/17.
//  Copyright © 2016年 xianshijian. All rights reserved.
//

#import "NewBuyInsurance_VC.h"
#import "NewBuyInsuranceCell.h"
#import "DateSelectView.h"
#import "NSString+XZExtension.h"
#import "PaySelect_VC.h"
#import "WebView_VC.h"

@interface NewBuyInsurance_VC () <NewBuyInsuranceCellDelegate>{
    CGFloat _allNeedPayMoney;
}

@property (nonatomic, weak) UIButton *comfirmBtn;
@property (nonatomic, assign) BOOL isAgree;
@property (nonatomic, assign) CGFloat insuranceUnit;    /*! 保险单价 */

@end

@implementation NewBuyInsurance_VC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"立即投保";
    [WDNotificationCenter addObserver:self selector:@selector(backAction) name:WDNotification_backFromMoneyBag object:nil];
    [[XSJRequestHelper sharedInstance] getClientGlobalInfoWithBlock:^(ClientGlobalInfoRM *clientGlobalInfoRM) {
        if (clientGlobalInfoRM) {
            self.insuranceUnit = clientGlobalInfoRM.pingan_unit_price_ent.floatValue;
        }
    }];
    
    [self newSubViews];
    if (self.isBuyForJK) {
        [self loadData];
    }else{
        [self addData];
    }
}

- (void)newSubViews{
    
    UIView *topView = [[UIView alloc] init];
    UILabel *label = [UILabel labelWithText:@"添加前请确保被投保人的身份证号码正确" textColor:[UIColor XSJColor_tGrayDeepTransparent80] fontSize:14.0f];

    [self.view addSubview:topView];
    [topView addSubview:label];
    
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.right.equalTo(topView);
        make.left.equalTo(topView).offset(16);
    }];
    [label addBorderInDirection:BorderDirectionTypeBottom borderWidth:0.7 borderColor:[UIColor XSJColor_clipLineGray] isConstraint:YES];

    [self initUIWithType:DisplayTypeOnlyTableView];
    [self.tableView registerNib:nib(@"NewBuyInsuranceCell") forCellReuseIdentifier:@"NewBuyInsuranceCell"];
    
    UIView *botView = [[UIView alloc] init];
    
    UIButton *addBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [addBtn setTitle:@"添加被投保人" forState:UIControlStateNormal];
    [addBtn setTitleColor:[UIColor XSJColor_tGrayDeepTinge] forState:UIControlStateNormal];
    addBtn.titleLabel.font = [UIFont systemFontOfSize:15.0f];
    [addBtn addTarget:self action:@selector(addBtnOnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *botBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [botBtn setTitle:@"确认投保" forState:UIControlStateNormal];
    botBtn.titleLabel.font = [UIFont systemFontOfSize:17.0f];
    [botBtn setBackgroundColor:[UIColor XSJColor_base]];
    [botBtn setCornerValue:2.0f];
    [botBtn addTarget:self action:@selector(botBtnOnClick:) forControlEvents:UIControlEventTouchUpInside];
    _comfirmBtn = botBtn;
    
    UIButton *selectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [selectBtn setImage:[UIImage imageNamed:@"v230_building_checkbox"] forState:UIControlStateNormal];
    [selectBtn setImage:[UIImage imageNamed:@"frequent_icon_checkbox"] forState:UIControlStateSelected];
    selectBtn.selected = YES;
    _isAgree = YES;
    [selectBtn addTarget:self action:@selector(boxBtnOnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    UILabel *viewLabel = [UILabel labelWithText:@"我已阅读" textColor:[UIColor XSJColor_tGrayDeepTransparent2] fontSize:13.0f];
    
    UIButton *dutyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [dutyBtn setTitle:@"《保险责任》" forState:UIControlStateNormal];
    [dutyBtn setTitleColor:[UIColor XSJColor_tGrayDeepTransparent80] forState:UIControlStateNormal];
    dutyBtn.titleLabel.font = [UIFont systemFontOfSize:13.0f];
    [dutyBtn addTarget:self action:@selector(dutyBtnOnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    UILabel *dunLabel = [UILabel labelWithText:@"、" textColor:[UIColor XSJColor_tGrayDeepTransparent2] fontSize:13.0f];
    
    UIButton *mianBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [mianBtn setTitle:@"《责任免除》" forState:UIControlStateNormal];
    [mianBtn setTitleColor:[UIColor XSJColor_tGrayDeepTransparent80] forState:UIControlStateNormal];
    mianBtn.titleLabel.font = [UIFont systemFontOfSize:13.0f];
    [mianBtn addTarget:self action:@selector(mianBtnOnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    UILabel *tiaoLabel = [UILabel labelWithText:@"条款" textColor:[UIColor XSJColor_tGrayDeepTransparent2] fontSize:13.0f];
    
    [self.view addSubview:botView];
    [botView addSubview:addBtn];
    [botView addSubview:botBtn];
    [botView addSubview:selectBtn];
    [botView addSubview:viewLabel];
    [botView addSubview:dutyBtn];
    [botView addSubview:dunLabel];
    [botView addSubview:mianBtn];
    [botView addSubview:tiaoLabel];
    
    [topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.view);
        make.height.equalTo(@44);
    }];
    
    [self.tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(topView.mas_bottom);
        make.left.right.equalTo(self.view);
        make.bottom.equalTo(botView.mas_top);
    }];
    
    [botView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(addBtn.mas_top).offset(-12);
        make.left.right.bottom.equalTo(self.view);
    }];
    
    [addBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(botView);
        make.height.equalTo(@44);
        make.bottom.equalTo(botBtn.mas_top).offset(-12);
    }];
    
    [botBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(botView).offset(12);
        make.right.equalTo(botView).offset(-12);
        make.bottom.equalTo(selectBtn.mas_top).offset(-12);
        make.height.equalTo(@44);
    }];
    
    [selectBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(botBtn);
        make.width.height.equalTo(@16);
        make.bottom.equalTo(self.view).offset(-12);
    }];
    
    [viewLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(selectBtn);
        make.left.equalTo(selectBtn.mas_right).offset(6);
    }];

    [dutyBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(selectBtn);
        make.left.equalTo(viewLabel.mas_right);
    }];
    
    [dunLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(selectBtn);
        make.left.equalTo(dutyBtn.mas_right);
    }];
    
    [mianBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(selectBtn);
        make.left.equalTo(dunLabel.mas_right);
    }];
    
    [tiaoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(selectBtn);
        make.left.equalTo(mianBtn.mas_right);
    }];
    
    [addBtn addBorderInDirection:BorderDirectionTypeTop | BorderDirectionTypeBottom borderWidth:0.7 borderColor:[UIColor XSJColor_clipLineGray] isConstraint:YES];
    [botView addBorderInDirection:BorderDirectionTypeTop borderWidth:0.7 borderColor:[UIColor XSJColor_clipLineGray] isConstraint:YES];
}

#pragma mark - uitableview datasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.dataSource.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NewBuyInsuranceCell *cell = [tableView dequeueReusableCellWithIdentifier:@"NewBuyInsuranceCell" forIndexPath:indexPath];
    cell.clipsToBounds = YES;
    InsurancePolicyParamModel *model = [self.dataSource objectAtIndex:indexPath.section];
    cell.delegate = self;
    cell.insurancePolicyModel = model;
    cell.indexPath = indexPath;
    return cell;
}

#pragma mark - uitableview delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.dataSource.count > 1) {
        return 220.0f;
    }
    return 176.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 20.0f;
}

#pragma mark - NewBuyInsuranceCellDelegate

- (void)NewBuyInsuranceCell:(NewBuyInsuranceCell *)cell actionType:(BtnOnClickActionType)actionType atIndexPath:(NSIndexPath *)indexPath{
    switch (actionType) {
        case BtnOnClickActionType_addDay:{
            InsurancePolicyParamModel *model = [self.dataSource objectAtIndex:indexPath.section];
            [self showCalendar:model];
        }
            break;
        case BtnOnClickActionType_delete:{
            [self deleteDataAtIndex:indexPath.section];
        }
            break;
        default:
            break;
    }
}

#pragma mark - 事件相应

- (void)addBtnOnClick:(UIButton *)sender{
    
    if (self.dataSource.count) {
        InsurancePolicyParamModel *insuranceModel = [self.dataSource lastObject];
        NSInteger indexOfError = [self checkDataExactwithInsuranceModelIsIncludeDate:YES];
        if (indexOfError != NSNotFound) {
            [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:indexOfError] atScrollPosition:UITableViewScrollPositionTop animated:YES];
            return;
        }
    }
    [self addData];
    [self.tableView setContentOffset:CGPointMake(0, self.tableView.contentSize.height - self.tableView.height) animated:YES];
}

- (void)botBtnOnClick:(UIButton *)sender{
    
    if (!self.dataSource.count) {
        [UIHelper toast:@"您未添加任何投保保单"];
        return;
    }else{
        InsurancePolicyParamModel *insuranceModel = [self.dataSource lastObject];
        NSInteger indexOfError = [self checkDataExactwithInsuranceModelIsIncludeDate:YES];
        if (indexOfError != NSNotFound) {
            [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:indexOfError] atScrollPosition:UITableViewScrollPositionTop animated:YES];
            return;
        }
        
        if (!_allNeedPayMoney) {
            [UIHelper toast:@"投保金额不能为0"];
            return;
        }
        
        if(!_isAgree){
            [UIHelper toast:@"须同意《保险责任》、《责任免责》条款才能投保"];
            return;
        }
    }
    
    [self comfirmInsuracenOrder];
}

- (void)boxBtnOnClick:(UIButton *)sender{
    sender.selected = !sender.selected;
    _isAgree = sender.selected;
}

- (void)dutyBtnOnClick:(UIButton *)sender{
    WebView_VC *viewCtrl = [[WebView_VC alloc] init];
    NSString *url = [NSString stringWithFormat:@"%@%@", URL_HttpServer, KUrl_toInsuranceResponsibilityPage];
    viewCtrl.url = url;
    [self.navigationController pushViewController:viewCtrl animated:YES];
}

- (void)mianBtnOnClick:(UIButton *)sender{
    WebView_VC *viewCtrl = [[WebView_VC alloc] init];
    NSString *url = [NSString stringWithFormat:@"%@%@", URL_HttpServer, KUrl_toRemitResponsibilityPage];
    viewCtrl.url = url;
    [self.navigationController pushViewController:viewCtrl animated:YES];
}

#pragma mark - 业务方法

- (void)loadData{
    NSAssert(self.jobId, @"jobId不能为空");
    WEAKSELF
    [[XSJRequestHelper sharedInstance] entQueryCanInsureApplyResumeListWithJobId:self.jobId block:^(ResponseInfo *response) {
        if (response) {
            NSArray *array = [response.content objectForKey:@"resume_list"];
            if (array.count) {
                for (NSDictionary *dic in array) {
                    InsurancePolicyParamModel *insuranceModel = [[InsurancePolicyParamModel alloc] init];
                    insuranceModel.pingan_unit_price_ent = self.insuranceUnit;
                    [insuranceModel setValueWithDic:dic];
                    
                    //录用时间后的已投保时间
                    NSArray *hasBuyInsuranceDateArray = [dic objectForKey:@"insurance_date_list"];
                    
                    //录用时间
                    NSArray *hireDateArray = [dic objectForKey:@"apply_date_list"];

                    //今天之后的已报名时间
                    NSMutableArray *tmpArr = [NSMutableArray array];
                    NSDate *nowDate = [NSDate date];
                    NSDate *buyDate = nil;
                    for (NSNumber *dateNum in hireDateArray) {
                        buyDate = [NSDate dateWithTimeIntervalSince1970:dateNum.longLongValue * 0.001];
                        if ([nowDate compare:buyDate] == NSOrderedAscending) {
                            if (![DateHelper isSameDay:nowDate date2:buyDate]) {
                                [tmpArr addObject:dateNum];
                            }
                        }
                    }
                    //此时，该数组即为今天后已报名的日期数组
                    hireDateArray = [tmpArr copy];
                    NSMutableArray *tmpHireDateArray = [hireDateArray mutableCopy];
                    NSNumber *buyDateNum;
                    
                    if (hasBuyInsuranceDateArray.count) {
                        for (NSNumber *hasBuyInsuranceDate in hasBuyInsuranceDateArray) {
                            for (NSInteger i = 0; i < tmpHireDateArray.count; i++) {
                                buyDateNum = tmpHireDateArray[i];
                                if (buyDateNum.longLongValue == hasBuyInsuranceDate.longLongValue) {
                                    [tmpHireDateArray removeObjectAtIndex:i];
                                    break;
                                }
                            }
                        }
                        hireDateArray = [tmpHireDateArray copy];
                    }
                    
                    if ([NSString verifyIDCardNumber:insuranceModel.insured_id_card_num]) {
                        insuranceModel.isBuyForJK = YES;
                        insuranceModel.insurance_date_list = [hireDateArray copy];
                        insuranceModel.all_pay_money_for_insurance = insuranceModel.insurance_date_list.count * insuranceModel.pingan_unit_price_ent * 0.01;
                        _allNeedPayMoney += insuranceModel.all_pay_money_for_insurance;
                        [weakSelf updateBotBtnTitle];
                    }else{
                        insuranceModel.isBuyForJK = NO;
                        insuranceModel.insurance_date_list = nil;
                    }
                    
                    [weakSelf.dataSource addObject:insuranceModel];
                    [weakSelf.tableView reloadData];
                }
            }else{
                [weakSelf addData];
            }
        }else{
            [weakSelf addData];
        }
    }];
}

- (void)addData{
    InsurancePolicyParamModel *model = [[InsurancePolicyParamModel alloc] init];
    [[XSJRequestHelper sharedInstance] getClientGlobalInfoWithBlock:^(ClientGlobalInfoRM *clientGlobalInfoRM) {
        if (clientGlobalInfoRM) {
            model.pingan_unit_price_ent = self.insuranceUnit;
        }
    }];
    
    [self.dataSource addObject:model];
    [self.tableView reloadData];
}

- (void)deleteDataAtIndex:(NSInteger)index{
    if (self.dataSource.count > index) {
        InsurancePolicyParamModel *model = [self.dataSource objectAtIndex:index];
        _allNeedPayMoney -= model.all_pay_money_for_insurance;
        
        [self.dataSource removeObjectAtIndex:index];
        [self.tableView reloadData];
        
        [self updateBotBtnTitle];
    }
}

- (NSInteger)checkDataExactwithInsuranceModelIsIncludeDate:(BOOL)isIncludeDate{
    
    NSAssert(self.dataSource.count, @"datasource一定要有值(长度为1及以上)");
    
    if (self.dataSource.count >= 2) {
        InsurancePolicyParamModel *comparedInsuranceModel = nil;
        InsurancePolicyParamModel *comparingInsuranceModel = nil;
        for (NSInteger i = 0 ; i < self.dataSource.count - 1; i++) {
            comparingInsuranceModel = [self.dataSource objectAtIndex:i];
            
            if (![self checkInsuranceModelIsExact:comparingInsuranceModel]) {
                return i;
            }
            
            for (NSInteger j = (i+1); j < self.dataSource.count; j++) {
                comparedInsuranceModel = [self.dataSource objectAtIndex:j];
                if ([comparingInsuranceModel.insured_id_card_num isEqualToString:comparedInsuranceModel.insured_id_card_num]) {
                    [UIHelper toast:@"请勿输入重复身份证号码"];
                    return j;
                }
                if ([comparingInsuranceModel.insured_telephone isEqualToString:comparedInsuranceModel.insured_telephone]) {
                    [UIHelper toast:@"请勿输入重复手机号码"];
                    return j;
                }
            }
            
            if (isIncludeDate) {
                if (!comparingInsuranceModel.insurance_date_list.count) {
                    [UIHelper toast:@"请添加投保日期"];
                    return i;
                }
            }
        }
        InsurancePolicyParamModel *insuranceModel = self.dataSource.lastObject;
        if (![self checkInsuranceModelIsExact:insuranceModel]) {
            return self.dataSource.count - 1;
        }
        
        if (!insuranceModel.insurance_date_list.count) {
            [UIHelper toast:@"请添加投保日期"];
            return self.dataSource.count - 1;
        }
    }else{
        InsurancePolicyParamModel *insuranceModel = self.dataSource.lastObject;
        if (![self checkInsuranceModelIsExact:insuranceModel]) {
            return 0;
        }
        if (!insuranceModel.insurance_date_list.count) {
            [UIHelper toast:@"请添加投保日期"];
            return 0;
        }
    }
    
    return NSNotFound;
}

- (BOOL)checkInsuranceModelIsExact:(InsurancePolicyParamModel *)insuranceModel{
    if (!insuranceModel.insured_telephone.length) {
        [UIHelper toast:@"手机号码不能为空"];
        return NO;
    }
    
    if (insuranceModel.insured_telephone.length != 11) {
        [UIHelper toast:@"请输入11位手机号码"];
        return NO;
    }
    
    if (!insuranceModel.insured_true_name.length) {
        [UIHelper toast:@"被投保人姓名不能为空"];
        return NO;
    }
    
    if (!(insuranceModel.insured_true_name.length >= 2 && insuranceModel.insured_true_name.length <= 10)) {
        [UIHelper toast:@"请输入2-10位数姓名"];
        return NO;
    }
    
    if (![NSString verifyIDCardNumber:insuranceModel.insured_id_card_num]) {
        [UIHelper toast:@"请输入正确的身份证号码"];
        return NO;
    }
    
    return YES;
}


- (void)showCalendar:(InsurancePolicyParamModel *)insuranceModel{
    if (![self checkInsuranceModelIsExact:insuranceModel]) {
        return;
    }
    
    DLog(@"弹出日历");
    
    WEAKSELF
    [[XSJRequestHelper sharedInstance] getSuccessInsuredDateListWithIdCard:insuranceModel.insured_id_card_num block:^(ResponseInfo *response) {
        if (response) {
            NSArray *datesPay = [response.content objectForKey:@"insurance_date_list"];
            
            DLAVAlertView *alertView = [[DLAVAlertView alloc] initWithTitle:@"请选择投保日期" message:nil delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
            [alertView setMinContentWidth:300];
            
            UIView *containerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 280, 300)];
            //日历下方的label
            UILabel *allSalaryLabel = [[UILabel alloc]initWithFrame:CGRectMake(8, 270, 200, 20)];
            allSalaryLabel.font = [UIFont systemFontOfSize:12];
            NSInteger days = insuranceModel.insurance_date_list.count;
            NSString *allDayPay = [NSString stringWithFormat:@"￥%.2f", days * (insuranceModel.pingan_unit_price_ent) * 0.01];
            allSalaryLabel.text = [NSString stringWithFormat:@"投保金额:%@", allDayPay];
            [containerView addSubview:allSalaryLabel];
            // 日期控件
            DateSelectView *dateView = [[DateSelectView alloc] initWithFrame:CGRectMake(0, 0, 280, 260)];
            dateView.type = DateViewType_PinganInsurance;
            [containerView addSubview:dateView];
            alertView.contentView = containerView;
            
            //  可投保时间范围
            NSDate * startDate = [NSDate dateWithTimeIntervalSinceNow:(24 * 60 * 60)];
            NSDate * endDate = [NSDate dateWithTimeIntervalSinceNow:(24 * 1000 * 60 * 60)];
            dateView.startDate = startDate;
            dateView.endDate = endDate;
            
            //该身份证已投保天数
            NSDate *datesPayDate;
            NSMutableArray *tmpDatesPayArr = [NSMutableArray array];
            for (NSNumber *datePayNum in datesPay) {
                datesPayDate = [NSDate dateWithTimeIntervalSince1970:(datePayNum.longLongValue * 0.001)];
                [tmpDatesPayArr addObject:datesPayDate];
            }
            dateView.datesPay = [tmpDatesPayArr copy];
            
            for (NSNumber *dateNum in insuranceModel.insurance_date_list) {
                NSDate *date = [NSDate dateWithTimeIntervalSince1970:dateNum.longLongValue * 0.001];
                [dateView.datesSelected addObject:date];
            }
            __weak typeof(DateSelectView *) weakDateView = dateView;
            __block NSMutableArray *tmpInsuranceListArr = [insuranceModel.insurance_date_list mutableCopy];
            WEAKSELF
            dateView.didClickBlock = ^(id obj){
                NSInteger days = weakDateView.datesSelected.count;
                //日历上label
                NSString *allDayPay = [NSString stringWithFormat:@"￥%.2f", days * (insuranceModel.pingan_unit_price_ent) * 0.01];
                allSalaryLabel.text = [NSString stringWithFormat:@"投保金额:%@", allDayPay];
                
                //选择投保日期
                NSNumber *tmpNum;
                NSMutableArray *tmpArray = [NSMutableArray array];
                for (NSDate *date in weakDateView.datesSelected) {
                    tmpNum = [NSNumber numberWithDouble:date.timeIntervalSince1970 * 1000];
                    [tmpArray addObject:tmpNum];
                }
                tmpInsuranceListArr = [tmpArray mutableCopy];
                    };
            
            //alertView操作
            [alertView showWithCompletion:^(DLAVAlertView *alertView, NSInteger buttonIndex) {
                if (buttonIndex == 1) {
                    _allNeedPayMoney -= insuranceModel.all_pay_money_for_insurance;
                    insuranceModel.all_pay_money_for_insurance = tmpInsuranceListArr.count * insuranceModel.pingan_unit_price_ent * 0.01;
                    _allNeedPayMoney += insuranceModel.all_pay_money_for_insurance;
                    insuranceModel.insurance_date_list = [tmpInsuranceListArr copy];
                    [weakSelf updateBotBtnTitle];
                    [weakSelf.tableView reloadData];
                }
            }];
        }
    }];
}

- (void)updateBotBtnTitle{
    [self.comfirmBtn setTitle:[NSString stringWithFormat:@"确认投保 ￥%.2f", _allNeedPayMoney] forState:UIControlStateNormal];
}

- (void)comfirmInsuracenOrder{
    
    NSNumber *totalAmount = [NSNumber numberWithInteger:((NSInteger)ceilf(_allNeedPayMoney * 100))];
    WEAKSELF
    [[XSJRequestHelper sharedInstance] rechargeInsuranceWithTotalAmount:totalAmount insuranceList:[self.dataSource copy] block:^(ResponseInfo *response) {
        if (response) {
            PaySelect_VC *viewCtrl = [[PaySelect_VC alloc] init];
            viewCtrl.fromType = PaySelectFromType_pinganInsurance;
            viewCtrl.insurance_record_id = [response.content objectForKey:@"insurance_record_id"];
            viewCtrl.needPayMoney = totalAmount.intValue;
            viewCtrl.updateDataBlock = self.block;
            [weakSelf.navigationController pushViewController:viewCtrl animated:YES];
        }
    }];
}

- (void)backAction{
    [self.navigationController popToViewController:self.popVC animated:YES];
}

- (void)backToLastView{
    [self.view endEditing:YES];
    InsurancePolicyParamModel *model = self.dataSource.firstObject;
    if (model.insured_telephone.length || model.insured_true_name.length || model.insured_id_card_num.length) {
        [MKAlertView alertWithTitle:@"提示" message:@"保单尚未支付,离开页面将导致添加列表丢失" cancelButtonTitle:@"果断离开" confirmButtonTitle:@"留在该页面" completion:^(UIAlertView *alertView, NSInteger buttonIndex) {
            if (buttonIndex == 0) {
                [self.navigationController popViewControllerAnimated:YES];
            }
        }];
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc{
    [WDNotificationCenter removeObserver:self];
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
