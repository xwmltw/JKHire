//
//  HireServiceIntro_VC.m
//  JKHire
//
//  Created by yanqb on 2017/3/21.
//  Copyright © 2017年 xianshijian. All rights reserved.
//

#import "HireServiceIntro_VC.h"
#import "HiringJobList_VC.h"
#import "JobVasOrder_VC.h"
#import "WebView_VC.h"
#import "VipIPacket_VC.h"
#import "VipInfoCenter_VC.h"

#import "UserData.h"

#import "HireServiceIntro_Cell.h"

@interface HireServiceIntro_VC ()

@end

@implementation HireServiceIntro_VC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"招人神器";
    [self initUIWithType:DisplayTypeOnlyTableView];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerNib:nib(@"HireServiceIntro_Cell") forCellReuseIdentifier:@"HireServiceIntro_Cell"];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    HireServiceIntro_Cell *cell = [tableView dequeueReusableCellWithIdentifier:@"HireServiceIntro_Cell" forIndexPath:indexPath];
    cell.indexPath = indexPath;
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return 190.0f;
    }
    return 171.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10.0f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.section) {
        case 0:{
            WEAKSELF
            [[UserData sharedInstance] userIsLogin:^(id result) {
                if (result) {
                    [weakSelf enterVipCenter:[[UserData sharedInstance] isAccoutVip]];
                }
            }];
            
        }
            break;
        case 1:{
            [self enterHireVC];
        }
            break;
        case 2:{
            [self enterHiringVC];
        }
            break;
        default:
            break;
    }
}

- (void)enterHireVC{
    if (![XSJUserInfoData isReviewAccount]) {
        JobVasOrder_VC *vc = [[JobVasOrder_VC alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (void)enterHiringVC{
    [[UserData sharedInstance] userIsLogin:^(id result) {
        if (result) {
            HiringJobList_VC *vc = [[HiringJobList_VC alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        }
    }];
    
}

- (void)enterVipCenter:(BOOL)isVip{
    [TalkingData trackEvent:@"首页_招人神器_VIP会员"];
    if (isVip) {
        VipInfoCenter_VC *vc = [[VipInfoCenter_VC alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }else{
        VipIPacket_VC *vc = [[VipIPacket_VC alloc] init];
        WEAKSELF
        vc.block = ^(id result){
            [weakSelf.navigationController popToViewController:weakSelf animated:YES];
            [weakSelf enterVipCenter:YES];
        };
        [self.navigationController pushViewController:vc animated:YES];
    }
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
