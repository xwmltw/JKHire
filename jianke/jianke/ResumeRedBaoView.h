//
//  ResumeRedBaoView.h
//  JKHire
//
//  Created by yanqb on 2017/6/30.
//  Copyright © 2017年 xianshijian. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface ResumeRedBaoView : UIView
@property (weak, nonatomic) IBOutlet UILabel *redbaoNum;
@property (nonatomic, copy)MKBlock block;
@property (weak, nonatomic) IBOutlet UILabel *lab3;
@property (weak, nonatomic) IBOutlet UILabel *lab1;
@property (weak, nonatomic) IBOutlet UILabel *lab2;
@property (weak, nonatomic) IBOutlet UILabel *lab4;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *layout3;
@end

