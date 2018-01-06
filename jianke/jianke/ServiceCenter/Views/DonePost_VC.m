//
//  DonePost_VC.m
//  jianke
//
//  Created by xuzhi on 16/9/25.
//  Copyright © 2016年 xianshijian. All rights reserved.
//

#import "DonePost_VC.h"
#import "JianKeAppreciation_VC.h"
#import "EPVerity_VC.h"
#import "PreviewJob_VC.h"

@interface DonePost_VC ()

@property (nonatomic, copy) NSNumber *authStatus;
@property (nonatomic, copy) NSNumber *isJobExamVip; /*! 是否免审账号 */

@end

@implementation DonePost_VC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"岗位提交成功";
    self.authStatus = [[UserData sharedInstance] getEpModelFromHave].verifiy_status;
    self.isJobExamVip = [[UserData sharedInstance] getEpModelFromHave].job_exam_vip;
    [self setupView];
}

- (void)setupView{
    UIImageView *imgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"v3_public_nodata"]];
    [self.view addSubview:imgView];
    
    UILabel *label = nil;
    
    if (self.isJobExamVip.integerValue == 1) { //认证通过
        label = [UILabel labelWithText:@"马上使用兼客置顶推广，岗位招聘效果可提升约3~5倍。" textColor:[UIColor XSJColor_blackBase] fontSize:18.0f];
        
        UIButton *leftBtn = [UIButton buttonWithTitle:@"效果预览" bgColor:[UIColor whiteColor] image:nil target:self sector:@selector(preview)];
        [leftBtn setTitleColor:[UIColor XSJColor_base] forState:UIControlStateNormal];
        [leftBtn setCornerValue:2.0f];
        [leftBtn setBorderWidth:1.0f andColor:[UIColor XSJColor_base]];
        UIButton *rightBtn = [UIButton buttonWithTitle:@"置顶推广" bgColor:[UIColor XSJColor_base] image:nil target:self sector:@selector(pushStick)];
        [rightBtn setCornerValue:2.0f];
        [rightBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
        [self.view addSubview:label];
        [self.view addSubview:leftBtn];
        [self.view addSubview:rightBtn];
        
        [leftBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(label.mas_bottom).offset(32);
            make.left.equalTo(self.view).offset(16);
            make.right.equalTo(rightBtn.mas_left).offset(-9);
            make.width.equalTo(rightBtn);
            make.height.equalTo(@44);
        }];
        
        [rightBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.width.height.equalTo(leftBtn);
            make.right.equalTo(self.view).offset(-16);
            make.left.equalTo(leftBtn.mas_right).offset(9);
        }];
        
    }else{
        
        NSString *titleOfLab;
        UIButton *button;
        
        if (self.authStatus.integerValue == 2 || self.authStatus.integerValue == 3) {
            titleOfLab = @"雇主发布的岗位需要经过信息审核，请在[管理]中关注岗位状态。";
            button = [UIButton buttonWithTitle:@"知道了" bgColor:[UIColor XSJColor_base] image:nil target:self sector:@selector(backToIndex)];
        }else{
            titleOfLab = @"雇主发布的岗位需要经过信息审核，请在[管理]中关注岗位状态，完成企业认证的雇主会吸引更多兼客报名";
            button = [UIButton buttonWithTitle:@"申请企业认证" bgColor:[UIColor XSJColor_base] image:nil target:self sector:@selector(applyAuth)];
        }
        
        label = [UILabel labelWithText:titleOfLab textColor:[UIColor XSJColor_blackBase] fontSize:18.0f];
        UILabel *subLabel = [UILabel labelWithText:@"(工作日9：00~21：00，2个小时内完成审核)" textColor:MKCOLOR_RGBA(34, 58, 80, 0.48) fontSize:14.0f];
        subLabel.textAlignment = NSTextAlignmentCenter;
        subLabel.numberOfLines = 0;
        
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [button setCornerValue:2.0f];
        
        [self.view addSubview:label];
        [self.view addSubview:subLabel];
        [self.view addSubview:button];
        
        [subLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(label.mas_bottom).offset(4);
            make.left.equalTo(self.view).offset(40);
            make.right.equalTo(self.view).offset(-40);
        }];
        
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(subLabel.mas_bottom).offset(32);
            make.left.equalTo(self.view).offset(16);
            make.right.equalTo(self.view).offset(-16);
            make.height.equalTo(@44);
        }];
        
    }

    label.textAlignment = NSTextAlignmentCenter;
    label.numberOfLines = 0;

    [imgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(60);
        make.width.height.equalTo(@100);
        make.centerX.equalTo(self.view);
    }];
    
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(imgView.mas_bottom).offset(24);
        make.left.equalTo(self.view).offset(17);
        make.right.equalTo(self.view).offset(-17);
    }];
    
    
}

#pragma mark - 按钮事件响应

- (void)preview{
    PreviewJob_VC *viewCtrl = [[PreviewJob_VC alloc] init];
    viewCtrl.jobId = self.jobId;
    [self.navigationController pushViewController:viewCtrl animated:YES];
}

- (void)pushStick{
    JianKeAppreciation_VC *viewCtrl = [[JianKeAppreciation_VC alloc] init];
    viewCtrl.serviceType = Appreciation_stick_Type;
    viewCtrl.jobId = self.jobId;
    viewCtrl.popToVC = [self.navigationController.viewControllers objectAtIndex:0];
    [self.navigationController pushViewController:viewCtrl animated:YES];
}

- (void)applyAuth{
    [TalkingData trackEvent:@"雇主信息_编辑_企业认证"];
    EPVerity_VC *vc=[[EPVerity_VC alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)backToIndex{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)backToLastView{
    [self.navigationController popToRootViewControllerAnimated:YES];
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
