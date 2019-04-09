//
//  KFImageViewCell.m
//  feedback
//
//  Created by 萝卜丝 on 2017/2/18.
//  Copyright © 2017 年 萝卜丝. All rights reserved.
//

#import "KFFormImageViewCell.h"
#import "UIView+FeedBack.h"
#import <TZImagePickerController/TZImagePickerController.h>
#import <TZImagePickerController/TZGifPhotoPreviewController.h>
#import <TZImagePickerController/TZVideoPlayerController.h>
#import "LxGridViewFlowLayout.h"
#import <TZImagePickerController/UIView+Layout.h>
#import "TZTestCell.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <Photos/Photos.h>

#define LBScreen [UIScreen mainScreen].bounds.size

@interface KFFormImageViewCell () <UICollectionViewDataSource, UICollectionViewDelegate>
{
    CGFloat _itemWH;
    CGFloat _margin;
}

@property (nonatomic, strong) UILabel *countTipLabel;
@property (nonatomic, strong) UICollectionView *collectionView;

@end

@implementation KFFormImageViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        [self setupSubviews];
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

- (void)reloadCollectionData {
    [_countTipLabel setText:[NSString stringWithFormat:@"%lu/4", (unsigned long)[_selectedPhotos count]]];
    [_collectionView reloadData];
}

- (void)setupSubviews {
    
    UILabel *tipLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    tipLabel.text = @"图片(选填，提供问题截图)";
    tipLabel.font = [UIFont systemFontOfSize:13.0f];
    [self.contentView addSubview:tipLabel];
    tipLabel.fb_left = 10;
    tipLabel.fb_top = 10;
    [tipLabel sizeToFit];
    
    _countTipLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    _countTipLabel.text = @"0/4";
    _countTipLabel.font = [UIFont systemFontOfSize:13.0f];
    _countTipLabel.textColor = [UIColor grayColor];
    _countTipLabel.fb_top = 10;
    _countTipLabel.fb_right = LBScreen.width - 30;
    [self.contentView addSubview:_countTipLabel];
    [_countTipLabel sizeToFit];
    
    [self configCollectionView];
}


- (void)configCollectionView {
    _selectedPhotos = [NSMutableArray array];
    _selectedAssets = [NSMutableArray array];
    
    // 如不需要长按排序效果，将LxGridViewFlowLayout类改成UICollectionViewFlowLayout即可
    LxGridViewFlowLayout *layout = [[LxGridViewFlowLayout alloc] init];
    //    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    _margin = 4;
    //    _itemWH = (self.contentView.tz_width - 2 * _margin - 4) / 3 - _margin;
    _itemWH = 60;
    layout.itemSize = CGSizeMake(_itemWH, _itemWH);
    layout.minimumInteritemSpacing = _margin;
    layout.minimumLineSpacing = _margin;
    
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(10, 30, LBScreen.width-20, 70) collectionViewLayout:layout];
    _collectionView.alwaysBounceVertical = YES;
    _collectionView.backgroundColor = [UIColor clearColor];
    //    CGFloat rgb = 244 / 255.0;
    //    _collectionView.backgroundColor = [UIColor colorWithRed:rgb green:rgb blue:rgb alpha:1.0];
    _collectionView.contentInset = UIEdgeInsetsMake(4, 4, 4, 4);
    _collectionView.dataSource = self;
    _collectionView.delegate = self;
    _collectionView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    _collectionView.userInteractionEnabled = YES;
    [self.contentView addSubview:_collectionView];
    
    [_collectionView registerClass:[TZTestCell class] forCellWithReuseIdentifier:@"TZTestCell"];
}

