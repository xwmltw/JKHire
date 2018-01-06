
//
//  EPVerity_VC.m
//  JKHire
//
//  Created by yanqb on 2017/4/18.
//  Copyright © 2017年 xianshijian. All rights reserved.
//

#import "EPVerity_VC.h"
#import "WebView_VC.h"

@interface EPVerity_VC (){
    NSString* _headImgUrl;
    NSString *_idCardImgUrl;
    BOOL _isAgree;
}

@property (nonatomic, strong) EPModel* epModel;

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UITextField *utfEPName;
@property (nonatomic, strong) UITextField *utfEPIdentifier;
@property (nonatomic, strong) UIImageView *imgBusiness;
@property (nonatomic, strong) UIImageView *imgIdCard;

@property (nonatomic, strong) UIButton *btnUploadBusiness;
@property (nonatomic, strong) UIButton *btnUploadIdCard;
@property (nonatomic, strong) UIButton *btnConfirm;

@end

@implementation EPVerity_VC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"企业认证";
    [self setupViews];
    [self getLatestVerifyInfo];
}

- (void)setupViews{
    self.scrollView = [[UIScrollView alloc] init];
    
    self.utfEPName = [[UITextField alloc] init];
    self.utfEPName.backgroundColor = MKCOLOR_RGBA(34, 58, 80, 0.03);
    self.utfEPName.font = [UIFont systemFontOfSize:14.0f];
    self.utfEPName.placeholder = @"填写公司名称，要与营业执照上的名称完全一致";
    UIView *leftview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 20)];
    leftview.backgroundColor = [UIColor clearColor];
    self.utfEPName.leftView = leftview;
    self.utfEPName.leftViewMode = UITextFieldViewModeAlways;
    [self.utfEPName addTarget:self action:@selector(utfEPNameOnChange:) forControlEvents:UIControlEventEditingChanged];
    
    self.utfEPIdentifier = [[UITextField alloc] init];
    self.utfEPIdentifier.backgroundColor = MKCOLOR_RGBA(34, 58, 80, 0.03);
    self.utfEPIdentifier.font = [UIFont systemFontOfSize:14.0f];
    self.utfEPIdentifier.placeholder = @"营业执照号";
    UIView *leftview1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 20)];
    leftview1.backgroundColor = [UIColor clearColor];
    self.utfEPIdentifier.leftView = leftview1;
    self.utfEPIdentifier.leftViewMode = UITextFieldViewModeAlways;
    [self.utfEPName addTarget:self action:@selector(utfEPIdentifierOnChange:) forControlEvents:UIControlEventEditingChanged];
    
    UILabel *lab1 = [UILabel labelWithText:@"1.请上传营业执照" textColor:[UIColor XSJColor_tGrayDeepTransparent32] fontSize:14.0f];
    UIImageView *imgBg1 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"mask_bg_icon"]];
    UIImageView *img1 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_upload"]];
    UILabel *lab2 = [UILabel labelWithText:@"上传营业执照" textColor:[UIColor XSJColor_base] fontSize:16.0f];
    self.imgBusiness = [[UIImageView alloc] init];
    [self.imgBusiness setCornerValue:2.0f];
    self.btnUploadBusiness = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.btnUploadBusiness addTarget:self action:@selector(btnUploadBusinessOnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    UILabel *lab3 = [UILabel labelWithText:@"2. 请上传法人身份证正面  或者  经办人身份证正面和工牌(或名片)的合照" textColor:[UIColor XSJColor_tGrayDeepTransparent32] fontSize:14.0f];
    UIImageView *imgBg2 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"mask_bg_icon"]];
    lab3.numberOfLines = 0;
    UIImageView *img2 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_upload"]];
    UILabel *lab4 = [UILabel labelWithText:@"上传身份证明" textColor:[UIColor XSJColor_base] fontSize:16.0f];
    self.imgIdCard = [[UIImageView alloc] init];
    [self.imgIdCard setCornerValue:2.0f];
    self.imgIdCard = [[UIImageView alloc] init];
    self.btnUploadIdCard = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.btnUploadIdCard addTarget:self action:@selector(btnUploadIdCardOnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    UILabel *viewLabel = [UILabel labelWithText:@"已阅读，并同意" textColor:[UIColor XSJColor_tGrayDeepTransparent2] fontSize:13.0f];
    
    UIButton *selectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [selectBtn setImage:[UIImage imageNamed:@"v230_building_checkbox"] forState:UIControlStateNormal];
    [selectBtn setImage:[UIImage imageNamed:@"frequent_icon_checkbox"] forState:UIControlStateSelected];
    selectBtn.selected = YES;
    _isAgree = YES;
    [selectBtn addTarget:self action:@selector(boxBtnOnClick:) forControlEvents:UIControlEventTouchUpInside];
    UIButton *dutyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [dutyBtn setTitle:@"[雇主认证承诺书]" forState:UIControlStateNormal];
    [dutyBtn setTitleColor:[UIColor XSJColor_tGrayDeepTransparent80] forState:UIControlStateNormal];
    dutyBtn.titleLabel.font = [UIFont systemFontOfSize:13.0f];
    [dutyBtn addTarget:self action:@selector(dutyBtnOnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    self.btnConfirm = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.btnConfirm setTitle:@"确定" forState:UIControlStateNormal];
    self.btnConfirm.backgroundColor = [UIColor XSJColor_base];
    [self.btnConfirm setCornerValue:2.0f];
    self.btnConfirm.titleLabel.font = [UIFont systemFontOfSize:17.0f];
    [self.btnConfirm addTarget:self action:@selector(btnConfirmOnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:self.scrollView];
    [self.scrollView addSubview:self.utfEPName];
    [self.scrollView addSubview:self.utfEPIdentifier];
    [self.scrollView addSubview:imgBg1];
    [self.scrollView addSubview:lab1];
    [self.scrollView addSubview:img1];
    [self.scrollView addSubview:lab2];
    [self.scrollView addSubview:self.imgBusiness];
    [self.scrollView addSubview:imgBg2];
    [self.scrollView addSubview:img2];
    [self.scrollView addSubview:lab4];
    [self.scrollView addSubview:self.imgIdCard];
    [self.scrollView addSubview:lab3];
    [self.scrollView addSubview:self.btnConfirm];
    [self.scrollView addSubview:self.btnUploadBusiness];
    [self.scrollView addSubview:self.btnUploadIdCard];
    [self.scrollView addSubview:selectBtn];
    [self.scrollView addSubview:viewLabel];
    [self.scrollView addSubview:dutyBtn];
    
    CGFloat height = 813;
    
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    self.scrollView.contentSize = CGSizeMake(SCREEN_WIDTH, height);
    
    [self.utfEPName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.scrollView).offset(24);
        make.left.equalTo(self.scrollView).offset(12);
        make.right.equalTo(self.scrollView).offset(-12);
        make.width.equalTo(@(SCREEN_WIDTH - 24));
        make.height.equalTo(@52);
    }];
    
    [self.utfEPIdentifier mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.utfEPName.mas_bottom).offset(4);
        make.left.equalTo(self.scrollView).offset(12);
        make.right.equalTo(self.scrollView).offset(-12);
        make.height.equalTo(@52);
    }];
    
    [lab1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.utfEPIdentifier.mas_bottom).offset(16);
        make.left.equalTo(self.scrollView).offset(16);
    }];
    
    [self.imgBusiness mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lab1.mas_bottom).offset(16);
        make.left.equalTo(self.scrollView).offset(12);
        make.right.equalTo(self.scrollView).offset(-12);
        make.height.equalTo(@220);
    }];
    
    [imgBg1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.imgBusiness).offset(-2);
        make.left.equalTo(self.scrollView).offset(10);
        make.right.equalTo(self.scrollView).offset(-10);
        make.bottom.equalTo(self.imgBusiness).offset(2);
    }];
    
    [img1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.imgBusiness);
        make.centerY.equalTo(self.imgBusiness).offset(-22);
    }];
    
    [lab2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.imgBusiness);
        make.centerY.equalTo(self.imgBusiness).offset(22);
    }];
    
    [imgBg2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.imgIdCard).offset(-2);
        make.left.equalTo(self.scrollView).offset(10);
        make.right.equalTo(self.scrollView).offset(-10);
        make.bottom.equalTo(self.imgIdCard).offset(2);
    }];
    
    [self.btnUploadBusiness mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.imgBusiness);
    }];
    
    [lab3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.imgBusiness.mas_bottom).offset(24);
        make.left.equalTo(self.scrollView).offset(12);
        make.right.equalTo(self.scrollView).offset(-12);
    }];
    
    [self.imgIdCard mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lab3.mas_bottom).offset(16);
        make.left.equalTo(self.scrollView).offset(12);
        make.right.equalTo(self.scrollView).offset(-12);
        make.height.equalTo(@220);
    }];
    
    [img2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.imgIdCard);
        make.centerY.equalTo(self.imgIdCard).offset(-22);
    }];
    
    [lab4 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.imgIdCard);
        make.centerY.equalTo(self.imgIdCard).offset(22);
    }];
    
    [self.btnUploadIdCard mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.imgIdCard);
    }];
    
    [selectBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.imgIdCard.mas_bottom).offset(10);
        make.left.equalTo(self.scrollView).offset(12);
    }];
    
    [viewLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(selectBtn);
        make.left.equalTo(selectBtn.mas_right).offset(2);
    }];
    
    [dutyBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(viewLabel);
        make.left.equalTo(viewLabel.mas_right);
    }];
    
    [self.btnConfirm mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.imgIdCard.mas_bottom).offset(49);
        make.left.equalTo(self.scrollView).offset(12);
        make.right.equalTo(self.scrollView).offset(-12);
        make.height.equalTo(@44);
        make.bottom.equalTo(self.scrollView).offset(-16);
    }];
}

