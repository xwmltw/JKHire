//
//  JKMangeFooterView.m
//  JKHire
//
//  Created by fire on 16/10/25.
//  Copyright © 2016年 xianshijian. All rights reserved.
//

#import "JKMangeFooterView.h"

@interface JKMangeFooterView ()

- (IBAction)btnOnClick:(id)sender;


@end

@implementation JKMangeFooterView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (IBAction)btnOnClick:(id)sender {
    if ([self.delegate respondsToSelector:@selector(btnOnClick)]) {
        [self.delegate btnOnClick];
    }
}
@end
