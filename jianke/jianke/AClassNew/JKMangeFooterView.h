//
//  JKMangeFooterView.h
//  JKHire
//
//  Created by fire on 16/10/25.
//  Copyright © 2016年 xianshijian. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol JKMangeFooterViewDelegate <NSObject>

- (void)btnOnClick;

@end

@interface JKMangeFooterView : UICollectionReusableView

@property (nonatomic, weak) id<JKMangeFooterViewDelegate> delegate;

@end
