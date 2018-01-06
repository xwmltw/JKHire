//
//  GuideMaskView.m
//  JKHire
//
//  Created by yanqb on 2017/3/3.
//  Copyright © 2017年 xianshijian. All rights reserved.
//

#import "GuideMaskView.h"
#import "WDConst.h"

@interface GuideMaskView () <GuideMaskAlertViewDelegate>

@property (nonatomic, strong) UIWindow *window;
@property (nonatomic, copy) MKIntegerBlock block;

@end

@implementation GuideMaskView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        UITapGestureRecognizer *ges = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
        [self addGestureRecognizer:ges];
        self.backgroundColor = MKCOLOR_RGBA(0, 0, 0, 0.4);
    }
    return self;
}

- (instancetype)initWithTitle:(NSString *)title subTitle:(NSString *)subTitle content:(NSString *)content imgUrlStr:(NSString *)imgUrlStr cancel:(NSString *)cancelStr commit:(NSString *)commitStr block:(MKIntegerBlock)block{
    GuideMaskView *maskView = [[GuideMaskView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    maskView.alertView.title = title;
    maskView.alertView.content = content;
    maskView.alertView.commitStr = commitStr;
    maskView.alertView.cancelStr = cancelStr;
    maskView.alertView.imgUrlStr = imgUrlStr;
    maskView.alertView.subTitle = subTitle;
    maskView.alertView.delegate = maskView;
    [maskView.alertView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(maskView);
        make.left.equalTo(maskView).offset((SCREEN_WIDTH / 8));
        make.right.equalTo(maskView).offset(-(SCREEN_WIDTH / 8));
        make.top.equalTo(maskView.alertView.imgView);
    }];
    maskView.block = block;
    
    return maskView;
}

- (instancetype)initWithTitle:(NSString *)title content:(NSString *)content cancel:(NSString *)cancelStr commit:(NSString *)commitStr block:(MKIntegerBlock)block{
    return [self initWithTitle:title subTitle:nil content:content imgUrlStr:nil cancel:cancelStr commit:commitStr block:block];
}

+ (void)showTitle:(NSString *)title subTitle:(NSString *)subTitle content:(NSString *)content imgView:(NSString *)imgUrl cancel:(NSString *)cancelStr commit:(NSString *)commitStr block:(MKIntegerBlock)block{
    GuideMaskView *maskView = [[GuideMaskView alloc] initWithTitle:title subTitle:subTitle content:content imgUrlStr:imgUrl cancel:cancelStr commit:commitStr block:block];
    [maskView show];
}

+ (void)showTitle:(NSString *)title content:(NSString *)content cancel:(NSString *)cancelStr commit:(NSString *)commitStr block:(MKIntegerBlock)block{
    [self showTitle:title subTitle:nil content:content imgView:nil cancel:cancelStr commit:commitStr block:block];
}

- (void)show{
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.windowLevel = UIWindowLevel_custom;
    [self.window addSubview:self];
    self.window.hidden = NO;
    
    NSString *type =nil;
    switch (self.animationType) {
        case showAnimationType_moveIn:{
            type = kCATransitionMoveIn;
        }
            break;
        case showAnimationType_Fade:{
            type = kCATransitionFade;
        }
            break;
        case showAnimationType_Push:{
            type = kCATransitionPush;
        }
            break;
        case showAnimationType_Reveal:{
            type = kCATransitionReveal;
        }
            break;
            
        default:
            break;
    }
    if (self.animationType) {
        CATransition *transition = [CATransition animation];
        transition.duration = 0.3;
        transition.type = type;
        transition.subtype = self.subType;
        [self.alertView.layer addAnimation:transition forKey:@"animationKey"];
    }
    
}

- (void)dismiss{
    [UIView animateWithDuration:0.3 animations:^{
        self.alpha = 0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

- (void)tapAction:(UITapGestureRecognizer *)ges{
    [self dismiss];
}

- (GuideMaskAlertView *)alertView{
    if (!_alertView) {
        GuideMaskAlertView *view = [[GuideMaskAlertView alloc] init];
        [view setCornerValue:3.0f];
        view.backgroundColor = [UIColor XSJColor_newWhite];
        _alertView = view;
        [self addSubview:_alertView];
    }
    return _alertView;
}


- (void)guideMaskAlertView:(GuideMaskAlertView *)alertView actionIndex:(NSInteger)actionIndex{
    [self dismiss];
    MKBlockExec(self.block, actionIndex);
}

- (void)dealloc{
    ELog(@"GuideMaskView dealloc");
}

@end

@interface GuideMaskAlertView ()

@property (nonatomic, strong) UIButton *commitBtn;
@property (nonatomic, strong) UIButton *cancelBtn;
@property (nonatomic, strong) UILabel *labSubTitle;

@end

@implementation GuideMaskAlertView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        UITapGestureRecognizer *ges = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
        [self addGestureRecognizer:ges];
        [self setupViews];
    }
    return self;
}

- (void)setupViews{
    _titleLab = [[UILabel alloc] init];
    self.titleLab.textColor = [UIColor XSJColor_tGrayDeepTinge];
    self.titleLab.font = [UIFont systemFontOfSize:20.0f];
    self.titleLab.numberOfLines = 0;
    
    _labcontent = [[UILabel alloc] init];
    self.labcontent.textColor = [UIColor XSJColor_tGrayDeepTransparent3];
    self.labcontent.font = [UIFont systemFontOfSize:16.0f];
    self.labcontent.numberOfLines = 0;
    
    [self addSubview:self.titleLab];
    [self addSubview:self.labcontent];
    
    [self.titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(12);
        make.right.equalTo(self).offset(-12);
        make.bottom.equalTo(self.labcontent.mas_top).offset(-12);
    }];
    
    [self.labcontent mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(12);
        make.right.equalTo(self).offset(-12);
        make.bottom.equalTo(self).offset(-68);
    }];
}

