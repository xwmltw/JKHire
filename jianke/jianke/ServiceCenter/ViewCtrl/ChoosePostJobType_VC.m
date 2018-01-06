//
//  ChoosePostJobType_VC.m
//  jianke
//
//  Created by xiaomk on 16/4/18.
//  Copyright © 2016年 xianshijian. All rights reserved.
//

#import "ChoosePostJobType_VC.h"
#import "ChooseJobTypeList_VC.h"
#import "PostPersonalJob_VC.h"
#import "WebView_VC.h"
#import "ChooseJob_Cell.h"
#import "HiringJobList_VC.h"
#import "PostJob_VC.h"

@interface ChoosePostJobType_VC (){
    NSMutableArray *_array;
}

@end

@implementation ChoosePostJobType_VC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"发布我的需求";
    self.tableViewStyle = UITableViewStyleGrouped;
    [self setUISingleTableView];
    [self loadDataSource];
}

- (void)loadDataSource{
    _array = [NSMutableArray array];
    
    JobTypeModel* model1 = [[JobTypeModel alloc] init];
    model1.title = @"普通兼职需求";
    model1.detail = @"简单方便，海量兼客来报名";
    model1.imgName = @"JKHire_Post_Type_Normal";
    
    JobTypeModel *model4 = [[JobTypeModel alloc] init];
    model4.title = @"推广服务需求";
    model4.detail = @"企业线上线下、产品推广";
    model4.imgName = @"JKHire_Post_Type_marketing";
    
    [self.datasArray addObject:model1];
    [_array addObject:@(PostJobType_common)];
    CityModel *cityModel = [[UserData sharedInstance] city];
    if (cityModel) {
        if (cityModel.enablePersonalService.integerValue == 1) {
            JobTypeModel* model2 = [[JobTypeModel alloc] init];
            model2.title = @"专业人才直接邀约";
            model2.detail = @"模特、礼仪、商演、主持";
            model2.imgName = @"JKHire_Post_Type_Personal";
            [self.datasArray addObject:model2];
            [_array addObject:@(PostJobType_Personal)];
        }
        if (cityModel.enableTeamService.integerValue == 1) {
            JobTypeModel *model3 = [[JobTypeModel alloc] init];
            model3.title = @"招聘执行需求外包";
            model3.detail = @"兼职管理烦心？直接外包给专业团队";
            model3.imgName = @"JKHire_Post_Type_team";
            [self.datasArray addObject:model3];
            [_array addObject:@(PostJobType_Team)];
        }
    }
    [self.datasArray addObject:model4];
    [_array addObject:@(PostJobType_Push)];
    [self.tableView reloadData];
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString* cellIdentifier = @"cell";
    ChooseJob_Cell* cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[ChooseJob_Cell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
        cell.textLabel.font = [UIFont boldSystemFontOfSize:18.0f];
        cell.textLabel.textColor = [UIColor XSJColor_tGrayDeepTinge];
        cell.detailTextLabel.font = [UIFont systemFontOfSize:14.0f];
        cell.detailTextLabel.textColor = [UIColor XSJColor_tGrayDeepTransparent2];
        cell.detailTextLabel.numberOfLines = 0;
        cell.accessoryView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"job_icon_push"]];
    }
    JobTypeModel* model = [self.datasArray objectAtIndex:indexPath.row];
    cell.textLabel.text = model.title;
    cell.detailTextLabel.text = model.detail;
    cell.imageView.image = [UIImage imageNamed:model.imgName];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    PostJobType type = [[_array objectAtIndex:indexPath.row] integerValue];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (type == PostJobType_common) {
        [self enterPostJobVC];
    }else if(type == PostJobType_Personal){
        [[UserData sharedInstance] handleGlobalRMUrlWithType:GlobalRMUrlType_postServicePersonalJob block:^(UIViewController *vc) {
            [self.navigationController pushViewController:vc animated:YES];
        }];
        
    }else if (type == PostJobType_Team){
        PostPersonalJob_VC *viewCtrl = [[PostPersonalJob_VC alloc] init];
        viewCtrl.sourceType = ViewSourceType_PostTeamJob;
        [self.navigationController pushViewController:viewCtrl animated:YES];
    }else if (type == PostJobType_Push){
        ClientGlobalInfoRM* globaModel = [[XSJRequestHelper sharedInstance] getClientGlobalModel];
        WebView_VC *viewCtrl = [[WebView_VC alloc] init];
        viewCtrl.url = globaModel.wap_url_list.zhongbao_demand_url;
        viewCtrl.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:viewCtrl animated:YES];
    }

}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 92.0f;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.datasArray ? self.datasArray.count : 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 20.0f;
}

- (void)enterPostJobVC{
    PostJob_VC* vc = [[PostJob_VC alloc] init];
    vc.postJobType = PostJobType_common;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)enterRecuitVC{
    HiringJobList_VC *viewCtrl = [[HiringJobList_VC alloc] init];
    viewCtrl.model = [UserData sharedInstance].recruitJobNumInfo;
    viewCtrl.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:viewCtrl animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
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



@implementation JobTypeModel
@end
