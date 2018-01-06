//
//  PostJob_VC.m
//  jianke
//
//  Created by xiaomk on 16/4/18.
//  Copyright © 2016年 xianshijian. All rights reserved.
//

#import "PostJob_VC.h"
#import "MyEnum.h"

#import "PostJobCell_title.h"
#import "PostJobCell_date.h"
#import "PostJobCell_send.h"
#import "PostJobCell_select.h"
#import "PostJobCell_textField.h"
#import "PostJobCell_twoEdit.h"
#import "PostJobCell_time.h"
#import "PostJobCell_remind.h"
#import "PostJobCell_jobTag.h"

#import "PostJobCellModel.h"
#import "PostJobModel.h"
#import "WebView_VC.h"
#import "TimeBtn.h"
#import "JobTypeList_VC.h"
#import "JobDscEditController.h"
#import "DateHelper.h"
#import "XSJUIHelper.h"
#import "ConditionController.h"
#import "MutiSelectSheetItem.h"
#import "MutiSelectSheet.h"
#import "CityTool.h"
#import "IdentityCardAuth_VC.h"
#import "SYDatePicker.h"
#import "TagView.h"
#import "CitySelectController.h"
#import "PostJobAlertView.h"
#import "PaySelect_VC.h"
#import "AccountMoneyModel.h"
#import "AreaMapSelect_VC.h"
#import "HistoryPostJob_VC.h"
#import "XZNotifyView.h"
#import "DonePost_VC.h"
#import "PostJobSuccess_VC.h"
#import "RegiseterGuide_VC.h"
#import "JobDetail_VC.h"
#import "GuideMaskView.h"

#import "EPActionSheetItem.h"
#import "ConditionSheet.h"

@interface PostJob_VC ()<TagDelegate,PostJobAlertViewDelegate,PostJobCellTimeDelegate>{
    PostJobModel *_postJobModel;    /*!< 发布岗位模型 */
    
    NSArray *_jobWelfareArray;      /*!< 岗位福利列表 */
    NSArray *_areaItems;            /*!< 所在区域列表 */
    BOOL _isAgree;                  /*!< 是否同意发布协议 */

    NSMutableArray *_timeBtnArray;  /*!< 时间按钮数组 */
    NSArray *_payWayArray;   /*!< 支付方式数组 */
    NSArray *_salaryArray;      /*!< 结算方式数组 */
    NSArray *_unitArray;        /*!< 结算单位 */
    
    NSMutableArray *_bdJobTagArray;    /*!< 包招岗位类型 标签数组 */
    NSMutableArray *_bdJobTagSelArray; /*!< 包招岗位类型 选中标签数组 */
    CGFloat _jobTagCellHeight;          /*!< 包招岗位 标签cell高 */
    
    CGFloat _totalHours;                /*!< 一共多少工作小时 */
    CGFloat _tagAllMoney;               /*!< 标签总价 */
    CGFloat _lastDirectionMoney;      /*!< 最终指导价 */
    //329
    NSInteger _maxLengh;

}
@property (nonatomic, strong) UIView *noSignalView; /*!< 无网络显示View */
@property (nonatomic, strong) MutiSelectSheet *walfareSelectView; /*!< 福利保障上弹View */

@property (nonatomic, strong) NSLayoutConstraint *layoutTimeViewHeight; /*!< 时间View高度约束 */
@property (nonatomic, strong) EPModel *epModel;
@property (nonatomic, strong) JobModel *jobModel; /*!< 发布时的岗位模型 */

@property (nonatomic, strong) NSDate *startDate;    /*!< 开始日期 */
@property (nonatomic, strong) NSDate *endDate;      /*!< 结束日期 */
@property (nonatomic, strong) NSDate *applyEndDate; /*!< 报名截止日期 */
@property (nonatomic, strong) NSDate *tmpDate;      /*!< 临时变量 */

@property (nonatomic, strong) CityModel *city; /*!< 岗位发布相关城市 */
//329
@property (nonatomic, weak) UIPlaceHolderTextView *textView;
@property (nonatomic, strong) UILabel *labTip;
@property (nonatomic, weak) UIButton *resBtn;
@property (nonatomic, weak) UILabel *waleLab;
@property (nonatomic, strong) ConditionSheet *sexSheet; /*!< 性别 */
@property (nonatomic, copy) NSString *descStr;
@property (nonatomic, assign) BOOL isSelectBtnMaxTime;
@end

@implementation PostJob_VC

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (self.tableView) {
        [self.tableView reloadData];
    }
    [self updateStatus];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"发布兼职";
    
    self.labTip = [[UILabel alloc]init];
    _postJobModel = [[PostJobModel alloc]init];
    
    if (self.isEditAction) {
        NSAssert(self.jobId, @"编辑岗位需要传JobId");
    }
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"历史岗位模板" style:UIBarButtonItemStylePlain target:self action:@selector(historyOnclick:)];
//    [item setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:16],NSFontAttributeName, nil] forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItem = item;
    
    //结束
    [self setUISingleTableView];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    if (self.myPostJobModel) {
        self.jobModel = [NSKeyedUnarchiver unarchiveObjectWithData:[NSKeyedArchiver archivedDataWithRootObject:self.myPostJobModel]];
    }
    
    [self initData];
    [self getData];
    [self checkPublishedNum];
}

- (void)historyOnclick:(id)sender{
       
    HistoryPostJob_VC *vc = [[HistoryPostJob_VC alloc] init];
    vc.postJobType = self.postJobType;
    WEAKSELF
    vc.block = ^(JobModel* jobModel ){
        if (jobModel) {
            weakSelf.jobModel = [NSKeyedUnarchiver unarchiveObjectWithData:[NSKeyedArchiver archivedDataWithRootObject:jobModel]];
            [self judgeAreaWith:jobModel];
            [weakSelf getData];
        }
    };
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)judgeAreaWith:(JobModel *)jobModel{
    self.jobModel.address_area_id = nil;
    if (jobModel.address_area_id && jobModel.address_area_name.length) {
        self.jobModel.address_area_id = jobModel.address_area_id;
    }
    self.jobModel.working_place = jobModel.working_place;
}

/** 初始化数据 */
- (void)initData{
    _isAgree = YES;
    _jobTagCellHeight = 56;
    self.epModel = [[UserData sharedInstance] getEpModelFromHave];
    
    _payWayArray = [SalaryModel salaryPayWayArray];
    _salaryArray = [SalaryModel salaryArrayForSettlement];
    _unitArray = [SalaryModel salaryArray];
    
    _timeBtnArray = [[NSMutableArray alloc] init];
    _jobWelfareArray = [[NSArray alloc] init];
    _bdJobTagArray = [[NSMutableArray alloc] init];
    _bdJobTagSelArray = [[NSMutableArray alloc] init];
    
    if (!self.city) {
        self.city = [[UserData sharedInstance] city];
    }
}

/** 获取数据 */
- (void)getData{

    
    // 获取普通招聘岗位列表
    WEAKSELF
    NSString* content = [NSString stringWithFormat:@"\"city_id\":\"%@\"", self.city.id];
    RequestInfo* request = [[RequestInfo alloc] initWithService:@"shijianke_getJobClassifyInfoList" andContent:content];
    [request sendRequestWithResponseBlock:^(ResponseInfo *response) {
        if (response && response.success) {
            _jobClassArray = [JobClassifyInfoModel objectArrayWithKeyValuesArray:response.content[@"job_classifier_list"]];
             //获取福利保障列表
            [[UserData sharedInstance] getJobTagListWithBlock:^(NSArray *jobTagList) {
                if (jobTagList && jobTagList.count) {
                    _jobWelfareArray = [NSKeyedUnarchiver unarchiveObjectWithData:[NSKeyedArchiver archivedDataWithRootObject:jobTagList]];
                } else {
                    [UIHelper toast:@"获取福利列表失败"];
                }
                [weakSelf initUIData];
            }];
    
        }else{
            [UIHelper toast:@"获取岗位分类列表失败"];
        }
    }];
}

/** 初始化 UI */
- (void)initUIData{
    if (self.jobModel && self.city) {   /*!<  快速发布 */
        // 起始日期
        
        if (self.myPostJobModel && !self.isEditAction && !self.isUpload) {  //有数据 说明是从其他带进来的
            [self judgeAreaWith:self.myPostJobModel];
        }
        
        if (self.isEditAction || self.isUpload) {
//            self.jobModel.working_area = self.jobModel.address_area_name;
        }
        
        if (self.isEditAction) {    //编辑岗位要带入时间(当开始日期大于当前日期)
            NSDate *startDate = [NSDate dateWithTimeIntervalSince1970:self.jobModel.working_time_start_date.longLongValue * 0.001];
            NSDate *endDate = [NSDate dateWithTimeIntervalSince1970:self.jobModel.working_time_end_date.longLongValue * 0.001];
            NSDate *applyEndDate = [NSDate dateWithTimeIntervalSince1970:self.jobModel.apply_dead_time.longLongValue * 0.001];
            NSDate *nowDate = [NSDate date];
            if ([startDate compare:nowDate] == NSOrderedDescending ) {
                self.startDate = startDate;
                self.endDate = endDate;
                self.applyEndDate = applyEndDate;
            }
        }
        
        // 起始时间
        WorkTimePeriodModel *workTime = self.jobModel.working_time_period;
        if (workTime && workTime.f_start && workTime.f_end) {
            NSDate *startTime = [DateHelper convertTimeTo1970WithNumber:workTime.f_start];
            NSDate *endTime = [DateHelper convertTimeTo1970WithNumber:workTime.f_end];
            [self selectTimeRangWithStartTime:startTime endTime:endTime];
        }
        if (workTime && workTime.s_start && workTime.s_end) {
            NSDate *startTime = [DateHelper convertTimeTo1970WithNumber:workTime.s_start];
            NSDate *endTime = [DateHelper convertTimeTo1970WithNumber:workTime.s_end];
            [self selectTimeRangWithStartTime:startTime endTime:endTime];
        }
        if (workTime && workTime.t_start && workTime.t_end) {
            NSDate *startTime = [DateHelper convertTimeTo1970WithNumber:workTime.t_start];
            NSDate *endTime = [DateHelper convertTimeTo1970WithNumber:workTime.t_end];
            [self selectTimeRangWithStartTime:startTime endTime:endTime];
        }
        if (!self.jobModel.salary.pay_type) { // 在没有线支付字段时
            self.jobModel.salary.pay_type = @(1); // 在线支付
        }
        
        // 设置委托招聘状态
        if (self.jobModel.enable_recruitment_service.integerValue == 1) {
            self.postJobType = PostJobType_bd;
        }else{
            self.postJobType = PostJobType_common;
        }
        
        if (self.epModel.identity_mark.integerValue == 2) {
            self.postJobType = PostJobType_fast;
        }
        // 福利保障
        [self setOldValueToJobTagList];
        
    }else{      //不是快捷发布
        self.jobModel = [[JobModel alloc] init];
        self.jobModel.job_type = @(1);    //设置普通岗位类型
        
        self.jobModel.job_classfie_name = self.jobClassifyInfoModel.job_classfier_name;
        self.jobModel.job_type_id = self.jobClassifyInfoModel.job_classfier_id;
        
        SalaryModel *salary = [[SalaryModel alloc] init];
        salary.unit = @(1); // 元/天
        salary.unit_value = [salary getUnitValue];
        salary.settlement = @(4); // 完工结算
        salary.settlement_value = [salary getSettlementDesc];
        salary.pay_type = @(1); // 在线支付
        self.jobModel.salary = salary;
        
        ContactModel* contact = [[ContactModel alloc] init];
        contact.name = [[UserData sharedInstance] getUserTureName];
        contact.phone_num = [[XSJUserInfoData sharedInstance] getUserInfo].userPhone;
        self.jobModel.contact = contact;
    }
    
    if (self.postJobType == PostJobType_bd) {   //是否包招
        self.jobModel.enable_recruitment_service = @(1);
    } else {
        self.jobModel.enable_recruitment_service = @(0);
    }

    if (self.postJobType == PostJobType_fast) { //设置 job_type
        self.jobModel.job_type = @(4);      //设置快招（兼客合伙人）岗位
        self.jobModel.salary.unit = @(1); // 在线支付
        self.jobModel.salary.unit_value = [self.jobModel.salary getUnitValue];
    }
    
    [self loadDataSource];
}

