//
//  MyFanseList_VC.m
//  JKHire
//
//  Created by fire on 16/11/4.
//  Copyright © 2016年 xianshijian. All rights reserved.
//

#import "MyFanseList_VC.h"
#import "LookupResume_VC.h"
#import "MyFanseCell.h"

@interface MyFanseList_VC ()

@property (nonatomic, strong) QueryParamModel *queryParam;

@end

@implementation MyFanseList_VC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的粉丝";
    self.queryParam = [[QueryParamModel alloc] init];
    [self initUIWithType:DisplayTypeOnlyTableView];
    self.refreshType = RefreshTypeAll;
    self.tableView.separatorStyle = UITableViewCellSelectionStyleNone;
    [self.tableView registerClass:[MyFanseCell class] forCellReuseIdentifier:@"MyFanseCell"];
    [self initWithNoDataViewWithStr:@"你还没有粉丝哦" onView:self.tableView];
    [self.tableView.header beginRefreshing];
}

- (void)headerRefresh{
    self.queryParam.page_num = @1;
    WEAKSELF
    [[XSJRequestHelper sharedInstance] entQueryFocusFansListWithQueryParam:self.queryParam block:^(ResponseInfo *response) {
        [weakSelf.tableView.header endRefreshing];
        if (response) {
            NSArray *array = [JKModel objectArrayWithKeyValuesArray:[response.content objectForKey:@"focus_fans_list"]];
            if (array.count) {
                weakSelf.viewWithNoData.hidden = YES;
                weakSelf.dataSource = [array mutableCopy];
                weakSelf.queryParam.page_num = @2;
                [weakSelf.tableView reloadData];
            }else{
                weakSelf.viewWithNoData.hidden = NO;
            }
        }
    }];
}

- (void)footerRefresh{
    WEAKSELF
    [[XSJRequestHelper sharedInstance] entQueryFocusFansListWithQueryParam:self.queryParam block:^(ResponseInfo *response) {
        [weakSelf.tableView.footer endRefreshing];
        if (response) {
            NSArray *array = [JKModel objectArrayWithKeyValuesArray:[response.content objectForKey:@"focus_fans_list"]];
            if (array.count) {
                [weakSelf.dataSource addObjectsFromArray:array];
                weakSelf.queryParam.page_num = @(weakSelf.queryParam.page_num.integerValue + 1);
                [weakSelf.tableView reloadData];
            }
        }
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MyFanseCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MyFanseCell" forIndexPath:indexPath];
    JKModel *model = [self.dataSource objectAtIndex:indexPath.row];
    [cell setModel:model];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80.0f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    JKModel *jkModel = [self.dataSource objectAtIndex:indexPath.row];
    LookupResume_VC *vc = [[LookupResume_VC alloc] init];
    vc.resumeId = jkModel.resume_id;
    vc.isFromToLookUpResume = 2;
    vc.accountId = jkModel.account_id.description;
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
