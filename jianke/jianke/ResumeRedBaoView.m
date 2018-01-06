//
//  ResumeRedBaoView.m
//  JKHire
//
//  Created by yanqb on 2017/6/30.
//  Copyright © 2017年 xianshijian. All rights reserved.
//

#import "ResumeRedBaoView.h"

@implementation ResumeRedBaoView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (instancetype)initWithFrame:(CGRect)frame{
    if (self =[super initWithFrame:frame]) {
        self = [[[NSBundle mainBundle]loadNibNamed:@"ResumeRedBao" owner:nil options:nil]firstObject];
        NSMutableAttributedString *str = [[NSMutableAttributedString alloc]initWithString:@"4. 账户没有剩余简历数时，查看兼客联系方式 需要付费"];
        [str addAttribute:NSForegroundColorAttributeName value:MKCOLOR_RGB(255, 245, 216) range:NSMakeRange(23, 4)];
        self.lab3.attributedText = str;
        
        self.layout3.constant = (15*SCREEN_HEIGHT)/667;
        
        [self setFont:_lab1];
        [self setFont:_lab2];
        [self setFont:_lab3];
        [self setFont:_lab4];
        
        
    }
    return self;
}
- (IBAction)cancelBtn:(UIButton *)sender {
    
    
    MKBlockExec(self.block,nil);
}

- (void)setFont:(UILabel *)label{

    CGFloat fontSize = (14*SCREEN_HEIGHT)/667;
    
    [label setFont:[UIFont systemFontOfSize:fontSize]];
    
}
@end
