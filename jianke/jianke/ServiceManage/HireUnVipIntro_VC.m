//
//  HireUnVipIntro_VC.m
//  JKHire
//
//  Created by yanqb on 2017/3/21.
//  Copyright © 2017年 xianshijian. All rights reserved.
//

#import "HireUnVipIntro_VC.h"

@interface HireUnVipIntro_VC ()

@property (nonatomic, weak) UIScrollView *scrollView;

@end

@implementation HireUnVipIntro_VC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"招人神器";
    [self setupViews];
}

- (void)setupViews{
    CGFloat height = 120.0f;
    CGFloat imgW = SCREEN_WIDTH - 32;
    
    UIScrollView *scrollView = [[UIScrollView alloc] init];
    _scrollView = scrollView;
    
    UILabel *lab1 = [[UILabel alloc] init];
    lab1.textColor = [UIColor XSJColor_tGrayDeepTinge];
    lab1.font = [UIFont systemFontOfSize:14.0f];
    lab1.numberOfLines = 0;
    NSString *title = @"兼职推广：刷新、置顶、推送推广，让岗位曝光量提升2-5倍 HOT ";
    NSMutableAttributedString *mutablStr = [[NSMutableAttributedString alloc] initWithString:title attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:14.0f]}];
    [mutablStr addAttributes:@{NSBackgroundColorAttributeName : [UIColor XSJColor_middelRed], NSForegroundColorAttributeName: [UIColor whiteColor], NSFontAttributeName : [UIFont systemFontOfSize:12.0f]} range:[title rangeOfString:@" HOT "]];
    lab1.attributedText = mutablStr;
    
