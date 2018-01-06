//
//  PersonalListCell.m
//  JKHire
//
//  Created by fire on 16/10/12.
//  Copyright © 2016年 xianshijian. All rights reserved.
//

#import "PersonalListCell.h"
#import "ResponseInfo.h"
#import "UIImageView+WebCache.h"
#import "WDConst.h"
#import "XZImgPreviewView.h"

@interface PersonalListCell (){
    NSIndexPath *_indexPath;
}


@property (weak, nonatomic) IBOutlet UILabel *labName;
@property (weak, nonatomic) IBOutlet UILabel *labStatus;
@property (weak, nonatomic) IBOutlet UILabel *labLeftTag;
@property (weak, nonatomic) IBOutlet UILabel *labRightTag;
@property (weak, nonatomic) IBOutlet UILabel *labLeftStu;
@property (weak, nonatomic) IBOutlet UILabel *labRightStu;
@property (weak, nonatomic) IBOutlet UILabel *labLeftColloge;
@property (weak, nonatomic) IBOutlet UILabel *labRightColloge;
@property (weak, nonatomic) IBOutlet UILabel *labLeftSalary;
@property (weak, nonatomic) IBOutlet UILabel *labRightSalary;
@property (weak, nonatomic) IBOutlet UIButton *btnInvite;
@property (weak, nonatomic) IBOutlet UIImageView *imgStatus;
@property (weak, nonatomic) IBOutlet UIView *bottomLine;

//图片
@property (weak, nonatomic) IBOutlet UIImageView *imgview1;
@property (weak, nonatomic) IBOutlet UIImageView *imgview2;
@property (weak, nonatomic) IBOutlet UIImageView *imgview3;
@property (weak, nonatomic) IBOutlet UIButton *imgBtn1;
@property (weak, nonatomic) IBOutlet UIButton *imgBtn2;
@property (weak, nonatomic) IBOutlet UIButton *imgBtn3;

@property (nonatomic, copy) NSArray *imgArr;
@property (nonatomic, copy) NSArray<UIButton *> *btnArr;


- (IBAction)btnInviteOnClick:(UIButton *)sender;

@end

