//
//  XZImgPreviewView.h
//  jianke
//
//  Created by yanqb on 2016/11/17.
//  Copyright © 2016年 xianshijian. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XZImgPreviewView : UIView

+ (void)showViewWithArray:(NSArray *)imgArr beginWithIndex:(NSInteger)index;

@property (nonatomic, copy) NSArray<UIImageView *> *imgArr;

@end
