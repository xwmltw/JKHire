//
//  SalaryJobGuide_VC.m
//  JKHire
//
//  Created by yanqb on 2016/12/13.
//  Copyright © 2016年 xianshijian. All rights reserved.
//

#import "SalaryJobGuide_VC.h"
#import "PostSalaryJob_VC.h"
#import "SalaryRecord_VC.h"

@interface SalaryJobGuide_VC ()

@property (nonatomic, strong) UIScrollView *scrollView;

@end

@interface SalaryJobGuide_VC ()

@end

@implementation SalaryJobGuide_VC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupViews];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"新建代发岗位" style:UIBarButtonItemStylePlain target:self action:@selector(postSalaryJob)];
}

- (void)setupViews{
    self.scrollView = [[UIScrollView alloc] init];
    [self.view addSubview:self.scrollView];
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    CGFloat scrollViewH = 0;
    
    UILabel *labTitle1 = [UILabel labelWithText:@"代发工资引导" textColor:[UIColor XSJColor_tGrayDeepTinge] fontSize:26.0f];
    UILabel *labTip1 = [UILabel labelWithText:@"1. 点击右上角「新建代发岗位」, 填写岗位信息" textColor:[UIColor XSJColor_tGrayHistoyTransparent] fontSize:16.0f];
    labTip1.numberOfLines = 0;
    UIImageView *imgView1 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"salary_guide_bg1"]];
    
    UILabel *labTip2 = [UILabel labelWithText:@"2. 发布成功后，添加待发工资的兼客信息即可发放工资" textColor:[UIColor XSJColor_tGrayHistoyTransparent] fontSize:16.0f];
    labTip2.numberOfLines = 0;
    UIImageView *imgView2 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"salary_guide_bg2"]];
    
    UILabel *labTip3 = [UILabel labelWithText:@"3. 已发布的代发工资岗位，可在「兼职管理」页面再次发放" textColor:[UIColor XSJColor_tGrayHistoyTransparent] fontSize:16.0f];
    labTip3.numberOfLines = 0;
    UIImageView *imgView3 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"salary_guide_bg3"]];
    
    [self.scrollView addSubview:labTitle1];
    [self.scrollView addSubview:labTip1];
    [self.scrollView addSubview:imgView1];
    [self.scrollView addSubview:labTip2];
    [self.scrollView addSubview:imgView2];
    [self.scrollView addSubview:labTip3];
    [self.scrollView addSubview:imgView3];
    
    CGFloat imgWidth = SCREEN_WIDTH - 32;
    CGFloat imgHeight = 0;
    
    CGFloat imgOrignWidth = 0;
    CGFloat imgOrignHeight = 0;
    
    [labTitle1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.scrollView).offset(40);
        make.left.equalTo(self.scrollView).offset(16);
        make.right.equalTo(self.scrollView).offset(-16);
    }];
    
    scrollViewH += (40 + 37);
    
    [labTip1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(labTitle1.mas_bottom).offset(33);
        make.left.equalTo(self.scrollView).offset(16);
        make.width.equalTo(@(imgWidth));
    }];
    
    scrollViewH += (33 + [labTip1 contentSizeWithWidth:SCREEN_WIDTH - 32].height);
    
    imgOrignWidth = imgView1.width;
    imgOrignHeight = imgView1.height;
    imgHeight = ((imgWidth - imgOrignWidth) / imgOrignWidth ) * imgOrignHeight + imgOrignHeight;
    
    [imgView1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(labTip1.mas_bottom).offset(16);
        make.centerX.equalTo(self.scrollView);
        make.width.equalTo(@(imgWidth));
        make.height.equalTo(@(imgHeight));
    }];
    
    scrollViewH += (16 + imgHeight);
    
    [labTip2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(imgView1.mas_bottom).offset(33);
        make.left.equalTo(self.scrollView).offset(16);
        make.width.equalTo(@(imgWidth));
    }];
    
    scrollViewH += (33 + [labTip2 contentSizeWithWidth:SCREEN_WIDTH - 32].height);
    
    imgOrignWidth = imgView2.width;
    imgOrignHeight = imgView2.height;
    imgHeight = ((imgWidth - imgOrignWidth) / imgOrignWidth ) * imgOrignHeight + imgOrignHeight;
    
    [imgView2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(labTip2.mas_bottom).offset(16);
        make.centerX.equalTo(self.scrollView);
        make.width.equalTo(@(imgWidth));
        make.height.equalTo(@(imgHeight));
    }];
    
    scrollViewH += (16 + imgHeight);
    
    [labTip3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(imgView2.mas_bottom).offset(33);
        make.left.equalTo(self.scrollView).offset(16);
        make.width.equalTo(@(imgWidth));
    }];
    
    scrollViewH += (33 + [labTip3 contentSizeWithWidth:SCREEN_WIDTH - 32].height);
    
    imgOrignWidth = imgView3.width;
    imgOrignHeight = imgView3.height;
    imgHeight = ((imgWidth - imgOrignWidth) / imgOrignWidth ) * imgOrignHeight + imgOrignHeight;
    
    [imgView3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(labTip3.mas_bottom).offset(16);
        make.centerX.equalTo(self.scrollView);
        make.width.equalTo(@(imgWidth));
        make.height.equalTo(@(imgHeight));
        make.bottom.equalTo(self.scrollView).offset(-16);
    }];
    
    scrollViewH += (16 + imgHeight + 16);
    self.scrollView.contentSize = CGSizeMake(SCREEN_WIDTH, scrollViewH);
}

- (void)postSalaryJob{
    [[UserData sharedInstance] userIsLogin:^(id result) {
        if (result) {
            PostSalaryJob_VC *viewCtrl = [[PostSalaryJob_VC alloc] init];
            WEAKSELF
            viewCtrl.block = ^(NSNumber *jobId){
                [weakSelf.navigationController popToViewController:weakSelf animated:NO];
                SalaryRecord_VC *viewCtrl1 = [[SalaryRecord_VC alloc] init];
                viewCtrl1.jobId = jobId.description;
                viewCtrl1.isAddPay = YES;
                [weakSelf.navigationController pushViewController:viewCtrl1 animated:YES];
            };
            [self.navigationController pushViewController:viewCtrl animated:YES];
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