- (void)tapAction:(UITapGestureRecognizer *)ges{
    
}

- (UIButton *)commitBtn{
    if (!_commitBtn) {
        _commitBtn = [self createBtn];
        _commitBtn.tag = 1;
        [self addSubview:_commitBtn];
        [_commitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self).offset(-12);
            make.bottom.equalTo(self).offset(-8);
            make.width.greaterThanOrEqualTo(@75);
            make.height.equalTo(@36);
        }];
    }
    return _commitBtn;
}

- (UIButton *)cancelBtn{
    if (!_cancelBtn) {
        _cancelBtn = [self createBtn];
        _cancelBtn.tag = 0;
        [self addSubview:_cancelBtn];
        if (_commitBtn) {
            [_cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(_commitBtn.mas_left).offset(-10);
                make.bottom.equalTo(self).offset(-8);
                make.width.greaterThanOrEqualTo(@75);
                make.height.equalTo(@36);
            }];
        }else{
            [_cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(self).offset(-12);
                make.bottom.equalTo(self).offset(-8);
                make.width.greaterThanOrEqualTo(@75);
                make.height.equalTo(@36);
            }];
        }
    }
    return _cancelBtn;
}

- (UIButton *)createBtn{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.titleLabel.font = [UIFont systemFontOfSize:14.0f];
    [button setTitleColor:[UIColor XSJColor_base] forState:UIControlStateNormal];
    [button setTitleColor:[UIColor XSJColor_base] forState:UIControlStateHighlighted];
    [button addTarget:self action:@selector(btnOnClick:) forControlEvents:UIControlEventTouchUpInside];
    return button;
}


- (void)btnOnClick:(UIButton *)sender{
    if ([self.delegate respondsToSelector:@selector(guideMaskAlertView:actionIndex:)]) {
        [self.delegate guideMaskAlertView:self actionIndex:sender.tag];
    }
}

#pragma mark - 数据加载
- (void)setTitle:(NSString *)title{
    if (!title) {
        return;
    }
    _title = title;
    self.titleLab.text = title;
}

- (void)setContent:(NSString *)content{
    if (!content) {
        return;
    }
    _content = content;
    if ([content rangeOfString:@"敏感词"].location != NSNotFound) {
        NSAttributedString *attribute = [[NSAttributedString alloc]initWithData:[content dataUsingEncoding:NSUnicodeStringEncoding]
                                                                        options:@{NSDocumentTypeDocumentAttribute:NSHTMLTextDocumentType}
                                                             documentAttributes:nil
                                                                          error:nil];
        
        self.labcontent.attributedText = attribute;
    }else{
        self.labcontent.text = content;
    }

}

- (void)setCancelStr:(NSString *)cancelStr{
    if (!cancelStr) {
        return;
    }
    _cancelStr = cancelStr;
    [self.cancelBtn setTitle:cancelStr forState:UIControlStateNormal];
}

- (void)setCommitStr:(NSString *)commitStr{
    if (!commitStr) {
        return;
    }
    _commitStr = commitStr;
    [self.commitBtn setTitle:commitStr forState:UIControlStateNormal];
}

- (void)setSubTitle:(NSString *)subTitle{
    if (!subTitle) {
        return;
    }
    _subTitle = subTitle;
    self.labSubTitle.text = subTitle;
}

- (UILabel *)labSubTitle{
    if (!_labSubTitle) {
        _labSubTitle = [UILabel labelWithText:nil textColor:[UIColor XSJColor_middelRed] fontSize:14.0f];
        [self addSubview:_labSubTitle];
        [_labSubTitle mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(_titleLab);
            make.right.equalTo(self).offset(-16);
        }];
    }
    return _labSubTitle;
}

- (void)setImgUrlStr:(NSString *)imgUrlStr{
    if (!imgUrlStr) {
        return;
    }
    _imgUrlStr = imgUrlStr;
    self.imgView.hidden = NO;
}

- (UIImageView *)imgView{
    if (!_imgView) {
        _imgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:_imgUrlStr]];
        [self addSubview:_imgView];
        if (_imgUrlStr.length && [_imgUrlStr hasPrefix:@"http"]) {
            [_imgView sd_setImageWithURL:[NSURL URLWithString:_imgUrlStr]];
            CGFloat width = SCREEN_WIDTH - SCREEN_WIDTH / 4;
            [_imgView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.bottom.equalTo(self.titleLab.mas_top).offset(-16);
                make.left.right.equalTo(self);
                make.height.equalTo(@(width * 150 / 272));
            }];
        }else{
            [_imgView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.bottom.equalTo(self.titleLab.mas_top).offset(-16);
                make.centerX.equalTo(self);
            }];
        }
    }
    return _imgView;
}

@end