@implementation PersonalListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self.btnInvite setCornerValue:2.0f];
    [self.btnInvite setBorderWidth:1.0f andColor:[UIColor XSJColor_tGrayDeepTinge]];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.imgArr = @[self.imgview1, self.imgview2, self.imgview3];
    self.btnArr = @[self.imgBtn1, self.imgBtn2, self.imgBtn3];
    self.imgBtn1.tag = 0;
    self.imgBtn2.tag = 1;
    self.imgBtn3.tag = 2;
    [self.imgBtn1 addTarget:self action:@selector(btnonlick:) forControlEvents:UIControlEventTouchUpInside];
    [self.imgBtn2 addTarget:self action:@selector(btnonlick:) forControlEvents:UIControlEventTouchUpInside];
    [self.imgBtn3 addTarget:self action:@selector(btnonlick:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)setModel:(ServicePersonalStuModel *)model cellType:(ServicePersonType)servicePersonType atIndexPath:(NSIndexPath *)indexPath{
    
    _indexPath = indexPath;
    model.cellHeight = 53 + 8;
    
    self.labName.textColor = (model.sex.integerValue == 1) ? [UIColor XSJColor_base] : [UIColor XSJColor_middelRed] ;
    self.labName.text = model.true_name;
    if (model.desc_after_true_name.length) {
        self.labStatus.hidden = NO;
        self.labStatus.text = [NSString stringWithFormat:@"/%@", model.desc_after_true_name];
    }else{
        self.labStatus.hidden = YES;
    }
    
    self.labLeftTag.hidden = YES;
    self.labRightTag.hidden = YES;
    self.labLeftStu.hidden = YES;
    self.labRightStu.hidden = YES;
    self.labLeftColloge.hidden = YES;
    self.labRightColloge.hidden = YES;
    self.labLeftSalary.hidden = YES;
    self.labRightSalary.hidden = YES;

    self.imgStatus.hidden = !(model.id_card_verify_status.integerValue == 3);
    
    if (model.is_be_invited.integerValue == 1) {
        NSString *title = (model.invite_type.integerValue == 1) ? @"已邀约" : @"系统已邀约";
        [self.btnInvite setTitle:title forState:UIControlStateNormal];
        
    }else{
        [self.btnInvite setTitle:@"邀约TA" forState:UIControlStateNormal];
    }
    
    for (NSInteger index = 0; index < model.service_personal_info_list.count; index++) {
        if (index == 0) {
            self.labLeftTag.hidden = NO;
            self.labRightTag.hidden = NO;
            self.labLeftTag.text = [NSString stringWithFormat:@"%@:", [model.service_personal_info_list[index] objectForKey:@"key"]];
            self.labRightTag.text = [model.service_personal_info_list[index] objectForKey:@"value"];
            model.cellHeight += [self.labRightTag contentSizeWithWidth:SCREEN_WIDTH - 98].height + 2;
        }else if (index == 1){
            self.labLeftStu.hidden = NO;
            self.labRightStu.hidden = NO;
            self.labLeftStu.text = [NSString stringWithFormat:@"%@:", [model.service_personal_info_list[index] objectForKey:@"key"]];
            self.labRightStu.text = [model.service_personal_info_list[index] objectForKey:@"value"];
            model.cellHeight += [self.labRightStu contentSizeWithWidth:SCREEN_WIDTH - 98].height +2;
        }else if (index == 2){
            self.labLeftColloge.hidden = NO;
            self.labRightColloge.hidden = NO;
            self.labLeftColloge.text = [NSString stringWithFormat:@"%@:", [model.service_personal_info_list[index] objectForKey:@"key"]];
            self.labRightColloge.text = [model.service_personal_info_list[index] objectForKey:@"value"];
            model.cellHeight += [self.labRightColloge contentSizeWithWidth:SCREEN_WIDTH - 98].height +2;
        }else if (index == 3){
            self.labLeftSalary.hidden = NO;
            self.labRightSalary.hidden = NO;
            self.labLeftSalary.text = [NSString stringWithFormat:@"%@:", [model.service_personal_info_list[index] objectForKey:@"key"]];
            self.labRightSalary.text = [model.service_personal_info_list[index] objectForKey:@"value"];
            model.cellHeight += [self.labRightSalary contentSizeWithWidth:SCREEN_WIDTH - 98].height + 2;
        }
    }
    
    [self.imgArr enumerateObjectsUsingBlock:^(UIButton*  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj setHidden:YES];
        self.btnArr[idx].hidden = YES;
    }];
    self.bottomLine.hidden = YES;
    UIImageView *tmpImgView;
    if (model.work_photos_list.count) {
        self.bottomLine.hidden = NO;
        model.cellHeight += 15;
        for (NSInteger imgIndex = 0; imgIndex < model.work_photos_list.count; imgIndex++) {
            tmpImgView = [self.imgArr objectAtIndex:imgIndex];
            tmpImgView.hidden = NO;
            self.btnArr[imgIndex].hidden = NO;
            [tmpImgView sd_setImageWithURL:[NSURL URLWithString:[model.work_photos_list objectAtIndex:imgIndex]] placeholderImage:[UIHelper getDefaultImage]];
        }
    }
    model.cellHeight += 35;
    model.cellHeight += 14;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)btnInviteOnClick:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(personalListCellAtIndexPath:)]) {
        [self.delegate personalListCellAtIndexPath:_indexPath];
    }
}

- (IBAction)btnonlick:(UIButton *)sender {
    NSPredicate *pre = [NSPredicate predicateWithFormat:@"hidden = NO"];
    NSArray *array = [self.imgArr filteredArrayUsingPredicate:pre];
    [XZImgPreviewView showViewWithArray:array beginWithIndex:sender.tag];
}

@end
