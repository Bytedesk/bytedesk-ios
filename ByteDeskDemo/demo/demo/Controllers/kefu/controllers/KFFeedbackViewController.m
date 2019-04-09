//
//  KFFeedbackViewController.m
//  demo
//
//  Created by 萝卜丝 on 2018/12/30.
//  Copyright © 2018 KeFuDaShi. All rights reserved.
//

#import "KFFeedbackViewController.h"
#import "KFFormContentViewCell.h"
#import "KFFormImageViewCell.h"
#import "KFFormPhoneViewCell.h"
#import "KFFormSubmitViewCell.h"
#import <TZImagePickerController/TZImagePickerController.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import <Photos/Photos.h>

@interface KFFeedbackViewController ()<KFFormContentViewCellDelegate, KFFormImageViewCellDelegate, KFFormPhoneViewCellDelegate, KFFormSubmitViewCellDelegate, TZImagePickerControllerDelegate>

@property(nonatomic, strong) KFFormImageViewCell *imageViewCell;

@end

@implementation KFFeedbackViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // TODO: 待上线
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    self.tableView.separatorColor = [UIColor clearColor];
    
    //
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard:)];
    singleTap.numberOfTapsRequired = 1;
    singleTap.numberOfTouchesRequired = 1;
    [self.view addGestureRecognizer:singleTap];
    // Dismiss the keyboard if user double taps on the background
    UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard:)];
    doubleTap.numberOfTapsRequired = 2;
    doubleTap.numberOfTouchesRequired = 1;
    [self.view addGestureRecognizer:doubleTap];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    //
    if (section == 0) {
        return @"问题和意见";
    }
    else if (section == 1) {
        return @"";
    }
    else if (section == 2) {
        return @"联系方式";
    }
    
    return @"";
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    //
    if (indexPath.section == 0) {
        return 100;
    }
    else if (indexPath.section == 1) {
        return 100;
    }
    else if (indexPath.section == 2) {
        return 44;
    }
    return 40;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        NSString *identifier = @"identifierContent";
        KFFormContentViewCell *contentCell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!contentCell) {
            contentCell = [[KFFormContentViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier];
        }
        contentCell.delegate = self;
        return contentCell;
    }
    else if (indexPath.section == 1) {
        NSString *identifier = @"identifierImage";
        self.imageViewCell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!self.imageViewCell) {
            self.imageViewCell = [[KFFormImageViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier];
        }
        self.imageViewCell.delegate = self;
        return self.imageViewCell;
    }
    else if (indexPath.section == 2) {
        NSString *identifier = @"identifierPhone";
        KFFormPhoneViewCell *phoneCell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!phoneCell) {
            phoneCell = [[KFFormPhoneViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier];
        }
        phoneCell.delegate = self;
        return phoneCell;
    }
    
    NSString *identifier = @"identifierSubmit";
    KFFormSubmitViewCell *submitCell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!submitCell) {
        submitCell = [[KFFormSubmitViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier];
    }
    submitCell.delegate = self;
    
    return submitCell;
}


#pragma mark - TouchGestures

-(void)dismissKeyboard:(id)sender {
    [self.view endEditing:YES];
}


#pragma mark - FBContentViewCellDelegate

-(void)contentTextView:(NSString *)content {
    NSLog(@"%s, %@", __PRETTY_FUNCTION__, content);
    
}

#pragma mark - FBImageViewCellDelegate

- (void)pushImagePickerController {
    
    TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:4 columnNumber:4 delegate:self pushPhotoPickerVc:YES];
    
#pragma mark - 四类个性化设置，这些参数都可以不传，此时会走默认设置
    imagePickerVc.isSelectOriginalPhoto = NO;
    
    //    if (self.maxCountTF.text.integerValue > 1) {
    // 1.设置目前已经选中的图片数组
    imagePickerVc.selectedAssets = self.imageViewCell.selectedAssets; // 目前已经选中的图片数组
    //    }
    imagePickerVc.allowTakePicture = YES; // 在内部显示拍照按钮
    
    // 2. Set the appearance
    // 2. 在这里设置imagePickerVc的外观
    // imagePickerVc.navigationBar.barTintColor = [UIColor greenColor];
    // imagePickerVc.oKButtonTitleColorDisabled = [UIColor lightGrayColor];
    // imagePickerVc.oKButtonTitleColorNormal = [UIColor greenColor];
    // imagePickerVc.navigationBar.translucent = NO;
    
    // 3. Set allow picking video & photo & originalPhoto or not
    // 3. 设置是否可以选择视频/图片/原图
    imagePickerVc.allowPickingVideo = NO;
    imagePickerVc.allowPickingImage = YES;
    imagePickerVc.allowPickingOriginalPhoto = YES;
    imagePickerVc.allowPickingGif = FALSE;
    
    // 4. 照片排列按修改时间升序
    imagePickerVc.sortAscendingByModificationDate = YES;
    
    // imagePickerVc.minImagesCount = 3;
    // imagePickerVc.alwaysEnableDoneBtn = YES;
    
    // imagePickerVc.minPhotoWidthSelectable = 3000;
    // imagePickerVc.minPhotoHeightSelectable = 2000;
    
    /// 5. Single selection mode, valid when maxImagesCount = 1
    /// 5. 单选模式,maxImagesCount为1时才生效
    imagePickerVc.showSelectBtn = NO;
    imagePickerVc.allowCrop = NO;
    imagePickerVc.needCircleCrop = NO;
    imagePickerVc.circleCropRadius = 100;
    /*
     [imagePickerVc setCropViewSettingBlock:^(UIView *cropView) {
     cropView.layer.borderColor = [UIColor redColor].CGColor;
     cropView.layer.borderWidth = 2.0;
     }];*/
    
    //imagePickerVc.allowPreview = NO;
