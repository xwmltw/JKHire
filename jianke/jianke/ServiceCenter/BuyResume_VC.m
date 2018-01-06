//
//  BuyResume_VC.m
//  JKHire
//
//  Created by 徐智 on 2017/6/4.
//  Copyright © 2017年 xianshijian. All rights reserved.
//

#import "BuyResume_VC.h"
#import "PaySelect_VC.h"
#import "BuyApplyNum_Cell.h"

@interface BuyResume_VC ()

@property (nonatomic, weak) UIButton *btnBot;
@property (nonatomic, strong) ResumeNumPackage *selectedModel;

@end

@implementation BuyResume_VC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"简历数购买";
    self.btntitles = @[@"去付款"];
    self.marginTop = 48;
    [self initUIWithType:DisplayTypeTableViewAndBottom];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.refreshType = RefreshTypeHeader;
    self.btnBot = [self.bottomBtns objectAtIndex:0];
    self.tableView.tableHeaderView = [self getTopView];
    [self.tableView registerNib:nib(@"BuyApplyNum_Cell") forCellReuseIdentifier:@"BuyApplyNum_Cell"];
    [self updateBotView];
    [self getData:YES];
    [self addObserver:self forKeyPath:@"selectedModel" options:NSKeyValueObservingOptionNew context:nil];
}

- (void)headerRefresh{
    [self getData:NO];
}

- (void)getData:(BOOL)isShowLoading{
    WEAKSELF
    [[XSJRequestHelper sharedInstance] queryAccountResumeNumPackageList:isShowLoading block:^(ResponseInfo *response) {
        [weakSelf.tableView.header endRefreshing];
        if (response) {
            NSArray *array = [ResumeNumPackage objectArrayWithKeyValuesArray:[response.content objectForKey:@"account_resume_num_package_list"]];
            if (array.count) {
                weakSelf.viewWithNoData.hidden = YES;
                weakSelf.selectedModel = array.firstObject;
                weakSelf.selectedModel.isSelected = YES;
            }else{
                weakSelf.viewWithNoData.hidden = NO;
                weakSelf.selectedModel = nil;
            }
            weakSelf.dataSource = [array mutableCopy];
            [weakSelf.tableView reloadData];
        }else{
            weakSelf.viewWithNoData.hidden = NO;
            weakSelf.selectedModel = nil;
            [weakSelf.dataSource removeAllObjects];
            [weakSelf.tableView reloadData];
        }
    }];
}

- (void)updateBotView{
    UILabel *lab = [UILabel labelWithText:@"*" textColor:[UIColor XSJColor_middelRed] fontSize:12.0f];
    UILabel *lab1 = [UILabel labelWithText:@"购买套餐即表示已阅读并同意" textColor:[UIColor XSJColor_tGrayDeepTransparent32] fontSize:12.0f];
    UIButton *btn = [UIButton buttonWithTitle:@"《增值服务协议》" bgColor:nil image:nil target:self sector:@selector(btnOnClick:)];
    NSAttributedString *arrStr = [[NSAttributedString alloc] initWithString:@"《增值服务协议》" attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:12.0f], NSForegroundColorAttributeName: [UIColor XSJColor_tGrayDeepTransparent80], NSUnderlineStyleAttributeName: @(NSUnderlineStyleSingle)}];
    [btn setAttributedTitle:arrStr forState:UIControlStateNormal];
    
    UILabel *lab2 = [UILabel labelWithText:@"*" textColor:[UIColor XSJColor_middelRed] fontSize:12.0f];
    UILabel *lab3 = [UILabel labelWithText:@"在线购买的简历数自购买起1年内有效,逾期清零。" textColor:[UIColor XSJColor_tGrayDeepTransparent32] fontSize:12.0f];
    
    [self.bottomView addSubview:lab2];
    [self.bottomView addSubview:lab3];
    [self.bottomView addSubview:lab];
    [self.bottomView addSubview:lab1];
    [self.bottomView addSubview:btn];
    
   
    
   
    
    [lab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bottomView).offset(16);
        make.bottom.equalTo(self.btnBot.mas_top).offset(-8);
    }];
    
    [lab1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(lab.mas_right);
        make.centerY.equalTo(lab);
    }];
    
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(lab1.mas_right);
        make.centerY.equalTo(lab1);
    }];
    
    [lab2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bottomView).offset(16);
        make.bottom.equalTo(self.btnBot.mas_top).offset(-24);
    }];
    
    [lab3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(lab2.mas_right);
        make.centerY.equalTo(lab2);
    }];
}

