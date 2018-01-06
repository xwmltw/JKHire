//
//  JobExpress_VC.m
//  jianke
//
//  Created by xiaomk on 15/9/9.
//  Copyright (c) 2015年 xianshijian. All rights reserved.
//

#import "JobExpress_VC.h"
#import "WDConst.h"
#import "JobExpressCell.h"
#import "JobModel.h"
#import "JobDetail_VC.h"
#import "JobSearchController.h"
#import "JobDetailMgr_VC.h"
#import "DataBaseTool.h"
#import "JobDetail_VC.h"
#import "JKHome_VC.h"

@interface JobExpress_VC ()<JobExpressCellDelegate>

@end

@implementation JobExpress_VC

- (instancetype)init{
    self = [super init];
    if (self) {
        ELog(@"===========JobExpress_VC init ok");
        
    }
    return self;
}

- (void)getHistoryData{
    if (self.isHome) {
        NSArray* jobAry = [[UserData sharedInstance] getHomeJobList];
        if (jobAry && jobAry.count > 0) {
            self.arrayData = [[NSMutableArray alloc] initWithArray:jobAry];
            
            if ([XSJADHelper getAdIsShowWithType:XSJADType_homeJobList]) {
                if (self.arrayData && self.arrayData.count >= 10) {
                    JobModel *adModel = [[JobModel alloc] init];
                    adModel.isSSPAd = YES;
                    [self.arrayData insertObject:adModel atIndex:10];
                }
            }
        }
    }
}

- (void)jobExpressCell_closeSSPAD{
    if (self.arrayData && self.arrayData.count >= 11) {
        [self.arrayData removeObjectAtIndex:10];
        [self.tableView reloadData];
        [XSJADHelper closeAdWithADType:XSJADType_homeJobList];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    JobExpressCell* cell = [JobExpressCell cellWithTableView:tableView];
    cell.delegate = self;
    if (self.arrayData.count <= indexPath.row) {
        return cell;
    }

    JobModel* model = self.arrayData[indexPath.row];
    [cell refreshWithData:model];
    cell.selectedBackgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"v210_pressed_background"]];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 94;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    ELog("====didSelectRowAtIndexPath:%ld",(long)indexPath.row);
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    // 退出编辑
    if ([self.owner isKindOfClass:[JobSearchController class]]) {
        [self.owner.navigationItem.titleView endEditing:YES];
    }
    
    JobModel* model = self.arrayData[indexPath.row];
    // 设置岗位为已读状态
    model.readed = YES;
    [DataBaseTool saveReadedJobId:model.job_id.stringValue];
    [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
    
    // 跳转到岗位详情
    DLog(@"跳转到有上拉/下拉的岗位详情");
    NSString *jobId = model.job_id.stringValue; 
    NSInteger index = indexPath.row;
    
    NSMutableArray *jobIdArray = [NSMutableArray array];
    for (JobModel *model in self.arrayData) {
        if (!model.isSSPAd) {
            NSString *jobIdStr = model.job_id.stringValue;
            [jobIdArray addObject:jobIdStr];
        }
    }
  
//    NSArray *tmpJobIdArray = [self.arrayData valueForKeyPath:@"job_id"];
//    NSMutableArray *jobIdArray = [NSMutableArray array];
//    for (NSNumber *num in tmpJobIdArray) {
//        if (num) {
//            NSString *jobIdStr = num.stringValue;
//            [jobIdArray addObject:jobIdStr];
//        }
//    }
    
    JobDetailMgr_VC *vc = [[JobDetailMgr_VC alloc] init];
    vc.jobIdArray = jobIdArray;
    vc.index = index;
    vc.jobId = jobId;
    vc.hidesBottomBarWhenPushed = YES;
    [self.owner.navigationController pushViewController:vc animated:YES];
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{

}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (self.isHome) {
        return self.tableSectionView;
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (self.isHome) {
        return 45;
    }
    return 0;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (self.owner) {
        if ([self.owner isKindOfClass:[JKHome_VC class]]) {
            [(JKHome_VC*)self.owner onScrollViewDidScroll:scrollView];
        }
    }
}


@end
