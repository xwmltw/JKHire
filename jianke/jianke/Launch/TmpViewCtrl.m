//
//  TmpViewCtrl.m
//  JKHire
//
//  Created by xuzhi on 16/10/25.
//  Copyright © 2016年 xianshijian. All rights reserved.
//

#import "TmpViewCtrl.h"
#import "WDConst.h"

@interface TmpViewCtrl ()

@end

@implementation TmpViewCtrl

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"v112_screen_bg"]];
    UIImageView *imageView2 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"LaunchScreen_youpinLogo"]];
    
//    UILabel *label = [[UILabel alloc] init];
//    label.text = @"企业兼职服务第一交易平台";
//    label.textColor = [UIColor XSJColor_tGrayDeepTransparent2];
//    label.font = [UIFont systemFontOfSize:15.0f];
    
    [self.view addSubview:imageView];
    [self.view addSubview:imageView2];
    
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.width.equalTo(@95);
//        make.height.equalTo(@125);
        make.centerY.equalTo(self.view).offset(-60);
        make.centerX.equalTo(self.view);
    }];
    [imageView2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.bottom.equalTo(self.view).offset(-32);
        make.width.equalTo(@156);
        make.height.equalTo(@36);
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
