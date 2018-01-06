//
//  PostPersonalJob_VC.m
//  JKHire
//
//  Created by fire on 16/10/11.
//  Copyright © 2016年 xianshijian. All rights reserved.
//

#import "PostPersonalJob_VC.h"
#import "ModelManage.h"
#import "CityTool.h"

#import "AreaMapSelect_VC.h"
#import "JobTypeList_VC.h"
#import "PersonalJobList_VC.h"
#import "PersonalList_VC.h"
#import "TeamServiceList_VC.h"
#import "HistoryTeamJobList_VC.h"
#import "SuccessPostPerson_VC.h"
#import "WebView_VC.h"

#import "PersonalPostCell_Title.h"
#import "PostJobCell_textField.h"
#import "PostJobCell_select.h"
#import "PostJobCell_date.h"
#import "PostJobCell_time.h"
#import "PostJobCell_twoEdit.h"
#import "PostJobCell_des.h"
#import "PostJobCell_send.h"
#import "PostTeamCell_Money.h"
#import "SYDatePicker.h"
#import "TimeBtn.h"

#import "PostJobModel.h"
#import "JobClassifyInfoModel.h"
#import "JobModel.h"

@interface PostPersonalJob_VC () <PostJobCellDateDelegate,PostJobCellTimeDelegate, PostJobCellTwoEditDelegate, PostJobCellSendDelegate> {
    PostJobModel *_postJobModel;    //发布需求模型
    NSMutableArray *_timeBtnArray;
    CGFloat _totalHours;                /*!< 一共多少工作小时 */
    NSArray *_unitArray;        /*!< 结算单位 */
}

//@property (nonatomic, strong) NSMutableArray *firstSectionArr;
//@property (nonatomic, strong) NSMutableArray *secondSectionArr;

@property (nonatomic, strong) NSDate *startDate;    /*!< 开始日期 */
@property (nonatomic, strong) NSDate *endDate;      /*!< 结束日期 */
@property (nonatomic, strong) NSDate *applyEndDate; /*!< 报名截止日期 */

@property (nonatomic, strong) NSDate *tmpDate;      /*!< 临时变量 */
@property (nonatomic, strong) NSLayoutConstraint *layoutTimeViewHeight; /*!< 时间View高度约束 */

@end

@implementation PostPersonalJob_VC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"描述需求";
    [self setupViews];
}

- (void)setupViews{
    NSAssert((_sourceType > 0), @"sourceType一定要赋值");
    [self setupData];
    self.tableViewStyle = UITableViewStyleGrouped;
    [self initUIWithType:DisplayTypeOnlyTableView];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerNib:nib(@"PersonalPostCell_Title") forCellReuseIdentifier:@"PersonalPostCell_Title"];
    [self.tableView registerNib:nib(@"PostJobCell_select") forCellReuseIdentifier:@"PostJobCell_select"];
    [self.tableView registerNib:nib(@"PostJobCell_date") forCellReuseIdentifier:@"PostJobCell_date"];
    [self.tableView registerNib:nib(@"PostJobCell_time") forCellReuseIdentifier:@"PostJobCell_time"];
    [self.tableView registerNib:nib(@"PostJobCell_twoEdit") forCellReuseIdentifier:@"PostJobCell_twoEdit"];
    [self.tableView registerNib:nib(@"PostJobCell_send") forCellReuseIdentifier:@"PostJobCell_send"];
    [self.tableView registerNib:nib(@"PostJobCell_des") forCellReuseIdentifier:@"PostJobCell_des"];
    if (_sourceType == ViewSourceType_PostTeamJob || _sourceType == ViewSourceType_InviteTeamJob) {
        [self.tableView registerNib:nib(@"PostTeamCell_Money") forCellReuseIdentifier:@"PostTeamCell_Money"];
        [self.tableView registerNib:nib(@"PostJobCell_textField") forCellReuseIdentifier:@"PostJobCell_textField"];
    }
}