- (void)getLatestVerifyInfo{
    WEAKSELF
    [[XSJRequestHelper sharedInstance] getLatestVerifyInfo:^(ResponseInfo *result) {
        weakSelf.epModel = [EPModel objectWithKeyValues:[result.content objectForKey:@"account_info"]];
        EPModel *tmpModel = [EPModel objectWithKeyValues:[result.content objectForKey:@"last_business_licence_verify_info"]];
        weakSelf.epModel.enterprise_name = tmpModel.enterprise_name;
        weakSelf.epModel.regist_num = tmpModel.regist_num;
        weakSelf.epModel.business_licence_url = tmpModel.business_licence_url;
        weakSelf.epModel.extra_verify_pic_url = tmpModel.extra_verify_pic_url;
        [weakSelf updateData];
    }];
}

- (void)updateData{
    if (self.epModel.enterprise_name) {
        self.utfEPName.text = self.epModel.enterprise_name;
    }
//    self.readedEpPromise.selected = YES;
    if (self.epModel.regist_num && self.epModel.regist_num.length) {
        self.utfEPIdentifier.text = [NSString stringWithFormat:@"%@",self.epModel.regist_num];
    }
    if (self.epModel.business_licence_url.length) {
        [self.imgBusiness sd_setImageWithURL:[NSURL URLWithString:self.epModel.business_licence_url]];
        _headImgUrl = self.epModel.business_licence_url;
    }
    if (self.epModel.extra_verify_pic_url.length) {
        [self.imgIdCard sd_setImageWithURL:[NSURL URLWithString:self.epModel.extra_verify_pic_url]];
        _idCardImgUrl = self.epModel.extra_verify_pic_url;
    }
    
    if (self.epModel.business_licence_url.length) {
        [self.btnConfirm setTitle:@"重新提交" forState:UIControlStateNormal];
    }else{
        [self.btnConfirm setTitle:@"保存" forState:UIControlStateNormal];
    }
}

