//
//  PostJobSuccessCell.m
//  JKHire
//
//  Created by yanqb on 2017/2/9.
//  Copyright © 2017年 xianshijian. All rights reserved.
//

#import "PostJobSuccessCell.h"
#import "UserData.h"

@interface PostJobSuccessCell ()

@property (weak, nonatomic) IBOutlet UILabel *labTitle;
@property (weak, nonatomic) IBOutlet UILabel *labSubTitle;


@end

@implementation PostJobSuccessCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)setCellType:(PostJobSuccessCellType)cellType{
    _cellType = cellType;
    switch (cellType) {
        case PostJobSuccessCellType_ParttimePromotion:{ //兼职推广
            self.labTitle.text = @"兼职推广";
            self.labSubTitle.text = @"增加曝光,提升招聘效率";
        }
            break;
        case PostJobSuccessCellType_PostManagement:{    //岗位管理
            self.labTitle.text = @"岗位管理";
            self.labSubTitle.text = @"第一时间 关注岗位动态";
        }
            break;
        case PostJobSuccessCellType_PayMargin:{ //缴纳保证金
            self.labTitle.text = @"缴纳保证金";
            self.labSubTitle.text = @"点亮「工资保障」标识，提高招聘转化率";
        }
            break;
        case PostJobSuccessCellType_Certification:{ //企业认证
            self.labTitle.text = @"企业认证";
            self.labSubTitle.text = @"点亮「企业认证」标识，提高信用度";
        }
            break;
        case PostJobSuccessCellType_payForVIP:{ //获取更多权限
            self.labTitle.text = @"获取更多岗位权限";
            self.labSubTitle.text = @"升级VIP、购买在招岗位数";
        }
            break;
        case PostJobSuccessCellType_VIPPostManage:{ //VIP无权限
            self.labTitle.text = @"兼职管理";
            self.labSubTitle.text = [NSString stringWithFormat:@"关闭%@地区其他岗位，并提交审核", [UserData sharedInstance].city.name];
        }
            break;
        case PostJobSuccessCellType_suggestTalent:{ //人才匹配
            self.labTitle.text = @"人才匹配";
            self.labSubTitle.text = @"主动出击，直接联系求职者，招聘效果棒棒哒";
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