/** 置顶提示 */
- (UIView *)setupTopView:(NSString *)title isShowLeftPostNum:(BOOL)isShowLeftPostNum{
    
    UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 10)];
    topView.backgroundColor = MKCOLOR_RGBA(0, 118, 255, 0.03);
    UILabel *label = nil;
    CGFloat height = 0.0;
    if (isShowLeftPostNum) {
        label = [UILabel labelWithText:title textColor:[UIColor XSJColor_tBlue] fontSize:15.0f];
        label.numberOfLines = 0;
        [topView addSubview:label];
        
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(topView).offset(16);
            make.right.equalTo(topView).offset(-16);
            make.top.equalTo(topView).offset(14);
            make.bottom.equalTo(topView).offset(-14);
        }];
        height = [label contentSizeWithWidth:SCREEN_WIDTH - 32].height + 28;
    }
    
    if (self.isShowTip) {
        UILabel *topLabel = [UILabel labelWithText:@"您所在的城市还没有相关服务商入驻,你可以发布兼职职位等待兼客报名" textColor:[UIColor XSJColor_tGrayDeepTransparent2] fontSize:15.0f];
        topLabel.numberOfLines = 0;
        [topView addSubview:topLabel];
        
        [topLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(topView).offset(16);
            make.right.equalTo(topView).offset(-16);
            make.top.equalTo(topView).offset(14);
            make.height.greaterThanOrEqualTo(@1);
        }];
        if (isShowLeftPostNum) {
            [label mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(topView).offset(16);
                make.right.equalTo(topView).offset(-16);
                make.top.equalTo(topLabel.mas_bottom).offset(14);
                make.height.greaterThanOrEqualTo(@1);
            }];
            height += ([topLabel contentSizeWithWidth:SCREEN_WIDTH - 32].height + 14);
        }else{
            height += ([topLabel contentSizeWithWidth:SCREEN_WIDTH - 32].height + 28);
        }
    }
    
    topView.height = height;
    [topView addBorderInDirection:BorderDirectionTypeBottom borderWidth:0.7 borderColor:MKCOLOR_RGBA(0, 118, 255, 0.48) isConstraint:NO];
    return topView;
}

- (void)setOldValueToJobTagList{    //发布岗位模板用
    if (!_jobWelfareArray || !_jobWelfareArray.count) {
        return;
    }
    
    // 岗位详情中的福利列表
    NSArray *oldJobTags = self.jobModel.job_tags;
    
    // 比对快捷发布中的福利列表,及默认的福利列表并设值
    for (WelfareModel *oldJobTag in oldJobTags) {
        for (WelfareModel *jobTag in _jobWelfareArray) {
            if (oldJobTag.tag_id.integerValue == jobTag.tag_id.integerValue) {
                jobTag.check_status = oldJobTag.check_status;
            }
        }
    }
}

- (void)loadDataSource{
    
    [self.datasArray removeAllObjects];
    [self.datasArray addObject:@(PostJobCellType_title)];
    [self.datasArray addObject:@(PostJobCellType_jobType)];
    [self.datasArray addObject:@(PostJobCellType_date)];
    [self.datasArray addObject:@(PostJobCellType_applyEndDate)];
    [self.datasArray addObject:@(PostJobCellType_time)];
//    [self.datasArray addObject:@(PostJobCellType_maxTime)];
    [self.datasArray addObject:@(PostJobCellType_maxJKCount)];
    
    [self.datasArray addObject:@(PostJobCellType_payMoney)];
    
    [self.datasArray addObject:@(PostJobCellType_payType)];
    [self.datasArray addObject:@(PostJobCellType_JobDetail)];
    [self.datasArray addObject:@(PostJobCellType_Gender)];
    [self.datasArray addObject:@(PostJobCellType_FuLi)];
    [self.datasArray addObject:@(PostJobCellType_MoreCondition)];
//    [self.datasArray addObject:@(PostJobCellType_detail)];
    [self.datasArray addObject:@(PostJobCellType_area)];
    [self.datasArray addObject:@(PostJobCellType_workAddress)];
    [self.datasArray addObject:@(PostJobCellType_contact)];
    [self.datasArray addObject:@(PostJobCellType_send)];
    if (self.postJobType == PostJobType_bd) {
        [self.datasArray addObject:@(PostJobCellType_jobTag)];
    }

    [self.tableView reloadData];
}

