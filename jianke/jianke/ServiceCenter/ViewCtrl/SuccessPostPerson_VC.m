//
//  SuccessPostPerson_VC.m
//  JKHire
//
//  Created by fire on 16/10/17.
//  Copyright © 2016年 xianshijian. All rights reserved.
//

#import "SuccessPostPerson_VC.h"

#import "PersonalList_VC.h"

#import "ModelManage.h"
#import "MainTabBarCtlMgr.h"
#import "CityTool.h"

@interface SuccessPostPerson_VC ()

@property (nonatomic, strong) UIView *headerView;

@end

@implementation SuccessPostPerson_VC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"发送成功";
    [self initUIWithType:DisplayTypeOnlyTableView];
    self.tableView.tableHeaderView = self.headerView;
//    [self initWithNoDataViewWithLabColor:[UIColor XSJColor_base] imgName:@"v3_public_nobill" onView:self.headerView strArgs:@"邀约已发送",@"我们已通知邀约人员，邀约结果将第一时间通知您。", nil];
    self.tableView.sectionHeaderHeight = 28;
//    self.viewWithNoData.hidden = NO;
    [self loadData];
    CityModel *ctModel = [[UserData sharedInstance] city];
    WEAKSELF
    [CityTool getCityModelWithCityId:ctModel.id block:^(CityModel* obj) {
        if (obj) {
            [[UserData sharedInstance] setCity:obj];
            [weakSelf loadData];
        }
    }];
}

- (void)loadData{
    CityModel *cityModel = [[UserData sharedInstance] city];
    [self.dataSource removeAllObjects];
    [self.dataSource addObject:@(SuccesscellType_invite)];
    [self.dataSource addObject:@(SuccessCellType_manage)];
    if (cityModel.contactQQ.length) {
        [self.dataSource addObject:@(SuccessCellType_contactQQ)];
    }
    [self.tableView reloadData];
}

- (UIView *)headerView{
    if (!_headerView) {
        _headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 146)];
        
        CGFloat marginX = (SCREEN_WIDTH - 4 * 28) / 8;
        UIImageView *imgView1 = [self createImageView:@"v312_job_icon_selected"];
        UILabel *lab1 = [UILabel labelWithText:@"成功邀约" textColor:[UIColor XSJColor_base] fontSize:13.0f];
        
        UIImageView *imgView2 = [self createImageView:@"v312_job_icon_selected_no2"];
        UILabel *lab2 = [UILabel labelWithText:@"待对方报名" textColor:[UIColor XSJColor_tGrayDeepTransparent2] fontSize:13.0f];
        UIImageView *imgView3 = [self createImageView:@"v312_job_icon_selected_no3"];
        UILabel *lab3 = [UILabel labelWithText:@"待付款" textColor:[UIColor XSJColor_tGrayDeepTransparent2] fontSize:13.0f];
        UIImageView *imgView4 = [self createImageView:@"v312_job_icon_selected_no4"];
        UILabel *lab4 = [UILabel labelWithText:@"待沟通" textColor:[UIColor XSJColor_tGrayDeepTransparent2] fontSize:13.0f];
        
        UIView *line = [[UIView alloc] init];
        line.backgroundColor = [UIColor XSJColor_clipLineGray];
        
        UILabel *labTip = [UILabel labelWithText:@"您已成功发出邀约，待对方接单邀约后，请及时付款购买对方联系方式并进行电话沟通。" textColor:[UIColor XSJColor_base] fontSize:15.0f];
        labTip.numberOfLines = 0;
        
        [_headerView addSubview:imgView1];
        [_headerView addSubview:imgView2];
        [_headerView addSubview:imgView3];
        [_headerView addSubview:imgView4];
        
        [_headerView addSubview:lab1];
        [_headerView addSubview:lab2];
        [_headerView addSubview:lab3];
        [_headerView addSubview:lab4];
        
        [_headerView addSubview:line];
        [_headerView addSubview:labTip];
        
        [imgView1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_headerView).offset(12);
            make.left.equalTo(_headerView).offset(marginX);
            make.width.height.equalTo(@28);
        }];
        
        [imgView2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.width.height.equalTo(imgView1);
            make.left.equalTo(imgView1.mas_right).offset(2 * marginX);
        }];
        
        [imgView3 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.width.height.equalTo(imgView1);
            make.left.equalTo(imgView2.mas_right).offset(2 * marginX);
        }];
        
        [imgView4 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.width.height.equalTo(imgView1);
            make.left.equalTo(imgView3.mas_right).offset(2 * marginX);
        }];
        
        [lab1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(imgView1.mas_bottom).offset(2);
            make.centerX.equalTo(imgView1);
        }];
        
        [lab2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(imgView2.mas_bottom).offset(2);
            make.centerX.equalTo(imgView2);
        }];
        
        [lab3 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(imgView3.mas_bottom).offset(2);
            make.centerX.equalTo(imgView3);
        }];
        
        [lab4 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(imgView4.mas_bottom).offset(2);
            make.centerX.equalTo(imgView4);
        }];
        
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(lab1.mas_bottom).offset(11);
            make.left.equalTo(lab1);
            make.right.equalTo(_headerView);
            make.height.equalTo(@0.7);
        }];
        
        [labTip mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(line.mas_bottom).offset(16);
            make.left.equalTo(_headerView).offset(marginX - 13);
            make.right.equalTo(_headerView).offset(-marginX);
        }];
    }
    return _headerView;
}

