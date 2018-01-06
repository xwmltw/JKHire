//
//  Recharge_VC.m
//  jianke
//
//  Created by xiaomk on 15/9/23.
//  Copyright (c) 2015年 xianshijian. All rights reserved.
//

#import "Recharge_VC.h"
#import "WDConst.h"
#import <AlipaySDK/AlipaySDK.h>
#import "DataSigner.h"
#import "PayWebView_VC.h"



@interface Recharge_VC ()<UITextFieldDelegate> {
    WDPayType _selectPayType;
    WeChatRechargeModel* _wxRechModel;
    AlipayRechargeModel* _alipayRechModel;
}


@property (weak, nonatomic) IBOutlet UITextField *labInputMoney;
@property (weak, nonatomic) IBOutlet UIButton *btnWechatPay;
@property (weak, nonatomic) IBOutlet UIButton *btnBank;
@property (weak, nonatomic) IBOutlet UIButton *btnZhifubaoPay;
@property (weak, nonatomic) IBOutlet UIButton *btnSure;
@property (weak, nonatomic) IBOutlet UIView *zhifubaoView;
@end

@implementation Recharge_VC

- (void)viewDidLoad {
    [super viewDidLoad];
    [TalkingData trackEvent:@"钱袋子_充值_确定"];
    self.title = @"充值";
    // 支付回调通知
    [WDNotificationCenter addObserver:self selector:@selector(weCharPayResponse:) name:WXPayGetCodeNotification object:nil];
//    [WDNotificationCenter addObserver:self selector:@selector(alipayResponse:) name:AlipayResponseNotification object:nil];

    [self.btnSure setBackgroundImage:[UIImage imageNamed:@"login_btn_login_0"] forState:UIControlStateNormal];
    [self.btnSure setBackgroundImage:[UIImage imageNamed:@"login_btn_login_1"] forState:UIControlStateHighlighted];

    self.btnWechatPay.selected = YES;
    _selectPayType = WDPayType_WeChat;
    
    self.labInputMoney.delegate = self;

}

- (IBAction)btnWXPayOnClick:(UIButton *)sender {
    self.btnWechatPay.selected = YES;
    self.btnZhifubaoPay.selected = NO;
    self.btnBank.selected = NO;
    _selectPayType = WDPayType_WeChat;
    [TalkingData trackEvent:@"充值_微信支付"];
}

- (IBAction)btnBankOnclick:(UIButton *)sender {
    [UIHelper toast:@"平安付充值服务已经关闭"];
//    self.btnWechatPay.selected = NO;
//    self.btnZhifubaoPay.selected = NO;
//    self.btnBank.selected = YES;
//    _selectPayType = WDPayType_Bank;
}

- (IBAction)btnZFBPayOnClien:(UIButton *)sender {
    [UIHelper toast:@"支付宝充值服务已经关闭，但在支付工资时，还可以选择支付宝支付"];
//    self.btnWechatPay.selected = NO;
//    self.btnZhifubaoPay.selected = YES;
//    _selectPayType = WDPayType_AliPay;
    [TalkingData trackEvent:@"充值_支付宝支付"];
}



/** 确认充值 */
- (IBAction)btnSurOnClick:(UIButton *)sender {
    
    if (!_selectPayType) {
        [UIHelper toast:@"请选着支付类型"];
        return;
    }
    if (self.labInputMoney.text.length <= 0) {
        [UIHelper toast:@"请输入金额"];
        return;
    }
    if ([self.labInputMoney.text floatValue] <= 0) {
        [UIHelper toast:@"输入金额不能为0"];
        return;
    }
    
    if (_selectPayType == WDPayType_WeChat) {
        [self requestWXOutTradeNo];
    }else if (_selectPayType == WDPayType_AliPay){
        [self requestAlipayOutTradeNo];
    }else if (_selectPayType == WDPayType_Bank){
        
//        NSString* num = self.labInputMoney.text;
//        float floatNum = [num floatValue] * 100;
//        int intNum = (int)floatNum;
//
//        PayWebView_VC *vc = [[PayWebView_VC alloc] init];
//        vc.isUnSaftLinks = YES;
//        vc.url = [NSString stringWithFormat:@"%@%@%d",URL_HttpServer,kUrl_pinganRecharge, intNum];
//        [self.navigationController pushViewController:vc animated:YES];
        
    }
    [TalkingData trackEvent:@"充值_确定"];
}

