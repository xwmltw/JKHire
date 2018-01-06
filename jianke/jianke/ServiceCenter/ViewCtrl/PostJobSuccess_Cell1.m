//
//  PostJobSuccess_Cell1.m
//  JKHire
//
//  Created by yanqb on 2017/5/31.
//  Copyright © 2017年 xianshijian. All rights reserved.
//

#import "PostJobSuccess_Cell1.h"
#import "WDConst.h"
#import "NSString+XZExtension.h"

@interface PostJobSuccess_Cell1 ()
{
    NSString *_city;

}
@property (weak, nonatomic) IBOutlet UIImageView *imgProfile;
@property (weak, nonatomic) IBOutlet UILabel *labName;
@property (weak, nonatomic) IBOutlet UILabel *labInfo;
@property (weak, nonatomic) IBOutlet UILabel *labCompete;
@property (weak, nonatomic) IBOutlet UILabel *labLastOn;
@property (weak, nonatomic) IBOutlet UIButton *btnMsg;
@property (weak, nonatomic) IBOutlet UILabel *labLeftJobType;
@property (weak, nonatomic) IBOutlet UIButton *btnCall;
@property (weak, nonatomic) IBOutlet UILabel *labJobType;
@property (weak, nonatomic) IBOutlet UILabel *labArea;
@property (weak, nonatomic) IBOutlet UIButton *btnCollect;
@property (weak, nonatomic) IBOutlet UIImageView *authenticationImage;


@end

@implementation PostJobSuccess_Cell1

