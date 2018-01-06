//
//  OnlinePayViewController.m
//  QuanWangDai
//
//  Created by 余文灿 on 2017/12/27.
//  Copyright © 2017年 kizy. All rights reserved.
//

#import "OnlinePayViewController.h"
#import <AlipaySDK/AlipaySDK.h>
#import "DataSigner.h"
#import "OnlinePayTableCell.h"
#import "OnlineCollectionReusableView.h"
#import "OnlinePayCollectionCell.h"
#import "MoneyBagPasswordManager.h"
#import "WeChatRechargeModel.h"
#import "WDConst.h"
#import "QueryAccountMoneyModel.h"

@interface OnlinePayViewController ()<UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>

/** UICollectionView */
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UICollectionViewFlowLayout *flowLayout;
@property (nonatomic, strong) NSDictionary *improveDic;
@property (nonatomic, strong) QueryAccountMoneyModel* moneyModel;   /*!< 钱袋子数据 */
@end

@implementation OnlinePayViewController
{
    NSInteger selectRow;
    WeChatRechargeModel* _wxRechModel;  /*!< 微信 数据模型 */
    AlipayRechargeModel* _alipayRechModel;  /*!< alipay 数据模型 */
}
-(void)viewWillAppear:(BOOL)animated{
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"在线支付";
    [self initUIWithType:DisplayTypeOnlyTableView];
    self.refreshType = RefreshTypeHeader;
//    [self createTableViewWithFrame:CGRectZero];
//    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.edges.mas_equalTo(self.view);
//    }];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.scrollEnabled = NO;
    self.tableView.tableHeaderView = [self creatHeadView];
   
    WEAKSELF
    [[MoneyBagPasswordManager sharedInstance] setPasswordSuccess:^(MoneyBagInfoModel* model) {
        if (model) {
            weakSelf.moneyModel = model.account_money_info;
            [self getDota];
             self.tableView.tableFooterView = [self creatFooterView];
        }else{
            [weakSelf.navigationController popViewControllerAnimated:YES];
        }
    }];
   
    
    UIButton *btnLoan = [[UIButton alloc]init];
    [btnLoan setTitle:@"确认支付" forState:UIControlStateNormal];
    [btnLoan setBackgroundColor:XColorWithRGB(0,199, 225)];
    [btnLoan setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btnLoan  setTitleColor:XColorWithRBBA(255, 255, 255, 0.4) forState:UIControlStateHighlighted];
    [btnLoan addTarget:self action:@selector(btnOnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btnLoan];
    [btnLoan mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(self.view);
        make.height.mas_equalTo(AdaptationWidth(56));
    }];
}
- (void)getDota{
    NSString *money = [NSString stringWithFormat:@"￥%0.2f",(float)self.moneyModel.available_amount.intValue/100];
    self.improveDic = @{@"name":@[@"余额",@"支付宝",@"微信"],
                        @"money":@[money,@"",@""],
                        @"image":@[@"vip_money",@"vip_zfb",@"vip_walt"],
                        @"selectedimage":@[@"vip_money",@"vip_zfb",@"vip_walt"],
                        @"btnimage":@[@"vip_unSelect",@"vip_unSelect",@"vip_unSelect"],
                        @"btnselectedimage":@[@"vip_select",@"vip_select",@"vip_select"]};
}

#pragma mark - 创建头视图
- (UIView *)creatHeadView{
    
    UIView * headBgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, AdaptationWidth(100))];
    headBgView.backgroundColor = [UIColor clearColor];
    
    /** 文本 */
    UILabel *titleLabel = [[UILabel alloc]init];
    titleLabel.text = @"支付金额 (元)";
    [titleLabel setFont:[UIFont fontWithName:@"PingFangSC-Medium" size:AdaptationWidth(15)]];
    [titleLabel setTextColor:XColorWithRBBA(34, 58, 80, 0.16)];
    [headBgView addSubview:titleLabel];
    
    UILabel *moneyLabel = [[UILabel alloc]init];
    moneyLabel.text = [NSString stringWithFormat:@"%.2f", self.needPayMoney/100.0];
    moneyLabel.textAlignment = NSTextAlignmentLeft;
    [moneyLabel setFont:[UIFont fontWithName:@"Menlo-Regular" size:AdaptationWidth(32)]];
    [moneyLabel setTextColor:XColorWithRGB(255, 97, 142)];
    [headBgView addSubview:moneyLabel];
    
    UIView *line = [[UIView alloc]init];
    line.backgroundColor = XColorWithRGB(233, 233, 235);
    [headBgView addSubview:line];
    
    
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(headBgView).offset(AdaptationWidth(16));
        make.height.mas_equalTo(AdaptationWidth(21));
        make.width.mas_equalTo(AdaptationWidth(105));
        make.top.mas_equalTo(headBgView).offset(AdaptationWidth(16));
    }];
    [moneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(headBgView).offset(AdaptationWidth(16));
        make.height.mas_equalTo(AdaptationWidth(38));
        make.bottom.mas_equalTo(headBgView).offset(-AdaptationWidth(16));
        make.top.mas_equalTo(titleLabel.mas_bottom).offset(AdaptationWidth(8));
    }];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(headBgView);
        make.bottom.mas_equalTo(headBgView.mas_bottom);
        make.height.mas_equalTo(1);
    }];
    
    return headBgView;
}

