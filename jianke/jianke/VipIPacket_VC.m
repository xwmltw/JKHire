
//
//  VipIPacket_VC.m
//  JKHire
//
//  Created by yanqb on 2017/5/9.
//  Copyright © 2017年 xianshijian. All rights reserved.
//

#import "VipIPacket_VC.h"
#import "VIPHeaderView.h"
#import "VipPacket_Cell.h"
#import "VipPacket_Cell2.h"
#import "GuideMaskView.h"
#import "CitySelectController.h"
#import "WebView_VC.h"
#import "PaySelect_VC.h"
#import "VipPacker_cell3.h"
#import "VipPacket_Cell3.h"
#import "VIPRule_VC.h"
#import "OnlinePayViewController.h"

@interface VipIPacket_VC () <VIPHeaderViewDelegate, UITextFieldDelegate, UIAlertViewDelegate>

@property (nonatomic, copy) NSArray *vipList;
@property (nonatomic, strong) VipPackageEntryModel *model;
@property (nonatomic, strong) VIPHeaderView *headerView;
@property (nonatomic, strong) CityModel *cityModel;
@property (nonatomic, weak) UIButton *btn;
@property (nonatomic, copy) NSNumber *saleCode; //推荐码
@property (nonatomic, copy) NSNumber *curr_city_is_account_vip;

@end

@implementation VipIPacket_VC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"VIP套餐";
    self.view.backgroundColor = [UIColor XSJColor_newWhite];
    self.cityModel = [UserData sharedInstance].city;
    self.btntitles = @[@"", @"购买套餐"];
    self.marginTopY = 48;
    [self initUIWithType:DisplayTypeTableViewAndLeftRightEspectBottom];
    self.refreshType = RefreshTypeHeader;
    self.tableView.backgroundColor = [UIColor XSJColor_newWhite];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerNib:nib(@"VipPacket_Cell") forCellReuseIdentifier:@"VipPacket_Cell"];
     [self.tableView registerNib:nib(@"VipPacket_Cell2") forCellReuseIdentifier:@"VipPacket_Cell2"];
    [self.tableView registerNib:nib(@"VipPacker_cell3") forCellReuseIdentifier:@"VipPacker_cell3"];
    [self.tableView registerNib:nib(@"VipPacket_Cell3") forCellReuseIdentifier:@"VipPacket_Cell3"];
    [self setupBotViews];
    [self getData:YES];
}

