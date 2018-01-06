//
//  BuyJobNum_VC.m
//  JKHire
//
//  Created by yanqb on 2017/2/8.
//  Copyright © 2017年 xianshijian. All rights reserved.
//

#import "BuyJobNum_VC.h"
#import "BuyJobNumCell_City.h"
#import "BuyJobNumCell_Input.h"
#import "CitySelectController.h"
#import "PaySelect_VC.h"

#import "CityTool.h"
#import "XZDropView.h"

@interface BuyJobNum_VC ()<BuyJobNumCell_InputDelegate>

@property (nonatomic, strong) RechargeRecruitParam *paramModel;
@property (nonatomic, strong) CityModel *cityModel;
@property (nonatomic, strong) UILabel *labFirstNum;
@property (nonatomic, strong) UILabel *labSecondNum;
@property (nonatomic, strong) UILabel *labThirdNum;
@property (nonatomic, weak) UIButton *btn;

@end

@implementation BuyJobNum_VC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"在招岗位数购买";
    NSAssert(self.actionType, @"self.actionType必须赋值！！");
    
    self.paramModel = [[RechargeRecruitParam alloc] init];
    
    [self.dataSource addObject:@(BuyJobNumCelltype_city)];
    [self.dataSource addObject:@(BuyJobNumCelltype_jobNum)];
    [self.dataSource addObject:@(BuyJobNumCelltype_jobTimeLong)];
    
    [self initUIWithType:DisplayTypeOnlyTableView];
    
    [self.tableView registerNib:nib(@"BuyJobNumCell_City")
         forCellReuseIdentifier:@"BuyJobNumCell_City"];
    [self.tableView registerNib:nib(@"BuyJobNumCell_Input")
         forCellReuseIdentifier:@"BuyJobNumCell_Input"];
    
    self.tableView.tableFooterView = [self getTableFooterView];
    
    [self loadDatas];
    [self updateBotView];
}

- (void)loadDatas{
    WEAKSELF
    switch (self.actionType) {
        case BuyJobNumActionType_ForRenew:{ //续费
            self.paramModel.recruit_city_id = self.recruit_city_id;
            self.paramModel.recruit_job_num = self.recruit_job_num;
            self.paramModel.record_id = self.record_id;
            [CityTool getCityModelWithCityId:self.recruit_city_id block:^(CityModel *cityModel) {
                if (cityModel) {
                    weakSelf.cityModel = cityModel;
                    [self updateBotView];
                    [weakSelf.tableView reloadData];
                }
            }];
        }
            break;
        case BuyJobNumActionType_ForReBuy:{ //默认填充岗位相关的城市
            self.paramModel.recruit_job_num = @1;
            self.paramModel.recruit_keep_months = @1;
            
            if ([[UserData sharedInstance].city.id isEqualToNumber:self.recruit_city_id]) {
                self.cityModel = [UserData sharedInstance].city;
                self.paramModel.recruit_city_id = [UserData sharedInstance].city.id;
            }else{
                WEAKSELF
                [CityTool getCityModelWithCityId:self.recruit_city_id block:^(CityModel *result) {
                    if (result) {
                        weakSelf.recruit_city_id = weakSelf.recruit_city_id;
                        weakSelf.cityModel = result;
                        [weakSelf.tableView reloadData];
                        [weakSelf updateBotView];
                    }
                }];
            }
        }
            break;
        case BuyJobNumActionType_ForBuy:{   //默认当前定位城市数据
            self.paramModel.recruit_job_num = @1;
            self.paramModel.recruit_keep_months = @1;
            self.paramModel.recruit_city_id = [UserData sharedInstance].city.id;
            self.cityModel = [UserData sharedInstance].city;
        }
            break;
        default:
            break;
    }
}

#pragma mark - uitableview datasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.dataSource.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    BuyJobNumCelltype cellType = [[self.dataSource objectAtIndex:indexPath.section] integerValue];
    switch (cellType) {
        case BuyJobNumCelltype_city:
        case BuyJobNumCelltype_jobNum:
        case BuyJobNumCelltype_jobTimeLong:{
            BuyJobNumCell_City *cell = [tableView dequeueReusableCellWithIdentifier:@"BuyJobNumCell_City"
                forIndexPath:indexPath];
            cell.cellType = cellType;
            cell.actionType = self.actionType;
            [cell setCityModel:self.cityModel paramModel:self.paramModel];
            return cell;
        }
//         case BuyJobNumCelltype_jobNum:
//        case BuyJobNumCelltype_jobTimeLong:{
//            BuyJobNumCell_Input *cell = [tableView dequeueReusableCellWithIdentifier:@"BuyJobNumCell_Input"
//                forIndexPath:indexPath];
//            cell.delegate = self;
//            [cell setModel:self.paramModel cellType:cellType isCanModify:(self.actionType == BuyJobNumActionType_ForBuy || self.actionType == BuyJobNumActionType_ForReBuy)];
//            return cell;
//        }
        default:
            break;
    }
    return nil;
}

