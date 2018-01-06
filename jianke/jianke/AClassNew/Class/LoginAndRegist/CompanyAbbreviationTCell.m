//
//  CompanyAbbreviationTCell.m
//  JKHire
//
//  Created by yanqb on 2017/6/13.
//  Copyright © 2017年 xianshijian. All rights reserved.
//

#import "CompanyAbbreviationTCell.h"
#import "UIPlaceHolderTextView.h"

@interface CompanyAbbreviationTCell ()

@property (nonatomic, weak) UIPlaceHolderTextView *textView;
@property (nonatomic, weak) UILabel *labTip;
@property (nonatomic, copy) NSString *placeHolder;
@property (nonatomic, assign) NSInteger maxLength;


@end
@implementation CompanyAbbreviationTCell

-(void)setCellWithPlaceHilder:(NSString *)placeHolder maxLength:(NSInteger )maxLength epModel:(EPModel *)epModel{

    UILabel *lbl = [[UILabel alloc]init];
    [lbl setFont:[UIFont systemFontOfSize:12]];
    [lbl setText:@"公司简介"];
    [lbl setTextColor:MKCOLOR_RGBA(34, 58, 80, 0.64)];
    
    UIPlaceHolderTextView *textView = [[UIPlaceHolderTextView alloc] init];
    textView.placeholder = placeHolder;
    textView.placeholderColor = [UIColor XSJColor_tGrayDeepTransparent32];
    textView.backgroundColor = [UIColor XSJColor_newGray];
    textView.font = [UIFont systemFontOfSize:16.0f];
    textView.maxLength = maxLength;
    self.maxLength = maxLength;
    self.textView = textView;
    
    UILabel *lable = [[UILabel alloc]init];
    [lable setFont:[UIFont systemFontOfSize:12]];
    lable.textColor = [UIColor XSJColor_tGrayDeepTransparent32];
    lable.attributedText = [self getMutableAttStrWith:nil];
    _labTip = lable;
    
    WEAKSELF
    textView.block = ^(NSString *text){
        epModel.desc = text;
        weakSelf.labTip.attributedText = [weakSelf getMutableAttStrWith:text];
        
    };
    [self addSubview:lbl];
    [self addSubview:textView];
    [self addSubview:lable];
    
    [lbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.equalTo(self).offset(16);
    }];
    
    [textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lbl.mas_bottom).offset(8);
        make.left.equalTo(self).offset(16);
        make.right.equalTo(self).offset(-16);
        make.height.mas_equalTo(220);
        
    }];
    
    [lable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(textView.mas_bottom).offset(8);
        make.right.equalTo(self).offset(-16);
    }];


}

- (void)awakeFromNib {
    [super awakeFromNib];
    
}
- (NSMutableAttributedString *)getMutableAttStrWith:(NSString *)text{
    if (!text.length) {
        text = @"";
    }
    NSMutableAttributedString *mutableAttStr = [[NSMutableAttributedString alloc] initWithString:@"还能输入" attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:12.0f], NSForegroundColorAttributeName: [UIColor XSJColor_tGrayDeepTinge]}];
    NSString *str = [NSString stringWithFormat:@"%ld", self.maxLength - text.length];
    NSAttributedString *attStr1 = [[NSAttributedString alloc] initWithString:str attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:12.0f], NSForegroundColorAttributeName: [UIColor XSJColor_middelRed]}];
    NSAttributedString *attStr2 = [[NSAttributedString alloc] initWithString:@"字" attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:12.0f], NSForegroundColorAttributeName: [UIColor XSJColor_tGrayDeepTinge]}];
    [mutableAttStr appendAttributedString:attStr1];
    [mutableAttStr appendAttributedString:attStr2];
    return mutableAttStr;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