#pragma mark - 创建尾视图
- (UIView *)creatFooterView{
    UIView * FooterBgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, AdaptationWidth(100))];
    FooterBgView.backgroundColor = [UIColor clearColor];
    
    _flowLayout = [[UICollectionViewFlowLayout alloc]init];
    _flowLayout.minimumLineSpacing = 0;
    _flowLayout.minimumInteritemSpacing = -1;
    
    _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 10,SCREEN_WIDTH , SCREEN_WIDTH-44) collectionViewLayout:_flowLayout];
    _collectionView.scrollEnabled = NO;
    _collectionView.delaysContentTouches = NO;
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    _collectionView.backgroundColor = [UIColor whiteColor];
//    MJRefreshStateHeader *header = [MJRefreshStateHeader headerWithRefreshingTarget:self refreshingAction:@selector(headerRefresh)];
//    _collectionView.mj_header = nil;
//    header.lastUpdatedTimeLabel.hidden = YES;
//    header.stateLabel.hidden = YES;
    [FooterBgView addSubview:_collectionView];
    
    // register SectionHeader
    [_collectionView registerClass:[OnlineCollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:NSStringFromClass([OnlineCollectionReusableView class])];
    
    // register cell
    [_collectionView registerClass:[OnlinePayCollectionCell class] forCellWithReuseIdentifier:NSStringFromClass([OnlinePayCollectionCell class])];

    return FooterBgView;
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 4;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [self tableView:self.tableView cellForRowAtIndexPath:indexPath];
    return cell.frame.size.height;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 47;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    UIView * view = [[UIView alloc]init];
    view.backgroundColor = [UIColor clearColor];
    UILabel *lab = [[UILabel alloc]init];
    [lab setText:@"订单详情"];
    [lab setTextColor:XColorWithRBBA(34, 58, 80, 0.16)];
    [lab setFont:[UIFont fontWithName:@"PingFangSC-Medium" size:AdaptationWidth(15)]];
    [view addSubview:lab];
    
    [lab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(view).offset(AdaptationWidth(16));
        make.bottom.mas_equalTo(view.mas_bottom).offset(-AdaptationWidth(10));
    }];
    return view;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"OnlinePayTableCell";
    OnlinePayTableCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[OnlinePayTableCell alloc] initWithReuseIdentifier:identifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    NSArray *arr = @[self.name,self.city,[NSString stringWithFormat:@"%@个月",self.date],self.des];
    NSArray *title = @[@"套餐名称：",@"服务城市：",@"服务时长：",@"服务内容："];
    [cell setIntroductionText:arr[indexPath.row] row:indexPath.row];
    cell.category.text = title[indexPath.row];
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {

    return 3;
}
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    OnlinePayCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([OnlinePayCollectionCell class]) forIndexPath:indexPath];
    UIImageView *image = [[UIImageView alloc]init];
    image.image = [UIImage imageNamed:@""];
    cell.backgroundView = image;
    cell.backgroundColor = [UIColor whiteColor];
    cell.selectedBackgroundView = [[UIImageView alloc] initWithImage:nil];
    if (indexPath.row == selectRow) {
        cell.changebtn.selected = YES;
    }else{
        cell.changebtn.selected = NO;
    }
    
    [cell configureWith:self.improveDic indexPath:indexPath.row ];
    
    return cell;

}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    if (kind == UICollectionElementKindSectionHeader) {
        
        OnlineCollectionReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:NSStringFromClass([OnlineCollectionReusableView class]) forIndexPath:indexPath];
        headerView.titleLabe.text = @"支付方式";
        return headerView;
    }
    return nil;
}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    selectRow = indexPath.row;
    [_collectionView reloadData];
}

- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    return YES;
}

#pragma mark - UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    return CGSizeMake(self.collectionView.bounds.size.width, AdaptationWidth(38));
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {

    return CGSizeMake([self fixSlitWith:self.collectionView.bounds colCount:3 space:0], AdaptationWidth(150));
}

- (CGFloat)fixSlitWith:(CGRect)rect colCount:(CGFloat)colCount space:(CGFloat)space {
    CGFloat totalSpace = (colCount - 1) * space;                  //总共留出的距离
    CGFloat itemWidth = (rect.size.width - totalSpace) / colCount;// 按照真实屏幕算出的cell宽度 （iPhone6 375*667）93.75
    CGFloat fixValue = 1 / [UIScreen mainScreen].scale; //(1px=0.5pt,6Plus为3px=1pt)
    CGFloat realItemWidth = floor(itemWidth) + fixValue;//取整加fixValue
    //floor:如果参数是小数，则求最大的整数但不大于本身.
    if (realItemWidth < itemWidth) {// 有可能原cell宽度小数点后一位大于0.5
        realItemWidth += fixValue;
    }
    CGFloat realWidth = colCount * realItemWidth + totalSpace;//算出屏幕等分后满足1px=([UIScreen mainScreen].scale)pt实际的宽度,可能会超出屏幕,需要调整一下frame
    CGFloat pointX = (realWidth - rect.size.width) / 2; //偏移距离
    rect.origin.x = -pointX;//向左偏移
    rect.size.width = realWidth;
    return (rect.size.width - totalSpace) / colCount; //每个cell的真实宽度
}


