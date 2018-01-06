//
//  MoreView.m
//  JKHire
//
//  Created by fire on 16/11/2.
//  Copyright © 2016年 xianshijian. All rights reserved.
//

#import "MoreView.h"
#import "WDConst.h"

@implementation MoreView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor XSJColor_newGray];
        [self setupView];
    }
    return self;
}

- (void)setupView{
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.minimumLineSpacing = 0.7;
    layout.minimumInteritemSpacing = 0.7;
    layout.itemSize = CGSizeMake((SCREEN_WIDTH - 2) / 3, 40);
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    UICollectionView *collectView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0) collectionViewLayout:layout];
    collectView.backgroundColor = [UIColor XSJColor_newGray];
    _collectView = collectView;
    [self addSubview:collectView];
}

- (void)showMoreView{
    self.hidden = NO;
    CGFloat col = (self.maxVisibleCol) ? self.maxVisibleCol : 5;
    [UIView animateWithDuration:0.5f animations:^{
        self.alpha = 1;
        self.collectView.height = col * 40;
        self.collectView.alpha = 1;
    } completion:^(BOOL finished) {
        [self.collectView reloadData];
        [self.collectView flashScrollIndicators];
    }];
}

- (void)hidesMoreView{
    if (self.hidden) {
        return;
    }
    [UIView animateWithDuration:0.5f animations:^{
        self.alpha = 0;
        self.collectView.height = 0;
        self.collectView.alpha = 0;
    } completion:^(BOOL finished) {
        self.hidden = YES;
    }];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self hidesMoreView];
    if ([self.delegate respondsToSelector:@selector(moreViewOnTouch)]) {
        [self.delegate moreViewOnTouch];
    }
}

@end