- (void)setupBotViews{
    self.bottomView.backgroundColor = [UIColor whiteColor];
    self.btn = [self.bottomBtns objectAtIndex:0];
    [self.btn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    [self.btn setContentEdgeInsets:UIEdgeInsetsMake(0, 24, 0, 0)];
    
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
        make.bottom.equalTo(self.btn.mas_top).offset(-16);
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
    
    self.bottomView.hidden = YES;
}

#pragma mark - 网络部分

- (void)headerRefresh{
    [self getData:NO];
}

- (void)getData:(BOOL)isShowLoading{
    WEAKSELF
    [[XSJRequestHelper sharedInstance] getVipPackageEntryList:self.cityModel.id isShowLoading:isShowLoading block:^(ResponseInfo *response) {
        [weakSelf.tableView.header endRefreshing];
        if (response) {
            weakSelf.curr_city_is_account_vip = [response.content objectForKey:@"curr_city_is_account_vip"];
            NSArray *array = [VipPackageEntryModel objectArrayWithKeyValuesArray:[response.content objectForKey:@"vip_package_entry_list"]];
            weakSelf.vipList = array;
            weakSelf.tableView.tableHeaderView = nil;
            if (weakSelf.vipList.count) {
                weakSelf.tableView.tableHeaderView = [weakSelf getHeaderView];
//                weakSelf.tableView.tableFooterView = weakSelf.footerView;
//                [weakSelf.footerView setModel:self.cityModel];
                weakSelf.model = weakSelf.vipList.firstObject;
                weakSelf.bottomView.hidden = NO;
                [weakSelf updateBtn];
            }else{
                weakSelf.tableView.tableHeaderView = [weakSelf getNoDataView];
                weakSelf.bottomView.hidden = YES;
            }
            [self loadData];
        }
    }];
}

- (void)loadData{
    [self.dataSource removeAllObjects];
    if (self.vipList.count) {
        NSMutableArray *array = [NSMutableArray array];
        [self.model.package_item_arr enumerateObjectsUsingBlock:^(PackageItem *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if (!obj.package_item_num.integerValue && !obj.package_item_value.integerValue) {
                return;
            }
            [array addObject:obj];
        }];
        NSMutableArray *array1 = [NSMutableArray array];
        [array1 addObject:@(VipPacketCellType_service)];
        [array1 addObject:@(VipPacketCellType_chooseCityWithData)];
        [array1 addObject:@(VipPacketCellType_qrcode)];
        [array1 addObject:@(VipPacketCellType_guize)];
        
        [self.dataSource addObject:array];
        [self.dataSource addObject:array1];
    }else{
        NSMutableArray *array = [NSMutableArray array];
        [array addObject:@(VipPacketCellType_chooseCity)];
        [self.dataSource addObject:array];
    }
    [self.tableView reloadData];
}

#pragma mark - uitableview datasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.dataSource.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSArray *array = [self.dataSource objectAtIndex:section];
    return array.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    id model = [[self.dataSource objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    if ([model isKindOfClass:[PackageItem class]]) {
        VipPacket_Cell *cell = [tableView dequeueReusableCellWithIdentifier:@"VipPacket_Cell" forIndexPath:indexPath];
        [cell setModel:model indexPath:indexPath];
        return cell;
    }else{
        VipPacketCellType cellType = [model integerValue];
        switch (cellType) {
            case VipPacketCellType_service:{
                VipPacket_Cell2 *cell = [tableView dequeueReusableCellWithIdentifier:@"VipPacket_Cell2" forIndexPath:indexPath];
                cell.model = self.model;
                [cell setCityModel:self.cityModel];
                return cell;
            }
                break;
            case VipPacketCellType_chooseCity:{
                VipPacker_cell3 *cell = [tableView dequeueReusableCellWithIdentifier:@"VipPacker_cell3" forIndexPath:indexPath];
                return cell;
            }
                break;
            case VipPacketCellType_qrcode:
            case VipPacketCellType_guize:
            case VipPacketCellType_chooseCityWithData:{
                VipPacket_Cell3 *cell = [tableView dequeueReusableCellWithIdentifier:@"VipPacket_Cell3" forIndexPath:indexPath];
                cell.cellType = cellType;
                [cell setModel:self.cityModel];
                [cell setSaleCode:self.saleCode];
                return cell;
            }
                
            default:
                break;
        }
    }
    return nil;
}

#pragma mark - uitableview delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    id model = [[self.dataSource objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    if ([model isKindOfClass:[NSNumber class]]) {
        VipPacketCellType cellType = [model integerValue];
        switch (cellType) {
            case VipPacketCellType_service:{
                return 177.0f;
            }
                break;
            case VipPacketCellType_chooseCity:{
                return 57.0f;
            }
            case VipPacketCellType_guize:
            case VipPacketCellType_qrcode:
            case VipPacketCellType_chooseCityWithData:{
                return 54.0f;
            }
            default:
                break;
        }
    }else if ([model isKindOfClass:[PackageItem class]]){
        PackageItem *item = (PackageItem *)model;
        return item.cellHeight;
    }
    return 36.0f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    id model = [[self.dataSource objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    if ([model isKindOfClass:[PackageItem class]]) {
        PackageItem *item = (PackageItem *)model;
        GuideMaskView *mask = [[GuideMaskView alloc] initWithTitle:item.package_item_title subTitle:item.package_item_value_desc content:item.package_item_content imgUrlStr:item.package_item_icon cancel:nil commit:@"我知道了" block:^(NSInteger result) {
            
        }];
        mask.animationType = showAnimationType_moveIn;
        mask.subType = kCATransitionFromBottom;
        mask.alertView.titleLab.font = [UIFont systemFontOfSize:14.0f];
        mask.alertView.labcontent.font = [UIFont systemFontOfSize:13.0f];
        [mask show];
    }else{
        VipPacketCellType cellType = [model integerValue];
        switch (cellType) {
            case VipPacketCellType_chooseCity:{
                [TalkingData trackEvent:@"VIP会员_切换城市"];
            }
            case VipPacketCellType_chooseCityWithData:{
                [self chooseCity];
            }
                break;
            case VipPacketCellType_qrcode:{
                [TalkingData trackEvent:@"VIP会员_填写推荐码"];
                [self inputSaleCode];
            }
                break;
            case VipPacketCellType_guize:{
                [self enterRule];
            }
                break;
            default:
                break;
        }
    }
    
}

#pragma mark - 重写方法

- (void)clickOnview:(UIView *)bottomView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 1) {
        [self makeSend];
    }
}

