//
//  RecruitPostDetail_VC.m
//  JKHire
//
//  Created by yanqb on 2017/2/13.
//  Copyright © 2017年 xianshijian. All rights reserved.
//

#import "RecruitPostDetail_VC.h"
#import "RecruitPostDetailCell.h"
#import "BuyJobNum_VC.h"

@interface RecruitPostDetail_VC () <RecruitPostDetailCellDelegate>

@end

@implementation RecruitPostDetail_VC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"在招岗位数";
    [self initUIWithType:DisplayTypeOnlyTableView];
    self.tableView.backgroundColor = [UIColor XSJColor_newWhite];
    [self.tableView registerNib:nib(@"RecruitPostDetailCell") forCellReuseIdentifier:@"RecruitPostDetailCell"];
    [self getData];
}

- (void)getData{
    WEAKSELF
    [[XSJRequestHelper sharedInstance] entQueryRecruitJobNumRecordList:[UserData sharedInstance].city.id block:^(ResponseInfo *response) {
        if (response) {
            NSArray *array = [RecruitJobNumRecord objectArrayWithKeyValuesArray:[response.content objectForKey:@"recruit_job_num_record_list"]];
            weakSelf.dataSource = [array mutableCopy];
            [weakSelf.tableView reloadData];
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
    RecruitJobNumRecord *model = [self.dataSource objectAtIndex:indexPath.section];
    RecruitPostDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RecruitPostDetailCell" forIndexPath:indexPath];
    cell.delegate = self;
    [cell setModel:model];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 76.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return 12.0f;
    }
    return 4.0f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [UIColor XSJColor_newWhite];
    return view;
}

- (void)btnOnClickWithRecruitPostDetailCell:(RecruitPostDetailCell *)cell withModel:(RecruitJobNumRecord *)model{
    ELog(@"在招岗位数续费");
    BuyJobNum_VC *viewCtrl = [[BuyJobNum_VC alloc] init];
    viewCtrl.actionType = BuyJobNumActionType_ForRenew;
    viewCtrl.block = self.block;
    viewCtrl.recruit_city_id = model.recruit_city_id;
    viewCtrl.recruit_job_num = model.recruit_job_num;
    viewCtrl.record_id = model.id;
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
