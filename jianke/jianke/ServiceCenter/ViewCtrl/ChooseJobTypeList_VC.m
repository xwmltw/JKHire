//
//  ChooseJobTypeList_VC.m
//  JKHire
//
//  Created by yanqb on 2017/3/3.
//  Copyright © 2017年 xianshijian. All rights reserved.
//

#import "ChooseJobTypeList_VC.h"
#import "PostJob_VC.h"

#import "ChooseJobType_cell.h"
#import "ChooseJobTypeHeaderView.h"

#import "JobClassifyInfoModel.h"

@interface ChooseJobTypeList_VC ()<UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>

@property (nonatomic, weak) UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, copy) NSNumber *seekerNum;

@end

@implementation ChooseJobTypeList_VC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"选择岗位类型";
    
    [self setupUI];
    [self getData];
    
}

- (void)setupUI{
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
    collectionView.backgroundColor = [UIColor XSJColor_newGray];
    collectionView.dataSource = self;
    collectionView.delegate = self;
    collectionView.collectionViewLayout = flowLayout;
    self.collectionView = collectionView;
    [self.view addSubview:collectionView];
    
    [collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    [self.collectionView registerClass:[ChooseJobType_cell class] forCellWithReuseIdentifier:@"ChooseJobType_cell"];
    [self.collectionView registerClass:[ChooseJobTypeHeaderView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"ChooseJobTypeHeaderView"];
}

- (void)getData{
    WEAKSELF
    [[XSJRequestHelper sharedInstance] getNearbyJobSeekerNumWithLongitude:[UserData sharedInstance].local.longitude latitude:[UserData sharedInstance].local.longitude block:^(ResponseInfo *result) {
        weakSelf.seekerNum = [result.content objectForKey:@"nearby_job_seeker_num"];
        [[XSJRequestHelper sharedInstance] getJobClassifyInfoListWithCityId:[UserData sharedInstance].city.id isShowLoading:YES block:^(ResponseInfo *response) {
            if (response) {
                NSArray *array = [JobClassifyInfoModel objectArrayWithKeyValuesArray:response.content[@"job_classifier_list"]];
                weakSelf.dataSource = [array mutableCopy];
                [weakSelf.collectionView reloadData];
            }
        }];
    }];
    
}

#pragma mark - uicollection datasource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    if (self.dataSource.count) {
        return 1;
    }
    return 0;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.dataSource.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    ChooseJobType_cell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ChooseJobType_cell" forIndexPath:indexPath];
    JobClassifyInfoModel *model = [self.dataSource objectAtIndex:indexPath.item];
    cell.tagLab.text = model.job_classfier_name;
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    ChooseJobTypeHeaderView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"ChooseJobTypeHeaderView" forIndexPath:indexPath];
    headerView.seekerNum = self.seekerNum;
    return headerView;
}

#pragma mark - UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake((SCREEN_WIDTH - 32 - 11) / 3, 44);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 4.0f;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 4.0f;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    return CGSizeMake(SCREEN_WIDTH, 150);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(0, 16, 0, 16);
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    JobClassifyInfoModel *model = [self.dataSource objectAtIndex:indexPath.item];
    PostJob_VC *viewCtrl = [[PostJob_VC alloc] init];
    viewCtrl.isShowTip = self.isShowTip;
    viewCtrl.jobClassArray = [self.dataSource copy];
    viewCtrl.postJobType = PostJobType_common;
    viewCtrl.jobClassifyInfoModel = model;
    [self.navigationController pushViewController:viewCtrl animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
