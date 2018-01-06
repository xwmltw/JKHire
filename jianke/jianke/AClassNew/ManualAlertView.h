//
//  ManualAlertView.h
//  JKHire
//
//  Created by yanqb on 16/11/9.
//  Copyright © 2016年 xianshijian. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ManualAlertView;
@protocol ManualAlertViewDelegate <NSObject>

- (void)ManualAlertView:(ManualAlertView *)alertView clickedButtonAtIndex:(NSInteger)index;

@end

@interface ManualAlertView : UIView

@property (nonatomic,weak) id<ManualAlertViewDelegate> delegate;
@property (nonatomic,weak, readonly)UILabel *rightLabel;
@property (nonatomic,copy) NSString *message;
@property (nonatomic,copy) NSString *rightMessage;


@end
