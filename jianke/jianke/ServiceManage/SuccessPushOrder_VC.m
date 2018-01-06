//
//  SuccessPushOrder_VC.m
//  JKHire
//
//  Created by yanqb on 2016/12/6.
//  Copyright © 2016年 xianshijian. All rights reserved.
//

#import "SuccessPushOrder_VC.h"
#import "JobVasOrder_VC.h"
#import "WebView_VC.h"
#import "JKManage_NewVC.h"
#import "MyEnum.h"

@interface SuccessPushOrder_VC ()

@property (nonatomic,strong) JobVasResponse *model;

@end

@implementation SuccessPushOrder_VC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"推送已发出";
    [self initWithNoDataViewWithStr:[NSString stringWithFormat:@"系统已经向%ld名兼客发出推送", self.push_num.integerValue] labColor:nil imgName:@"v3_public_success" onView:self.view];
    self.viewWithNoData.hidden = NO;
    [self setBotBtns];
//    [self getData];
}

- (void)setBotBtns{
    UIView *botView = [[UIView alloc] init];
    UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftBtn setTitle:@"查看推送记录" forState:UIControlStateNormal];
    [leftBtn setTitleColor:[UIColor XSJColor_base] forState:UIControlStateNormal];
    leftBtn.titleLabel.font = [UIFont systemFontOfSize:17.0f];
    leftBtn.tag = BtnOnClickActionType_sliderLeft;
    [leftBtn addTarget:self action:@selector(btnOnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightBtn setTitle:@"返回兼职管理" forState:UIControlStateNormal];
    [rightBtn setBackgroundColor:[UIColor XSJColor_base]];
    rightBtn.titleLabel.font = [UIFont systemFontOfSize:17.0f];
    rightBtn.tag = BtnOnClickActionType_sliderRight;
    [rightBtn addTarget:self action:@selector(btnOnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:botView];
    [botView addSubview:leftBtn];
    [botView addSubview:rightBtn];
    
    [botView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.top.equalTo(leftBtn);
    }];
    
    [leftBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.equalTo(botView);
        make.width.equalTo(rightBtn);
        make.height.equalTo(@60);
    }];
    
    [rightBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.bottom.equalTo(botView);
        make.width.height.equalTo(leftBtn);
        make.left.equalTo(leftBtn.mas_right);
    }];
    
}
//
//- (void)getData{
//    WEAKSELF
//    [[XSJRequestHelper sharedInstance] queryJobVasInfo:self.jobId block:^(ResponseInfo *result) {
//        if (result) {
//            weakSelf.model = [JobVasResponse objectWithKeyValues:result.content];
//            [weakSelf reloadUI];
//        }
//    }];
//}

//- (void)reloadUI{
//    self.viewWithNoData.hidden = NO;
//    if (self.model.last_push_desc.length) {
//        [self setNoDataViewText:self.model.last_push_desc];
//    }else{
//        [self setNoDataViewText:@"邀约成功"];
//    }
//}

- (void)btnOnClick:(UIButton *)sender{
    switch (sender.tag) {
        case BtnOnClickActionType_sliderLeft:{
            [self lookPushHistory];
        }
            break;
        case BtnOnClickActionType_sliderRight:{
            [self backToJKManage];
        }
            break;
        default:
            break;
    }
}

- (void)lookPushHistory{
    WebView_VC* vc = [[WebView_VC alloc] init];
    vc.url = [NSString stringWithFormat:@"%@%@%@", URL_HttpServer, KUrl_jobPushOrderList, self.jobId];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)backToJKManage{
    for (UIViewController *viewCtrl in self.navigationController.childViewControllers) {
        if ([viewCtrl isKindOfClass:[JKManage_NewVC class]]) {
            [self.navigationController popToViewController:viewCtrl animated:YES];
            return;
        }
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)backToLastView{
    for (UIViewController *viewCtrl in self.navigationController.childViewControllers) {
        if ([viewCtrl isKindOfClass:[JobVasOrder_VC class]]) {
            [self.navigationController popToViewController:viewCtrl animated:YES];
            return;
        }
    }
    [self.navigationController popViewControllerAnimated:YES];
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
