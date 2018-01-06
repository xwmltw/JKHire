//
//  XZScrollBaseVC.m
//  JKHire
//
//  Created by xuzhi on 16/10/13.
//  Copyright © 2016年 xianshijian. All rights reserved.
//

#import "XZScrollBaseVC.h"

@interface XZScrollBaseVC ()

@property(nonatomic, weak)UIScrollView *scrollView;

@end

@implementation XZScrollBaseVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupViews];
}

- (void)setupViews{
    UIScrollView *scrollView = [[UIScrollView alloc] init];
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
