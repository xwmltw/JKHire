//
//  MutilScrollBase_VC.m
//  JKHire
//
//  Created by fire on 16/11/2.
//  Copyright © 2016年 xianshijian. All rights reserved.
//

#import "MutilScrollBase_VC.h"
#import "ScrollBanner.h"
#import "MoreView.h"
#import "TitleColletionCell.h"
#import "TeamServiceList_VC.h"
#import "TeamServiceMag_VC.h"

@interface MutilScrollBase_VC () <UICollectionViewDelegateFlowLayout,UICollectionViewDataSource, ScrollBannerDelegate, MoreViewDelegate>

@property (nonatomic, strong) ScrollBanner *bannerView;
@property (nonatomic, strong) UIScrollView *topScrollView;
@property (nonatomic, strong) UIButton *moreBtn;
@property (nonatomic, assign) NSInteger selectedIndex;
@property (nonatomic, strong) MoreView *moreView;
@property (nonatomic, assign) NSInteger currentSelecedIndex;
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, assign) BOOL hasMoreView;

@end

@implementation MutilScrollBase_VC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"找团队服务商";
    [UserData sharedInstance].popViewCtrl = self;
    [self setupViews];
}

- (void)setupViews{
    UIButton *btnQrCode = [UIButton buttonWithType:UIButtonTypeCustom];
    btnQrCode.frame = CGRectMake(0, 0, 83, 44);
    btnQrCode.titleLabel.font = [UIFont systemFontOfSize:16];
    [btnQrCode setTitle:@"我的预约单" forState:UIControlStateNormal];
    [btnQrCode setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btnQrCode addTarget:self action:@selector(lookMyInviteList) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:btnQrCode];
    self.navigationItem.rightBarButtonItem = rightItem;
    
    if (self.menuModelArr.count) {
        [self.menuModelArr.firstObject setSelected:YES];
        self.bannerView = [[ScrollBanner alloc] initWithMenuModelArr:self.menuModelArr];
        self.bannerView.delegate = self;
        [self.view addSubview:self.bannerView];
        [self.bannerView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.equalTo(self.view);
            make.height.equalTo(@(topScrollViewHeight));
        }];
        
        UIView *view = [[UIView alloc] init];
        view.backgroundColor = [UIColor XSJColor_clipLineGray];
        [self.view addSubview:view];
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.bannerView.mas_bottom).offset(-0.7);
            make.left.right.equalTo(self.view);
            make.height.equalTo(@0.7);
        }];
        
        self.contentView = [[UIView alloc] init];
        [self.view addSubview:self.contentView];
        [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.bannerView.mas_bottom);
            make.left.bottom.right.equalTo(self.view);
        }];
        
        self.selectedIndex = XZScrollViewBtnTag;
    }
}

#pragma mark - lazy

- (MoreView *)moreView{
    if (!_moreView) {
        _hasMoreView = YES;
        _moreView = [[MoreView alloc] init];
        _moreView.backgroundColor = MKCOLOR_RGBA(0, 0, 0, 0.6);
        _moreView.delegate = self;
        _moreView.collectView.delegate = self;
        _moreView.collectView.dataSource = self;
        NSInteger cols = (self.menuModelArr.count + 3 - 1) / 3;
        _moreView.maxVisibleCol = MIN(cols, 5);
        [self.view addSubview:_moreView];
        [_moreView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.bannerView.mas_bottom);
            make.left.bottom.right.equalTo(self.view);
        }];
        [_moreView.collectView registerNib:nib(@"TitleColletionCell") forCellWithReuseIdentifier:@"TitleColletionCell"];
    }
    return _moreView;
}

#pragma mark - uicollectview datasource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.menuModelArr.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    TitleColletionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"TitleColletionCell" forIndexPath:indexPath];
    MenuBtnModel *model = [self.menuModelArr objectAtIndex:indexPath.item];
    [cell setMenuBtnModel:model];
    return cell;
}

#pragma mark - uicollectiview delegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    [self.menuModelArr enumerateObjectsUsingBlock:^(MenuBtnModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (idx == indexPath.item) {
            obj.selected = YES;
        }else{
            obj.selected = NO;
        }
    }];
    [collectionView reloadData];
    [self hidesMoreView];
    [self.bannerView reloadData];
    [self.bannerView setBtnStatus:NO];
    [self.bannerView setPositionWithOffsetX:indexPath.item];
    self.selectedIndex = indexPath.item + XZScrollViewBtnTag;
}

#pragma mark - scrollviewbanner delegate

- (void)scrollBanner:(ScrollBanner *)banner selectedIndex:(NSInteger)index{
    [self.bannerView setBtnStatus:NO];
    [self setSelectedIndex:index];
    if (self.hasMoreView) {
        [self hidesMoreView];
    }
}

- (void)moreBtnOnClickWithButton:(UIButton *)sender{
    if (sender.selected) {
        [self hidesMoreView];
    }else{
        [self showMoreView];
    }
    sender.selected = !sender.selected;
}

#pragma mark - MoreViewDelegate

- (void)moreViewOnTouch{
    [self.bannerView setBtnStatus:NO];
}

#pragma mark - 响应事件

- (void)showMoreAction:(UIButton *)sender{
    
}

#pragma mark - 其他

- (void)showMoreView{
    [self.moreView showMoreView];
}

- (void)hidesMoreView{
    [self.moreView hidesMoreView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setSelectedIndex:(NSInteger)selectedIndex{
    _selectedIndex = selectedIndex;
    self.currentSelecedIndex = selectedIndex;
    if (![self hasSelectedVCAtIndex:selectedIndex]){
        TeamServiceList_VC *vc = [[TeamServiceList_VC alloc] init];
        vc.view.tag = selectedIndex;
        vc.cityId = [UserData sharedInstance].city.id;
        vc.service_classify_id = [self.menuModelArr objectAtIndex:(selectedIndex - XZScrollViewBtnTag)].service_classify_id;
        vc.service_classify_name = [self.menuModelArr objectAtIndex:(selectedIndex - XZScrollViewBtnTag)].service_classify_name;
        [self addChildViewController:vc];
        [self.contentView addSubview:vc.view];
        [vc.view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.contentView);
        }];
    }
    [self setChildVCShowAtIndex:selectedIndex];
}

- (void)setChildVCShowAtIndex:(NSInteger)index{
    NSArray *views = [self.childViewControllers valueForKey:@"view"];
    [views enumerateObjectsUsingBlock:^(UIView*  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj.tag == index) {
            obj.hidden = NO;
        }else{
            obj.hidden = YES;
        }
    }];
    
}

- (BOOL)hasSelectedVCAtIndex:(NSInteger)index{
    NSArray *views = [self.childViewControllers valueForKey:@"view"];
    for (UIView *view in views) {
        if (view.tag == index) {
            return YES;
        }
    }
    return NO;
}

- (void)lookMyInviteList{
    WEAKSELF
    [[UserData sharedInstance] userIsLogin:^(id result) {
        if (result) {
            TeamServiceMag_VC *viewCtrl = [[TeamServiceMag_VC alloc] init];
            [weakSelf.navigationController pushViewController:viewCtrl animated:YES];
        }
    }];
}

- (void)dealloc{
    ELog(@"%@消失了", [self class]);
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
