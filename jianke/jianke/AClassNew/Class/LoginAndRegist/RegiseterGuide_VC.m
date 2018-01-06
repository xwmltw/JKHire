//
//  RegiseterGuide_VC.m
//  JKHire
//
//  Created by yanqb on 2016/12/20.
//  Copyright © 2016年 xianshijian. All rights reserved.
//

#import "RegiseterGuide_VC.h"
#import "ApplyServiceCell_0.h"
#import "ApplyServiceCell_desc.h"
#import "CitySelectController.h"
#import "SecondGuide_VC.h"
@interface RegiseterGuide_VC ()

@property (nonatomic, strong) EPModel *epModel;
@property (nonatomic, assign) BOOL isOtherIndustry;//是否选择其他行业
@end

@implementation RegiseterGuide_VC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self loadDatas];
    [self setupViews];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
}

- (void)loadDatas{
    
    self.epModel = [[EPModel alloc] init];
    
    if (self.isNotRergistAction) {
        WEAKSELF
        [[UserData sharedInstance] getEPModelWithBlock:^(EPModel *epModel) {
            if (epModel) {
                weakSelf.epModel = [NSKeyedUnarchiver unarchiveObjectWithData:[NSKeyedArchiver archivedDataWithRootObject:epModel]];
                if (weakSelf.tableView) {
                    [weakSelf.tableView reloadData];
                }
            }
        }];
    }
    
//    NSMutableArray *array1 = [NSMutableArray array];
    [self.dataSource addObject:@(ApplySerciceCellType_trueName)];
    [self.dataSource addObject:@(ApplySerciceCellType_hireCity)];
    [self.dataSource addObject:@(ApplySerciceCellType_industry)];
    
  
    
//    NSMutableArray *array2 = [NSMutableArray array];
//    [array2 addObject:@(ApplySerciceCellType_companyName)];
    
    
   
//    [self.dataSource addObject:array2];
}

- (void)setupViews{
    
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:self action:nil];
    self.navigationItem.leftBarButtonItems = @[leftItem];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"下一步" style:UIBarButtonItemStylePlain target:self action:@selector(completeAction)];
    
    [self initUIWithType:DisplayTypeOnlyTableView];
    self.tableView.backgroundColor = [UIColor XSJColor_newWhite];
    self.tableView.tableHeaderView = [self getHeaderView];
    [self.tableView registerNib:nib(@"ApplyServiceCell_0") forCellReuseIdentifier:@"ApplyServiceCell_0"];
    [self.tableView registerClass:[ApplyServiceCell_desc class] forCellReuseIdentifier:@"ApplyServiceCell_desc"];
}

