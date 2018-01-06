//
//  VipPacket_Cell.h
//  JKHire
//
//  Created by yanqb on 2017/5/9.
//  Copyright © 2017年 xianshijian. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PackageItem;
@interface VipPacket_Cell : UITableViewCell

- (void)setModel:(PackageItem *)model indexPath:(NSIndexPath *)indexPath;

@end
