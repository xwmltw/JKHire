//
//  FindTalent_VC.m
//  JKHire
//
//  Created by yanqb on 2017/5/31.
//  Copyright © 2017年 xianshijian. All rights reserved.
//

#import "FindTalent_VC.h"
#import "LookupResume_VC.h"
#import "XZDropDownMenu.h"
#import "CityTool.h"
#import "JobClassifierModel.h"
#import "XZDropDownModel.h"
#import "BaseButton.h"
#import "PostJobSuccess_Cell1.h"
#import "JSDropDownMenu.h"

@interface FindTalent_VC ()<JSDropDownMenuDelegate, JSDropDownMenuDataSource>

{
    NSString *_seletCity,*_selectJob;
}

@property (nonatomic, strong) JSDropDownMenu *dropDownMenu;
//@property (nonatomic, strong) MenuDataSource *menuDataSource;   /*!< 撒选管理器 */
@property (nonatomic, strong) NSArray *cityFirstLetterArray; //城市首字母数组
@property (nonatomic, strong) NSMutableArray *jobTypeArray;
@property (nonatomic, strong) NSMutableArray *positionArray;
@property (nonatomic, strong) NSMutableArray *sexArray;
@property (nonatomic, strong) NSMutableArray *ageArray;
@property (nonatomic, strong) NSMutableArray *columnArray;
@property (nonatomic, strong) NSMutableArray *allSortCity;
@property (nonatomic, assign) NSInteger positionIndex;
@property (nonatomic, assign) NSInteger jobTypeIndex;
@property (nonatomic, assign) NSInteger timeIndex;
@property (nonatomic, assign) NSInteger unitIndex;
@property (nonatomic, assign) NSInteger selectIndenx;
@property (nonatomic, strong) QueryTalentParam *queryModel;
@property (nonatomic, strong) QueryParamModel *queryParam;
@property (nonatomic, strong)XZDropDownModel *selectModel;

@end

@implementation FindTalent_VC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"发现人才";
    NSLog(@"");
    
    [WDNotificationCenter addObserver:self selector:@selector(citySelectAction) name:RefreshFindTalentNotification object:nil];
    
    [TalkingData trackEvent:@"发现人才页"];
    
    [self loadData];
    [self initUIWithType:DisplayTypeOnlyTableView];
    [self.tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(50);
        make.left.right.bottom.equalTo(self.view);
    }];
    self.refreshType = RefreshTypeAll;
    self.tableView.backgroundColor = [UIColor XSJColor_newWhite];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.estimatedRowHeight = 199.0f;
    [self.tableView registerNib:nib(@"PostJobSuccess_Cell1") forCellReuseIdentifier:@"PostJobSuccess_Cell1"];
    
    [self.view addSubview:self.dropDownMenu];
    
    if (self.isBeginWithMJRefresh) {
        [self.tableView.header beginRefreshing];
    }else{
        self.dataSource = [[[UserData sharedInstance] getFindTalentList] mutableCopy];
        [self headerRefresh];
    }
    
}

- (void)loadData{
    self.queryModel = [[QueryTalentParam alloc] init];
    self.queryModel.list_type = @1;
    self.queryModel.city_id = self.city_id? self.city_id:[UserData sharedInstance].city.id;
    self.queryModel.address_area_id = self.address_area_id;
    self.queryModel.job_classify_id = self.job_classify_id;
    self.queryModel.sex = self.sex;
    self.queryModel.age_limit = self.age_limit;
    
    _selectJob = self.job_classfie_name;
    _seletCity = self.address_area_name;
    
    
    self.queryParam = [[QueryParamModel alloc] init];
    [self getCity];
    [self getJobTypeData];
    [self getPositionData];
    [self getSexData];
    [self getAgeData];
    [self getColumeData];
}

