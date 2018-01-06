  //
//  VipInfoCenter_VC.m
//  JKHire
//
//  Created by yanqb on 2017/5/10.
//  Copyright © 2017年 xianshijian. All rights reserved.
//

#import "VipInfoCenter_VC.h"
#import "VipInfoCenter_Cell1.h"
#import "VipInfoHeaderView.h"
#import "BaseButton.h"
#import "VipIPacket_VC.h"
#import "UsedApplyNum_VC.h"
#import "BuyApplyNum_VC.h"
#import "VipInfoCenter_Cell2.h"
#import "VipInfoCenter_Cell.h"
#import "VipInfoCenter_CellNil.h"
@interface VipInfoCenter_VC () <VipInfoCenter_Cell1Delegate>

@property (nonatomic, strong) UIView *headerView;
@property (nonatomic, strong) UIView *tableFooterView;
@property (nonatomic, assign) BOOL isNullWithVipInfo;

@end

@implementation VipInfoCenter_VC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title  =@"VIP会员中心";
    self.btntitles = @[@"联系我"];
    self.tableViewStyle = UITableViewStyleGrouped;
    self.marginTop = 46;
    [self initUIWithType:DisplayTypeTableViewAndBottom];
    self.tableView.backgroundColor = [UIColor XSJColor_newGray];
    self.refreshType = RefreshTypeHeader;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerNib:nib(@"VipInfoCenter_Cell1") forCellReuseIdentifier:@"VipInfoCenter_Cell1"];
    [self.tableView registerNib:nib(@"VipInfoCenter_Cell2") forCellReuseIdentifier:@"VipInfoCenter_Cell2"];
    
    UILabel *lab = [UILabel labelWithText:@"如需升级会员、续费，请点击“联系我”" textColor:[UIColor XSJColor_tGrayDeepTransparent32] fontSize:12.0f];
    [self.bottomView addSubview:lab];
    UIButton *btn = [self.bottomBtns objectAtIndex:0];
    [lab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bottomView).offset(16);
        make.bottom.equalTo(btn.mas_top).offset(-8);
    }];
    
    [self.bottomView addBorderInDirection:BorderDirectionTypeTop borderWidth:0.7f borderColor:[UIColor XSJColor_clipLineGray] isConstraint:YES];
    
    self.tableView.tableHeaderView = self.headerView;
    self.headerView.hidden = YES;
    self.tableView.tableFooterView = [self getFooterView];
    
    [self getData:YES];
}

- (void)headerRefresh{
    [self getData:NO];
   
}

