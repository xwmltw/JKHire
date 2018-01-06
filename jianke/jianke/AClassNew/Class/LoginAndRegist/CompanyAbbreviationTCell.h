//
//  CompanyAbbreviationTCell.h
//  JKHire
//
//  Created by yanqb on 2017/6/13.
//  Copyright © 2017年 xianshijian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EPModel.h"
@interface CompanyAbbreviationTCell : UITableViewCell

- (void)setCellWithPlaceHilder:(NSString *)placeHolder maxLength:(NSInteger )maxLength epModel:(EPModel *)epModel ;
@end