- (UIView *)getHeaderView{

    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 154)];

    UILabel *labTitle = [UILabel labelWithText:@"请完善您的基础信息" textColor:[UIColor XSJColor_tGrayDeepTinge] fontSize:20];
    labTitle.numberOfLines = 0;
    UILabel *labSubTitle = [UILabel labelWithText:@"让求职者更好认识您" textColor:[UIColor XSJColor_tGrayDeepTransparent2] fontSize:16];
    labSubTitle.numberOfLines = 0;
    
    UILabel *labNext = [UILabel labelWithText:@"1/2" textColor:[UIColor XSJColor_tGrayDeepTinge] fontSize:24.0f];
    labNext.backgroundColor = [UIColor XSJColor_tGrayDeepTransparent003];
    labNext.textAlignment = NSTextAlignmentCenter;
    NSMutableAttributedString *mutableAttStr = [[NSMutableAttributedString alloc] initWithString:@"1/2" attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:24.0f], NSForegroundColorAttributeName: [UIColor XSJColor_tGrayDeepTinge]}];
    [mutableAttStr addAttributes:@{NSFontAttributeName: [UIFont systemFontOfSize:18.0f], NSForegroundColorAttributeName: [UIColor XSJColor_tGrayDeepTransparent32]} range:NSRangeFromString(@"{1, 2}")];
    labNext.attributedText = mutableAttStr;
    [labNext setCornerValue:26.0f];


    [headerView addSubview:labTitle];
    [headerView addSubview:labSubTitle];
    [headerView addSubview:labNext];

    [labTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(headerView).offset(40);
        make.left.equalTo(headerView).offset(16);
        make.right.equalTo(headerView).offset(-16);
    }];

    [labSubTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(labTitle.mas_bottom).offset(8);
        make.left.equalTo(labTitle);
        make.right.equalTo(headerView).offset(-68);
    }];
    [labNext mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(labTitle);
        make.right.equalTo(headerView).offset(-16);
        make.width.height.equalTo(@52);
    }];

    return headerView;

}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ApplySerciceCellType cellType = [[self.dataSource  objectAtIndex:indexPath.row] integerValue];
    switch (cellType) {
        case ApplySerciceCellType_trueName:
        case ApplySerciceCellType_companyName:
        case ApplySerciceCellType_email:
        case ApplySerciceCellType_hireCity:
        case ApplySerciceCellType_industry:{
            ApplyServiceCell_0 *cell = [tableView dequeueReusableCellWithIdentifier:@"ApplyServiceCell_0" forIndexPath:indexPath];
            [cell setModel:self.epModel cellType:cellType];
            return cell;
        }
        case ApplySerciceCellType_industryDesc:{
            
                ApplyServiceCell_desc *cell = [tableView dequeueReusableCellWithIdentifier:@"ApplyServiceCell_desc" forIndexPath:indexPath];
                cell.placeHolder = @"请输入行业名称";
                cell.maxLength = 200;
                [cell setEpModel:_epModel cellType:cellType];
            
            
                return cell;
            
        }
        default:
            break;
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    ApplySerciceCellType cellType = [[self.dataSource  objectAtIndex:indexPath.row] integerValue];
    switch (cellType) {
        case ApplySerciceCellType_trueName:
        case ApplySerciceCellType_companyName:
        case ApplySerciceCellType_email:
            return 70.0f;
        case ApplySerciceCellType_industryDesc:
            return 54.0f;
        default:
            break;
    }
    return 70.0f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section == 1) {
        UIView *view = [[UIView alloc] init];
        UILabel *lab = [UILabel labelWithText:@"· 若您是个人招聘，可不填写公司名称、公司简介" textColor:[UIColor XSJColor_tGrayDeepTransparent2] fontSize:13.0f];
        lab.numberOfLines = 0;
        [view addSubview:lab];
        [lab mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.edges.equalTo(view);
            make.top.bottom.equalTo(view);
            make.left.equalTo(view).offset(16);
            make.right.equalTo(view).offset(-16);
        }];
        return view;
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 1) {
        return 50.0f;
    }
    return 0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    ApplySerciceCellType cellType = [[self.dataSource  objectAtIndex:indexPath.row] integerValue];
    switch (cellType) {
        case ApplySerciceCellType_hireCity:{
            CitySelectController *viewCtrl = [[CitySelectController alloc] init];
            viewCtrl.isPushAction = YES;
            WEAKSELF
            viewCtrl.didSelectCompleteBlock = ^(CityModel *cityModel){
                if (cityModel) {
                    weakSelf.epModel.city_id = cityModel.id;
                    weakSelf.epModel.city_name = cityModel.name;
                    [weakSelf.tableView reloadData];
                }
            };
            [self.navigationController pushViewController:viewCtrl animated:YES];
        }
            break;
        case ApplySerciceCellType_industry:{
            WEAKSELF
            [[XSJRequestHelper sharedInstance] getClientGlobalInfoWithBlock:^(ClientGlobalInfoRM *globalInfo) {
                if (globalInfo) {
                    NSArray *array = [globalInfo.industry_info_list valueForKey:@"industry_name"];
                    NSArray *idArray = [globalInfo.industry_info_list valueForKey:@"industry_id"];
                    [MKActionSheet sheetWithTitle:@"请选择涉及行业" buttonTitleArray:array isNeedCancelButton:YES maxShowButtonCount:5 block:^(MKActionSheet *actionSheet, NSInteger buttonIndex) {
                        if (buttonIndex < idArray.count) {
                            weakSelf.epModel.industry_id = [idArray objectAtIndex:buttonIndex];
                            weakSelf.epModel.industry_name = [array objectAtIndex:buttonIndex];
                            if (buttonIndex == 0 && self.dataSource.count == 3) {
                                [self.dataSource addObject:@(ApplySerciceCellType_industryDesc)];
                            
                            }else if(![weakSelf.epModel.industry_name isEqualToString:@"其他行业"]){
                            
                                [self.dataSource removeObject:@(ApplySerciceCellType_industryDesc)];
                            }
                           
                            [weakSelf.tableView reloadData];
                        }
                    }];
                }
            }];
            
        }
            break;
        default:
            break;
    }
}

#pragma mark - 其他
- (void)completeAction{
    if (!self.epModel.true_name.length) {
        [UIHelper toast:@"雇主姓名不能为空"];
        return;
    }
    
//    if (self.epModel.true_name.length < 2 || self.epModel.true_name.length > 5) {
//        [UIHelper toast:@"雇主姓名长度为2-5位"];
//        return;
//    }
    
    if (!self.epModel.city_id) {
        [UIHelper toast:@"请选择主要招聘城市"];
        return;
    }
    
//    if (!self.epModel.industry_id) {
//        [UIHelper toast:@"请选择涉及行业"];
//        return;
//    }
    if (self.epModel.industry_name.length) {
        if ([self.epModel.industry_name isEqualToString:@"其他行业"]) {
            if (!self.epModel.industry_desc.length){
                [UIHelper toast:@"请输入涉及行业"];
                return;
            }
        }
        
    }else{
        [UIHelper toast:@"请输入涉及行业"];
        return;
    }

    
//    if (self.epModel.desc.length > 200) {
//        [UIHelper toast:@"公司简介要求200字以内"];
//        return;
//    }
    
   [self.view endEditing:YES];
    
   
    
    SecondGuide_VC *vc = [[SecondGuide_VC alloc]init];
    vc.epModel = self.epModel;
    vc.block = self.block;
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
