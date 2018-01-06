//
//  PostJobSuccess_VC.m
//  JKHire
//
//  Created by yanqb on 2017/2/9.
//  Copyright © 2017年 xianshijian. All rights reserved.
//

#import "PostJobSuccess_VC.h"
#import "JobVasOrder_VC.h"
#import "EPVerity_VC.h"
#import "PaySelect_VC.h"
#import "HiringJobList_VC.h"
#import "LookupResume_VC.h"
#import "FindTalent_VC.h"
#import "CityTool.h"
#import "BaseButton.h"

#import "PostJobSuccessCell.h"
#import "PostJobSuccess_Cell1.h"

@interface PostJobSuccess_VC ()

@property (strong, nonatomic) RecruitJobNumInfo *model;
@property (nonatomic, strong) NSMutableArray *arrayList;

@end

@implementation PostJobSuccess_VC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"创建成功";
    NSAssert(self.jobModel.city_id, @"哈哈，你忘记传cityId了，必传字段，不可偷懒~");
    self.tableViewStyle = UITableViewStyleGrouped;
    [self initUIWithType:DisplayTypeOnlyTableView];
    self.tableView.backgroundColor = [UIColor XSJColor_newWhite];
    [self.tableView registerNib:nib(@"PostJobSuccessCell") forCellReuseIdentifier:@"PostJobSuccessCell"];
    [self.tableView registerNib:nib(@"PostJobSuccess_Cell1") forCellReuseIdentifier:@"PostJobSuccess_Cell1"];
    self.arrayList = [NSMutableArray array];
    [self getData:^(id result) {
        [self loadDatas];
        [self setupViews];
        if (self.is_need_recommend.integerValue == 1) {
            [self load];
        }
    }];
}

- (void)load{
    QueryTalentParam *param = [[QueryTalentParam alloc] init];
    param.city_id = self.jobModel.city_id;
    param.address_area_id = self.jobModel.address_area_id;
    param.job_classify_id = self.jobModel.job_type_id;
    param.sex = self.jobModel.sex;
    param.age_limit = self.jobModel.age;
    param.list_type = @1;
    
    QueryParamModel *queryParam = [[QueryParamModel alloc] init];
    queryParam.page_size = @3;
    WEAKSELF
    [[XSJRequestHelper sharedInstance] entQueryTalentList:param queryParam:queryParam isShowLoading:NO block:^(ResponseInfo *response) {
        if (response) {
            NSArray *array = [JKModel objectArrayWithKeyValuesArray:[response.content objectForKey:@"telent_list"]];
            weakSelf.dataSource = [array mutableCopy];
            [weakSelf.tableView reloadData];
        }
    }];
}

- (void)getData:(MKBlock)block{
    if (self.cityModel && [self.jobModel.city_id isEqual:[UserData sharedInstance].city.id]) {
        self.model = [UserData sharedInstance].recruitJobNumInfo;
        MKBlockExec(block, nil);
        return;
    }
    WEAKSELF
    [CityTool getCityModelWithCityId:self.jobModel.city_id block:^(CityModel *model) {
        weakSelf.cityModel = model;
        if ([weakSelf.jobModel.city_id isEqual:[UserData sharedInstance].city.id]) {
            weakSelf.model = [UserData sharedInstance].recruitJobNumInfo;
            MKBlockExec(block, nil);
        }else{
            [[XSJRequestHelper sharedInstance] entQueryRecruitJobNumInfo:weakSelf.jobModel.city_id isShowLoading:NO block:^(ResponseInfo *response) {
                if (response) {
                    weakSelf.model = [RecruitJobNumInfo objectWithKeyValues:response.content];
                }
                MKBlockExec(block, nil);
            }];
        }
    }];
}

- (void)loadDatas{
    NSNumber *status = [[UserData sharedInstance] getEpModelFromHave].verifiy_status;
    if (status.integerValue == 1 || status.integerValue == 4) {
        [self.arrayList addObject:@(PostJobSuccessCellType_Certification)];
    }
    if (self.is_need_recommend.integerValue == 1) {
        [self.arrayList addObject:@(PostJobSuccessCellType_suggestTalent)];
    }
    [self.tableView reloadData];
}