- (void)getColumeData{
    self.columnArray = [NSMutableArray array];
    if (self.job_classfie_name.length) {
        [self.columnArray addObject:self.job_classfie_name];
    }else{
        [self.columnArray addObject:@"岗位类型"];
    }
    if (self.address_area_name.length) {
        [self.columnArray addObject:self.address_area_name];
    }
    else{
        if (self.city_name.length) {
            [self.columnArray addObject:[NSString stringWithFormat:@"全%@", self.city_name]];
        }else{
            [self.columnArray addObject:[NSString stringWithFormat:@"全%@", [UserData sharedInstance].city.name]];
        }
    }
    if (self.sex) {
        NSString *sexStr = (self.sex.integerValue == 1) ? @"男": @"女";
        [self.columnArray addObject:sexStr];
    }else{
        [self.columnArray addObject:@"性别"];
    }
    NSString *ageStr = @"";
    switch (self.age_limit.integerValue) {
        case 1:
            ageStr = @"18周岁以上";
            break;
        case 2:
            ageStr = @"18~25周岁";
            break;
        case 3:
            ageStr = @"25周岁以上";
            break;
        default:
            ageStr = @"年龄";
            break;
    }
    [self.columnArray addObject:ageStr];
}

- (void)headerRefresh{
    self.queryParam.page_num = @1;
    self.queryModel.list_type = @1;
//    NSString *str = [self.queryModel getContent];
    WEAKSELF
    [[XSJRequestHelper sharedInstance] entQueryTalentList:self.queryModel queryParam:self.queryParam isShowLoading:NO block:^(ResponseInfo *response) {
        [weakSelf.tableView.header endRefreshing];
        if (response) {
            NSArray *array = [JKModel objectArrayWithKeyValuesArray:[response.content objectForKey:@"telent_list"]];
           
            weakSelf.dataSource = [array mutableCopy];
            [weakSelf.tableView reloadData];
            weakSelf.tableView.tableFooterView = nil;
            if (array.count && weakSelf.queryModel.list_type.integerValue == 1 && !weakSelf.isBeginWithMJRefresh) {
                [[UserData sharedInstance] saveFindTalentListWithArray:array];
            }
            if (array.count == 0) {
                weakSelf.tableView.tableFooterView = [weakSelf getTableFooterView:YES];
                weakSelf.queryModel.list_type = @2;
            }else if (array.count < weakSelf.queryParam.page_size.integerValue){
                weakSelf.tableView.tableFooterView = [weakSelf getTableFooterView:NO];
                weakSelf.queryModel.list_type = @2;
            }else{
                weakSelf.queryParam.page_num = @2;
            }
        }
    }];
}

- (void)footerRefresh{
    if (self.queryModel.list_type.integerValue == 2 && self.queryParam.page_num.integerValue == 1) {
        [TalkingData trackEvent:@"人才库_发现人才_查看更多同城求职者"];
    }
    
        WEAKSELF
    [[XSJRequestHelper sharedInstance] entQueryTalentList:self.queryModel queryParam:self.queryParam isShowLoading:NO block:^(ResponseInfo *response) {
        [weakSelf.tableView.footer endRefreshing];
        if (response) {
            NSArray *array = [JKModel objectArrayWithKeyValuesArray:[response.content objectForKey:@"telent_list"]];
            weakSelf.tableView.tableFooterView = nil;
            if (array.count) {
                weakSelf.queryParam.page_num = @(weakSelf.queryParam.page_num.integerValue + 1);
            }
            if (array.count < weakSelf.queryParam.page_size.integerValue && weakSelf.queryModel.list_type.integerValue == 1) {
                weakSelf.queryModel.list_type = @2;
                weakSelf.queryParam.page_num = @1;
                weakSelf.tableView.tableFooterView = [weakSelf getTableFooterView:NO];
            }
            
            [weakSelf.dataSource addObjectsFromArray:array];
            [weakSelf.tableView reloadData];
//            [weakSelf.tableView layoutIfNeeded];
            
        
            
//            [self performSelector:@selector(scrollToIndexPath:) withObject:[NSIndexPath indexPathForRow:0 inSection:0] afterDelay:0.0];
            }
    }];
   
}
- (void)scrollToIndexPath:(NSIndexPath *)path
{
    NSIndexPath *indexPath1 = [NSIndexPath indexPathForRow:35 inSection:0];
    [self.tableView scrollToRowAtIndexPath:indexPath1 atScrollPosition:UITableViewScrollPositionBottom animated:YES];
}
- (UIView *)getTableFooterView:(BOOL)isNotData{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 98)];
    view.backgroundColor = [UIColor XSJColor_newWhite];
    
    if (isNotData) {
        UIView *noDataView = [UIHelper noDataViewWithTitle:@"还没有求职者达到您的要求，放宽条件试试~"];
        noDataView.height = 150;
        noDataView.y = 24;
        [view addSubview:noDataView];
        view.height = 174;
    }else{
        UILabel *lab = [UILabel labelWithText:@"还有很多优秀的人才，不妨再看看" textColor:[UIColor XSJColor_tGrayDeepTransparent48] fontSize:14.0f];
        BaseButton *btn = [BaseButton buttonWithType:UIButtonTypeCustom];
        [btn setTitle:@"看更多同城求职者" forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:@"jiantou_down_icon_16"] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor XSJColor_tGrayDeepTinge1] forState:UIControlStateNormal];
        [btn setCornerValue:19.0f];
        btn.titleLabel.font = [UIFont systemFontOfSize:16.0f];
        btn.backgroundColor = MKCOLOR_RGBA(34, 58, 80, 0.03);
        [btn addTarget:self action:@selector(btnOnClick:) forControlEvents:UIControlEventTouchUpInside];
        [btn setMarginForImg:-10 marginForTitle:16];
        
        [view addSubview:lab];
        [view addSubview:btn];
        
        [lab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(btn.mas_top).offset(-8);
            make.centerX.equalTo(view);
        }];
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(view).offset(-23);
            make.centerX.equalTo(view);
            make.width.equalTo(@180);
            make.height.equalTo(@38);
        }];

    }
    return view;
}