- (void)setupData{
    _postJobModel = [[PostJobModel alloc] init];
    _timeBtnArray = [[NSMutableArray alloc] init];
    _unitArray = [SalaryModel salaryArray];
    
    SalaryModel *salary = [[SalaryModel alloc] init];
    salary.unit = @(1); // 元/天
    salary.unit_value = [salary getUnitValue];
    _postJobModel.salary = salary;
    NSMutableArray *firstSectionArr = [NSMutableArray array];
    NSMutableArray *secondSectionArr = [NSMutableArray array];
    NSMutableArray *thirdArr = [NSMutableArray array];
    
    
    switch (_sourceType) {
        case ViewSourceType_InvitePersonalJob:{
            NSAssert((self.serviceType), @"从个人服务列表进入,serviceType必须传值");
            _postJobModel.job_classfie_name = [ModelManage getJobClassfiyNameWithServiceType:_serviceType];
            _postJobModel.service_type = _serviceType;
            
            [thirdArr addObject:@(PostJobCellType_chooseJob)];
            [self.dataSource addObject:thirdArr];
        }
        case ViewSourceType_PostPersonalJob:{
            self.title = @"发布通告";
            [firstSectionArr addObject:@(PostJobCellType_title)];
            [firstSectionArr addObject:@(PostJobCellType_jobType)];
            [firstSectionArr addObject:@(PostJobCellType_jobClassify)];
            [firstSectionArr addObject:@(PostJobCellType_chooseSex)];
            [firstSectionArr addObject:@(PostJobCellType_area)];
            [firstSectionArr addObject:@(PostJobCellType_date)];
            [firstSectionArr addObject:@(PostJobCellType_time)];
            [firstSectionArr addObject:@(PostJobCellType_payMoney)];
            
            [secondSectionArr addObject:@(PostJobCellType_detail)];
            [secondSectionArr addObject:@(PostJobCellType_send)];
            
            [self.dataSource addObject:firstSectionArr];
            [self.dataSource addObject:secondSectionArr];
        }
            break;
        case ViewSourceType_InviteTeamJob:{
            _postJobModel.service_classify_id = self.service_classify_id;
            _postJobModel.service_classify_name = self.service_classify_name;
            [secondSectionArr addObject:@(PostJobCellType_chooseJob)];
            [self.dataSource addObject:secondSectionArr];
        }
        case ViewSourceType_PostTeamJob:{
            _postJobModel.city_id = [UserData sharedInstance].city.id ? [UserData sharedInstance].city.id : @211 ;
            _postJobModel.city_name = [UserData sharedInstance].city.name ? [UserData sharedInstance].city.name : @"福州" ;
            [firstSectionArr addObject:@(PostJobCellType_title)];
            [firstSectionArr addObject:@(PostJobCellType_jobType)];
            [firstSectionArr addObject:@(PostJobCellType_maxJKCount)];
            [firstSectionArr addObject:@(PostJobCellType_chooseCity)];
            [firstSectionArr addObject:@(PostJobCellType_date)];
            [firstSectionArr addObject:@(PostJobCellType_payPreMoney)];
            [firstSectionArr addObject:@(PostJobCellType_nextStep)];
            
            [self.dataSource addObject:firstSectionArr];
        }
            break;
        default:
            break;
    }
    
}