- (void)makeSend{
    [TalkingData trackEvent:@"VIP会员_购买套餐按钮"];
    if (self.curr_city_is_account_vip.integerValue == 1) {
        [GuideMaskView showTitle:@"提示" content:@"当前城市已开通VIP服务，不能重复购买。是否切换其他城市？" cancel:@"切换城市" commit:@"取消购买" block:^(NSInteger result) {
            if (result == 0) {
                [self chooseCity];
            }
        }];
        return;
    }
    WEAKSELF
    NSNumber *totalAmount = self.model.total_price;
    if (self.model.promotion_price) {
        totalAmount = self.model.promotion_price;
    }
    [[XSJRequestHelper sharedInstance] rechargeVipPackageWithVipId:self.model.package_id totalAmount:totalAmount cityId:self.cityModel.id saleManId:self.saleCode block:^(ResponseInfo *response) {
        if (response) {
//            PaySelect_VC *vc = [[PaySelect_VC alloc] init];
//            vc.needPayMoney = totalAmount.intValue;
//            vc.fromType = PaySelectFromType_payVipOrder;
//            vc.vip_order_id = [response.content objectForKey:@"vip_order_id"];
//            vc.updateDataBlock = weakSelf.block;
//            [weakSelf.navigationController pushViewController:vc animated:YES];
            OnlinePayViewController *vc = [[OnlinePayViewController alloc]init];
            vc.needPayMoney = totalAmount.intValue;
            vc.vip_order_id = [response.content objectForKey:@"vip_order_id"];
            vc.updateDataBlock = weakSelf.block;
            vc.des = self.model.package_order_desc;
            vc.city = self.cityModel.name;
            vc.date = self.model.vip_keep_months;
            vc.name = self.model.package_name;
            [weakSelf.navigationController pushViewController:vc animated:YES];
        }
    }];
}

#pragma mark - 业务方法
- (VIPHeaderView *)getHeaderView{
    _headerView = [[VIPHeaderView alloc] initWithVipList:_vipList];
    _headerView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 110);
    _headerView.delegate = self;
    return _headerView;
}

//- (VIPFooterView *)footerView{
//    if (!_footerView ) {
//        _footerView = [[VIPFooterView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 110)];
//        _footerView.delegate = self;
//    }
//    return _footerView;
//}

- (void)VIPHeaderView:(VIPHeaderView *)headerView index:(NSInteger)index{
    self.model = self.vipList[index];
    [self updateBtn];
    [self loadData];
}