- (void)getData:(BOOL)isShowLoading{
    WEAKSELF
    [[XSJRequestHelper sharedInstance] queryAccountVipInfo:^(ResponseInfo *response) {
        [weakSelf.tableView.header endRefreshing];
        if (response) {
            weakSelf.headerView.hidden = NO;
            [weakSelf.dataSource removeAllObjects];
            AccountVipInfo *vipInfo = [AccountVipInfo objectWithKeyValues:response.content];
            weakSelf.isNullWithVipInfo = [vipInfo isNullWithGeneralVip];
            if (!weakSelf.isNullWithVipInfo) {
                [weakSelf.dataSource addObject:vipInfo];
            }
            [weakSelf.dataSource addObjectsFromArray:vipInfo.city_vip_info];
            [weakSelf.tableView reloadData];
            weakSelf.tableFooterView.hidden = NO;
        }
    }];
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.dataSource.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    id model = [self.dataSource objectAtIndex:indexPath.section];
    if ([model isKindOfClass:[AccountVipInfo class]]) {
        AccountVipInfo *modelA = model;
        if (modelA.national_general_vip_resume_num_privilege.all_resume_num || modelA.national_general_vip_resume_num_privilege.left_resume_num || modelA.national_general_vip_resume_num_privilege.soon_expired_resume_num) {
            [tableView registerNib:[UINib nibWithNibName:@"VipInfoCenter_cell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"VipInfoCenter_cell"];
            VipInfoCenter_Cell *cell = [tableView dequeueReusableCellWithIdentifier:@"VipInfoCenter_cell"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.model = model;
            return cell;
        }else{
            [tableView registerNib:[UINib nibWithNibName:@"VipInfoCenter_CellNil" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"VipInfoCenter_cellNil"];
            VipInfoCenter_CellNil *cell = [tableView dequeueReusableCellWithIdentifier:@"VipInfoCenter_cellNil"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.model = model;
            return cell;
        }
        
        
        
    }else{
        VipInfoCenter_Cell1 *cell = [tableView dequeueReusableCellWithIdentifier:@"VipInfoCenter_Cell1" forIndexPath:indexPath];
        cell.delegate = self;
        cell.model = model;
        return cell;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (self.isNullWithVipInfo) {
        if (section == 0) {
            return [self getSectionWithTitle:@"VIP服务城市特权" subTitle:@"以下特权仅在VIP服务城市使用"];
        }
    }else{
        if (section == 0) {
            return [self getSectionWithTitle:@"VIP全国通用特权" subTitle:@"全国都可使用，开通多个VIP城市，数量累加"];
        }else if (section == 1){
            return [self getSectionWithTitle:@"VIP服务城市特权" subTitle:@"以下特权仅在VIP服务城市使用"];
        }
    }
    
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [UIColor XSJColor_newGray];
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    id model = [self.dataSource objectAtIndex:indexPath.section];
    if ([model isKindOfClass:[AccountVipInfo class]]) {
        AccountVipInfo *info = (AccountVipInfo *)model;
        return info.cellHeight;
    }else{
        CityVipInfo *info = (CityVipInfo *)model;
        return info.cellHeight;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (!self.isNullWithVipInfo) {
        if (section == 1) {
            return 70.0f;
        }
    }
    if (section == 0) {
        return 70.0f;
    }else{
        return 32.0f;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01f;
}

#pragma mark - VipInfoCenter_Cell1Delegate

- (void)vipInfoCenter_Cell1:(VipInfoCenter_Cell1 *)cell actionType:(BtnOnClickActionType)actionType model:(CityVipInfo *)model{
    switch (actionType) {
        case BtnOnClickActionType_usedApplyNum:{
            [self enterUsedApplyNumVC:model];
        }
            break;
        case BtnOnClickActionType_buyApplyNum:{
            [self enterBuyApplyNumVC:model];
        }
            break;
        default:
            break;
    }
}

- (void)enterUsedApplyNumVC:(CityVipInfo *)model{
    UsedApplyNum_VC *vc = [[UsedApplyNum_VC alloc] init];
    vc.vip_order_id = model.vip_apply_job_num_obj.vip_order_id;
    vc.fromType = UsedApplyNumType_vip;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)enterBuyApplyNumVC:(CityVipInfo *)model{
    [TalkingData trackEvent:@"VIP会员中心_报名数购买入口"];
    BuyApplyNum_VC *vc = [[BuyApplyNum_VC alloc] init];
    vc.vip_order_id = model.vip_apply_job_num_obj.vip_order_id;
    vc.vipInfo = model;
    WEAKSELF
    vc.block = ^(id result){
        [weakSelf.navigationController popToViewController:weakSelf animated:YES];
        [weakSelf getData:YES];
    };
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - 重写方法
- (void)clickOnview:(UIView *)bottomView clickedButtonAtIndex:(NSInteger)buttonIndex{
    [TalkingData trackEvent:@"VIP会员中心_联系我按钮"];
    [[XSJRequestHelper sharedInstance] postSaleClueWithDesc:@"VIP会员中心" isNeedContact:@1 isShowloading:YES block:^(id result) {
        if (result) {
            [UIHelper toast:@"提交成功，顾问正光速赶来，请您保持手机通畅"];
        }
    }];
}

#pragma mark - 自定义方法

- (UIView *)getFooterView{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 70)];
    view.backgroundColor = [UIColor XSJColor_newGray];
    view.hidden = YES;
    
    BaseButton *btn = [BaseButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:@"继续开通其他VIP服务城市" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor XSJColor_tGrayDeepTinge] forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:16.0f];
    [btn setImage:[UIImage imageNamed:@"job_icon_push"] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(btnBuyVipOnClick:) forControlEvents:UIControlEventTouchUpInside];
    [btn setMarginForImg:-8 marginForTitle:16];
    [view addSubview:btn];
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(view);
        make.height.equalTo(@54);
    }];
    
    self.tableFooterView = view;
    return view;
}

- (void)btnBuyVipOnClick:(UIButton *)sender{
    [TalkingData trackEvent:@"VIP会员中心_继续开通其他VIP服务城市"];
    VipIPacket_VC *vc = [[VipIPacket_VC alloc] init];
    WEAKSELF
    vc.block = ^(id result){
        [weakSelf.navigationController popToViewController:weakSelf animated:YES];
        [weakSelf getData:YES];
    };
    [self.navigationController pushViewController:vc animated:YES];
}

- (UIView *)getSectionWithTitle:(NSString *)title subTitle:(NSString *)subTitle{
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [UIColor XSJColor_newGray];

    UILabel *lab6 = [UILabel labelWithText:title textColor:[UIColor XSJColor_base] fontSize:14.0f];
    UILabel *lab7 = [UILabel labelWithText:subTitle textColor:[UIColor XSJColor_tGrayDeepTransparent3] fontSize:12.0f];
    lab7.numberOfLines = 0;
    [view addSubview:lab6];
    [view addSubview:lab7];
    
    [lab6 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(view).offset(16);
        make.left.equalTo(view).offset(16);
        make.right.equalTo(view).offset(-16);
    }];
    [lab7 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lab6.mas_bottom).offset(4);
        make.left.right.equalTo(lab6);
    }];
    
    return view;
}

- (UIView *)headerView{
    if (!_headerView) {
        UIView *view =[[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 54.0f)];
        UILabel *lab1 = [[UILabel alloc] init];
        lab1.font = [UIFont systemFontOfSize:14.0f];
        lab1.textColor = [UIColor XSJColor_tGrayDeepTinge];
        EPModel *epModel = [[UserData sharedInstance] getEpModelFromHave];
        lab1.text = epModel.enterprise_name.length ? epModel.enterprise_name : nil;
        
        UIImageView *imgIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[[UserData sharedInstance] getStatusImgWithAccout]]];
        
        UIView *line = [[UIView alloc] init];
        line.backgroundColor = [UIColor XSJColor_clipLineGray];
        
        [view addSubview:lab1];
        [view addSubview:imgIcon];
        [view addSubview:line];
        
        [lab1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.equalTo(view).offset(16);
            make.right.lessThanOrEqualTo(view).offset(-28);
            make.height.equalTo(@20);
        }];
        
        [imgIcon mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(lab1.mas_right).offset(4);
            make.centerY.equalTo(lab1);
            make.width.height.equalTo(@20);
        }];
        
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(lab1.mas_bottom).offset(16);
            make.left.right.equalTo(view);
            make.height.equalTo(@0.7);
        }];
        
        _headerView = view;
        
    }
    return _headerView;
    
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