#pragma mark UICollectionView

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _selectedPhotos.count + 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    TZTestCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"TZTestCell" forIndexPath:indexPath];
    cell.videoImageView.hidden = YES;
    
    if (indexPath.row == _selectedPhotos.count) {
        cell.imageView.image = [UIImage imageNamed:@"AlbumAddBtn.png" inBundle:[NSBundle bundleForClass:self.class] compatibleWithTraitCollection:nil];
        cell.deleteBtn.hidden = YES;
        cell.gifLable.hidden = YES;
    } else {
        cell.imageView.image = _selectedPhotos[indexPath.row];
        cell.asset = _selectedAssets[indexPath.row];
        cell.deleteBtn.hidden = NO;
    }
    cell.gifLable.hidden = YES;
    cell.deleteBtn.tag = indexPath.row;
    [cell.deleteBtn addTarget:self action:@selector(deleteBtnClik:) forControlEvents:UIControlEventTouchUpInside];
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    NSLog(@"%s", __PRETTY_FUNCTION__);
    
    if (indexPath.row == _selectedPhotos.count) {
        
        //        BOOL showSheet = NO;//self.showSheetSwitch.isOn;
        //        if (showSheet) {
        //            UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照",@"去相册选择", nil];
        //            [sheet showInView:self.contentView];
        //        } else {
        //            [self pushImagePickerController];
        //        }
        
        if (_delegate && [_delegate respondsToSelector:@selector(pushImagePickerController)]) {
            [_delegate pushImagePickerController];
        }
        
    }
    else
    { // preview photos or video / 预览照片或者视频
        id asset = _selectedAssets[indexPath.row];
        BOOL isVideo = NO;
        if ([asset isKindOfClass:[PHAsset class]]) {
            PHAsset *phAsset = asset;
            isVideo = phAsset.mediaType == PHAssetMediaTypeVideo;
        } else if ([asset isKindOfClass:[ALAsset class]]) {
            ALAsset *alAsset = asset;
            isVideo = [[alAsset valueForProperty:ALAssetPropertyType] isEqualToString:ALAssetTypeVideo];
        }
        if ([[asset valueForKey:@"filename"] containsString:@"GIF"] ) {
            TZGifPhotoPreviewController *vc = [[TZGifPhotoPreviewController alloc] init];
            TZAssetModel *model = [TZAssetModel modelWithAsset:asset type:TZAssetModelMediaTypePhotoGif timeLength:@""];
            vc.model = model;
            //            [self presentViewController:vc animated:YES completion:nil];
            if (_delegate && [_delegate respondsToSelector:@selector(presentViewController:)]) {
                [_delegate presentViewController:vc];
            }
        } else if (isVideo) { // perview video / 预览视频
            TZVideoPlayerController *vc = [[TZVideoPlayerController alloc] init];
            TZAssetModel *model = [TZAssetModel modelWithAsset:asset type:TZAssetModelMediaTypeVideo timeLength:@""];
            vc.model = model;
            //            [self presentViewController:vc animated:YES completion:nil];
            if (_delegate && [_delegate respondsToSelector:@selector(presentViewController:)]) {
                [_delegate presentViewController:vc];
            }
        } else { // preview photos / 预览照片
            TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithSelectedAssets:_selectedAssets selectedPhotos:_selectedPhotos index:indexPath.row];
            imagePickerVc.maxImagesCount = 4;
            imagePickerVc.allowPickingOriginalPhoto = YES;
            imagePickerVc.isSelectOriginalPhoto = FALSE;
            [imagePickerVc setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {
                self->_selectedPhotos = [NSMutableArray arrayWithArray:photos];
                self->_selectedAssets = [NSMutableArray arrayWithArray:assets];
                //                _isSelectOriginalPhoto = isSelectOriginalPhoto;
                
                [self reloadCollectionData];
                self->_collectionView.contentSize = CGSizeMake(0, ((self->_selectedPhotos.count + 2) / 3 ) * (_margin + _itemWH));
            }];
            //            [self presentViewController:imagePickerVc animated:YES completion:nil];
            if (_delegate && [_delegate respondsToSelector:@selector(presentViewController:)]) {
                [_delegate presentViewController:imagePickerVc];
            }
        }
    }
}

#pragma mark - LxGridViewDataSource

/// 以下三个方法为长按排序相关代码
- (BOOL)collectionView:(UICollectionView *)collectionView canMoveItemAtIndexPath:(NSIndexPath *)indexPath {
    return indexPath.item < _selectedPhotos.count;
}

- (BOOL)collectionView:(UICollectionView *)collectionView itemAtIndexPath:(NSIndexPath *)sourceIndexPath canMoveToIndexPath:(NSIndexPath *)destinationIndexPath {
    return (sourceIndexPath.item < _selectedPhotos.count && destinationIndexPath.item < _selectedPhotos.count);
}

- (void)collectionView:(UICollectionView *)collectionView itemAtIndexPath:(NSIndexPath *)sourceIndexPath didMoveToIndexPath:(NSIndexPath *)destinationIndexPath {
    UIImage *image = _selectedPhotos[sourceIndexPath.item];
    [_selectedPhotos removeObjectAtIndex:sourceIndexPath.item];
    [_selectedPhotos insertObject:image atIndex:destinationIndexPath.item];
    
    id asset = _selectedAssets[sourceIndexPath.item];
    [_selectedAssets removeObjectAtIndex:sourceIndexPath.item];
    [_selectedAssets insertObject:asset atIndex:destinationIndexPath.item];
    
    [_countTipLabel setText:[NSString stringWithFormat:@"%lu/4", (unsigned long)[_selectedPhotos count]]];
    [_collectionView reloadData];
}


#pragma mark - Click Event

- (void)deleteBtnClik:(UIButton *)sender {
    [_selectedPhotos removeObjectAtIndex:sender.tag];
    [_selectedAssets removeObjectAtIndex:sender.tag];
    
    [_collectionView performBatchUpdates:^{
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:sender.tag inSection:0];
        [self->_collectionView deleteItemsAtIndexPaths:@[indexPath]];
    } completion:^(BOOL finished) {
        
        [self reloadCollectionData];
    }];
}


@end




