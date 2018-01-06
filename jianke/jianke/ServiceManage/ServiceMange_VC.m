//
//  ServiceMange_VC.m
//  JKHire
//
//  Created by xuzhi on 16/10/16.
//  Copyright © 2016年 xianshijian. All rights reserved.
//

#import "ServiceMange_VC.h"

#import "UITabBar+MKExtension.h"
#import "XZTool.h"

#define XZRedPointTag 200

@interface ServiceMange_VC ()

@property (nonatomic, strong) NSMutableArray *redPointArr;

@end

@implementation ServiceMange_VC

- (void)viewDidLoad {
    self.isRootVC = YES;
    [super viewDidLoad];
    self.navigationItem.title = @"服务管理";
    [self.view addSubview:self.customToolBar];
    [WDNotificationCenter addObserver:self selector:@selector(showJobManageRedPoint) name:IMPushJobManageNotification object:nil];
    [WDNotificationCenter addObserver:self selector:@selector(showPersonalserviceRedPoint) name:IMPushServicePersonalNotification object:nil];
}

//显示个人服务小红点
- (void)showPersonalserviceRedPoint{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self showRedPointWithIndex:1];
    });
    
}

- (void)showRedPointWithIndex:(NSInteger)index{
    if (self.tabBarController.selectedIndex != 1) {
        switch (index) {
            case 0:{
                [XSJUserInfoData sharedInstance].isShowJobManageServiceRedPoint = YES;
                [self.tabBarController.tabBar showSmallBadgeOnItemIndex:1];
            }
                break;
            case 1:{
                [XSJUserInfoData sharedInstance].isShowPersonalServiceRedPoint = YES;
                [self.tabBarController.tabBar showSmallBadgeOnItemIndex:1];
            }
                break;
        }
    }else{
        switch (index) {
            case 0:{
                if (self.selectedIndex != 0) {
                    [XSJUserInfoData sharedInstance].isShowJobManageServiceRedPoint = YES;
                    [self.tabBarController.tabBar showSmallBadgeOnItemIndex:1];
                }
            }
                break;
            case 1:{
                if (self.selectedIndex != 1) {
                    [XSJUserInfoData sharedInstance].isShowPersonalServiceRedPoint = YES;
                    [self.tabBarController.tabBar showSmallBadgeOnItemIndex:1];
                }
            }
                break;
        }
    }
    [self showRedPoint];
}

- (void)showJobManageRedPoint{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self showRedPointWithIndex:0];
    });
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (self.selectedIndex == 0) {
        [XSJUserInfoData sharedInstance].isShowJobManageServiceRedPoint = NO;
        [self removeRedPointAtIndex:0];
    }else if (self.selectedIndex == 1){
        [XSJUserInfoData sharedInstance].isShowPersonalServiceRedPoint = NO;
        [self removeRedPointAtIndex:1];
    }
    [self showRedPoint];
}

- (void)hidesTabBarRedPointWithIndex:(NSInteger)index{
    switch (index) {
        case 0:{
            [XSJUserInfoData sharedInstance].isShowJobManageServiceRedPoint = NO;
        }
            break;
        case 1:{
            [XSJUserInfoData sharedInstance].isShowPersonalServiceRedPoint = NO;
        }
            break;
    }
    [self removeRedPointAtIndex:index];
}

- (void)showRedPoint{
    if (self.customToolBar) {
        if ([XSJUserInfoData sharedInstance].isShowPersonalServiceRedPoint) {
            [self setupRedPointAtIndex:1];
        }
        if ([XSJUserInfoData sharedInstance].isShowJobManageServiceRedPoint) {
            [self setupRedPointAtIndex:0];
        }
    }
}

- (NSMutableArray *)redPointArr{
    if (!_redPointArr) {
        _redPointArr = [NSMutableArray array];
    }
    return _redPointArr;
}

- (void)setupRedPointAtIndex:(NSInteger)index{
    if (![self hasExistRedPointAtIndex:index]) {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake((SCREEN_WIDTH / self.toolBarTitles.count) * ( index + 1) - 10, 5, 10, 10)];
        view.tag = XZRedPointTag + index;
        view.backgroundColor = [UIColor XSJColor_middelRed];
        [view setToCircle];
        [self.customToolBar addSubview:view];
        [self.redPointArr addObject:view];
    }
}

