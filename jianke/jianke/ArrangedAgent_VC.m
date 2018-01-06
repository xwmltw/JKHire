//
//  ArrangedAgent_VC.m
//  JKHire
//
//  Created by 徐智 on 2017/6/5.
//  Copyright © 2017年 xianshijian. All rights reserved.
//

#import "ArrangedAgent_VC.h"
#import "ArrangedAgent_Cell.h"
#import "UsedApplyNum_VC.h"

@interface ArrangedAgent_VC () <ArrangedAgent_CellDelegate>

@property (nonatomic, strong) ArrangedAgentVasInfo *info;
@property (nonatomic, weak) UILabel *labEpName;
@property (nonatomic, weak) UIImageView *imgView;

@end

@implementation ArrangedAgent_VC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"包代招";
    [self initUIWithType:DisplayTypeOnlyTableView];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerNib:nib(@"ArrangedAgent_Cell") forCellReuseIdentifier:@"ArrangedAgent_Cell"];
    [self getData];
}

- (void)getData{
    WEAKSELF
    [[XSJRequestHelper sharedInstance] queryArrangedAgentVasInfoList:^(ResponseInfo *response) {
        if (response) {
            weakSelf.info = [ArrangedAgentVasInfo objectWithKeyValues:response.content];
            weakSelf.dataSource = [weakSelf.info.arranged_agent_vas_list mutableCopy];
            weakSelf.tableView.tableHeaderView = [self getTableHeaderView];
            weakSelf.tableView.tableFooterView = [self getTableFooterView];
            [weakSelf.tableView reloadData];
        }
    }];
}

- (UIView *)getTableHeaderView{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 54.0f)];
    NSString *enStr = self.info.enterprise_name.length ? self.info.enterprise_name: self.info.true_name.length ? self.info.true_name: @"";
    UILabel *lab1 = [UILabel labelWithText:enStr textColor:[UIColor XSJColor_tGrayDeepTinge1] fontSize:14.0f];
    
    NSString *imgStr = @"";
    switch (self.info.account_vip_type.integerValue) {
        case 0:{
            imgStr = @"pay_vip_icon";
        }
            break;
        case 1:{
            imgStr = @"v320_vip_zuanshi";
        }
            break;
        case 2:{
            imgStr = @"v320_vip_bojin";
        }
            break;
        case 3:{
            imgStr = @"v320_vip_gold";
        }
            break;
        case 4:{
            imgStr = @"v320_vip_baiying";
        }
            break;
        case 5:{
            imgStr = @"v320_vip_qingtong";
        }
            break;
        default:
            break;
    }
    UIImageView *imgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:imgStr]];
    
    [view addSubview:lab1];
    [view addSubview:imgView];
    [lab1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(view).offset(16);
        make.centerY.equalTo(view);
    }];
    [imgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(view);
        make.left.equalTo(lab1.mas_right).offset(4);
    }];
    return view;
}

- (UIView *)getTableFooterView{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0)];
    
    UILabel *lab1 = [UILabel labelWithText:@"1. 该业务适用于非普通岗位；" textColor:[UIColor XSJColor_tGrayDeepTransparent32] fontSize:12.0f];
    lab1.numberOfLines = 0;
    
    UILabel *lab2 = [UILabel labelWithText:@"2. 包代招的报名数只能在有效期内使用，过期自动清零；" textColor:[UIColor XSJColor_tGrayDeepTransparent32] fontSize:12.0f];
    lab2.numberOfLines = 0;
    
    UILabel *lab3 = [UILabel labelWithText:@"3. 在有效期内，剩余报名数为0时，将终止包代招服务，相关岗位会被下架；" textColor:[UIColor XSJColor_tGrayDeepTransparent32] fontSize:12.0f];
    lab3.numberOfLines = 0;
    
    UILabel *lab4 = [UILabel labelWithText:@"更多详情请联系" textColor:[UIColor XSJColor_tGrayDeepTransparent32] fontSize:12.0f];
    lab4.numberOfLines = 0;
    
    UILabel *lab5 = [UILabel labelWithText:[NSString stringWithFormat:@"%@：", self.info.contacter_name.length ? self.info.contacter_name : @"" ] textColor:[UIColor XSJColor_base] fontSize:14.0f];
    
    NSAttributedString *attStr = [[NSAttributedString alloc] initWithString:self.info.contacter_tel attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:14.0f], NSForegroundColorAttributeName: [UIColor XSJColor_base], NSUnderlineStyleAttributeName: @(NSUnderlineStyleSingle), NSUnderlineColorAttributeName: [UIColor XSJColor_base]}];
    UIButton *btnCall = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnCall setAttributedTitle:attStr forState:UIControlStateNormal];
    [btnCall addTarget:self action:@selector(btnCallOnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    [view addSubview:lab1];
    [view addSubview:lab2];
    [view addSubview:lab3];
    [view addSubview:lab4];
    [view addSubview:lab5];
    [view addSubview:btnCall];
    
    CGFloat height = 0;
    
    [lab1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(view).offset(4);
        make.left.equalTo(view).offset(8);
        make.right.equalTo(view).offset(-8);
    }];
    
    height += ([lab1 contentSizeWithWidth:SCREEN_WIDTH - 16].height + 4);
    
    [lab2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lab1.mas_bottom).offset(4);
        make.left.right.equalTo(lab1);
    }];
    height += ([lab2 contentSizeWithWidth:SCREEN_WIDTH - 16].height + 4);
    
    [lab3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lab2.mas_bottom).offset(4);
        make.left.right.equalTo(lab1);
    }];
    height += ([lab3 contentSizeWithWidth:SCREEN_WIDTH - 16].height + 4);
    
    [lab4 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lab3.mas_bottom).offset(16);
        make.left.equalTo(view).offset(8);
    }];
    height += (17 + 16);
    
    [lab5 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lab4.mas_bottom).offset(4);
        make.left.equalTo(view).offset(8);
    }];
    
    [btnCall mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(lab5);
        make.left.equalTo(lab5.mas_right);
    }];
    
    height += (22 + 4 + 16);
    view.height = height;
    
    return view;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.dataSource.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ArrangedAgent_Cell *cell = [tableView dequeueReusableCellWithIdentifier:@"ArrangedAgent_Cell" forIndexPath:indexPath];
    ArrangedAgentVas *model = [self.dataSource objectAtIndex:indexPath.section];
    cell.delegate = self;
    cell.model = model;
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [UIColor XSJColor_newGray];
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 198.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 16.0f;
}

#pragma mark - ArrangedAgent_CellDelegate
- (void)ArrangedAgent_Cell:(ArrangedAgent_Cell *)cell actionType:(BtnOnClickActionType)actionType model:(ArrangedAgentVas *)model{
    switch (actionType) {
        case BtnOnClickActionType_arragedUsedApply:{
            [self enterUsedApply:model];
        }
            break;
            
        default:
            break;
    }
}

- (void)enterUsedApply:(ArrangedAgentVas *)model{
    UsedApplyNum_VC *vc = [[UsedApplyNum_VC alloc] init];
    vc.fromType = UsedApplyNumType_baozhao;
    vc.arranged_agent_vas_order_id = model.id;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)btnCallOnClick:(UIButton *)sender{
    if (self.info.contacter_tel.length) {
        [[MKOpenUrlHelper sharedInstance] makeCallWithPhone:self.info.contacter_tel];
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