#pragma mark - 事件方法

- (void)boxBtnOnClick:(UIButton *)sender{
    sender.selected = !sender.selected;
    _isAgree = !_isAgree;
}

- (void)dutyBtnOnClick:(UIButton *)sender{
    WebView_VC* vc = [[WebView_VC alloc] init];
    vc.url = [NSString stringWithFormat:@"%@%@", URL_HttpServer, kUrl_entPromise];
    vc.title = @"雇主认证承诺书";
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)utfEPNameOnChange:(UITextField *)sender{
    [TalkingData trackEvent:@"企业认证_企业名称"];
    if (sender.text.length > 30) {
        sender.text = [sender.text substringToIndex:30];
    }
}

- (void)utfEPIdentifierOnChange:(UITextField *)sender{
    [TalkingData trackEvent:@"企业认证_营业执照号"];
    if (sender.text.length > 26) {
        sender.text = [sender.text substringToIndex:26];
    }
}

- (void)btnUploadBusinessOnClick:(UIButton *)sender{
    [self.view endEditing:YES];
    [self postImage:100];
}

- (void)btnUploadIdCardOnClick:(UIButton *)sender{
    [self.view endEditing:YES];
    [self postImage:101];
}

- (void)btnConfirmOnClick:(UIButton *)sender{
    if (!self.utfEPName.text.length ) {
        [UIHelper toast:@"名称不能为空"];
        return;
    }
    
    if (self.utfEPName.text.length < 2 || self.utfEPName.text.length > 30) {
        [UIHelper toast:@"名称长度只能在2-30个汉字或字母"];
        return;
    }
    
    if (self.utfEPIdentifier.text.length < 2 || self.utfEPIdentifier.text.length > 30) {
        [UIHelper toast:@"请输入有效的营业执照号码"];
        return;
    }
    
    if (!_headImgUrl.length) {
        [UIHelper toast:@"请上传营业执照照片!"];
        return;
    }
    
    if (!_idCardImgUrl) {
        [UIHelper toast:@"请上传身份证明照片!"];
        return;
    }
    
    if (!_isAgree) {
        [UIHelper toast:@"请阅读并确认同意雇主认证承诺书的内容!"];
        return;
    }

    [self sendMsg];


}

