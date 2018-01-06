//
//  PersonSmcHeaderView.m
//  JKHire
//
//  Created by fire on 16/10/19.
//  Copyright © 2016年 xianshijian. All rights reserved.
//

#import "PersonSmcHeaderView.h"
#import "PersonServiceModel.h"
#import "WDConst.h"

@interface PersonSmcHeaderView ()

@property (weak, nonatomic) IBOutlet UIButton *btnTitle;
@property (weak, nonatomic) IBOutlet UILabel *labInvited;
@property (weak, nonatomic) IBOutlet UILabel *labAccepted;
@property (weak, nonatomic) IBOutlet UIButton *btnContiueInvite;

@property (weak, nonatomic) IBOutlet UIButton *btnHasInvited;
@property (weak, nonatomic) IBOutlet UIButton *btnFlatInvited;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *layoutBottomLineLeft;

- (IBAction)btnInviteOnClick:(UIButton *)sender;

@end

@implementation PersonSmcHeaderView

- (void)awakeFromNib{
    [super awakeFromNib];
    
    self.btnContiueInvite.tag = PersonSmcBtnActionType_inviteOnClick;
    
    self.btnTitle.tag = PersonSmcBtnActionType_titleOnClick;
    [self.btnTitle addTarget:self action:@selector(btnInviteOnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    self.btnHasInvited.tag = PersonSmcBtnActionType_sliderLeftBtnOnClick;
    [self.btnHasInvited addTarget:self action:@selector(btnInviteOnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.btnHasInvited setTitleColor:[UIColor XSJColor_tGrayDeepTinge] forState:UIControlStateSelected];
    [self.btnHasInvited setTitleColor:[UIColor XSJColor_tGrayDeepTransparent] forState:UIControlStateNormal];
    
    self.btnFlatInvited.tag = PersonSmcBtnActionType_sliderRightBtnOnClick;
    [self.btnFlatInvited addTarget:self action:@selector(btnInviteOnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.btnFlatInvited setTitleColor:[UIColor XSJColor_tGrayDeepTinge] forState:UIControlStateSelected];
    [self.btnFlatInvited setTitleColor:[UIColor XSJColor_tGrayDeepTransparent] forState:UIControlStateNormal];

}

- (void)setModel:(PersonServiceModel *)model{
    [self.btnTitle setTitle:model.service_title forState:UIControlStateNormal];
    self.labInvited.text = model.invite_num.description;
    self.labAccepted.text = model.accept_invite_num.description;
}

- (IBAction)btnInviteOnClick:(UIButton *)sender {
    [self makeBtnSelectedStatus:sender.tag];
    if ([self.delegate respondsToSelector:@selector(btnOnClickWithActionType:)]) {
        [self.delegate btnOnClickWithActionType:sender.tag];
    }
}

- (void)makeBtnSelectedStatus:(PersonSmcBtnActionType)actionType{
    if (actionType == PersonSmcBtnActionType_sliderLeftBtnOnClick) {
        self.btnFlatInvited.selected = NO;
        self.btnHasInvited.selected = YES;
        [self setBottomLineHorizoneOffset:0];
    }else if (actionType == PersonSmcBtnActionType_sliderRightBtnOnClick){
        self.btnHasInvited.selected = NO;
        self.btnFlatInvited.selected = YES;
        [self setBottomLineHorizoneOffset:SCREEN_WIDTH / 2];
    }
}

- (void)setBottomLineHorizoneOffset:(CGFloat)offset{
    [self layoutIfNeeded];
    [UIView animateWithDuration:1 animations:^{
        self.layoutBottomLineLeft.constant = offset;
    }];
}

@end