#pragma mark - ***** UITableView delegate ******
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    PostJobCellType cellType = [[self.datasArray objectAtIndex:indexPath.row] integerValue];
    switch (cellType) {
        case PostJobCellType_jobTag:{
            PostJobCell_jobTag* cell = [PostJobCell_jobTag cellWithTableView:tableView];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
           
            [cell.viewTagSel.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
            [cell.viewTag.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
            cell.labTitle.hidden = _bdJobTagSelArray.count > 0;

            if (_bdJobTagSelArray.count == 0 && _bdJobTagArray.count == 0) {
                _jobTagCellHeight = 0;
            }else{
                if (_bdJobTagSelArray.count > 0) {
                    TagView *inputTagView = [[TagView alloc] initWithWidth:SCREEN_WIDTH-72];
                    NSMutableArray *tmpArray = [_bdJobTagSelArray valueForKeyPath:@"label_name"];
                    [inputTagView showTagsWithArray:tmpArray isEnable:YES isShowCloseIcon:YES];
                    inputTagView.deletage = self;
                    inputTagView.tag = 2000;
                    [cell.viewTagSel addSubview:inputTagView];
                    cell.layoutViewTagSelHeight.constant = [inputTagView getTagViewHeight];
                    _jobTagCellHeight = 12+cell.layoutViewTagSelHeight.constant+8;
                }else{
                    cell.layoutViewTagSelHeight.constant = 36;
                    _jobTagCellHeight = 56;
                }
                if (_bdJobTagArray.count > 0) {
                    TagView *inputTagView = [[TagView alloc] initWithWidth:SCREEN_WIDTH-72];
                    NSMutableArray *tmpArray = [_bdJobTagArray valueForKeyPath:@"label_name"];
                    [inputTagView showTagsWithArray:tmpArray isEnable:YES isShowCloseIcon:NO];
                    inputTagView.deletage = self;
                    inputTagView.tag = 2001;
                    [cell.viewTag addSubview:inputTagView];
                    cell.layoutViewTagHeight.constant = [inputTagView getTagViewHeight];
                    _jobTagCellHeight = _jobTagCellHeight + cell.layoutViewTagHeight.constant;
                }else{
                    cell.layoutViewTagHeight.constant = 0;
                }
            }
          
            return cell;
        }
        case PostJobCellType_title:{    /*!< 岗位标题 */
            
            PostJobCell_title* cell = [PostJobCell_title cellWithTableView:tableView];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
          
            [cell refreshWithData:self.jobModel andIndexPath:indexPath];
            return cell;
        }
        case PostJobCellType_jobType:{  /*!< 选择岗位类型 */
            PostJobCell_select *cell = [PostJobCell_select cellWithTableView:tableView];
            
            cell.imgIcon.image = [UIImage imageNamed:@"v250_type"];
            cell.labTitle.text = @"请选择岗位类型";
            cell.imgRightIcon.image = [UIImage imageNamed:@"job_icon_push"];

            if (_jobModel.job_classfie_name.length) {
                cell.labTitle.text = _jobModel.job_classfie_name;
                
                if (_jobModel.job_type_id == nil && _jobClassArray) {
                    for (JobClassifyInfoModel *model in _jobClassArray) {
                        if ([_jobModel.job_classfie_name isEqualToString:model.job_classfier_name]) {
                            _jobModel.job_type_id = model.job_classfier_id;
                        }
                    }
                }
            }
            return cell;
        }
        case PostJobCellType_date:{     /*!< 选择 开始 结束日期 */
            PostJobCell_date *cell = [PostJobCell_date cellWithTableView:tableView];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
       
            [cell.btnDateStart addTarget:self action:@selector(btnDateStartOnclick:) forControlEvents:UIControlEventTouchUpInside];
            [cell.btnDateEnd addTarget:self action:@selector(btnDateEndOnclick:) forControlEvents:UIControlEventTouchUpInside];
            
            if (self.startDate) {
                cell.labDateStart.text = [DateHelper getDateAndWeekWithDate:self.startDate];
            }
            if (self.endDate) {
                cell.labDateEnd.text = [DateHelper getDateAndWeekWithDate:self.endDate];
            }
            
            return cell;
        }
        case PostJobCellType_time:{     /*!< 工作时间 */
            PostJobCell_time *cell = [PostJobCell_time cellWithTableView:tableView];
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.delegate = self;
            [cell.btnAddTime addTarget:self action:@selector(btnAddTimeOnclick:) forControlEvents:UIControlEventTouchUpInside];
            [cell.timeBgView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
            
            if (_postJobModel.selectAddMaxTime) {
                [cell.btnMaxTime setSelected:YES];
                [cell.btnAddTime setUserInteractionEnabled:NO];
                [cell.btnAddTime setTitleColor:MKCOLOR_RGBA(34, 58, 80, 0.48) forState:UIControlStateNormal];
                
            }
            if (_postJobModel.selectAddTime) {
                
                [cell.btnMaxTime setSelected:NO];
                [cell.btnAddTime setTitleColor:MKCOLOR_RGB(74, 144, 226) forState:UIControlStateNormal];
                [cell.btnAddTime setUserInteractionEnabled:YES];
            }
            
//            if (_timeBtnArray.count == 0) {
//                [cell.btnMaxTime setUserInteractionEnabled:YES];
//            }else{
//                [cell.btnMaxTime setUserInteractionEnabled:NO];
//            }
            
            for (NSInteger i = 0; i < _timeBtnArray.count; i++) {
                
                TimeBtn* btn = _timeBtnArray[i];
                [cell.timeBgView addSubview:btn];
                CGRect frame = btn.frame;
                frame.origin.x = 0;
                frame.origin.y = 12 + i * (26+8);
                btn.frame = frame;
            }
            cell.btnAddTime.hidden = _timeBtnArray.count > 2;
            
            
            cell.layoutViewHeight.constant = 112+ (26+8)*_timeBtnArray.count ;
            cell.layoutTimeBtnToTop.constant = cell.layoutViewHeight.constant - 32-12 -56;
            if (_timeBtnArray.count > 2) {
                cell.layoutViewHeight.constant = 112+ (26+8)*_timeBtnArray.count - 32;
            }
            self.layoutTimeViewHeight = cell.layoutViewHeight;
            
            
            
            return cell;
        }
        
        case PostJobCellType_applyEndDate:{ /*!< 报名截止日期 */
            PostJobCell_select *cell = [PostJobCell_select cellWithTableView:tableView];
         
            cell.imgIcon.image = [UIImage imageNamed:@"v260_icon_deadline"];
            cell.labTitle.text = @"报名截止日期";
            if (self.applyEndDate) {
                cell.labTitle.text = [DateHelper getDateAndWeekWithDate:self.applyEndDate];
            }
            
            return cell;
        }
        case PostJobCellType_detail:{       /*!< 工作内容说明 */
            PostJobCell_select *cell = [PostJobCell_select cellWithTableView:tableView];
            
            cell.imgIcon.image = [UIImage imageNamed:@"v250_content_paste"];
            cell.imgRightIcon.image = [UIImage imageNamed:@"job_icon_push"];
            cell.labTitle.text = @"有什么工作内容、福利和特殊要求呢?";
            
            if (_jobModel.job_desc && _jobModel.job_desc.length > 0) {
                cell.labTitle.text = _jobModel.job_desc;
                cell.labTitle.textColor = [UIColor blackColor];
            }
            
            return cell;
        }
        case PostJobCellType_area:{       /*!< 选择所在区域 */
            PostJobCell_select *cell = [PostJobCell_select cellWithTableView:tableView];
            
            cell.imgIcon.image = [UIImage imageNamed:@"v250_iconfont"];
            cell.labTitle.text = @"选择区域";
            cell.imgRightIcon.image = [UIImage imageNamed:@"job_icon_push"];
            if (self.jobModel.city_id) {
                if (!self.jobModel.address_area_id) {
                    cell.labTitle.text = [NSString stringWithFormat:@"%@", self.jobModel.city_name];
                }else{
                    cell.labTitle.text = [NSString stringWithFormat:@"%@%@", self.jobModel.city_name, self.jobModel.address_area_name];
                }
            }
            
            
            return cell;
        }
        case PostJobCellType_workAddress:{  /*!< 详细地址 */
            PostJobCell_textField *cell = [PostJobCell_textField cellWithTableView:tableView];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            cell.tfText.placeholder = @"详细地址";
            [cell.tfText addTarget:self action:@selector(tfTextEditEnd:) forControlEvents:UIControlEventEditingDidEnd];
            [cell.tfText addTarget:self action:@selector(tfTextEditChange:) forControlEvents:UIControlEventEditingChanged];
            cell.tfText.tag = PostJobCellType_workAddress;
            cell.tfText.keyboardType = UIKeyboardTypeDefault;
            cell.btnGetLocation.hidden = YES;
            cell.imgIcon.hidden = YES;
            if (self.jobModel.working_place.length > 0) {
                cell.tfText.text = self.jobModel.working_place;
            }else{
                cell.tfText.text = nil;
            }
            
            return cell;
        }
        case PostJobCellType_maxJKCount:{   /*!< 总人数 */
            PostJobCell_textField *cell = [PostJobCell_textField cellWithTableView:tableView];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            cell.tfText.placeholder = @"总人数";
            [cell.tfText addTarget:self action:@selector(tfTextEditEnd:) forControlEvents:UIControlEventEditingDidEnd];
            [cell.tfText addTarget:self action:@selector(tfTextEditChange:) forControlEvents:UIControlEventEditingChanged];
            cell.tfText.tag = PostJobCellType_maxJKCount;
            cell.tfText.keyboardType = UIKeyboardTypeNumberPad;
            cell.btnGetLocation.hidden = YES;
            cell.imgIcon.hidden = NO;
            
            if (self.jobModel.recruitment_num.integerValue > 0) {
                cell.tfText.text = [NSString stringWithFormat:@"%@",self.jobModel.recruitment_num];
            }else{
                cell.tfText.text = nil;
            }
            
            return cell;
        }
        case PostJobCellType_contact:{  /*!< 联系人 */
            PostJobCell_twoEdit *cell = [PostJobCell_twoEdit cellWithTableView:tableView];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
           
            cell.btnLeft.hidden = YES;
            cell.btnRight.hidden = YES;
            cell.imgXiaLeft.hidden = YES;
            cell.imgXiaRight.hidden = YES;
            cell.imgIcon.image = [UIImage imageNamed:@"v250_phone"];
            cell.tfLeft.placeholder = @"联系人";
            cell.tfRight.placeholder = @"联系电话";
            
            [cell.tfLeft addTarget:self action:@selector(tfTextEditEnd:) forControlEvents:UIControlEventEditingDidEnd];
            [cell.tfLeft addTarget:self action:@selector(tfTextEditChange:) forControlEvents:UIControlEventEditingChanged];
            cell.tfLeft.tag = 1000;
            
            [cell.tfRight addTarget:self action:@selector(tfTextEditEnd:) forControlEvents:UIControlEventEditingDidEnd];
            [cell.tfRight addTarget:self action:@selector(tfTextEditChange:) forControlEvents:UIControlEventEditingChanged];
            cell.tfRight.tag = 1001;
            cell.tfRight.keyboardType = UIKeyboardTypeNumberPad;
            
            
            if (self.jobModel.contact.name.length) {
                cell.tfLeft.text = self.jobModel.contact.name;
            }
            if (self.jobModel.contact.phone_num.length) {
                cell.tfRight.text = self.jobModel.contact.phone_num;
            }
            return cell;
        }
        case PostJobCellType_payMoney:{
            PostJobCell_twoEdit *cell = [PostJobCell_twoEdit cellWithTableView:tableView];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
           
            cell.imgIcon.image = [UIImage imageNamed:@"v250_money"];

            cell.btnLeft.hidden = YES;
            cell.imgXiaLeft.hidden = YES;
            cell.tfRight.hidden = YES;
            
            cell.tfLeft.placeholder = @"报酬";
            cell.tfLeft.keyboardType = UIKeyboardTypeDecimalPad;
            cell.tfLeft.tag = PostJobCellType_payMoney;
            [cell.tfLeft addTarget:self action:@selector(tfTextEditEnd:) forControlEvents:UIControlEventEditingDidEnd];
            [cell.tfLeft addTarget:self action:@selector(tfTextEditChange:) forControlEvents:UIControlEventEditingChanged];

            [cell.btnRight setTitle:self.jobModel.salary.unit_value forState:UIControlStateNormal];

            if (self.jobModel.salary.value) {
                NSString *moneyStr = [NSString stringWithFormat:@"%.1f", self.jobModel.salary.value.floatValue];
                cell.tfLeft.text = [moneyStr stringByReplacingOccurrencesOfString:@".0" withString:@""];
            }
            
            if (self.postJobType == PostJobType_bd || self.postJobType == PostJobType_fast) {
                cell.btnRight.enabled = NO;
                cell.imgXiaRight.hidden = YES;
            }else{
                cell.btnRight.enabled = YES;
                cell.imgXiaRight.hidden = NO;
                [cell.btnRight addTarget:self action:@selector(btnSalaryUnitOnclick:) forControlEvents:UIControlEventTouchUpInside];
            }
            return cell;
        }
        case PostJobCellType_payType:{  /*!< 支付 类型 */
            PostJobCell_twoEdit *cell = [PostJobCell_twoEdit cellWithTableView:tableView];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            cell.imgIcon.hidden = YES;
            cell.tfLeft.hidden = YES;
            cell.tfRight.hidden = YES;
            
            [cell.btnLeft addTarget:self action:@selector(btnPayTimeOnclick:) forControlEvents:UIControlEventTouchUpInside];
            [cell.btnRight addTarget:self action:@selector(btnPayWayOnclick:) forControlEvents:UIControlEventTouchUpInside];
            
            [cell.btnLeft setTitle:self.jobModel.salary.settlement_value forState:UIControlStateNormal];
            [cell.btnRight setTitle:[self.jobModel.salary getPayWayStr] forState:UIControlStateNormal];
            
            return cell;
        }
        case PostJobCellType_JobDetail:{//岗位描述
            static NSString *identifier =@"jobDetailCell";
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
            if (cell == nil) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
            }
            _maxLengh = 1000;
            UIPlaceHolderTextView *textView = [[UIPlaceHolderTextView alloc] init];
            textView.placeholder = @"请尽可能详细地填写该岗位的工作内容、福利、待遇、要求，不能包含微信、电话号码等信息！";
            textView.font = [UIFont systemFontOfSize:16];
            textView.maxLength = _maxLengh;
            textView.scrollEnabled = YES;
            textView.backgroundColor = [UIColor XSJColor_grayTinge];
            textView.placeholderColor = MKCOLOR_RGB(180, 180, 185);
            [cell addSubview:textView];
            self.textView = textView;
            
            // 附旧值
            if (self.jobModel.job_desc && self.jobModel.job_desc.length > 0) {
                self.textView.text = self.jobModel.job_desc;
            }

            
            
            [_labTip setFont:[UIFont systemFontOfSize:12]];
            _labTip.textColor = [UIColor XSJColor_tGrayDeepTransparent32];
            _labTip.attributedText = [self getMutableAttStrWith:self.jobModel.job_desc];
            
            
            WEAKSELF
            textView.block = ^(NSString *text){
                weakSelf.jobModel.job_desc = weakSelf.textView.text;
                weakSelf.labTip.attributedText = [weakSelf getMutableAttStrWith:text];
            };
            [cell addSubview:_labTip];

            // textView
            [textView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(cell).offset(12);
                make.right.equalTo(cell).offset(-12);
                make.top.equalTo(cell).offset(8);
                make.bottom.equalTo(cell).offset(-20);
            }];
            [_labTip mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(textView.mas_bottom).offset(8);
                make.right.equalTo(cell).offset(-16);
                
            }];

            return cell;
        
        }
        case PostJobCellType_Gender:{//性别
            PostJobCell_select *cell = [PostJobCell_select cellWithTableView:tableView];
            
            cell.imgIcon.image = [UIImage imageNamed:@"PostJobCell_Gender"];
            cell.labTitle.text = @"性别要求(选填)";
            NSNumber *arg = self.jobModel.sex;
            if (arg && arg.integerValue == 1) {
                cell.labTitle.text = @"男";
            }
            if (arg && arg.integerValue == 0) {
                cell.labTitle.text = @"女";
            }

            
            return cell;
        }
        case PostJobCellType_FuLi:{//福利
            PostJobCell_select *cell = [PostJobCell_select cellWithTableView:tableView];
            
            cell.imgIcon.image = [UIImage imageNamed:@"v250_alarm"];
            cell.labTitle.text = @"福利保障(选填)";
            
            self.waleLab = cell.labTitle;
            
            return cell;
        
        }
        case PostJobCellType_MoreCondition:{//限制条件
            PostJobCell_select *cell = [PostJobCell_select cellWithTableView:tableView];
            
            cell.imgIcon.image = [UIImage imageNamed:@"choose_job_classify"];
            cell.labTitle.text = @"更多限制条件(选填)";
            cell.imgRightIcon.image = [UIImage imageNamed:@"job_icon_push"];
            
            if (self.jobModel.age.integerValue || self.jobModel.height.integerValue || self.jobModel.rel_name_verify.integerValue || self.jobModel.life_photo.integerValue || self.jobModel.apply_job_date.integerValue || self.jobModel.health_cer.integerValue || self.jobModel.stu_id_card.integerValue) {
                
                cell.labTitle.text = @"已限制";
                
            }
            
            
            return cell;

        }
        case PostJobCellType_send:{    /*!< 发布岗位 */
            PostJobCell_send *cell = [PostJobCell_send cellWithTableView:tableView];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            [cell.btnSend addTarget:self action:@selector(btnSendOnclick:) forControlEvents:UIControlEventTouchUpInside];
            [cell.btnAgreement addTarget:self action:@selector(btnAgreementOnclick:) forControlEvents:UIControlEventTouchUpInside];
            [cell.btnAgreeChoose addTarget:self action:@selector(btnAgreeChooseOnclick:) forControlEvents:UIControlEventTouchUpInside];
            cell.btnAgreeChoose.selected = _isAgree;
            return cell;
        }
        default:
            break;
    }
    return nil;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    PostJobCellType cellType = [[self.datasArray objectAtIndex:indexPath.row] integerValue];
    switch (cellType) {
        case PostJobCellType_jobType:{
            [self jobTypeOnclick];
        }
            break;
        case PostJobCellType_detail:{
            [self detailOnclick];
        }
            break;
        case PostJobCellType_applyEndDate:{
            [self applyEndDateOnclick];
        }
            break;
        case PostJobCellType_restrict:{
            [self restrictOnclick];
        }
            break;
//        case PostJobCellType_welfare:
//            [self welfareOnclick];
//            break;
        case PostJobCellType_area:
            [self areaOnclick];
            break;
        case PostJobCellType_Gender:{
            ELog(@"性别");
            [self.sexSheet show];
        }
            break;
        case PostJobCellType_FuLi:{
            ELog(@"福利保障");
            [self welfareOnclick];
        }
            break;
        case PostJobCellType_MoreCondition:{
            ELog(@"限制条件");
            [self restrictOnclick];
        }
            break;
        case PostJobCellType_time:
        case PostJobCellType_maxTime:
//        case PostJobCellType_concentrate:
        case PostJobCellType_maxJKCount:
        case PostJobCellType_contact:
        case PostJobCellType_payType:
        case PostJobCellType_send:
        case PostJobCellType_JobDetail:
        default:
            break;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    PostJobCellType cellType = [[self.datasArray objectAtIndex:indexPath.row] integerValue];
    switch (cellType) {
        case PostJobCellType_title:
            return 80;
        case PostJobCellType_jobType:
        case PostJobCellType_detail:
        case PostJobCellType_date:
        case PostJobCellType_applyEndDate:
        case PostJobCellType_restrict:
//        case PostJobCellType_welfare:
        case PostJobCellType_area:
//        case PostJobCellType_concentrate:
        case PostJobCellType_maxJKCount:
        case PostJobCellType_contact:
        case PostJobCellType_payType:
        case PostJobCellType_payMoney:
        case PostJobCellType_workAddress:
        case PostJobCellType_maxTime:
        case PostJobCellType_Gender:
        case PostJobCellType_FuLi:
        case PostJobCellType_MoreCondition:
            return 56;
        case PostJobCellType_send:
            return 100;
        case PostJobCellType_time:
            return self.layoutTimeViewHeight.constant;
        case PostJobCellType_jobTag:
            return _jobTagCellHeight;
        case PostJobCellType_JobDetail:
            return 150;
        default:
            break;
    }
    return 0;
}
#pragma mark - ***** PostJobCellType_welfare ******
- (void)welfareOnclick{
    [self.view endEditing:YES];
    if (!_jobWelfareArray || !_jobWelfareArray
        .count) {
        [UIHelper toast:@"获取福利列表失败"];
        return;
    }
    
    NSMutableArray *items = [NSMutableArray array];
    for (WelfareModel *jobTag in _jobWelfareArray) {
        MutiSelectSheetItem *item = [[MutiSelectSheetItem alloc] initWithTitle:jobTag.tag_title selected:jobTag.check_status.integerValue enable:YES arg:jobTag];
        [items addObject:item];
    }
    WEAKSELF
    MutiSelectSheet *walfareSelectView = [[MutiSelectSheet alloc] initWithTitle:@"福利保障" items:items selctedBlock:^(NSArray *selItems) {
        for (MutiSelectSheetItem *item in items) {
            WelfareModel *jobTag = item.arg;
            jobTag.check_status = item.selected ? @(1) : @(0);
        }
        [weakSelf updateBtn];
    }];
    [walfareSelectView show];
}
- (void)updateBtn{
    if (_jobWelfareArray && _jobWelfareArray.count) {
        NSArray *jobTagList = [_jobWelfareArray filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"check_status.integerValue == 1"]];
        NSString *titleStr;
        if (jobTagList.count) {
            NSArray *titleArray = [jobTagList valueForKeyPath:@"tag_title"];
            titleStr = [titleArray componentsJoinedByString:@","];
            if (titleStr.length) {
                [self.waleLab setText:titleStr];
            }
        }else{
            [self.waleLab setText:@"福利保障"];
        }
    }
}

