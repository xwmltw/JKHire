//
//  EditEmployerHeaderView.m
//  JKHire
//
//  Created by yanqb on 2017/3/7.
//  Copyright © 2017年 xianshijian. All rights reserved.
//

#import "EditEmployerHeaderView.h"
#import "EPModel.h"
#import "WDConst.h"

@interface EditEmployerHeaderView (){
    EPModel *_epModel;
}



@end

@implementation EditEmployerHeaderView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupViews];
    }
    return self;
}

- (void)setupViews{
    self.headImgView = [[UIImageView alloc] init];
    [self.headImgView setCornerValue:35.0f];
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.tag = BtnOnClickActionType_uploadHeadImg;
    [btn addTarget:self action:@selector(btnOnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    self.utf = [[UITextField alloc] init];
    [self.utf addTarget:self action:@selector(utfOnEdit:) forControlEvents:UIControlEventEditingChanged];
    self.utf.textColor = [UIColor whiteColor];
    
    self.labName = [UILabel labelWithText:@"" textColor:[UIColor whiteColor] fontSize:17.0f];
    self.iconImgView = [[UIImageView alloc] init];
    
    self.autnBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.autnBtn addTarget:self action:@selector(btnOnClick:) forControlEvents:UIControlEventTouchUpInside];
    self.autnBtn.tag = BtnOnClickActionType_idAuthAction;
    self.autnBtn.titleLabel.font = [UIFont systemFontOfSize:13.0f];
    
    UIView *botLine = [[UIView alloc] init];
    botLine.backgroundColor = [UIColor whiteColor];
    self.botLine = botLine;
    
    UIView *leftLine = [[UIView alloc] init];
    leftLine.backgroundColor = [UIColor whiteColor];
    self.leftLine = leftLine;
    
    [self addSubview:self.labName];
    [self addSubview:self.iconImgView];
    [self addSubview:self.headImgView];
    [self addSubview:self.utf];
    [self addSubview:self.autnBtn];
    [self addSubview:botLine];
    [self addSubview:leftLine];
    [self addSubview:btn];
    
    [self.headImgView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(self).offset(24);
//        make.centerY.equalTo(self);
//        make.width.height.equalTo(@70);
        make.edges.equalTo(self);
    }];
    
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.headImgView);
    }];
    
    [self.utf mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.headImgView.mas_right).offset(16);
        make.centerY.equalTo(self);
        make.height.equalTo(@40);
        make.right.equalTo(self).offset(-85);
    }];
    
    [self.labName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.height.centerY.equalTo(self.utf);
    }];
    
    [self.iconImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.labName.mas_right).offset(8);
        make.centerY.equalTo(self.labName);
    }];
    
    [self.autnBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).offset(-24);
        make.centerY.equalTo(self);
        make.height.equalTo(@30);
    }];
    
    [botLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.utf.mas_bottom);
        make.left.right.equalTo(self.utf);
        make.height.equalTo(@1);
    }];
    
    [leftLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.utf.mas_right);
        make.centerY.equalTo(self);
        make.width.equalTo(@0.7);
        make.height.equalTo(@16);
    }];
}

- (void)setEpModel:(EPModel *)epModel{
    _epModel = epModel;
    [self.headImgView sd_setImageWithURL:[NSURL URLWithString:epModel.profile_url] placeholderImage:[UIHelper getDefaultHead]];
    
//    self.utf.text = epModel.true_name.length ? epModel.true_name : @"";
//    self.labName.text = epModel.true_name.length ? epModel.true_name : @"";
//    
//    self.autnBtn.enabled = NO;
//    self.autnBtn.hidden = NO;
//    self.utf.userInteractionEnabled = YES;
//    self.labName.hidden = YES;
//    self.iconImgView.hidden = YES;
//    self.botLine.hidden = NO;
//    self.leftLine.hidden = NO;
//    
//    if (epModel.id_card_verify_status.integerValue == 1 || epModel.id_card_verify_status.integerValue == 4) {
//        [self.autnBtn setTitle:@"未认证>" forState:UIControlStateNormal];
//        [self.autnBtn setEnabled:YES];
//    }else if (epModel.id_card_verify_status.integerValue == 2) {
//        self.autnBtn.hidden = YES;
//        self.utf.hidden = YES;
//        self.labName.hidden = NO;
//        self.iconImgView.image = [UIImage imageNamed:@"info_auth_ing"];
//        self.botLine.hidden = YES;
//        self.leftLine.hidden = YES;
//        self.iconImgView.hidden = NO;
//    }else if (epModel.id_card_verify_status.integerValue == 3) {
//        self.autnBtn.hidden = YES;
//        self.utf.hidden = YES;
//        self.labName.hidden = NO;
//        self.iconImgView.hidden = NO;
//        self.botLine.hidden = YES;
//        self.leftLine.hidden = YES;
//        self.iconImgView.image = [UIImage imageNamed:@"person_service_vertify"];
//    }
    
}

- (void)utfOnEdit:(UITextField *)sender{
    _epModel.true_name = sender.text;
}

- (void)btnOnClick:(UIButton *)sender{
    if ([self.delegate respondsToSelector:@selector(editEmployerHeaderView:actionType:)]) {
        [self.delegate editEmployerHeaderView:self actionType:sender.tag];
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
