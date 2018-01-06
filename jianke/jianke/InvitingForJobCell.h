//
//  InvitingForJobCell.h
//  jianke
//
//  Created by xiaomk on 15/9/15.
//  Copyright (c) 2015年 xianshijian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JobModel.h"
#import "WDConst.h"

typedef NS_ENUM(NSInteger, JobOpreationType) {
    JobOpreationType_Close = 10086, //关闭岗位
    JobOpreationType_Refresh,   //刷新岗位
    JobOpreationType_Upload,    //上架岗位
    JobOpreationType_FastPost,  //快捷发布
    JobOpreationType_EditJob,   //编辑岗位
    JobOpreationType_ViewApplyJK,   //查看简历
    JobOpreationType_payForStick,   //置顶
    JobOpreationType_payForPush,    //推送
    JobOpreationType_jobDaifa,  //代发工资按钮
    JobOpreationType_payForTelentMatch, //人才匹配
};

@protocol InvitingForJobDelegate <NSObject>

//- (void)cell_didSelectRowAtIndex:(JobModel*)model;
- (void)cell_btnBotOnClick:(JobModel *)model atIndexPath:(NSIndexPath *)indexPath;
- (void)cell_btnBotOnClick:(JobModel *)model actionType:(JobOpreationType)actionType atIndexPath:(NSIndexPath *)indexPath;
//- (void)cell_btnPaySalaryOnClick:(JobModel *)model;
//- (void)cell_btnRefreshJobOnClick:(JobModel*)model;
//- (void)cell_btnOverJobOnClick:(JobModel*)model;
//- (void)cell_btnShareClick:(JobModel*)model;
//- (void)cell_btnApplyListOnclick:(JobModel*)model;
//- (void)cell_quickPublishClick:(JobModel*)model;

@end

@interface InvitingForJobCell : UITableViewCell

@property (nonatomic, weak) id <InvitingForJobDelegate> delegate;
@property (nonatomic, assign) ManagerType managerType;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

- (void)refreshWithData:(id)data atIndexPath:(NSIndexPath *)indexPath;
- (void)refreshWithData:(id)data;

@end
