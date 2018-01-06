//
//  XZDropDownMenu.m
//  JKHire
//
//  Created by yanqb on 2017/5/31.
//  Copyright © 2017年 xianshijian. All rights reserved.
//

#import "XZDropDownMenu.h"
#import "XZDropDownContetCell.h"
#import "XDropDowmMenuCell.h"
#import "ImgTextButton.h"
#import "WDConst.h"

#define xzMenuHeight 50.0f
#define xzDropMenuHeight 50.0f

@implementation XZIndexPath

- (instancetype)initWithColumn:(NSInteger)column indexPath:(NSIndexPath *)indexPath{
    self = [super init];
    if (self) {
        self.column = column;
        self.indexPath = indexPath;
    }
    return self;
}

@end

@interface XZDropDownMenu () <UITableViewDataSource, UITableViewDelegate, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UIGestureRecognizerDelegate>{
    NSInteger _currentColumn;
}
@property (nonatomic, weak) UIView *line;
@property (nonatomic, weak) UIView *containtView;
@property (nonatomic, strong) UIScrollView *menuScrollView;
@property (nonatomic, strong) NSMutableArray <ImgTextButton *> *btnArray;
@property (nonatomic, weak) UITableView *tableView;
@property (nonatomic, weak) UICollectionView *collectionView;
@property (nonatomic, assign) CGFloat orignHeight;

@end

@implementation XZDropDownMenu

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.orignHeight = frame.size.height;
        self.backgroundColor = MKCOLOR_RGBA(0, 0, 0, 0.4);
        UITapGestureRecognizer *tagGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapOnClick:)];
        tagGes.delegate = self;
        [self addGestureRecognizer:tagGes];
    }
    return self;
}

- (void)setDataSource:(id<XZDropDownMenuDataSource>)dataSource{
    _dataSource = dataSource;
    self.menuScrollView.hidden = NO;
}

#pragma mark - uicollectionview datasource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if ([_dataSource respondsToSelector:@selector(numberOfItemsOrRowsInXzDropMenu:atColumn:)]) {
        return [_dataSource numberOfItemsOrRowsInXzDropMenu:self atColumn:_currentColumn];
    }
    return 0;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    XZIndexPath *xzIndexPath = [[XZIndexPath alloc] initWithColumn:_currentColumn indexPath:indexPath];
    if ([_delegate respondsToSelector:@selector(menu:sizeForItemAtXzIndexPath:)]) {
        return [_delegate menu:self sizeForItemAtXzIndexPath:xzIndexPath];
    }
    return CGSizeMake((SCREEN_WIDTH - 3) / 3, 50.0f);
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    XZIndexPath *xzIndexPath = [[XZIndexPath alloc] initWithColumn:_currentColumn indexPath:indexPath];
    XZDropDownContetCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"XZDropDownContetCell" forIndexPath:indexPath];
    XZDropDownModel *model = [_dataSource menu:self modelForItemOrRowAtXZIndexPath:xzIndexPath];
    cell.model = model;
    return cell;
}

#pragma mark - uicollectionview delegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    XZIndexPath *xzIndexPath = [[XZIndexPath alloc] initWithColumn:_currentColumn indexPath:indexPath];
    if ([_delegate respondsToSelector:@selector(menu:didSelectItemOrRowAtXZIndexPath:)]) {
            [_delegate menu:self didSelectItemOrRowAtXZIndexPath:xzIndexPath];
        }
    [self setBtnStatueIndex:xzIndexPath];
    [self hides:YES atIndex:_currentColumn];
}

#pragma mark - uitableview datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if ([_dataSource respondsToSelector:@selector(numberOfItemsOrRowsInXzDropMenu:atColumn:)]) {
        return [_dataSource numberOfItemsOrRowsInXzDropMenu:self atColumn:_currentColumn];
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    XDropDowmMenuCell *cell = [tableView dequeueReusableCellWithIdentifier:@"XDropDowmMenuCell" forIndexPath:indexPath];
    XZIndexPath *xzIndexPath = [[XZIndexPath alloc] initWithColumn:_currentColumn indexPath:indexPath];
    XZDropDownModel *model = [_dataSource menu:self modelForItemOrRowAtXZIndexPath:xzIndexPath];
    cell.model = model;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([_delegate respondsToSelector:@selector(menu:heightForRowAtXzIndexPath:)]) {
        XZIndexPath *xzIndexPath = [[XZIndexPath alloc] initWithColumn:_currentColumn indexPath:indexPath];
        return [_delegate menu:self heightForRowAtXzIndexPath:xzIndexPath];
    }
    return xzDropMenuHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    XZIndexPath *xzIndexPath = [[XZIndexPath alloc] initWithColumn:_currentColumn indexPath:indexPath];
    if ([_delegate respondsToSelector:@selector(menu:didSelectItemOrRowAtXZIndexPath:)]) {
        [_delegate menu:self didSelectItemOrRowAtXZIndexPath:xzIndexPath];
    }
    [self setBtnStatueIndex:xzIndexPath];
    [self hides:YES atIndex:_currentColumn];
}

