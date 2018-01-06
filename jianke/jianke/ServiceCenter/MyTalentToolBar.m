//
//  MyTalentToolBar.m
//  JKHire
//
//  Created by 徐智 on 2017/6/2.
//  Copyright © 2017年 xianshijian. All rights reserved.
//

#import "MyTalentToolBar.h"
#import "WDConst.h"
#import "ToolBarItem.h"

@interface MyTalentToolBar () <ToolBarItemDelegate>

@property (nonatomic, weak) ToolBarItem *itemLeft;
@property (nonatomic, weak) ToolBarItem *itemRight;
@property (nonatomic, weak) UIView *line;
@property (nonatomic, copy) NSArray *array;

@end

@implementation MyTalentToolBar

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupViews];
    }
    return self;
}

- (void)setupViews{
    ToolBarItem *item1 = [[ToolBarItem alloc] init];
    item1.type = ToolBarItemType_default;
    item1.itemTitle = @"我联系过的兼客";
    item1.selectedColor = [UIColor XSJColor_tGrayDeepTinge1];
    item1.color = [UIColor XSJColor_tGrayHistoyTransparent64];
    [item1 setItemTag:BtnOnClickActionType_contactedJK];
    item1.selected = YES;
    item1.delegate = self;
    self.itemLeft = item1;
    
    ToolBarItem *item2 = [[ToolBarItem alloc] init];
    item2.type = ToolBarItemType_default;
    item2.itemTitle = @"我收藏的简历";
    item2.selectedColor = [UIColor XSJColor_tGrayDeepTinge1];
    item2.color = [UIColor XSJColor_tGrayHistoyTransparent64];
    [item2 setItemTag:BtnOnClickActionType_collectedJK];
    item2.delegate = self;
    self.itemRight = item2;
    
    self.array = @[item1, item2];
    
    UIView *line = [[UIView alloc] init];
    line.backgroundColor = [UIColor XSJColor_tGrayDeepTinge1];
    self.line = line;
    
    [self addSubview:item1];
    [self addSubview:item2];
    [self addSubview:line];
    
    [item1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.equalTo(self);
        make.width.equalTo(item2);
    }];
    
    [item2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.bottom.equalTo(self);
        make.left.equalTo(item1.mas_right);
    }];
    
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.itemLeft);
        make.bottom.equalTo(self);
        make.height.equalTo(@1);
        make.width.equalTo(@80);
    }];
}

- (void)setContactedNum:(NSNumber *)contactedNum{
    self.itemLeft.bageVal = [NSString stringWithFormat:@"%ld", contactedNum.integerValue];
}

- (void)toolBarItem:(ToolBarItem *)item selecedIndex:(NSInteger)selectedIndex{
    [self.array enumerateObjectsUsingBlock:^(ToolBarItem*  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.selected = NO;
    }];
    item.selected = YES;
    
    [self.line mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(item);
        make.bottom.equalTo(self);
        make.height.equalTo(@1);
        make.width.equalTo(@80);
    }];
    
    if ([self.delegate respondsToSelector:@selector(MyTalentToolBar:actiontype:)]) {
        [self.delegate MyTalentToolBar:self actiontype:selectedIndex];
    }
}

- (void)setOffsetOfLineWithIndex:(NSInteger)index{
    ToolBarItem *item = (index == 0) ? self.itemLeft: self.itemRight;
    [self.line mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(item);
        make.bottom.equalTo(self);
        make.height.equalTo(@1);
        make.width.equalTo(@80);
    }];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
