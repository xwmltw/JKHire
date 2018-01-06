//
//  TitleColletionCell.m
//  JKHire
//
//  Created by fire on 16/11/2.
//  Copyright © 2016年 xianshijian. All rights reserved.
//

#import "TitleColletionCell.h"
#import "WDConst.h"

@interface TitleColletionCell ()

@property (weak, nonatomic) IBOutlet UILabel *labTitle;

@end

@implementation TitleColletionCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.backgroundColor = [UIColor XSJColor_newWhite];
}

- (void)setMenuBtnModel:(MenuBtnModel *)menuBtnModel{
    _menuBtnModel = menuBtnModel;
    self.labTitle.text = menuBtnModel.entry_title;
    if (menuBtnModel.isSelected) {
        self.labTitle.textColor = [UIColor XSJColor_tGrayDeepTinge];
    }else{
        self.labTitle.textColor = [UIColor XSJColor_tGrayDeepTransparent2];
    }
}

@end