#pragma mark - ***** PostJobCellType_jobTag ******
- (void)tagView:(TagView *)tagView didClickWithIndex:(NSUInteger)index{
    if (tagView.tag == 2000) {
        JobClassifierLabelModel* model = [[_bdJobTagSelArray objectAtIndex:index] copy];
        [_bdJobTagSelArray removeObjectAtIndex:index];
        [_bdJobTagArray addObject:model];
    }else if (tagView.tag == 2001) {
        JobClassifierLabelModel* model = [[_bdJobTagArray objectAtIndex:index] copy];
        [_bdJobTagArray removeObjectAtIndex:index];
        [_bdJobTagSelArray addObject:model];
    }
    CGFloat money = 0;
    for (JobClassifierLabelModel* model in _bdJobTagSelArray) {
        NSNumber* num = [model valueForKey:@"label_add_price"];
        money = money + num.floatValue;
    }
    _tagAllMoney = money;
    [self.tableView reloadData];
}

#pragma mark - ***** PostJobCellType_jobType ******
- (void)jobTypeOnclick{
//    if (_jobClassArray) {
        WEAKSELF
        JobTypeList_VC* vc = [[JobTypeList_VC alloc] init];
        vc.classifierArray = _jobClassArray;
        vc.postJobType = self.postJobType;
        vc.block = ^(JobClassifyInfoModel* model){
            if (model) {
                _jobClassifyInfoModel = model;
                _jobModel.job_type_id = _jobClassifyInfoModel.job_classfier_id;
                _jobModel.job_classfie_name = _jobClassifyInfoModel.job_classfier_name;
                [weakSelf.tableView reloadData];
            }
        };
        [self.navigationController pushViewController:vc animated:YES];
//    }
}
- (void)switchToCommonPost{
    self.postJobType = PostJobType_common;
    [self loadDataSource];
}

#pragma mark - ***** PostJobCellType_detail ******
- (void)detailOnclick{
    JobDscEditController *vc = [[JobDscEditController alloc] init];
    if (_jobModel.job_desc.length > 0) {
        vc.descStr = _jobModel.job_desc;
    }
    vc.jobModel = [NSKeyedUnarchiver unarchiveObjectWithData:[NSKeyedArchiver archivedDataWithRootObject:self.jobModel]];
    vc.startDate = self.startDate;
    vc.endDate = self.endDate;
    vc.jobWelfareArray = [NSKeyedUnarchiver unarchiveObjectWithData:[NSKeyedArchiver archivedDataWithRootObject:_jobWelfareArray]];
    WEAKSELF
    vc.block = ^(JobModel *jobModel, NSArray *jobWelfareArray){
        _jobModel = jobModel;
        _jobWelfareArray = jobWelfareArray;
        [weakSelf.tableView reloadData];
    };
    [self.navigationController pushViewController:vc animated:YES];

}

