//
//  EditEmployerInfo_VC.m
//  jianke
//
//  Created by xiaomk on 16/3/2.
//  Copyright © 2016年 xianshijian. All rights reserved.
//

#import "EditEmployerInfo_VC.h"
#import "WDConst.h"
#import "MKCommonHelper.h"
#import "EditEPInfoCell.h"
#import "IdentityCardAuth_VC.h"
#import "EPVerity_VC.h"
#import "UIPlaceHolderTextView.h"
#import "EditEPInfoDetailCell.h"
#import "EditEmployerHeaderView.h"
#import "CitySelectController.h"
#import "ApplyServiceCell_desc.h"
#import "GuideMaskView.h"

@interface EditEmployerInfo_VC ()<UIActionSheetDelegate,UINavigationBarDelegate,EditEPInfoCellDelegate, EditEmployerHeaderViewDelegate>{
    NSString* _headImgUrl;

}

@property (nonatomic, strong) UITextView* tvEditEPInfo;
@property (nonatomic, strong) EditEmployerHeaderView *myHeaderView;

@end

@implementation EditEmployerInfo_VC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"编辑雇主信息";
//    self.btntitles = @[@"保存"];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self action:@selector(keepInfoAction)];
    
    [self initUIWithType:DisplayTypeOnlyTableView];
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view exchangeSubviewAtIndex:0 withSubviewAtIndex:2];
    
    //header
    EditEmployerHeaderView *headerView = [[EditEmployerHeaderView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-96, 24, 80, 80)];
    headerView.backgroundColor = [UIColor XSJColor_blackBase];
    [headerView setCornerValue:40.0f];
    headerView.delegate = self;
    self.myHeaderView = headerView;
    self.myHeaderView.utf.hidden = YES;
    self.myHeaderView.iconImgView.hidden = YES;
    self.myHeaderView.labName.hidden = YES;
    self.myHeaderView.botLine.hidden = YES;
    self.myHeaderView.leftLine.hidden = YES;
//    self.topView.height = 140;
    [self.view addSubview:headerView];
    
    [self.myHeaderView setEpModel:self.epModel];
    

    
    [self.dataSource addObject:@(ApplySerciceCellType_trueName)];
    [self.dataSource addObject:@(ApplySerciceCellType_hireCity)];
    [self.dataSource addObject:@(ApplySerciceCellType_industry)];
    if ([self.epModel.industry_name isEqualToString:@"其他行业"]) {
        [self.dataSource addObject:@(ApplySerciceCellType_industryDesc)];
    }
    [self.dataSource addObject:@(ApplySerciceCellType_companyName)];
    [self.dataSource addObject:@(ApplySerciceCellType_abbreviationName)];
   

    

}

- (void)getData{
    WEAKSELF
    [[UserData sharedInstance] getEPModelWithBlock:^(EPModel *epModel) {
        if (epModel) {
            weakSelf.epModel = [NSKeyedUnarchiver unarchiveObjectWithData:[NSKeyedArchiver archivedDataWithRootObject:epModel]];
            [weakSelf.myHeaderView setEpModel:self.epModel];
            [weakSelf.tableView reloadData];
        }
    }];
}

#pragma mark - UITableView delegate
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ApplySerciceCellType cellType = [[self.dataSource objectAtIndex:indexPath.row]integerValue];
    
    if(indexPath.section == 0){
        switch (cellType) {
            case ApplySerciceCellType_trueName:
            case ApplySerciceCellType_hireCity:
            case ApplySerciceCellType_industry:
            case ApplySerciceCellType_companyName:
            case ApplySerciceCellType_abbreviationName:{
                EditEPInfoCell* cell = [EditEPInfoCell cellWithTableView:tableView];
                cell.delegate = self;
                [cell setData:_epModel atIndexPath:cellType];
                return cell;
            }
            case ApplySerciceCellType_industryDesc:{
                
                //            ApplyServiceCell_desc *cell = [tableView dequeueReusableCellWithIdentifier:@"ApplyServiceCell_desc" forIndexPath:indexPath];
                ApplyServiceCell_desc *cell = [[ApplyServiceCell_desc alloc]init];
                cell.placeHolder = @"请输入行业名称";
                
                [cell setEpModel:_epModel cellType:cellType];
                
                return cell;
                
            }
                
            default:
                break;
        }
    }
   if (indexPath.section == 1){
        static NSString* editIdentifie = @"editCell";
        EditEPInfoDetailCell* cell = [tableView dequeueReusableCellWithIdentifier:editIdentifie];
        if (!cell) {
            cell = [EditEPInfoDetailCell new];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        self.tvEditEPInfo = cell.tfEPDetail;
        cell.tfEPDetail.placeholder = @"公司简介能增加求职者的信任感......";
        cell.tfEPDetail.backgroundColor = [UIColor XSJColor_newWhite];
        cell.tfEPDetail.font = [UIFont systemFontOfSize:16];
        cell.tfEPDetail.scrollEnabled = YES;
        cell.tfEPDetail.maxLength = 200;
        cell.tfEPDetail.text = self.epModel.desc.length && ![self.epModel.desc isEqualToString:@" "] ? self.epModel.desc : @"";
        cell.tfEPDetail.placeholderColor = MKCOLOR_RGB(180, 180, 185);
        return cell;
    }
    return nil;
}



- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView* view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.size.width, 32)];
    view.backgroundColor = [UIColor XSJColor_grayTinge];
    UILabel* labTitle = [[UILabel alloc] initWithFrame:CGRectMake(16, 0, 200, 32)];
    labTitle.textColor = MKCOLOR_RGBA(34, 58, 80, 0.64);
    labTitle.font = [UIFont systemFontOfSize:12];
    [view addSubview:labTitle];
    
    if (section == 1){
        labTitle.text = @"公司简介";
    }
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 1) {
        return 32;
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    ApplySerciceCellType cellType = [[self.dataSource objectAtIndex:indexPath.row]integerValue];
    if (indexPath.section == 0) {
        switch (cellType) {
            case ApplySerciceCellType_trueName:
            case ApplySerciceCellType_hireCity:
            case ApplySerciceCellType_industry:
            case ApplySerciceCellType_companyName:
            case ApplySerciceCellType_abbreviationName:{
                return 75;
            }
            case ApplySerciceCellType_industryDesc:{
                return 45;
            }
            default:
                break;
        }
        
    }else if (indexPath.section == 1){
        return 140;
    }
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return self.dataSource.count;
    }else if (section == 1){
        return 1;
    }
    return 0;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0) {
        switch (indexPath.row) {
            case 0:{
                
                }
                break;
            case 1:{
                [self selectHireCity];
                
            }
                break;
            case 2:{
                [self selectIndustry];
            }
                break;
            case 3:{
                if (self.epModel.verifiy_status.integerValue == 1 || self.epModel.verifiy_status.integerValue == 4) {
                    [self btnEPAuthOnclick];
                }

            }
                break;
            default:
                break;
        }
    }
}

#pragma mark - uiscrollview delegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
//    ELog(@"%f",scrollView.contentOffset.y);
    CGFloat cy = scrollView.contentOffset.y;
    if (cy <= 0) {
        cy = cy * (-1);
        self.topView.transform = CGAffineTransformMakeScale(1 + cy/70, 1+ cy/70);
    }else if(!CGAffineTransformIsIdentity(self.topView.transform)){
        self.topView.transform = CGAffineTransformIdentity;
    }
//    ELog(@"--%f",self.topView.height);
}

#pragma mark - 按钮事件

//个人完成认证不能修改
- (void)alertNameMsg {
//    UIButton *btn = [[UIButton alloc]init];
//    btn.frame = self.tfTureName.bounds;
//    [self.tfTureName addSubview:btn];
//    [btn addTarget:self action:@selector(nameAlreadyAuthing) forControlEvents:UIControlEventTouchUpInside];
//    self.tfTureName.textColor = [UIColor grayColor];
}

//完成认证提示消息
-(void)nameAlreadyAuthing {
    if (self.epModel.id_card_verify_status.intValue == 2 ) {
        [UIHelper toast:@"正在认证中..."];
    } else if (self.epModel.id_card_verify_status.intValue == 3) {
        [UIHelper toast:@"已完成认证不能修改"];
    }
}

////企业完成认证不能修改
//- (void)alertEpNameMsg {
//    UIButton *btn = [[UIButton alloc]init];
//    btn.frame = self.tfEPName.bounds;
//    [self.tfEPName addSubview:btn];
//    [btn addTarget:self action:@selector(epAlreadyAuthing) forControlEvents:UIControlEventTouchUpInside];
//    self.tfEPName.textColor = [UIColor grayColor];
//}

////完成认证提示消息
//-(void)epAlreadyAuthing {
//    if (self.epModel.verifiy_status.intValue == 2 ) {
//        [UIHelper toast:@"正在认证中..."];
//    } else if (self.epModel.verifiy_status.intValue == 3 ) {
//        [UIHelper toast:@"已完成认证不能修改"];
//    }
//}
- (void)showBombBox:(NSInteger)tag{
    switch (tag) {
        case 1:
            [GuideMaskView showTitle:@"提示" content:@"通过“实名认证”或处于“实名认证中”的用户不能再修改姓名哦~" cancel:nil commit:@"我知道了" block:^(NSInteger result) {
                
            }];
            break;
        case 2:
            [GuideMaskView showTitle:@"提示" content:@"通过企业认证或处于“企业认证中”的用户不能直接修改企业名称哦~可到【认证】页去修改" cancel:nil commit:@"我知道了" block:^(NSInteger result) {
                
            }];
            break;
        default:
            break;
    }
    

}