- (void)getJobTypeData{
    WEAKSELF
    // 获取岗位分类
    [[UserData sharedInstance] getJobClassifierListWithBlock:^(NSArray *jobArray) {
        NSMutableArray *arry = [NSMutableArray array];
        
        // 不限
        JobClassifierModel *model = [[JobClassifierModel alloc] init];
        model.job_classfier_id = nil;
        model.job_classfier_name = @"不限";
        
        XZDropDownModel *xzModel = [[XZDropDownModel alloc] init];
        xzModel.extra = model;
        xzModel.content = model.job_classfier_name;
        xzModel.subContet = @"岗位类型";
        xzModel.selected = YES;
        [arry addObject:xzModel];
        
        [jobArray enumerateObjectsUsingBlock:^(JobClassifierModel *_Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if (obj.enable_limit_job.integerValue == 1) {
                return;
            }
            XZDropDownModel *model = [[XZDropDownModel alloc] init];
            model.extra = obj;
            model.content = obj.job_classfier_name;
            model.subContet = obj.job_classfier_name;
            if (weakSelf.job_classify_id && [weakSelf.job_classify_id isEqual:obj.job_classfier_id]) {
                model.selected = YES;
                xzModel.selected = NO;
            }
            [arry addObject:model];
        }];
        weakSelf.jobTypeArray = arry;
    }];
}

