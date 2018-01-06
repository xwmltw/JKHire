//
//  JobSearchList_VC.m
//  jianke
//
//  Created by xiaomk on 16/1/20.
//  Copyright © 2016年 xianshijian. All rights reserved.
//

#import "JobSearchList_VC.h"
#import "WDConst.h"
#import "JobExpressCell.h"
#import "JobModel.h"
#import "JobDetail_VC.h"
#import "JobClassCollectionViewCell.h"
#import "JobClassifierModel.h"
#import "JobController.h"
#import "GetEnterpriseModel.h"
#import "LookupEPInfo_VC.h"
#import "SearchEpList_VC.h"

@interface JobSearchList_VC ()<UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>{
    NSMutableArray* _jobClassArray;
    NSMutableArray* _historyArray;
    NSMutableArray* _searchDatasArray;
    QueryParamModel* _queryParam;
    
    CGFloat _jobClassWidth;
    CGFloat _jobClassHeight;
    
    NSNumber* _entCount;   /*!< 搜索到的雇主数量 */
    NSMutableArray* _entArray;  /*!< 搜索的雇主列表 */
    NSString* _searchStr;   /*!< 搜索的字符串 */
}

@property (nonatomic, strong) UITableView* tagTableView;
@property (nonatomic, strong) UITableView* jobListTableView;
@property (nonatomic, strong) UITextField* tfSearch;
@property (nonatomic, strong) UICollectionView* collectView;

@end

@implementation JobSearchList_VC

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar addSubview:self.tfSearch];
    [self.tfSearch becomeFirstResponder];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.tfSearch removeFromSuperview];
    
}

