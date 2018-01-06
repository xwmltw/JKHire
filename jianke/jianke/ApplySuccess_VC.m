//
//  ApplySuccess_VC.m
//  jianke
//
//  Created by xiaomk on 16/6/21.
//  Copyright © 2016年 xianshijian. All rights reserved.
//

#import "ApplySuccess_VC.h"
#import "XSJConst.h"
#import "JobModel.h"
#import "BaseButton.h"
#import "WeChatBinding_VC.h"

@interface ApplySuccess_VC ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIView *botView;
@end

@implementation ApplySuccess_VC

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    self.view.backgroundColor = [UIColor XSJColor_grayTinge];
    
    self.botView = [[UIView alloc] init];
    self.botView.backgroundColor = [UIColor XSJColor_grayTinge];
    [self.view addSubview:self.botView];
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self.view);
        make.bottom.equalTo(self.botView.mas_top);
    }];
    
    UIView *footView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 80)];
    footView.backgroundColor = [UIColor clearColor];
    
    UIButton *btnMoreJob = [UIButton creatBottomButtonWithTitle:@"查看我的报名" addTarget:self action:@selector(btnMoreJobOnclick:)];
    btnMoreJob.frame = CGRectMake(16, 16, SCREEN_WIDTH-32, 44);
    [footView addSubview:btnMoreJob];
    if ([[UserData sharedInstance] getJkModelFromHave].bind_wechat_public_num_status.integerValue == 0) {
        UILabel *leftLab = [UILabel labelWithText:@"绑定微信即时获取录用通知" textColor:[UIColor XSJColor_tGrayTinge] fontSize:13.0f];
        BaseButton *btn = [BaseButton buttonWithType:UIButtonTypeCustom];
        [btn setTitle:@"即时通知" forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor XSJColor_tBlackTinge] forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:@"info_icon_push_2"] forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:13.0f];
        [btn addTarget:self action:@selector(pushWechat:) forControlEvents:UIControlEventTouchUpInside];
        [footView addSubview:leftLab];
        [footView addSubview:btn];
        
        [leftLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(btnMoreJob.mas_bottom).offset(12);
            make.left.equalTo(btnMoreJob);
            make.right.greaterThanOrEqualTo(btn.mas_left);
        }];
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(btnMoreJob.mas_bottom).offset(12);
            make.right.equalTo(btnMoreJob);
            make.width.equalTo(@79);
            make.height.equalTo(@18);
        }];
        [btn setMarginForImg:-0.1 marginForTitle:0];
        footView.height += 18;
    }

    self.tableView.tableFooterView = footView;
    
    [self.botView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.height.mas_equalTo(1);
    }];
}

- (void)btnMoreJobOnclick:(UIButton *)sender{
    [UserData sharedInstance].refreshApplyJobList = YES;
    self.tabBarController.selectedIndex = 1;
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)pushWechat:(UIButton *)sender{
    WeChatBinding_VC* vc = [UIHelper getVCFromStoryboard:@"Public" identify:@"sid_wechatBinding"];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)backToLastView{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIdentifier = @"ApplySuccessCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    if (indexPath.section == 0) {
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        UIView *infoView = (UIView*)[cell viewWithTag:100];
        if (!infoView) {
            infoView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 100)];
            infoView.backgroundColor = [UIColor whiteColor];
            infoView.tag = 100;
            
            UIImageView *img = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"v3_job_success"]];
            [infoView addSubview:img];
            
            UILabel *labTitle = [[UILabel alloc] init];
            labTitle.font = [UIFont systemFontOfSize:22];
            labTitle.textColor = [UIColor XSJColor_tBlackTinge];
            labTitle.textAlignment = NSTextAlignmentCenter;
            labTitle.text = @"报名成功";
            [infoView addSubview:labTitle];
            
            UILabel *labText1 = [[UILabel alloc] init];
            labText1.text = @"请静候佳音，您亦可";
            labText1.textAlignment = NSTextAlignmentCenter;
            labText1.font = [UIFont systemFontOfSize:14];
            labText1.textColor = [UIColor XSJColor_tGrayDeep];
            [infoView addSubview:labText1];
            
            UILabel *labText2 = [[UILabel alloc] init];
            labText2.font = [UIFont systemFontOfSize:14];
            labText2.textAlignment = NSTextAlignmentCenter;
            labText2.text = @"联系雇主了解其他事项";
            labText2.textColor = [UIColor XSJColor_tGrayDeep];
            [infoView addSubview:labText2];
            
            [cell addSubview:infoView];
            
            [img mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerX.equalTo(infoView);
                make.top.equalTo(infoView).offset(32);
                make.left.greaterThanOrEqualTo(cell.mas_left).offset(8);
                make.right.lessThanOrEqualTo(cell.mas_right).offset(-8);
            }];
            
            [labTitle mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerX.equalTo(infoView);
                make.top.equalTo(img.mas_bottom).offset(24);
            }];
            
            [labText1 mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerX.equalTo(infoView);
                make.top.equalTo(labTitle.mas_bottom).offset(8);
            }];
            
            [labText2 mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerX.equalTo(infoView);
                make.top.equalTo(labText1.mas_bottom).offset(4);
            }];
        }
      
    }else if (indexPath.section == 1){
        UIView *cellView = (UIView *)[cell viewWithTag:101];
        if (!cellView) {
            cellView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 48)];
            cellView.backgroundColor = [UIColor clearColor];
            cellView.tag = 101;
            [cell addSubview:cellView];
            
            UILabel *labTitle = [[UILabel alloc] init];
            labTitle.text = @"联系商家: ";
            labTitle.font = [UIFont systemFontOfSize:15];
            labTitle.textColor = [UIColor XSJColor_tGrayDeep];
            [cellView addSubview:labTitle];
            
            UILabel *labName = [[UILabel alloc] init];
            labName.font = [UIFont systemFontOfSize:15];
            labName.textColor = [UIColor XSJColor_tGrayDeep];
            labName.tag = 200;
            [cellView addSubview:labName];
            
            UIImageView *imgCall = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"v3_job_call_success"]];
            [cellView addSubview:imgCall];
            
            [labTitle mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(cellView);
                make.left.mas_equalTo(16);
            }];
            
            [labName mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(cellView);
                make.left.equalTo(labTitle.mas_right);
            }];
            
            [imgCall mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(cellView);
                make.right.equalTo(cellView.mas_right).offset(-16);
            }];
        }
        UILabel *labName = (UILabel *)[cellView viewWithTag:200];
        labName.text = self.jobModel.contact.name;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 1) {
        [[MKOpenUrlHelper sharedInstance] callWithPhone:self.jobModel.contact.phone_num];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return 200;
    }else if (indexPath.section == 1){
        return 48;
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 16;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 1;
}

- (void)dealloc{
    ELog(@"ApplySuccess_VC dealloc");
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
