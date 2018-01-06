//
//  VipInfoCenter_CellNil.h
//  JKHire
//
//  Created by yanqb on 2017/8/8.
//  Copyright © 2017年 xianshijian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ResponseInfo.h"
@interface VipInfoCenter_CellNil : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *labNum1;
@property (weak, nonatomic) IBOutlet UILabel *labNum2;
@property (weak, nonatomic) IBOutlet UILabel *labNum3;
@property (weak, nonatomic) IBOutlet UILabel *labDate1;
@property (weak, nonatomic) IBOutlet UILabel *labDate2;
@property (weak, nonatomic) IBOutlet UILabel *labDate3;
@property (weak, nonatomic) IBOutlet UILabel *labRen1;
@property (weak, nonatomic) IBOutlet UILabel *labRen2;
@property (weak, nonatomic) IBOutlet UILabel *labRen3;
@property (nonatomic, strong) AccountVipInfo *model;
@end