#pragma mark - uitableview datasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.dataSource ? self.dataSource.count : 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSArray *array = [self.dataSource objectAtIndex:section];
    return array.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    PostJobCellType type = [self cellTypeAtIndexPath:indexPath];
    NSString *identifier;
    switch (type) {
        case PostJobCellType_title:
            identifier = @"PersonalPostCell_Title";
            break;
        case PostJobCellType_chooseJob:
        case PostJobCellType_jobType:
        case PostJobCellType_area:
        case PostJobCellType_chooseCity:
        case PostJobCellType_jobClassify:
        case PostJobCellType_chooseSex:{
            PostJobCell_select *selectCell = [tableView dequeueReusableCellWithIdentifier:@"PostJobCell_select" forIndexPath:indexPath];
            [selectCell setModel:_postJobModel jobCellType:@(type) sourceType:_sourceType];
            return selectCell;
        }
        case PostJobCellType_date:{
            PostJobCell_date *dateCell = [tableView dequeueReusableCellWithIdentifier:@"PostJobCell_date" forIndexPath:indexPath];
            [dateCell setStartDate:self.startDate endDate:self.endDate jobCellType:@(type)];
            dateCell.delegate = self;
            return dateCell;
        }
        case PostJobCellType_time:{
            PostJobCell_time *timeCell = [tableView dequeueReusableCellWithIdentifier:@"PostJobCell_time" forIndexPath:indexPath];
            timeCell.delegate = self;
            [timeCell setModel:_postJobModel timeBtnArray:_timeBtnArray];
            self.layoutTimeViewHeight = timeCell.layoutViewHeight;
            return timeCell;
        }
        case PostJobCellType_payMoney:{
            PostJobCell_twoEdit *payCell = [tableView dequeueReusableCellWithIdentifier:@"PostJobCell_twoEdit" forIndexPath:indexPath];
            payCell.delegate = self;
            [payCell setModel:_postJobModel];
            return payCell;
        }
        case PostJobCellType_detail:{
            PostJobCell_des *desCell = [tableView dequeueReusableCellWithIdentifier:@"PostJobCell_des" forIndexPath:indexPath];
            [desCell setModel:_postJobModel];
            return desCell;
        }
        case PostJobCellType_nextStep:
        case PostJobCellType_send:{
            PostJobCell_send *sendCell = [tableView dequeueReusableCellWithIdentifier:@"PostJobCell_send" forIndexPath:indexPath];
            sendCell.delegate = self;
            [sendCell setSourceType:_sourceType withModel:_postJobModel];
            return sendCell;
        }
        case PostJobCellType_payPreMoney:{
            PostTeamCell_Money *moneyCell = [tableView dequeueReusableCellWithIdentifier:@"PostTeamCell_Money" forIndexPath:indexPath];
            [moneyCell setModel:_postJobModel];
            return moneyCell;
        }
        case PostJobCellType_maxJKCount:{
            PostJobCell_textField *cell = [PostJobCell_textField cellWithTableView:tableView];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            cell.tfText.placeholder = @"总人数";
            [cell.tfText addTarget:self action:@selector(tfTextEditEnd:) forControlEvents:UIControlEventEditingDidEnd];
            [cell.tfText addTarget:self action:@selector(tfTextEditChange:) forControlEvents:UIControlEventEditingChanged];
            cell.tfText.tag = PostJobCellType_maxJKCount;
            cell.tfText.keyboardType = UIKeyboardTypeNumberPad;
            cell.btnGetLocation.hidden = YES;
            
            if (_postJobModel.recruitment_num.integerValue > 0) {
                cell.tfText.text = [NSString stringWithFormat:@"%@",_postJobModel.recruitment_num];
            }
            
            return cell;
        }
        default:
            break;
    }
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
    if ([cell respondsToSelector:@selector(setModel:jobCellType:)]) {
        [cell performSelector:@selector(setModel:jobCellType:) withObject:_postJobModel withObject:@(type)];
    }
    return cell;
}

#pragma mark - uitableview delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    PostJobCellType type = [self cellTypeAtIndexPath:indexPath];
    switch (type) {
        case PostJobCellType_chooseJob:{
            [self choosePostedJob];
        }
            break;
        case PostJobCellType_area:{
            [self areaSelectAction];
        }
            break;
        case PostJobCellType_jobType:{
            if (self.sourceType == ViewSourceType_InvitePersonalJob || self.sourceType == ViewSourceType_InviteTeamJob) {
                return;
            }
            [self jobTagAction];
        }
            break;
        case PostJobCellType_jobClassify:{
            [self showServiceClassify];
        }
            break;
        case PostJobCellType_chooseSex:{
            [self shooseSexAction];
        }
            break;
        default:
            break;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    PostJobCellType cellType = [self cellTypeAtIndexPath:indexPath];
    switch (cellType) {
        case PostJobCellType_chooseJob:
        case PostJobCellType_title:
        case PostJobCellType_jobType:
        case PostJobCellType_date:
        case PostJobCellType_applyEndDate:
        case PostJobCellType_area:
        case PostJobCellType_payMoney:
        case PostJobCellType_maxJKCount:
        case PostJobCellType_chooseCity:
        case PostJobCellType_payPreMoney:
        case PostJobCellType_nextStep:
        case PostJobCellType_jobClassify:
        case PostJobCellType_chooseSex:
        case PostJobCellType_send:
            return 55;
        case PostJobCellType_time:
            return self.layoutTimeViewHeight.constant;
        case PostJobCellType_remind:
            return 32;
        case PostJobCellType_detail:
            return 150;
        default:
            break;
    }
    return 55;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.1f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section == 0) {
        return 20.0f;
    }
    return 0.1f;
}

