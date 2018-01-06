//
//  VipPacket_Cell.m
//  JKHire
//
//  Created by yanqb on 2017/5/9.
//  Copyright © 2017年 xianshijian. All rights reserved.
//

#import "VipPacket_Cell.h"
#import "ResponseInfo.h"

@interface VipPacket_Cell ()

@property (weak, nonatomic) IBOutlet UILabel *labTitle;
@property (weak, nonatomic) IBOutlet UILabel *labSubTitle;
@property (weak, nonatomic) IBOutlet UIButton *btnIcon;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *layoutLabSubTitleRight;
@property (weak, nonatomic) IBOutlet UIView *viewContaint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *layoutViewHeight;
@property (weak, nonatomic) IBOutlet UILabel *lab1;
@property (weak, nonatomic) IBOutlet UILabel *lab2;
@property (weak, nonatomic) IBOutlet UILabel *lab3;
@property (weak, nonatomic) IBOutlet UILabel *lab4;
@property (weak, nonatomic) IBOutlet UILabel *lab5;
@property (weak, nonatomic) IBOutlet UILabel *lab6;

@property (nonatomic, copy) NSArray *labArr;


@end

@implementation VipPacket_Cell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.labArr = @[self.lab1, self.lab2, self.lab3, self.lab4, self.lab5, self.lab6];
    self.viewContaint.clipsToBounds = YES;
    self.clipsToBounds = YES;
}

- (void)setModel:(PackageItem *)model indexPath:(NSIndexPath *)indexPath{

    self.layoutLabSubTitleRight.constant = 32;
    self.btnIcon.hidden = NO;
    PackageItem *item = model;
    self.labTitle.text = [NSString stringWithFormat:@"%@", item.package_item_desc];
    if (item.package_item_value.integerValue) {
        self.labSubTitle.hidden = NO;
        NSString *str = [NSString stringWithFormat:@"价值¥%.2f", item.package_item_value.integerValue * 0.01];
        str = [str stringByReplacingOccurrencesOfString:@".00" withString:@""];
        self.labSubTitle.text = str;
    }else{
        self.labSubTitle.hidden = YES;
    }
    if (indexPath.row >= 8) {
        self.layoutLabSubTitleRight.constant = 16;
        self.btnIcon.hidden = YES;
    }
    
    self.layoutViewHeight.constant = 0;
    [model.package_item_privilege_desc enumerateObjectsUsingBlock:^(NSString*  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (idx < self.labArr.count) {
            UILabel *lab = [self.labArr objectAtIndex:idx];
            lab.text = obj;
            self.layoutViewHeight.constant = 32 + 37 * (idx + 1);
        }
    }];
    
    model.cellHeight = 36 + self.layoutViewHeight.constant;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