#pragma mark - 到这里为止
    
    // You can get the photos by block, the same as by delegate.
    // 你可以通过block或者代理，来得到用户选择的照片.
    [imagePickerVc setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {
        
    }];
    
    [self presentViewController:imagePickerVc animated:YES completion:nil];
}

- (void)presentViewController:(UIViewController *)vc {
    
    [self presentViewController:vc animated:YES completion:nil];
    
}

#pragma mark - FBFormPhoneViewCellDelegate

-(void)phoneTextField:(NSString *)phone {
    NSLog(@"%s, %@", __PRETTY_FUNCTION__, phone);
    
}

#pragma mark - TZImagePickerControllerDelegate

/// User click cancel button
/// 用户点击了取消
- (void)tz_imagePickerControllerDidCancel:(TZImagePickerController *)picker {
    // NSLog(@"cancel");
}

// The picker should dismiss itself; when it dismissed these handle will be called.
// If isOriginalPhoto is YES, user picked the original photo.
// You can get original photo with asset, by the method [[TZImageManager manager] getOriginalPhotoWithAsset:completion:].
// The UIImage Object in photos default width is 828px, you can set it by photoWidth property.
// 这个照片选择器会自己dismiss，当选择器dismiss的时候，会执行下面的代理方法
// 如果isSelectOriginalPhoto为YES，表明用户选择了原图
// 你可以通过一个asset获得原图，通过这个方法：[[TZImageManager manager] getOriginalPhotoWithAsset:completion:]
// photos数组里的UIImage对象，默认是828像素宽，你可以通过设置photoWidth属性的值来改变它
- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingPhotos:(NSArray *)photos sourceAssets:(NSArray *)assets isSelectOriginalPhoto:(BOOL)isSelectOriginalPhoto {
    _imageViewCell.selectedPhotos = [NSMutableArray arrayWithArray:photos];
    _imageViewCell.selectedAssets = [NSMutableArray arrayWithArray:assets];
    //    _isSelectOriginalPhoto = isSelectOriginalPhoto;
    [_imageViewCell reloadCollectionData];
    // _collectionView.contentSize = CGSizeMake(0, ((_selectedPhotos.count + 2) / 3 ) * (_margin + _itemWH));
    
    // 1.打印图片名字
    [self printAssetsName:assets];
}

// If user picking a video, this callback will be called.
// If system version > iOS8,asset is kind of PHAsset class, else is ALAsset class.
// 如果用户选择了一个视频，下面的handle会被执行
// 如果系统版本大于iOS8，asset是PHAsset类的对象，否则是ALAsset类的对象
- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingVideo:(UIImage *)coverImage sourceAssets:(id)asset {
    _imageViewCell.selectedPhotos = [NSMutableArray arrayWithArray:@[coverImage]];
    _imageViewCell.selectedAssets = [NSMutableArray arrayWithArray:@[asset]];
    // open this code to send video / 打开这段代码发送视频
    // [[TZImageManager manager] getVideoOutputPathWithAsset:asset completion:^(NSString *outputPath) {
    // NSLog(@"视频导出到本地完成,沙盒路径为:%@",outputPath);
    // Export completed, send video here, send by outputPath or NSData
    // 导出完成，在这里写上传代码，通过路径或者通过NSData上传
    
    // }];
    [_imageViewCell reloadCollectionData];
    // _collectionView.contentSize = CGSizeMake(0, ((_selectedPhotos.count + 2) / 3 ) * (_margin + _itemWH));
}

// If user picking a gif image, this callback will be called.
// 如果用户选择了一个gif图片，下面的handle会被执行
- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingGifImage:(UIImage *)animatedImage sourceAssets:(id)asset {
    _imageViewCell.selectedPhotos = [NSMutableArray arrayWithArray:@[animatedImage]];
    _imageViewCell.selectedAssets = [NSMutableArray arrayWithArray:@[asset]];
    
    [_imageViewCell reloadCollectionData];
}


/// 打印图片名字
- (void)printAssetsName:(NSArray *)assets {
    NSString *fileName;
    for (id asset in assets) {
        if ([asset isKindOfClass:[PHAsset class]]) {
            PHAsset *phAsset = (PHAsset *)asset;
            fileName = [phAsset valueForKey:@"filename"];
        } else if ([asset isKindOfClass:[ALAsset class]]) {
            ALAsset *alAsset = (ALAsset *)asset;
            fileName = alAsset.defaultRepresentation.filename;;
        }
        //NSLog(@"图片名字:%@",fileName);
    }
}

@end
