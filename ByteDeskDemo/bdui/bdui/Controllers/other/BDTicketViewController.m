//
//  KFTicketViewController.m
//  demo
//
//  Created by 萝卜丝 on 2019/1/21.
//  Copyright © 2019 KeFuDaShi. All rights reserved.
//

#import "BDTicketViewController.h"
//#import "QDNavigationController.h"
#import "BDFormContentViewCell.h"
#import "BDFormEmailViewCell.h"
#import "BDFormPhoneViewCell.h"
#import "BDFormSubmitViewCell.h"


#import "BDSingleImagePickerPreviewViewController.h"
#import <AFNetworking/UIImageView+AFNetworking.h>

#import <bytedesk-core/bdcore.h>

static QMUIAlbumContentType const kAlbumContentType = QMUIAlbumContentTypeOnlyPhoto;

@interface BDTicketViewController ()<BDFormContentViewCellDelegate, BDFormPhoneViewCellDelegate, BDFormEmailViewCellDelegate, BDFormSubmitViewCellDelegate, QMUIAlbumViewControllerDelegate,QMUIImagePickerViewControllerDelegate,BDSingleImagePickerPreviewViewControllerDelegate>

@property(nonatomic, strong) NSMutableDictionary *mCategoryDict;

// 注意：仅有两个值，NSString类型，紧急：“1”，一般：“0”
@property(nonatomic, strong) NSString *mUrgent;
@property(nonatomic, strong) NSString *mCategoryName;
@property(nonatomic, strong) NSString *mCategoryCid;

@property(nonatomic, strong) NSString *mContent;
@property(nonatomic, strong) NSString *mMobile;
@property(nonatomic, strong) NSString *mEmail;
@property(nonatomic, strong) NSString *mFileUrl;

@property(nonatomic, strong) NSString *mAdminUid;

@end

@implementation BDTicketViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //
    self.mUrgent = @"0";
    self.mCategoryName = @"";
    self.mCategoryCid = @"";
    //
    self.mContent = @"";
    self.mMobile = @"";
    self.mEmail = @"";
    self.mFileUrl = @"";
    
    // TODO: 待上线
    [self getTicketCategories];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    //
//    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard:)];
//    singleTap.numberOfTapsRequired = 1;
//    singleTap.numberOfTouchesRequired = 1;
//    [self.view addGestureRecognizer:singleTap];
//    // Dismiss the keyboard if user double taps on the background
//    UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard:)];
//    doubleTap.numberOfTapsRequired = 2;
//    doubleTap.numberOfTouchesRequired = 1;
//    [self.view addGestureRecognizer:doubleTap];
}