//    lab1.attributedText =
    
    UILabel *lab6 = [UILabel labelWithText:@"兼职推广：刷新、置顶、推送推广，让岗位曝光量提升2-5倍" textColor:[UIColor XSJColor_tGrayDeepTinge] fontSize:14.0f];
    lab1.numberOfLines = 0;
    lab6.hidden = YES;
    height += [lab1 contentSizeWithWidth:SCREEN_WIDTH - 32].height;
    
    UIImageView *imgView1 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"job_vas_push_type"]];
    
    imgView1.height = (imgW * imgView1.height) / imgView1.width;
    imgView1.width = SCREEN_WIDTH - 32;
    height += imgView1.height;
    
    
    UILabel *lab2 = [UILabel labelWithText:@"岗位置顶：24小时优先展示，曝光率提升5倍！" textColor:[UIColor XSJColor_tGrayDeepTinge] fontSize:14.0f];
    lab2.numberOfLines = 0;
    height += [lab2 contentSizeWithWidth:SCREEN_WIDTH - 32].height;
    
    UIImageView *imgView2 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"job_vas_stick_type"]];
    imgView2.height = (imgW * imgView2.height) / imgView2.width;
    imgView2.width = SCREEN_WIDTH - 32;
    height += imgView2.height;
    
    UILabel *lab3 = [UILabel labelWithText:@"刷新岗位：排名靠前、时间最新。获得更多浏览机会!" textColor:[UIColor XSJColor_tGrayDeepTinge] fontSize:14.0f];
    lab3.numberOfLines = 0;
    height += [lab3 contentSizeWithWidth:SCREEN_WIDTH - 32].height;
    
    UIImageView *imgView3 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"job_vas_refresh_type"]];
    imgView3.height = (imgW * imgView3.height) / imgView3.width;
    imgView3.width = SCREEN_WIDTH - 32;
    height += imgView3.height;
    
    
    UIImageView *imgIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"v320_hire_icon_light"]];
    UILabel *lab4 = [UILabel labelWithText:@"如何使用付费推广？" textColor:[UIColor XSJColor_base] fontSize:22.0f];
    height += 22;
    
    UILabel *lab5 = [UILabel labelWithText:@"如图，点击兼职管理页面下的「付费推广」按钮" textColor:MKCOLOR_RGB(149, 161, 171) fontSize:14.0f];
    lab5.numberOfLines = 0;
    height += [lab5 contentSizeWithWidth:SCREEN_WIDTH - 32].height;
    
    UIImageView *imgView4 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"job_vas_light_type"]];
    imgView4.height = (imgW * imgView4.height) / imgView4.width;
    imgView4.width = SCREEN_WIDTH - 32;
    height += imgView4.height;
 
    
    UIView *line1 = [[UIView alloc] init];
    line1.backgroundColor = [UIColor XSJColor_clipLineGray];
    
    UIView *line2 = [[UIView alloc] init];
    line2.backgroundColor = [UIColor XSJColor_clipLineGray];
    
    UIView *line3 = [[UIView alloc] init];
    line3.backgroundColor = [UIColor XSJColor_clipLineGray];
    
    [self.view addSubview:self.scrollView];
    [self.scrollView addSubview:lab1];
    [self.scrollView addSubview:imgView1];
    [self.scrollView addSubview:lab2];
    [self.scrollView addSubview:imgView2];
    [self.scrollView addSubview:lab3];
    [self.scrollView addSubview:imgView3];
    [self.scrollView addSubview:imgIcon];
    [self.scrollView addSubview:lab4];
    [self.scrollView addSubview:lab5];
    [self.scrollView addSubview:imgView4];
    [self.scrollView addSubview:line1];
    [self.scrollView addSubview:line2];
    [self.scrollView addSubview:line3];
    
    self.scrollView.contentSize = CGSizeMake(SCREEN_WIDTH, height);
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    [lab1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.scrollView).offset(16);
        make.width.equalTo(@(imgW));
        make.centerX.equalTo(self.scrollView);
    }];
    
    [imgView1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lab1.mas_bottom).offset(8);
        make.width.equalTo(@(imgW));
        make.centerX.equalTo(self.scrollView);
        make.height.equalTo(@(imgView1.height));
    }];
    
    [lab2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(imgView1.mas_bottom).offset(16);
        make.width.equalTo(@(imgW));
        make.centerX.equalTo(self.scrollView);
    }];
    
    [imgView2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lab2.mas_bottom).offset(8);
        make.width.equalTo(@(imgW));
        make.centerX.equalTo(self.scrollView);
        make.height.equalTo(@(imgView2.height));
    }];
    
    [lab3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(imgView2.mas_bottom).offset(16);
        make.width.equalTo(@(imgW));
        make.centerX.equalTo(self.scrollView);
    }];
    
    [imgView3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lab3.mas_bottom).offset(8);
        make.width.equalTo(@(imgW));
        make.centerX.equalTo(self.scrollView);
        make.height.equalTo(@(imgView3.height));
    }];
    
    [imgIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(imgView3.mas_bottom).offset(16);
        make.left.equalTo(self.scrollView).offset(16);
    }];
    
    [lab4 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(imgIcon);
        make.left.equalTo(imgIcon.mas_right);
    }];
    
    [lab5 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(imgIcon.mas_bottom).offset(8);
        make.width.equalTo(@(imgW));
        make.centerX.equalTo(self.scrollView);
    }];
    
    [imgView4 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lab5.mas_bottom).offset(8);
//        make.left.equalTo(self.scrollView).offset(16);
//        make.right.equalTo(self.scrollView).offset(-16);
        make.width.equalTo(@(imgW));
        make.centerX.equalTo(self.scrollView);
        //        make.bottom.equalTo(self.scrollView).offset(-16);
        make.height.equalTo(@(imgView4.height));
    }];
    
    [line1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(imgW));
        make.centerX.equalTo(self.scrollView);
        make.bottom.equalTo(imgView1);
        make.height.equalTo(@0.7);
    }];
    
    [line2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(imgW));
        make.centerX.equalTo(self.scrollView);
        make.bottom.equalTo(imgView2);
        make.height.equalTo(@0.7);
    }];
    
    [line3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(imgW));
        make.centerX.equalTo(self.scrollView);
        make.bottom.equalTo(imgView3);
        make.height.equalTo(@0.7);
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