- (void)sendMsg{
    [TalkingData trackEvent:@"雇主个人中心_企业认证确定"];
    NSString* content = [NSString stringWithFormat:@"enterprise_name:\"%@\",regist_num:\"%@\",business_licence_url:\"%@\",\"extra_verify_pic_url\":\"%@\"",self.utfEPName.text, self.utfEPIdentifier.text,_headImgUrl, _idCardImgUrl];
    
    RequestInfo* request = [[RequestInfo alloc] initWithService:@"shijianke_entLicenseInfoVerify" andContent:content];
    request.isShowLoading = YES;
    [request sendRequestWithResponseBlock:^(ResponseInfo *response) {
        if (response && [response success]) {
            [UIHelper toast:@"提交成功！"];
            [[UserData sharedInstance] setIsUpdateWithMyInfo:YES];
            [[UserData sharedInstance] getEPModelWithBlock:^(id result) {
            }];
            MKBlockExec(self.block, nil);
            if (self.isPopLast) {
                [self.navigationController popViewControllerAnimated:YES];
            }else{
                [self.navigationController popToRootViewControllerAnimated:YES];
            }
        }else{
            [UIHelper toast:@"提交失败，请重新提交！"];
        }
    }];

}

- (void)postImage:(NSUInteger)tag{
    [TalkingData trackEvent:@"企业认证_上传营业执照"];
    UIActionSheet *menu = [[UIActionSheet alloc] initWithTitle:@"请选择图片来源" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照上传",@"从相册上传", nil];
    menu.actionSheetStyle=UIActionSheetStyleBlackTranslucent;
    menu.tag = tag;
    [menu showInView:self.view];
}

/** ActionSheet选择相应事件 */
- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex{
    //按了取消
    if (buttonIndex == 2) {
        return;
    }
    WEAKSELF
    [UIDeviceHardware getCameraAuthorization:^(id obj) {
        UIImagePickerControllerSourceType type = UIImagePickerControllerSourceTypeCamera;
        if(buttonIndex == 0){
            type = UIImagePickerControllerSourceTypeCamera;
        }else if(buttonIndex == 1){
            type = UIImagePickerControllerSourceTypePhotoLibrary;
        }
        [[UIPickerHelper sharedInstance] presentImagePickerOnVC:weakSelf sourceType:type finish:^(NSDictionary *info) {
            UIImage * image = [info objectForKey:UIImagePickerControllerEditedImage];
            UIImage *newImg = image;
            if (actionSheet.tag == 100) {
                [weakSelf performSelector:@selector(selectPic:) withObject:newImg afterDelay:0.1];
            }else{
                [weakSelf performSelector:@selector(selectIdCardPic:) withObject:newImg afterDelay:0.1];
            }
            
        }];
    }];
}

/** 设置营业执照照显示 */
- (void)selectPic:(UIImage*)image
{
    self.imgBusiness.image = image;
    
    RequestInfo* info = [[RequestInfo alloc] init];
    [info uploadImage:image andBlock:^(NSString* imageUrl) {
        _headImgUrl = imageUrl;
    }];
}

- (void)selectIdCardPic:(UIImage *)image{
    self.imgIdCard.image = image;
    RequestInfo* info = [[RequestInfo alloc] init];
    [info uploadImage:image andBlock:^(NSString* imageUrl) {
        _idCardImgUrl = imageUrl;
    }];
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