- (UITextField *)tfSearch{
    if (!_tfSearch) {
        UIView* view = [[UIView alloc] initWithFrame:CGRectMake(4, 0, 30, 28)];
        UIImageView* imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"v250_icon_search"]];
        imageView.frame = CGRectMake(4, 4, 20, 20);
        [view addSubview:imageView];
        
        _tfSearch = [[UITextField alloc] initWithFrame:CGRectMake(80, 8, SCREEN_WIDTH-80-16, 28)];
        _tfSearch.returnKeyType = UIReturnKeySearch;
        _tfSearch.clearButtonMode = UITextFieldViewModeAlways;
        _tfSearch.delegate = self;
        _tfSearch.font = [UIFont systemFontOfSize:14];
        _tfSearch.placeholder = @"输入岗位关键字";
        _tfSearch.textColor = [UIColor blackColor];
        _tfSearch.tintColor = [UIColor blueColor];
        _tfSearch.backgroundColor = [UIColor whiteColor];
        _tfSearch.leftView = view;
        _tfSearch.leftViewMode = UITextFieldViewModeAlways;
        [_tfSearch addTarget:self action:@selector(searchChanged:) forControlEvents:UIControlEventEditingChanged];
        [_tfSearch setCorner];
    }
    return _tfSearch;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _jobClassHeight = 54;
    _jobClassWidth = (SCREEN_WIDTH-2)/3;
    
    _queryParam = [[QueryParamModel alloc] init];
    _queryParam.page_num = @(1);
    _queryParam.page_size = @(100);
    
    NSArray* ary = [[UserData sharedInstance] getSearchHistoty];
    if (ary) {
        _historyArray = [[NSMutableArray alloc] initWithArray:ary];
    }else{
        _historyArray = [[NSMutableArray alloc] init];
    }
   
    self.tagTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    self.tagTableView.delegate = self;
    self.tagTableView.dataSource = self;
    self.tagTableView.hidden = NO;
    self.tagTableView.tag = 100;
    self.tagTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tagTableView];

    
    self.jobListTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    self.jobListTableView.delegate = self;
    self.jobListTableView.dataSource = self;
    self.jobListTableView.hidden = YES;
    self.jobListTableView.tag = 101;
    self.jobListTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.jobListTableView];
    
    WEAKSELF
    [self.tagTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(weakSelf.view);
    }];
    [self.jobListTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(weakSelf.view);
    }];
    
    if ([self.tagTableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.tagTableView setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([self.tagTableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [self.tagTableView setLayoutMargins:UIEdgeInsetsZero];
    }
    
    _searchDatasArray = [[NSMutableArray alloc] init];
    _entArray = [[NSMutableArray alloc] init];
    [self getJobTagData];
}

/** 获取分类 岗位 */
- (void)getJobTagData{
    WEAKSELF
    [[UserData sharedInstance] getJobClassifierListWithBlock:^(NSArray* jobClassArray) {
        if (jobClassArray && jobClassArray.count) {
            _jobClassArray = [[NSMutableArray alloc] initWithArray:jobClassArray];
            [weakSelf.collectView reloadData];
        }
    }];
}

/** 搜索 */
- (void)searchDataWithText:(NSString*)searchText isFromHistory:(BOOL)isFromHistory{
    [_searchDatasArray removeAllObjects];
    
    _searchStr = searchText;
    NSString* cityId = [[UserData sharedInstance] city].id.stringValue;
    QueryJobListConditionModel *conModel = [[QueryJobListConditionModel alloc] init];
    conModel.city_id = cityId;
    conModel.job_title = searchText;
    conModel.is_include_grab_single = @"1";
    
    QueryJobListModel* queryModel = [[QueryJobListModel alloc] init];
    queryModel.query_param = _queryParam;
    queryModel.query_condition = conModel;
    
    NSString* content = [queryModel getContent];
    
    RequestInfo* request = [[RequestInfo alloc] initWithService:@"shijianke_queryJobListFromApp" andContent:content];
    WEAKSELF
    [request sendRequestWithResponseBlock:^(ResponseInfo* response) {
        if (response && [response success]) {
            NSArray* dataArray = [JobModel objectArrayWithKeyValuesArray:response.content[@"self_job_list"]];
            if (dataArray.count) {
                if (isFromHistory || weakSelf.tfSearch.text.length > 0) {
                    [_searchDatasArray addObjectsFromArray:dataArray];
//                    weakSelf.tagTableView.hidden = YES;
//                    weakSelf.jobListTableView.hidden = NO;
//                    [weakSelf.jobListTableView reloadData];
                }
            }
        }
        [weakSelf searchEPWithText:searchText isFromHistory:isFromHistory];
    }];
}

/** 搜索雇主 */
- (void)searchEPWithText:(NSString*)searchText isFromHistory:(BOOL)isFromHistory{
    [_entArray removeAllObjects];
    
    QueryParamModel* qpModel = [[QueryParamModel alloc] init];
    qpModel.page_size = @(3);
    qpModel.page_num = @(1);
    
    EntNameModel* enModel = [[EntNameModel alloc] init];
    enModel.enterprise_name = searchText;
    
    GetEnterpriseModel* gemModel = [[GetEnterpriseModel alloc] init];
    gemModel.query_condition = enModel;
    gemModel.query_param = qpModel;
    
    NSString* content = [gemModel getContent];
    WEAKSELF
    RequestInfo* request = [[RequestInfo alloc] initWithService:@"shijianke_queryEnterpriseList" andContent:content];
    [request sendRequestWithResponseBlock:^(ResponseInfo* response) {
        if (response && [response success]) {
            [_entArray removeAllObjects];
            NSArray* ary = [EntInfoModel objectArrayWithKeyValuesArray:response.content[@"ent_list"]];
            _entCount = response.content[@"ent_count"];
            if (ary.count) {
                if (isFromHistory || weakSelf.tfSearch.text.length > 0) {
                    [_entArray addObjectsFromArray:ary];
                }
            }
        }
        weakSelf.tagTableView.hidden = YES;
        weakSelf.jobListTableView.hidden = NO;
        [weakSelf.jobListTableView reloadData];

    }];
}

/** 保存搜索记录 */
- (void)saveSearchText:(NSString*)text{
    if (!_historyArray) {
        _historyArray = [[NSMutableArray alloc] init];
    }
    for (NSString* str in _historyArray) {
        if ([str isEqualToString:text]) {
            [_historyArray removeObject:str];
            [_historyArray insertObject:text atIndex:0];
            [[UserData sharedInstance] saveSearchHistoryWithArray:_historyArray];
            return;
        }
    }
    [_historyArray insertObject:text atIndex:0];
    [[UserData sharedInstance] saveSearchHistoryWithArray:_historyArray];
}

/** 更多雇主搜索信息 */
- (void)btnShowMoreEp:(UIButton*)sender{
    SearchEpList_VC* vc = [[SearchEpList_VC alloc] init];
    vc.searchStr = _searchStr;
    [self.navigationController pushViewController:vc animated:YES];
}


#pragma mark - ***** UITableView delegate ******
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:[tableView indexPathForSelectedRow] animated:YES];
    if (tableView.tag == 101) {
        [self.tfSearch resignFirstResponder];
        [self saveSearchText:self.tfSearch.text];
        NSNumber *cityId = [[UserData sharedInstance] city].id;
        [[XSJRequestHelper sharedInstance] recordSearchKeyWord:self.tfSearch.text cityId:cityId block:^(id result) {
            
        }];
        if (indexPath.section == 0) {
            if (_entArray.count <= indexPath.row) {
                return;
            }
            EntInfoModel* eiModel = [_entArray objectAtIndex:indexPath.row];
            LookupEPInfo_VC* vc = [UIHelper getVCFromStoryboard:@"EP" identify:@"sid_lookupEPInfo"];
            vc.lookOther = YES;
            vc.enterpriseId = [NSString stringWithFormat:@"%@",eiModel.enterprise_id];
            [self.navigationController pushViewController:vc animated:YES];
        
        }else if (indexPath.section == 1){
            if (_searchDatasArray.count <= indexPath.row) {
                return;
            }
            JobModel* model = [_searchDatasArray objectAtIndex:indexPath.row];
            JobDetail_VC* vc = [[JobDetail_VC alloc] init];
            vc.jobId = [NSString stringWithFormat:@"%@", model.job_id];
            vc.userType = WDLoginType_JianKe;
            [self.navigationController pushViewController:vc animated:YES];
        }
    }else if (tableView.tag == 100){
        if (indexPath.section == 1) {
            [self searchDataWithText:[_historyArray objectAtIndex:indexPath.row] isFromHistory:YES];
        }else if (indexPath.section == 2){
            if (_historyArray) {
                [_historyArray removeAllObjects];
                [[UserData sharedInstance] saveSearchHistoryWithArray:_historyArray];
                [self.tagTableView reloadData];
            }
        }
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView.tag == 100) {
        UITableViewCell* cell;
        if (indexPath.section == 0) {
            cell = [tableView dequeueReusableCellWithIdentifier:@"tagCell"];
            if (!cell) {
                cell = [[UITableViewCell alloc] initWithFrame:CGRectMake(0, 0, tableView.size.width, _jobClassHeight*2+1)];
                cell.backgroundColor = [UIColor whiteColor];
                
                UICollectionViewFlowLayout* flowLayout = [[UICollectionViewFlowLayout alloc] init];
                [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
                flowLayout.itemSize = CGSizeMake(_jobClassWidth, _jobClassHeight);
                flowLayout.minimumInteritemSpacing = 1;
                flowLayout.minimumLineSpacing = 1;
                
                self.collectView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, self.tagTableView.size.width, _jobClassHeight*3+2) collectionViewLayout:flowLayout];
                self.collectView.delegate = self;
                self.collectView.dataSource = self;
                self.collectView.bounces = NO;
                self.collectView.backgroundColor = [UIColor XSJColor_grayDeep];
                [self.collectView registerClass:[JobClassCollectionViewCell class] forCellWithReuseIdentifier:@"jobClassCVCell"];
                
                [cell addSubview:self.collectView];
            }
        }else if (indexPath.section == 1){
            cell = [tableView dequeueReusableCellWithIdentifier:@"historyCell"];
            if (!cell) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"historyCell"];
                cell.selectedBackgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"v210_pressed_background"]];
                cell.textLabel.font = [UIFont systemFontOfSize:16];
                cell.textLabel.textColor = MKCOLOR_RGB(89, 89, 89);
                UIView *sepView = [[UIView alloc]initWithFrame:CGRectMake(16, 49, SCREEN_WIDTH, 1)];
                sepView.backgroundColor = [UIColor XSJColor_grayTinge];
                sepView.tag = 100;
                [cell addSubview:sepView];
            }

            UIView* sepView = (UIView*)[cell viewWithTag:100];
            if (indexPath.row == _historyArray.count-1) {
                sepView.hidden = YES;
            }else{
                sepView.hidden = NO;
            }
            
            cell.textLabel.text = [_historyArray objectAtIndex:indexPath.row];
        }else if (indexPath.section == 2){
            cell = [tableView dequeueReusableCellWithIdentifier:@"clearHistoryCell"];
            if (!cell) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"clearHistoryCell"];
                cell.selectedBackgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"v210_pressed_background"]];
                UILabel* labClear = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, tableView.size.width, 48)];
                labClear.tag = 200;
                labClear.textAlignment = NSTextAlignmentCenter;
                labClear.textColor = MKCOLOR_RGB(74, 144, 226);
                labClear.font = [UIFont systemFontOfSize:16];
                [cell addSubview:labClear];
            }
            UILabel* labClear = (UILabel*)[cell viewWithTag:200];
            labClear.text = @"清除搜索记录";
        }
        return cell;
    }else if (tableView.tag == 101){
        if (indexPath.section == 0) {
            UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"epCell"];
            if (!cell) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"epCell"];
            }
            if (_entArray.count <= indexPath.row) {
                return cell;
            }
            EntInfoModel* eiModel = [_entArray objectAtIndex:indexPath.row];
            
            NSMutableAttributedString* attributeStr = [[NSMutableAttributedString alloc] initWithString:eiModel.enterprise_name];
            NSRange range = [eiModel.enterprise_name rangeOfString:_searchStr];
            if (range.location != NSNotFound) {
                [attributeStr addAttribute:NSForegroundColorAttributeName value:[UIColor orangeColor] range:range];
                cell.textLabel.attributedText = attributeStr;
            }else{
                cell.textLabel.text = eiModel.enterprise_name;
            }

            return cell;
        }else if (indexPath.section == 1) {
            JobExpressCell* cell = [JobExpressCell cellWithTableView:tableView];
           
            if (_searchDatasArray.count <= indexPath.row) {
                return cell;
            }
            JobModel* model = [_searchDatasArray objectAtIndex:indexPath.row];
            [cell refreshWithData:model andSearchStr:_searchStr];
            return cell;
        }
    }
    return nil;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView.tag == 100) {
        if (section == 0) {
            return 1;
        }else if (section == 1) {
            return _historyArray.count ? _historyArray.count : 0;
        }else if (section == 2) {
            return _historyArray.count ? 1 : 0;
        }
    }else if (tableView.tag == 101){
        if (section == 0) {
            return _entArray.count ? _entArray.count : 0;
        }else if (section == 1){
            return _searchDatasArray.count ? _searchDatasArray.count : 0;
        }
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView.tag == 100) {
        if (indexPath.section == 0) {
            return _jobClassHeight*3+2;
        }else if (indexPath.section == 1 || indexPath.section == 2){
            return 50;
        }
    }else if (tableView.tag == 101){
        if (indexPath.section == 0) {
            return 44;
        }else if (indexPath.section == 1){
            return 94;
        }
//        JobModel* model = _searchDatasArray[indexPath.row];
//        if (model.job_tags.count || (model.icon_status.integerValue == 1 && model.icon_url.length)) {
//            return 94;
//        } else {
//            return 68;
//        }
    }
    return 0;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (tableView.tag == 100) {
        return 3;
    }else if (tableView.tag == 101){
        return 2;
    }
    return 1;
}

