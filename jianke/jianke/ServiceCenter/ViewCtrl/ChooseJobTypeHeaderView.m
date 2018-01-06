//
//  ChooseJobTypeHeaderView.m
//  JKHire
//
//  Created by yanqb on 2017/3/3.
//  Copyright © 2017年 xianshijian. All rights reserved.
//

#import "ChooseJobTypeHeaderView.h"
#import "UILabel+MKExtension.h"
#import "WDConst.h"

@interface ChooseJobTypeHeaderView ()

@property (nonatomic, weak) UILabel *seekerLab;

@end

@implementation ChooseJobTypeHeaderView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI{
    UILabel *numLab = [UILabel labelWithText:@"0" textColor:[UIColor XSJColor_middelRed] fontSize:32.0f];
    self.seekerLab = numLab;
    UILabel *rightLab = [UILabel labelWithText:@"位/求职者等待招募中..." textColor:[UIColor XSJColor_tGrayHistoyTransparent] fontSize:15.0f];
    UIView *line = [[UIView alloc] init];
    line.backgroundColor = [UIColor XSJColor_tGrayHistoyTransparent];
    UILabel *bottomLab = [UILabel labelWithText:@"选择您要招聘的岗位:" textColor:[UIColor XSJColor_tGrayDeepTransparent3] fontSize:13.0f];
    
    [self addSubview:numLab];
    [self addSubview:rightLab];
    [self addSubview:line];
    [self addSubview:bottomLab];
    
    [numLab setContentHuggingPriority:UILayoutPriorityDefaultHigh forAxis:UILayoutConstraintAxisHorizontal];
    
    [numLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(16);
        make.top.equalTo(self).offset(32);
    }];
    
    [rightLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(numLab);
        make.left.equalTo(numLab.mas_right).offset(4);
        make.right.equalTo(self).offset(-16);
    }];
    
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(numLab.mas_bottom).offset(32);
        make.left.equalTo(self).offset(16);
        make.height.equalTo(@3);
        make.width.equalTo(@40);
    }];
    
    [bottomLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(line.mas_bottom).offset(16);
        make.left.equalTo(self).offset(16);
    }];
    
}

- (void)setSeekerNum:(NSNumber *)seekerNum{
//    __block int _numText = 0;
//    //全局队列    默认优先级
//    dispatch_queue_t quene = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
//    //定时器模式  事件源
//    dispatch_source_t timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, quene);
//    //NSEC_PER_SEC是秒，＊1是每秒
//    dispatch_source_set_timer(timer, dispatch_walltime(NULL, 0), NSEC_PER_SEC * (1/seekerNum.floatValue), 0);
//    //设置响应dispatch源事件的block，在dispatch源指定的队列上运行
//    dispatch_source_set_event_handler(timer, ^{
//        //回调主线程，在主线程中操作UI
//        dispatch_async(dispatch_get_main_queue(), ^{
//            if (_numText <= seekerNum.integerValue) {
//                _seekerLab.text = [NSString stringWithFormat:@"%d",_numText];
//                _numText++;
//                
//            }
//            else
//            {
//                //这句话必须写否则会出问题
//                dispatch_source_cancel(timer);
//                _seekerLab.text = [NSString stringWithFormat:@"%d",_numText];
//            }
//        });
//    });
//    //启动源
//    dispatch_resume(timer);
    
    self.seekerLab.text = seekerNum ? seekerNum.description : @"0" ;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