#pragma mark - ***** PostJobCellType_date ******
/** 开始时间 */
- (void)btnDateStartOnclick:(UIButton*)sender{
    [self.view endEditing:YES];

    UIDatePicker *datepicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, 0, 300, 180)];
    [datepicker setDatePickerMode:UIDatePickerModeDate];
    NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];//设置 为中文
    datepicker.locale = locale;
    datepicker.timeZone = [NSTimeZone timeZoneWithName:@"Asia/beijing"];
    [datepicker addTarget:self action:@selector(datePickerValueChanged:) forControlEvents:UIControlEventValueChanged];

    // 设置时间限制
    NSDate *minDate = [DateHelper zeroTimeOfToday];
    [datepicker setMinimumDate:minDate];
 
    if (self.endDate) {
        [datepicker setMaximumDate:self.endDate];   // 开始时间必须小于结束日期
    }
    
    if (self.startDate != nil) {
        [datepicker setDate:self.startDate];
    }else{
        [datepicker setDate:[DateHelper zeroTimeOfToday]];
    }
    self.tmpDate = datepicker.date;
    WEAKSELF
    [XSJUIHelper showConfirmWithView:datepicker msg:nil title:@"选择时间" cancelBtnTitle:@"取消" okBtnTitle:@"确定" completion:^(DLAVAlertView *alertView, NSInteger buttonIndex) {
        if (buttonIndex == 1) {
            // 判断选择的工作时间是否比限制条件的短
            if ([weakSelf isWorkDateLessThanConditionDateWithStartDate]) {
                [UserData delayTask:0.4 onTimeEnd:^{
                    [UIHelper toast:@"兼职日期不可少于最少上岗天数"];
                }];
                return ;
            }
            weakSelf.startDate = weakSelf.tmpDate;
            [weakSelf.tableView reloadData];
        }
    }];
}

/** 结束时间 */
- (void)btnDateEndOnclick:(UIButton*)sender{
    [self.view endEditing:YES];
    
    if (!self.startDate) {
        [UIHelper toast:@"请先设置开始日期!"];
        return;
    }
    
    UIDatePicker *datepicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, 0, 300, 180)];
    [datepicker setDatePickerMode:UIDatePickerModeDate];
    NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];//设置 为中文
    datepicker.locale = locale;
    datepicker.timeZone = [NSTimeZone timeZoneWithName:@"Asia/beijing"];
    [datepicker addTarget:self action:@selector(datePickerValueChanged:) forControlEvents:UIControlEventValueChanged];
    
    // 设置时间限制
    NSDate *minDate = [DateHelper zeroTimeOfToday];
    if (self.startDate) {
        minDate = self.startDate; // 结束时间必须大于开始日期
    }
    [datepicker setMinimumDate:minDate];
    
    NSTimeInterval minTime = [minDate timeIntervalSince1970];
    NSTimeInterval maxTime = minTime + 60*60*24*89;
    NSDate *maxDate = [NSDate dateWithTimeIntervalSince1970:maxTime];
    
    [datepicker setMaximumDate:maxDate];

    // 值不为空时  为时间控件赋值为当前的值
    if (self.endDate) {
        if ([self.endDate isLaterThan:maxDate]) {
            [datepicker setDate:maxDate];
        }else{
            [datepicker setDate:self.endDate];
        }
    }else if (self.startDate){
        [datepicker setDate:self.startDate];
    } else {
        [datepicker setDate:[DateHelper zeroTimeOfToday]];
    }
    self.tmpDate = datepicker.date;
    WEAKSELF
    [XSJUIHelper showConfirmWithView:datepicker msg:nil title:@"选择时间" cancelBtnTitle:@"取消" okBtnTitle:@"确定" completion:^(DLAVAlertView *alertView, NSInteger buttonIndex) {
        if (buttonIndex == 1) {
            // 判断选择的工作时间是否比限制条件的短
            if ([weakSelf isWorkDateLessThanConditionDateWithEndDate]) {
                [UserData delayTask:0.4 onTimeEnd:^{
                    [UIHelper toast:@"兼职日期不可少于最少上岗天数"];
                }];
                return ;
            }
            weakSelf.endDate = weakSelf.tmpDate;
            [weakSelf.tableView reloadData];
        }
    }];
}

- (BOOL)isWorkDateLessThanConditionDateWithStartDate{
    NSDate *startDate = self.tmpDate;
    NSDate *endDate = self.endDate;
    return [self isWorkDateLessThanConditionDateWithStartDate:startDate endDate:endDate];
}

- (BOOL)isWorkDateLessThanConditionDateWithEndDate{
    NSDate *startDate = self.startDate;
    NSDate *endDate = self.tmpDate;
    return [self isWorkDateLessThanConditionDateWithStartDate:startDate endDate:endDate];
}

/** 判断工作日期是否小于条件限制的日期 */
- (BOOL)isWorkDateLessThanConditionDateWithStartDate:(NSDate *)startDate endDate:(NSDate *)endDate{
    if (!startDate || !endDate || !self.jobModel.apply_job_date) {
        return NO;
    }
    NSInteger days = [startDate daysEarlierThan:endDate] + 1;
    switch (self.jobModel.apply_job_date.integerValue) {
        case 2:{
            if (days < 2) return YES;
        }
            break;
        case 3:{
            if (days < 3) return YES;
        }
            break;
        case 5:{
            if (days < 5) return YES;
        }
            break;
        default:
            break;
    }
    return NO;
}

#pragma mark - ***** PostJobCellType_time ******
- (void)btnAddTimeOnclick:(UIButton*)sender{
    [self.view endEditing:YES];
    WEAKSELF
    SYDatePicker *datePicker = [[SYDatePicker alloc] init];
    [datePicker showDatePickerWithSelectedBlock:^(NSDate *startTime, NSDate *endTime) {
        [weakSelf selectTimeRangWithStartTime:startTime endTime:endTime];
        _totalHours = [weakSelf totalHours];
        [weakSelf.tableView reloadData];
    }];
}

- (void)selectTimeRangWithStartTime:(NSDate *)startTime endTime:(NSDate *)endTime{
    // 判断时间段是否重叠
    if (![self checkOverlapWithStartTime:startTime endTime:endTime]) {
        
        // 添加时间段
        NSInteger index = _timeBtnArray.count;
        TimeBtn *timeBtn = [TimeBtn timeBtnWithStartTime:startTime endTime:endTime target:self selector:@selector(timeBtnDelClick:)];
        timeBtn.tag = index;
        [_timeBtnArray addObject:timeBtn];
   
        // 排序
        [self sortTimeBtn];
    } else { // 重叠了, 刷新按钮显示
        for (TimeBtn *btn in _timeBtnArray) {
            [btn updateDisplay];
        }
    }
    // 最低薪资提示更新
//    [self checkLowestMoney];
}

/** 排序 */
- (void)sortTimeBtn{
    if (_timeBtnArray.count >= 2) {
        NSArray *tmpArray = [_timeBtnArray sortedArrayUsingComparator:^NSComparisonResult(TimeBtn *obj1, TimeBtn *obj2) {
            return [obj1.startTime compare:obj2.startTime];
        }];
        _timeBtnArray = [NSMutableArray arrayWithArray:tmpArray];
        
    }
    //存储按钮
    _postJobModel.addBtnArray = [NSMutableArray arrayWithArray:_timeBtnArray];
}


/** 判断时间段是否重叠 */
- (BOOL)checkOverlapWithStartTime:(NSDate *)startTime endTime:(NSDate *)endTime{
    BOOL isOverlap = NO;
    
    NSInteger count = _timeBtnArray.count;
    for (NSInteger i = 0; i < count; i++) {
        TimeBtn *timeBtn = _timeBtnArray[i];
        NSDate *tmpStartTime = timeBtn.startTime;
        NSDate *tmpEndTime = timeBtn.endTime;
        
        if ((startTime.timeIntervalSince1970 >= tmpStartTime.timeIntervalSince1970 && startTime.timeIntervalSince1970 <= tmpEndTime.timeIntervalSince1970)
            || (endTime.timeIntervalSince1970 >= tmpStartTime.timeIntervalSince1970 && endTime.timeIntervalSince1970 <= tmpEndTime.timeIntervalSince1970)
            || (startTime.timeIntervalSince1970 >= tmpStartTime.timeIntervalSince1970 && endTime.timeIntervalSince1970 <= tmpEndTime.timeIntervalSince1970)
            || (startTime.timeIntervalSince1970 <= tmpStartTime.timeIntervalSince1970 && endTime.timeIntervalSince1970 >= tmpEndTime.timeIntervalSince1970)) {
            
            NSDate *newStartTime = [self earlyDateBetweenDate:startTime andDate:tmpStartTime];
            NSDate *newEndTime = [self laterDateBetweenDate:endTime andDate:tmpEndTime];
            timeBtn.startTime = newStartTime;
            timeBtn.endTime = newEndTime;
            isOverlap = YES;
        }
    }
    
    if (isOverlap && _timeBtnArray.count >= 2) {
        TimeBtn *firstBtn = _timeBtnArray[0];
        TimeBtn *secBtn = _timeBtnArray[1];
        NSDate *firstBtnStartTime = firstBtn.startTime;
        NSDate *firstBtnEndTime = firstBtn.endTime;
        NSDate *secBtnStartTime = secBtn.startTime;
        NSDate *secBtnEndTime = secBtn.endTime;
        
        if ((firstBtnStartTime.timeIntervalSince1970 >= secBtnStartTime.timeIntervalSince1970 && firstBtnStartTime.timeIntervalSince1970 <= secBtnEndTime.timeIntervalSince1970)
            || (firstBtnEndTime.timeIntervalSince1970 >= secBtnStartTime.timeIntervalSince1970 && firstBtnEndTime.timeIntervalSince1970 <= secBtnEndTime.timeIntervalSince1970)
            || (firstBtnStartTime.timeIntervalSince1970 >= secBtnStartTime.timeIntervalSince1970 && firstBtnEndTime.timeIntervalSince1970 <= secBtnEndTime.timeIntervalSince1970)
            || (firstBtnStartTime.timeIntervalSince1970 <= secBtnStartTime.timeIntervalSince1970 && firstBtnEndTime.timeIntervalSince1970 >= secBtnEndTime.timeIntervalSince1970)) {
            
            NSDate *newStartTime = [self earlyDateBetweenDate:firstBtnStartTime andDate:secBtnStartTime];
            NSDate *newEndTime = [self laterDateBetweenDate:firstBtnEndTime andDate:secBtnEndTime];
            firstBtn.startTime = newStartTime;
            firstBtn.endTime = newEndTime;
            
            [self timeBtnDelClick:secBtn];
        }
    }
    
    return isOverlap;
}

- (void)timeBtnDelClick:(TimeBtn *)btn{
    
    // 删除按钮
    [_timeBtnArray removeObject:btn];
    [btn removeFromSuperview];
    
    //存储按钮
    _postJobModel.addBtnArray = [NSMutableArray arrayWithArray:_timeBtnArray];

    
    [self.tableView reloadData];
}

- (NSDate *)earlyDateBetweenDate:(NSDate *)aDate andDate:(NSDate *)otherDate{
    if (aDate.timeIntervalSince1970 > otherDate.timeIntervalSince1970) {
        return otherDate;
    }
    return aDate;
}

