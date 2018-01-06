//
//  HireServiceIntro_Cell.m
//  JKHire
//
//  Created by yanqb on 2017/3/21.
//  Copyright © 2017年 xianshijian. All rights reserved.
//

#import "HireServiceIntro_Cell.h"
#import "WDConst.h"

@interface HireServiceIntro_Cell ()

@property (weak, nonatomic) IBOutlet UILabel *labTitle;
@property (weak, nonatomic) IBOutlet UILabel *labSubTitle;
@property (weak, nonatomic) IBOutlet UILabel *labDes;
@property (weak, nonatomic) IBOutlet UIImageView *imgDes;


@end

@implementation HireServiceIntro_Cell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    [self.labDes setCornerValue:2.0f];
}

- (void)setIndexPath:(NSIndexPath *)indexPath{
    _indexPath = indexPath;
    switch (indexPath.section) {
        case 0:{
            self.labTitle.text = @"VIP会员";
            self.labSubTitle.text = @"会员专属岗位曝光区+会员岗位特殊标识+免费兼职推广工具+专人服务";
            self.labDes.text = @" 招聘效率提升90% ";
            self.imgDes.image = [UIImage imageNamed:@"v320_hire_icon_1"];
        }
            break;
        case 1:{
            self.labTitle.text = @"付费推广";
            self.labSubTitle.text = @"刷新、置顶、推送推广";
            self.labDes.text = @" 岗位曝光量提升2-5倍! ";
            self.imgDes.image = [UIImage imageNamed:@"v320_hire_icon_2"];
        }
            break;
        case 2:{
            self.labTitle.text = @"在招岗位数";
            self.labSubTitle.text = @"更多在招岗位数";
            self.labDes.text = @" 同时进行多个岗位招聘! ";
            self.imgDes.image = [UIImage imageNamed:@"v320_hire_icon_3"];
        }
            break;
        default:
            break;
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
