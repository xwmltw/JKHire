//
//  VipInfoCenter_Cell2.m
//  JKHire
//
//  Created by yanqb on 2017/5/15.
//  Copyright © 2017年 xianshijian. All rights reserved.
//

#import "VipInfoCenter_Cell2.h"
#import "ResponseInfo.h"
#import "WDConst.h"

@interface VipInfoCenter_Cell2 ()

@property (weak, nonatomic) IBOutlet UILabel *labRefresh;
@property (weak, nonatomic) IBOutlet UILabel *labStick;
@property (weak, nonatomic) IBOutlet UILabel *labPush;
@property (weak, nonatomic) IBOutlet UILabel *labLeftRefresh;
@property (weak, nonatomic) IBOutlet UILabel *labDeadRefresh;
@property (weak, nonatomic) IBOutlet UILabel *labLeftStick;
@property (weak, nonatomic) IBOutlet UILabel *labDeadStick;
@property (weak, nonatomic) IBOutlet UILabel *labLeftPush;
@property (weak, nonatomic) IBOutlet UILabel *labDeadPush;
@property (weak, nonatomic) IBOutlet UIView *viewRefresh;
@property (weak, nonatomic) IBOutlet UIView *viewStick;
@property (weak, nonatomic) IBOutlet UIView *viewPush;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *laboutRefreshViewWith;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *laboutStickViewWith;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *laboutPushViewWith;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *layoutStickViewLeft;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *layoutPushViewLeft;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *layoutRefreshViewLeft;

@end

@implementation VipInfoCenter_Cell2

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setModel:(AccountVipInfo *)model{
    _model = model;
//    EPModel *epModel = [[UserData sharedInstance] getEpModelFromHave];
//    self.labEpName.text = epModel.enterprise_name.length ? epModel.enterprise_name : nil;
//    self.imgIcon.image = [UIImage imageNamed:[epModel getImgOfAccountVipType]];
    
    CGFloat width = (SCREEN_WIDTH - 16) / 3;
    
    self.viewRefresh.hidden = NO;
    self.viewStick.hidden = NO;
    self.viewPush.hidden = NO;
    self.laboutPushViewWith.constant = width;
    self.laboutStickViewWith.constant = width;
    self.laboutRefreshViewWith.constant = width;
    self.layoutPushViewLeft.constant = width * 2;
    self.layoutStickViewLeft.constant = width;
    self.layoutRefreshViewLeft.constant = 0;
    
     //只有一个视图显示(参数注意，第一个为left,第二个为width)
    void (^onlyViewBlock)(NSLayoutConstraint *layout, NSLayoutConstraint *layoutWidth) = ^(NSLayoutConstraint *layout, NSLayoutConstraint *layoutWidth){
        CGFloat width = SCREEN_WIDTH - 16;
        layout.constant = 0;
        layoutWidth.constant = width;
    };
    
     //只有刷新和个视图显示
    void (^twoViewBlock)(NSLayoutConstraint *layout1, NSLayoutConstraint *layout1Width, NSLayoutConstraint *layout2, NSLayoutConstraint *layout2Width) = ^(NSLayoutConstraint *layout1, NSLayoutConstraint *layout1Width, NSLayoutConstraint *layout2, NSLayoutConstraint *layout2Width){
        CGFloat width = (SCREEN_WIDTH - 16) / 2;
        layout1.constant = 0;
        layout1Width.constant = width;
        layout2.constant = width;
        layout2Width.constant = width;
    };
    
    BOOL isHasSoonExpired = NO;
    if (model.national_general_vip_refresh_privilege && model.national_general_vip_refresh_privilege.all_refresh_num.integerValue) {
        
        if (model.national_general_vip_top_privilege && model.national_general_vip_top_privilege.all_top_num.integerValue) {
            
            if (model.national_general_vip_push_privilege && model.national_general_vip_push_privilege.all_push_num.integerValue) {
                
            }else{
                self.viewPush.hidden = YES;
                twoViewBlock(self.layoutPushViewLeft, self.laboutRefreshViewWith, self.layoutStickViewLeft, self.laboutStickViewWith);
            }
            
        }else{
            self.viewStick.hidden = YES;
            if (model.national_general_vip_push_privilege && model.national_general_vip_push_privilege.all_push_num.integerValue) {
                twoViewBlock(self.layoutPushViewLeft, self.laboutRefreshViewWith, self.layoutPushViewLeft, self.laboutPushViewWith);
            }else{
                self.viewPush.hidden = YES;
                onlyViewBlock(self.layoutRefreshViewLeft, self.laboutRefreshViewWith);
            }
            
        }
    }else{
        self.viewRefresh.hidden = YES;
        if (model.national_general_vip_top_privilege && model.national_general_vip_top_privilege.all_top_num.integerValue) {
            
            if (model.national_general_vip_push_privilege && model.national_general_vip_push_privilege.all_push_num.integerValue) {
                twoViewBlock(self.layoutStickViewLeft, self.laboutStickViewWith, self.layoutPushViewLeft, self.laboutPushViewWith);
            }else{
                self.viewPush.hidden = YES;
                onlyViewBlock(self.layoutStickViewLeft, self.laboutStickViewWith);
            }
            
        }else{
            self.viewStick.hidden = YES;
            if (model.national_general_vip_push_privilege && model.national_general_vip_push_privilege.all_push_num.integerValue) {
                onlyViewBlock(self.layoutPushViewLeft, self.laboutPushViewWith);
            }
        }
    }
    self.labRefresh.text = [NSString stringWithFormat:@"刷新%ld次", model.national_general_vip_refresh_privilege.all_refresh_num.integerValue];
    self.labLeftRefresh.text = [NSString stringWithFormat:@"%ld", model.national_general_vip_refresh_privilege.left_can_refresh_num.integerValue];
    if (model.national_general_vip_refresh_privilege.soon_expired_refresh_num.integerValue) {
        self.labDeadRefresh.hidden = NO;
        self.labDeadRefresh.text = [NSString stringWithFormat:@"有%ld次即将到期", model.national_general_vip_refresh_privilege.soon_expired_refresh_num.integerValue];
        isHasSoonExpired = YES;
    }else{
        self.labDeadRefresh.hidden = YES;
    }
    
    self.labStick.text = [NSString stringWithFormat:@"置顶%ld天", model.national_general_vip_top_privilege.all_top_num.integerValue];
    self.labLeftStick.text = model.national_general_vip_top_privilege.left_can_top_num.description;
    if (model.national_general_vip_top_privilege.soon_expired_top_num.integerValue) {
        self.labDeadStick.hidden = NO;
        self.labDeadStick.text = [NSString stringWithFormat:@"有%ld天即将过期", model.national_general_vip_top_privilege.soon_expired_top_num.integerValue];
        isHasSoonExpired = YES;
    }else{
        self.labDeadStick.hidden = YES;
    }
    
    self.labPush.text = [NSString stringWithFormat:@"推送%ld人", model.national_general_vip_push_privilege.all_push_num.integerValue];
    self.labLeftPush.text = model.national_general_vip_push_privilege.left_can_push_num.description;
    if (model.national_general_vip_push_privilege.soon_expired_push_num.integerValue) {
        self.labDeadPush.hidden = NO;
        self.labDeadPush.text = [NSString stringWithFormat:@"有%ld人数即将到期", model.national_general_vip_push_privilege.soon_expired_push_num.integerValue];
        isHasSoonExpired = YES;
    }else{
        self.labDeadPush.hidden = YES;
    }
    model.cellHeight = isHasSoonExpired ? 180.0f : 141.0f ;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
