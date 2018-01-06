//
//  ScrollBanner.m
//  JKHire
//
//  Created by fire on 16/11/2.
//  Copyright © 2016年 xianshijian. All rights reserved.
//

#import "ScrollBanner.h"
#import "Masonry.h"
#import "UIColor+Extension.h"
#import "JKHomeModel.h"
#import "WDConst.h"

#define moreViewWidth 51.0f

@interface ScrollBanner () <UIScrollViewDelegate>

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIButton *moreBtn;
@property (nonatomic, copy) NSArray *menuModelArr;
@property (nonatomic, strong) NSMutableArray *btnsArr;

@end

@implementation ScrollBanner

- (instancetype)initWithMenuModelArr:(NSArray *)menuModelArr{
    self = [super init];
    if (self) {
        _menuModelArr = menuModelArr;
        [self setScrollViewWithArr:menuModelArr];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor XSJColor_newWhite];
    }
    return self;
}

- (void)setScrollViewWithArr:(NSArray *)menuModelArr{
    self.scrollView.contentSize = CGSizeMake(btnWith * menuModelArr.count, topScrollViewHeight);
    UIButton *button;
    MenuBtnModel *menuModel;
    self.btnsArr = [NSMutableArray array];
    for (NSInteger index = 0; index < menuModelArr.count; index++) {
        menuModel = [menuModelArr objectAtIndex:index];
        button = [self addBtnWithTitle:menuModel.entry_title];
        button.tag = XZScrollViewBtnTag + index;
        button.selected = menuModel.isSelected;
        button.frame = CGRectMake(index * btnWith, 0, btnWith, topScrollViewHeight);
        [self.btnsArr addObject:button];
        [self.scrollView addSubview:button];
    }
}

- (UIButton *)addBtnWithTitle:(NSString *)title{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:[UIColor XSJColor_tGrayDeepTinge] forState:UIControlStateSelected];
    [button setTitleColor:[UIColor XSJColor_tGrayDeepTransparent2] forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:13.0f];
    [button addTarget:self action:@selector(btnOnClick:) forControlEvents:UIControlEventTouchUpInside];
    return button;
}

- (UIButton *)moreBtn{
    if (!_moreBtn) {
        _moreBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_moreBtn setImage:[UIImage imageNamed:@"jiantou_down_icon_16"] forState:UIControlStateNormal];
        [_moreBtn setImage:[UIImage imageNamed:@"jiantou_up_icon_16"] forState:UIControlStateSelected];
        [_moreBtn addTarget:self action:@selector(showMoreAction:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_moreBtn];
        [_moreBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.right.bottom.equalTo(self);
            make.width.equalTo(@(moreViewWidth));
        }];
    }
    return _moreBtn;
}

- (UIScrollView *)scrollView{
    if (!_scrollView) {
        UIScrollView *scrollView = [[UIScrollView alloc] init];
        scrollView.showsVerticalScrollIndicator = NO;
        scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView = scrollView;
        [self addSubview:scrollView];
        [scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.bottom.equalTo(self);
            make.right.equalTo(self.moreBtn.mas_left);
        }];
    }
    return _scrollView;
}

- (void)setBtnStatus:(BOOL)selected{
    self.moreBtn.selected = selected;
}

- (void)showMoreAction:(UIButton *)sender{
    if ([self.delegate respondsToSelector:@selector(moreBtnOnClickWithButton:)]) {
        [self.delegate moreBtnOnClickWithButton:sender];
    }
}

- (void)setPositionWithOffsetX:(NSInteger)index{
    CGFloat offsetX = (btnWith * index);
    CGFloat maxOffsetX = self.scrollView.width;
    if (self.scrollView.contentSize.width > maxOffsetX) {
        if ((self.scrollView.contentSize.width - offsetX) < maxOffsetX) {
            offsetX = self.scrollView.contentSize.width - maxOffsetX;
        }
        [self.scrollView setContentOffset:CGPointMake(offsetX , 0) animated:YES];
    }
}

- (void)btnOnClick:(UIButton *)sender{
    [self setPositionWithOffsetX:sender.tag - XZScrollViewBtnTag];
    [self.menuModelArr enumerateObjectsUsingBlock:^(MenuBtnModel*  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (idx == (sender.tag - XZScrollViewBtnTag)) {
            obj.selected = YES;
        }else{
            obj.selected = NO;
        }
    }];
    [self reloadData];
    if ([self.delegate respondsToSelector:@selector(scrollBanner:selectedIndex:)]) {
        [self.delegate scrollBanner:self selectedIndex:sender.tag];
    }
}

- (void)reloadData{
    UIButton *button;
    for (NSInteger index = 0; index < self.btnsArr.count; index++) {
        MenuBtnModel *model = [_menuModelArr objectAtIndex:index];
        button = [self.btnsArr objectAtIndex:index];
        button.selected = model.isSelected;
    }
}

@end