- (NSDate *)laterDateBetweenDate:(NSDate *)aDate andDate:(NSDate *)otherDate{
    if (aDate.timeIntervalSince1970 > otherDate.timeIntervalSince1970) {
        return aDate;
    }
    return otherDate;
}

/** 计算一天总共工作时间 */
- (CGFloat)totalHours{
    CGFloat totalHours = 0;
    for (TimeBtn *btn in _timeBtnArray) {
        totalHours += [self hoursBetweenBeginDate:btn.startTime andEndDate:btn.endTime];
    }
    return totalHours;
}
/** 通过NSDate计算时间差 */
- (CGFloat)hoursBetweenBeginDate:(NSDate *)beginDate andEndDate:(NSDate *)endDate{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSUInteger unit = NSCalendarUnitHour | NSCalendarUnitMinute;
    NSDateComponents *components = [calendar components:unit fromDate:beginDate toDate:endDate options:NSCalendarWrapComponents];
    CGFloat hours = components.hour + components.minute / 60.0;
    return hours;
}

#pragma mark - ***** PostJobCellType_applyEndDate ******
- (void)applyEndDateOnclick{
    [self.view endEditing:YES];
    if (!self.startDate || !self.endDate) {
        [UIHelper toast:@"请先设置起止日期!"];
        return;
    }
    
    UIDatePicker *datepicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, 0, 300, 180)];
    [datepicker setDatePickerMode:UIDatePickerModeDate];
    NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];//设置 为中文
    datepicker.locale = locale;
    datepicker.timeZone = [NSTimeZone timeZoneWithName:@"Asia/beijing"];
    [datepicker addTarget:self action:@selector(datePickerValueChanged:) forControlEvents:UIControlEventValueChanged];

    // 设置时间限制
    NSDate *minDate = [DateHelper zeroTimeOfToday];
    NSDate *maxDate = self.endDate;
    
    [datepicker setMinimumDate:minDate];
    [datepicker setMaximumDate:maxDate];
    
    // 值不为空时  为时间控件赋值为当前的值
    if (self.applyEndDate != nil) {
        [datepicker setDate:self.applyEndDate];
    }else{
        [datepicker setDate:minDate];
    }
    self.tmpDate = datepicker.date;

    WEAKSELF
    [XSJUIHelper showConfirmWithView:datepicker msg:nil title:@"选择时间" cancelBtnTitle:@"取消" okBtnTitle:@"确定" completion:^(DLAVAlertView *alertView, NSInteger buttonIndex) {
        if (buttonIndex == 1) {
            weakSelf.applyEndDate = weakSelf.tmpDate;
            [weakSelf.tableView reloadData];
        }
    }];
}

#pragma mark - ***** PostJobCellType_restrict ******
- (void)restrictOnclick{
    ConditionController *vc = [[ConditionController alloc] init];
    vc.jobModel = [NSKeyedUnarchiver unarchiveObjectWithData:[NSKeyedArchiver archivedDataWithRootObject:self.jobModel]];
    vc.startDate = self.startDate;
    vc.endDate = self.endDate;
    vc.block = ^(JobModel *jobModel){
        self.jobModel = jobModel;
    };
    [self.navigationController pushViewController:vc animated:YES];
}
/** 是否进行条件筛选 */
- (BOOL)isSetCondition{
    JobModel *jobModel = self.jobModel;
    if (jobModel.sex
        || (jobModel.age && jobModel.age.intValue != 0)
        || (jobModel.height && jobModel.height.intValue != 0)
        || (jobModel.rel_name_verify && jobModel.rel_name_verify.intValue != 0)
        || (jobModel.life_photo && jobModel.life_photo.intValue != 0)
        || jobModel.apply_job_date
        || (jobModel.health_cer && jobModel.health_cer.intValue != 0)
        || (jobModel.stu_id_card && jobModel.stu_id_card.intValue != 0)
        ) {
        return YES;
    }
    return NO;
}
//刷新视图
- (void)updateStatus{
    if (self.resBtn) {
        if ([self isSetCondition]) {
            [self.resBtn setTitle:@"已限制" forState:UIControlStateNormal];
        }else{
            [self.resBtn setTitle:@"限制条件" forState:UIControlStateNormal];
        }
    }
    [self updateBtn];
}
#pragma mark- PostJobCellType_MaxTime

- (void)btnAddMaxTimeInClick{
    
    [_timeBtnArray removeAllObjects];
    
    self.isSelectBtnMaxTime = YES;
    
    _postJobModel.selectAddMaxTime = YES;
    _postJobModel.selectAddTime = NO;
    
    [self.tableView reloadData];
    
}
- (void)btnAddTimeInclick{
    
    _postJobModel.selectAddMaxTime = NO;

    _postJobModel.selectAddTime = YES;
    
    _timeBtnArray =[NSMutableArray arrayWithArray:_postJobModel.addBtnArray] ;
    
    if (_timeBtnArray.count) {
        [self.tableView reloadData];

    }
    
}
#pragma mark - ***** PostJobCellType_area ******
- (void)areaOnclick{
    [self.view endEditing:YES];
//    AreaMapSelect_VC *viewCtrl = [[AreaMapSelect_VC alloc] init];
//    viewCtrl.block = ^(AMapPOI *poi){
//        self.jobModel.area_code = poi.citycode;
//        self.jobModel.admin_code = poi.adcode;
//        self.jobModel.working_place = poi.address;
//        [self.tableView reloadData];
//    };
//    [self.navigationController pushViewController:viewCtrl animated:YES];
//    WEAKSELF
//    CityModel *currectCity = [UserData sharedInstance].city;
////    if (self.areas && self.areas.count) {
//    NSMutableArray *items = [NSMutableArray array];
//    EPActionSheetItem *item = [[EPActionSheetItem alloc] initWithTitle:@"全市" arg:currectCity];
//    [items addObject:item];
//        // 添加子区域
//        for (CityModel *area in self.areas) {
//            EPActionSheetItem *item = [[EPActionSheetItem alloc] initWithTitle:area.name arg:area];
//            [items addObject:item];
//        }
//        MKActionSheet *sheet = [[MKActionSheet alloc] initWithTitle:@"请选择区域" objArray:items titleKey:@"title"];
//        sheet.maxShowButtonCount = 5.6;
//        [sheet showWithBlock:^(MKActionSheet *actionSheet, NSInteger buttonIndex) {
//            EPActionSheetItem *item = [items objectAtIndex:buttonIndex];
//            CityModel *area = item.arg;
//            
//            if (buttonIndex != 0) {
//                weakSelf.jobModel.address_area_id = area.id;
//            }else{
//                weakSelf.jobModel.address_area_id = nil;
//            }
//            if ((weakSelf.isEditAction && weakSelf.isUpload) || buttonIndex == 0) {
//                weakSelf.jobModel.working_area = area.name;
//            }else{
//                weakSelf.jobModel.working_area = [NSString stringWithFormat:@"%@%@", currectCity.name, area.name];
//            }
//            [weakSelf.tableView reloadData];
//        }];
////    }
    
    
    //选择城市
    CitySelectController* cityVC = [[CitySelectController alloc] init];
    
    WEAKSELF
    cityVC.showSubArea = YES;
    cityVC.showCityWide = YES;
    cityVC.isPushAction = YES;
    cityVC.didSelectCompleteBlock = ^(CityModel *area){
        if ([area isKindOfClass:[CityModel class]]) {
            if (area) {
                if (area.parent_id) {
                    weakSelf.jobModel.city_id = area.parent_id;
                    weakSelf.jobModel.city_name = area.parent_name;
                    weakSelf.jobModel.address_area_id = area.id;
                    weakSelf.jobModel.address_area_name = area.name;
                }else{
                    weakSelf.jobModel.city_id = area.id;
                    weakSelf.jobModel.city_name = area.name;
                    weakSelf.jobModel.address_area_id = nil;
                    weakSelf.jobModel.address_area_name = nil;
                }
                [weakSelf.tableView reloadData];
            }else{
                [UIHelper toast:@"没有城市信息"];
            }
        }
    };
    [self.navigationController pushViewController:cityVC animated:YES];
}

#pragma mark - ***** PostJobCellType_payMoney ******
- (void)btnSalaryUnitOnclick:(UIButton*)sender{
    [self.view endEditing:YES];

    NSMutableArray *titleArray = [NSMutableArray array];
    for (SalaryModel *salary in _unitArray) {
        [titleArray addObject:salary.unit_value];
    }
    WEAKSELF
    [MKActionSheet sheetWithTitle:@"请选择薪酬单位" buttonTitleArray:titleArray isNeedCancelButton:NO maxShowButtonCount:6 block:^(MKActionSheet *actionSheet, NSInteger buttonIndex) {
        if (buttonIndex < _unitArray.count) {
            SalaryModel *salary = [_unitArray objectAtIndex:buttonIndex];
            weakSelf.jobModel.salary.unit_value = salary.unit_value;
            weakSelf.jobModel.salary.unit = salary.unit;
            [weakSelf.tableView reloadData];
        }
    }];
}

#pragma mark - ***** PostJobCellType_payType ******
- (void)btnPayTimeOnclick:(UIButton*)sender{
    [self.view endEditing:YES];

    NSMutableArray *items = [NSMutableArray array];
    for (SalaryModel *salary in _salaryArray) {
        [items addObject:salary.settlement_value];
    }
    WEAKSELF
    [MKActionSheet sheetWithTitle:@"请选择薪酬单位" buttonTitleArray:items isNeedCancelButton:NO maxShowButtonCount:6 block:^(MKActionSheet *actionSheet, NSInteger buttonIndex) {
        if (buttonIndex < _salaryArray.count) {
            SalaryModel *salary = [_salaryArray objectAtIndex:buttonIndex];
            weakSelf.jobModel.salary.settlement_value = salary.settlement_value;
            weakSelf.jobModel.salary.settlement = salary.settlement;
            [weakSelf.tableView reloadData];
        }
    }];
}

- (void)btnPayWayOnclick:(UIButton*)sender{
    [self.view endEditing:YES];
    WEAKSELF
    [MKActionSheet sheetWithTitle:@"请选择支付方式" buttonTitleArray:_payWayArray isNeedCancelButton:NO maxShowButtonCount:6 block:^(MKActionSheet *actionSheet, NSInteger buttonIndex) {
        if (buttonIndex < _payWayArray.count) {
            weakSelf.jobModel.salary.pay_type = [SalaryModel getPayWayWith:[_payWayArray objectAtIndex:buttonIndex]];
            [weakSelf.tableView reloadData];
        }
    }];
}


