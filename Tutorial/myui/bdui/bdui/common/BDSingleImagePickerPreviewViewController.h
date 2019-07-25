//
//  QDSingleImagePickerPreviewViewController.h
//  qmuidemo
//
//  Created by Kayo Lee on 15/5/17.
//  Copyright (c) 2015年 QMUI Team. All rights reserved.
//

#import <QMUIKit/QMUIKit.h>

@class BDSingleImagePickerPreviewViewController;

@protocol BDSingleImagePickerPreviewViewControllerDelegate <QMUIImagePickerPreviewViewControllerDelegate>

@required
- (void)imagePickerPreviewViewController:(BDSingleImagePickerPreviewViewController *)imagePickerPreviewViewController didSelectImageWithImagesAsset:(QMUIAsset *)imageAsset;

@end

@interface BDSingleImagePickerPreviewViewController : QMUIImagePickerPreviewViewController

@property(nonatomic, weak) id<BDSingleImagePickerPreviewViewControllerDelegate> delegate;
@property(nonatomic, strong) QMUIAssetsGroup *assetsGroup;

@end