#pragma mark - 业务方法
- (void)showOrHidesAtIndexPath:(NSInteger)index{
    if (_isShow) {
        if (_currentColumn != index) {
            [self hides:NO atIndex:index];
            [self show:index];
        }else{
            [self hides:YES atIndex:index];
        }
    }else{
        [self show:index];
    }
    
    _currentColumn = index;
    if ([self isShouldSupportCollectinViewWithIndex:_currentColumn]) {
        if (_tableView) {
            [_tableView reloadData];
            _tableView.hidden = YES;
        }
        self.collectionView.hidden = NO;
        [self.collectionView reloadData];
    }else{
        if (_collectionView) {
            [_collectionView reloadData];
            _collectionView.hidden = YES;
        }
        self.tableView.hidden = NO;
        [self.tableView reloadData];
    }
}

- (void)show:(NSInteger)index{
    _isShow = YES;
    self.height = self.orignHeight;
    self.height = SCREEN_HEIGHT;
    [UIView animateWithDuration:0.2f animations:^{
        CGFloat height = 0;
        NSInteger count = [_dataSource numberOfItemsOrRowsInXzDropMenu:self atColumn:index];
        if ([self isShouldSupportCollectinViewWithIndex:index]) {
            count = (count + (3 - 1)) / 3;
        }
        height = count * xzMenuHeight;
        CGFloat maxHeight = 5 * xzMenuHeight;
        
        if (height >= maxHeight) {
            height = maxHeight;
        }
        self.containtView.height = height;
    } completion:^(BOOL finished) {
        
    }];
    [self setBtnHightedStatus:YES atIndex:index];
}

- (void)hides:(BOOL)isAnimation atIndex:(NSInteger)index{
    _isShow = NO;
    self.height = self.orignHeight;
    if (isAnimation) {
        [UIView animateWithDuration:0.2f animations:^{
            self.containtView.height = 0;
        } completion:^(BOOL finished) {
        }];
    }else{
        self.height = self.orignHeight;
        self.containtView.height = 0;
    }
    [self setBtnHightedStatus:NO atIndex:index];
}

- (void)reloadData:(XZIndexPath *)xzIndexPath{
    if ([self isShouldSupportCollectinViewWithIndex:xzIndexPath.column]) {
        [self.collectionView reloadData];
    }else{
        [self.tableView reloadData];
    }
}

- (void)reloadData{
    if ([self isShouldSupportCollectinViewWithIndex:_currentColumn]) {
        [self.collectionView reloadData];
    }else{
        [self.tableView reloadData];
    }
    [self reloadComulnData];
}

- (void)reloadComulnData{
    [self.btnArray enumerateObjectsUsingBlock:^(ImgTextButton * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSString *title = [_dataSource menu:self titleForColumn:idx];
        [obj setTitle:title forState:UIControlStateNormal];
    }];
}

- (void)btnOnClick:(UIButton *)sender{
    [self showOrHidesAtIndexPath:sender.tag];
}

- (void)setBtnStatueIndex:(XZIndexPath *)xzIndexPath{
    UIButton *btn = [self.btnArray objectAtIndex:xzIndexPath.column];
    XZDropDownModel *model = [_dataSource menu:self modelForItemOrRowAtXZIndexPath:xzIndexPath];
    [btn setTitle:model.subContet forState:UIControlStateNormal];
}

- (void)setBtnHightedStatus:(BOOL)seleced atIndex:(NSInteger)index{
    [self.btnArray enumerateObjectsUsingBlock:^(ImgTextButton * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.selected = NO;
        if (index == idx) {
            obj.selected = seleced;          
        }
    }];
}

- (void)tapOnClick:(UITapGestureRecognizer *)ges{
    [self hides:YES atIndex:_currentColumn];
}

