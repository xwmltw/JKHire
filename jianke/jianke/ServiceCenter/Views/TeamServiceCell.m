//
//  TeamServiceCell.m
//  JKHire
//
//  Created by fire on 16/10/11.
//  Copyright © 2016年 xianshijian. All rights reserved.
//

#import "TeamServiceCell.h"
#import "Masonry.h"
#import "WDConst.h"
#import "JKHomeModel.h"
#import "ImgTextButton.h"

#define MaxCountPerRow 4
#define BtnWidth ([UIScreen mainScreen].bounds.size.width / MaxCountPerRow)

#define MaxCountPerPage 8


@interface TeamServiceCell ()<UIScrollViewDelegate> {
    NSArray *_btnModelArr;
}

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, weak) UIView *bgView;
@property (nonatomic, weak) UIPageControl *pageCtrl;

@end

@implementation TeamServiceCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
}

- (UIScrollView *)scrollView{
    if (!_scrollView) {
        UIScrollView *scrollView = [[UIScrollView alloc] init];
        scrollView.bounces = NO;
        scrollView.indicatorStyle = UIScrollViewIndicatorStyleWhite;
        scrollView.pagingEnabled = YES;
        scrollView.delegate = self;
        _scrollView = scrollView;
        [self.contentView addSubview:scrollView];
        
        [_scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.contentView);
        }];
       
    }
    return _scrollView;
}

- (UIView *)bgView{
    if (!_bgView) {
        UIView *bgView = [[UIView alloc] init];
        _bgView = bgView;
        [self.scrollView addSubview:_bgView];
    }
    return _bgView;
}

- (UIPageControl *)pageCtrl{
    if (!_pageCtrl) {
        UIPageControl *pageCtrl = [[UIPageControl alloc] init];
        pageCtrl.pageIndicatorTintColor = [UIColor XSJColor_grayDeep];
        pageCtrl.currentPageIndicatorTintColor = [UIColor XSJColor_tGray];
        _pageCtrl = pageCtrl;
        [self.contentView addSubview:pageCtrl];
        
        [_pageCtrl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(@1);
            make.centerX.equalTo(self.contentView);
            make.bottom.equalTo(self.contentView).offset(2);
        }];
    }
    return _pageCtrl;
}

- (void)setModel:(NSArray *)model{
    _btnModelArr = model;
    [self.bgView.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj removeFromSuperview];
    }];
    if (!model.count) {
        return;
    }
    NSInteger page = (model.count + MaxCountPerPage - 1) / MaxCountPerPage;
    CGFloat scrollHeight = (model.count <= MaxCountPerRow) ? BtnHeight : BtnHeight * 2 ;
    
    if (page > 1) {
        self.pageCtrl.numberOfPages = page;
        self.pageCtrl.hidden = NO;
    }else{
        self.pageCtrl.hidden = YES;
    }
    
    self.scrollView.contentSize = CGSizeMake(SCREEN_WIDTH * page, scrollHeight);
    self.bgView.frame = CGRectMake(0, 0, SCREEN_WIDTH * page, scrollHeight);
    
    MenuBtnModel *btnModel = nil;
    UIButton *button = nil;
    for (NSInteger index = 0; index < model.count; index ++) {  //添加button
        btnModel = [model objectAtIndex:index];
        button = [self addBtnWithBtnModel:btnModel];
        button.tag = index;
    }
    
    [self layoutBtns:model.count];  //排列

}

- (UIButton *)addBtnWithBtnModel:(MenuBtnModel *)btnModel{
    ImgTextButton *button = [ImgTextButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, BtnWidth, BtnHeight);
    [button setBackgroundColor:[UIColor XSJColor_newWhite]];
    button.titleLabel.textAlignment = NSTextAlignmentCenter;
    [button setTitle:btnModel.entry_title forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:12.0f];
    [button setTitleColor:MKCOLOR_RGB(145, 157, 168) forState:UIControlStateNormal];
    [button setTitleColor:[UIColor XSJColor_tGrayDeepTransparent2] forState:UIControlStateNormal];
    [button sd_setImageWithURL:[NSURL URLWithString:btnModel.entry_icon] forState:UIControlStateNormal placeholderImage:nil];
    [button addTarget:self action:@selector(btnOnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.bgView addSubview:button];
    return button;
}

- (void)layoutBtns:(NSInteger)count{
    NSArray *subViews = self.bgView.subviews;
    NSInteger row;
    NSInteger col;
    UIButton *button;
    for (NSInteger index = 0; index < subViews.count ; index++) {
        button = (UIButton *)subViews[index];
        row = index / MaxCountPerRow;
        col = index % MaxCountPerRow;
        if (row % 2 == 1) { //每屏第一行
            button.y = BtnHeight;
        }else if (row % 2 == 0){    //每屏第二行
            button.y = 0;
        }
        NSInteger btnInPage = index / MaxCountPerPage;
        button.x = SCREEN_WIDTH * btnInPage + (BtnWidth * col);
    }
}

- (void)btnOnClick:(UIButton *)sender{
    
    MenuBtnModel *btnModel = [_btnModelArr objectAtIndex:sender.tag];
    
    if ([self.delegate respondsToSelector:@selector(teamServiceCell:btnModel:)]) {
        [self.delegate teamServiceCell:self btnModel:btnModel];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    NSInteger page = scrollView.contentOffset.x / SCREEN_WIDTH;
    self.pageCtrl.currentPage = page;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
