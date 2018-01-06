//
//  PostSalaryJob_VC.m
//  JKHire
//
//  Created by yanqb on 2016/12/6.
//  Copyright © 2016年 xianshijian. All rights reserved.
//

#import "PostSalaryJob_VC.h"
#import "JobTypeList_VC.h"
#import "CitySelectController.h"
#import "WebView_VC.h"
#import "ManualAddPerson_VC.h"

#import "PostJobCell_select.h"
#import "PostSalaryJobCell.h"
#import "PersonalPostCell_Title.h"
#import "PostJobCell_twoEdit.h"

#import "PostJobModel.h"
#import "MyEnum.h"

@interface PostSalaryJob_VC ()<PostJobCellTwoEditDelegate>  {
    PostJobModel *_postJobModel;    /*!< 发布岗位模型 */
    NSArray *_unitArray;        /*!< 结算单位 */
    BOOL _isAgree;      /*!< 是否同意发布须知 */
}

@end

@implementation PostSalaryJob_VC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"新建代发岗位";
    
    [self loadDatas];
    self.tableViewStyle = UITableViewStyleGrouped;
    self.btntitles = @[@"下一步"];
    [self initUIWithType:DisplayTypeTableViewAndBottom];
    [self updateBotView];
    
    [self.tableView registerNib:nib(@"PersonalPostCell_Title") forCellReuseIdentifier:@"PersonalPostCell_Title"];
    [self.tableView registerNib:nib(@"PostJobCell_select") forCellReuseIdentifier:@"PostJobCell_select"];
    [self.tableView registerClass:[PostSalaryJobCell class] forCellReuseIdentifier:@"PostSalaryJobCell"];
    [self.tableView registerNib:nib(@"PostJobCell_twoEdit") forCellReuseIdentifier:@"PostJobCell_twoEdit"];
    
}

- (void)updateBotView{
    UIButton *btnAgreeChoose = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnAgreeChoose setImage:[UIImage imageNamed:@"v230_building_checkbox"] forState:UIControlStateNormal];
    [btnAgreeChoose setImage:[UIImage imageNamed:@"v318_selected_rect_icon"] forState:UIControlStateSelected];
    btnAgreeChoose.titleLabel.font = [UIFont systemFontOfSize:13.0f];
    
    [btnAgreeChoose addTarget:self action:@selector(btnAgreeChooseOnclick:) forControlEvents:UIControlEventTouchUpInside];
    btnAgreeChoose.selected = YES;
    
    UIButton *btnAgreement = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnAgreement setTitle:@"《发布须知》" forState:UIControlStateNormal];
    [btnAgreement setTitleColor:[UIColor XSJColor_base] forState:UIControlStateNormal];
    btnAgreement.titleLabel.font = [UIFont systemFontOfSize:13.0f];
    [btnAgreement addTarget:self action:@selector(btnAgreementOnclick:) forControlEvents:UIControlEventTouchUpInside];
    UILabel *lab = [UILabel labelWithText:@"我已同意" textColor:[UIColor XSJColor_tGrayDeepTransparent2] fontSize:13.0f];
    
    UIButton *button = [self.bottomBtns objectAtIndex:0];

    [self.bottomView addSubview:btnAgreeChoose];
    [self.bottomView addSubview:btnAgreement];
    [self.bottomView addSubview:lab];
    
    [button mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(btnAgreeChoose.mas_top).offset(-11);
        make.left.equalTo(self.bottomView).offset(16);
        make.right.equalTo(self.bottomView).offset(-16);
        make.height.equalTo(@44);
    }];
    
    [btnAgreeChoose mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bottomView).offset(16);
        make.bottom.equalTo(self.bottomView).offset(-11);
    }];
    
    [lab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(btnAgreeChoose.mas_right).offset(6);
        make.centerY.equalTo(btnAgreeChoose);
    }];
    
    [btnAgreement mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(lab.mas_right);
        make.centerY.equalTo(btnAgreeChoose);
    }];
}