- (void)enterRule{
    [TalkingData trackEvent:@"VIP会员_了解VIP套餐适用规则"];
    VIPRule_VC *vc = [[VIPRule_VC alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)inputSaleCode{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"请输入推荐码" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil];
    alertView.alertViewStyle = UIAlertViewStylePlainTextInput;
    UITextField *utf = [alertView textFieldAtIndex:0];
    utf.placeholder = @"输入4位推荐码";
    utf.keyboardType = UIKeyboardTypeDecimalPad;
    utf.delegate = self;
    [alertView show];
}

- (void)requestSale:(NSString *)desc{
    WEAKSELF
    [[XSJRequestHelper sharedInstance] postSaleClueWithDesc:desc isNeedContact:@1 isShowloading:YES block:^(id result) {
        [weakSelf showAlertView];
    }];
}

- (void)showAlertView{
    GuideMaskView *maskView = [[GuideMaskView alloc] initWithTitle:@"业务咨询提交成功" content:@"您的业务咨询已传达给优聘顾问，顾问会在一个工作日内与您联系，请您保持手机通畅。" cancel:nil commit:@"我知道了" block:nil];
    maskView.alertView.titleLab.font = [UIFont systemFontOfSize:16.0f];
    maskView.alertView.labcontent.font = [UIFont systemFontOfSize:14.0f];
    [maskView show];
}

- (void)chooseCity{
    CitySelectController *viewCtrl = [[CitySelectController alloc] init];
    viewCtrl.isPushAction = YES;
    viewCtrl.showType = CitySelectControllerShowType_filterVip;
    WEAKSELF
    viewCtrl.didSelectCompleteBlock = ^(CityModel *cityModel){
        if (cityModel) {
            weakSelf.cityModel = cityModel;
            [weakSelf getData:YES];
        }
    };
    [self.navigationController pushViewController:viewCtrl animated:YES];
}

- (void)updateBtn{
    NSString *str = [NSString stringWithFormat:@"¥%.2f", self.model.promotion_price.floatValue * 0.01];
    str = [str stringByReplacingOccurrencesOfString:@".00" withString:@""];
    NSMutableAttributedString *mutalStr = [[NSMutableAttributedString alloc] initWithString:str attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:20.0f], NSForegroundColorAttributeName: [UIColor XSJColor_middelRed], NSBaselineOffsetAttributeName: @0}];
    NSAttributedString *attStr = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"/%ld个月", self.model.vip_keep_months.integerValue] attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:14.0f], NSForegroundColorAttributeName: [UIColor XSJColor_tGrayHistoyTransparent64], NSBaselineOffsetAttributeName: @2}];
    [mutalStr appendAttributedString:attStr];
    [self.btn setAttributedTitle:mutalStr forState:UIControlStateNormal];
}

- (void)btnOnClick:(UIButton *)sender{
    WebView_VC* vc = [[WebView_VC alloc] init];
    vc.url = [NSString stringWithFormat:@"%@%@", URL_HttpServer, KUrl_toValueAddServiceAgreementPage];
    [self.navigationController pushViewController:vc animated:YES];
}

- (UIView *)getNoDataView{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 289.0f)];
    UIView *nodataView = [UIHelper noDataViewWithTitleArr:@[@"当前城市暂无VIP套餐", @"您可以选择其他城市哦~"] titleColor:nil image:@"v3_public_nobill" button:nil];
    nodataView.hidden = NO;
    nodataView.y = 80;
    nodataView.height = 209.0f;
    [view addSubview:nodataView];
    return view;
}

#pragma mark - uialertview delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 0) {
        return;
    }
    UITextField *utf = [alertView textFieldAtIndex:0];
    if (utf.text.length != 4) {
        [UIHelper toast:@"请输入4位数的推荐码"];
        [self inputSaleCode];
        return;
    }
    WEAKSELF
    [[XSJRequestHelper sharedInstance] getAdminUserInfoWithSaleCode:@(utf.text.integerValue) block:^(ResponseInfo *response) {
        if (response) {
            NSNumber *result = [response.content objectForKey:@"is_exists"];
            if (result.integerValue == 1) {
                [UIHelper toast:@"推荐码校验成功"];
                weakSelf.saleCode = @(utf.text.integerValue);
                [weakSelf.tableView reloadData];
            }else{
                [UIHelper toast:@"推荐码错误"];
            }
            
        }
    }];
}

#pragma mark - uitextfeild delegate
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if (range.location >= 4) { //置换最后一位
        return NO;
        return YES;
    }
    return YES;
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
