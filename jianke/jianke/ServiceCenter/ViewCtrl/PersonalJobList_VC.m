//
//  PersonalJobList_VC.m
//  JKHire
//
//  Created by fire on 16/10/13.
//  Copyright © 2016年 xianshijian. All rights reserved.
//

#import "PersonalJobList_VC.h"
#import "SuccessPostPerson_VC.h"
#import "XSJRequestHelper.h"


#import "PersonPostedJobCell.h"

@interface PersonalJobList_VC () <PersonPostedJobCellDelegate>

@property (nonatomic, strong) QueryParamModel *queryParam;

@end

@implementation PersonalJobList_VC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我发布的需求";
    self.queryParam = [[QueryParamModel alloc] init];
    self.tableViewStyle = UITableViewStyleGrouped;
    [self initUIWithType:DisplayTypeOnlyTableView];
    [self.tableView registerNib:nib(@"PersonPostedJobCell") forCellReuseIdentifier:@"PersonPostedJobCell"];
    self.refreshType = RefreshTypeAll;
    [self initWithNoDataViewWithStr:@"您还没有发布过个人服务需求哦" onView:self.tableView];
    [self.tableView.header beginRefreshing];
}

- (void)headerRefresh{
    self.queryParam.page_num = @1;
    WEAKSELF
    [[XSJRequestHelper sharedInstance] entQueryServicePersonalJobList:self.service_type withAccountId:self.stu_account_id inHistory:nil queryParam:self.queryParam listType:@1 block:^(ResponseInfo *response) {
        [weakSelf.tableView.header endRefreshing];
        weakSelf.viewWithNoNetwork.hidden = YES;
        if (response) {
            NSArray *array = [JobModel objectArrayWithKeyValuesArray:[response.content objectForKey:@"service_personal_job_list"]];
            if (array.count) {
                weakSelf.dataSource = [array mutableCopy];
                weakSelf.viewWithNoData.hidden = YES;
                weakSelf.queryParam.page_num = @2;
                [weakSelf.tableView reloadData];
            }else{
                weakSelf.viewWithNoData.hidden = NO;
            }
        }else{
            weakSelf.viewWithNoData.hidden = YES;
            weakSelf.viewWithNoNetwork.hidden = NO;
        }
    }];
}

- (void)footerRefresh{
    WEAKSELF
    [[XSJRequestHelper sharedInstance] entQueryServicePersonalJobList:self.service_type withAccountId:self.stu_account_id inHistory:nil queryParam:self.queryParam listType:@1 block:^(ResponseInfo *response) {
        [weakSelf.tableView.footer endRefreshing];
        weakSelf.viewWithNoNetwork.hidden = YES;
        if (response) {
            NSArray *array = [JobModel objectArrayWithKeyValuesArray:[response.content objectForKey:@"service_personal_job_list"]];
            if (array.count) {
                [weakSelf.dataSource addObjectsFromArray:array];
                weakSelf.queryParam.page_num = @(weakSelf.queryParam.page_num.integerValue + 1);
                [weakSelf.tableView reloadData];
            }
        }else{
            weakSelf.viewWithNoData.hidden = YES;
            weakSelf.viewWithNoNetwork.hidden = NO;
        }
    }];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.dataSource ? self.dataSource.count : 0 ;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    PersonPostedJobCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PersonPostedJobCell" forIndexPath:indexPath];
    cell.delegate = self;
    JobModel *model = [self.dataSource objectAtIndex:indexPath.section];
    [cell setModel:model];
    return cell;
}

#pragma mark - uitableview delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    JobModel *model = [self.dataSource objectAtIndex:indexPath.section];
    return model.cellHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 21.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.1f;
}

#pragma mark - PersonPostedJobCellDelegate

- (void)inviteActionWithJobModel:(JobModel *)jobModel{
    WEAKSELF
    [[XSJRequestHelper sharedInstance] entInviteServicePersonal:self.stu_account_id serviceJobId:jobModel.service_personal_job_id block:^(id result) {
        if (result) {
            ELog(@"进入邀约成功页");
            SuccessPostPerson_VC *successViewCtrl = [[SuccessPostPerson_VC alloc] init];
            successViewCtrl.personServiceType = weakSelf.service_type;
            successViewCtrl.service_personal_job_id = jobModel.service_personal_job_id;
            [weakSelf.navigationController pushViewController:successViewCtrl animated:YES];
        }
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