- (UIView *)getTopView{
    CGFloat height = 57.0f;
    
    UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 10)];
    topView.backgroundColor = [UIColor XSJColor_newWhite];
    
    UIImageView *imgHead = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"v320_firendly_icon"]];
    
    EPModel *epInfo = [[UserData sharedInstance] getEpModelFromHave];
    NSString *str = nil;
    if (epInfo.true_name.length) {
        str = [NSString stringWithFormat:@"您好，%@", epInfo.true_name];
    }else{
        str = @"您好，兼客";
    }
    UILabel *lab = [UILabel labelWithText:str textColor:[UIColor XSJColor_tGrayDeepTransparent2] fontSize:18.0f];
    
    UIView *bgView = [[UIView alloc] init];
    bgView.backgroundColor = MKCOLOR_RGB(231, 247, 250);
    UILabel *label = [UILabel labelWithText:@"看到合适的人才，别犹豫，直接联系TA。主动出击，招聘效果棒棒哒!" textColor:[UIColor XSJColor_base] fontSize:15.0f];
    label.numberOfLines = 0;
    
    [bgView addSubview:label];
    [topView addSubview:imgHead];
    [topView addSubview:lab];
    [topView addSubview: bgView];
    
    [imgHead mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(topView).offset(16);
        make.centerY.equalTo(lab);
    }];
    
    [lab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(imgHead.mas_right).offset(2);
        make.top.equalTo(topView).offset(24);
    }];
    
    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lab.mas_bottom).offset(8);
        make.left.equalTo(topView).offset(16);
        make.right.equalTo(topView).offset(-16);
        make.bottom.equalTo(label).offset(12);
    }];
    
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(bgView).offset(12);
        make.right.equalTo(bgView).offset(-12);
        make.top.equalTo(bgView).offset(8);
    }];
    
    height += ([label contentSizeWithWidth:SCREEN_WIDTH - 56].height + 24);
    topView.height = height;
    
    return topView;
}

#pragma mark - uitableview datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    BuyApplyNum_Cell *cell = [tableView dequeueReusableCellWithIdentifier:@"BuyApplyNum_Cell" forIndexPath:indexPath];
    ResumeNumPackage *model = [self.dataSource objectAtIndex:indexPath.row];
    [cell setReumeModel:model];
    return cell;
}

#pragma mark - uitableview delegate

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [UIColor XSJColor_newWhite];
    UILabel *lab = [UILabel labelWithText:@"选择简历数" textColor:[UIColor XSJColor_tGrayDeepTransparent48] fontSize:16.0f];
    [view addSubview:lab];
    [lab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(view).offset(16);
        make.centerY.equalTo(view);
    }];
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 54.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 54.0f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.dataSource enumerateObjectsUsingBlock:^(ResumeNumPackage *_Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.isSelected = NO;
    }];
    ResumeNumPackage *model = [self.dataSource objectAtIndex:indexPath.row];
    model.isSelected = YES;
    self.selectedModel = model;
    [tableView reloadData];
}

#pragma mark - 重写方法
- (void)clickOnview:(UIView *)bottomView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (!self.selectedModel) {
        [UIHelper toast:@"请选择购买简历数套餐"];
        return;
    }
    [TalkingData trackEvent:@"简历数购买_去付款按钮"];
    NSNumber *totalAmount = (self.selectedModel.promotion_price) ? self.selectedModel.promotion_price: self.selectedModel.price;
    WEAKSELF
    [[XSJRequestHelper sharedInstance] rechargeResumeNumPackageWithId:self.selectedModel.id totalAmount:totalAmount block:^(ResponseInfo *result) {
        if (result) {
            PaySelect_VC *vc = [[PaySelect_VC alloc] init];
            vc.fromType = PaySelectFromType_payResumeNumOrder;
            vc.needPayMoney = totalAmount.intValue;
            vc.resume_num_order_id = [result.content objectForKey:@"resume_num_order_id"];
            vc.updateDataBlock = weakSelf.block;
            [weakSelf.navigationController pushViewController:vc animated:YES];
        }
    }];
}

- (void)updateBtn{
    if (self.selectedModel) {
        NSNumber *numOfTitle = nil;
        numOfTitle = (self.selectedModel.promotion_price) ? self.selectedModel.promotion_price: self.selectedModel.price;
        [self.btnBot setTitle:[NSString stringWithFormat:@"去付款 ¥%.2f", numOfTitle.floatValue * 0.01] forState:UIControlStateNormal];
    }else{
        [self.btnBot setTitle:@"去付款" forState:UIControlStateNormal];
    }
}

- (void)btnOnClick:(UIButton *)sender{
    [[UserData sharedInstance] handleGlobalRMUrlWithType:GlobalRMUrlType_addServiceAgreement block:^(UIViewController *vc) {
        [self.navigationController pushViewController:vc animated:YES];
    }];
}
#pragma mark - KVO
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    [self updateBtn];
}

- (void)dealloc{
    [self removeObserver:self forKeyPath:@"selectedModel"];
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