#pragma mark - 微信充值==========================
- (void)requestWXOutTradeNo{
    
    if (![[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"weixin://"]]) {
        [UIHelper toast:@"你没有安装微信"];
        return;
    };
    
    NSString* num = self.labInputMoney.text;
    float floatNum = [num floatValue] * 100;
    int intNum = (int)floatNum;
    NSString* content = [NSString stringWithFormat:@"\"recharge_amount\":\"%d\"",intNum];
    RequestInfo* request = [[RequestInfo alloc] initWithService:@"shijianke_youpinWechatRecharge" andContent:content];
    request.isShowLoading = YES;
    WEAKSELF
    [request sendRequestWithResponseBlock:^(ResponseInfo* response) {
        if (response && [response success]) {
            _wxRechModel = [WeChatRechargeModel objectWithKeyValues:response.content];
            [weakSelf showWeixinPay];
        }
    }];
}

- (void)showWeixinPay{
    NSString* nonceStr = [XSJUserInfoData createRandom32UppStr];
    ELog("==nonceStr:%@",nonceStr);
    
    NSString* package = @"Sign=WXPay";

    UInt32 timeStampInt = [DateHelper getTimeStamp4Second];
    NSString* timeStamp = [NSString stringWithFormat:@"%d",(unsigned int)timeStampInt];
    ELog(@"timeStamp=%@",timeStamp);

    PayReq* request = [[PayReq alloc] init];
    request.openID = _wxRechModel.appid;
    request.partnerId = _wxRechModel.mch_id;
    request.prepayId = _wxRechModel.prepay_id;
    request.package = @"Sign=WXPay";
    request.nonceStr = nonceStr;
    request.timeStamp = timeStampInt;
    
    NSMutableDictionary* signParams = [NSMutableDictionary dictionary];
    [signParams setObject:_wxRechModel.appid        forKey:@"appid"];
    [signParams setObject:_wxRechModel.mch_id       forKey:@"partnerid"];
    [signParams setObject:_wxRechModel.prepay_id    forKey:@"prepayid"];
    [signParams setObject:nonceStr                  forKey:@"noncestr"];
    [signParams setObject:package                   forKey:@"package"];
    [signParams setObject:timeStamp                 forKey:@"timestamp"];
    
    NSString* sign = [self createMd5Sign:signParams];
    
    request.sign = sign;
    ELog("====signParams:%@",signParams);
    ELog("====sign:%@",sign);
    [WXApi sendReq:request];
    
}

- (NSString*)createMd5Sign:(NSMutableDictionary*)dict{
    NSMutableString* contentString = [NSMutableString string];
    NSArray* keys = [dict allKeys];
    NSArray* sortedArray = [keys sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        return [obj1 compare:obj2 options:NSNumericSearch];
    }];
    for (NSString* categoryId in sortedArray) {
        if (![[dict objectForKey:categoryId] isEqualToString:@""] && ![categoryId isEqualToString:@"sign"] && ![categoryId isEqualToString:@"key"]) {
            [contentString appendFormat:@"%@=%@&", categoryId, [dict objectForKey:categoryId]];
        }
    }
    [contentString appendFormat:@"key=%@",_wxRechModel.mch_key];
    //    ELog("====contentString:%@",contentString);
    NSString* md5Sign = [[contentString MD5] uppercaseString];
    return  md5Sign;
}

- (void)weCharPayResponse:(NSNotification *)notification{
    ELog("=======weCharPayResponse");
    
    NSString* content = [NSString stringWithFormat:@"out_trade_no:\"%@\"",_wxRechModel.out_trade_no];
    RequestInfo* request = [[RequestInfo alloc] initWithService:@"shijianke_queryWechatAcctRechageResult" andContent:content];
    request.isShowLoading = YES;
    WEAKSELF
    [request sendRequestWithResponseBlock:^(ResponseInfo* response) {
        if (response && [response success]) {
            WeChatPayResultModel* model = [WeChatPayResultModel objectWithKeyValues:response.content];
            if (model.order_status.intValue == 2 && model.order_close_type.intValue == 1 && [model.wechat_result_code isEqualToString:@"SUCCESS"]) {
                [UIHelper toast:@"充值成功"];
                [weakSelf.navigationController popViewControllerAnimated:YES];
            }else{
                [UIHelper toast:@"充值异常"];
            }
        }
    }];
}


