//
//  TalentPool_VC.m
//  JKHire
//
//  Created by yanqb on 2017/5/31.
//  Copyright © 2017年 xianshijian. All rights reserved.
//

#import "TalentPool_VC.h"
#import "FindTalent_VC.h"
#import "MyTalent_VC.h"

@interface TalentPool_VC ()

@property (nonatomic, weak) FindTalent_VC *leftViewCtrl;
@property (nonatomic, weak) UIView *leftView;

@property (nonatomic, weak) MyTalent_VC *rightViewCtrl;
@property (nonatomic, weak) UIView *rightView;

@end

@implementation TalentPool_VC

- (void)viewDidLoad {
    self.isRootVC = YES;
    [super viewDidLoad];
    [self initNavigation];
    self.leftView.hidden = NO;
}

- (void)initNavigation{
    UISegmentedControl *segmentCtrl = [[UISegmentedControl alloc] initWithItems:@[@"发现人才", @"我的人才"]];
    segmentCtrl.frame = CGRectMake(0, 0, 200, 30);
    segmentCtrl.selectedSegmentIndex = 0;
    [segmentCtrl addTarget:self action:@selector(segmentCtrlOnClick:) forControlEvents:UIControlEventValueChanged];
    self.navigationItem.titleView = segmentCtrl;
}

#pragma mark - UISegmentedControl事件
- (void)segmentCtrlOnClick:(UISegmentedControl *)sender{
    switch (sender.selectedSegmentIndex) {
        case 0:{
            self.leftView.hidden = NO;
            if (_rightView) {
                _rightView.hidden = YES;
            }
        }
            break;
        case 1:{
            [[UserData sharedInstance] userIsLogin:^(id result) {
                if (result) {
                    self.rightView.hidden = NO;
                    if (_leftView) {
                        _leftView.hidden = YES;
                    }
                }else{
                    sender.selectedSegmentIndex = 0;
                }
            }];
        }
            break;
        default:
            break;
    }
}

#pragma mark - lazy
- (UIView *)leftView{
    if (!_leftView) {
        FindTalent_VC *vc = [[FindTalent_VC alloc] init];
        [self addChildViewController:vc];
        [self.view addSubview:vc.view];
        _leftView = vc.view;
    }
    return _leftView;
}

- (UIView *)rightView{
    if (!_rightView) {
        MyTalent_VC *vc = [[MyTalent_VC alloc] init];
        [self addChildViewController:vc];
        [self.view addSubview:vc.view];
        _rightView = vc.view;
    }
    return _rightView;
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
