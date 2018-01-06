//
//  PostJobSuccess_Cell1.h
//  JKHire
//
//  Created by yanqb on 2017/5/31.
//  Copyright © 2017年 xianshijian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyEnum.h"
#import "ParamModel.h"
typedef NS_ENUM(NSInteger, FromSourceType) {
    FromSourceType_postSuccess,
    FromSourceType_findTalent,
    FromSourceType_myTalent,
    FromSourceType_myTalenForCollect,
};

@class JKModel,PostJobSuccess_Cell1;
@protocol PostJobSuccess_Cell1Delegate <NSObject>

- (void)PostJobSuccess_Cell1:(PostJobSuccess_Cell1 *)cell actionType:(BtnOnClickActionType)actionType model:(JKModel *)model;

@end

@interface PostJobSuccess_Cell1 : UITableViewCell

@property (nonatomic, weak) id<PostJobSuccess_Cell1Delegate> delegate;
@property (nonatomic, assign) FromSourceType sourceType;
@property (nonatomic, strong) JKModel *model;

- (void)setSelctModel:(QueryTalentParam *)selctModel andArea:(NSString *)area andJob:(NSString *)job;
@end
