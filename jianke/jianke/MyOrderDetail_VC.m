//
//  MyOrderDetail_VC.m
//  JKHire
//
//  Created by fire on 16/10/24.
//  Copyright © 2016年 xianshijian. All rights reserved.
//

#import "MyOrderDetail_VC.h"
#import "MyOrderDetailCell.h"

@interface MyOrderDetail_VC ()

@property (nonatomic, strong) TeamCompanyModel *jobModel;

@end

@implementation MyOrderDetail_VC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"订单详情";
    [self initUIWithType:DisplayTypeOnlyTableView];
    self.tableView.backgroundColor = MKCOLOR_RGB(233, 233, 233);
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerNib:nib(@"MyOrderDetailCell") forCellReuseIdentifier:@"MyOrderDetailCell"];
    [self getData];
}

- (void)getData{
    WEAKSELF
    [[XSJRequestHelper sharedInstance] getServiceTeamJobApplyDetailWithApplyId:self.service_team_job_apply_id block:^(ResponseInfo *response) {
        if (response) {
            weakSelf.jobModel = [TeamCompanyModel objectWithKeyValues:[response.content objectForKey:@"service_team_job_apply"]];
            [weakSelf.tableView reloadData];
        }
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.jobModel ? 1 : 0 ;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MyOrderDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MyOrderDetailCell" forIndexPath:indexPath];
    [cell setModel:self.jobModel];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return self.jobModel.cellHeight;
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
