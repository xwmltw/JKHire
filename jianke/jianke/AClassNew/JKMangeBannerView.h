//
//  JKMangeBannerView.h
//  JKHire
//
//  Created by yanqb on 2017/4/6.
//  Copyright © 2017年 xianshijian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyEnum.h"

@class JKMangeBannerView;

@protocol JKMangeBannerViewDelegate <NSObject>

- (void)JKMangeBannerView:(JKMangeBannerView *)view actionType:(BtnOnClickActionType)actionType;

@end

@interface JKMangeBannerView : UIView

@property (nonatomic, weak) id<JKMangeBannerViewDelegate> delegate;
- (void)setModel:(NSString *)undealNum hireNum:(NSNumber *)hireNum;

@end