#pragma mark - ***** PostJobCellType_send ******
/** 发布 */
- (void)btnSendOnclick:(UIButton*)sender{
    [self.view endEditing:YES];
    if (self.postJobType == PostJobType_bd && self.jobModel.salary.value.floatValue*100 < _lastDirectionMoney) {
        NSString* textStr = [NSString stringWithFormat:@"您当前设置的兼客工资低于包招市场平均水平，招聘难度较大，建议您调整为%.2f元/天。",_lastDirectionMoney*0.01];
        WEAKSELF
        [UIHelper showConfirmMsg:textStr title:@"提醒" cancelButton:@"调整工资" okButton:@"确定发布" completion:^(DLAVAlertView *alertView, NSInteger buttonIndex) {
            if (buttonIndex == 1) {
                [weakSelf makeSendData];
            }
        }];
    }else{
        [self makeSendData];
    }
}

- (void)makeSendData{
    // 标题
    if (!self.jobModel.job_title || self.jobModel.job_title.length < 1) {
        [UIHelper toast:@"岗位标题不能为空"];
        return;
    }

    // 岗位类型
    if (!self.jobModel.job_type_id) {
        [UIHelper toast:@"请选择岗位类型"];
        return;
    }
    
    // 时间
    if (!self.startDate) {
        [UIHelper toast:@"请选择开始日期"];
        return;
    }
    
    if (!self.endDate) {
        [UIHelper toast:@"请选择结束日期"];
        return;
    }

    if (((self.endDate.timeIntervalSince1970 - self.startDate.timeIntervalSince1970)+1) > (60*60*24*90)) {
        [UIHelper toast:@"岗位天数不能超过90天"];
        return;
    }
    if (!self.isSelectBtnMaxTime){
        if (!_timeBtnArray || !_timeBtnArray.count) {
            [UIHelper toast:@"请选择工作时间段"];
            return;
        }
    }
    // 报名截止日期
    if (!self.applyEndDate) {
        [UIHelper toast:@"请选择报名截止日期"];
        return;
    }
    // 区域
    if (!self.jobModel.city_id) {
        [UIHelper toast:@"请选择区域"];
        return;
    }
    // 详细位置
    if (!self.jobModel.working_place || self.jobModel.working_place.length < 1) {
        [UIHelper toast:@"详细工作地点不能为空"];
        return;
    }
    
    if (self.jobModel.working_place.length > 32 || self.jobModel.working_place.length < 6) {
        [UIHelper toast:@"详细工作地点长度为6-32字"];
        return;
    }
    
    // 招聘人数
    if (!self.jobModel.recruitment_num) {
        [UIHelper toast:@"招聘人数不能为空"];
        return;
    }
    if (self.jobModel.recruitment_num.integerValue < 1) {
        [UIHelper toast:@"招聘人数不能为0"];
        return;
    }
    
    // 岗位描述
    if (!self.jobModel.job_desc || self.jobModel.job_desc.length < 1) {
        [UIHelper toast:@"岗位描述不能为空"];
        return;
    }
    // 薪资
    if (!self.jobModel.salary.value) {
        [UIHelper toast:@"薪资不能为空"];
        return;
    }
    
    if (self.jobModel.salary.value.floatValue == 0) {
        [UIHelper toast:@"薪资不能为0"];
        return;
    }
    
    // 联系人
    if (!self.jobModel.contact.name || self.jobModel.contact.name.length < 2 || self.jobModel.contact.name.length > 10) {
        [UIHelper toast:@"请输入真实的联系人姓名"];
        return;
    }
    // 联系电话
    if (!self.jobModel.contact.phone_num || self.jobModel.contact.phone_num.length != 11) {
        [UIHelper toast:@"请输入正确的联系电话"];
        return;
    }
    // 发布须知已阅读
    if (!_isAgree) {
        [UIHelper toast:@"须同意《发布须知》才能发布岗位"];
        return;
    }
//    self.jobModel.working_place = [NSString stringWithFormat:@"%@%@", self.jobModel.working_area, self.jobModel.working_address];

    self.jobModel.working_place = self.jobModel.working_place;
    // 填充数据
    PostJobModel* postJobModel = [[PostJobModel alloc] init];
    postJobModel.job_title = self.jobModel.job_title;
    postJobModel.job_type = self.jobModel.job_type;
    postJobModel.job_type_id = self.jobModel.job_type_id;
    postJobModel.job_classfie_name = self.jobModel.job_classfie_name;
    postJobModel.job_desc = self.jobModel.job_desc;
    
    // 日期
    postJobModel.working_time_start_date = @(self.startDate.timeIntervalSince1970 * 1000);
    postJobModel.working_time_end_date = @(self.endDate.timeIntervalSince1970 * 1000);
    
    WorkTimePeriodModel *workTime = [[WorkTimePeriodModel alloc] init];
    NSInteger count = _timeBtnArray.count;
    for (NSInteger i = 0; i < count; i++) {
        TimeBtn *btn = _timeBtnArray[i];
        if (i == 0) {
            workTime.f_start = @(btn.startTime.timeIntervalSince1970 * 1000);
            workTime.f_end = @(btn.endTime.timeIntervalSince1970 * 1000);
        }
        if (i == 1) {
            workTime.s_start = @(btn.startTime.timeIntervalSince1970 * 1000);
            workTime.s_end = @(btn.endTime.timeIntervalSince1970 * 1000);
        }
        if (i == 2) {
            workTime.t_start = @(btn.startTime.timeIntervalSince1970 * 1000);
            workTime.t_end = @(btn.endTime.timeIntervalSince1970 * 1000);
        }
    }
    postJobModel.working_time_period = workTime; //工作时间段
    postJobModel.apply_dead_time = @(self.applyEndDate.timeIntervalSince1970 * 1000); // 报名截止日期
    
    postJobModel.city_id = self.jobModel.city_id;
    postJobModel.address_area_id = self.jobModel.address_area_id;
    postJobModel.working_place = self.jobModel.working_place;
    postJobModel.recruitment_num = self.jobModel.recruitment_num;
    postJobModel.map_coordinates = self.jobModel.map_coordinates;
    
    
    postJobModel.salary = [[SalaryModel alloc] init];
    postJobModel.salary.settlement = self.jobModel.salary.settlement;    // 结算方式
    postJobModel.salary.pay_type = self.jobModel.salary.pay_type;       // 支付方式
    postJobModel.salary.unit = self.jobModel.salary.unit;               // 支付单位
    
    
    if (self.postJobType == PostJobType_bd) {
        postJobModel.ent_publish_price = @(self.jobModel.salary.value.floatValue*100);
        //选择标签
        if (_bdJobTagSelArray && _bdJobTagSelArray.count > 0) {
            postJobModel.job_type_label = [NSArray arrayWithArray:_bdJobTagSelArray];
        }
    }else{
        postJobModel.salary.value = self.jobModel.salary.value;
    }

    // 委托招聘
    postJobModel.enable_recruitment_service = self.jobModel.enable_recruitment_service;
    
    // 筛选内容
    postJobModel.sex = self.jobModel.sex;
    postJobModel.age = self.jobModel.age;
    postJobModel.height = self.jobModel.height;
    postJobModel.rel_name_verify = self.jobModel.rel_name_verify;
    postJobModel.life_photo = self.jobModel.life_photo;
    postJobModel.apply_job_date = self.jobModel.apply_job_date;
    postJobModel.health_cer = self.jobModel.health_cer;
    postJobModel.stu_id_card = self.jobModel.stu_id_card;
    
    // 联系人 && 联系信息
    ContactModel *contact = [[ContactModel alloc] init];
    contact.name = self.jobModel.contact.name;
    contact.phone_num = self.jobModel.contact.phone_num;
    postJobModel.contact = contact;
    
    // 福利保障

    postJobModel.job_tags = [_jobWelfareArray filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"check_status.integerValue == 1"]];
    _postJobModel = postJobModel;
    
    // 发送请求
    WEAKSELF
    [self checkEPInfo:^(id result) {
        if (weakSelf.isEditAction) {    //编辑岗位
            [weakSelf editParttimeJob:^(id result) {
                [UIHelper toast:@"编辑成功"];
                [self popViewCtrl:[JobDetail_VC class]];
            }];
        }else if(weakSelf.isUpload){
            [weakSelf editParttimeJob:^(id result) {
                [weakSelf submitJob];
            }];
        }else{
            [weakSelf publishJobIsNewPhone:NO];
        }
    }];
}

- (void)submitJob{
    WEAKSELF
    [[XSJRequestHelper sharedInstance] entJobSubmitAuditWithJobId:self.jobId block:^(ResponseInfo *response) {
        if (response && response.success) {
            [WDNotificationCenter postNotificationName:IMNotification_EPMainHeaderViewUpdate object:nil];
            [weakSelf popViewCtrl:[JobDetail_VC class]];
        }
    }];
}

- (void)popViewCtrl:(Class)vcClass{
    [self.navigationController.childViewControllers enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(__kindof UIViewController * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:vcClass]) {
            MKBlockExec(self.block, nil);
            [self.navigationController popToViewController:obj animated:YES];
            *stop = YES;
            return;
        }
        if (idx == 0) {
            [self.navigationController popToRootViewControllerAnimated:YES];
        }
    }];
}

- (void)editParttimeJob:(MKBlock)block{
    WEAKSELF
    [[XSJRequestHelper sharedInstance] editParttimeJobServiceWithJobId:self.jobId parttimeJob:_postJobModel block:^(id result) {
        if (result) {
            [[UserData sharedInstance] setIsUpdateWithEPWaitJob:YES];
            MKBlockExec(block, nil);
        }
    }];
}

- (void)checkEPInfo:(MKBlock)block{
    [[UserData sharedInstance] getEPModelIsNeedUpdate:NO block:^(EPModel *epModel) {
        if (epModel) {
            if (!epModel.true_name.length || !epModel.industry_id || !epModel.city_id) {
                RegiseterGuide_VC *vc = [[RegiseterGuide_VC alloc] init];
                vc.isNotRergistAction = YES;
                vc.block = ^(id result){
                    MKBlockExec(block, @"还不开会？？");
                    [[UserData sharedInstance] getEPModelWithBlock:nil];
                };
                [self.navigationController pushViewController:vc animated:YES];
            }else{
                MKBlockExec(block, @"领导，你TM要拖到几点才开会啊？");
            }
        }
    }];
}

