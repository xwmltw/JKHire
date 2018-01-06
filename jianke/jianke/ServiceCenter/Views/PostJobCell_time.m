//
//  PostJobCell_time.m
//  jianke
//
//  Created by xiaomk on 16/4/20.
//  Copyright © 2016年 xianshijian. All rights reserved.
//

#import "PostJobCell_time.h"
#import "PostJobModel.h"
#import "TimeBtn.h"

@implementation PostJobCell_time

- (void)awakeFromNib{
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

+ (instancetype)cellWithTableView:(UITableView *)tableView{
    static NSString *identifier = @"PostJobCell_time";
    PostJobCell_time *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (!cell) {
        static UINib* _nib;
        if (!_nib) {
            _nib = [UINib nibWithNibName:@"PostJobCell_time" bundle:nil];
        }
        
        if (_nib) {
            cell = [[_nib instantiateWithOwner:nil options:nil] objectAtIndex:0];
        }
        cell.backgroundColor = [UIColor whiteColor];
    }
    return cell;
}

- (void)setModel:(PostJobModel *)model timeBtnArray:(NSArray *)timeBtnArray{
    
    [self.btnAddTime setTitle:@"添加工作时间段" forState:UIControlStateNormal];
    [self.btnAddTime addTarget:self action:@selector(btnAddTimeOnclick:) forControlEvents:UIControlEventTouchUpInside];
    [self.timeBgView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    for (NSInteger i = 0; i < timeBtnArray.count; i++) {
        TimeBtn* btn = timeBtnArray[i];
        [self.timeBgView addSubview:btn];
        CGRect frame = btn.frame;
        frame.origin.x = 0;
        frame.origin.y = 12 + i * (26+8);
        btn.frame = frame;
    }
    self.btnAddTime.hidden = timeBtnArray.count > 2;
    
    
    self.layoutViewHeight.constant = 112+ (26+8)*timeBtnArray.count ;
    self.layoutTimeBtnToTop.constant = self.layoutViewHeight.constant - 32-12-56;
    if (timeBtnArray.count > 2) {
        self.layoutViewHeight.constant = 112+ (26+8)*timeBtnArray.count - 32;
    }
    
    
}

- (void)btnAddTimeOnclick:(UIButton *)sender{
    
   
}
- (IBAction)btnMaxTime:(UIButton *)sender {
    
    if (sender.selected) {
//        [self.btnMaxTime setImage:[UIImage imageNamed:@"PostJobCell_MaxTime"] forState:UIControlStateNormal];
        [self.btnAddTime setTitleColor:MKCOLOR_RGB(74, 144, 226) forState:UIControlStateNormal];
        [self.btnAddTime setUserInteractionEnabled:YES];
//        self.selectBtn = !self.selectBtn;
        
        if ([self.delegate respondsToSelector:@selector(btnAddTimeInclick)]) {
            [self.delegate btnAddTimeInclick];
        }
        
    }else{
       
//        [self.btnMaxTime setImage:[UIImage imageNamed:@"v3_public_select_1"] forState:UIControlStateNormal];
        

        [self.btnAddTime setTitleColor:MKCOLOR_RGBA(34, 58, 80, 0.48) forState:UIControlStateNormal];
        [self.btnAddTime setUserInteractionEnabled:NO];
//        self.selectBtn = !self.selectBtn;
        
        if ([self.delegate respondsToSelector:@selector(btnAddMaxTimeInClick)]) {
            [self.delegate btnAddMaxTimeInClick];
        }
    }
    sender.selected = !sender.selected;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