#pragma mark - ***** UITextField edit end ******
- (void)tfTextEditEnd:(UITextField*)textField{
    NSInteger tag = textField.tag;
    switch (tag) {
        case PostJobCellType_maxJKCount:
            _postJobModel.recruitment_num = @(textField.text.integerValue);
            break;
        case 1000:  //联系人
            _postJobModel.contact.name = textField.text;
            break;
        case 1001:  //联系电话
            _postJobModel.contact.phone_num = textField.text;
            break;
        case PostJobCellType_payMoney:
            _postJobModel.salary.value = @(textField.text.floatValue);
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
            _postJobModel.recruitment_num = @(textField.text.integerValue);
            break;
        case 1001:
            if (textField.text.length > 11) {
                textField.text = [textField.text substringToIndex:11];
            }
            _postJobModel.contact.phone_num = textField.text;
            break;
        case PostJobCellType_payMoney:
//            [self constraintMoneyInputWithLength:4 textField:textField];
//            _postJobModel.salary.value = @(textField.text.floatValue);
//            ELog(@"num:%@",_postJobModel.salary.value);
            break;
        default:
            break;
    }
}

#pragma mark - PostJobCellDate delegate

- (void)btnDateStartOnclick{
    [self.view endEditing:YES];
    
    UIDatePicker *datepicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, 0, 300, 180)];
    [datepicker setDatePickerMode:UIDatePickerModeDate];
    NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];//设置 为中文
    datepicker.locale = locale;
    datepicker.timeZone = [NSTimeZone timeZoneWithName:@"Asia/beijing"];
    
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
            self.startDate = datepicker.date;
            [weakSelf.tableView reloadData];
        }
    }];
}

- (void)btnDateEndOnclick{
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
            self.endDate = datepicker.date;
            [weakSelf.tableView reloadData];
        }
    }];

}

#pragma mark - PostJobCelTime delegate

