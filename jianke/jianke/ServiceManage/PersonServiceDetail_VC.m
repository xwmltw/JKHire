//
//  PersonServiceDetail_VC.m
//  jianke
//
//  Created by fire on 16/10/18.
//  Copyright © 2016年 xianshijian. All rights reserved.
//

#import "PersonServiceDetail_VC.h"
#import "PersonalList_VC.h"
#import "PersonServiceModel.h"
#import "PersonServDetailCell.h"
#import "WDConst.h"

@interface PersonServiceDetail_VC ()

@property (nonatomic, strong) UIView *botView;
@property (nonatomic, strong) UIButton *leftBtn;
@property (nonatomic, strong) UIButton *rightBtn;
@property (nonatomic, strong) UILabel *labStatus;
@property (nonatomic, strong) PersonServiceModel *personServiceModel;

@end

@implementation PersonServiceDetail_VC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"通告详情";
    [self setupViews];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self getData];
}

- (void)setupViews{
    self.btntitles = @[@"继续邀约"];
    [self initUIWithType:DisplayTypeTableViewAndBottom];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerNib:nib(@"PersonServDetailCell") forCellReuseIdentifier:@"PersonServDetailCell"];
}

- (void)getData{
    WEAKSELF
    [[XSJRequestHelper sharedInstance] getServicePersonalJobDetailWithJobId:self.service_personal_job_id block:^(ResponseInfo *response) {
        if (response) {
            weakSelf.personServiceModel = [PersonServiceModel objectWithKeyValues:[response.content objectForKey:@"service_personal_job"]];
            [weakSelf reloadData];
            self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"v3_job_share"] style:UIBarButtonItemStylePlain target:self action:@selector(shareAction)];
        }
    }];
}

- (void)reloadData{
    [self.tableView reloadData];
    if (self.personServiceModel.status.integerValue != 1) {
        self.btntitles = @[@"已结束"];
        [self.bottomBtns enumerateObjectsUsingBlock:^(UIButton *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            obj.enabled = NO;
            [obj setTitle:@"已结束" forState:UIControlStateNormal];
        }];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (self.personServiceModel) {
        return 1;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    PersonServDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PersonServDetailCell" forIndexPath:indexPath];
    [cell setModel:self.personServiceModel];
    return cell;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return self.personServiceModel.cellHeight;
}

- (void)clickOnview:(UIView *)bottomView clickedButtonAtIndex:(NSInteger)buttonIndex{
    ELog(@"进入个人服务商列表");
    PersonalList_VC *viewCtrl = [[PersonalList_VC alloc] init];
    viewCtrl.service_personal_job_id = self.service_personal_job_id;
    viewCtrl.servicePersonType = [self.personServiceModel getServiceTypeEnum];
    viewCtrl.sourceType = ViewSourceType_PersonManage;
    viewCtrl.isPopToPrevious = YES;
    viewCtrl.block = self.block;
    [self.navigationController pushViewController:viewCtrl animated:YES];
}

- (void)shareAction{
    ShareInfoModel *shareModel = [[ShareInfoModel alloc] init];
    shareModel.share_title = @"我在兼客上发现了一个不错的订单，你也赶紧来看看吧~";
    if (self.personServiceModel.service_type_classify_name.length) {
        shareModel.share_content = [NSString stringWithFormat:@"%@ - %@ %.2f元%@ %@ 再不报名就没机会了~", [self.personServiceModel getServiceTypeStr], self.personServiceModel.service_type_classify_name, self.personServiceModel.salary.value.floatValue, [self.personServiceModel.salary getTypeDesc], self.personServiceModel.working_place];
    }else{
        shareModel.share_content = [NSString stringWithFormat:@"%@ %.2f元%@ %@ 再不报名就没机会了~", [self.personServiceModel getServiceTypeStr], self.personServiceModel.salary.value.floatValue, [self.personServiceModel.salary getTypeDesc], self.personServiceModel.working_place];
    }
    shareModel.share_url = [NSString stringWithFormat:@"%@%@?service_personal_job_id=%@", URL_HttpServer   , KUrl_toServicePersonalJobDetailPage, self.personServiceModel.service_personal_job_id];
    
    WEAKSELF
    [[XSJRequestHelper sharedInstance] getClientGlobalInfoWithBlock:^(ClientGlobalInfoRM *globalInfo) {
        if (globalInfo) {
            shareModel.share_img_url = globalInfo.logo_url;
            [ShareHelper platFormShareWithVc:weakSelf info:shareModel block:^(id obj) {
            }];
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