- (void)pushAction:(EditEpCellType)type{
    if (type == EditEpCellType_Name) {
        [self btnAuthUserNameOnclick];
    }else if (type == EditEpCellType_Enterprase){
        [self btnEPAuthOnclick];
    }
}


//实名认证
- (void)btnAuthUserNameOnclick{
    IdentityCardAuth_VC* vc = [[IdentityCardAuth_VC alloc] init];
    WEAKSELF
    vc.block = ^(BOOL obj){
        [weakSelf getData];
    };
    [self.navigationController pushViewController:vc animated:YES];
}

//企业认证
- (void)btnEPAuthOnclick{
    EPVerity_VC *vc=[[EPVerity_VC alloc] init];
//    WEAKSELF
//    vc.block = ^(id obj){
//        [weakSelf getData];
//    };
    [self.navigationController pushViewController:vc animated:YES];
}

//保存按钮
//- (void)clickOnview:(UIView *)bottomView clickedButtonAtIndex:(NSInteger)buttonIndex{
- (void)keepInfoAction{
    [TalkingData trackEvent:@"雇主信息_编辑保存"];
    if (self.epModel.true_name.length == 0 || self.epModel.true_name.length > 10) {
        [UIHelper toast:@"请输入正确姓名"];
        return;
    }
    if (self.epModel.email.length > 0) {
        if (![MKCommonHelper validateEmail:self.epModel.email]) {
            [UIHelper toast:@"邮箱格式有误，请输入有效果的邮箱"];
            return;
        }
    }
    if (self.epModel.industry_name.length) {
        if ([self.epModel.industry_name isEqualToString:@"其他行业"]) {
            if (!self.epModel.industry_desc.length){
                 [UIHelper toast:@"请输入涉及行业"];
                return;
            }
        }
       
    }else{
         [UIHelper toast:@"请输入涉及行业"];
        return;
    }
    
    [self sendMsg];
}

- (void)sendMsg {
    PostEPInfo *model = [[PostEPInfo alloc]init];
    model.true_name = self.epModel.true_name;
    model.enterprise_name = self.epModel.enterprise_name;
    
    if (!self.epModel.ent_short_name.length) {
        model.ent_short_name = @" ";
    }else{
        model.ent_short_name = self.epModel.ent_short_name;
    }
    if (_headImgUrl.length > 0) {
        model.profile_url = _headImgUrl;
    }
    if (!self.tvEditEPInfo.text.length) {
        model.desc = @" ";
    }else{
        model.desc = self.tvEditEPInfo.text;
    }
    model.city_id = self.epModel.city_id;
    model.industry_id = self.epModel.industry_id;
    if ([self.epModel.industry_name isEqualToString:@"其他行业"]) {
        model.industry_desc = self.epModel.industry_desc;
    }
    
//    ELog(@"========_headImgUrl%@",_headImgUrl);
    NSString* content = [model getContent];
    
    RequestInfo* request = [[RequestInfo alloc] initWithService:@"shijianke_postEnterpriseBasicInfo_V1" andContent:content];
    request.isShowLoading = YES;
    WEAKSELF
    [request sendRequestWithResponseBlock:^(ResponseInfo *response) {
        if (response && [response success]) {
            [UIHelper toast:@"保存信息成功！"];
//            [weakSelf updateResume];
            [[UserData sharedInstance] setIsUpdateWithMyInfo:YES];
            [weakSelf.navigationController popViewControllerAnimated:YES];
        }
    }];
}

/** 更新雇主简历 */
- (void)updateResume{
    [[UserData sharedInstance] getEPModelWithBlock:^(EPModel *model) {
        [WDNotificationCenter postNotificationName:WDNotifi_updateEPResume object:self];
    }];
}

//返回提示
-(void)backToLastView{
    [self.view endEditing:YES];
    WEAKSELF
    [UIHelper showConfirmMsg:@"您还未保存，确定要退出吗？" completion:^(DLAVAlertView *alertView, NSInteger buttonIndex) {
        if (buttonIndex == 0) {
            return;
        }else{
            [weakSelf.navigationController popViewControllerAnimated:YES];
        }
    }];
}

