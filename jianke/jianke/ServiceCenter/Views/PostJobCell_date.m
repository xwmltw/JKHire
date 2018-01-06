//
//  PostJobCell_date.m
//  jianke
//
//  Created by xiaomk on 16/4/18.
//  Copyright © 2016年 xianshijian. All rights reserved.
//

#import "PostJobCell_date.h"
#import "PostJobModel.h"
#import "DateHelper.h"


@implementation PostJobCell_date

- (void)awakeFromNib{
    [super awakeFromNib];
    [_btnDateStart addTarget:self action:@selector(btnDateStartOnclick:) forControlEvents:UIControlEventTouchUpInside];
    [_btnDateEnd addTarget:self action:@selector(btnDateEndOnclick:) forControlEvents:UIControlEventTouchUpInside];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

+ (instancetype)cellWithTableView:(UITableView *)tableView{
    static NSString *identifier = @"PostJobCell_date";
    PostJobCell_date *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (!cell) {
        static UINib* _nib;
        if (!_nib) {
            _nib = [UINib nibWithNibName:@"PostJobCell_date" bundle:nil];
        }
        
        if (_nib) {
            cell = [[_nib instantiateWithOwner:nil options:nil] objectAtIndex:0];
        }
        cell.backgroundColor = [UIColor whiteColor];
    }
    return cell;
}

- (void)setStartDate:(NSDate *)startDate endDate:(NSDate *)endDate jobCellType:(NSNumber *)cellType{
    if (startDate) {
        self.labDateStart.text = [DateHelper getDateAndWeekWithDate:startDate];
    }else{
        self.labDateStart.text = @"开始日期";
    }
    if (endDate) {
        self.labDateEnd.text = [DateHelper getDateAndWeekWithDate:endDate];
    }else{
        self.labDateEnd.text = @"结束日期";
    }
}

/** 开始时间 */
- (void)btnDateStartOnclick:(UIButton*)sender{
    if ([self.delegate respondsToSelector:@selector(btnDateStartOnclick)]) {
        [self.delegate btnDateStartOnclick];
    }
}
/** 结束时间 */
- (void)btnDateEndOnclick:(UIButton*)sender{
    if ([self.delegate respondsToSelector:@selector(btnDateEndOnclick)]) {
        [self.delegate btnDateEndOnclick];
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