- (void)setupViews{
    NSArray *titleArr = [self getTitleOfHeaderView];
    NSString *imgStr = (self.jobStatus.integerValue != 0) ? @"v3_public_success" : @"v3_public_sorry";
    UIView *tableHeaderView = [UIHelper noDataViewWithTitleArr:titleArr titleColor:[UIColor XSJColor_base] image:imgStr button:nil isAbsoluteWidth:NO isFullScreen:NO];
    UIImageView *imgView = [tableHeaderView viewWithTag:110];
    [imgView mas_updateConstraints:^(MASConstraintMaker *make) {
       make.top.equalTo(tableHeaderView.mas_top).offset(32);
    }];
    tableHeaderView.height += 32;
    
    self.tableView.tableHeaderView = tableHeaderView;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return self.arrayList.count;
    }else if (section == 1){
        return self.dataSource.count;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        PostJobSuccessCellType cellType = [[self.arrayList objectAtIndex:indexPath.row] integerValue];
        PostJobSuccessCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PostJobSuccessCell" forIndexPath:indexPath];
        cell.cellType = cellType;
        return cell;
    }else if (indexPath.section == 1){
        PostJobSuccess_Cell1 *cell = [tableView dequeueReusableCellWithIdentifier:@"PostJobSuccess_Cell1" forIndexPath:indexPath];
        cell.sourceType = FromSourceType_postSuccess;
        JKModel *model = [self.dataSource objectAtIndex:indexPath.row];
        cell.model = model;
        return cell;
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return 76.0f;
    }
    return 119.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        if (self.arrayList.count) {
            return 58.0f;
        }
    }else if (section == 1){
        if (self.dataSource.count) {
            return 58.0f;
        }
    }
    return 0.1f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        if (self.arrayList.count) {
            return [self getSectionViewWithTitle:@"您还可以:"];
        }
    }else if (section == 1){
        if (self.dataSource.count) {
            return [self getSectionViewWithTitle:@"推荐人才:"];
        }
    }
    return nil;
}

- (UIView *)getSectionViewWithTitle:(NSString *)title{
    UILabel *label = [UILabel labelWithText:title textColor:[UIColor XSJColor_tGrayDeepTransparent3] fontSize:13.0f];
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [UIColor XSJColor_newWhite];
    [view addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(view).offset(16);
        make.bottom.equalTo(view).offset(-8);
    }];
    return view;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    if (section == 1 && self.dataSource.count) {
        UIView *view = [[UIView alloc] init];
        view.backgroundColor = [UIColor XSJColor_newWhite];
        BaseButton *button = [BaseButton buttonWithType:UIButtonTypeCustom];
        [button setTitle:@"更多人才" forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:16.0f];
        [button setImage:[UIImage imageNamed:@"job_icon_push"] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor XSJColor_tGrayDeepTinge1] forState:UIControlStateNormal];
        [button setBackgroundColor:MKCOLOR_RGBA(34, 58, 80, 0.03)];
        [button setCornerValue:19.0f];
        [button addTarget:self action:@selector(btnOnClick:) forControlEvents:UIControlEventTouchUpInside];
        [button setMarginForImg:-6 marginForTitle:12];
        [view addSubview:button];
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(view);
            make.width.equalTo(@108);
            make.height.equalTo(@38);
        }];
        return view;
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section == 1 && self.dataSource.count) {
        return 70.0f;
    }
    return 0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0) {
        PostJobSuccessCellType cellType = [[self.arrayList objectAtIndex:indexPath.row] integerValue];
        switch (cellType) {
            case PostJobSuccessCellType_ParttimePromotion:{ //兼职推广
                [self pushParttimePromotion];
            }
                break;
            case PostJobSuccessCellType_VIPPostManage:
            case PostJobSuccessCellType_PostManagement:{    //岗位管理
                [self switchPostManagement];
            }
                break;
            case PostJobSuccessCellType_PayMargin:{ //缴纳保证金
                [self payGuaranteeAmount];
            }
                break;
            case PostJobSuccessCellType_Certification:{ //实名认证
                [self applyEpAuth];
            }
                break;
            case PostJobSuccessCellType_payForVIP:{ //获取更多权限
                [self enterRecuitVC];
            }
                break;
            case PostJobSuccessCellType_suggestTalent:{ //人才匹配
                [TalkingData trackEvent:@"岗位发布成功/发布失败_人才匹配"];
                [self enterTalent];
            }
                break;
            default:
                break;
        }
    }else if (indexPath.section == 1){
        [TalkingData trackEvent:@"岗位发布成功/发布失败_点击兼客名片"];
        JKModel *model = [self.dataSource objectAtIndex:indexPath.row];
        [self enterResumeVC:model];
    }
}

