//
//  HiringJobList_VC.m
//  JKHire
//
//  Created by yanqb on 2017/2/8.
//  Copyright © 2017年 xianshijian. All rights reserved.
//

#import "HiringJobList_VC.h"
#import "BuyJobNum_VC.h"
#import "RecruitPostDetail_VC.h"
#import "VipIPacket_VC.h"
#import "VipInfoCenter_VC.h"
#import "HiringJobNumCell.h"
#import "HiringJobNumCell1.h"
#import "HiringJobNumCell2.h"

#import "MyEnum.h"

@interface HiringJobList_VC () <HiringJobNumCellDelegate, HiringJobNumCell2Delegate>

@property (nonatomic, assign) CGFloat heigtOfAllJobNumCell;
@property (nonatomic, strong) UIView *tableHeaderView;

@end

@implementation HiringJobList_VC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"在招岗位数";
    
    _heigtOfAllJobNumCell = 52;
    [self setupViews];
    [self loadData];
    [self getData:YES];
}

- (void)getData:(BOOL)isShowLoading{
    CityModel *cityModel = [UserData sharedInstance].city;
    WEAKSELF
    [[XSJRequestHelper sharedInstance] entQueryRecruitJobNumInfo:cityModel.id isShowLoading:isShowLoading block:^(ResponseInfo *response) {
        [weakSelf.tableView.header endRefreshing];
        if (response) {
            self.model = [RecruitJobNumInfo objectWithKeyValues:response.content];
            [weakSelf loadData];
        }
    }];
}

- (void)loadData{
    [self.dataSource removeAllObjects];
    if (self.model) {
        [self.dataSource addObject:@(hiringJobCellType_allJobBum)];
        [self.dataSource addObject:@(hiringJobCellType_usedJobNum)];
        [self.dataSource addObject:@(hiringJobCellType_leftJobNum)];
        if (![XSJUserInfoData isReviewAccount]) {
            [self.dataSource addObject:@(hiringJobCellType_vipInfo)];
        }
    }
    [self.tableView reloadData];
}

- (void)setupViews{
    self.tableViewStyle = UITableViewStyleGrouped;
    [self initUIWithType:DisplayTypeOnlyTableView];
    self.refreshType = RefreshTypeHeader;
    self.tableView.backgroundColor = [UIColor whiteColor];
    
    [self.tableView registerNib:nib(@"HiringJobNumCell") forCellReuseIdentifier:@"HiringJobNumCell"];
    [self.tableView registerClass:[HiringJobNumCell1 class                                                                                                                                                            ] forCellReuseIdentifier:@"HiringJobNumCell1"];
    [self.tableView registerNib:nib(@"HiringJobNumCell2") forCellReuseIdentifier:@"HiringJobNumCell2"];
    
}

- (void)headerRefresh{
    [self getData:NO];
}

#pragma mark - uitableview datasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (!self.dataSource.count) {
        return 0;
    }
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    hiringJobCellType cellType = [[self.dataSource objectAtIndex:indexPath.row] integerValue];
    
    switch (cellType) {
        case hiringJobCellType_allJobBum:{
            HiringJobNumCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HiringJobNumCell" forIndexPath:indexPath];
            cell.delegate = self;
            [cell setModel:self.model];
            return cell;
        }
        case hiringJobCellType_usedJobNum:
        case hiringJobCellType_leftJobNum:{
            HiringJobNumCell1 *cell = [tableView dequeueReusableCellWithIdentifier:@"HiringJobNumCell1" forIndexPath:indexPath];
            cell.cellType = cellType;
            [cell setModel:self.model];
            return cell;
        }
        case hiringJobCellType_vipInfo:{
            HiringJobNumCell2 *cell = [tableView dequeueReusableCellWithIdentifier:@"HiringJobNumCell2" forIndexPath:indexPath];
            cell.delegate = self;
            return cell;
        }
        default:
            break;
    }
    return nil;
}

#pragma mark - uitableview delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    hiringJobCellType cellType = [[self.dataSource objectAtIndex:indexPath.row] integerValue];
    switch (cellType) {
        case hiringJobCellType_allJobBum:{
            return _heigtOfAllJobNumCell;
        }
            break;
        case hiringJobCellType_vipInfo:{
            return 120.0f + 168.0f;
        }
        default:
            break;
    }
    return 52.0f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return self.tableHeaderView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 80.0f;
}

