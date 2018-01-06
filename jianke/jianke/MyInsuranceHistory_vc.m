//
//  MyInsuranceHistory_vc.m
//  JKHire
//
//  Created by yanqb on 2016/11/19.
//  Copyright © 2016年 xianshijian. All rights reserved.
//

#import "MyInsuranceHistory_vc.h"
#import "MyInsurancehistoryCell.h"
#import "DateSelectView.h"

@interface MyInsuranceHistory_vc ()<MyInsurancehistoryCellDelegate>

@property (nonatomic,strong) QueryParamModel *queryParam;

@end

@implementation MyInsuranceHistory_vc

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"被投保人";
    self.queryParam = [[QueryParamModel alloc] init];
    [self initUIWithType:DisplayTypeOnlyTableView];
    self.refreshType = RefreshTypeAll;
    [self.tableView registerNib:nib(@"MyInsurancehistoryCell") forCellReuseIdentifier:@"MyInsurancehistoryCell"];
    [self.tableView.header beginRefreshing];
}

- (void)headerRefresh{
    self.queryParam.page_num = @1;
    WEAKSELF
    [[XSJRequestHelper sharedInstance] queryInsuranceRecordDetailList:self.insurance_record_id queryParam:self.queryParam block:^(ResponseInfo *response) {
        [weakSelf.tableView.header endRefreshing];
        if (response) {
            NSArray *array = [InsurancePolicyParamModel objectArrayWithKeyValuesArray:[response.content objectForKey:@"insurance_record_detail_list"]];
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
    [[XSJRequestHelper sharedInstance] queryInsuranceRecordDetailList:self.insurance_record_id queryParam:self.queryParam block:^(ResponseInfo *response) {
        [weakSelf.tableView.footer endRefreshing];
        if (response) {
            NSArray *array = [InsurancePolicyParamModel objectArrayWithKeyValuesArray:[response.content objectForKey:@"insurance_record_detail_list"]];
            if (array.count) {
                weakSelf.queryParam.page_num = @(weakSelf.queryParam.page_num.integerValue + 1);
                [weakSelf.dataSource addObjectsFromArray:array];
                [weakSelf.tableView reloadData];
            }
        }
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MyInsurancehistoryCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MyInsurancehistoryCell" forIndexPath:indexPath];
    InsurancePolicyParamModel *model = [self.dataSource objectAtIndex:indexPath.row];
    cell.delegate = self;
    [cell setModel:model];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 79.0f;
}

- (void)MyInsurancehistoryCell:(MyInsurancehistoryCell *)cell withModel:(InsurancePolicyParamModel *)model{
    model.pingan_unit_price_ent = [[XSJRequestHelper sharedInstance] getClientGlobalModel].pingan_unit_price_ent.floatValue;
    
    DLAVAlertView *alertView = [[DLAVAlertView alloc] initWithTitle:@"投保日期" message:nil delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
    [alertView setMinContentWidth:300];
    
    UIView *containerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 280, 300)];
    //日历下方的label
    UILabel *allSalaryLabel = [[UILabel alloc]initWithFrame:CGRectMake(8, 270, 200, 20)];
    allSalaryLabel.font = [UIFont systemFontOfSize:12];
    NSInteger days = model.insurance_date_list.count;
    NSString *allDayPay = [NSString stringWithFormat:@"￥%.2f", days * (model.pingan_unit_price_ent) * 0.01];
    allSalaryLabel.text = [NSString stringWithFormat:@"投保金额:%@", allDayPay];
    [containerView addSubview:allSalaryLabel];
    
    // 日期控件
    DateSelectView *dateView = [[DateSelectView alloc] initWithFrame:CGRectMake(0, 0, 280, 260)];
    dateView.type = DateViewType_ViewPinganInsurance;
    [containerView addSubview:dateView];
    alertView.contentView = containerView;
    
    //  可投保时间范围
    NSDate * startDate = [NSDate dateWithTimeIntervalSinceNow:-(24 * 1000 * 60 * 60)];
    NSDate * endDate = [NSDate dateWithTimeIntervalSinceNow:(24 * 1000 * 60 * 60)];
    dateView.startDate = startDate;
    dateView.endDate = endDate;
    
    NSDate *datesPayDate;
    NSMutableArray *tmpDatesPayArr = [NSMutableArray array];
    for (NSNumber *datePayNum in model.insurance_date_list) {
        datesPayDate = [NSDate dateWithTimeIntervalSince1970:(datePayNum.longLongValue * 0.001)];
        [tmpDatesPayArr addObject:datesPayDate];
    }
    dateView.datesPay = [tmpDatesPayArr copy];
    
    for (NSNumber *dateNum in model.insurance_date_list) {
        NSDate *date = [NSDate dateWithTimeIntervalSince1970:dateNum.longLongValue * 0.001];
        [dateView.datesSelected addObject:date];
    }
    
    //alertView操作
    [alertView showWithCompletion:^(DLAVAlertView *alertView, NSInteger buttonIndex) {
    }];
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
