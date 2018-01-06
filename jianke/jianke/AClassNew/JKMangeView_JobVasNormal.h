//
//  JKMangeView_JobVasNormal.h
//  JKHire
//
//  Created by yanqb on 2017/4/7.
//  Copyright © 2017年 xianshijian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyEnum.h"

@class JKMangeView_JobVasNormal;
@protocol JKMangeView_JobVasNormalDelegate <NSObject>

- (void)JKMangeView_JobVasNormal:(JKMangeView_JobVasNormal *)cell actionType:(BtnOnClickActionType)actionType;

@end

@interface JKMangeView_JobVasNormal : UIView

@property (nonatomic, weak) id<JKMangeView_JobVasNormalDelegate> delegate;

@end
