//
//  ApplyService_VC.m
//  JKHire
//
//  Created by fire on 16/11/5.
//  Copyright © 2016年 xianshijian. All rights reserved.
//

#import "ApplyService_VC.h"
#import "CitySelectController.h"
#import "ApplyServiceCell_0.h"
#import "ApplyServiceCell_1.h"
#import "ApplyServiceCell_desc.h"
#import "EPVerity_VC.h"
#import "WebView_VC.h"

@interface ApplyService_VC () <ApplyServiceCell_0Delegate, UIActionSheetDelegate>{
    NSString* _headImgUrl;
}

@property (nonatomic, strong) EPModel *epModel;
@property (nonatomic, weak) UIImageView *imageView;

@end

@implementation ApplyService_VC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadDatas];
    self.epModel = [NSKeyedUnarchiver unarchiveObjectWithData:[NSKeyedArchiver archivedDataWithRootObject:[[UserData sharedInstance] getEpModelFromHave]]];
    WEAKSELF
    [[UserData sharedInstance]getEPModelWithBlock:^(EPModel* model) {
        _epModel = [NSKeyedUnarchiver unarchiveObjectWithData:[NSKeyedArchiver archivedDataWithRootObject:model]];
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf.tableView reloadData];
        });
    }];
    
    self.btntitles = self.isPostAction ? @[@"下一步"] : @[@"保存"];
    [self initUIWithType:DisplayTypeTableViewAndTopBottom];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self registerCells];
    [self setupTopView];
    
}

- (void)setupTopView{
    self.topView.height = 140.0f;
    self.topView.backgroundColor = [UIColor XSJColor_blackBase];
    UIImageView *imageView = [[UIImageView alloc] init];
    [imageView sd_setImageWithURL:[NSURL URLWithString:_epModel.profile_url] placeholderImage:[UIHelper getDefaultHead]];
    _imageView = imageView;
    [imageView setCornerValue:35.0f];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setCornerValue:35.0f];
    [button addTarget:self action:@selector(btnHeadOnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.topView addSubview:imageView];
    [self.topView addSubview:button];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.topView);
        make.height.width.equalTo(@70);
    }];
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(imageView);
    }];
}

- (void)loadDatas{
    [self.dataSource addObject:@(ApplySerciceCellType_serviceName)];
    [self.dataSource addObject:@(ApplySerciceCellType_city)];
    [self.dataSource addObject:@(ApplySerciceCellType_name)];
    [self.dataSource addObject:@(ApplySerciceCellType_telphone)];
    [self.dataSource addObject:@(ApplySerciceCellType_summary)];
}

- (void)registerCells{
    [self.tableView registerNib:nib(@"ApplyServiceCell_0") forCellReuseIdentifier:@"ApplyServiceCell_0"];
    [self.tableView registerClass:[ApplyServiceCell_1 class] forCellReuseIdentifier:@"ApplyServiceCell_1"];
    [self.tableView registerClass:[ApplyServiceCell_desc class] forCellReuseIdentifier:@"ApplyServiceCell_desc"];
}

#pragma mark - uitableview datasource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ApplySerciceCellType cellType = [[self.dataSource objectAtIndex:indexPath.row] integerValue];
    switch (cellType) {
        case ApplySerciceCellType_serviceName:
        case ApplySerciceCellType_name:
        case ApplySerciceCellType_telphone:{
            ApplyServiceCell_0 *cell = [tableView dequeueReusableCellWithIdentifier:@"ApplyServiceCell_0" forIndexPath:indexPath];
            cell.delegate = self;
            [cell setModel:self.epModel cellType:cellType];
            return cell;
        }
        case ApplySerciceCellType_city:{
            ApplyServiceCell_1 *cell = [tableView dequeueReusableCellWithIdentifier:@"ApplyServiceCell_1" forIndexPath:indexPath];
            [cell setModel:_epModel];
            return cell;
        }
        case ApplySerciceCellType_summary:{
            ApplyServiceCell_desc *cell = [tableView dequeueReusableCellWithIdentifier:@"ApplyServiceCell_desc" forIndexPath:indexPath];
            cell.placeHolder = @"服务商介绍突出企业或团队亮点，最多输入500字";
            cell.maxLength = 500;
            [cell setEpModel:_epModel cellType:cellType];
            return cell;
        }
        default:
            break;
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    ApplySerciceCellType cellType = [[self.dataSource objectAtIndex:indexPath.row] integerValue];
    switch (cellType) {
        case ApplySerciceCellType_serviceName:
        case ApplySerciceCellType_name:
        case ApplySerciceCellType_telphone:
        case ApplySerciceCellType_city:
            return 54.0f;
        case ApplySerciceCellType_summary:
            return 144.0f;
        default:
            break;
    }
    return 54.0f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    ApplySerciceCellType cellType = [[self.dataSource objectAtIndex:indexPath.row] integerValue];
    switch (cellType) {
        case ApplySerciceCellType_city:{
            [self selectCity];
        }
        default:
            break;
    }
}

#pragma mark - 重写方法

