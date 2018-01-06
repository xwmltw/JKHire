//
//  VIPHeaderView.m
//  JKHire
//
//  Created by yanqb on 2017/5/9.
//  Copyright © 2017年 xianshijian. All rights reserved.
//

#import "VIPHeaderView.h"
#import "ResponseInfo.h"
#import "WDConst.h"

@interface VIPHeaderView ()

@property (nonatomic, weak) VIPTitleView *viewOne;
@property (nonatomic, weak) VIPTitleView *viewTwo;
@property (nonatomic, weak) VIPTitleView *viewThree;
@property (nonatomic, weak) UIView *line;

@property (nonatomic, strong) NSMutableArray<VIPTitleView *> *array;

@property (nonatomic, copy) NSArray *vipList;

@end

@implementation VIPHeaderView

- (instancetype)initWithVipList:(NSArray *)vipList{
    self = [super init];
    if (self) {
        self.vipList = vipList;
        self.backgroundColor = MKCOLOR_RGB(253, 253, 254);
        [self setupViews];
    }
    return self;
}

- (void)setupViews{
    UIView *line = [[UIView alloc] init];
    line.backgroundColor = MKCOLOR_RGB(252, 181, 21);
    
    self.array = [NSMutableArray array];
    CGFloat width = SCREEN_WIDTH / self.vipList.count;
    [self.vipList enumerateObjectsUsingBlock:^(VipPackageEntryModel *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        VIPTitleView *btn = [self createBtnWithTitle:obj.package_name img:obj.package_entry_icon selectedImg:obj.package_entry_icon];
        btn.frame = CGRectMake(width * idx, 0, width, 110);
        btn.tag = idx;
        btn.identifier = obj.package_entry_identifier;
        [self.array addObject:btn];
        switch (idx) {
            case 0:{
                self.viewOne = btn;
                self.viewOne.button.selected = YES;
            }
                break;
            case 1:{
                
                self.viewTwo = btn;
            }
                break;
            case 2:{
                self.viewThree = btn;
            }
                break;
            default:
                break;
        }
    }];
    
    self.line = line;
    [self addSubview:line];
    
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.viewOne);
        make.bottom.equalTo(self);
        make.width.equalTo(@40);
        make.height.equalTo(@2);
    }];
    
}

- (VIPTitleView *)createBtnWithTitle:(NSString *)title img:(NSString *)img selectedImg:(NSString *)selectedImg{
    VIPTitleView *view = [[VIPTitleView alloc] init];
    [view.button setTitle:title forState:UIControlStateNormal];
    [view.button setTitleColor:[UIColor XSJColor_tGrayDeepTransparent48] forState:UIControlStateNormal];
    [view.button sd_setImageWithURL:[NSURL URLWithString:img] forState:UIControlStateNormal];
    [view.button sd_setImageWithURL:[NSURL URLWithString:img] forState:UIControlStateHighlighted];
    WEAKSELF
    view.block = ^(VIPTitleView *result){
        weakSelf.line.backgroundColor = [self getColorWithIndex:result.tag];
        [weakSelf.line mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(result);
            make.bottom.equalTo(self);
            make.width.equalTo(@40);
            make.height.equalTo(@2);
        }];
        
        [weakSelf.array enumerateObjectsUsingBlock:^(VIPTitleView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            obj.button.selected = NO;
            if (result == obj) {
                obj.button.selected = YES;
            }
        }];
        
        if ([weakSelf.delegate respondsToSelector:@selector(VIPHeaderView:index:)]) {
            [weakSelf.delegate VIPHeaderView:weakSelf index:result.tag];
        }
    };
    [self addSubview:view];
    return view;
}

- (void)btnOnClick:(ImgTextButton *)sender{
    
}

- (UIColor *)getColorWithIndex:(NSInteger)index{
    switch (index) {
        case 0:
            return MKCOLOR_RGB(252, 181, 21);
        case 1:
            return MKCOLOR_RGB(23, 239, 205);
        case 2:
            return MKCOLOR_RGB(54, 218, 255);
        default:
            break;
    }
    return MKCOLOR_RGB(252, 181, 21);
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end

@interface VIPTitleView ()

@property (nonatomic, strong) UIImageView *imgView;
@property (nonatomic, strong) UILabel *labProtion;

@end

@implementation VIPTitleView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupViews];
    }
    return self;
}

- (void)setupViews{
    ImgTextButton *button = [ImgTextButton buttonWithType:UIButtonTypeCustom];
    [button setTitleColor:[UIColor XSJColor_tGrayDeepTransparent48] forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:14.0f];
    [button addTarget:self action:@selector(btnOnClick:) forControlEvents:UIControlEventTouchUpInside];
    _button = button;
    
    self.imgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"invalidName"]];
    self.imgView.hidden = YES;
    self.labProtion = [[UILabel alloc] init];
    self.labProtion.textColor = [UIColor whiteColor];
    self.labProtion.font = [UIFont systemFontOfSize:10.0f];
    self.labProtion.userInteractionEnabled = NO;
    self.labProtion.hidden = YES;
    
    [self addSubview:button];
    [self addSubview:self.imgView];
    [self addSubview:self.labProtion];
    
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    [self.imgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.bottom.equalTo(button.imageView);
    }];
    [self.labProtion mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.imgView);
    }];
}

- (void)setIdentifier:(NSString *)identifier{
    _identifier = identifier;
    if (identifier.length) {
        self.labProtion.hidden = NO;
        self.labProtion.text = identifier;
        self.imgView.hidden = NO;
    }
}

- (void)btnOnClick:(ImgTextButton *)sender{
    MKBlockExec(self.block, self);
}

@end
