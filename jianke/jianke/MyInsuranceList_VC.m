//
//  MyInsuranceList_VC.m
//  JKHire
//
//  Created by yanqb on 2016/11/17.
//  Copyright © 2016年 xianshijian. All rights reserved.
//

#import "MyInsuranceList_VC.h"
#import "NewBuyInsurance_VC.h"
#import "MyInsuranceCell.h"
#import "MyInsuranceHistory_vc.h"
#import "WebView_VC.h"

@interface MyInsuranceList_VC ()

@property (nonatomic, strong) QueryParamModel *queryParam;

@end

@implementation MyInsuranceList_VC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"兼职保险";
    self.queryParam = [[QueryParamModel alloc] init];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"frequent_icon_questionmark"] style:UIBarButtonItemStylePlain target:self action:@selector(showQA)];
    
    self.tableViewStyle = UITableViewStyleGrouped;
    self.btntitles = @[@"立即投保"];
    if (![[XSJUserInfoData sharedInstance] getIsCloseInsuranceAD]) {
        [self initUIWithType:DisplaytypeBannerWithBottom];
        [self.XZTopBanner.button setTitle:@"  尊享十万意外兼职险" forState:UIControlStateNormal];
    }else{
        [self initUIWithType:DisplayTypeTableViewAndBottom];
    }
    [self initWithNoDataViewWithStr:@"您还没有投过保哦" onView:self.tableView];
    [self.tableView registerNib:nib(@"MyInsuranceCell") forCellReuseIdentifier:@"MyInsuranceCell"];

    self.refreshType = RefreshTypeAll;
    [self.tableView.header beginRefreshing];
}

- (void)headerRefresh{
    self.queryParam.page_num = @1;
    WEAKSELF
    [[XSJRequestHelper sharedInstance] queryInsuranceRecordList:self.queryParam block:^(ResponseInfo *response) {
        [weakSelf.tableView.header endRefreshing];
        if (response) {
            NSArray *array = [InsuranceRecordModel objectArrayWithKeyValuesArray:[response.content objectForKey:@"insurance_record_list"]];
            if (array.count) {
                weakSelf.viewWithNoData.hidden = YES;
                weakSelf.queryParam.page_num = @2;
                weakSelf.dataSource = [array mutableCopy];
                [weakSelf.tableView reloadData];
            }else{
                weakSelf.viewWithNoData.hidden = NO;
            }
        }
    }];
}

- (void)footerRefresh{
    WEAKSELF
    [[XSJRequestHelper sharedInstance] queryInsuranceRecordList:self.queryParam block:^(ResponseInfo *response) {
        [weakSelf.tableView.footer endRefreshing];
        if (response) {
            NSArray *array = [InsuranceRecordModel objectArrayWithKeyValuesArray:[response.content objectForKey:@"insurance_record_list"]];
            if (array.count) {
                weakSelf.queryParam.page_num = @(weakSelf.queryParam.page_num.integerValue + 1);
                [weakSelf.dataSource addObjectsFromArray:array];
                [weakSelf.tableView reloadData];
            }
        }
    }];
}

#pragma mark - uitableview datasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.dataSource.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MyInsuranceCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MyInsuranceCell" forIndexPath:indexPath];
    InsuranceRecordModel *model = [self.dataSource objectAtIndex:indexPath.section];
    [cell setModel:model];
    return cell;
}

#pragma mark - uitableview delegate

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 20.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.1f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 83.0f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    InsuranceRecordModel *model = [self.dataSource objectAtIndex:indexPath.section];
    MyInsuranceHistory_vc *viewCtrl = [[MyInsuranceHistory_vc alloc] init];
    viewCtrl.insurance_record_id = model.insurance_record_id;
    [self.navigationController pushViewController:viewCtrl animated:YES];
}

#pragma mark - 重写方法

- (void)clickOnview:(UIView *)bottomView clickedButtonAtIndex:(NSInteger)buttonIndex{
    NewBuyInsurance_VC *viewCtrl = [[NewBuyInsurance_VC alloc] init];
    viewCtrl.popVC = self;
    WEAKSELF
    viewCtrl.block = ^(id result){
        [weakSelf headerRefresh];
    };
    [self.navigationController pushViewController:viewCtrl animated:YES];
}

- (void)clickOnBannerview:(UIView *)bannerView actiontype:(BannerBtnActiontype)actionType{
    switch (actionType) {
        case BannerBtnActiontype_AD:{
            [[XSJUserInfoData sharedInstance] setIsCloseInsuranceAD:YES];
        }
            break;
        case BannerBtnActiontype_Dissmiss:{
            WebView_VC *viewCtrl = [[WebView_VC alloc] init];
            NSString *url = [NSString stringWithFormat:@"%@%@", URL_HttpServer, KUrl_toSeekerInsurancePage];
            viewCtrl.url = url;
            [self.navigationController pushViewController:viewCtrl animated:YES];
        }
            break;
        default:
            break;
    }
}

#pragma mark - 其他

- (void)showQA{
    WebView_VC *viewCtrl = [[WebView_VC alloc] init];
    viewCtrl.url = KUrl_insuranceHelp;
    [self.navigationController pushViewController:viewCtrl animated:YES];
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