/** 发布 */
- (void)publishJobIsNewPhone:(BOOL)isNewPhone{
    // 发送请求
    NSString *parttimeJob = [_postJobModel getContent];
    NSNumber *useNewPhone = isNewPhone ? @(1) : @(0);
    NSString *content = [NSString stringWithFormat:@"\"parttime_job\":{%@}, \"use_new_phone\":%@", parttimeJob, useNewPhone.description];
    
    ELog(@"content:%@",content);
    
    WEAKSELF
    [[UserData sharedInstance] postParttimeJobWithContent:content block:^(ResponseInfo *response) {
        if (response && response.success) { // 发布成功
            [weakSelf publishSuccess:response];
        } else if (response.errCode.integerValue == 57) { // 使用了新号码
            [weakSelf checkNewPhonePost];
        } else if (response.errCode.integerValue == 91){ //敏感词提示
            [weakSelf checkSensitiveWords:response.errMsg];
        }
    }];
}
- (void)checkSensitiveWords:(NSString *)msg{
    //敏感词提示
//    [UIHelper showConfirmMsg:msg title:@"提示" cancelButton:@"确定" completion:^(DLAVAlertView *alertView, NSInteger buttonIndex) {
//        
//    }];
    
    [GuideMaskView showTitle:@"提示" content:msg cancel:nil commit:@"知道了" block:^(NSInteger result) {
        
    }];
   

}
- (void)checkNewPhonePost{
    NSString *msgStr = [NSString stringWithFormat:@"%@ 以前未发布过岗位哦，您确定使用该号码吗？", _postJobModel.contact.phone_num];
    // 确认发布
    WEAKSELF
    [UIHelper showConfirmMsg:msgStr title:@"注意" okButton:@"确定" completion:^(DLAVAlertView *alertView, NSInteger buttonIndex) {
        if (buttonIndex == 0) {
            return;
        }else if (buttonIndex == 1){
            [weakSelf publishJobIsNewPhone:YES];
        }
    }];
}

/** 发布完成动作 */
- (void)publishSuccess:(ResponseInfo *)response{
    [[UserData sharedInstance] setIsUpdateWithEPHome:YES];
    [[UserData sharedInstance] setIsUpdateWithEPWaitJob:YES];
    [WDNotificationCenter postNotificationName:IMNotification_EPMainHeaderViewUpdate object:nil];
    
    PostJobSuccess_VC *viewCtrl = [[PostJobSuccess_VC alloc] init];
    viewCtrl.jobId = [response.content objectForKey:@"job_id"];
    viewCtrl.jobStatus = [response.content objectForKey:@"job_status"];
    viewCtrl.jobModel = self.jobModel;
    viewCtrl.is_need_recommend = [response.content objectForKey:@"is_need_recommend"];
    [self.navigationController pushViewController:viewCtrl animated:YES];
}

/** 发布协议 */
- (void)btnAgreementOnclick:(UIButton*)sender{
    WebView_VC* vc = [[WebView_VC alloc] init];
    vc.url = [NSString stringWithFormat:@"%@%@", URL_HttpServer, kUrl_releaseAgree];
    vc.fixednessTitle = @"发布协议";
    [self.navigationController pushViewController:vc animated:YES];
}

/** 是否同意发布协议 */
- (void)btnAgreeChooseOnclick:(UIButton*)sender{
    sender.selected = !sender.selected;
    _isAgree = sender.selected;
}

#pragma mark - ***** UITextField edit end ******
- (void)tfTextEditEnd:(UITextField*)textField{
    NSInteger tag = textField.tag;
    switch (tag) {
//        case PostJobCellType_concentrate:
//            self.jobModel.working_place = textField.text;
//            break;
        case PostJobCellType_maxJKCount:
            self.jobModel.recruitment_num = @(textField.text.integerValue);
            break;
        case 1000:  //联系人
            self.jobModel.contact.name = textField.text;
            break;
        case 1001:  //联系电话
            self.jobModel.contact.phone_num = textField.text;
            break;
        case PostJobCellType_payMoney:
            self.jobModel.salary.value = @(textField.text.floatValue);
            break;
        case PostJobCellType_workAddress:
            self.jobModel.working_place = textField.text;
            break;
        default:
            break;
    }
}

- (void)tfTextEditChange:(UITextField*)textField{
    NSInteger tag = textField.tag;
    switch (tag) {
        case PostJobCellType_maxJKCount:
            if (textField.text.length > 3) {
                textField.text = [textField.text substringToIndex:3];
            }
            self.jobModel.recruitment_num = @(textField.text.integerValue);
            break;
        case 1001:
            if (textField.text.length > 11) {
                textField.text = [textField.text substringToIndex:11];
            }
            self.jobModel.contact.phone_num = textField.text;
            break;
        case PostJobCellType_payMoney:
            [self constraintMoneyInputWithLength:9 textField:textField];
            self.jobModel.salary.value = @(textField.text.floatValue);
            ELog(@"num:%@",self.jobModel.salary.value);
            break;
        case PostJobCellType_workAddress:
            if (textField.text.length > 32) {
                textField.text = [textField.text substringToIndex:32];
            }
            self.jobModel.working_place = textField.text;
            break;
        default:
            break;
    }
}

/** 约束薪资输入 */
- (void)constraintMoneyInputWithLength:(NSInteger)length textField:(UITextField *)sender{
    NSRange range = [sender.text rangeOfString:@"."];
    if (range.location != NSNotFound) { // 有小数点
        if (sender.text.length == 1) {
            sender.text = @"";
            return;
        }
        if (sender.text.length > length + 2) {
            sender.text = [sender.text substringToIndex:length + 2];
        }
        if (range.location < sender.text.length - 1) {
            sender.text = [sender.text substringToIndex:range.location + 2];
        }
        sender.text = [sender.text stringByReplacingOccurrencesOfString:@".." withString:@"."];
        if ([sender.text rangeOfString:@"."].location == 0) {
            sender.text = [sender.text stringByReplacingOccurrencesOfString:@"." withString:@""];
        }
    } else { // 没有小数点
        if (sender.text.length > length) {
            sender.text = [sender.text substringToIndex:length];
        }
    }
}

#pragma mark - ***** UIDatePick Changed ******
- (void)datePickerValueChanged:(UIDatePicker *)datePicker{
    if (datePicker.date) {
        self.tmpDate = datePicker.date;
    }
}

#pragma mark - ***** other ******
/** 判断当天是否已发布超过3或7次 */
- (void)checkPublishedNum{
    if (self.isShowTip) {
        self.tableView.tableHeaderView = [self setupTopView:nil isShowLeftPostNum:NO];
    }
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

/** 无网络显示 */
- (void)noInternet{
    self.noSignalView = [UIHelper noDataViewWithTitle:@"啊噢,网络不见了" image:@"v3_public_nowifi"];
    [self.view addSubview:self.noSignalView];
    self.noSignalView.centerX = self.view.centerX;
    self.noSignalView.y = 200;
}
//性别懒加载
- (ConditionSheet *)sexSheet{
    if (!_sexSheet) {
        NSNumber *sex = self.jobModel.sex;
        ConditionSheetItem *other = [[ConditionSheetItem alloc] initWithTitle:@"不限" selected:(sex ? NO : YES) enable:YES arg:nil];
        ConditionSheetItem *man = [[ConditionSheetItem alloc] initWithTitle:@"男" selected:(sex && sex.integerValue == 1 ? YES : NO) enable:YES arg:@(1)];
        ConditionSheetItem *women = [[ConditionSheetItem alloc] initWithTitle:@"女" selected:(sex && sex.integerValue == 0 ? YES : NO) enable:YES arg:@(0)];
        
        WEAKSELF
        _sexSheet = [[ConditionSheet alloc] initWithItems:@[other, man, women] complentBlock:^(NSInteger index, NSNumber *arg) {
            weakSelf.jobModel.sex = arg;
            [weakSelf.tableView reloadData];
        }];
    }
    return _sexSheet;
}

#pragma mark - ***** 合伙人发布 业务 ******
- (void)publishWithPartner{
    [[XSJRequestHelper sharedInstance] queryAccountMoneyWithBlock:^(ResponseInfo *response) {
        if (response && response.success) {
            AccountMoneyModel *account = [AccountMoneyModel objectWithKeyValues:response.content[@"account_money_info"]];
            _postJobModel.recruitment_amount = account.recruitment_amount;
            
            PostJobAlertView *alertView = [PostJobAlertView showAlertView];
            alertView.delegate = self;
            [alertView setPostJobModel:_postJobModel andEpModel:_epModel];
        }
    }];
}

/** PostJobAlertViewDelegate */
- (void)PostJobAlertView:(PostJobAlertView *)view actionType:(ActionType)actionType needPayMoney:(NSInteger)money{
    switch (actionType) {
        case ActionTypeConfirm:{
            [self publishJobIsNewPhone:NO];
        }
            break;
        case ActionTypePay:{
            if (money > 0) {
                PaySelect_VC *vc = [[PaySelect_VC alloc] init];
                vc.fromType = PaySelectFromType_partnerPostJob;
                vc.needPayMoney = (int)money;
                WEAKSELF
                vc.partnerPostJobPayBlock = ^(id obj){
                    [weakSelf publishJobIsNewPhone:NO];
                };
                [self.navigationController pushViewController:vc animated:YES];
            }
        }
            break;
    }
}

- (BOOL)checkShowWarn{
    // 标题
    if (self.jobModel.job_title.length) {
        return YES;
    }
    
    // 岗位类型
    if (self.jobModel.job_type_id) {
        return YES;
    }
    
    // 时间
    if (self.startDate) {
        return YES;
    }
    
    if (self.endDate) {
        return YES;
    }

    
    if (_timeBtnArray.count) {
        return YES;
    }
    // 报名截止日期
    if (self.applyEndDate) {
        return YES;
    }
    // 区域
    if (self.jobModel.address_area_id) {
        return YES;
    }

    // 详细位置
    if (self.jobModel.working_place.length) {
        return YES;
    }
    
    // 招聘人数
    if (self.jobModel.recruitment_num.integerValue) {
        return YES;
    }
    
    // 岗位描述
    if (self.jobModel.job_desc.length) {
        return YES;
    }
    // 薪资
    if (self.jobModel.salary.value.floatValue) {
        return YES;
    }
    
    return NO;
}

- (void)backToLastView{
    [self.view endEditing:YES];
    if ([self checkShowWarn]) {
        [MKAlertView alertWithTitle:nil message:@"退出后，您编辑的信息将不会保存，请确认是否退出" cancelButtonTitle:@"果断退出" confirmButtonTitle:@"继续发布" completion:^(UIAlertView *alertView, NSInteger buttonIndex) {
            if (buttonIndex == 0) {
                [self.navigationController popViewControllerAnimated:YES];
            }
        }];
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