#pragma mark - AliPay==================
- (void)requestAlipayOutTradeNo{
    
    if (![[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"alipay://"]]) {
        [UIHelper toast:@"你没有安装支付宝"];
        return;
    };
    
    
    NSString* num = self.labInputMoney.text;
    float floatNum = [num floatValue] * 100;
    int intNum = (int)floatNum;
    NSString* content = [NSString stringWithFormat:@"\"recharge_amount\":\"%d\"",intNum];
    RequestInfo* request = [[RequestInfo alloc] initWithService:@"shijianke_createAlipayRechargeRequest" andContent:content];
    request.isShowLoading = YES;
    [request sendRequestWithResponseBlock:^(ResponseInfo* response) {
        if (response && [response success]) {
            _alipayRechModel = [AlipayRechargeModel objectWithKeyValues:response.content];
            [self showAlipay];
        }
    }];
}

- (void)showAlipay{
    ELog(@"=====showAlipay");
 
    AlipayOredrModel* model = [[AlipayOredrModel alloc] init];
    model.partner = _alipayRechModel.alipay_partner;
    model.seller_id = _alipayRechModel.alipay_account;
    model.out_trade_no = _alipayRechModel.recharge_serail_id;
    model.subject = _alipayRechModel.recharge_title;
    model.body = _alipayRechModel.recharge_title;
    model.total_fee = [NSString stringWithFormat:@"%0.2f", ((float)_alipayRechModel.recharge_amount.intValue)/100];
    model.notify_url = _alipayRechModel.callback_url;
    model.service = @"mobile.securitypay.pay";
    model.payment_type = @"1";
    model._input_charset = @"utf-8";
    model.it_b_pay = @"30m";
    model.show_url = @"m.alipay.com";
    
    NSString* orderSpec = [model description];
    ELog(@"======orderSpec:%@",orderSpec);
    
    id<DataSigner> signer = CreateRSADataSigner(_alipayRechModel.recharge_private_key);
    NSString* signedString = [signer signString:orderSpec];
    
    NSString* orderString = nil;
    if (signedString != nil) {
        orderString = [NSString stringWithFormat:@"%@&sign=\"%@\"&sign_type=\"%@\"",orderSpec,signedString,@"RSA"];
        ELog(@"===========orderString:%@",orderString);
        NSString* fromScheme = @"JKHire";
        WEAKSELF
        [[AlipaySDK defaultService] payOrder:orderString fromScheme:fromScheme callback:^(NSDictionary *resultDic) {
            ELog("=========resultDic:%@",resultDic);
            NSString* resultStatus = resultDic[@"resultStatus"];
            if ([resultStatus isEqualToString:@"9000"]) {
                [UIHelper toast:@"充值成功"];
                [weakSelf.navigationController popViewControllerAnimated:YES];
            }else{
                [UIHelper toast:@"充值失败"];
            }
        }];
    }
}


- (void)alipayResponse:(NSNotification *)notification{
    ELog(@"======notification.userInfo:%@",notification.userInfo);
    NSString* resultStatus = notification.userInfo[@"resultStatus"];
    if ([resultStatus isEqualToString:@"9000"]) {
        [UIHelper toast:@"充值成功"];
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        [UIHelper toast:@"充值失败"];
    }
}






#pragma mark - UITextField delegate
#define WDDotNumbers     @"0123456789.\n"
#define MDNumbers          @"0123456789\n"
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if ([string isEqualToString:@"."] && textField.text.length == 0) {
        return NO;
    }
    
    if ([string isEqual:@"\n"] || [string isEqualToString:@""]) {
        return YES;
    }
    
    NSCharacterSet* cs;
    NSUInteger nDotloc = [textField.text rangeOfString:@"."].location;
    if (NSNotFound == nDotloc && 0 != range.location) {
        cs = [[NSCharacterSet characterSetWithCharactersInString:MDNumbers] invertedSet];
        if ([string isEqualToString:@"."]) {
            return YES;
        }
        if (textField.text.length >= 6) {
            return NO;
        }
    }else{
        cs = [[NSCharacterSet characterSetWithCharactersInString:WDDotNumbers] invertedSet];
        if (textField.text.length >= 9) {
            return NO;
        }
    }
    NSString* filtered = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
    BOOL basicText = [string isEqualToString:filtered];
    if (!basicText) {
        return NO;
    }
    if (NSNotFound != nDotloc && range.location > nDotloc + 2) {
        return NO;
    }
    return YES;
}

- (IBAction)bgVIewOnClick:(id)sender {
    [self.labInputMoney resignFirstResponder];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [WDNotificationCenter removeObserver:self];
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