#pragma mark - 私有方法
- (BOOL)isShouldSupportCollectinViewWithIndex:(NSInteger)index{
    if ([_dataSource respondsToSelector:@selector(menu:shouldSupportCollectionViewAtColumn:)]) {
        return [_dataSource menu:self shouldSupportCollectionViewAtColumn:index];
    }else{
        return NO;
    }
}

#pragma mark - UIGestureRecognizerDelegate

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    // 若为UITableViewCellContentView（即点击了tableViewCell），则不截获Touch事件
    if ([NSStringFromClass([touch.view class]) isEqualToString:@"UITableViewCellContentView"] || [NSStringFromClass([touch.view class]) isEqualToString:@"UIView"]) {
        return NO;
    }
    return  YES;
}

#pragma mark - lazy

- (UIScrollView *)menuScrollView{
    if (!_menuScrollView) {
        _menuScrollView = [[UIScrollView alloc] init];
        _menuScrollView.frame = CGRectMake(0, 0, self.width, self.orignHeight);
        _menuScrollView.backgroundColor = [UIColor whiteColor];
        _menuScrollView.contentSize = CGSizeMake(self.width, self.orignHeight);
        _menuScrollView.showsVerticalScrollIndicator = NO;
        _menuScrollView.showsHorizontalScrollIndicator = NO;
        
        NSAssert([_dataSource respondsToSelector:@selector(menu:titleForColumn:)], @"未重写代理协议menu:titleForColumn:");
        self.btnArray = [NSMutableArray array];
        NSInteger count = [_dataSource numberOfColumsInXzDropMenu:self];
        NSString *title = nil;
        ImgTextButton *btn = nil;
        for (NSInteger index = 0; index < count; index++) {
            title = [_dataSource menu:self titleForColumn:index];
            btn = [ImgTextButton buttonWithType:UIButtonTypeCustom];
            btn.alignmentType = ImgTextAlignMentType_leftToRight;
            [btn setTitle:title forState:UIControlStateNormal];
            [btn setTitleColor:[UIColor XSJColor_tGrayDeepTinge1] forState:UIControlStateNormal];
            [btn setTitleColor:[UIColor XSJColor_base] forState:UIControlStateSelected];
            [btn setImage:[UIImage imageNamed:@"jiantou_down_icon_16"] forState:UIControlStateNormal];
            [btn setImage:[UIImage imageNamed:@"jiantou_up_icon_16"] forState:UIControlStateSelected];
            btn.titleLabel.font = [UIFont systemFontOfSize:13.0f];
            [btn addTarget:self action:@selector(btnOnClick:) forControlEvents:UIControlEventTouchUpInside];
            btn.frame = CGRectMake((SCREEN_WIDTH / 4) * index, 0, SCREEN_WIDTH / 4, self.height);
            btn.tag = index;
            [self.btnArray addObject:btn];
            [_menuScrollView addSubview:btn];
            
            UIView *line = [[UIView alloc] init];
            line.backgroundColor = [UIColor XSJColor_clipLineGray];
            self.line = line;
            
            [self addSubview:_menuScrollView];
            [self addSubview:self.line];
            [self.line mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.bottom.right.equalTo(_menuScrollView);
                make.height.equalTo(@1);
            }];
            
        }
    }
    return _menuScrollView;
}

- (UICollectionView *)collectionView{
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.minimumLineSpacing = 1;
        layout.minimumInteritemSpacing = 1;
        UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        collectionView.backgroundColor = [UIColor XSJColor_clipLineGray];
        collectionView.tag = 10010;
        collectionView.dataSource = self;
        collectionView.delegate = self;
        [collectionView registerClass:[XZDropDownContetCell class] forCellWithReuseIdentifier:@"XZDropDownContetCell"];
        _collectionView = collectionView;
        [self.containtView addSubview:collectionView];
        [_collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.containtView);
        }];
    }
    return _collectionView;
}

- (UITableView *)tableView{
    if (!_tableView) {
        UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        tableView.delegate = self;
        tableView.dataSource = self;
        [tableView registerClass:[XDropDowmMenuCell class] forCellReuseIdentifier:@"XDropDowmMenuCell"];
        _tableView = tableView;
        [self.containtView addSubview:tableView];
        [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.containtView);
        }];
    }
    return _tableView;
}

- (UIView *)containtView{
    if (!_containtView) {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, self.orignHeight, self.width, 0)];
        view.clipsToBounds = YES;
        _containtView = view;
        [self addSubview:view];
    }
    return _containtView;
}

- (CGFloat)orignHeight{
    if (!_orignHeight) {
        _orignHeight = 50.0f;
    }
    return _orignHeight;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
