//
//  OnlinePayCollectionCell.h
//  QuanWangDai
//
//  Created by 余文灿 on 2017/12/27.
//  Copyright © 2017年 kizy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OnlinePayCollectionCell : UICollectionViewCell

- (void)configureWith:(id)dic indexPath:(NSInteger)row;
@property (nonatomic,strong) UIButton *changebtn;
@end