- (void)switchPostManagement{
    if (self.tabBarController.selectedIndex != 0) {
        self.tabBarController.selectedIndex = 0;
    }
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)pushParttimePromotion{
    JobVasOrder_VC *viewCtrl = [[JobVasOrder_VC alloc] init];
    viewCtrl.jobId = self.jobId;
    viewCtrl.isFromSuccess = YES;
    [self.navigationController pushViewController:viewCtrl animated:YES];
}

- (void)payGuaranteeAmount{
    PaySelect_VC *viewCtrl = [[PaySelect_VC alloc] init];
    viewCtrl.fromType = PaySelectFromType_payGuaranteeAmountForPostJob;
    viewCtrl.needPayMoney = self.guaranteeAmount.intValue;
    viewCtrl.jobId = @(self.jobId.integerValue);
    viewCtrl.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:viewCtrl animated:YES];
}

- (void)applyEpAuth{
    [TalkingData trackEvent:@"雇主信息_编辑_企业认证"];
    EPVerity_VC *vc=[[EPVerity_VC alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)enterRecuitVC{
    HiringJobList_VC *viewCtrl = [[HiringJobList_VC alloc] init];
    viewCtrl.cityId = self.jobModel.city_id;
    
    [self.navigationController pushViewController:viewCtrl animated:YES];
}

- (void)enterTalent{
    FindTalent_VC *vc = [[FindTalent_VC alloc] init];
    vc.isBeginWithMJRefresh = YES;
    vc.city_id = self.jobModel.city_id;
    vc.address_area_id = self.jobModel.address_area_id;
    vc.job_classify_id = self.jobModel.job_type_id;
    vc.sex = self.jobModel.sex;
    vc.age_limit = self.jobModel.age;
    vc.city_name = self.jobModel.city_name;
    vc.job_classfie_name = self.jobModel.job_classfie_name;
    vc.address_area_name = self.jobModel.address_area_name;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)enterResumeVC:(JKModel *)model{
    LookupResume_VC *vc = [[LookupResume_VC alloc] init];
    vc.isFromToLookUpResume = 1;
    vc.resumeId = model.resume_id;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)backToLastView{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (NSArray *)getTitleOfHeaderView{
    if (self.jobStatus.integerValue != 0) {
        return @[@"岗位创建成功，已提交审核"];
    }else{
        if (self.cityModel.enableVipService.integerValue == 1) {
            return @[@"岗位发布失败！已保存在”待审核“列表", [NSString stringWithFormat:@"您在%@已经发布%ld个岗位，不能再继续发布。您可以通过购买在招岗位数来获取更多权限，或者关闭%@地区其他岗位，然后在“待审核“列表找到该岗位并提交审核。", self.jobModel.city_name, [UserData sharedInstance].recruitJobNumInfo.userd_recruit_job_num.integerValue, self.jobModel.city_name]];
        }else{
            return  @[@"岗位发布失败", @"今天您已经发布够多岗位，该岗位暂不上架显示招聘，如有需要，明天在首页的[待审核]列表上架该岗位"];
        }
    }
}

- (void)btnOnClick:(UIButton *)sender{
    [TalkingData trackEvent:@"岗位发布成功/发布失败_更多人才"];
    [self enterTalent];
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
