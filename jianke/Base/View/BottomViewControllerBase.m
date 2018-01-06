//
//  BottomViewControllerBase.m
//  jianke
//
//  Created by xuzhi on 16/7/21.
//  Copyright © 2016年 xianshijian. All rights reserved.
//

#import "BottomViewControllerBase.h"
#import "MJRefresh.h"

@interface XZBannerView ()

@property (nonatomic, weak, readonly) UIButton *dismissBtn;

@end

@implementation XZBannerView


- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupViews];
    }
    return self;
}

- (void)setupViews{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitleColor:[UIColor XSJColor_tBlue] forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:15.0f];
    [button setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
//    [button setImage:[UIImage imageNamed:@"push_icon_blue"] forState:UIControlStateNormal];
    _button = button;
    [self addSubview:button];
    
    UIButton *dismissBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [dismissBtn setImage:[UIImage imageNamed:@"v3_public_close_blue"] forState:UIControlStateNormal];
    _dismissBtn = dismissBtn;
    [self addSubview:dismissBtn];
    
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    [dismissBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.equalTo(self);
        make.width.height.equalTo(@30);
    }];
}

@end

@interface BottomViewControllerBase () <UIAlertViewDelegate>

@property (nonatomic, weak) UIButton *bannerBtn;
@property (nonatomic, weak) UIButton *dismissBtn;

@end

@implementation BottomViewControllerBase

- (instancetype)init{
    self = [super init];
    if (self) {
        _btnHeight = 44;
        _marginX = 16;
        _marginY = 12;
        _marginTopY = 0;
        _marginTop = 12;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

//初始化UI
- (void)initUIWithType:(DisplayType)type{
    _type = type;
    switch (type) {
        case DisplayTypeTableViewAndBottom:
        case DisplayTypeTableViewAndLeftRightBottom:
        case DisplayTypeTableViewAndLeftRightEspectBottom:{
            NSString *output = [NSString stringWithFormat:@"****%@\n****%s : 未设置btntitles",[self class],__FUNCTION__];
            NSAssert((self.btntitles && self.btntitles.count), output);
            [self newBottomView];
        }
            break;
        case DisplayTypeOnlyTableView:
            break;
        case DisplayTypeTableViewAndTopBottom:{
            [self newTopView];
            [self newBottomView];
        }
            break;
        case DisplaytypeBannerWithDismiss:{
            [self newBannerView];
        }
            break;
        case DisplaytypeBannerWithBottom:{
            [self newBannerView];
            [self newBottomView];
        }
            break;
    }
    [self makeConstraint:type];
    [self newRefresh];
}

- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [UIHelper createTableViewWithStyle:_tableViewStyle delegate:self onView:self.view];
        _tableView.backgroundColor = [UIColor XSJColor_newGray];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _tableView;
}

- (void)newBannerView{
    XZBannerView *bannerView = [[XZBannerView alloc] init];
    bannerView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 49);
    bannerView.backgroundColor = MKCOLOR_RGBA(0, 118, 255, 0.03);
//    [bannerView addBorderInDirection:BorderDirectionTypeBottom borderWidth:0.7 borderColor:MKCOLOR_RGBA(0, 118, 255, 0.48) isConstraint:NO];
    _XZTopBanner = bannerView;
    [self.view addSubview:bannerView];
    
    [bannerView.button addTarget:self action:@selector(bannerBtnOnClick:) forControlEvents:UIControlEventTouchUpInside];
    [bannerView.dismissBtn addTarget:self action:@selector(dismissBtnOnClick:) forControlEvents:UIControlEventTouchUpInside];

}

- (void)newTopView{
    UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 10)];
    _topView = topView;
    [self.view addSubview:topView];
}

- (void)newBottomView{
    UIView *bottomView = [[UIView alloc] init];
    bottomView.backgroundColor = [UIColor XSJColor_grayTinge];
    [self.view addSubview:bottomView];
    self.bottomView = bottomView;
    [self newBottomBtns];
}

- (void)newBottomBtns{
    NSMutableArray *btns = [NSMutableArray array];
    NSInteger index = 0;
    for (NSString *title in self.btntitles) {
        UIButton *button = [UIButton creatBottomButtonWithTitle:title addTarget:self action:@selector(didClickAction:)];
        button.tag = index;
        [self.bottomView addSubview:button];
        [btns addObject:button];
        index++;
    }
    _bottomBtns = [btns copy];
}

