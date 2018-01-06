//
//  JKMangeBannerView.m
//  JKHire
//
//  Created by yanqb on 2017/4/6.
//  Copyright © 2017年 xianshijian. All rights reserved.
//

#import "JKMangeBannerView.h"
#import "ToolBarItem.h"
#import "WDConst.h"
#import "UILabel+MKExtension.h"
#import "BaseButton.h"

@interface JKMangeBannerView () <ToolBarItemDelegate>

@property (nonatomic, weak) BaseButton *btnMore;
@property (nonatomic, weak) ToolBarItem *itemWait;
@property (nonatomic, weak) ToolBarItem *itemHired;
@property (nonatomic, weak) ToolBarItem *itemRejected;
@property (nonatomic, strong) UIView *lineBot;

@end

@implementation JKMangeBannerView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor XSJColor_newGray];
        [self setupViews];
    }
    return self;
}

- (void)setupViews{
    UIView *line = [[UIView alloc] init];
    line.backgroundColor = [UIColor XSJColor_clipLineGray];
    
    self.lineBot = [[UIView alloc] init];
    self.lineBot.backgroundColor = [UIColor XSJColor_tGrayDeepTinge];
    
    UILabel *lab = [UILabel labelWithText:@"简历处理" textColor:[UIColor XSJColor_tGrayHistoyTransparent64] fontSize:16.0f];
    BaseButton *btnMore = [BaseButton buttonWithType:UIButtonTypeCustom];
    _btnMore = btnMore;
    btnMore.tag = BtnOnClickActionType_viewMoreMange;
    [btnMore setTitleColor:[UIColor XSJColor_tGrayDeepTransparent48] forState:UIControlStateNormal];
    btnMore.titleLabel.font = [UIFont systemFontOfSize:13.0f];
    [btnMore setTitle:@"更多管理" forState:UIControlStateNormal];
    [btnMore setImage:[UIImage imageNamed:@"job_icon_push"] forState:UIControlStateNormal];
    [btnMore setMarginForImg:-1 marginForTitle:0];
    [btnMore addTarget:self action:@selector(btnOnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    ToolBarItem *item1 = [[ToolBarItem alloc] init];
    item1.delegate = self;
    _itemWait = item1;
    item1.itemTitle = @"待处理";
    item1.titleSize = 13.0f;
    item1.color = [UIColor XSJColor_tGrayHistoyTransparent64];
    item1.selectedColor = [UIColor XSJColor_tGrayDeepTinge];
    item1.selected = YES;
    item1.type = ToolBarItemType_default;
    [item1 setItemTag:BtnOnClickActionType_applyForWait];
    
    ToolBarItem *item2 = [[ToolBarItem alloc] init];
    item2.delegate = self;
    _itemHired = item2;
    item2.itemTitle = @"已录用";
    item2.titleSize = 13.0f;
    item2.color = [UIColor XSJColor_tGrayHistoyTransparent64];
    item2.selectedColor = [UIColor XSJColor_tGrayDeepTinge];
    item2.type = ToolBarItemType_default;
    [item2 setItemTag:BtnOnClickActionType_applyForHired];
    
    ToolBarItem *item3 = [[ToolBarItem alloc] init];
    item3.delegate = self;
    _itemRejected = item3;
    item3.itemTitle = @"已拒绝";
    item3.titleSize = 13.0f;
    item3.color = [UIColor XSJColor_tGrayHistoyTransparent64];
    item3.selectedColor = [UIColor XSJColor_tGrayDeepTinge];
    item3.type = ToolBarItemType_default;
    [item3 setItemTag:BtnOnClickActionType_applyForRejected];
    
    [self addSubview:lab];
    [self addSubview:btnMore];
    [self addSubview:item1];
    [self addSubview:item2];
    [self addSubview:item3];
    [self addSubview:self.lineBot];
    [self addSubview:line];
    
    [lab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.equalTo(self).offset(16);
        make.height.equalTo(@22);
    }];
    
    [btnMore mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(lab);
        make.right.equalTo(self).offset(-16);
        make.height.equalTo(@22);
    }];
    
    [item1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lab.mas_bottom);
        make.left.bottom.equalTo(self);
        make.width.equalTo(item2);
    }];
    
    [item2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.height.equalTo(item1);
        make.left.equalTo(item1.mas_right);
        make.width.equalTo(item3);
    }];
    
    [item3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.height.equalTo(item2);
        make.left.equalTo(item2.mas_right);
        make.right.equalTo(self);
    }];
    
    [self.lineBot mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(item1);
        make.bottom.equalTo(self);
        make.width.equalTo(@40);
        make.height.equalTo(@0.7);
    }];
    
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self);
        make.height.equalTo(@0.7);
    }];
}

- (void)setModel:(NSString *)undealNum hireNum:(NSNumber *)hireNum{
    self.itemWait.bageVal = undealNum;
    if (hireNum.integerValue) {
        self.itemHired.itemTitle = [NSString stringWithFormat:@"已录用(%ld)", hireNum.integerValue];
    }else{
        self.itemHired.itemTitle = @"已录用";
    }
}

- (void)toolBarItem:(ToolBarItem *)item selecedIndex:(NSInteger)selectedIndex{
    [self.lineBot mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(item);
        make.bottom.equalTo(self);
        make.width.equalTo(@40);
        make.height.equalTo(@0.7);
    }];
    
    [self.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:[ToolBarItem class]]) {
            ToolBarItem *item1 = (ToolBarItem *)obj;
            item1.selected = NO;
            if (item1 == item) {
                item1.selected = YES;
            }
        }
    }];
    
    if ([self.delegate respondsToSelector:@selector(JKMangeBannerView:actionType:)]) {
        [self.delegate JKMangeBannerView:self actionType:item.tag];
    }
}

- (void)btnOnClick:(BaseButton *)sender{
    if ([self.delegate respondsToSelector:@selector(JKMangeBannerView:actionType:)]) {
        [self.delegate JKMangeBannerView:self actionType:sender.tag];
    }
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