- (void)loadDatas{
    _unitArray = [SalaryModel salaryArray];
    _isAgree = YES;
    
    _postJobModel = [[PostJobModel alloc] init];
    _postJobModel.job_type = @3;
    _postJobModel.city_id = [UserData sharedInstance].city.id;
    _postJobModel.city_name = [UserData sharedInstance].city.name;
    
    _postJobModel.contact = [[ContactModel alloc] init];
    _postJobModel.contact.phone_num = [[UserData sharedInstance] getEpModelFromHave].telphone;
    _postJobModel.contact.name = [[UserData sharedInstance] getEpModelFromHave].true_name;
    
    SalaryModel *salary = [[SalaryModel alloc] init];
    salary.unit = @(1); // 元/天
    salary.unit_value = [salary getUnitValue];
    _postJobModel.salary = salary;
    
    NSMutableArray *array1 = [NSMutableArray array];
    [array1 addObject:@(PostJobCellType_NewGuide)];
    
    NSMutableArray *array2 = [NSMutableArray array];
    [array2 addObject:@(PostJobCellType_salaryJobtitle)];
    [array2 addObject:@(PostJobCellType_jobType)];
    [array2 addObject:@(PostJobCellType_payMoney)];
    [array2 addObject:@(PostJobCellType_salaryJobArea)];
    [array2 addObject:@(PostJobCellType_contact)];

    [self.dataSource addObject:array1];
    [self.dataSource addObject:array2];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.dataSource.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSArray *array = [self.dataSource objectAtIndex:section];
    return array.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    PostJobCellType cellType = [[[self.dataSource objectAtIndex:indexPath.section] objectAtIndex:indexPath.row] integerValue];
    switch (cellType) {
        case PostJobCellType_NewGuide:{
            PostSalaryJobCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PostSalaryJobCell" forIndexPath:indexPath];
            return cell;
        }
        case PostJobCellType_salaryJobtitle:{
            PersonalPostCell_Title *cell = [tableView dequeueReusableCellWithIdentifier:@"PersonalPostCell_Title" forIndexPath:indexPath];
            cell.utf.placeholder = @"代发工资岗位标题（20字以内）";
            [cell setModel:_postJobModel jobCellType:@(cellType)];
            return cell;
        }
        case PostJobCellType_jobType:
        case PostJobCellType_salaryJobArea:{
            PostJobCell_select *selectCell = [tableView dequeueReusableCellWithIdentifier:@"PostJobCell_select" forIndexPath:indexPath];
            [selectCell setModel:_postJobModel jobCellType:cellType];
            return selectCell;
        }
        case PostJobCellType_payMoney:
        case PostJobCellType_contact:{
            PostJobCell_twoEdit *payCell = [tableView dequeueReusableCellWithIdentifier:@"PostJobCell_twoEdit" forIndexPath:indexPath];
            payCell.delegate = self;
            [payCell setModel:_postJobModel cellType:cellType];
            return payCell;
        }
        default:
            break;
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 54.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.01f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 20.0f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    PostJobCellType cellType = [[[self.dataSource objectAtIndex:indexPath.section] objectAtIndex:indexPath.row] integerValue];
    switch (cellType) {
        case PostJobCellType_jobType:{
            [self jobTypeOnClick];
        }
            break;
        case PostJobCellType_salaryJobArea:{
            [self selectCity];
        }
            break;
        default:
            break;
    }
}

#pragma mark - PostJobCellTwoEditDelegate

- (void)btnSalaryUnitOnclick{
    [self.view endEditing:YES];
    
    NSMutableArray *titleArray = [NSMutableArray array];
    for (SalaryModel *salary in _unitArray) {
        [titleArray addObject:salary.unit_value];
    }
    WEAKSELF
    [MKActionSheet sheetWithTitle:@"请选择薪酬单位" buttonTitleArray:titleArray isNeedCancelButton:NO maxShowButtonCount:6 block:^(MKActionSheet *actionSheet, NSInteger buttonIndex) {
        if (buttonIndex < _unitArray.count) {
            SalaryModel *salary = [_unitArray objectAtIndex:buttonIndex];
            _postJobModel.salary.unit_value = salary.unit_value;
            _postJobModel.salary.unit = salary.unit;
            [weakSelf.tableView reloadData];
        }
    }];
}

- (void)jobTypeOnClick{
    WEAKSELF
    JobTypeList_VC* vc = [[JobTypeList_VC alloc] init];
    vc.postJobType = PostJobType_Push;
    vc.block = ^(JobClassifyInfoModel* model){
        if (model) {
            _postJobModel.job_type_id = model.job_classfier_id;
            _postJobModel.job_classfie_name = model.job_classfier_name;
            [weakSelf.tableView reloadData];
        }
    };
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)selectCity{
    CitySelectController *viewCtrl = [[CitySelectController alloc] init];
    viewCtrl.isPushAction = YES;
    WEAKSELF
    viewCtrl.didSelectCompleteBlock = ^(CityModel *area){
        if (area && [area isKindOfClass:[CityModel class]]) {
            _postJobModel.city_name = area.name;
            _postJobModel.city_id = area.id;
            [weakSelf.tableView reloadData];
        }
    };
    [self.navigationController pushViewController:viewCtrl animated:YES];
}

- (void)btnAgreeChooseOnclick:(UIButton *)sender{
    sender.selected = !sender.selected;
    _isAgree = sender.selected;
}

/** 发布协议 */
- (void)btnAgreementOnclick:(UIButton*)sender{
    WebView_VC* vc = [[WebView_VC alloc] init];
    vc.url = [NSString stringWithFormat:@"%@%@", URL_HttpServer, kUrl_releaseAgree];
    vc.fixednessTitle = @"发布协议";
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)clickOnview:(UIView *)bottomView clickedButtonAtIndex:(NSInteger)buttonIndex{
    [self.view endEditing:YES];
    if ([self dataIsExact]) {
        [self publishJobIsNewPhone:NO];
    }
}

- (BOOL)dataIsExact{
    // 标题
    if (!_postJobModel.job_title || _postJobModel.job_title.length < 1) {
        [UIHelper toast:@"代发岗位名称不能为空"];
        return NO;
    }
    
    // 岗位类型
    if (!_postJobModel.job_type_id) {
        [UIHelper toast:@"请选择代发岗位类型"];
        return NO;
    }
    
    
    // 区域
    if (!_postJobModel.city_id) {
        [UIHelper toast:@"请选择工作区域"];
        return NO;
    }
    
    // 薪资
    if (!_postJobModel.salary.value) {
        [UIHelper toast:@"薪资不能为空"];
        return NO;
    }
    
    if (_postJobModel.salary.value.floatValue == 0) {
        [UIHelper toast:@"薪资不能为0"];
        return NO;
    }
    
    // 联系人
    if (!_postJobModel.contact.name || _postJobModel.contact.name.length < 2 || _postJobModel.contact.name.length > 5) {
        [UIHelper toast:@"请输入真实的联系人姓名"];
        return NO;
    }
    // 联系电话
    if (!_postJobModel.contact.phone_num || _postJobModel.contact.phone_num.length != 11) {
        [UIHelper toast:@"请输入正确的联系电话"];
        return NO;
    }
    
    // 发布须知已阅读
    if (!_isAgree) {
        [UIHelper toast:@"须同意《发布须知》才能发布岗位"];
        return NO;
    }
    
    return YES;
}

/** 发布 */
- (void)publishJobIsNewPhone:(BOOL)isNewPhone{
    // 发送请求
    NSString *parttimeJob = [_postJobModel getContent];
    NSNumber *useNewPhone = isNewPhone ? @(1) : @(0);
    NSString *content = [NSString stringWithFormat:@"\"parttime_job\":{%@}, \"use_new_phone\":%@", parttimeJob, useNewPhone.description];
    
    ELog(@"content:%@",content);
    
    WEAKSELF
    [[UserData sharedInstance] postParttimeJobWithContent:content block:^(ResponseInfo *response) {
        if (response && response.success) { // 发布成功
            [weakSelf publishSuccedWithJobId:[response.content objectForKey:@"job_id"]];
        } else if (response.errCode.integerValue == 57) { // 使用了新号码
            [weakSelf checkNewPhonePost];
        }
    }];
}

- (void)publishSuccedWithJobId:(NSString *)jobId{
    [[UserData sharedInstance] setIsUpdateWithEPHome:YES];
    ManualAddPerson_VC *viewCtrl = [[ManualAddPerson_VC alloc] init];
    viewCtrl.title = @"添加发放对象";
    viewCtrl.job_id = jobId;
    viewCtrl.fromViewType = FromViewType_PostSalayJob;
    viewCtrl.block = self.block;
    [self.navigationController pushViewController:viewCtrl animated:YES];
}

- (void)checkNewPhonePost{
    NSString *msgStr = [NSString stringWithFormat:@"%@ 以前未发布过岗位哦，您确定使用该号码吗？", _postJobModel.contact.phone_num];
    // 确认发布
    WEAKSELF
    [UIHelper showConfirmMsg:msgStr title:@"注意" okButton:@"确定" completion:^(DLAVAlertView *alertView, NSInteger buttonIndex) {
        if (buttonIndex == 0) {
            return;
        }else if (buttonIndex == 1){
            [weakSelf publishJobIsNewPhone:YES];
        }
    }];
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
