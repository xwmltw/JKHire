//
//  TeamEnableServiceCell.m
//  JKHire
//
//  Created by fire on 16/10/24.
//  Copyright © 2016年 xianshijian. All rights reserved.
//

#import "TeamEnableServiceCell.h"
#import "WDConst.h"

@interface TeamEnableServiceCell ()

- (IBAction)applyAction:(id)sender;


@end

@implementation TeamEnableServiceCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)applyAction:(id)sender {
    [MKAlertView alertWithTitle:@"提示" message:@"成为兼客服务商,请在电脑访问youpin.jianke.cc注册登录兼客雇主账号,填写提交企业信息并发布服务" cancelButtonTitle:nil confirmButtonTitle:@"确定" completion:^(UIAlertView *alertView, NSInteger buttonIndex) {
        
    }];
}
@end