#pragma mark - HiringJobNumCellDelegate

- (void)HiringJobNumCell:(HiringJobNumCell *)cell actionType:(BtnOnClickActionType)actionType{
    switch (actionType) {
        case BtnOnClickActionType_Vip:{
            [self enterVipCenter];
        }
            break;
        case BtnOnClickActionType_recruitJobHistory:{
            RecruitPostDetail_VC *viewCtrl = [[RecruitPostDetail_VC alloc] init];
            WEAKSELF
            viewCtrl.block = ^(id result){
                [weakSelf getData:YES];
            };
            [self.navigationController pushViewController:viewCtrl animated:YES];
        }
            break;
        default:
            break;
    }
}

- (void)HiringJobNumCell:(HiringJobNumCell *)cell isDropDownDirect:(BOOL)isDropDownDirect{
    if (isDropDownDirect) {
        _heigtOfAllJobNumCell = 166;
    }else{
        _heigtOfAllJobNumCell = 50;
    }
    [self.tableView beginUpdates];
    [self.tableView endUpdates];
}

#pragma mark - HiringJobNumCell2Delegate

- (void)hiringJobNumCell2:(HiringJobNumCell2 *)cell actionType:(BtnOnClickActionType)actionType{
    switch (actionType) {
        case BtnOnClickActionType_buyVip:{
            WEAKSELF
            [[UserData sharedInstance] handleGlobalRMUrlWithType:GlobalRMUrlType_memberCenter block:^(UIViewController *viewCtrl) {
                [weakSelf.navigationController pushViewController:viewCtrl animated:YES];
            }];
        }
            break;
        case BtnOnClickActionType_buyPostJobNumber:{
            BuyJobNum_VC *viewCtrl = [[BuyJobNum_VC alloc] init];
            if (self.isFromPost) {
                NSAssert(self.cityId, @"cityId不能为空");
                viewCtrl.recruit_city_id = self.cityId;
                viewCtrl.actionType = BuyJobNumActionType_ForReBuy;
            }else{
                viewCtrl.actionType = BuyJobNumActionType_ForBuy;
            }
            WEAKSELF
            viewCtrl.block = ^(id result){
                [weakSelf getData:YES];
            };
            [self.navigationController pushViewController:viewCtrl animated:YES];
        }
            break;
        default:
            break;
    }
}

- (UIView *)tableHeaderView{
    if (!_tableHeaderView) {
        UIView *tableVHeaderView = [[UIView alloc] init];
        tableVHeaderView.backgroundColor = [UIColor whiteColor];
        _tableHeaderView = tableVHeaderView;
        
        UIImageView *imgHead = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"v320_firendly_icon"]];
        
        EPModel *epInfo = [[UserData sharedInstance] getEpModelFromHave];
        NSString *str = nil;
        if (epInfo.true_name.length) {
            str = [NSString stringWithFormat:@"您好，%@", epInfo.true_name];
        }else{
            str = @"您好，兼客";
        }
        
        UILabel *lab = [UILabel labelWithText:str textColor:[UIColor XSJColor_tGrayDeepTransparent2] fontSize:18.0f];
        
        UIView *line = [[UIView alloc] init];
        line.backgroundColor = [UIColor XSJColor_clipLineGray];

        [_tableHeaderView addSubview:imgHead];
        [_tableHeaderView addSubview:lab];
        [_tableHeaderView addSubview:line];
        
        [imgHead mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(tableVHeaderView).offset(16);
            make.centerY.equalTo(tableVHeaderView);
        }];
        
        [lab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(imgHead.mas_right).offset(2);
            make.centerY.equalTo(tableVHeaderView);
        }];
        
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(tableVHeaderView).offset(16);
            make.bottom.equalTo(tableVHeaderView);
            make.width.equalTo(@40);
            make.height.equalTo(@0.7);
        }];
    }
    return _tableHeaderView;
}

- (void)enterVipCenter{
    VipInfoCenter_VC *vc = [[VipInfoCenter_VC alloc] init];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
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
