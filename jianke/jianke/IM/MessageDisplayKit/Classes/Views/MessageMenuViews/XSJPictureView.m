//
//  XSJPictureView.m
//  jianke
//
//  Created by fire on 16/1/6.
//  Copyright © 2016年 xianshijian. All rights reserved.
//

#import "XSJPictureView.h"
#import "UIView+MKExtension.h"
#import "UIHelper.h"
#import "Masonry.h"


@implementation XSJPictureCellModel
@end


@implementation XSJPictureCell

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        UIImageView *imageView = [[UIImageView alloc] init];
        [self.contentView addSubview:imageView];
        self.imageView =  imageView;
        imageView.frame = self.contentView.bounds;
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.contentView);
        }];
        
        UIButton *selectBtn = [[UIButton alloc] initWithFrame:CGRectMake(imageView.width - 25, 5, 20, 20)];
        [selectBtn setImage:[UIImage imageNamed:@"v240_img_0"] forState:UIControlStateNormal];
        [selectBtn setImage:[UIImage imageNamed:@"v240_img_1"] forState:UIControlStateSelected];
        [selectBtn setImage:[UIImage imageNamed:@"v240_img_1"] forState:UIControlStateHighlighted];
        selectBtn.userInteractionEnabled = NO;
        [self addSubview:selectBtn];
        self.selectBtn = selectBtn;
        
        [selectBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentView).offset(5);
            make.right.equalTo(self.contentView).offset(-5);
            make.width.height.equalTo(@20);
        }];
    }
    
    return self;
}
@end



//@implementation XSJPictureFooter
//
//- (instancetype)initWithFrame:(CGRect)frame
//{
//    if (self = [super initWithFrame:frame]) {
//        
//        UIButton *selectBtn = [[UIButton alloc] initWithFrame:CGRectMake(-20, 5, 20, 20)];
//        [selectBtn setImage:[UIImage imageNamed:@"v240_img_0"] forState:UIControlStateNormal];
//        [selectBtn setImage:[UIImage imageNamed:@"v240_img_1"] forState:UIControlStateSelected];
//        [selectBtn setImage:[UIImage imageNamed:@"v240_img_1"] forState:UIControlStateHighlighted];
//        [self addSubview:selectBtn];
//        self.selectBtn = selectBtn;
//    }
//    
//    return self;
//}
//
//- (void)setSelected:(BOOL)selected
//{
//    _selected = selected;
//    self.selectBtn.selected = selected;
//}
//
//@end


@interface XSJPictureView () <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (nonatomic, weak) UICollectionView *collectionView;

@property (nonatomic, strong) ALAssetsLibrary *assetsLibrary; /*!< 相片库 */
@property (nonatomic, strong) NSMutableArray *imagesAssetArray; /*!< 相片数组 */
@property (nonatomic, weak) UIButton *sendPictureBtn; /*!< 发送按钮 */
@property (nonatomic, strong) NSArray *selectedPictures; /*!< 选中的相片 */

@end


@implementation XSJPictureView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)setup
{
    self.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    self.backgroundColor = [UIColor colorWithWhite:0.961 alpha:1.000];

    
    // 获取相片
    [self getAllPictures];
    
    // 设置collectionView
    [self setupCollectionView];
    
    // 设置底部按钮
    [self setupBottomBtn];
}


/** 获取相片 */
- (void)getAllPictures
{
    NSString *tipTextWhenNoPhotosAuthorization; // 提示语

    // 获取当前应用对照片的访问授权状态
//    ALAuthorizationStatus authorizationStatus = [ALAssetsLibrary authorizationStatus];
    PHAuthorizationStatus authorizationStatus = [PHPhotoLibrary authorizationStatus];
    
    // 如果没有获取访问授权，或者访问授权状态已经被明确禁止，则显示提示语，引导用户开启授权
    if (authorizationStatus == PHAuthorizationStatusRestricted || authorizationStatus == PHAuthorizationStatusDenied) {
        NSDictionary *mainInfoDictionary = [[NSBundle mainBundle] infoDictionary];
        NSString *appName = [mainInfoDictionary objectForKey:@"CFBundleDisplayName"];
        tipTextWhenNoPhotosAuthorization = [NSString stringWithFormat:@"请在设备的\"设置-隐私-照片\"选项中，允许%@访问你的手机相册", appName];

        // 展示提示语
        [UIHelper toast:tipTextWhenNoPhotosAuthorization];
        return;
    }
    
    self.assetsLibrary = [[ALAssetsLibrary alloc] init];
    self.imagesAssetArray = [[NSMutableArray alloc] init];
    
    
    PHFetchResult *assetColletionList = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum subtype:PHAssetCollectionSubtypeSmartAlbumUserLibrary options:nil];
    if (assetColletionList.count) { //有相册簿
        PHFetchOptions *options = [[PHFetchOptions alloc] init];
        WEAKSELF
        [assetColletionList enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(PHAssetCollection * _Nonnull assetCollection, NSUInteger idx, BOOL * _Nonnull stop) {
            if (assetCollection.estimatedAssetCount > 0) {
                PHFetchResult *phAssetList = [PHAsset fetchAssetsInAssetCollection:assetCollection options:nil];
                if (phAssetList.count) {    //有相片
                    [phAssetList enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(PHAsset * _Nonnull asset, NSUInteger index, BOOL * _Nonnull stopAsset) {
                        if (asset) {
                            XSJPictureCellModel *model = [[XSJPictureCellModel alloc] init];
                            model.imageAsset = asset;
                            model.selected = NO;
                            [weakSelf.imagesAssetArray addObject:model];
                            
                            // 最多100张照片
                            if (self.imagesAssetArray.count >= 100) {
                                *stopAsset = YES;
                            }
                        }
                    }];
                }
            }
            // 最多100张照片
            if (self.imagesAssetArray.count >= 100) {
                *stop = YES;
            }
        }];
    }else{
        [self.collectionView reloadData];
        DLog(@"Asset group not found!\n");
    }
}


