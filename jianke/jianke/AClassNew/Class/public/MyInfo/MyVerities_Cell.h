//
//  MyVerities_Cell.h
//  JKHire
//
//  Created by yanqb on 2017/3/31.
//  Copyright © 2017年 xianshijian. All rights reserved.
//

#import <UIKit/UIKit.h>

#define IMGOH 182.0f
#define IMGOW 351.0f
#define IMGMarginX 12.0f

typedef NS_ENUM(NSInteger, MyVeritiesCellType) {
    MyVeritiesCellType_idCardVerity,    //实名认证
    MyVeritiesCellType_enterpriseVerity,   //企业认证
};

@class LatestVerifyInfo;
@interface MyVerities_Cell : UITableViewCell

@property (nonatomic, assign) MyVeritiesCellType cellType;
@property (nonatomic, assign) LatestVerifyInfo *epInfo;

@end