- (void)makeConstraint:(DisplayType)type{
    if (type == DisplayTypeOnlyTableView) {
        [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.leading.bottom.trailing.equalTo(self.view);
        }];
    }else if (type == DisplayTypeTableViewAndBottom) {
        [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.equalTo(self.view);
            make.bottom.equalTo(self.bottomView.mas_top);
        }];
        [self makeBtnConstraint];
        
    }else if (type == DisplayTypeTableViewAndTopBottom){
        [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.topView.mas_bottom);
            make.left.right.equalTo(self.view);
            make.bottom.equalTo(self.bottomView.mas_top);
        }];
        [self makeBtnConstraint];
    }else if (type == DisplaytypeBannerWithDismiss){
        [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.XZTopBanner.mas_bottom);
            make.left.bottom.right.equalTo(self.view);
        }];
    }else if (type == DisplaytypeBannerWithBottom){
        [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.XZTopBanner.mas_bottom);
            make.left.right.equalTo(self.view);
            make.bottom.equalTo(self.bottomView.mas_top);
        }];
        [self makeBtnConstraint];
    }else if (type == DisplayTypeTableViewAndLeftRightBottom || self.type == DisplayTypeTableViewAndLeftRightEspectBottom){
        [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.equalTo(self.view);
            make.bottom.equalTo(self.bottomView.mas_top);
        }];
        [self makeLeftRightBtnConstraint];
    }
}

- (void)newRefresh{
    switch (self.refreshType) {
        case RefreshTypeNone:
            break;
        case RefreshTypeHeader:{
            WEAKSELF
            self.tableView.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
                [weakSelf headerRefresh];
            }];
        }
            break;
        case RefreshTypeFooter:{
            WEAKSELF
            self.tableView.footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
                [weakSelf footerRefresh];
            }];
            
        }
            break;
        case RefreshTypeAll:{
            WEAKSELF
            self.tableView.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
                [weakSelf headerRefresh];
            }];
            self.tableView.footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
                [weakSelf footerRefresh];
            }];
        }
            break;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataSource ? _dataSource.count : 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    return nil;
}

#pragma mark - 刷新事件

- (void)headerRefresh{
    
}

- (void)footerRefresh{
    
}

#pragma mark - 事件响应方法

- (void)didClickAction:(UIButton *)sender{
    if (self.btnEventBlock) {
        self.btnEventBlock(sender);
        return;
    }
    [self clickOnview:self.bottomView clickedButtonAtIndex:sender.tag];
}

- (void)clickOnview:(UIView *)bottomView clickedButtonAtIndex:(NSInteger)buttonIndex{

}


- (void)bannerBtnOnClick:(UIButton *)sender{
    [self clickOnBannerview:self.XZTopBanner actiontype:BannerBtnActiontype_Dissmiss];
}

- (void)dismissBtnOnClick:(UIButton *)sender{
    [self.XZTopBanner removeConstraints:self.XZTopBanner.constraints];
    [self.XZTopBanner removeFromSuperview];
    self.XZTopBanner = nil;
    [self.tableView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view);
    }];
    [self clickOnBannerview:self.XZTopBanner actiontype:BannerBtnActiontype_AD];
}

- (void)clickOnBannerview:(UIView *)bannerView actiontype:(BannerBtnActiontype)actionType{
    
}

#pragma mark - setter方法

- (void)setRefreshType:(RefreshType)refreshType{
    _refreshType = refreshType;
    [self newRefresh];
}

- (void)setBtntitles:(NSArray *)btntitles{
    _btntitles = btntitles;
    if (self.type == DisplayTypeTableViewAndBottom || self.type == DisplayTypeTableViewAndLeftRightBottom || self.type == DisplayTypeTableViewAndLeftRightEspectBottom) { //解决btnTitles赋值操作在初始化UI方法后面
        if (self.tableView && self.tableView.constraints) {
            [self.tableView removeConstraints:self.tableView.constraints];
        }
        
        if (self.bottomView && self.bottomView.constraints) {
            [self.bottomView.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if (obj.constraints) {
                    [obj removeConstraints:obj.constraints];
                }
                [obj removeFromSuperview];
            }];
            
            [self.bottomView removeConstraints:self.bottomView.constraints];
        }
        _bottomBtns = nil;
        [self newBottomBtns];
        [self makeConstraint:self.type];
        
//        UIButton *button;
//        NSArray *btns = self.bottomView.subviews;
//        for (NSInteger index =0 ; index < btns.count; index++) {
//            button = [btns objectAtIndex:index];
//            if (index >= btntitles.count) {
//                break;
//            }
//            [button setTitle:btntitles[index] forState:UIControlStateNormal];
//        }
    }
}

#pragma mark - 其他

/** 显示底部视图 */
- (void)showBottomView{
    if (self.type == DisplayTypeTableViewAndBottom && self.bottomView.isHidden) {
        self.bottomView.hidden = NO;
        [self removeConstraints];
        [self makeConstraint:DisplayTypeTableViewAndBottom];
    }
}

/** 隐藏底部视图 */
- (void)hidesBottomView{
    if (self.type == DisplayTypeTableViewAndBottom) {
        self.bottomView.hidden = YES;
        [self removeConstraints];
        [self makeConstraint:DisplayTypeOnlyTableView];
    }
}

/** 清除所有约束 */
- (void)removeConstraints{

    [self.tableView removeConstraints:self.tableView.constraints];
    
    if (self.type == DisplayTypeTableViewAndBottom) {
        for (UIView *subView in self.bottomView.subviews) {
            if (subView.constraints) {
                [subView removeConstraints:subView.constraints];
            }
        }
        [self.bottomView removeConstraints:self.bottomView.constraints];
    }
}

