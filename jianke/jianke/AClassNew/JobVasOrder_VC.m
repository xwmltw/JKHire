//
//  JobVasOrder_VC.m
//  jianke
//
//  Created by fire on 16/9/24.
//  Copyright © 2016年 xianshijian. All rights reserved.
//

#import "JobVasOrder_VC.h"
#import "JianKeAppreciation_VC.h"
#import "JobVasOrderCell.h"
#import "PushOrder_VC.h"
#import "WebView_VC.h"
#import "JobModel.h"
#import "JobAutoRefresh_VC.h"

@interface JobVasOrder_VC () <JobVasOrderCellDelegate>

@property (nonatomic, strong) JobVasResponse *model;
@property (nonatomic, strong) NSMutableDictionary<NSNumber * , NSNumber *> *cellHeightDic;   /*!< cell高度 */

@end

@implementation JobVasOrder_VC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = self.isShowZhaoRenTitle ? @"招人神器" : @"付费推广";
    
    self.tableViewStyle = UITableViewStyleGrouped;
    [self initUIWithType:DisplayTypeOnlyTableView];
    [self.tableView registerNib:nib(@"JobVasOrderCell") forCellReuseIdentifier:@"aJobVasOrderCell"];
    self.cellHeightDic = [NSMutableDictionary dictionary];
    [self uploadRecord];
}

- (void)uploadRecord{
    [[XSJRequestHelper sharedInstance] recordPageVisitLogWithVisitPageId:@2 block:nil];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self getData];
}

- (void)getData{
    if (!self.jobId) {
        [self loadUIData];
        return;
    }
    WEAKSELF
    [[XSJRequestHelper sharedInstance] queryJobVasInfo:self.jobId block:^(ResponseInfo *result) {
        if (result) {
            weakSelf.model = [JobVasResponse objectWithKeyValues:result.content];
            [weakSelf loadUIData];
        }
    }];
}

- (void)loadUIData{
    if (self.dataSource.count == 0) {
        [self.dataSource addObject:@(Appreciation_push_Type)];
        [self.dataSource addObject:@(Appreciation_stick_Type)];
        [self.dataSource addObject:@(Appreciation_Refresh_Type)];
    }
//    [self.dataSource removeAllObjects];

    [self.tableView reloadData];
}

#pragma mark - uitableview datasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.dataSource ? self.dataSource.count : 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    JobVasOrderCell *cell = [tableView dequeueReusableCellWithIdentifier:@"aJobVasOrderCell" forIndexPath:indexPath];
    AppreciationType type = ((NSNumber *)[self.dataSource objectAtIndex:indexPath.section]).integerValue;
    cell.delegate = self;
    cell.jobIsOver = self.jobIsOver;
    [cell setData:self.model andType:type cellDic:self.cellHeightDic];
    return cell;
}

#pragma mark - uitableview delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat height = [self.cellHeightDic objectForKey:[self.dataSource objectAtIndex:indexPath.section]].floatValue;
    return height;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 21.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01f;
}

#pragma mark - JobVasOrderCell delegate

- (void)jobVasOrderCell:(JobVasOrderCell *)cell actionType:(NSInteger)type{
    switch (type) {
        case 1:{
            BOOL hasAlert = [[UserData sharedInstance] isHasAlertWithJobId:self.jobId];
            if ((self.model.top_dead_time.doubleValue * 0.001) >= [NSDate date].timeIntervalSince1970 && !hasAlert) {
                [MKAlertView alertWithTitle:nil message:@"你好，本岗位处于置顶效果中。与刷新的效果有一定的重复，推荐您使用‘推送’功能。" cancelButtonTitle:nil confirmButtonTitle:@"我知道了" completion:^(UIAlertView *alertView, NSInteger buttonIndex) {
                    [[UserData sharedInstance] setHasAlertWithJobId:self.jobId];
                }];
            }else{
                JianKeAppreciation_VC *viewCtrl = [[JianKeAppreciation_VC alloc] init];
                viewCtrl.serviceType = type;
                viewCtrl.jobId = self.jobId;
                viewCtrl.popToVC = self;
                [self.navigationController pushViewController:viewCtrl animated:YES];
            }
        }
            break;
        case 2:{
            JobAutoRefresh_VC *viewCtrl = [[JobAutoRefresh_VC alloc] init];
            viewCtrl.jobId = self.jobId;
            viewCtrl.popToVC = self;
            [self.navigationController pushViewController:viewCtrl animated:YES];
        }
            break;
        case 3:{
            PushOrder_VC *viewCtrl = [[PushOrder_VC alloc] init];
            viewCtrl.jobId = self.jobId;
            viewCtrl.isShowHistory = (self.model.last_push_time !=nil && self.model.last_push_time.longLongValue > 0);
            viewCtrl.isFromJobManage = self.isFromSuccess;
            [self.navigationController pushViewController:viewCtrl animated:YES];
        }
        default:
            break;
    }
}

- (void)pushHistoryBtnOnClick{
    WebView_VC* vc = [[WebView_VC alloc] init];
    vc.url = [NSString stringWithFormat:@"%@%@%@", URL_HttpServer, KUrl_jobPushOrderList, self.jobId];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)backToLastView{
    MKBlockExec(self.block, nil);
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