- (void)getCity{
        // 排序好的城市数组
    [CityTool getAllCityWithBlock:^(NSMutableArray *allSortCity) {
        self.allSortCity = allSortCity;
        
        CityModel *model = [[UserData sharedInstance] city];
        [self.allSortCity insertObject:model atIndex:0];

    
    }];
    
    WEAKSELF
//    [CityTool getCityFirstLetterArrayWithBlock:^(NSArray *cityFirstLetterArray) {
//        weakSelf.cityFirstLetterArray = [NSKeyedUnarchiver unarchiveObjectWithData:[NSKeyedArchiver archivedDataWithRootObject:cityFirstLetterArray]];
//    }];
//    
//    // 排序好的城市数组
//    [CityTool getAllSortCityWithBlock:^(NSArray *allSortCity) {
//        weakSelf.allSortCity = allSortCity;
//        
//    }];


}
- (void)getPositionData{
    WEAKSELF
    NSNumber *cityId = self.city_id ? self.city_id: [[UserData sharedInstance] city].id;
    [CityTool getAreasWithCityId:cityId block:^(NSArray *areaArray) {
        
        // 全福州 && 附近
        CityModel *savedCuttentCity = [[UserData sharedInstance] city];
//        CityModel *savedCuttentCity = [[CityModel alloc]init];
        if (self.city_id) {
            CityModel *cityModel = [[CityModel alloc] init];
            cityModel.id = self.city_id;
            cityModel.name = self.city_name;
            savedCuttentCity = cityModel;
        }
        savedCuttentCity = [NSKeyedUnarchiver unarchiveObjectWithData:[NSKeyedArchiver archivedDataWithRootObject:savedCuttentCity]];
        savedCuttentCity.name = [NSString stringWithFormat:@"全%@", savedCuttentCity.name];
        savedCuttentCity.id = nil;
        XZDropDownModel *model = [[XZDropDownModel alloc] init];
        model.extra = savedCuttentCity;
        model.content = savedCuttentCity.name;
        model.subContet = savedCuttentCity.name;
        model.selected = YES;
        
        NSMutableArray *array = [NSMutableArray array];
        
        [areaArray enumerateObjectsUsingBlock:^(CityModel*  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            XZDropDownModel *model1 = [[XZDropDownModel alloc] init];
            model1.extra = obj;
            model1.content = obj.name;
            model1.subContet = obj.name;
            if (weakSelf.address_area_id && [weakSelf.address_area_id isEqual:obj.id]) {
                model1.selected = YES;
                model.selected = NO;
            }
            [array addObject:model1];
        }];
       
        if (savedCuttentCity) { // 有保存城市
            if (array.count) {
                [array insertObject:model atIndex:0];
            }else{
                [array addObject:model];
            }
            
        } else { // 没保存城市, 也没定位信息
            [CityTool getCurrentCityWithBlock:^(CityModel *currentCity) {
                if (currentCity) {
                    currentCity = [NSKeyedUnarchiver unarchiveObjectWithData:[NSKeyedArchiver archivedDataWithRootObject:currentCity]];
                    currentCity.name = [NSString stringWithFormat:@"全%@", currentCity.name];
                    
                    XZDropDownModel *model = [[XZDropDownModel alloc] init];
                    model.content = currentCity.name;
                    model.selected = YES;
                    model.extra = currentCity;
                    
                    if (array.count) {
                        [array insertObject:model atIndex:0];
                    }else{
                        [array addObject:model];
                    }
                }
            }];
        }
        
        weakSelf.positionArray = array;
        // 必须放置主线程刷新
         dispatch_async(dispatch_get_main_queue(), ^{
             [weakSelf.dropDownMenu reloadDataWith:self.selectIndenx];
         });
    }];
}

- (void)getSexData{
    self.sexArray = [NSMutableArray array];
    
    sexModel *model1 = [[sexModel alloc] init];
    model1.name = @"不限";
    XZDropDownModel *model = [[XZDropDownModel alloc] init];
    model.content = model1.name;
    model.subContet = @"性别";
    model.selected = YES;
    model.extra = model1;
    [self.sexArray addObject:model];
    
    sexModel *model2 = [[sexModel alloc] init];
    model2.name = @"男";
    model2.id = @1;
    
    sexModel *model3 = [[sexModel alloc] init];
    model3.name = @"女";
    model3.id = @0;
    
    NSArray *array = @[model2, model3];
    [array enumerateObjectsUsingBlock:^(sexModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        XZDropDownModel *tmpmodel = [[XZDropDownModel alloc] init];
        tmpmodel.content = obj.name;
        tmpmodel.subContet = obj.name;
        tmpmodel.extra = obj;
        if (self.sex && [self.sex isEqual:obj.id]) {
            tmpmodel.selected = YES;
            model.selected = NO;
        }
        [self.sexArray addObject:tmpmodel];
    }];
}