- (void)makeBtnConstraint{
    NSInteger index = self.bottomBtns.count;
    CGFloat margin = _marginY;
    for (UIButton *button in self.bottomBtns) {
        margin = index * _marginY;
        index--;
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.view).offset(_marginX);
            make.right.equalTo(self.view).offset(-(_marginX));
            make.bottom.equalTo(self.bottomView).offset(-(index * _btnHeight + margin));
            make.height.equalTo(@(_btnHeight));
        }];
    }
    
    UIButton *preBtn = [self.bottomBtns firstObject];
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.top.equalTo(preBtn.mas_top).offset(-_marginTop);
    }];
    
//    [self.bottomView addBorderInDirection:BorderDirectionTypeTop borderWidth:0.7f borderColor:[UIColor XSJColor_tGrayTinge] isConstraint:YES];
}

- (void)makeLeftRightBtnConstraint{
    
    if (self.bottomBtns.count == 1) {
        [self makeBtnConstraint];
        return;
    }
    
    UIButton *preBtn;
    UIButton *currectBtn;
    UIButton *nextBtn;
    
    if (self.bottomBtns.count == 2) {
        currectBtn = [self.bottomBtns objectAtIndex:0];
        nextBtn = [self.bottomBtns objectAtIndex:1];
        
        if (self.type == DisplayTypeTableViewAndLeftRightEspectBottom) {
            [currectBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.bottom.equalTo(self.bottomView);
                make.right.equalTo(nextBtn.mas_left);
                make.width.equalTo(@( 2 * (SCREEN_WIDTH / 3)));
                make.height.equalTo(@(_btnHeight + 2 * _marginY));
            }];
            
            [nextBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.bottom.right.equalTo(self.bottomView);
                make.left.equalTo(currectBtn.mas_right);
                make.top.equalTo(currectBtn);
            }];
        }else{
            [currectBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.bottom.equalTo(self.bottomView);
                make.right.equalTo(nextBtn.mas_left);
                make.width.equalTo(nextBtn);
                make.height.equalTo(@(_btnHeight + 2 * _marginY));
            }];
            
            [nextBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                //                make.top.equalTo(preBtn);
                make.bottom.right.equalTo(self.bottomView);
                make.left.equalTo(currectBtn.mas_right);
                make.width.top.equalTo(currectBtn);
            }];
        }
        UIButton *btn = [self.bottomBtns firstObject];
        [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.equalTo(self.view);
            make.top.equalTo(btn.mas_top).offset(-_marginTopY);
        }];
        
        [currectBtn setBackgroundImage:nil forState:UIControlStateNormal];
        [currectBtn setBackgroundImage:nil forState:UIControlStateHighlighted];
        [currectBtn setBackgroundColor:[UIColor whiteColor]];
        [currectBtn setTitleColor:[UIColor XSJColor_base] forState:UIControlStateNormal];
        
        [nextBtn setBackgroundColor:[UIColor XSJColor_base]];
        [nextBtn setTitleColor:[UIColor XSJColor_white] forState:UIControlStateNormal];
        
        return;
    }
    
    
    for (NSInteger index = 0; index < self.bottomBtns.count - 1; index++) {
        currectBtn = [self.bottomBtns objectAtIndex:index];
        nextBtn = [self.bottomBtns objectAtIndex:index + 1];
        
        if (index % 2 == 0) {
            [currectBtn setBackgroundColor:[UIColor whiteColor]];
            [currectBtn setTitleColor:[UIColor XSJColor_base] forState:UIControlStateNormal];
        }else{
            [currectBtn setBackgroundColor:[UIColor XSJColor_base]];
            [currectBtn setTitleColor:[UIColor XSJColor_white] forState:UIControlStateNormal];
        }
        
        if (index == 0) {
            [currectBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.bottom.equalTo(self.bottomView);
                make.right.equalTo(nextBtn.mas_left);
                make.width.equalTo(nextBtn);
                make.height.equalTo(@(_btnHeight + 2 * _marginY));
            }];
            continue;
        }
        
        preBtn = [self.bottomBtns objectAtIndex:index - 1];
        
        if (index == self.bottomBtns.count - 1) {
            [currectBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//                make.top.equalTo(preBtn);
                make.bottom.right.equalTo(self.bottomView);
                make.left.equalTo(preBtn.mas_right);
                make.width.top.equalTo(preBtn);
            }];
            continue;
        }
        
        [currectBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(preBtn.mas_right);
            make.bottom.equalTo(self.bottomView);
            make.right.equalTo(nextBtn.mas_left);
            make.width.height.equalTo(preBtn);
        }];
        
    }
    
    UIButton *btn = [self.bottomBtns firstObject];
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.top.equalTo(btn.mas_top);
    }];
    
    [UserData delayTask:3.0f onTimeEnd:^{
        ELog(@"%@", self.bottomView.subviews);
    }];
//    
//    [self.bottomView addBorderInDirection:BorderDirectionTypeTop borderWidth:0.7f borderColor:[UIColor XSJColor_tGrayTinge] isConstraint:YES];
}

- (NSMutableArray *)dataSource{
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}

@end
