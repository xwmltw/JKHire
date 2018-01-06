//
//  OnlineCollectionReusableView.m
//  QuanWangDai
//
//  Created by 余文灿 on 2017/12/27.
//  Copyright © 2017年 kizy. All rights reserved.
//

#import "OnlineCollectionReusableView.h"

@implementation OnlineCollectionReusableView
- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        
        _imageView = [[UIImageView alloc]initWithFrame:CGRectZero];
        [_imageView setBackgroundColor:[UIColor clearColor]];
        
        _titleLabe = [[UILabel alloc]initWithFrame:CGRectZero];
        [_titleLabe setFont:[UIFont fontWithName:@"PingFangSC-Regular" size:AdaptationWidth(15)]];
        [_titleLabe setTextColor:XColorWithRBBA(34, 58, 80, 0.16)];
        
        [self addSubview:_imageView];
        [_imageView addSubview:_titleLabe];
        
        _line = [[UIView alloc]init];
        _line.backgroundColor = XColorWithRGB(233, 233, 235);
        [_imageView addSubview:_line];
        
        
    }
    return self;
}

+ (BOOL)requiresConstraintBasedLayout {
    return YES;
}

- (void)updateConstraints {
    [_titleLabe mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self);
        make.bottom.mas_equalTo(self);
        make.height.equalTo(@(21));
    }];
    [_imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self).offset(0);
        make.centerY.mas_equalTo(self);
        make.bottom.mas_equalTo(self);
    }];
    
    [_line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self);
        make.top.mas_equalTo(self);
        make.height.mas_equalTo(1);
    }];
    [super updateConstraints];
}

@end