- (void)clickOnview:(UIView *)bottomView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if ([self checkExactModel]) {
        WEAKSELF
        [[XSJRequestHelper sharedInstance] postEnterpriseServiceBasicInfo:self.epModel block:^(id result) {
            if (result) {
                if (weakSelf.isPostAction) {
                    WebView_VC *viewCtrl = [[WebView_VC alloc] init];
                    NSString *url = [NSString stringWithFormat:@"%@%@", URL_HttpServer, KUrl_toPostServiceInfoPage];
                    viewCtrl.url = url;
                    viewCtrl.isPopToRootVC = YES;
                    [self.navigationController pushViewController:viewCtrl animated:YES];
                }else{
                    [UIHelper toast:@"保存成功"];
                    [weakSelf.navigationController popViewControllerAnimated:YES];
                }
            }
        }];
    }
}

#pragma mark - ApplyServiceCell_0Delegate

- (void)applyServiceCell:(ApplyServiceCell_0 *)cell actionType:(BtnOnClickActionType)actionType{
    switch (actionType) {
        case BtnOnClickActionType_idAuthAction:{
            [self pushToIdAuth];
        }
            break;
        default:
            break;
    }
}
#pragma mark - 自定义方法

- (void)btnHeadOnClick:(UIButton *)sender{
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
    [self.imageView setImage:image];
    
    WEAKSELF
    RequestInfo* info = [[RequestInfo alloc] init];
    [info uploadImage:image andBlock:^(NSString* imageUrl) {
        weakSelf.epModel.profile_url = imageUrl;
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
    ELog(@"===new fullPathToFile===%@",fullPathToFile);
    ELog(@"===new FileName===%@",[nameAry objectAtIndex:[nameAry count]-1]);
    
    [imageData writeToFile:fullPathToFile atomically:NO];
}

- (BOOL)checkExactModel{
    if (!self.epModel.service_name.length) {
        [UIHelper toast:@"服务商名称不能为空"];
        return NO;
    }
    if (!self.epModel.city_id) {
        [UIHelper toast:@"请选择城市"];
        return NO;
    }
    if (!self.epModel.service_contact_name.length) {
        [UIHelper toast:@"负责人姓名不能为空"];
        return NO;
    }
    if (!self.epModel.service_contact_tel.length) {
        [UIHelper toast:@"联系方式不能为空"];
        return NO;
    }
    if (self.epModel.service_contact_tel.length != 11) {
        [UIHelper toast:@"请输入有效的联系方式"];
        return NO;
    }
    if (!self.epModel.service_desc.length) {
        [UIHelper toast:@"服务商介绍不能为空"];
        return NO;
    }
    if (self.epModel.service_desc.length > 500) {
        [UIHelper toast:@"服务商介绍不能超过500字"];
        return NO;
    }
    return YES;
}

- (void)pushToIdAuth{
    EPVerity_VC* vc = [[EPVerity_VC alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)selectCity{
    CitySelectController *viewCtrl = [[CitySelectController alloc] init];
    viewCtrl.isPushAction = YES;
    viewCtrl.hidesBottomBarWhenPushed = YES;
    WEAKSELF
    viewCtrl.didSelectCompleteBlock = ^(CityModel *area){
        if (area && [area isKindOfClass:[CityModel class]]) {
            weakSelf.epModel.city_name = area.name;
            weakSelf.epModel.city_id = area.id;
            [weakSelf.tableView reloadData];
        }
    };
    [self.navigationController pushViewController:viewCtrl animated:YES];
}

- (BOOL)isAdjustEpModel{
    EPModel *tmpEpModel = [[UserData sharedInstance] getEpModelFromHave];
    if (![self.epModel.profile_url isEqualToString:tmpEpModel.profile_url]) {
        return YES;
    }
    if (![self.epModel.service_name isEqualToString:tmpEpModel.service_name]) {
        return YES;
    }
    if (![self.epModel.city_name isEqualToString:tmpEpModel.city_name]) {
        return YES;
    }
    if (![self.epModel.service_contact_name isEqualToString:tmpEpModel.service_contact_name]) {
        return YES;
    }
    if (![self.epModel.service_contact_tel isEqualToString:tmpEpModel.service_contact_tel]) {
        return YES;
    }
    if (![self.epModel.service_desc isEqualToString:tmpEpModel.service_desc]) {
        return YES;
    }
    return NO;
}

//返回提示
-(void)backToLastView{
    [self.view endEditing:YES];
    if ([self isAdjustEpModel]) {
        if (self.isPostAction) {
            [self.navigationController popViewControllerAnimated:YES];
        }else{
            WEAKSELF
            [UIHelper showConfirmMsg:@"您还未保存，确定要退出吗？" completion:^(DLAVAlertView *alertView, NSInteger buttonIndex) {
                if (buttonIndex == 0) {
                    return;
                }else{
                    [weakSelf.navigationController popViewControllerAnimated:YES];
                }
            }];
        }
    }else{
        [self.navigationController popViewControllerAnimated:YES];
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