#pragma mark - uitableview delegate

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [UIColor XSJColor_newGray];
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return 12.0f;
    }
    return 4.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 70.0f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    BuyJobNumCelltype cellType = [[self.dataSource objectAtIndex:indexPath.section] integerValue];
    
    if (self.actionType == BuyJobNumActionType_ForRenew && cellType != BuyJobNumCelltype_jobTimeLong) {
        return;
    }
    
    switch (cellType) {
        case BuyJobNumCelltype_city:{
            CitySelectController *viewCtrl = [[CitySelectController alloc] init];
            viewCtrl.isPushAction = YES;
            viewCtrl.showType = CitySelectControllerShowType_filterVip;
            WEAKSELF
            viewCtrl.didSelectCompleteBlock = ^(CityModel *cityModel){
                if (cityModel) {
                    weakSelf.cityModel = cityModel;
                    weakSelf.paramModel.recruit_city_id = cityModel.id;
                    [weakSelf valueOnChage];
                    [weakSelf.tableView reloadData];
                }
            };
            [self.navigationController pushViewController:viewCtrl animated:YES];
        }
            break;
        case BuyJobNumCelltype_jobNum:{
            WEAKSELF
            [self showJobNumDropView:^(id result) {
                [weakSelf.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
                [weakSelf updateBotView];
            }];
        }
            break;
        case BuyJobNumCelltype_jobTimeLong:{
            WEAKSELF
            [self showJobTimeLong:^(id result) {
                [weakSelf.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
                [weakSelf updateBotView];
            }];
        }
            break;
        default:
            break;
    }
}

- (void)showJobNumDropView:(MKBlock)block{
    NSMutableArray *array = [NSMutableArray array];
    NSInteger index = 1;
    while (index < 11) {
        [array addObject:@(index).description];
        index++;
    }
    [MKActionSheet sheetWithTitle:@"选择在招岗位数量(单位:个)" buttonTitleArray:array isNeedCancelButton:YES maxShowButtonCount:4 block:^(MKActionSheet *actionSheet, NSInteger buttonIndex) {
        if (buttonIndex < array.count) {
            NSString *str = [array objectAtIndex:buttonIndex];
            self.paramModel.recruit_job_num = @(str.integerValue);
            MKBlockExec(block, nil);
        }
    }];
}

- (void)showJobTimeLong:(MKBlock)block{
    NSMutableArray *array = [NSMutableArray array];
    NSInteger index = 1;
    while (index < 13) {
        [array addObject:@(index).description];
        index++;
    }
    [MKActionSheet sheetWithTitle:@"选择招聘时长(单位:个月)" buttonTitleArray:array isNeedCancelButton:YES maxShowButtonCount:4 block:^(MKActionSheet *actionSheet, NSInteger buttonIndex) {
        if (buttonIndex < array.count) {
            NSString *str = [array objectAtIndex:buttonIndex];
            self.paramModel.recruit_keep_months = @(str.integerValue);
            MKBlockExec(block, nil);
        }
    }];
}

#pragma mark - BuyJobNumCell_InputDelegate
- (void)valueOnChage{
    [self updateBotView];
}

- (void)updateBotView{
    
    ClientGlobalInfoRM *globalInfoRM = [[XSJRequestHelper sharedInstance] getClientGlobalModel];
    
    NSInteger priceOfPer = 0;
    if (self.cityModel) {
        if (self.cityModel.level.integerValue == 1) {
            priceOfPer = (NSInteger)globalInfoRM.city_recruit_job_num_price.first_level.floatValue / 100;
            
        }else if (self.cityModel.level.integerValue == 2){
            priceOfPer = (NSInteger)globalInfoRM.city_recruit_job_num_price.second_level.floatValue / 100;
        }
        _labFirstNum.text = [NSString stringWithFormat:@"%ld元/个/月", priceOfPer];
    }else{
        _labFirstNum.text = @"";
    }
    
    if (self.paramModel.recruit_keep_months.integerValue <= 0 || self.paramModel.recruit_job_num.integerValue <= 0 || !self.paramModel.recruit_city_id) {
        self.paramModel.total_amount = nil;
        _labSecondNum.text = @"";
        _labThirdNum.text = @"";
        [self.btn setTitle:@"去付款" forState:UIControlStateNormal];
        return;
    }
    
    
    
    CGFloat price = 0.0;
    if (self.cityModel.level.integerValue == 1) {
        price = globalInfoRM.city_recruit_job_num_price.first_level.floatValue * self.paramModel.recruit_job_num.integerValue * self.paramModel.recruit_keep_months.integerValue;
    }else if (self.cityModel.level.integerValue == 2){
        price = globalInfoRM.city_recruit_job_num_price.second_level.floatValue * self.paramModel.recruit_job_num.integerValue * self.paramModel.recruit_keep_months.integerValue;
    }

    self.paramModel.total_amount = @((NSInteger)(ceil(price)));
    CGFloat totalPrice = price / 100;
    
    _labSecondNum.text = [NSString stringWithFormat:@"%ld*%ld*%ld=%.f", priceOfPer, self.paramModel.recruit_job_num.integerValue, self.paramModel.recruit_keep_months.integerValue, totalPrice];
    
    _labThirdNum.text = [NSString stringWithFormat:@"%.f元", totalPrice];
    NSString *title = [NSString stringWithFormat:@"去付款(￥%.f)", price / 100];
    [self.btn setTitle:title forState:UIControlStateNormal];
}

#pragma mark - 重写方法
- (void)btnPayOnClick{
    if (!self.paramModel.recruit_city_id) {
        [UIHelper toast:@"请选择招聘城市"];
        return;
    }
    
    if (self.paramModel.recruit_job_num.integerValue < 1) {
        [UIHelper toast:@"请输入在招岗位数量"];
        return;
    }
    
    if (self.paramModel.recruit_keep_months.integerValue < 1) {
        [UIHelper toast:@"请输入招聘时长"];
        return;
    }
    
    if (self.paramModel.recruit_keep_months.integerValue > 12) {
        [UIHelper toast:@"招聘时长不能大于12个月"];
        return;
    }
    
    [self makeDataSend];
    
}

- (void)makeDataSend{
    [self.view endEditing:YES];
    
    switch (self.actionType) {
        case BuyJobNumActionType_ForReBuy:
        case BuyJobNumActionType_ForBuy:{
            [self postBuyMethod];
        }
            break;
        case BuyJobNumActionType_ForRenew:{
            [self postRenewMethod];
        }
            break;
        default:
            break;
    }
    
}

- (void)postBuyMethod{
    WEAKSELF
    [[XSJRequestHelper sharedInstance] rechargeRecruitJobNum:self.paramModel block:^(ResponseInfo *response) {
        if (response) {
            PaySelect_VC *viewCtrl = [[PaySelect_VC alloc] init];
            viewCtrl.updateDataBlock = weakSelf.block;
            viewCtrl.needPayMoney = weakSelf.paramModel.total_amount.intValue;
            viewCtrl.recruit_job_num_order_id = [response.content objectForKey:@"recruit_job_num_order_id"];
            viewCtrl.fromType = PaySelectFromType_RecruitJobNum;
            [weakSelf.navigationController pushViewController:viewCtrl animated:YES];
        }
    }];
}

- (void)postRenewMethod{
    WEAKSELF
    [[XSJRequestHelper sharedInstance] renewRecruitJobNum:self.paramModel block:^(ResponseInfo *response) {
        if (response) {
            PaySelect_VC *viewCtrl = [[PaySelect_VC alloc] init];
            viewCtrl.updateDataBlock = weakSelf.block;
            viewCtrl.needPayMoney = weakSelf.paramModel.total_amount.intValue;
            viewCtrl.recruit_job_num_order_id = [response.content objectForKey:@"recruit_job_num_order_id"];
            viewCtrl.fromType = PaySelectFromType_RecruitJobNum;
            [weakSelf.navigationController pushViewController:viewCtrl animated:YES];
        }
    }];
}

#pragma mark - lazy
- (UIView *)getTableFooterView{

    UIView *tableFooterView = [[UIView alloc] init];
    CGFloat height = 277.0f;
    UILabel *titleLab = [UILabel labelWithText:@"通告" textColor:[UIColor XSJColor_tGrayDeepTinge] fontSize:14.0f];
    
    UILabel *labFirstDes = [UILabel labelWithText:@"在招岗位数单价：" textColor:[UIColor XSJColor_tGrayDeepTransparent80] fontSize:14.0f];
    self.labFirstNum = [UILabel labelWithText:@"" textColor:[UIColor XSJColor_middelRed] fontSize:14.0f];
    UILabel *labSecondDes = [UILabel labelWithText:@"购买岗位价格计算：" textColor:[UIColor XSJColor_tGrayDeepTransparent80] fontSize:14.0f];
    self.labSecondNum = [UILabel labelWithText:@"" textColor:[UIColor XSJColor_middelRed] fontSize:14.0f];
    UILabel *labThirdDes = [UILabel labelWithText:@"总计：" textColor:[UIColor XSJColor_tGrayDeepTransparent80] fontSize:14.0f];
    self.labThirdNum = [UILabel labelWithText:@"" textColor:[UIColor XSJColor_middelRed] fontSize:14.0f];
    
    UIButton *button = [UIButton creatBottomButtonWithTitle:@"去付款" addTarget:self action:@selector(btnPayOnClick)];
    [button setCornerValue:2.0f];
    _btn = button;
    
    UILabel *labBottom = [UILabel labelWithText:@"同时进行多个岗位招聘" textColor:[UIColor XSJColor_tGrayDeepTransparent48] fontSize:12.0f];
    
    UIView *bgView = [[UIView alloc] init];
    bgView.backgroundColor = MKCOLOR_RGBA(34, 58, 80, 0.03);
    
    UILabel *lab = [[UILabel alloc] init];
    lab.font = [UIFont systemFontOfSize:14.0f];
    lab.textColor = [UIColor XSJColor_tGrayHistoyTransparent];
    lab.numberOfLines = 0;
    lab.text = @"为更好的保障广大雇主的权益，避免部分中介雇主滥发无效或相同性质岗位，平台岗位发布特做如下调整：\n1、单个账号在单个城市仅允许发布1个招聘岗位\n2、平台将为发布的岗位提供更多流量支持，保证岗位快速有序的更新";
    [tableFooterView addSubview:labFirstDes];
    [tableFooterView addSubview:_labFirstNum];
    [tableFooterView addSubview:labSecondDes];
    [tableFooterView addSubview:_labSecondNum];
    [tableFooterView addSubview:labThirdDes];
    [tableFooterView addSubview:_labThirdNum];
    [tableFooterView addSubview:button];
    [tableFooterView addSubview:labBottom];
    [tableFooterView addSubview:bgView];
    
    [bgView addSubview:titleLab];
    [bgView addSubview:lab];
    
    [labFirstDes mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(tableFooterView).offset(12);
        make.left.equalTo(tableFooterView).offset(16);
    }];
    
    [_labFirstNum mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(labFirstDes.mas_right);
        make.centerY.equalTo(labFirstDes);
    }];
    
    [labSecondDes mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(labFirstDes.mas_bottom).offset(16);
        make.left.equalTo(tableFooterView).offset(16);
    }];
    
    [_labSecondNum mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(labSecondDes.mas_right);
        make.centerY.equalTo(labSecondDes);
    }];
    
    [labThirdDes mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(labSecondDes.mas_bottom).offset(16);
        make.left.equalTo(tableFooterView).offset(16);
    }];
    
    [_labThirdNum mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(labThirdDes.mas_right);
        make.centerY.equalTo(labThirdDes);
    }];
    
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(labThirdDes.mas_bottom).offset(24);
        make.left.equalTo(tableFooterView).offset(16);
        make.right.equalTo(tableFooterView).offset(-16);
        make.height.equalTo(@44);
    }];
    
    [labBottom mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(button.mas_bottom).offset(8);
        make.left.equalTo(tableFooterView).offset(16);
    }];
    
    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(tableFooterView).offset(16);
        make.right.equalTo(tableFooterView).offset(-16);
        make.top.equalTo(labBottom.mas_bottom).offset(24);
        make.bottom.equalTo(lab).offset(16);
    }];
    
    [titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(bgView).offset(12);
        make.left.equalTo(bgView).offset(12);
    }];
    
    [lab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(titleLab.mas_bottom).offset(4);
        make.left.equalTo(bgView).offset(12);
        make.right.equalTo(bgView).offset(-12);
    }];
    height += [lab contentSizeWithWidth:SCREEN_WIDTH - 64].height;
    height += [titleLab contentSizeWithWidth:SCREEN_WIDTH - 64].height;
    tableFooterView.frame = CGRectMake(0, 0, SCREEN_WIDTH, height);
    
    return tableFooterView;
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