- (void)awakeFromNib {
    [super awakeFromNib];
    self.clipsToBounds = YES;
    [self.imgProfile setCornerValue:30.0f];
    [self.btnCollect setImage:[UIImage imageNamed:@"v3_job_collect_blue_1"] forState:UIControlStateSelected];
    self.btnMsg.tag = BtnOnClickActionType_sendMsg;
    self.btnCall.tag = BtnOnClickActionType_makeCall;
    self.btnCollect.tag = BtnOnClickActionType_collectJK;
    [self.btnMsg addTarget:self action:@selector(btnOnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.btnCall addTarget:self action:@selector(btnOnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.btnCollect addTarget:self action:@selector(btnOnClick:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)setSourceType:(FromSourceType)sourceType{
    _sourceType = sourceType;
    
    self.btnMsg.hidden = NO;
    self.btnCall.hidden = NO;
    self.labArea.hidden = NO;
    self.labLeftJobType.hidden = NO;
    self.labJobType.hidden = NO;
    self.btnCollect.hidden = YES;
   
    
    switch (sourceType) {
        case FromSourceType_postSuccess:{
            self.btnMsg.hidden = YES;
            self.btnCall.hidden = YES;
            self.labArea.hidden = YES;
            self.labLeftJobType.hidden = YES;
            self.labJobType.hidden = YES;
            
        }
            break;
        case FromSourceType_findTalent:{
            self.btnMsg.hidden = YES;
            self.btnCall.hidden = YES;
        }
            break;
        case FromSourceType_myTalenForCollect:{
            self.btnCollect.hidden = NO;
            self.btnCall.hidden = YES;
            self.btnMsg.hidden = YES;
        }
            break;
        default:
            break;
    }
}
- (NSMutableAttributedString *)getStringColor:(NSString *)strA andString:(NSString *)strB{
    
    NSMutableAttributedString *attributeString = [[NSMutableAttributedString alloc]initWithString:strA];
    NSRange range = [strA rangeOfString:strB];
    [attributeString addAttribute:NSForegroundColorAttributeName value:MKCOLOR_RGB(0, 188, 212) range:range];
    
    
    return attributeString;
}
- (void)setSelctModel:(QueryTalentParam *)selctModel andArea:(NSString *)area andJob:(NSString *)job{
    
    
    
    
    
    
    NSString *strSex = self.model.sex.integerValue ? @"男": @"女";
    NSString *strAge = self.model.age.description;
    NSMutableString *mutableStr = [NSMutableString string];
    
    if (strSex.length) {
        [mutableStr appendString:strSex];
    }
    if (self.model.age) {
        [mutableStr appendString:[NSString stringWithFormat:@"  |  %@岁", self.model.age.description]];
    }
    if (!_model.subscribe_address_area_str.length) {
        [mutableStr appendString:[NSString stringWithFormat:@"  |  %@",_model.city_name]];
    }

    
    if (selctModel.job_classify_id) {
        if (job.length) {
          
            NSDictionary *dic = _model.subscribe_job_info;
            NSMutableArray *arr = dic[@"subscribe_job_classify_arr"];
            
            if (arr.count>7) {
                
                NSMutableString *str2 = [NSMutableString string];
                str2 = [NSMutableString stringWithFormat:@"%@", job];
                NSMutableString *str = [NSMutableString string];
                for (int i=0; arr.count>i; i++) {
                    
                    [str appendString:[NSString stringWithFormat:@",%@",arr[i][@"name"]]];
                }
                
                NSString *str3 = [str stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"%@,",job] withString:@""];
                [str2 appendString:str3];
                self.labJobType.attributedText = [self getStringColor:str2 andString:job];
                
            }else{
                self.labJobType.attributedText = [self getStringColor:self.model.subscribe_job_classify_str andString:job];
            
            }

            
            
        }
        

    }else {
        
        [self.labJobType setTextColor:MKCOLOR_RGBA(34, 58, 80, 0.32)];
    }
    
    
    
    if (selctModel.sex && !selctModel.age_limit) {
        [self.labInfo setTextColor:MKCOLOR_RGBA(34, 58, 80, 0.32)];
        self.labInfo.attributedText = [self getStringColor:mutableStr andString:strSex];
      
    }else if(selctModel.sex && selctModel.age_limit){
        
        [self.labInfo setTextColor:MKCOLOR_RGB(0, 188, 212)];
    }else if(selctModel.age_limit && !selctModel.sex){
        [self.labInfo setTextColor:MKCOLOR_RGBA(34, 58, 80, 0.32)];
        self.labInfo.attributedText = [self getStringColor:mutableStr andString:strAge];
        
    }else{
         [self.labInfo setTextColor:MKCOLOR_RGBA(34, 58, 80, 0.32)];
    }
    if (!_model.subscribe_address_area_str.length) {
        if (_city) {
            self.labInfo.attributedText = [self getStringColor:mutableStr andString:_city];
        }
        
    }
    
   

    
    if (selctModel.address_area_id) {
        if ([self.model.subscribe_address_area_str rangeOfString:@"全"].location != NSNotFound) {
            [self.labArea setTextColor:MKCOLOR_RGB(0, 188, 212)];
        }else{
            if (area.length) {
                [self.labArea setTextColor:MKCOLOR_RGBA(34, 58, 80, 0.32)];
                self.labArea.attributedText = [self getStringColor:self.model.subscribe_address_area_str andString:area];
            }
            
        }
    }else{
        
        [self.labArea setTextColor:MKCOLOR_RGBA(34, 58, 80, 0.32)];
    }

}
- (void)setModel:(JKModel *)model{
    _model = model;
    
    
    
//    BOOL sele = model.isSelect;
    
    [self.imgProfile sd_setImageWithURL:[NSURL URLWithString:[NSString stringNoneNullFromValue:model.profile_url]] placeholderImage:[UIHelper getDefaultHeadRect]];
    self.labName.text = model.true_name.length ? model.true_name: nil;
    self.labName.textColor = model.isSelect ? [UIColor XSJColor_tGrayDeepTransparent2]: [UIColor XSJColor_tGrayDeepTinge1];
    NSString *strSex = model.sex.integerValue ? @"男": @"女";
    NSMutableString *mutableStr = [NSMutableString string];
    
    if (strSex.length) {
        [mutableStr appendString:strSex];
    }
    if (model.age) {
        [mutableStr appendString:[NSString stringWithFormat:@"  |  %@岁", model.age.description]];
    }
    if (!model.subscribe_address_area_str.length) {
        _city = model.city_name;
        [mutableStr appendString:[NSString stringWithFormat:@"  |  %@",model.city_name]];
    }
    
    self.labInfo.text = mutableStr;
    
    NSString *competeStr = [NSString stringWithFormat:@"%ld次完工", model.complete_work_num.integerValue];
    if (model.last_login_time_str.length) {
        competeStr = [competeStr stringByAppendingString:@"，"];
    }
    
    self.labCompete.text = competeStr;
    self.labLastOn.text = model.last_login_time_str.length ? [NSString stringWithFormat:@"%@", model.last_login_time_str]: @"";
    
    model.cellHeight = 76;
    
    if (self.sourceType == FromSourceType_findTalent || self.sourceType == FromSourceType_myTalent || self.sourceType == FromSourceType_myTalenForCollect) {
        if (!model.subscribe_job_classify_str.length) {
            self.labJobType.text = @"暂无意向岗位";
            model.cellHeight += (17 + 12);
        }else{
            self.labJobType.text = model.subscribe_job_classify_str;
            CGFloat height = [self.labJobType contentSizeWithWidth:SCREEN_WIDTH - 84].height;
            height = (height >= 34) ? 34 : height;
            model.cellHeight += (height + 12);
        }
//        if (!model.subscribe_address_area_str.length) {
//            self.labArea.text = @"暂无意向区域";
//            model.cellHeight += (17 + 12 + 8);
//        }else
//        {
            self.labArea.text = model.subscribe_address_area_str;
            CGFloat height = [self.labArea contentSizeWithWidth:SCREEN_WIDTH - 84].height;
            height = (height >= 34) ? 34 : height;
            model.cellHeight += (height + 12 + 8);
//        }
    }
    self.authenticationImage.hidden = (model.id_card_verify_status.integerValue != 3);
    
    self.btnCollect.selected = YES;
}

- (void)btnOnClick:(UIButton *)sender{
    if ([self.delegate respondsToSelector:@selector(PostJobSuccess_Cell1:actionType:model:)]) {
        [self.delegate PostJobSuccess_Cell1:self actionType:sender.tag model:self.model];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