/** 设置collectionView */
- (void)setupCollectionView
{
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    layout.minimumInteritemSpacing = 5;
    layout.sectionInset = UIEdgeInsetsMake(0, 5, 0, 5);
//    layout.sectionInset = UIEdgeInsetsMake(0, 5, 0, 0);
//    layout.footerReferenceSize = CGSizeMake(1, self.collectionView.height);
    
//    if ([UIDevice currentDevice].systemVersion.floatValue >= 9.0) {
//        layout.sectionFootersPinToVisibleBounds = YES;
//    }    
    
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, self.width, self.height - 42) collectionViewLayout:layout];
    collectionView.backgroundColor = [UIColor colorWithWhite:0.961 alpha:1.000];
    [collectionView registerClass:[XSJPictureCell class] forCellWithReuseIdentifier:@"cell"];
//    [collectionView registerClass:[XSJPictureFooter class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"footer"];
    collectionView.delegate = self;
    collectionView.dataSource = self;
    collectionView.showsHorizontalScrollIndicator = NO;
    [self addSubview:collectionView];
    self.collectionView = collectionView;
}


/** 设置底部按钮 */
- (void)setupBottomBtn
{
    // 相册按钮
    UIButton *pictureBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, self.height - 42, 68, 42)];
    [pictureBtn setTitle:@"相册" forState:UIControlStateNormal];
    pictureBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [pictureBtn setTitleColor:MKCOLOR_RGB(32, 188, 210) forState:UIControlStateNormal];
    [pictureBtn addTarget:self action:@selector(pictureBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:pictureBtn];
    
    // 发送按钮
    UIButton *sendPictureBtn = [[UIButton alloc] initWithFrame:CGRectMake(self.width - 88, self.height - 35, 68, 28)];
    [sendPictureBtn setTitle:@"发送" forState:UIControlStateDisabled];
    [sendPictureBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [sendPictureBtn setBackgroundImage:[UIImage imageNamed:@"v210_rectangle"] forState:UIControlStateDisabled];
    [sendPictureBtn setBackgroundImage:[UIImage imageNamed:@"v210_delete_background"] forState:UIControlStateNormal];
    sendPictureBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [sendPictureBtn addTarget:self action:@selector(sendPictureBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    sendPictureBtn.layer.cornerRadius = 2;
    sendPictureBtn.layer.masksToBounds = YES;
    self.sendPictureBtn = sendPictureBtn;
    sendPictureBtn.enabled = NO;
    [self addSubview:sendPictureBtn];
}

#pragma mark - UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    XSJPictureCellModel *model = self.imagesAssetArray[indexPath.item];
    CGSize newSize = CGSizeMake(collectionView.height * model.imageAsset.pixelWidth / model.imageAsset.pixelHeight, collectionView.height);
    return newSize;
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.imagesAssetArray.count;
}

//- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
//{
//    return self.imagesAssetArray.count;
//}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    XSJPictureCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    
    XSJPictureCellModel *model = self.imagesAssetArray[indexPath.item];
    PHImageRequestOptions *options = [[PHImageRequestOptions alloc] init];
    // 异步获得图片, 可能会返回多张图片(block被多次调用)
    options.synchronous = NO;
    
    [[PHImageManager defaultManager] requestImageForAsset:model.imageAsset targetSize:CGSizeMake(model.imageAsset.pixelWidth, model.imageAsset.pixelHeight) contentMode:PHImageContentModeAspectFit options:options resultHandler:^(UIImage * _Nullable image, NSDictionary * _Nullable info) {
        if (image) {
            cell.imageView.image = image;
            cell.selectBtn.selected = model.selected;
        }
    }];
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
 
    // 设置数据模型
    XSJPictureCellModel *model = self.imagesAssetArray[indexPath.item];
    
    //  不能超过9张
    self.selectedPictures = [self.imagesAssetArray filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"selected == YES"]];
    if (self.selectedPictures.count >= 9 && !model.selected) {
        
        [UIHelper toast:@"每次最多发送9张图片"];
        return;
    }
    
    model.selected = !model.selected;
    
    // 设置打勾
    XSJPictureCell *cell = (XSJPictureCell *)[collectionView cellForItemAtIndexPath:indexPath];
    cell.selectBtn.selected = model.selected;
    
    // 设置发送按钮
    self.selectedPictures = [self.imagesAssetArray filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"selected == YES"]];
    [self.sendPictureBtn setTitle:[NSString stringWithFormat:@"发送(%lu)", (unsigned long)self.selectedPictures.count] forState:UIControlStateNormal];
    self.sendPictureBtn.enabled = self.selectedPictures.count;
    
    
}

#pragma mark - 按钮点击事件
- (void)pictureBtnClick
{
    if ([self.delegate respondsToSelector:@selector(pictureViewDidClickPictureBtn:)]) {
        [self.delegate pictureViewDidClickPictureBtn:self];
    }    
}


- (void)sendPictureBtnClick:(UIButton *)btn
{
    if ([self.delegate respondsToSelector:@selector(pictureView:didSelected:clickSendBtn:)]) {
        [self.delegate pictureView:self didSelected:self.selectedPictures clickSendBtn:btn];
    }
}

/** 设置图片状态为未选中 */
- (void)setPicturesUnSelected
{
    for (XSJPictureCellModel *model in self.selectedPictures) {
        model.selected = NO;
    }
    
    [self.collectionView reloadData];
}


@end