#pragma mark - 修改头像
- (void)btnHeadOnclick{
    UIActionSheet* menu = [[UIActionSheet alloc] initWithTitle:@"请选择图片来源" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照上传",@"从相册上传", nil];
    menu.actionSheetStyle = UIActionSheetStyleBlackTranslucent;
    [menu showInView:self.view];
}

- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 2) {
        return;
    }
    WEAKSELF
    [UIDeviceHardware getCameraAuthorization:^(id obj) {
        UIImagePickerControllerSourceType type = UIImagePickerControllerSourceTypeCamera;
        if (buttonIndex == 0) {
            type = UIImagePickerControllerSourceTypeCamera;
        }else if (buttonIndex == 1){
            type = UIImagePickerControllerSourceTypePhotoLibrary;
        }
        [[UIPickerHelper sharedInstance] presentImagePickerOnVC:weakSelf sourceType:type finish:^(NSDictionary *info) {
            UIImage* image = [info objectForKey:UIImagePickerControllerEditedImage];
            UIImage* newImage = image;
            NSString* uploadImageName = [NSString stringWithFormat:@"%@%@",@"shijiankehead_postEditEpInfoHead",@".jpg"];
            [weakSelf saveImage:newImage withName:uploadImageName];
            [weakSelf performSelector:@selector(selectPic:) withObject:newImage afterDelay:0.1];
        }];
    }];
}

- (void)selectPic:(UIImage*)image{
    
    RequestInfo* info = [[RequestInfo alloc] init];
    WEAKSELF
    [info uploadImage:image andBlock:^(NSString* imageUrl) {
        _headImgUrl = imageUrl;
        _epModel.profile_url = imageUrl;
        [weakSelf.myHeaderView setEpModel:_epModel];
    }];
}

- (UIImage*)imageWithImageSimple:(UIImage*)image scaledToSize:(CGSize)newSize{
    newSize.height = image.size.height*(newSize.width/image.size.width);
    UIGraphicsBeginImageContext(newSize);
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

- (void)saveImage:(UIImage*)tempImage withName:(NSString*)imageName{
    NSData* imageData = UIImagePNGRepresentation(tempImage);
    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString* documentsDirectory = [paths objectAtIndex:0];
    NSString* fullPathToFile = [documentsDirectory stringByAppendingPathComponent:imageName];
    
    imageName = fullPathToFile;
    __unused NSArray* nameAry = [imageName componentsSeparatedByString:@"/"];
//    ELog(@"===new fullPathToFile===%@",fullPathToFile);
//    ELog(@"===new FileName===%@",[nameAry objectAtIndex:[nameAry count]-1]);

    [imageData writeToFile:fullPathToFile atomically:NO];
}

#pragma mark - 编辑信息业务
- (void)selectHireCity{
    CitySelectController *viewCtrl = [[CitySelectController alloc] init];
    viewCtrl.isPushAction = YES;
    WEAKSELF
    viewCtrl.didSelectCompleteBlock = ^(CityModel *cityModel){
        if (cityModel) {
            weakSelf.epModel.city_id = cityModel.id;
            weakSelf.epModel.city_name = cityModel.name;
            [weakSelf.tableView reloadData];
        }
    };
    [self.navigationController pushViewController:viewCtrl animated:YES];
}

- (void)selectIndustry{
    WEAKSELF
    [[XSJRequestHelper sharedInstance] getClientGlobalInfoWithBlock:^(ClientGlobalInfoRM *globalInfo) {
        if (globalInfo) {
            NSArray *array = [globalInfo.industry_info_list valueForKey:@"industry_name"];
            NSArray *idArray = [globalInfo.industry_info_list valueForKey:@"industry_id"];
            [MKActionSheet sheetWithTitle:@"请选择涉及行业" buttonTitleArray:array isNeedCancelButton:YES maxShowButtonCount:5 block:^(MKActionSheet *actionSheet, NSInteger buttonIndex) {
                if (buttonIndex < idArray.count) {
                    weakSelf.epModel.industry_id = [idArray objectAtIndex:buttonIndex];
                    weakSelf.epModel.industry_name = [array objectAtIndex:buttonIndex];
                    if (buttonIndex == 0 && self.dataSource.count == 5) {
                        [self.dataSource insertObject:@(ApplySerciceCellType_industryDesc) atIndex:3];
//                        [self.dataSource addObject:@(ApplySerciceCellType_industryDesc)];
                    }else if(![weakSelf.epModel.industry_name isEqualToString:@"其他行业"]){
                        
                        [self.dataSource removeObject:@(ApplySerciceCellType_industryDesc)];
                    }

                    [weakSelf.tableView reloadData];
                }
            }];
        }
    }];

}

#pragma mark - EditEmployerHeaderViewDelegate

- (void)editEmployerHeaderView:(EditEmployerHeaderView *)headView actionType:(BtnOnClickActionType)actionType{
    switch (actionType) {
        case BtnOnClickActionType_uploadHeadImg:{
            [self btnHeadOnclick];
        }
            break;
        case BtnOnClickActionType_idAuthAction:{
            [self btnAuthUserNameOnclick];
        }
            break;
        default:
            break;
    }
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
