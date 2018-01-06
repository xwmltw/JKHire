//
//  PostTeamCell_Money.m
//  JKHire
//
//  Created by fire on 16/10/14.
//  Copyright © 2016年 xianshijian. All rights reserved.
//

#import "PostTeamCell_Money.h"
#import "PostJobModel.h"

@interface PostTeamCell_Money (){
    PostJobModel *_model;
}

@property (weak, nonatomic) IBOutlet UITextField *utf;
- (IBAction)utfEditingChage:(UITextField *)sender;


@end

@implementation PostTeamCell_Money

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setModel:(PostJobModel *)model{
    _model = model;
    if (model.budget_amount) {
        NSString *moneyStr = [NSString stringWithFormat:@"%.1f", model.budget_amount.floatValue];
        self.utf.text = [moneyStr stringByReplacingOccurrencesOfString:@".0" withString:@""];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)utfEditingChage:(UITextField *)sender {
    [self constraintMoneyInputWithLength:6 textField:sender];
    _model.budget_amount = @(sender.text.floatValue);
}

/** 约束薪资输入 */
- (void)constraintMoneyInputWithLength:(NSInteger)length textField:(UITextField *)sender{
    NSRange range = [sender.text rangeOfString:@"."];
    if (range.location != NSNotFound) { // 有小数点
        if (sender.text.length == 1) {
            sender.text = @"";
            return;
        }
        if (sender.text.length > length + 2) {
            sender.text = [sender.text substringToIndex:length + 2];
        }
        if (range.location < sender.text.length - 1) {
            sender.text = [sender.text substringToIndex:range.location + 2];
        }
        sender.text = [sender.text stringByReplacingOccurrencesOfString:@".." withString:@"."];
        if ([sender.text rangeOfString:@"."].location == 0) {
            sender.text = [sender.text stringByReplacingOccurrencesOfString:@"." withString:@""];
        }
    } else { // 没有小数点
        if (sender.text.length > length) {
            sender.text = [sender.text substringToIndex:length];
        }
    }
}

@end
