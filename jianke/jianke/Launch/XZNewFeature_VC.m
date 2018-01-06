//
//  XZNewFeature_VC.m
//  JKHire
//
//  Created by fire on 16/10/25.
//  Copyright © 2016年 xianshijian. All rights reserved.
//

#import "XZNewFeature_VC.h"
#import "Masonry.h"
#import "WDConst.h"
#import "XSJUIHelper.h"

@interface ImgAndTextView ()

@property (nonatomic, weak) UILabel *textLab;
@property (nonatomic, weak) UILabel *detailLab;
@property (nonatomic, weak) UIImageView *imageView;

@end

@implementation ImgAndTextView

- (instancetype)initWithTextStr:(NSString *)textStr withDetailStr:(NSString *)detailStr withImageStr:(NSString *)imgStr{
    self = [super init];
    if (self) {
        self.textLab.text = textStr;
        self.detailLab.text = detailStr;
        self.imageView.image = [UIImage imageNamed:imgStr];
    }
    return self;
}

- (UILabel *)textLab{
    if (!_textLab) {
        UILabel *label = [[UILabel alloc] init];
        label.font = [UIFont systemFontOfSize:32.0f];
        label.textColor = [UIColor whiteColor];
        _textLab = label;
        [self addSubview:label];
        
        [_textLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self).offset(66);
            make.centerX.equalTo(self);
        }];
    }
    return _textLab;
}

- (UILabel *)detailLab{
    if (!_detailLab) {
        UILabel *label = [[UILabel alloc] init];
        label.font = [UIFont systemFontOfSize:14.0f];
        label.textColor = [UIColor whiteColor];
        _detailLab = label;
        [self addSubview:label];
        
        [_detailLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.textLab.mas_bottom).offset(6);
            make.centerX.equalTo(self);
        }];
    }
    return _detailLab;
}

- (UIImageView *)imageView{
    if (!_imageView) {
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        _imageView = imageView;
        [self addSubview:imageView];
        
        [_imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self).offset(-100);
            make.centerX.equalTo(self);
            make.left.equalTo(self).offset(16);
            make.right.equalTo(self).offset(-16);
        }];
    }
    return _imageView;
}

- (void)showAnimation{
    [self.textLab mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(66);
    }];
    [UIView animateWithDuration:1.0f animations:^{
        [self.textLab mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self).offset(66);
        }];
    }completion:^(BOOL finished) {
        
    }];
}

@end

@interface XZNewFeature_VC () <UIScrollViewDelegate>

@property (nonatomic, weak) UIScrollView *scrollView;
@property (nonatomic, weak) UIPageControl *pageCtrl;

@property (nonatomic, copy) NSArray *imgArr;
@property (nonatomic, strong) NSMutableArray *viewArr;

@end

@implementation XZNewFeature_VC

- (instancetype)initWithImgArr:(NSArray *)imgArr{
    self = [super init];
    if (self) {
        self.imgArr = imgArr;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupViews];
}

- (void)setupViews{
    self.view.backgroundColor = MKCOLOR_RGB(15, 204, 229);
    
    //scrollview
    UIScrollView *scrollView = [[UIScrollView alloc] init];
    scrollView.frame = [UIScreen mainScreen].bounds;
    scrollView.contentSize = CGSizeMake(SCREEN_WIDTH * self.imgArr.count, SCREEN_HEIGHT);
    scrollView.delegate = self;
    scrollView.pagingEnabled = YES;
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.showsVerticalScrollIndicator = NO;
    _scrollView = scrollView;
    [self.view addSubview:scrollView];
    
    //跳过按钮
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:@"跳过" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    button.backgroundColor = MKCOLOR_RGBA(0, 0, 0, 0.24);
    button.titleLabel.font = [UIFont systemFontOfSize:14.0f];
    [button setCornerValue:14.0f];
    [button addTarget:self action:@selector(skipAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(20);
        make.right.equalTo(self.view).offset(-18);
        make.width.equalTo(@53);
        make.height.equalTo(@28);
    }];
    
    //ImgAndTextView
    NSAssert(self.imgArr.count, @"imgArr为空~~");
    self.viewArr = [NSMutableArray array];
    NSArray *textArr = @[@"兼客优聘", @"兼职管理", @"兼职招聘", @"兼职服务"];
    NSArray *detaiTextArr = @[@"专业招人 专业做事", @"实用工具 简单易用", @"实用工具 简单易用", @"专业团队 私人定制"];
    ImgAndTextView *view = nil;
    for (NSInteger index = 0; index < self.imgArr.count; index++) {
        view = [[ImgAndTextView alloc] initWithTextStr:textArr[index] withDetailStr:detaiTextArr[index] withImageStr:self.imgArr[index]];
        view.frame = CGRectMake(SCREEN_WIDTH * index, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
        [self.viewArr addObject:view];
        [self.scrollView addSubview:view];
    }
    
    //uipagecontrol
    UIPageControl *pageCtrl = [[UIPageControl alloc] init];
    pageCtrl.pageIndicatorTintColor = MKCOLOR_RGB(0, 148, 167);
    pageCtrl.currentPageIndicatorTintColor = MKCOLOR_RGB(0, 115, 131);
    pageCtrl.currentPage = 0;
    pageCtrl.numberOfPages = self.imgArr.count;
    _pageCtrl = pageCtrl;
    [self.view addSubview:pageCtrl];
    [pageCtrl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view).offset(-24);
        make.centerX.equalTo(self.view);
        make.width.equalTo(@100);
        make.height.equalTo(@20);
    }];
    [self.view addSubview:pageCtrl];
}

#pragma mark - uiscrollview delegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGFloat x = scrollView.contentOffset.x + SCREEN_WIDTH;
    if (x - scrollView.contentSize.width > 20) {
        [self showMainVC];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    NSInteger pageNum = scrollView.contentOffset.x / SCREEN_WIDTH;
    [self showVisibleViewWithPage:pageNum];
    self.pageCtrl.currentPage = pageNum;
}

- (void)showVisibleViewWithPage:(NSInteger)page{
    ImgAndTextView *view = self.viewArr[page];
    [view showAnimation];
}

#pragma mark - 响应事件

- (void)skipAction:(UIButton *)sender{
    [self showMainVC];
}

- (void)showMainVC{
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationNone];
    [XSJUIHelper showMainScene];
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
