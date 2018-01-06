//
//  JobDetailMgr_VC.m
//  jianke
//
//  Created by fire on 15/12/28.
//  Copyright © 2015年 xianshijian. All rights reserved.
//

#import "JobDetailMgr_VC.h"
#import "JobDetail_VC.h"
#import "MJRefresh.h"
#import "XSJUIHelper.h"
#import "TalkToBoss_VC.h"


@interface JobDetailMgr_VC ()
@property (nonatomic, weak) JobDetail_VC *currentJobDetailVc;
@property (nonatomic, weak) JobDetail_VC *lastJobDetailVc;

@property (nonatomic, assign) BOOL isFirstShowJob;
@end


typedef NS_ENUM(NSInteger, PositionType){
    PositionTypeTop,
    PositionTypeMiddle,
    PositionTypeBottom
};

@implementation JobDetailMgr_VC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.isFirstShowJob = YES;
    
    [self addJobVcWith:self.jobId positionType:PositionTypeMiddle withFinishBlock:nil];
    
    [[XSJUIHelper sharedInstance] showAppCommentAlertWithViewController:self];
    
}

/** 增加岗位详情View */
- (void)addJobVcWith:(NSString *)jobId positionType:(PositionType)apositionType withFinishBlock:(MKBlock)block{
    JobDetail_VC* currentVc = [[JobDetail_VC alloc] init];
    currentVc.isFromJobViewController = YES;
    currentVc.jobId = jobId;
    if (self.isFirstShowJob) {
        currentVc.isFirstShowJob = YES;
        self.isFirstShowJob = NO;
    }
    [self addChildViewController:currentVc];
    self.currentJobDetailVc = currentVc;
    [self.currentJobDetailVc view];
    
    WEAKSELF
    currentVc.loadFinishBlock = ^(id obj){
        if (!obj) { // 请求失败
            return;
        }
        
        [weakSelf.view addSubview:weakSelf.currentJobDetailVc.view];
        weakSelf.currentJobDetailVc.view.frame = weakSelf.view.bounds;
        
        switch (apositionType) {
            case PositionTypeTop:
            {
                weakSelf.currentJobDetailVc.view.x = 0;
                weakSelf.currentJobDetailVc.view.y = -weakSelf.view.frame.size.height;
            }
                break;
            case PositionTypeMiddle:
            {
                weakSelf.currentJobDetailVc.view.x = 0;
                weakSelf.currentJobDetailVc.view.y = 0;
            }
                break;
            case PositionTypeBottom:
            {
                weakSelf.currentJobDetailVc.view.x = 0;
                weakSelf.currentJobDetailVc.view.y = weakSelf.view.frame.size.height;
            }
                break;
            default:
                break;
        }
        weakSelf.currentJobDetailVc.headerReflushBlock = ^(id obj) {
            [weakSelf AddLastJob];
        };
        
        weakSelf.currentJobDetailVc.footerReflushBlock = ^(id obj) {
            [weakSelf AddNextJob];
        };
        
        if (block) {
            block(nil);
        }
        [weakSelf setupNavBtn];
        
    };

}


/** 设置导航栏按钮 */
- (void)setupNavBtn{
    // 社交分享
    UIBarButtonItem *shareBtn = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"v3_job_share"] style:UIBarButtonItemStylePlain target:self.currentJobDetailVc action:@selector(share)];
    [shareBtn setBackgroundImage:[UIImage imageNamed:@"v3_job_share"] forState:UIControlStateHighlighted barMetrics:UIBarMetricsDefault];
    
    UIButton *collectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    collectBtn.width = 22;
    collectBtn.height = 44;
    [collectBtn setImage:[UIImage imageNamed:@"v3_job_collect_0"] forState:UIControlStateNormal];
    [collectBtn addTarget:self.currentJobDetailVc action:@selector(addCollectionAction) forControlEvents:UIControlEventTouchUpInside];
    [collectBtn setImage:[UIImage imageNamed:@"v3_job_collect_1"] forState:UIControlStateSelected];
    UIBarButtonItem *collectItem = [[UIBarButtonItem alloc] initWithCustomView:collectBtn];
    NSInteger status = self.currentJobDetailVc.jobDetailModel.parttime_job.student_collect_status.integerValue;
    collectBtn.selected = (status == 0) ? NO : YES ;
    self.navigationItem.rightBarButtonItems = @[shareBtn, collectItem];
}


/** 添加上一个岗位 */
- (void)AddLastJob{
    if (self.index <= 0) { // 没有上一个了
        [self.currentJobDetailVc.tableView.header endRefreshing];
        [UIHelper toast:@"已是最新岗位"];
    } else { // 切换到上一个岗位
        self.lastJobDetailVc = self.currentJobDetailVc;
        self.index -= 1;
        NSString *jobId = self.jobIdArray[self.index];
        WEAKSELF
        [self addJobVcWith:jobId positionType:PositionTypeTop withFinishBlock:^(id obj) {
           [weakSelf showLastJob];
        }];
    }
}


/** 添加下一个岗位 */
- (void)AddNextJob{
    if (self.index >= self.jobIdArray.count - 1) { // 没有下一个了
        [self.currentJobDetailVc.tableView.footer endRefreshing];
        [UIHelper toast:@"暂无更多岗位"];
    } else { // 切换到下一个岗位
        self.lastJobDetailVc = self.currentJobDetailVc;
        self.index += 1;
        NSString *jobId = self.jobIdArray[self.index];
        WEAKSELF
        [self addJobVcWith:jobId positionType:PositionTypeBottom withFinishBlock:^(id obj) {
            [weakSelf showNextJob];
        }];
    }
}


/** 显示上一个岗位 */
- (void)showLastJob{
    WEAKSELF
    [UIView animateWithDuration:0.5 animations:^{
        weakSelf.currentJobDetailVc.view.y = 0;
        weakSelf.lastJobDetailVc.view.y = weakSelf.view.height;
    } completion:^(BOOL finished) {
        [weakSelf.lastJobDetailVc.tableView.header endRefreshing];
        [weakSelf.lastJobDetailVc.view removeFromSuperview];
        [weakSelf.lastJobDetailVc removeFromParentViewController];
        weakSelf.lastJobDetailVc = nil;
    }];
}


/** 显示下一个岗位 */
- (void)showNextJob{
    WEAKSELF
    [UIView animateWithDuration:0.5 animations:^{
        weakSelf.currentJobDetailVc.view.y = 0;
        weakSelf.lastJobDetailVc.view.y = -weakSelf.view.height;
    } completion:^(BOOL finished) {
        [weakSelf.lastJobDetailVc.tableView.header endRefreshing];
        [weakSelf.lastJobDetailVc.view removeFromSuperview];
        [weakSelf.lastJobDetailVc removeFromParentViewController];
        weakSelf.lastJobDetailVc = nil;
    }];
}


- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
//    DLog(@"self.view.frame====%@", NSStringFromCGRect(self.view.frame));
//    DLog(@"self.scrollView.frame====%@", NSStringFromCGRect(self.scrollView.frame));
//    DLog(@"currentJobDetailVc.scrollViewHeightConstraint.constant=======%f", self.currentJobDetailVc.scrollViewHeightConstraint.constant);
//    DLog(@"self.currentJobDetailVc.view====%@", NSStringFromCGRect(self.currentJobDetailVc.view.frame));
}

- (void)dealloc{
    ELog(@"====JobDetailMgr_VC dealloc");
}
@end