- (void)initWithUid:(NSString *)uid {
    self.mAdminUid = uid;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 5;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0 || section == 3) {
        return 2;
    }
    return 1;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return @"";
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    //
    if (indexPath.section == 0) {
        return 44;
    }
    else if (indexPath.section == 1) {
        return 100;
    }
    else if (indexPath.section == 2) {
        return 100;
    }
    else if (indexPath.section == 3) {
        return 44;
    }
    else if (indexPath.section == 4) {
        return 44;
    }
    return 40;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        //
        if (indexPath.row == 0) {
            NSString *identifier = @"identifierUrgent";
            UITableViewCell *urgentCell = [tableView dequeueReusableCellWithIdentifier:identifier];
            if (!urgentCell) {
                urgentCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier];
                urgentCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            }
            urgentCell.textLabel.text = @"优先级";
            urgentCell.detailTextLabel.text = [self.mUrgent isEqualToString:@"0"] ? @"一般" : @"紧急";
            return urgentCell;
        } else {
            NSString *identifier = @"identifierCategory";
            UITableViewCell *categoryCell = [tableView dequeueReusableCellWithIdentifier:identifier];
            if (!categoryCell) {
                categoryCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier];
                categoryCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            }
            categoryCell.textLabel.text = @"分类";
            categoryCell.detailTextLabel.text = self.mCategoryName;
            return categoryCell;
        }
    } else if (indexPath.section == 1) {
        NSString *identifier = @"identifierContent";
        BDFormContentViewCell *contentCell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!contentCell) {
            contentCell = [[BDFormContentViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier];
        }
        contentCell.delegate = self;
        return contentCell;
    }
    else if (indexPath.section == 2) {
        NSString *identifier = @"identifierImage";
        UITableViewCell *imageViewCell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!imageViewCell) {
            imageViewCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier];
        }
        // Configure the view for the selected state
        [imageViewCell.imageView setImageWithURL:[NSURL URLWithString:self.mFileUrl] placeholderImage:[UIImage imageNamed:@"AlbumAddBtn.png" inBundle:[NSBundle bundleForClass:self.class] compatibleWithTraitCollection:nil]];
        imageViewCell.imageView.userInteractionEnabled = YES;
        
        UITapGestureRecognizer *tapped = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(presentViewController:)];
        tapped.numberOfTapsRequired = 1;
        [imageViewCell.imageView addGestureRecognizer:tapped];
        
        return imageViewCell;
    }
    else if (indexPath.section == 3) {
        if (indexPath.row == 0) {
            NSString *identifier = @"identifierPhone";
            BDFormPhoneViewCell *phoneCell = [tableView dequeueReusableCellWithIdentifier:identifier];
            if (!phoneCell) {
                phoneCell = [[BDFormPhoneViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier];
            }
            phoneCell.delegate = self;
            return phoneCell;
        } else {
            NSString *identifier = @"identifierEmail";
            BDFormEmailViewCell *emailCell = [tableView dequeueReusableCellWithIdentifier:identifier];
            if (!emailCell) {
                emailCell = [[BDFormEmailViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier];
            }
            emailCell.delegate = self;
            return emailCell;
        }
    }
    //
    NSString *identifier = @"identifierSubmit";
    BDFormSubmitViewCell *submitCell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!submitCell) {
        submitCell = [[BDFormSubmitViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier];
    }
    submitCell.delegate = self;
    return submitCell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
//    DDLogInfo(@"%s, %@", __PRETTY_FUNCTION__, indexPath);
    
    if (indexPath.section == 0) {
        //
        if (indexPath.row == 0) {
            //
            [self chooseUrgent];
        } else {
            //
            [self chooseCategory];
        }
    }
}

#pragma mark - TouchGestures

-(void)dismissKeyboard:(id)sender {
    [self.view endEditing:YES];
}

#pragma mark - KFContentViewCellDelegate

-(void)contentTextView:(NSString *)content {
    DDLogInfo(@"%s, %@", __PRETTY_FUNCTION__, content);
    self.mContent = content;
}

#pragma mark - KFFormPhoneViewCellDelegate

-(void)phoneTextField:(NSString *)phone {
    DDLogInfo(@"%s %@", __PRETTY_FUNCTION__, phone);
    self.mMobile = phone;
}

#pragma mark - KFFormEmailViewCellDelegate

-(void)emailTextField:(NSString *)email {
    DDLogInfo(@"%s %@", __PRETTY_FUNCTION__, email);
    self.mEmail = email;
}

#pragma mark - KFFormSubmitViewCellDelegate

- (void)submitButtonClicked:(id)sender {
    DDLogInfo(@"%s", __PRETTY_FUNCTION__);
    
    [BDCoreApis createTicket:self.mAdminUid
                  withUrgent:self.mUrgent
                     withCid:self.mCategoryCid
                 withContent:self.mContent
                  withMobile:self.mMobile
                   withEmail:self.mEmail
                 withFileUrl:self.mFileUrl
               resultSuccess:^(NSDictionary *dict) {
        
                   NSString *message = [dict objectForKey:@"message"];
                   NSNumber *status_code = [dict objectForKey:@"status_code"];
                   if ([status_code isEqualToNumber:[NSNumber numberWithInt:200]]) {
                       //
                       [QMUITips showSucceed:@"提交工单成功" inView:self.view hideAfterDelay:2.0];
                   } else {
                       //
                       [QMUITips showError:message inView:self.view hideAfterDelay:2.0];
                   }
                   
               } resultFailed:^(NSError *error) {
                   DDLogError(@"%s %@", __PRETTY_FUNCTION__, error);
                   if (error) {
                       [QMUITips showError:error.localizedDescription inView:self.view hideAfterDelay:2];
                   }
               }];
}

#pragma mark - KFFormSingleImageViewCellDelegate

- (void)presentViewController:(id)sender {
    DDLogInfo(@"%s", __PRETTY_FUNCTION__);
    
    [self authorizationPresentAlbumViewController];
}

- (void)authorizationPresentAlbumViewController {
    DDLogInfo(@"%s", __PRETTY_FUNCTION__);
    
    if ([QMUIAssetsManager authorizationStatus] == QMUIAssetAuthorizationStatusNotDetermined) {
        [QMUIAssetsManager requestAuthorization:^(QMUIAssetAuthorizationStatus status) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self presentAlbumViewController];
            });
        }];
    } else {
        [self presentAlbumViewController];
    }
}

