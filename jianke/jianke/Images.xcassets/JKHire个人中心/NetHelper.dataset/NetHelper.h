//
//  NetHelper.h
//  lottery
//
//  Created by xuzhi on 2017/3/17.
//  Copyright © 2017年 xsj. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseParam.h"
#import "MJExtension.h"
#import "ResponseModel.h"

typedef void(^ requestBlock)(id result);

@interface NetHelper : NSObject

+ (instancetype)sharedInstance;

- (void)getLotteryWithParam:(NSString *)param isShowLoading:(BOOL)isShowLoading isAppId:(BOOL)isAppId block:(requestBlock)block;
- (void)getLotteryWithParam:(NSString *)param isShowLoading:(BOOL)isShowLoading block:(requestBlock)block;
- (void)getLotteryWithParam:(NSString *)param block:(requestBlock)block;

- (void)requestWithModel:(BaseParam *)paramModel isShowLoading:(BOOL)isshowLoading block:(requestBlock)block;

- (void)requestOddApi:(BaseParam *)paramModel isShowLoading:(BOOL)isshowLoading block:(requestBlock)block;

- (void)requestRankApi:(BaseParam *)paramModel isShowLoading:(BOOL)isshowLoading block:(requestBlock)block;

@end
