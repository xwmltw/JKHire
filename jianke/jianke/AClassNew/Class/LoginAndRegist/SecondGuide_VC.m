//
//  SecondGuide_VC.m
//  JKHire
//
//  Created by yanqb on 2017/6/13.
//  Copyright © 2017年 xianshijian. All rights reserved.
//

#import "SecondGuide_VC.h"
#import "ApplyServiceCell_0.h"
#import "CompanyAbbreviationTCell.h"

@interface SecondGuide_VC ()

@end

@implementation SecondGuide_VC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:self action:@selector(btnBeginOnClick)];
    
    [self loadDatas];
    [self setupViews];
    
}
- (void)loadDatas{
   
    NSMutableArray *array2 = [NSMutableArray array];
    [array2 addObject:@(ApplySerciceCellType_companyName)];
    [array2 addObject:@(ApplySerciceCellType_abbreviationName)];
    [array2 addObject:@(ApplySerciceCellType_commanySummary)];
    
    [self.dataSource addObject:array2];
}

- (void)setupViews{

    [self initUIWithType:DisplayTypeOnlyTableView];
    self.tableView.backgroundColor = [UIColor XSJColor_newWhite];
    self.tableView.tableHeaderView = [self getHeaderView];
    [self.tableView registerNib:nib(@"ApplyServiceCell_0") forCellReuseIdentifier:@"ApplyServiceCell_0"];
    

}
- (UIView *)getHeaderView{
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 154)];
    
    UILabel *labTitle = [UILabel labelWithText:@"企业招聘请填写以下内容" textColor:[UIColor XSJColor_tGrayDeepTinge] fontSize:20];
    labTitle.numberOfLines = 0;
    UILabel *labSubTitle = [UILabel labelWithText:@"个人招聘可不填" textColor:[UIColor XSJColor_tGrayDeepTransparent2] fontSize:16];
    labSubTitle.numberOfLines = 0;
    
    UILabel *labNext = [UILabel labelWithText:@"2/2" textColor:[UIColor XSJColor_tGrayDeepTinge] fontSize:24.0f];
    labNext.backgroundColor = [UIColor XSJColor_tGrayDeepTransparent003];
    labNext.textAlignment = NSTextAlignmentCenter;
    NSMutableAttributedString *mutableAttStr = [[NSMutableAttributedString alloc] initWithString:@"2/2" attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:24.0f], NSForegroundColorAttributeName: [UIColor XSJColor_tGrayDeepTinge]}];
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
//完成
- (void)btnBeginOnClick{
    
 
    NSString* content = [self.epModel getContent];
    
    RequestInfo* request = [[RequestInfo alloc] initWithService:@"shijianke_postEnterpriseBasicInfo_V1" andContent:content];
    request.isShowLoading = YES;
    WEAKSELF
    [request sendRequestWithResponseBlock:^(ResponseInfo *response) {
        MKBlockExec(weakSelf.block, @"一封来自赛亚人的鸡毛信！无论是否成功寄出，我都会把这封信传给你！，至于你收不收，随便！");
        [[UserData sharedInstance] getEPModelWithBlock:nil];
        
    }];


}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.dataSource.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSArray *array = [self.dataSource objectAtIndex:section];
    return array.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ApplySerciceCellType cellType = [[[self.dataSource objectAtIndex:indexPath.section] objectAtIndex:indexPath.row] integerValue];
    switch (cellType) {
        case ApplySerciceCellType_companyName:
        case ApplySerciceCellType_abbreviationName:{
            ApplyServiceCell_0 *cell = [tableView dequeueReusableCellWithIdentifier:@"ApplyServiceCell_0" forIndexPath:indexPath];
            [cell setModel:self.epModel cellType:cellType];
            return cell;
        }
        case ApplySerciceCellType_commanySummary:{
//            ApplyServiceCell_desc *cell = [tableView dequeueReusableCellWithIdentifier:@"ApplyServiceCell_desc" forIndexPath:indexPath];
//            cell.placeHolder = @"输入公司简介(选填)";
//            cell.maxLength = 200;
//            [cell setEpModel:_epModel cellType:cellType];
//            return cell;
            CompanyAbbreviationTCell *cell = [[CompanyAbbreviationTCell alloc]init];
            
            [cell setCellWithPlaceHilder:@"公司简介能增加求职者的信任感..." maxLength:200 epModel:self.epModel];
            
            return cell;
            
        }
        default:
            break;
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    ApplySerciceCellType cellType = [[[self.dataSource objectAtIndex:indexPath.section] objectAtIndex:indexPath.row] integerValue];
    switch (cellType) {
        
        case ApplySerciceCellType_companyName:
        case ApplySerciceCellType_abbreviationName:
            return 70.0f;
        case ApplySerciceCellType_commanySummary:
            return 300.0f;
        default:
            break;
    }
    return 70.0f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
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
