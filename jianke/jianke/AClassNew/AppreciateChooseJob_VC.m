//
//  AppreciateChooseJob_VC.m
//  JKHire
//
//  Created by yanqb on 2017/4/5.
//  Copyright © 2017年 xianshijian. All rights reserved.
//

#import "AppreciateChooseJob_VC.h"
#import "AppreciateChooseJobCell.h"
#import "JobModel.h"

@interface AppreciateChooseJob_VC ()

@property (nonatomic, strong) JobModel *  jobModel;

@end

@implementation AppreciateChooseJob_VC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"选择岗位";
    [self loadDatas];
    self.tableViewStyle = UITableViewStyleGrouped;
    [self initUIWithType:DisplayTypeOnlyTableView];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerNib:nib(@"AppreciateChooseJobCell") forCellReuseIdentifier:@"AppreciateChooseJobCell"];
}

- (void)loadDatas{
    [self.dataSource enumerateObjectsUsingBlock:^(JobModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (self.iszhiding && obj.stick.integerValue == 1) {
            [self.dataSource removeObjectAtIndex:idx];
            return;
        }
        if (idx == 0) {
            obj.selected = YES;
            self.jobModel = obj;
            return;
        }else{
            obj.selected = NO;
        }
        if (self.jobId && [self.jobId isEqualToNumber:obj.job_id]) {
            obj.selected = YES;
            self.jobModel = obj;
            JobModel *obj1 = self.dataSource[0];
            obj1.selected = NO;
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
    AppreciateChooseJobCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AppreciateChooseJobCell" forIndexPath:indexPath];
    JobModel *jobModel = [self.dataSource objectAtIndex:indexPath.section];
    cell.jobModel = jobModel;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 70.0f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [UIColor XSJColor_newGray];
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return 16.0f;
    }
    return 4.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    JobModel *jobModel = [self.dataSource objectAtIndex:indexPath.section];
    MKBlockExec(self.block, jobModel);
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)backToLastView{
    MKBlockExec(self.block, self.jobModel);
    [self.navigationController popViewControllerAnimated:YES];
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
