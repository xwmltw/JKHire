//
//  OnlinePayTableCell.h
//  QuanWangDai
//
//  Created by 余文灿 on 2017/12/27.
//  Copyright © 2017年 kizy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OnlinePayTableCell : UITableViewCell
// 文本
@property(nonatomic,retain) UILabel *introduction;
@property(nonatomic,retain) UILabel *category;
-(id)initWithReuseIdentifier:(NSString*)reuseIdentifier;
/** 设置文本自适应 */
-(void)setIntroductionText:(NSString*)text row:(NSInteger)row;
@end
