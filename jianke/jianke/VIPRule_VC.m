//
//  VIPRule_VC.m
//  JKHire
//
//  Created by 徐智 on 2017/5/16.
//  Copyright © 2017年 xianshijian. All rights reserved.
//

#import "VIPRule_VC.h"
#import "GuideMaskView.h"
#import "JobClassifierModel.h"
@interface VIPRule_VC ()
@property (nonatomic, strong) NSMutableArray *jobTypeLimitArray;
@property (nonatomic, strong) NSMutableArray *jobTypeArray;
@property (nonatomic, strong) UILabel *labLimitType;
@property (nonatomic, strong) UILabel *labType;
@end

@implementation VIPRule_VC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"VIP套餐适用规则";
    
    [self getData];
    
}

- (void)getData{
    self.jobTypeLimitArray = [NSMutableArray array];
    self.jobTypeArray = [NSMutableArray array];
    [[UserData sharedInstance] getJobClassifierListWithBlock:^(NSArray *jobArray) {
        [jobArray enumerateObjectsUsingBlock:^(JobClassifierModel *_Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if (obj.enable_limit_job.integerValue == 0) {
                [self.jobTypeLimitArray addObject:obj.job_classfier_name];
            }else{
                [self.jobTypeArray addObject:obj.job_classfier_name];
            }
            
        }];
        [self setupViews];
    }];
}
- (void)setupViews{
    UIScrollView *scrollView = [[UIScrollView alloc] init];
    
    UILabel *lab1 = [UILabel labelWithText:@"1. 专属VIP特权（除了会员标识）仅在VIP服务城市有效；" textColor:[UIColor XSJColor_tGrayHistoyTransparent64] fontSize:14.0f];
    lab1.numberOfLines = 0;
    
    UILabel *lab2 = [UILabel labelWithText:@"2. 在线招聘岗位的个数仅在VIP服务城市有效；" textColor:[UIColor XSJColor_tGrayHistoyTransparent64] fontSize:14.0f];
    lab2.numberOfLines = 0;
    
    UILabel *lab3 = [UILabel labelWithText:@"3. 岗位刷新、岗位置顶和岗位推送，同一账户下所有岗位全国通用，VIP服务到期自动清零。" textColor:[UIColor XSJColor_tGrayHistoyTransparent64] fontSize:14.0f];
    lab3.numberOfLines = 0;
    
    UILabel *lab8 = [UILabel labelWithText:@"4. 简历数全国通用，VIP服务过期时自动清零。" textColor:[UIColor XSJColor_tGrayHistoyTransparent64] fontSize:14.0f];
    lab8.numberOfLines = 0;
    
    UIView *line = [[UIView alloc] init];
    line.backgroundColor = [UIColor XSJColor_clipLineGray];
    
    
    UILabel *lab4 = [UILabel labelWithText:@"当前VIP服务适用于以下岗位类别" textColor:[UIColor XSJColor_tGrayDeepTinge] fontSize:16.0f];
    lab4.numberOfLines = 0;
    
    
    
    NSMutableString *str5 = [NSMutableString string];
    for (NSMutableString *str in self.jobTypeLimitArray) {
        if (str.length) {
            [str5 appendString:[NSString stringWithFormat:@"%@,",str]];
        }
    }
    NSString *str55 = [str5 substringToIndex:[str5 length]-1];//删除最后一个，
    UILabel *lab5 = [UILabel labelWithText:str55 textColor:[UIColor XSJColor_tGrayHistoyTransparent64] fontSize:14.0f];
    _labLimitType = lab5;
    lab5.numberOfLines = 0;
    
    UIView *line2 = [[UIView alloc] init];
    line2.backgroundColor = [UIColor XSJColor_clipLineGray];
    
    
    
    NSMutableString *str6 = [NSMutableString string];
    for (NSMutableString *str in self.jobTypeArray) {
        if (str.length) {
            [str6 appendString:[NSString stringWithFormat:@"%@,",str]];
        }
        
    }
   NSString *str66 =[str6 substringToIndex:[str6 length]-1];
    UILabel *lab6 = [UILabel labelWithText:[NSString stringWithFormat:@"如需发布除以上类别外的兼职岗位，如%@等，请点击：",str66] textColor:[UIColor XSJColor_tGrayDeepTransparent48] fontSize:12.0f];
    lab6.numberOfLines = 0;
    _labType = lab6;
    
    UIButton *btn1 = [UIButton buttonWithTitle:@"更多岗位服务" bgColor:MKCOLOR_RGB(231, 247, 250) image:nil target:self sector:@selector(btnMoreOnClick:)];
    [btn1 setTitleColor:[UIColor XSJColor_base] forState:UIControlStateNormal];
    [btn1.titleLabel setFont:[UIFont systemFontOfSize:14.0f]];
    [btn1 setCornerValue:19.0f];
    UIView *line3 = [[UIView alloc] init];
    line3.backgroundColor = [UIColor XSJColor_clipLineGray];
    
    
    UILabel *lab7 = [UILabel labelWithText:@"如需同时开通多个服务城市（或开通全国），请点击：" textColor:[UIColor XSJColor_tGrayDeepTinge] fontSize:16.0f];
    lab7.numberOfLines = 0;
    
    UIButton *btn2 = [UIButton buttonWithTitle:@"开通多个VIP城市" bgColor:MKCOLOR_RGB(231, 247, 250) image:nil target:self sector:@selector(btnMoreCityOnClick:)];
    [btn2 setTitleColor:[UIColor XSJColor_base] forState:UIControlStateNormal];
    [btn2.titleLabel setFont:[UIFont systemFontOfSize:14.0f]];
    [btn2 setCornerValue:19.0f];
    
    [self.view addSubview:scrollView];
    [scrollView addSubview:lab1];
    [scrollView addSubview:lab2];
    [scrollView addSubview:lab3];
    [scrollView addSubview:lab8];
    [scrollView addSubview:line];
    [scrollView addSubview:lab4];
    [scrollView addSubview:lab5];
    [scrollView addSubview:line2];
    [scrollView addSubview:lab6];
    [scrollView addSubview:btn1];
    [scrollView addSubview:line3];
    [scrollView addSubview:lab7];
    [scrollView addSubview:btn2];
    
    
    CGFloat height = 0.0f;
    
    [scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    height = [lab1 contentSizeWithWidth:SCREEN_WIDTH - 32].height + 16;
    
    [lab1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(scrollView).offset(16);
        make.left.equalTo(self.view).offset(16);
        make.right.equalTo(self.view).offset(-16);
    }];
    
    
    height += ([lab2 contentSizeWithWidth:SCREEN_WIDTH - 32].height + 16);
    [lab2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(lab1);
        make.top.equalTo(lab1.mas_bottom).offset(16);
    }];
    
    height += ([lab3 contentSizeWithWidth: SCREEN_WIDTH - 32].height + 16);
    [lab3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(lab1);
        make.top.equalTo(lab2.mas_bottom).offset(16);
    }];
    
    height += ([lab8 contentSizeWithWidth:SCREEN_WIDTH - 32].height + 16);
    [lab8 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lab3.mas_bottom).offset(16);
        make.left.right.equalTo(lab1);
    }];

    
    height += 16;
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lab8.mas_bottom).offset(16);
        make.left.right.equalTo(lab1);
        make.height.equalTo(@0.7);
    }];
    
    
    height += ([lab4 contentSizeWithWidth:SCREEN_WIDTH - 32].height + 16);
    [lab4 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(line.mas_bottom).offset(16);
        make.left.right.equalTo(lab1);
    }];
    
    
    
    height += ([lab5 contentSizeWithWidth:SCREEN_WIDTH - 32].height + 16);
    [lab5 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lab4.mas_bottom).offset(16);
        make.left.right.equalTo(lab4);
    }];
    
    height += 16;
    [line2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lab5.mas_bottom).offset(16);
        make.left.equalTo(lab1);
        make.width.equalTo(@40);
        make.height.equalTo(@0.7);
    }];
    
    height += ([lab6 contentSizeWithWidth:SCREEN_WIDTH - 32].height + 16);
    [lab6 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(line2.mas_bottom).offset(16);
        make.left.right.equalTo(lab1);
    }];
    
    height += (16 + 38);
    [btn1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lab6.mas_bottom).offset(16);
        make.centerX.equalTo(scrollView);
        make.width.equalTo(@116);
        make.height.equalTo(@38);
    }];
    
    height += 16;
    [line3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(btn1.mas_bottom).offset(16);
        make.left.right.equalTo(lab1);
        make.height.equalTo(@0.7);
    }];
    
    height += ([lab7 contentSizeWithWidth:SCREEN_WIDTH - 32].height + 16);
    [lab7 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(line3.mas_bottom).offset(16);
        make.left.right.equalTo(lab1);
    }];
    
    height += (16 + 38 + 16);
    [btn2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lab7.mas_bottom).offset(16);
        make.centerX.equalTo(scrollView);
        make.width.equalTo(@138);
        make.height.equalTo(@38);
        make.bottom.equalTo(scrollView).offset(-16);
    }];
    
    scrollView.contentSize = CGSizeMake(SCREEN_WIDTH, height);
}
- (void)btnMoreOnClick:(UIButton *)sender{
    [self requestSale:@"更多岗位服务：有意向开通特殊岗位包代招服务"];
}

