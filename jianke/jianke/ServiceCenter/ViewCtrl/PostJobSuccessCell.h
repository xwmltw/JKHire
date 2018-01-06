//
//  PostJobSuccessCell.h
//  JKHire
//
//  Created by yanqb on 2017/2/9.
//  Copyright © 2017年 xianshijian. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, PostJobSuccessCellType) {
    PostJobSuccessCellType_ParttimePromotion,
    PostJobSuccessCellType_PostManagement,
    PostJobSuccessCellType_PayMargin,
    PostJobSuccessCellType_Certification,
    PostJobSuccessCellType_payForVIP,
    PostJobSuccessCellType_VIPPostManage,   //VIP无权限兼职管理
    PostJobSuccessCellType_suggestTalent,   //人才匹配
};

@interface PostJobSuccessCell : UITableViewCell

@property (nonatomic, assign) PostJobSuccessCellType cellType;

@end
