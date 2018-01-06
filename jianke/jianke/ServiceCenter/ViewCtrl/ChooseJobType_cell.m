//
//  ChooseJobType_cell.m
//  JKHire
//
//  Created by yanqb on 2017/3/3.
//  Copyright © 2017年 xianshijian. All rights reserved.
//

#import "ChooseJobType_cell.h"
#import "Masonry.h"
#import "WDConst.h"

@interface ChooseJobType_cell ()

@end

@implementation ChooseJobType_cell

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = MKCOLOR_RGBA(34, 58, 80, 0.03);
        [self setupViews];
    }
    return self;
}

- (void)setupViews{
    self.tagLab = [[UILabel alloc] init];
    self.tagLab.textColor = [UIColor XSJColor_tGrayDeepTinge];
    self.tagLab.textAlignment = NSTextAlignmentCenter;
    self.tagLab.font = [UIFont systemFontOfSize:14.0f];
    [self.contentView addSubview:self.tagLab];
    [self.tagLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView);
    }];
}

@end