- (void)getAgeData{
    self.ageArray = [NSMutableArray array];
    
    AgeModel *model1 = [[AgeModel alloc] init];
    model1.name = @"不限";
    XZDropDownModel *tmpModel = [[XZDropDownModel alloc] init];
    tmpModel.content = model1.name;
    tmpModel.subContet = @"年龄";
    tmpModel.selected = YES;
    tmpModel.extra = model1;
    [self.ageArray addObject:tmpModel];
    
    AgeModel *model2 = [[AgeModel alloc] init];
    model2.name = @"18周岁以上";
    model2.id = @1;
    
    AgeModel *model3 = [[AgeModel alloc] init];
    model3.name = @"18~25周岁";
    model3.id = @2;
    
    AgeModel *model4 = [[AgeModel alloc] init];
    model4.name = @"25周岁以上";
    model4.id = @3;
    
    NSArray *array = @[model2, model3, model4];
    [array enumerateObjectsUsingBlock:^(AgeModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        XZDropDownModel *model = [[XZDropDownModel alloc] init];
        model.content = obj.name;
        model.subContet = obj.name;
        model.extra = obj;
        if (self.age_limit && [self.age_limit isEqual:obj.id]) {
            model.selected = YES;
            tmpModel.selected = NO;
        }
        [self.ageArray addObject:model];
    }];
}

#pragma mark - uitableview datasource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    PostJobSuccess_Cell1 *cell = [tableView dequeueReusableCellWithIdentifier:@"PostJobSuccess_Cell1" forIndexPath:indexPath];
    JKModel *model = [self.dataSource objectAtIndex:indexPath.row];
    cell.sourceType = FromSourceType_findTalent;
    cell.model = model;
    [cell setSelctModel:self.queryModel andArea:_seletCity andJob:_selectJob];
//    [cell setSelctModel:self.queryModel andArea:_seletCity andJob:_selectJob];
  
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    JKModel *model = [self.dataSource objectAtIndex:indexPath.row];
    return model.cellHeight;
}

#pragma mark - uitableview delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [TalkingData trackEvent:@"人才库_发现人才_点击兼客名片"];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    JKModel *model = [self.dataSource objectAtIndex:indexPath.row];
    model.isSelect = YES;
    LookupResume_VC *vc = [[LookupResume_VC alloc] init];
    vc.hidesBottomBarWhenPushed = YES;
    vc.resumeId = model.resume_id;
    vc.isFromToLookUpResume = 1;
    [self.navigationController pushViewController:vc animated:YES];
}



#pragma mark - jsDropDownMenuDeletage

- (JSDropDownMenu *)dropDownMenu{
    if(!_dropDownMenu){
    _dropDownMenu = [[JSDropDownMenu alloc]initWithOrigin:CGPointMake(0, 0) andHeight:50];
    _dropDownMenu.indicatorColor = MKCOLOR_RGBA(34, 58, 80, 0.80);
    _dropDownMenu.separatorColor = MKCOLOR_RGB(233, 233, 235);
    _dropDownMenu.textColor = MKCOLOR_RGBA(34, 58, 80, 0.80);
    _dropDownMenu.dataSource = self;
    _dropDownMenu.delegate = self;
    }
    return _dropDownMenu;
}
//- (NSInteger)numberOfLeftSectionsInMenu:(UITableView *)tableView{
//    
//    return self.allSortCity.count;
//}
- (NSInteger)numberOfColumnsInMenu:(JSDropDownMenu *)menu{
    return self.columnArray.count;
}
- (BOOL)displayByCollectionViewInColumn:(NSInteger)column{
    
    if (column == 0) {
        return YES;
    }
    return NO;
}
- (BOOL)haveRightTableViewInColumn:(NSInteger)column{
    if (column == 1) {
        return YES;
    }
    return NO;
    
}
- (CGFloat)widthRatioOfLeftColumn:(NSInteger)column{
    if (column == 1) {
        return 0.4;
    }
    return 1;
    
}
- (NSInteger)currentLeftSelectedRow:(NSInteger)column{
    switch (column) {
        case 0:
            return self.jobTypeIndex;
            break;
        case 1:
            return self.positionIndex;
            break;
        case 2:
            return self.timeIndex;
            break;
        case 3:
            return self.unitIndex;
            break;
            
        default:
            break;
    }    return 0;
    
}

- (NSInteger)menu:(JSDropDownMenu *)menu numberOfRowsInColumn:(NSInteger)column leftOrRight:(NSInteger)leftOrRight leftRow:(NSInteger)leftRow{
    if (column == 0) {
        return self.jobTypeArray.count;
    }else if (column == 2 ){
        return self.sexArray.count;
       
    }else if(column == 1){
        if (leftOrRight == 0) {
            return self.allSortCity.count;
        }else{
            
            return self.positionArray.count;
        }

    }
    return self.ageArray.count;
    
}