//section head view
- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (tableView.tag == 100) {
        UIView* view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.size.width, 32)];
        view.backgroundColor = [UIColor XSJColor_grayTinge];
        UILabel* labTitle = [[UILabel alloc] initWithFrame:CGRectMake(16, 0, 200, 32)];
        labTitle.backgroundColor = [UIColor clearColor];
        labTitle.textColor = [UIColor XSJColor_tGray];
        labTitle.font = [UIFont systemFontOfSize:14];
        [view addSubview:labTitle];
        
        if (section == 0) {
            labTitle.text = @"推荐分类";
        }else if (section == 1){
            labTitle.text = @"搜索历史";
        }
        return view;
    }else if (tableView.tag == 101){
        UIView* view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.size.width, 40)];
        view.backgroundColor = [UIColor XSJColor_grayDeep];
        if (section == 0) {
            UILabel* labTitle = [[UILabel alloc] initWithFrame:CGRectMake(16, 0, 200, 32)];
            labTitle.textColor = [UIColor XSJColor_tGray];
            labTitle.font = HHFontSys(kFontSize_2);
            labTitle.text = @"雇主";
            [view addSubview:labTitle];
        }else if (section == 1){
            UILabel* labTitle = [[UILabel alloc] initWithFrame:CGRectMake(16, 0, 200, 32)];
            labTitle.textColor = [UIColor XSJColor_tGray];
            labTitle.font = HHFontSys(kFontSize_2);
            labTitle.text = @"岗位";
            [view addSubview:labTitle];
            
            if (_entCount.intValue > 3) {
                UIButton* btnShowMoreEp = [UIButton buttonWithType:UIButtonTypeCustom];
                [btnShowMoreEp setTitle:@"查看更多雇主" forState:UIControlStateNormal];
                [btnShowMoreEp setTitleColor:[UIColor XSJColor_tBlue] forState:UIControlStateNormal];
                btnShowMoreEp.frame = CGRectMake(tableView.size.width-140, 0, 140, 32);
                btnShowMoreEp.titleLabel.font = HHFontSys(kFontSize_2);
                [btnShowMoreEp addTarget:self action:@selector(btnShowMoreEp:) forControlEvents:UIControlEventTouchUpInside];
                [view addSubview:btnShowMoreEp];
            }
        }
        return view;
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (tableView.tag == 100) {
        if (section == 0 || section == 1) {
            return 30;
        }else{
            return 1;
        }
    }else if (tableView.tag == 101){
        return 32;
    }
    return 0;
}

