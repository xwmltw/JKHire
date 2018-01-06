//
//  PersonalServiceCell.m
//  JKHire
//
//  Created by fire on 16/10/11.
//  Copyright © 2016年 xianshijian. All rights reserved.
//

#import "PersonalServiceCell.h"

@interface PersonalServiceCell ()
@property (weak, nonatomic) IBOutlet UIButton *btnLady;
@property (weak, nonatomic) IBOutlet UIButton *btnModel;
@property (weak, nonatomic) IBOutlet UIButton *btnTeacher;
@property (weak, nonatomic) IBOutlet UIButton *btnDelegate;
@property (weak, nonatomic) IBOutlet UIButton *btnActor;
@property (weak, nonatomic) IBOutlet UIButton *btnReporter;
@property (weak, nonatomic) IBOutlet UIButton *btnSales;

@end

@implementation PersonalServiceCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    [self.btnLady addTarget:self action:@selector(btnOnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.btnModel addTarget:self action:@selector(btnOnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.btnTeacher addTarget:self action:@selector(btnOnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.btnDelegate addTarget:self action:@selector(btnOnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.btnActor addTarget:self action:@selector(btnOnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.btnReporter addTarget:self action:@selector(btnOnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.btnSales addTarget:self action:@selector(btnOnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    self.btnLady.tag = ServicePersonType_Lady;
    self.btnModel.tag = ServicePersonType_model;
    self.btnTeacher.tag = ServicePersonType_teacher;
    self.btnDelegate.tag = ServicePersonType_delegate;
    self.btnActor.tag = ServicePersonType_actor;
    self.btnReporter.tag = ServicePersonType_reporter;
    self.btnSales.tag = ServicePersonType_saler;
}

- (void)btnOnClick:(UIButton *)sender{
    if ([self.delegate respondsToSelector:@selector(personalServiceCell:actionType:)]) {
        [self.delegate personalServiceCell:self actionType:sender.tag];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