- (UIImageView *)createImageView:(NSString *)imageUrl{
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.image = [UIImage imageNamed:imageUrl];
    return imageView;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"UITableViewCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
        cell.textLabel.font = [UIFont systemFontOfSize:16.0f];
        cell.accessoryView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"info_icon_push_2"]];
        cell.detailTextLabel.textColor = [UIColor XSJColor_tGrayDeepTransparent];
    }
    SuccessCellType type = [[self.dataSource objectAtIndex:indexPath.row] integerValue];
    switch (type) {
        case SuccesscellType_invite:{
            cell.textLabel.text = @"继续邀约";
            cell.detailTextLabel.text = @"看看更多合适人选";
        }
            break;
        case SuccessCellType_manage:{
            cell.textLabel.text = @"服务管理";
            cell.detailTextLabel.text = @"看看您都邀约了哪些人";
        }
            break;
        case SuccessCellType_contactQQ:{
            cell.textLabel.text = @"联系运营经理";
            cell.detailTextLabel.text = @"需要加急处理,点这里";
        }
            break;
        default:
            break;
    }
    return cell;
    
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UILabel *label = [[UILabel alloc] init];
    label.text = @"  您还可以逛";
    label.font = [UIFont systemFontOfSize:13.0f];
    label.textColor = [UIColor XSJColor_tGrayTinge];
    label.backgroundColor = MKCOLOR_RGB(233, 233, 233);
    return label;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 72.0f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    SuccessCellType type = [[self.dataSource objectAtIndex:indexPath.row] integerValue];
    switch (type) {
        case SuccesscellType_invite:{
            [self pushPersonServiceList];
        }
            break;
        case SuccessCellType_manage:{
            [self pushServiceManage];
        }
            break;
        case SuccessCellType_contactQQ:{
            [self contactWithKefu];
        }
            break;
        default:
            break;
    }
}

- (void)pushPersonServiceList{
    PersonalList_VC *viewCtrl = [[PersonalList_VC alloc] init];
    viewCtrl.servicePersonType = [ModelManage getServiceTypeFromNSNumber:self.personServiceType];
    viewCtrl.service_personal_job_id = self.service_personal_job_id;
    viewCtrl.sourceType = ViewSourceType_SuccessInviteJob;
    [self.navigationController pushViewController:viewCtrl animated:YES];
}

- (void)pushServiceManage{
    ELog(@"跳转到个人服务管理");
    [[MainTabBarCtlMgr sharedInstance] setManageVisibleAtIndex:1];
    [self.navigationController popToRootViewControllerAnimated:NO];
}

- (void)contactWithKefu{
    [TalkingData trackEvent:@"雇主_个人中心_联系运营经理"];
    CityModel* city = [[UserData sharedInstance] city];
    [MKOpenUrlHelper openQQWithNumber:city.contactQQ onViewController:self block:^(BOOL bRet) {
        [UIHelper toast:@"你没有安装QQ"];
    }];
}

- (void)backToLastView{
    [self.navigationController popToViewController:[[UserData sharedInstance] popViewCtrl] animated:YES];
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
