//
//  TeamPersonOrder_VC.m
//  JKHire
//
//  Created by yanqb on 2017/3/21.
//  Copyright © 2017年 xianshijian. All rights reserved.
//

#import "TeamPersonOrder_VC.h"
#import "MyInfoCell_new.h"
#import "ApplyService_VC.h"
#import "PostedServiceList_VC.h"
#import "MyOrderList_VC.h"

@interface TeamPersonOrder_VC ()

@property (nonatomic, strong) EPModel *epInfo;

@end

@implementation TeamPersonOrder_VC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"服务商信息";
    [self initUIWithType:DisplayTypeOnlyTableView];
    self.tableView.backgroundColor = [UIColor whiteColor];
    [self.tableView registerNib:nib(@"MyInfoCell_new") forCellReuseIdentifier:@"MyInfoCell_new"];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    WEAKSELF
    [[UserData sharedInstance] getEPModelWithBlock:^(EPModel *result) {
        if (result) {
            weakSelf.epInfo = result;
            [weakSelf.tableView reloadData];
        }
    }];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MyInfoCell_new *cell = [tableView dequeueReusableCellWithIdentifier:@"MyInfoCell_new" forIndexPath:indexPath];
    cell.labNum.hidden = YES;
    cell.btnCall.hidden = YES;
    switch (indexPath.section) {
        case 0:{
//            cell.imgTag.image = [UIImage imageNamed:@"myinfo_icon_gantanhao"];
            cell.labTitle.text = @"服务商信息";
        }
            break;
        case 2:{
//            cell.imgTag.image = [UIImage imageNamed:@"myinfo_icon_suggest"];
            cell.labTitle.text = @"收到订单";
            if (_epInfo) {
                cell.labNum.hidden = NO;
                cell.labNum.text = _epInfo.service_team_apply_ordered_count.description;
            }
        }
            break;
        case 1:{
//            cell.imgTag.image = [UIImage imageNamed:@"myinfo_icon_bz"];
            cell.labTitle.text = @"发布的服务";
            if (_epInfo) {
                cell.labNum.hidden = NO;
                cell.labNum.text = _epInfo.service_team_apply_count.description;
            }
        }
            break;
        default:
            break;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.section) {
        case 0:{
            [self editServiceAction:NO];
        }
            break;
        case 1:{
            [self ViewPostedServiceList];
        }
            break;
        case 2:{
            [self viewAllOrder];
        }
            break;
            
        default:
            break;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 68;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 4.0f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [UIColor whiteColor];
    return view;
}
- (void)editServiceAction:(BOOL)isPostAction{
    [[UserData sharedInstance] userIsLogin:^(id result) {
        if (result) {
            ApplyService_VC *viewCtrl = [[ApplyService_VC alloc] init];
            viewCtrl.hidesBottomBarWhenPushed = YES;
            viewCtrl.isPostAction = isPostAction;
            [self.navigationController pushViewController:viewCtrl animated:YES];
        }
    }];
}

- (void)ViewPostedServiceList{
    [[UserData sharedInstance] userIsLogin:^(id result) {
        if (result) {
            PostedServiceList_VC *viewCtrl = [[PostedServiceList_VC alloc] init];
            viewCtrl.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:viewCtrl animated:YES];
        }
    }];
}

- (void)viewAllOrder{
    ELog(@"查看更多订单");
    MyOrderList_VC *viewCtrl = [[MyOrderList_VC alloc] init];
    viewCtrl.hidesBottomBarWhenPushed = YES;
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