- (void)btnAddTimeOnclick{
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

#pragma mark - 

- (void)btnSalaryUnitOnclick{
    [self.view endEditing:YES];
    
    NSMutableArray *titleArray = [NSMutableArray array];
    for (SalaryModel *salary in _unitArray) {
        [titleArray addObject:salary.unit_value];
    }
    WEAKSELF
    [MKActionSheet sheetWithTitle:@"请选择薪酬单位" buttonTitleArray:titleArray isNeedCancelButton:NO maxShowButtonCount:6 block:^(MKActionSheet *actionSheet, NSInteger buttonIndex) {
        if (buttonIndex < _unitArray.count) {
            SalaryModel *salary = [_unitArray objectAtIndex:buttonIndex];
            _postJobModel.salary.unit_value = salary.unit_value;
            _postJobModel.salary.unit = salary.unit;
            [weakSelf.tableView reloadData];
        }
    }];
}

#pragma mark - PostJobCellSendDelegate

- (void)btnSendOnClickWithActionType:(ViewSourceType)actionType{
    [self.view endEditing:YES];
    switch (actionType) {
        case ViewSourceType_PostPersonalJob:
        case ViewSourceType_InvitePersonalJob:
            [self postPersonalJob];
            break;
        case ViewSourceType_PostTeamJob:
        case ViewSourceType_InviteTeamJob:
            [self postTeamJob];
            break;
        default:
            break;
    }
}

#pragma mark - 自定义方法

- (PostJobCellType)cellTypeAtIndexPath:(NSIndexPath *)indexPath{
   return [[[self.dataSource objectAtIndex:indexPath.section] objectAtIndex:indexPath.row] integerValue];
}

- (void)postPersonalJob{
    // 标题
    if (!_postJobModel.service_title || _postJobModel.service_title.length < 1) {
        [UIHelper toast:@"服务名称不能为空"];
        return;
    }
    
    // 岗位类型
    if (!_postJobModel.service_type) {
        [UIHelper toast:@"请选择服务类型"];
        return;
    }
    
    //二级分类
    if (!_postJobModel.service_type_classify_id) {
        [UIHelper toast:@"请选择分类"];
        return;
    }
    
    // 区域
    if (!_postJobModel.area_code && !_postJobModel.admin_code) {
        [UIHelper toast:@"请选择集合地点"];
        return;
    }
    // 详细位置
    if (!_postJobModel.working_place || _postJobModel.working_place.length < 1) {
        [UIHelper toast:@"详细工作地点不能为空"];
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
        [UIHelper toast:@"个人需求天数不能超过90天"];
        return;
    }
    
    if (!_timeBtnArray || !_timeBtnArray.count) {
        [UIHelper toast:@"请选择工作时间段"];
        return;
    }
    
    // 薪资
    if (!_postJobModel.salary.value) {
        [UIHelper toast:@"薪资不能为空"];
        return;
    }
    
    if (_postJobModel.salary.value.floatValue == 0) {
        [UIHelper toast:@"薪资不能为0"];
        return;
    }
    
    // 岗位描述
    if (!_postJobModel.service_desc || _postJobModel.service_desc.length < 1) {
        [UIHelper toast:@"需求描述不能为空"];
        return;
    }
    
    _postJobModel.working_time_start_date = @(self.startDate.timeIntervalSince1970 * 1000);
    _postJobModel.working_time_end_date = @(self.endDate.timeIntervalSince1970 * 1000);
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
    _postJobModel.working_time_period = workTime; //工作时间段
    
    [self postJobAboutPersonal];
}

- (void)postTeamJob{
    [self.view endEditing:YES];
    // 岗位类型
    if (!_postJobModel.service_classify_id) {
        [UIHelper toast:@"请选择服务类型"];
        return;
    }
    
    // 招聘人数
    if (!_postJobModel.recruitment_num) {
        [UIHelper toast:@"招聘人数不能为空"];
        return;
    }
    
    if (_postJobModel.recruitment_num.integerValue < 1) {
        [UIHelper toast:@"招聘人数不能为0"];
        return;
    }
    
    // 所在城市
    if (!_postJobModel.city_id) {
        [UIHelper toast:@"请选择城市"];
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
    // 预算
    if (!_postJobModel.budget_amount) {
        [UIHelper toast:@"预算金额不能为空"];
        return;
    }
    
    if (_postJobModel.budget_amount.floatValue == 0) {
        [UIHelper toast:@"预算金额不能为0"];
        return;
    }
    
    _postJobModel.working_time_start_date = @(self.startDate.timeIntervalSince1970 * 1000);
    _postJobModel.working_time_end_date = @(self.endDate.timeIntervalSince1970 * 1000);

    [self postJobAboutTeam];
}

- (void)postJobAboutPersonal{
    [[UserData sharedInstance] userNameIsExact:^(id result) {
        WEAKSELF
        [[XSJRequestHelper sharedInstance] postServicePersonalJob:_postJobModel block:^(ResponseInfo *response) {
            if (response) {
                [UserData sharedInstance].hasPostPersonalService = YES;
                NSNumber *serViceJobId = [response.content objectForKey:@"service_personal_job_id"];
                if (_sourceType == ViewSourceType_InvitePersonalJob) {
                    ELog(@"直接邀约");
                    [[XSJRequestHelper sharedInstance] entInviteServicePersonal:weakSelf.stu_account_id serviceJobId:serViceJobId block:^(id result) {
                        if (result) {
                            ELog(@"进入邀约成功页");
                            SuccessPostPerson_VC *successViewCtrl = [[SuccessPostPerson_VC alloc] init];
                            successViewCtrl.personServiceType = weakSelf.serviceType;
                            successViewCtrl.service_personal_job_id = serViceJobId;
                            [weakSelf.navigationController pushViewController:successViewCtrl animated:YES];
                        }
                    }];
                    return;
                }
                ELog(@"进入个人服务列表");
                PersonalList_VC *viewCtrl = [[PersonalList_VC alloc] init];
                viewCtrl.servicePersonType = [ModelManage getServiceTypeFromNSNumber:_postJobModel.service_type];
                viewCtrl.sourceType = _sourceType;
                viewCtrl.service_personal_job_id = serViceJobId;
                [weakSelf.navigationController pushViewController:viewCtrl animated:YES];
            }
        }];
    }];
}

- (void)postJobAboutTeam{
    [[UserData sharedInstance] userNameIsExact:^(id result) {
        WEAKSELF
        [[XSJRequestHelper sharedInstance] postServiceTeamJobWithModel:_postJobModel block:^(ResponseInfo *response) {
            if (response) {
                if (_sourceType == ViewSourceType_InviteTeamJob) {
                    ELog(@"直接邀约");
                    NSNumber *serViceJobId = [response.content objectForKey:@"service_team_job_id"];
                    [[XSJRequestHelper sharedInstance] entOrderServiceTeam:self.service_apply_id teamJobId:serViceJobId block:^(id result) {
                        if (result) {
                            [UIHelper toast:@"预约成功"];
                            WebView_VC *viewCtrl = [[WebView_VC alloc] init];
                            viewCtrl.isFromTeamPost = YES;
                            NSString *url = [NSString stringWithFormat:@"%@%@?service_apply_id=%@", URL_HttpServer, KUrl_ServiceTeamDetail, self.service_apply_id];
                            url = (serViceJobId) ? [url stringByAppendingFormat:@"&service_team_job_id=%@", serViceJobId] : url ;
                            viewCtrl.url = url;
                            [self.navigationController pushViewController:viewCtrl animated:YES];
                        }
                    }];
                    return;
                }
                ELog(@"进入团队服务商列表");
                TeamServiceList_VC *viewCtrl = [[TeamServiceList_VC alloc] init];
                viewCtrl.cityId = _postJobModel.city_id;
                viewCtrl.service_classify_id = _postJobModel.service_classify_id;
                viewCtrl.service_team_job_id = [response.content objectForKey:@"service_team_job_id"];
                [weakSelf.navigationController pushViewController:viewCtrl animated:YES];
            }
        }];
    }];
    
}

- (void)areaSelectAction{
    [self.view endEditing:YES];
    AreaMapSelect_VC *viewCtrl = [[AreaMapSelect_VC alloc] init];
    viewCtrl.block = ^(AMapPOI *poi){
        _postJobModel.area_code = poi.citycode;
        _postJobModel.admin_code = poi.adcode;
        _postJobModel.working_place = poi.address;
        [self.tableView reloadData];
    };
    [self.navigationController pushViewController:viewCtrl animated:YES];
}

- (void)jobTagAction{
    JobTypeList_VC *viewCtrl = [[JobTypeList_VC alloc] init];
    viewCtrl.postJobType = (_sourceType == ViewSourceType_PostPersonalJob) ? PostJobType_Personal : PostJobType_Team;
    viewCtrl.classifierArray = [JobClassifyInfoModel getPersonalTypeList];
    WEAKSELF
    viewCtrl.block = ^(JobClassifyInfoModel* model){
        _postJobModel.job_classfie_name = model.job_classfier_name;
        if (_sourceType == ViewSourceType_PostTeamJob || _sourceType == ViewSourceType_InviteTeamJob) {
            _postJobModel.service_classify_id = model.job_classfier_id;
        }else{
            if (_postJobModel.service_type && ![_postJobModel.service_type isEqualToNumber:model.job_classfier_id]) {
                _postJobModel.service_type_classify_id = nil;
                _postJobModel.service_type_classify_name = nil;
            }
            _postJobModel.service_type = model.job_classfier_id;
        }
        [weakSelf.tableView reloadData];
    };
    [self.navigationController pushViewController:viewCtrl animated:YES];
}

- (void)showServiceClassify{
    if (!_postJobModel.service_type) {
        [UIHelper toast:@"请先选择服务类型"];
        return;
    }
    
    [self.view endEditing:YES];
    WEAKSELF
    [[XSJRequestHelper sharedInstance] getClientGlobalInfoWithBlock:^(ClientGlobalInfoRM *globalInfo) {
        if (globalInfo && globalInfo.service_type_classify_list) {
            NSPredicate *predicate = [NSPredicate predicateWithFormat:[NSString stringWithFormat:@"key=%@", _postJobModel.service_type]];
            NSArray<serviceTypeClassify *> *result = [globalInfo.service_type_classify_list filteredArrayUsingPredicate:predicate];
            serviceTypeClassify *classify = [result lastObject];
            NSArray *nameArr = [classify.value valueForKey:@"name"];
            [MKActionSheet sheetWithTitle:@"请选择二级分类" buttonTitleArray:nameArr isNeedCancelButton:NO maxShowButtonCount:6 block:^(MKActionSheet *actionSheet, NSInteger buttonIndex) {
                _postJobModel.service_type_classify_id = [[classify.value objectAtIndex:buttonIndex] objectForKey:@"id"];
                _postJobModel.service_type_classify_name = [[classify.value objectAtIndex:buttonIndex] objectForKey:@"name"];
                [weakSelf.tableView reloadData];
            }];
        }
    }];
}

- (void)shooseSexAction{
    [self.view endEditing:YES];
    NSArray *array = @[@{@"id": [NSNull null], @"name": @"不限"}, @{@"id": @1, @"name": @"男"}, @{@"id": @0, @"name": @"女"}];
    NSArray *sexArr = @[@"不限", @"男", @"女"];
    WEAKSELF
    [MKActionSheet sheetWithTitle:@"请选择性别" buttonTitleArray:sexArr isNeedCancelButton:NO maxShowButtonCount:6 block:^(MKActionSheet *actionSheet, NSInteger buttonIndex) {
        _postJobModel.sex = [[array objectAtIndex:buttonIndex] objectForKey:@"id"];
        [weakSelf.tableView reloadData];
    }];
}

- (void)showCityList{
    [self.view endEditing:YES];
    __block NSArray *cityList;
    WEAKSELF
    [CityTool getAllCityFromCacheWithBlock:^(NSArray *allCity) {
        cityList = allCity;
        NSArray *cityEnableTeamService = [allCity filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"self.enableTeamService.integerValue = 1"]];
        NSArray *cityNameList = [cityEnableTeamService valueForKey:@"name"];
        [MKActionSheet sheetWithTitle:@"已开通团队服务城市" buttonTitleArray:cityNameList isNeedCancelButton:NO maxShowButtonCount:4 block:^(MKActionSheet *actionSheet, NSInteger buttonIndex) {
            _postJobModel.city_id = [[cityEnableTeamService objectAtIndex:buttonIndex] id];
            _postJobModel.city_name = [cityNameList objectAtIndex:buttonIndex];
            [weakSelf.tableView reloadData];
        }];
    }];
}

- (void)choosePostedJob{
    if (_sourceType == ViewSourceType_InvitePersonalJob) {
        PersonalJobList_VC *viewCtrl = [[PersonalJobList_VC alloc] init];
        viewCtrl.service_type = _serviceType;
        viewCtrl.stu_account_id = self.stu_account_id;
        [self.navigationController pushViewController:viewCtrl animated:YES];
    }else if (_sourceType == ViewSourceType_InviteTeamJob){
        HistoryTeamJobList_VC *viewCtrl = [[HistoryTeamJobList_VC alloc] init];
        viewCtrl.service_classify_id = self.service_classify_id;
        viewCtrl.service_apply_id = self.service_apply_id;
        [self.navigationController pushViewController:viewCtrl animated:YES];
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