#pragma mark - 按钮点击事件
-(void)btnOnClick:(UIButton *)sender{
    
    [TalkingData trackEvent:@"在线支付_确认支付按钮"];
    
    if (selectRow == 0) {
        WEAKSELF
        [[MoneyBagPasswordManager sharedInstance] showCommitPassword:^(NSString* password) {
            if (password) {
                [weakSelf sendPayRequestWithPassword:password];
            }
        }];
    }else{
        [self sendPayRequestWithPassword:nil];
    }
}

- (void)sendPayRequestWithPassword:(NSString*)password{
    NSNumber* payChannel = @(selectRow+1);
    if (payChannel == nil) {
        [UIHelper toast:@"请选择支付方式"];
        return;
    }
    
    PayJobInfoModel* payModel = [[PayJobInfoModel alloc] init];
    payModel.job_id = self.jobId;
    payModel.pay_channel = payChannel;
    
//    if (_selectPayType != WDPayType_WeChat) {
//        payModel.pay_channel_type = @3;
//    }else{
        payModel.pay_channel_type = @1;
//    }
    
    if (selectRow == 0 && password.length > 0) {
        NSString* pwdEncrypt = [[[NSString stringWithFormat:@"%@%@", password, [XSJNetWork getChallenge]] MD5] uppercaseString];
        payModel.acct_encpt_password = pwdEncrypt;
    }
    
    NSString* time = [NSString stringWithFormat:@"%lld",(long long)[DateHelper getTimeStamp]];
    payModel.client_time_millseconds = time;
    
     //VIP套餐业务
    [self payVipOrderWith:payModel];
   
}
- (void)payVipOrderWith:(PayJobInfoModel *)payModel{
    payModel.recharge_amount = @((self.needPayMoney*100));
    payModel.vip_order_id = self.vip_order_id;
    WEAKSELF
    [[XSJRequestHelper sharedInstance] payVipOrder:payModel block:^(id result) {
        if (result) {
            [weakSelf payEventWithResponse:result];
        }
    }];
}
/** 根据支付类型操作 */
- (void)payEventWithResponse:(ResponseInfo*)response{
    if (selectRow == 0) {
        [TalkingData trackEvent:@"在线支付_余额"];
        [self paySuccessJumpTo];
    }else if (selectRow == 2){
        [TalkingData trackEvent:@"在线支付_微信支付"];
        _wxRechModel = [WeChatRechargeModel objectWithKeyValues:response.content];
        [self showWeixinPay];
    }else if (selectRow == 1){
        [TalkingData trackEvent:@"在线支付_支付宝"];
        _alipayRechModel = [AlipayRechargeModel objectWithKeyValues:response.content];
        [self showAlipay];
    }
//    else if (_selectPayType == WDPayType_WapAliPay){
//        [TalkingData trackEvent:@"在线支付_支付宝"];
//        PayWebView_VC *viewCtrl = [[PayWebView_VC alloc] init];
//        viewCtrl.url = [response.content objectForKey:@"alipay_wap_pay_url"];
//        WEAKSELF
//        viewCtrl.block = ^(id obj){
//            [weakSelf paySuccessJumpTo];
//        };
//        [self.navigationController pushViewController:viewCtrl animated:YES];
//    }
}
/** 支付成功跳转 */
- (void)paySuccessJumpTo{
    [TalkingData trackEvent:@"支付成功/支付失败"];
    
        [UIHelper toast:@"支付成功"];
        [self.navigationController popViewControllerAnimated:NO];
        [[UserData sharedInstance] setIsUpdateWithMyInfo:YES];
        [[UserData sharedInstance] setIsUpdateWithMyInfoRecuit:YES];
        [WDNotificationCenter postNotificationName:IMNotification_EPMainHeaderViewUpdate object:nil];
    
        MKBlockExec(self.updateDataBlock, nil);
    
}
#pragma mark - ***** 微信支付 ******
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

/** 微信回调 支付成功*/
- (void)wecharPayResponseInfo:(NSNotification *)notification{
    ELog("=======wecharPayResponseInfo");
    [self paySuccessJumpTo];
}


#pragma mark - ***** aliPay ******
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
                [weakSelf paySuccessJumpTo];
                [UIHelper toast:@"支付成功"];
            }else{
                [UIHelper toast:@"支付失败"];
            }
        }];
    }
}
@end