- (void)removeRedPointAtIndex:(NSInteger)index{
    UIView *view = nil;
    for (NSInteger tmpIndex = 0; tmpIndex < self.redPointArr.count; tmpIndex++) {
        view = [self.redPointArr objectAtIndex:tmpIndex];
        if (view.tag == (index + XZRedPointTag)) {
            [self.redPointArr removeObject:view];
            [view removeFromSuperview];
        }
    }
    if (index == 1) {
        [XSJUserInfoData sharedInstance].isShowPersonalServiceRedPoint = NO;
    }
    if (index == 0) {
        [XSJUserInfoData sharedInstance].isShowJobManageServiceRedPoint = NO;
    }
    if (![XSJUserInfoData sharedInstance].isShowPersonalServiceRedPoint && ![XSJUserInfoData sharedInstance].isShowJobManageServiceRedPoint) {
        [self.tabBarController.tabBar hideSmallBadgeOnItemIndex:1];
    }
}

- (BOOL)hasExistRedPointAtIndex:(NSInteger)index{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"tag == %ld", (index + XZRedPointTag)];
    return [self.redPointArr filteredArrayUsingPredicate:predicate].count != 0;
}

#pragma mark - 创建toolBar

/**
 *  创建toolBar
 */

- (UIView *)customToolBar{
    if (!_customToolBar) {
        [self createToolBar];
    }
    return _customToolBar;
}

- (void)createToolBar{
    if (!self.toolBarTitles.count) {
        ELog(@"不创建toolBar")
        return;
    }
    
    NSAssert((self.childVCs.count), @"未给childVCs赋值");
    UIView *toolBar = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 49)];
    toolBar.backgroundColor = [UIColor XSJColor_blackBase];
    _customToolBar = toolBar;
    [self.view addSubview:toolBar];
    UIButton *button = nil;
    for (NSInteger index = 0; index < self.toolBarTitles.count; index++) {
        button = [self createToolBarBtn:self.toolBarTitles[index]];
        button.tag = index;
        [_customToolBar addSubview:button];
        [self layoutToolBarBtns];
    }
    self.selectedIndex = 0;
}

- (UIButton *)createToolBarBtn:(NSString *)title{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:15.0f];
    [button addTarget:self action:@selector(toolBarBtnOnClick:) forControlEvents:UIControlEventTouchUpInside];
    return button;
}

/**
 *  对toolBar排序
 */

- (void)layoutToolBarBtns{
    NSArray *subViews = [_customToolBar subviews];
    CGFloat width = SCREEN_WIDTH / subViews.count;
    CGFloat height = _customToolBar.height;
    for (NSInteger index = 0; index < subViews.count; index++) {
        UIView *view = [subViews objectAtIndex:index];
        view.frame = CGRectMake(width * index, 0, width, height);
    }
}

#pragma mark - toolBar点击业务

- (void)toolBarBtnOnClick:(UIButton *)sender{
    [self removeRedPointAtIndex:sender.tag];
    self.selectedIndex = sender.tag;
}

/**
 *  重写selectedIndex点方法,同时赋予创建childVC的业务
 */
- (void)setSelectedIndex:(NSInteger)selectedIndex{
    _selectedIndex = selectedIndex;
    [self hidesTabBarRedPointWithIndex:selectedIndex];
    [self setSelectedBtnHightLight:selectedIndex];
    if (![self hasSelectedVCAtIndex:selectedIndex]){
        UIViewController *vc = [self.childVCs objectAtIndex:selectedIndex];
        [self addChildViewController:vc];
        [self.view addSubview:vc.view];
        [vc.view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.customToolBar.mas_bottom);
            make.left.right.bottom.equalTo(self.view);
        }];
    }
    [self setChildVCShowAtIndex:selectedIndex];
}

- (void)setSelectedBtnHightLight:(NSInteger)selectedIndex{
    for (UIButton *button in self.customToolBar.subviews) {
        if ([button isKindOfClass:[UIButton class]]) {
            [button setTitleColor:MKCOLOR_RGBA(150, 150, 150, 0.88) forState:UIControlStateNormal];
            button.titleLabel.font = [UIFont systemFontOfSize:15.0f];
        }
    }
    if (selectedIndex < self.customToolBar.subviews.count) {
        UIButton *button = [self.customToolBar.subviews objectAtIndex:selectedIndex];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont boldSystemFontOfSize:15.0f];
    }
}

- (void)setChildVCShowAtIndex:(NSInteger)index{
    NSArray *views = [self.childVCs valueForKey:@"view"];
    [views enumerateObjectsUsingBlock:^(UIView*  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.hidden = YES;
    }];
    UIView *view = [views objectAtIndex:index];
    view.hidden = NO;
}

- (BOOL)hasSelectedVCAtIndex:(NSInteger)index{
    UIViewController *vc = [self.childVCs objectAtIndex:index];
    return !([self.childViewControllers indexOfObject:vc] == NSNotFound);
}

- (void)dealloc{
    [WDNotificationCenter removeObserver:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