- (void)presentAlbumViewController {
    DDLogInfo(@"%s", __PRETTY_FUNCTION__);
    
    // 创建一个 QMUIAlbumViewController 实例用于呈现相簿列表
    QMUIAlbumViewController *albumViewController = [[QMUIAlbumViewController alloc] init];
    albumViewController.albumViewControllerDelegate = self;
    albumViewController.contentType = kAlbumContentType;
    albumViewController.title = @"选择图片";
    QMUINavigationController *navigationController = [[QMUINavigationController alloc] initWithRootViewController:albumViewController];
    
    // 获取最近发送图片时使用过的相簿，如果有则直接进入该相簿
    [albumViewController pickLastAlbumGroupDirectlyIfCan];
    
    [self presentViewController:navigationController animated:YES completion:NULL];
}

#pragma mark - <QMUIAlbumViewControllerDelegate>

- (QMUIImagePickerViewController *)imagePickerViewControllerForAlbumViewController:(QMUIAlbumViewController *)albumViewController {
    DDLogInfo(@"%s", __PRETTY_FUNCTION__);
    
    QMUIImagePickerViewController *imagePickerViewController = [[QMUIImagePickerViewController alloc] init];
    imagePickerViewController.imagePickerViewControllerDelegate = self;
    imagePickerViewController.maximumSelectImageCount = 1;
    imagePickerViewController.view.tag = albumViewController.view.tag;
    imagePickerViewController.allowsMultipleSelection = NO;
    
    return imagePickerViewController;
}

#pragma mark - <QMUIImagePickerViewControllerDelegate>

- (QMUIImagePickerPreviewViewController *)imagePickerPreviewViewControllerForImagePickerViewController:(QMUIImagePickerViewController *)imagePickerViewController {
    DDLogInfo(@"%s", __PRETTY_FUNCTION__);
    //
    BDSingleImagePickerPreviewViewController *imagePickerPreviewViewController = [[BDSingleImagePickerPreviewViewController alloc] init];
    imagePickerPreviewViewController.delegate = self;
    imagePickerPreviewViewController.assetsGroup = imagePickerViewController.assetsGroup;
    imagePickerPreviewViewController.view.tag = imagePickerViewController.view.tag;
    
    return imagePickerPreviewViewController;
}


#pragma mark - <QDSingleImagePickerPreviewViewControllerDelegate>

- (void)imagePickerPreviewViewController:(BDSingleImagePickerPreviewViewController *)imagePickerPreviewViewController didSelectImageWithImagesAsset:(QMUIAsset *)imageAsset {
    DDLogInfo(@"%s", __PRETTY_FUNCTION__);
    
    // 储存最近选择了图片的相册，方便下次直接进入该相册
    [QMUIImagePickerHelper updateLastestAlbumWithAssetsGroup:imagePickerPreviewViewController.assetsGroup ablumContentType:kAlbumContentType userIdentify:nil];
    
    // 显示 loading
    //    [self startLoading];
    
    [imageAsset requestImageData:^(NSData *imageData, NSDictionary<NSString *,id> *info, BOOL isGIF, BOOL isHEIC) {
        UIImage *targetImage = [UIImage imageWithData:imageData];
        if (isHEIC) {
            // iOS 11 中新增 HEIF/HEVC 格式的资源，直接发送新格式的照片到不支持新格式的设备，照片可能会无法识别，可以先转换为通用的 JPEG 格式再进行使用。
            // 详细请浏览：https://github.com/QMUI/QMUI_iOS/issues/224
            targetImage = [UIImage imageWithData:UIImageJPEGRepresentation(targetImage, 1)];
        }
        NSData *imageData2 = UIImageJPEGRepresentation(targetImage, 0);
        [self uploadImageData:imageData2];
    }];
}

