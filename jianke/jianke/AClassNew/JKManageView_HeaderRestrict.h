//
//  JKManageView_HeaderRestrict.h
//  JKHire
//
//  Created by xuzhi on 2017/4/10.
//  Copyright © 2017年 xianshijian. All rights reserved.
//

#import <UIKit/UIKit.h>

@class JKManageView_HeaderRestrict;
@protocol JKManageView_HeaderRestrictDelegate <NSObject>

- (void)JKManageView_HeaderRestrict:(JKManageView_HeaderRestrict *)view;

@end

@interface JKManageView_HeaderRestrict : UIView

@property (nonatomic, weak) id<JKManageView_HeaderRestrictDelegate> delegate;
- (void)setData:(id)model;

@end