- (void)btnMoreCityOnClick:(UIButton *)sender{
    [self requestSale:@"开通多个VIP城市：有意向开通多个VIP城市（或全国）"];
}

//- (void)VIPFooterView:(VIPFooterView *)footerView actionType:(BtnOnClickActionType)actionType{
//    switch (actionType) {
//        case BtnOnClickActionType_qCode:{
//            
//        }
//            break;
//        case BtnOnClickActionType_chooseCity:{
//            
//        }
//            break;
//        case BtnOnClickActionType_vipCities:{
//            [self requestSale:@"开通多个VIP城市：有意向开通多个VIP城市（或全国）"];
//        }
//            break;
//        case BtnOnClickActionType_moreJobService:{
//            [self requestSale:@"更多岗位服务：有意向开通特殊岗位包代招服务"];
//        }
//            break;
//        default:
//            break;
//    }
//}

- (void)requestSale:(NSString *)desc{
    WEAKSELF
    [[XSJRequestHelper sharedInstance] postSaleClueWithDesc:desc isNeedContact:@1 isShowloading:YES block:^(id result) {
        [weakSelf showAlertView];
    }];
}

- (void)showAlertView{
    GuideMaskView *maskView = [[GuideMaskView alloc] initWithTitle:@"业务咨询提交成功" content:@"您的业务咨询已传达给优聘顾问，顾问会在一个工作日内与您联系，请您保持手机通畅。" cancel:nil commit:@"我知道了" block:nil];
    maskView.alertView.titleLab.font = [UIFont systemFontOfSize:16.0f];
    maskView.alertView.labcontent.font = [UIFont systemFontOfSize:14.0f];
    [maskView show];
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
