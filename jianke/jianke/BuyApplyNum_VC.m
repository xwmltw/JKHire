//
//  BuyApplyNum_VC.m
//  JKHire
//
//  Created by yanqb on 2017/5/12.
//  Copyright © 2017年 xianshijian. All rights reserved.
//

#import "BuyApplyNum_VC.h"
#import "BuyApplyNum_Cell.h"
#import "BuyApplyNumHeaderView.h"
#import "PaySelect_VC.h"
#import "WebView_VC.h"

@interface BuyApplyNum_VC ()

@property (nonatomic, weak) UIButton *btnPay;
@property (nonatomic, copy) NSNumber *cityId;
@property (nonatomic, strong) BuyApplyNumHeaderView *headerView;
@property (nonatomic, strong) VipApplyPackage *payModel;

@end

@implementation BuyApplyNum_VC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"报名数购买";
    self.cityId = [UserData sharedInstance].city.id;
    self.btntitles = @[@"去付款"];
    self.marginTop = 48;
    [self initUIWithType:DisplayTypeTableViewAndBottom];
    self.tableView.backgroundColor = [UIColor XSJColor_newWhite];
    self.btnPay = [self.bottomBtns objectAtIndex:0];
    [self updateBotView];
    [self initWithNoDataViewWithStr:@"暂无相关套餐" onView:self.tableView];
    self.viewWithNoData.y = 166.0f;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.refreshType = RefreshTypeHeader;
    self.tableView.tableHeaderView = self.headerView;
    [self.headerView setModel:self.vipInfo];
    self.tableView.tableFooterView = [self getFooterView];
    [self.tableView registerNib:nib(@"BuyApplyNum_Cell") forCellReuseIdentifier:@"BuyApplyNum_Cell"];
    [self getData:YES];
}

- (void)updateBotView{
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
        make.bottom.equalTo(self.btnPay.mas_top).offset(-16);
    }];
    
    [lab1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(lab.mas_right);
        make.centerY.equalTo(lab);
    }];
    
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(lab1.mas_right);
        make.centerY.equalTo(lab1);
    }];
}

- (void)headerRefresh{
    [self getData:NO];
}

- (void)getData:(BOOL)isShowLoading{
    WEAKSELF
    [[XSJRequestHelper sharedInstance] queryVipApplyJobNumPackageList:self.cityId isShowLoading:isShowLoading block:^(ResponseInfo *response) {
        [weakSelf.tableView.header endRefreshing];
        if (response) {
            NSArray *array = [VipApplyPackage objectArrayWithKeyValuesArray:[response.content objectForKey:@"vip_apply_job_package_list"]];
            weakSelf.payModel = nil;
            if (array.count) {
                weakSelf.viewWithNoData.hidden = YES;
                weakSelf.payModel = [array firstObject];
                weakSelf.payModel.isSelected = YES;
            }else{
                weakSelf.viewWithNoData.hidden = NO;
            }
            [weakSelf updateBtn];
            weakSelf.dataSource = [array mutableCopy];
            [weakSelf.tableView reloadData];
        }else{
            if (!weakSelf.dataSource.count) {
                weakSelf.viewWithNoData.hidden = NO;
            }
        }
    }];
}

#pragma mark - uitableview datasouce
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    BuyApplyNum_Cell *cell = [tableView dequeueReusableCellWithIdentifier:@"BuyApplyNum_Cell" forIndexPath:indexPath];
    VipApplyPackage *model = [self.dataSource objectAtIndex:indexPath.row];
    [cell setModel:model];
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [UIColor XSJColor_newWhite];
    
    UIView *line = [[UIView alloc] init];
    line.backgroundColor = [UIColor XSJColor_clipLineGray];
    
    UILabel *lab = [UILabel labelWithText:@"增加报名数" textColor:[UIColor XSJColor_tGrayDeepTransparent48] fontSize:16.0f];
    
    [view addSubview:line];
    [view addSubview:lab];
    
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(view);
        make.height.equalTo(@0.7);
    }];
    [lab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(view).offset(16);
        make.centerY.equalTo(view);
    }];
    return view;
}

#pragma mark - uitableview delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 56.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 54.0f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    VipApplyPackage *model = [self.dataSource objectAtIndex:indexPath.row];
    [self.dataSource enumerateObjectsUsingBlock:^(VipApplyPackage * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.isSelected = NO;
    }];
    model.isSelected = YES;
    self.payModel = model;
    [self updateBtn];
    [tableView reloadData];
}

#pragma mark - 重写方法
- (void)clickOnview:(UIView *)bottomView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (!self.payModel) {
        [UIHelper toast:@"请选择套餐"];
    }
    WEAKSELF
    [[XSJRequestHelper sharedInstance] rechargeVipApplyJobNumPackageWithOrderId:self.vip_order_id packageId:self.payModel.id totalAmount:self.payModel.price block:^(ResponseInfo *respnse) {
        if (respnse) {
            PaySelect_VC *vc = [[PaySelect_VC alloc] init];
            vc.fromType = PaySelectFromType_payVipApplyJobNumOrder;
            vc.needPayMoney = self.payModel.price.intValue;
            vc.vip_apply_job_num_order_id = [respnse.content objectForKey:@"vip_apply_job_num_order_id"];
            vc.vip_order_id = weakSelf.vip_order_id;
            vc.updateDataBlock = weakSelf.block;
            [weakSelf.navigationController pushViewController:vc animated:YES];
        }
    }];
}

#pragma mark - 业务方法
- (void)updateBtn{
    NSString *title = [NSString stringWithFormat:@"去付款 ¥%.2f", self.payModel.price.floatValue * 0.01];
    [self.btnPay setTitle:title forState:UIControlStateNormal];
}

- (void)btnOnClick:(UIButton *)sender{
    WebView_VC* vc = [[WebView_VC alloc] init];
    vc.url = [NSString stringWithFormat:@"%@%@", URL_HttpServer, KUrl_toValueAddServiceAgreementPage];
    [self.navigationController pushViewController:vc animated:YES];
}

- (UIView *)getFooterView{
    UIView *view = [[UIView alloc] init];
    
    UILabel *lab = [UILabel labelWithText:@"1.报名数只能在当前VIP服务城市使用；\n2.报名数请在当前VIP套餐有效期内使用，过期自动清零;\n3.剩余报名数为0时，当前VIP开通城市的岗位不能上直通车曝光。" textColor:[UIColor XSJColor_tGrayDeepTransparent32] fontSize:12.0f];
    lab.numberOfLines = 0;
    [view addSubview:lab];
    
    [lab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(view).offset(15);
        make.left.equalTo(view).offset(16);
        make.right.equalTo(view).offset(-16);
    }];
    
    CGFloat height = [lab contentSizeWithWidth:SCREEN_WIDTH - 32].height + 32;
    view.frame = CGRectMake(0, 0, SCREEN_WIDTH, height);
    return view;
}

#pragma mark - lazy
- (BuyApplyNumHeaderView *)headerView{
    if (!_headerView) {
        _headerView = [[BuyApplyNumHeaderView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 166)];
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