//处理分割线没在最左边问题：ios8以后才有的问题
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if ([tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [tableView setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [tableView setLayoutMargins:UIEdgeInsetsZero];
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}

//处理下面多余的线
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 1;
}


#pragma mark - ***** UITextField delegate ******
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

- (void)searchChanged:(UITextField*)textField{
    if (textField.text.length <= 0) {
        self.jobListTableView.hidden = YES;
        self.tagTableView.hidden = NO;
        [self.tagTableView reloadData];
    }else{
        UITextRange* selectedRange = [textField markedTextRange];
        NSString* newText = [textField textInRange:selectedRange];
        if (newText.length > 0) return;
        [self searchDataWithText:textField.text isFromHistory:NO];
    }
}


#pragma mark - ***** UICollectionView delegate ******
- (UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    static NSString* cellIdentifier = @"jobClassCVCell";
    JobClassCollectionViewCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    [cell sizeToFit];
    if (!cell) {
        ELog(@"====???");
    }
    cell.backgroundColor = [UIColor whiteColor];
    cell.labName.frame = CGRectMake(0, 0, cell.size.width, cell.size.height);
    
    if (indexPath.row < _jobClassArray.count) {
        JobClassifierModel* model = [_jobClassArray objectAtIndex:indexPath.row];
        cell.labName.text = model.job_classfier_name;
    }

    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    ELog(@"=collectionView====indexPath:%ld",(long)indexPath.row);
    if (indexPath.row >= _jobClassArray.count) {
        return;
    }
    NSString *cityId = [[UserData sharedInstance] city].id.stringValue;

    JobClassifierModel* model = [_jobClassArray objectAtIndex:indexPath.row];
    if (model) {
        NSString* jobClassId = model.job_classfier_id.stringValue;
        JobController* vc = [[JobController alloc] init];
        vc.content = [NSString stringWithFormat:@"query_condition:{city_id:%@, job_type_id:[%@]}", cityId, jobClassId];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
//    return 6;
    return _jobClassArray.count ? _jobClassArray.count : 0;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