- (NSString *)menu:(JSDropDownMenu *)menu titleForColumn:(NSInteger)column{
    NSString *title = [self.columnArray objectAtIndex:column];
    return title;
}
- (NSString *)menu:(JSDropDownMenu *)menu titleForRowAtIndexPath:(JSIndexPath *)indexPath{
    XZDropDownModel *model = [[XZDropDownModel alloc] init];
    if (indexPath.column == 0) {
        model = self.jobTypeArray[indexPath.row];
        return model.content;
    } else if (indexPath.column == 1){
        if (indexPath.leftOrRight == 0) {
           CityModel *model =self.allSortCity[indexPath.row];
            return model.name;
        }else {
            model =self.positionArray[indexPath.row];
            return model.content;
        }
    }else if(indexPath.column == 2) {
        model = self.sexArray[indexPath.row];
        return model.content;
    }else{
        model = self.ageArray[indexPath.row];
        return model.content;
    }
    
}

- (void)menu:(JSDropDownMenu *)menu didSelectRowAtIndexPath:(JSIndexPath *)indexPath{
    NSMutableArray *array = nil;
    switch (indexPath.column) {
        case 0:{
            self.jobTypeIndex = indexPath.row;
            [TalkingData trackEvent:@"人才库_发现人才_岗位类型"];
            array = self.jobTypeArray;
            JobClassifierModel *model = [[self.jobTypeArray objectAtIndex:indexPath.row] valueForKey:@"extra"];
            self.queryModel.job_classify_id = model.job_classfier_id;
            _selectJob = model.job_classfier_name;
        }
            break;
        case 1:{
            self.positionIndex = indexPath.row;
            if (indexPath.leftOrRight == 1) {
                [TalkingData trackEvent:@"人才库_发现人才_城区"];
                array = self.positionArray;
                CityModel *cityModel = [[self.positionArray objectAtIndex:indexPath.row] valueForKey:@"extra"];
                 _seletCity = cityModel.name;
                    self.queryModel.address_area_id = cityModel.id;
                if (self.city_id) {
                    self.queryModel.city_id = self.city_id;
                }else{
                    
                    self.queryModel.city_id = [[UserData sharedInstance] city].id;
                }
                
            }else{
                self.selectIndenx = indexPath.leftRow;
                CityModel *model = self.allSortCity[indexPath.leftRow];
                self.city_id = model.id;
           
                self.city_name = model.name;
                [self.columnArray replaceObjectAtIndex:1 withObject:[NSString stringWithFormat:@"全%@", self.city_name]];
                
                        [self getPositionData];
                
                return;
            }
        }
            break;
        case 2:{
            self.timeIndex = indexPath.row;
            [TalkingData trackEvent:@"人才库_发现人才_性别"];
            array = self.sexArray;
            sexModel *model = [[self.sexArray objectAtIndex:indexPath.row] valueForKey:@"extra"];
            self.queryModel.sex = model.id;
        }
            break;
        case 3:{
            self.unitIndex = indexPath.row;
            [TalkingData trackEvent:@"人才库_发现人才_年龄"];
            array = self.ageArray;
            AgeModel *model = [[self.ageArray objectAtIndex:indexPath.row] valueForKey:@"extra"];
            self.queryModel.age_limit = model.id;
        }
            break;
        default:
            break;
    }
    self.queryModel.list_type = @1;
    [self headerRefresh];
    
}


#pragma mark - 业务方法
- (void)btnOnClick:(UIButton *)sender{
    [self.tableView.footer beginRefreshing];
}


- (NSMutableArray *)columnArray{
    if (!_columnArray) {
        _columnArray = [NSMutableArray array];
    }
    return _columnArray;
}

- (void)citySelectAction{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self loadData];
        [self headerRefresh];

    });
}

- (void)dealloc{
    [WDNotificationCenter removeObserver:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of an[y resources that can be recreated.
}
- (void)viewWillAppear:(BOOL)animated{
    
    [self.tableView reloadData];
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
