//
//  VipInfoCenter_Cell.h
//  JKHire
//
//  Created by yanqb on 2017/7/31.
//  Copyright © 2017年 xianshijian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ResponseInfo.h"

@class AccountVipInfo;

@interface VipInfoCenter_Cell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *labNum1;
@property (weak, nonatomic) IBOutlet UILabel *labNum2;
@property (weak, nonatomic) IBOutlet UILabel *labNum3;
@property (weak, nonatomic) IBOutlet UILabel *labDate1;
@property (weak, nonatomic) IBOutlet UILabel *labDate2;
@property (weak, nonatomic) IBOutlet UILabel *labDate3;
@property (weak, nonatomic) IBOutlet UILabel *labRen1;
@property (weak, nonatomic) IBOutlet UILabel *labRen2;
@property (weak, nonatomic) IBOutlet UILabel *labRen3;
@property (weak, nonatomic) IBOutlet UILabel *labFen1;
@property (weak, nonatomic) IBOutlet UILabel *labFen2;
@property (weak, nonatomic) IBOutlet UILabel *labFen3;
@property (weak, nonatomic) IBOutlet UILabel *labfen;
@property (nonatomic, strong) AccountVipInfo *model;
@property (weak, nonatomic) IBOutlet UIView *xline;
@end
