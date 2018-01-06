//
//  ContactResumeFeedOther_VC.m
//  JKHire
//
//  Created by yanqb on 2017/6/30.
//  Copyright © 2017年 xianshijian. All rights reserved.
//

#import "ContactResumeFeedOther_VC.h"
#import "UIPlaceHolderTextView.h"

@interface ContactResumeFeedOther_VC ()
{
    NSInteger _maxLengh;

}
@property (nonatomic, weak)UILabel *labTip;
@property (nonatomic, weak)UIPlaceHolderTextView *textView;
@end

@implementation ContactResumeFeedOther_VC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"其他";
    
    _maxLengh = 120;
    UIPlaceHolderTextView *textView = [[UIPlaceHolderTextView alloc]init];
    textView.placeholder = @"没成功招到人的其他原因";
    textView.placeholderColor = [UIColor XSJColor_tGrayDeepTransparent32];
    textView.backgroundColor = [UIColor XSJColor_newGray];
    textView.font = [UIFont systemFontOfSize:16.0f];
    textView.maxLength = _maxLengh;
    self.textView = textView;
    
    UIButton *btn = [UIButton buttonWithTitle:@"提交" bgColor:MKCOLOR_RGB(43, 188, 223) image:nil target:self sector:@selector(btnOnActin:)];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn.titleLabel setFont:[UIFont systemFontOfSize:16]];
    [btn setCornerValue:5];
    
    UILabel *lab = [[UILabel alloc]init];
    [lab setFont:[UIFont systemFontOfSize:12.0f]];
    lab.textColor = [UIColor XSJColor_tGrayDeepTransparent32];
    lab.attributedText = [self getMutableAttStrWith:@""];
    _labTip = lab;

    WEAKSELF
    textView.block = ^(NSString *text){
        weakSelf.labTip.attributedText = [weakSelf getMutableAttStrWith:text];
    };
    
    [self.view addSubview:textView];
    [self.view addSubview:btn];
    [self.view addSubview:lab];
    
    [textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.equalTo(self.view).offset(16);
        make.right.equalTo(self.view).offset(-16);
        make.height.mas_equalTo(220);
        
    }];
   
    [lab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(textView.mas_bottom).offset(8);
        make.right.equalTo(self.view).offset(-16);
    }];
    
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lab.mas_bottom).offset(16);
        make.left.equalTo(self.view).offset(16);
        make.right.equalTo(self.view).offset(-16);
        make.height.equalTo(@40);
        
    }];
    
}

- (NSMutableAttributedString *)getMutableAttStrWith:(NSString *)text{
    if (!text.length) {
        text = @"";
    }
    NSMutableAttributedString *mutableAttStr = [[NSMutableAttributedString alloc] initWithString:@"还能输入" attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:12.0f], NSForegroundColorAttributeName: [UIColor XSJColor_tGrayDeepTinge]}];
    NSString *str = [NSString stringWithFormat:@"%ld", _maxLengh - text.length];
    NSAttributedString *attStr1 = [[NSAttributedString alloc] initWithString:str attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:12.0f], NSForegroundColorAttributeName: [UIColor XSJColor_middelRed]}];
    NSAttributedString *attStr2 = [[NSAttributedString alloc] initWithString:@"字" attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:12.0f], NSForegroundColorAttributeName: [UIColor XSJColor_tGrayDeepTinge]}];
    [mutableAttStr appendAttributedString:attStr1];
    [mutableAttStr appendAttributedString:attStr2];
    return mutableAttStr;
}

- (void)btnOnActin:(UIButton *)sender{
    if (self.textView.text.length) {
        [[XSJRequestHelper sharedInstance] entContactResumeFeedback:self.model.ent_contact_resume_log_id contactResultType:@(7) contactRemark:self.textView.text block:^(id result) {
            if (result) {
                [UIHelper toast:@"提交成功"];
                [self.navigationController popViewControllerAnimated:YES];
            }
        }];
    }else{
        [UIHelper toast:@"请输入原因"];
    }
 }

- (void)backToLastView{
    
    [self.navigationController popViewControllerAnimated:YES];
    MKBlockExec(self.block,nil);
//    [UIHelper toast:@"请输入原因并提交"];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