- (void)uploadImageData:(NSData *)imageData {
    //
    NSString *imageName = [NSString stringWithFormat:@"%@_%@.png", [BDSettings getUsername], [BDUtils getCurrentTimeString]];
    [BDCoreApis uploadImageData:imageData withImageName:imageName resultSuccess:^(NSDictionary *dict) {
        //
        NSNumber *status_code = [dict objectForKey:@"status_code"];
        if ([status_code isEqualToNumber:[NSNumber numberWithInt:200]]) {
            
            NSString *imageUrl = dict[@"data"];
            self.mFileUrl = imageUrl;
            DDLogInfo(@"imageUrl %@", imageUrl);
            
            [self.tableView reloadData];
            
        } else {
            [QMUITips showError:@"上传图片错误" inView:self.view hideAfterDelay:2];
        }
    } resultFailed:^(NSError *error) {
        
    }];
    
}

#pragma mark - 分类

- (void)getTicketCategories {
    //
    self.mCategoryDict = [[NSMutableDictionary alloc] init];
    [BDCoreApis getTicketCategories:self.mAdminUid resultSuccess:^(NSDictionary *dict) {
//        DDLogInfo(@"%s %@", __PRETTY_FUNCTION__, dict);
        
        NSNumber *status_code = [dict objectForKey:@"status_code"];
        if ([status_code isEqualToNumber:[NSNumber numberWithInt:200]]) {
            
            NSMutableArray *categoryArray = dict[@"data"];
            for (NSDictionary *categoryDict in categoryArray) {
                NSString *cid = categoryDict[@"cid"];
                NSString *name = categoryDict[@"name"];
//                DDLogInfo(@"cid: %@, name: %@", cid, name);
                self.mCategoryDict[name] = cid;
            }
            
        } else {
            NSString *message = [dict objectForKey:@"message"];
            [QMUITips showError:message inView:self.view hideAfterDelay:2.0];
        }
        
    } resultFailed:^(NSError *error) {
        DDLogError(@"%s %@", __PRETTY_FUNCTION__, error);
        if (error) {
            [QMUITips showError:error.localizedDescription inView:self.view hideAfterDelay:2];
        }
    }];
}

- (void)chooseUrgent {
    
    QMUIDialogSelectionViewController *dialogViewController = [[QMUIDialogSelectionViewController alloc] init];
    dialogViewController.title = @"选择优先级";
    dialogViewController.items = @[@"一般", @"紧急"];
    dialogViewController.cellForItemBlock = ^(QMUIDialogSelectionViewController *aDialogViewController, QMUITableViewCell *cell, NSUInteger itemIndex) {
        cell.accessoryType = UITableViewCellAccessoryNone;// 移除点击时默认加上右边的checkbox
    };
    dialogViewController.heightForItemBlock = ^CGFloat (QMUIDialogSelectionViewController *aDialogViewController, NSUInteger itemIndex) {
        return 54;// 修改默认的行高，默认为 TableViewCellNormalHeight
    };
    dialogViewController.didSelectItemBlock = ^(QMUIDialogSelectionViewController *aDialogViewController, NSUInteger itemIndex) {
        [aDialogViewController hide];
        if (itemIndex == 0) {
//            DDLogInfo(@"一般");
            self.mUrgent = @"0";
        } else {
//            DDLogInfo(@"紧急");
            self.mUrgent = @"1";
        }
        //
        [self.tableView reloadData];
    };
    [dialogViewController show];
}

- (void)chooseCategory {
    
    QMUIDialogSelectionViewController *dialogViewController = [[QMUIDialogSelectionViewController alloc] init];
    dialogViewController.title = @"选择分类";
    dialogViewController.items = [self.mCategoryDict allKeys];
    dialogViewController.cellForItemBlock = ^(QMUIDialogSelectionViewController *aDialogViewController, QMUITableViewCell *cell, NSUInteger itemIndex) {
        cell.accessoryType = UITableViewCellAccessoryNone;// 移除点击时默认加上右边的checkbox
    };
    dialogViewController.heightForItemBlock = ^CGFloat (QMUIDialogSelectionViewController *aDialogViewController, NSUInteger itemIndex) {
        return 54;// 修改默认的行高，默认为 TableViewCellNormalHeight
    };
    dialogViewController.didSelectItemBlock = ^(QMUIDialogSelectionViewController *aDialogViewController, NSUInteger itemIndex) {
        [aDialogViewController hide];
        //
        NSString *name = [[self.mCategoryDict allKeys] objectAtIndex:itemIndex];
        NSString *cid = [self.mCategoryDict objectForKey:name];
//        DDLogInfo(@"name: %@, cid: %@", name, cid);
        //
        self.mCategoryCid = cid;
        self.mCategoryName = name;
        //
        [self.tableView reloadData];
    };
    [dialogViewController show];
}



@end
