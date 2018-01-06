//
//  PostJobCell_des.m
//  JKHire
//
//  Created by xuzhi on 16/10/12.
//  Copyright © 2016年 xianshijian. All rights reserved.
//

#import "PostJobCell_des.h"
#import "UIPlaceHolderTextView.h"
#import "PostJobModel.h"

@interface PostJobCell_des (){
    PostJobModel *_postJobModel;
}
@property (weak, nonatomic) IBOutlet UIPlaceHolderTextView *textView;

@end

@implementation PostJobCell_des

- (void)awakeFromNib {
    [super awakeFromNib];
    self.textView.placeholder = @"输入您具体的要求（详细的工作描述能大幅提高服务商的接单几率哦，500字以内）";
    self.textView.backgroundColor = [UIColor XSJColor_newWhite];
    self.textView.maxLength = 500;
    WEAKSELF
    self.textView.block = ^(NSString *text){
        _postJobModel.service_desc = text;
    };
}

- (void)setModel:(PostJobModel *)model{
    _postJobModel = model;
    if (model.service_desc && model.service_desc.length > 0) {
        self.textView.text = model.service_desc;
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
