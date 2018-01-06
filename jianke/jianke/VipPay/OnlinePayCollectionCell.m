//
//  OnlinePayCollectionCell.m
//  QuanWangDai
//
//  Created by 余文灿 on 2017/12/27.
//  Copyright © 2017年 kizy. All rights reserved.
//

#import "OnlinePayCollectionCell.h"

@implementation OnlinePayCollectionCell
{
    UIImageView *image;
    UILabel *nameLab;
    UILabel *moneyLab;
}

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        
        image = [[UIImageView alloc]init];
        [self.contentView addSubview:image];
        
        nameLab = [[UILabel alloc]init];
        nameLab.textAlignment = NSTextAlignmentCenter;
        [nameLab setFont:[UIFont fontWithName:@"PingFangSC-Regular" size:AdaptationWidth(15)]];
        [nameLab setTextColor:XColorWithRBBA(34, 58, 80, 0.48)];
        [self.contentView addSubview:nameLab];
        
        moneyLab = [[UILabel alloc]init];
        moneyLab.textAlignment = NSTextAlignmentCenter;
        [moneyLab setFont:[UIFont fontWithName:@"PingFangSC-Regular" size:AdaptationWidth(13)]];
        [moneyLab setTextColor:XColorWithRBBA(34,58,80, 0.32)];
        [self.contentView addSubview:moneyLab];
        
        _changebtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.contentView addSubview:_changebtn];
    }
    return self;
}

+ (BOOL)requiresConstraintBasedLayout {
    return YES;
}

- (void)updateConstraints {
    [image mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.contentView).offset(AdaptationWidth(16));
        make.centerX.mas_equalTo(self.contentView);
        make.width.height.mas_offset(AdaptationWidth(56));
    }];
    [nameLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(image.mas_bottom).offset(AdaptationWidth(8));
        make.left.right.mas_equalTo(self.contentView);
        make.height.mas_offset(AdaptationWidth(21));
    }];
    [moneyLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(nameLab.mas_bottom);
        make.left.right.mas_equalTo(self.contentView);
    }];
    [_changebtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(nameLab.mas_bottom).offset(AdaptationWidth(26));
        make.centerX.mas_equalTo(self.contentView);
        make.width.height.mas_offset(AdaptationWidth(28));
    }];
    [super updateConstraints];
}

- (void)configureWith:(id)dic indexPath:(NSInteger)row{
    
    [image setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@",dic[@"image"][row]]]];
    [image setHighlightedImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@",dic[@"selectedimage"][row]]]];
    [nameLab setText:[NSString stringWithFormat:@"%@",dic[@"name"][row]]];
    [moneyLab setText:[NSString stringWithFormat:@"%@",dic[@"money"][row]]];
    [_changebtn setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@",dic[@"btnimage"][row]]] forState:UIControlStateNormal];
    [_changebtn setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@",dic[@"btnselectedimage"][row]]] forState:UIControlStateSelected];
//    if (row == 0) {
//        _changebtn.selected = YES;
//    }else{
//        _changebtn.selected = NO;
//    }
    
}


@end
