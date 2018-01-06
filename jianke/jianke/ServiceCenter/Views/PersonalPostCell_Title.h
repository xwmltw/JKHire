//
//  PersonalPostCell_Title.h
//  JKHire
//
//  Created by fire on 16/10/12.
//  Copyright © 2016年 xianshijian. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PersonalPostCell_Title : UITableViewCell

@property (weak, nonatomic) IBOutlet UITextField *utf;

- (void)setModel:(id)model jobCellType:(NSNumber *)cellType;

@end
