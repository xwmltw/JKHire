//
//  OnlinePayTableCell.m
//  QuanWangDai
//
//  Created by 余文灿 on 2017/12/27.
//  Copyright © 2017年 kizy. All rights reserved.
//

#import "OnlinePayTableCell.h"

@implementation OnlinePayTableCell
-(id)initWithReuseIdentifier:(NSString*)reuseIdentifier{
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    if (self) {
        _introduction = [[UILabel alloc] initWithFrame:CGRectMake(AdaptationWidth(96), 6, SCREEN_WIDTH - 96 - 16, AdaptationWidth(21))];
        [self addSubview:_introduction];
        _category = [[UILabel alloc] initWithFrame:CGRectMake(AdaptationWidth(16), 6, AdaptationWidth(80), AdaptationWidth(21))];
        self.category.font = [UIFont fontWithName:@"PingFangSC-Regular" size:AdaptationWidth(15)];
        self.category.textColor = XColorWithRBBA(34, 58, 80, 0.48);
        [self addSubview:_category];
    }
    return self;
}

-(void)setIntroductionText:(NSString*)text row:(NSInteger)row{
   
    CGRect frame = [self frame];
    if (row == 3) {
        NSArray *arr = [text componentsSeparatedByString:@"、"];
        NSString *str = @"";
        for (int i=0 ; arr.count > i; i++) {
            str = [str stringByAppendingFormat:@"%@、",arr[i]];
            if (i >0 && i%2) {
                str = [str stringByAppendingFormat:@"\n"];
            }
        }
        
        self.introduction.text = str;
    }else{
        self.introduction.text = text;
    }
    
    self.introduction.numberOfLines = 0;
    self.introduction.font = [UIFont fontWithName:@"PingFangSC-Regular" size:AdaptationWidth(15)];
    self.introduction.textColor = XColorWithRGB(34, 58, 80);
    CGSize size = CGSizeMake(SCREEN_WIDTH - 96 - 16, 1000);
    CGSize labelSize = [self.introduction.text sizeWithFont:self.introduction.font constrainedToSize:size lineBreakMode:NSLineBreakByClipping];
    self.introduction.frame = CGRectMake(self.introduction.frame.origin.x, self.introduction.frame.origin.y, labelSize.width, labelSize.height);
    frame.size.height = labelSize.height+12;
    self.frame = frame;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
}

@end
