//
//  ApplyServiceCell_desc.m
//  JKHire
//
//  Created by fire on 16/11/5.
//  Copyright © 2016年 xianshijian. All rights reserved.
//

#import "ApplyServiceCell_desc.h"
#import "UIPlaceHolderTextView.h"
#import "EPModel.h"

@interface ApplyServiceCell_desc ()

@property (nonatomic, weak) UIPlaceHolderTextView *textView;
@property (nonatomic, strong) EPModel *epModel;

@end

@implementation ApplyServiceCell_desc

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        UIPlaceHolderTextView *textView = [[UIPlaceHolderTextView alloc] init];
        textView.font = [UIFont systemFontOfSize:17.0f];
        textView.backgroundColor = [UIColor XSJColor_newWhite];
        self.textView = textView;
        
        UIView *view = [[UIView alloc]init];
        view.backgroundColor = MKCOLOR_RGB(233, 233, 233);
        [self.contentView addSubview:view];
        
        [self.contentView addSubview:textView];
        [textView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.equalTo(self.contentView);
            make.left.equalTo(self.contentView).offset(13);
            make.right.equalTo(self.contentView).offset(-16);
        }];
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).offset(16);
            make.right.equalTo(self.contentView).offset(-16);
            make.bottom.equalTo(self.contentView.mas_bottom).offset(1);
            make.height.equalTo(@0.5);
        }];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

- (void)setPlaceHolder:(NSString *)placeHolder{
    _placeHolder = placeHolder;
    self.textView.placeholder = placeHolder;
}

- (void)setMaxLength:(NSInteger)maxLength{
    _maxLength = maxLength;
    self.textView.maxLength = maxLength;
}

- (void)setEpModel:(EPModel *)epModel cellType:(ApplySerciceCellType)cellType{
    _epModel = epModel;
    switch (cellType) {
        case ApplySerciceCellType_summary:{
            self.textView.text = epModel.service_desc.length ? epModel.service_desc : @"";
            self.textView.block = ^(NSString *result){
                epModel.service_desc = result;
            };
        }
            break;
        case ApplySerciceCellType_commanySummary:{
            self.textView.placeholderColor = MKCOLOR_RGB(184, 192, 199);
                self.textView.font = [UIFont systemFontOfSize:17.0f];
            self.textView.text = epModel.desc.length ? epModel.desc : @"";
            self.textView.block = ^(NSString *result){
                epModel.desc = result;
            };
        }
        case ApplySerciceCellType_industryDesc:{
            
            
            self.textView.placeholderColor = MKCOLOR_RGB(184, 192, 199);
            self.textView.font = [UIFont systemFontOfSize:17.0f];
            self.textView.text = epModel.industry_desc.length ? epModel.industry_desc : @"";
            self.textView.block = ^(NSString *result){
                epModel.industry_desc = result;
                
            };
        }

        default:
            break;
    }
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
