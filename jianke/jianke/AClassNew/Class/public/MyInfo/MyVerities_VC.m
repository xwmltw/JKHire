//
//  MyVerities_VC.m
//  JKHire
//
//  Created by yanqb on 2017/3/31.
//  Copyright © 2017年 xianshijian. All rights reserved.
//

#import "MyVerities_VC.h"
#import "MyVerities_Cell.h"
#import "EPModel.h"
#import "IdentityCardAuth_VC.h"
#import "EPVerity_VC.h"

@interface MyVerities_VC ()

@property (nonatomic, strong) LatestVerifyInfo *latestVerifyInfo;


@end

@implementation MyVerities_VC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"认证";
    [self initUIWithType:DisplayTypeOnlyTableView];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerClass:[MyVerities_Cell class] forCellReuseIdentifier:@"MyVerities_Cell"];
    [self getData];
}

- (void)getData{
    WEAKSELF
    [[XSJRequestHelper sharedInstance] getLatestVerifyInfo:^(ResponseInfo *result) {
        if (result) {
            weakSelf.latestVerifyInfo = [LatestVerifyInfo objectWithKeyValues:result.content];
            [self loadDatas];
        }
    }];
}

- (void)loadDatas{
    [self.dataSource removeAllObjects];
    [self.dataSource addObject:@(MyVeritiesCellType_idCardVerity)];
    [self.dataSource addObject:@(MyVeritiesCellType_enterpriseVerity)];
    [self.tableView reloadData];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.dataSource.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MyVeritiesCellType cellType = [[self.dataSource objectAtIndex:indexPath.section] integerValue];
    MyVerities_Cell *cell = [tableView dequeueReusableCellWithIdentifier:@"MyVerities_Cell" forIndexPath:indexPath];
    cell.cellType = cellType;
    cell.epInfo = _latestVerifyInfo;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat height = (SCREEN_WIDTH - 2 * IMGMarginX) * IMGOH / IMGOW;
    return height;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    MyVeritiesCellType cellType = [[self.dataSource objectAtIndex:indexPath.section] integerValue];
    switch (cellType) {
        case MyVeritiesCellType_idCardVerity:{
            if (self.latestVerifyInfo.account_info.id_card_verify_status.integerValue == 1 || self.latestVerifyInfo.account_info.id_card_verify_status.integerValue == 4) {
                [self pushIdVerity];
            }
        }
            break;
        case MyVeritiesCellType_enterpriseVerity:{
            if (self.latestVerifyInfo.account_info.verifiy_status.integerValue != 2) {
                [self pushEpVerity];
            }
        }
            break;
        default:
            break;
    }
}

- (void)pushIdVerity{
    IdentityCardAuth_VC* vc = [[IdentityCardAuth_VC alloc] init];
    WEAKSELF
    vc.block = ^(BOOL obj){
        [weakSelf getData];
    };
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)pushEpVerity{
    EPVerity_VC* vc = [[EPVerity_VC alloc] init];
    vc.isPopLast = YES;
    WEAKSELF
    vc.block = ^(id obj){
        [weakSelf getData];
    };
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
