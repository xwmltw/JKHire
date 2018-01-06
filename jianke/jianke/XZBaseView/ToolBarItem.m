//
//  ToolBarItem.m
//  jianke
//
//  Created by yanqb on 2016/11/15.
//  Copyright © 2016年 xianshijian. All rights reserved.
//

#import "ToolBarItem.h"
#import "WDConst.h"
#import "ImgTextButton.h"

@interface ToolBarItem ()

@property (nonatomic, strong) ImgTextButton *button;
@property (nonatomic, strong) UILabel *labBageVal;


@end

@implementation ToolBarItem

- (void)setButtonTag:(NSInteger)tag{
    self.button.tag = tag;
}

- (void)setItemTitle:(NSString *)itemTitle{
    _itemTitle = itemTitle;
    [self.button setTitle:itemTitle forState:UIControlStateNormal];
}

- (void)setItemImage:(UIImage *)itemImage{
    _itemImage = itemImage;
    [self.button setImage:itemImage forState:UIControlStateNormal];
}

- (void)setItemTag:(NSInteger)tag{
    self.tag = tag;
    self.button.tag = tag;
}

- (void)setColor:(UIColor *)color{
    _color = color;
    [self.button setTitleColor:color forState:UIControlStateNormal];
}

- (void)setSelectedColor:(UIColor *)selectedColor{
    _selectedColor = selectedColor;
    [self.button setTitleColor:selectedColor forState:UIControlStateSelected];
}

- (ImgTextButton *)button{
    if (!_button) {
        _button = [ImgTextButton buttonWithType:UIButtonTypeCustom];
        if (self.type == ToolBarItemType_default) {
            _button.alignmentType = ImgTextAlignMentType_normal;
        }
        [_button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _button.titleLabel.font = [UIFont systemFontOfSize:15.0f];
        [_button addTarget:self action:@selector(toolBarBtnOnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_button];
        [_button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
    }
    return _button;
}

- (UIView *)budgeView{
    if (!_budgeView) {
        _budgeView = [[UIView alloc] init];
        [_budgeView setCornerValue:5.0f];
        _budgeView.backgroundColor = [UIColor XSJColor_middelRed];
        _budgeView.hidden = YES;
        [self addSubview:_budgeView];
        [_budgeView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.height.equalTo(@10);
            make.bottom.equalTo(_button.titleLabel.mas_top).offset(5);
            make.left.equalTo(_button.titleLabel.mas_right);
        }];
    }
    return _budgeView;
}

- (void)toolBarBtnOnClick:(UIButton *)sender{
    self.selected = !self.selected;
    if ([self.delegate respondsToSelector:@selector(toolBarItem:selecedIndex:)]) {
        [self.delegate toolBarItem:self selecedIndex:sender.tag];
    }
}

- (void)setSelected:(BOOL)selected{
    _selected = selected;
    self.button.selected = selected;
}

- (void)setTitleSize:(CGFloat)titleSize{
    _titleSize = titleSize;
    [self.button.titleLabel setFont:[UIFont systemFontOfSize:titleSize]];
}

- (void)setBageVal:(NSString *)bageVal{
    _bageVal = bageVal;
    if (!bageVal.length || bageVal.integerValue == 0) {
        self.labBageVal.hidden = YES;
    }else{
        self.labBageVal.hidden = NO;
        self.labBageVal.text = [NSString stringWithFormat:@"%ld", bageVal.integerValue];
    }
}

- (UILabel *)labBageVal{
    if (!_labBageVal) {
        _labBageVal = [UILabel labelWithText:@"0" textColor:[UIColor whiteColor] fontSize:12.0f];
        [_labBageVal setTextAlignment:NSTextAlignmentCenter];
        [_labBageVal setCornerValue:8.0f];
        [_labBageVal setBackgroundColor:[UIColor XSJColor_middelRed]];
        _labBageVal.hidden = YES;
        [self addSubview:_labBageVal];
        [_labBageVal mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@16);
            make.width.greaterThanOrEqualTo(@16);
            make.bottom.equalTo(_button.titleLabel.mas_top).offset(5);
            make.left.equalTo(_button.titleLabel.mas_right);
        }];
    }
    return _labBageVal;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
