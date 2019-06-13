//
//  KFSettingsViewController.m
//  linphone
//
//  Created by bytedesk.com on 2017/10/12.
//

#import "KFProfileViewController.h"
#import "QDNavigationController.h"
#import "KFQRCodeViewController.h"
#import "QDSingleImagePickerPreviewViewController.h"

#import <AFNetworking/UIImageView+AFNetworking.h>

#import <bytedesk-core/bdcore.h>

static QMUIAlbumContentType const kAlbumContentType = QMUIAlbumContentTypeOnlyPhoto;

@interface KFProfileViewController ()<QMUIAlbumViewControllerDelegate,QMUIImagePickerViewControllerDelegate,QDSingleImagePickerPreviewViewControllerDelegate>

@property(nonatomic, strong) UIRefreshControl *mRefreshControl;

@end

@implementation KFProfileViewController

- (instancetype)init {
    self = [super init];
    if (self) {
        //    self.view.qmui_shouldShowDebugColor = true;
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notifyProfileUpdate:) name:BD_NOTIFICATION_PROFILE_UPDATE object:nil];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"设置";
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem qmui_itemWithImage:UIImageMake(@"icon_nav_about") target:self action:@selector(handleAboutItemEvent)];

    // 防止tableview的最后一行被切断
    // http://stackoverflow.com/questions/7678910/uitableviewcontroller-last-row-cut-off
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 45, 0);
    //
    self.mRefreshControl = [[UIRefreshControl alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
    [self.tableView addSubview:self.mRefreshControl];
    [self.mRefreshControl addTarget:self action:@selector(refreshControlSelector) forControlEvents:UIControlEventValueChanged];
    //
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    } else if (section == 1) {
        return 3;
    }
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *identifier = @"cell";
    QMUITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[QMUITableViewCell alloc] initForTableView:self.tableView withStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier];
    }
    if (indexPath.section == 0) {
        [cell.imageView setImageWithURL:[NSURL URLWithString:[BDSettings getAvatar]] placeholderImage:[UIImage imageNamed:@"admin_default_avatar" inBundle:[NSBundle bundleForClass:self.class] compatibleWithTraitCollection:nil]];
        cell.textLabel.text = [BDSettings getNickname];
        cell.detailTextLabel.text = [BDSettings getDescription];
//        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    } else if (indexPath.section == 1) {
//        cell.imageView.image = [UIImage qmui_imageWithShape:QMUIImageShapeOval size:CGSizeMake(16, 16) lineWidth:2 tintColor:[QDCommonUI randomThemeColor]];
        if (indexPath.row == 0) {
            cell.textLabel.text = @"自动回复";
            cell.detailTextLabel.text = [BDSettings getAutoReplyContent];
        } else if (indexPath.row == 1) {
            cell.textLabel.text = @"接待状态";
            cell.detailTextLabel.text = [BDSettings getStatus];
        } else if (indexPath.row == 2) {
            cell.textLabel.text = @"二维码";
        }
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    [cell updateCellAppearanceWithIndexPath:indexPath];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return TableViewCellNormalHeight + 20;
    }
    return TableViewCellNormalHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
//    [self.tableView qmui_clearsSelection];
    //    UIViewController *viewController = nil;
    if (indexPath.section == 0) {
        //
    //        viewController = [[KFProfileViewController alloc] init];
    //        [self.navigationController pushViewController:viewController animated:YES];
        
        [self authorizationPresentAlbumViewController];
        
    } else if (indexPath.section == 1) {
        //
        if (indexPath.row == 0) {
            
            QMUIAlertAction *cancelAction = [QMUIAlertAction actionWithTitle:@"取消" style:QMUIAlertActionStyleCancel handler:^(QMUIAlertController *aAlertController, QMUIAlertAction *action) {
            }];
            //            QMUIAlertAction *customAction = [QMUIAlertAction actionWithTitle:@"自定义" style:QMUIAlertActionStyleDefault handler:^(QMUIAlertController *aAlertController, QMUIAlertAction *action) {
            //            }];
            QMUIAlertAction *phoneAction = [QMUIAlertAction actionWithTitle:@"接听电话中" style:QMUIAlertActionStyleDefault handler:^(QMUIAlertController *aAlertController, QMUIAlertAction *action) {
                
                // 调用服务器接口
                [BDCoreApis updateAutoReply:TRUE withContent:@"接听电话中" resultSuccess:^(NSDictionary *dict) {
                    [BDSettings setAutoReplyContent:@"接听电话中"];
                } resultFailed:^(NSError *error) {
                    DDLogError(@"%s %@", __PRETTY_FUNCTION__, error);
                    if (error) {
                        [QMUITips showError:error.localizedDescription inView:self.view hideAfterDelay:3];
                    }
                }];
                [self.tableView reloadData];
            }];
            QMUIAlertAction *backAction = [QMUIAlertAction actionWithTitle:@"马上回来" style:QMUIAlertActionStyleDefault handler:^(QMUIAlertController *aAlertController, QMUIAlertAction *action) {
                
                // 调用服务器接口
                [BDCoreApis updateAutoReply:TRUE withContent:@"马上回来" resultSuccess:^(NSDictionary *dict) {
                    [BDSettings setAutoReplyContent:@"马上回来"];
                } resultFailed:^(NSError *error) {
                    DDLogError(@"%s %@", __PRETTY_FUNCTION__, error);
                    if (error) {
                        [QMUITips showError:error.localizedDescription inView:self.view hideAfterDelay:3];
                    }
                }];
                [self.tableView reloadData];
            }];
            QMUIAlertAction *leaveAction = [QMUIAlertAction actionWithTitle:@"不在电脑旁，请稍后" style:QMUIAlertActionStyleDefault handler:^(QMUIAlertController *aAlertController, QMUIAlertAction *action) {
                
                // 调用服务器接口
                [BDCoreApis updateAutoReply:TRUE withContent:@"不在电脑旁，请稍后" resultSuccess:^(NSDictionary *dict) {
                    [BDSettings setAutoReplyContent:@"不在电脑旁，请稍后"];
                } resultFailed:^(NSError *error) {
                    DDLogError(@"%s %@", __PRETTY_FUNCTION__, error);
                    if (error) {
                        [QMUITips showError:error.localizedDescription inView:self.view hideAfterDelay:3];
                    }
                }];
                [self.tableView reloadData];
            }];
            QMUIAlertAction *eatAction = [QMUIAlertAction actionWithTitle:@"外出就餐，请稍后" style:QMUIAlertActionStyleDefault handler:^(QMUIAlertController *aAlertController, QMUIAlertAction *action) {
                
                // 调用服务器接口
                [BDCoreApis updateAutoReply:TRUE withContent:@"外出就餐，请稍后" resultSuccess:^(NSDictionary *dict) {
                    [BDSettings setAutoReplyContent:@"外出就餐，请稍后"];
                } resultFailed:^(NSError *error) {
                    DDLogError(@"%s %@", __PRETTY_FUNCTION__, error);
                    if (error) {
                        [QMUITips showError:error.localizedDescription inView:self.view hideAfterDelay:3];
                    }
                }];
                [self.tableView reloadData];
            }];
            QMUIAlertAction *noAction = [QMUIAlertAction actionWithTitle:@"无自动回复" style:QMUIAlertActionStyleDefault handler:^(QMUIAlertController *aAlertController, QMUIAlertAction *action) {
                
                // 调用服务器接口
                [BDCoreApis updateAutoReply:FALSE withContent:@"无自动回复" resultSuccess:^(NSDictionary *dict) {
                    [BDSettings setAutoReplyContent:@"无自动回复"];
                } resultFailed:^(NSError *error) {
                    DDLogError(@"%s %@", __PRETTY_FUNCTION__, error);
                    if (error) {
                        [QMUITips showError:error.localizedDescription inView:self.view hideAfterDelay:3];
                    }
                }];
                [self.tableView reloadData];
            }];
            QMUIAlertController *alertController = [QMUIAlertController alertControllerWithTitle:@"设置自动回复" message:@"" preferredStyle:QMUIAlertControllerStyleActionSheet];
            [alertController addAction:cancelAction];
            [alertController addAction:noAction];
            [alertController addAction:eatAction];
            [alertController addAction:leaveAction];
            [alertController addAction:backAction];
            [alertController addAction:phoneAction];
            //            [alertController addAction:customAction];
            
            [alertController showWithAnimated:YES];
            
        } else if (indexPath.row == 1) {
            
            QMUIAlertAction *cancelAction = [QMUIAlertAction actionWithTitle:@"取消" style:QMUIAlertActionStyleCancel handler:^(QMUIAlertController *aAlertController, QMUIAlertAction *action) {
            }];
            QMUIAlertAction *restAction = [QMUIAlertAction actionWithTitle:@"小休" style:QMUIAlertActionStyleDefault handler:^(QMUIAlertController *aAlertController, QMUIAlertAction *action) {
                
                // TODO: 调用服务器接口
                [BDCoreApis setAcceptStatus:BD_USER_STATUS_REST resultSuccess:^(NSDictionary *dict) {
                    [BDSettings setAcceptStatus:@"小休"];
                } resultFailed:^(NSError *error) {
                    DDLogError(@"%s %@", __PRETTY_FUNCTION__, error);
                    if (error) {
                        [QMUITips showError:error.localizedDescription inView:self.view hideAfterDelay:3];
                    }
                }];
                [self.tableView reloadData];
            }];
            QMUIAlertAction *busyAction = [QMUIAlertAction actionWithTitle:@"忙线" style:QMUIAlertActionStyleDefault handler:^(QMUIAlertController *aAlertController, QMUIAlertAction *action) {
                
                // TODO: 调用服务器接口
                [BDCoreApis setAcceptStatus:BD_USER_STATUS_BUSY resultSuccess:^(NSDictionary *dict) {
                    [BDSettings setAcceptStatus:@"忙线"];
                } resultFailed:^(NSError *error) {
                    DDLogError(@"%s %@", __PRETTY_FUNCTION__, error);
                    if (error) {
                        [QMUITips showError:error.localizedDescription inView:self.view hideAfterDelay:3];
                    }
                }];
                [self.tableView reloadData];
            }];
            QMUIAlertAction *onlineAction = [QMUIAlertAction actionWithTitle:@"在线" style:QMUIAlertActionStyleDefault handler:^(QMUIAlertController *aAlertController, QMUIAlertAction *action) {
                
                // 调用服务器接口
                [BDCoreApis setAcceptStatus:BD_USER_STATUS_ONLINE resultSuccess:^(NSDictionary *dict) {
                    [BDSettings setAcceptStatus:@"在线"];
                } resultFailed:^(NSError *error) {
                    DDLogError(@"%s %@", __PRETTY_FUNCTION__, error);
                    if (error) {
                        [QMUITips showError:error.localizedDescription inView:self.view hideAfterDelay:3];
                    }
                }];
                [self.tableView reloadData];
            }];
            QMUIAlertController *alertController = [QMUIAlertController alertControllerWithTitle:@"设置在线状态" message:@"" preferredStyle:QMUIAlertControllerStyleActionSheet];
            [alertController addAction:cancelAction];
            [alertController addAction:onlineAction];
            [alertController addAction:busyAction];
            [alertController addAction:restAction];
            [alertController showWithAnimated:YES];
        } else if (indexPath.row == 2) {
            // TODO: 二维码
            KFQRCodeViewController *qrcodeViewController = [[KFQRCodeViewController alloc] initWithStyle:UITableViewStyleGrouped];
            [qrcodeViewController initWithUid:[BDSettings getUid]];
            [self.navigationController pushViewController:qrcodeViewController animated:YES];
        }
    }
}

#pragma mark kIASKAppSettingChanged notification

- (void)settingDidChange:(NSNotification*)notification {
    //    DDLogInfo(@"%s, %@", __PRETTY_FUNCTION__, notification.userInfo.allKeys.firstObject);
    if ([notification.userInfo.allKeys.firstObject isEqual:@"video_enabled_preference"]) {
//        KFIASKAppSettingsViewController *activeController = notification.object;
//        BOOL enabled = (BOOL)[[notification.userInfo objectForKey:@"video_enabled_preference"] intValue];
//        [activeController setHiddenKeys:enabled ? nil : [NSSet setWithObjects:@"Video", nil] animated:YES];
    }
}

#pragma mark - IASKAppSettingsViewController Delegate

//- (void)settingsViewController:(IASKAppSettingsViewController*)sender buttonTappedForSpecifier:(IASKSpecifier*)specifier {
//    if ([specifier.key isEqualToString:@"ButtonDemoAction1"]) {
//        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Demo Action 1 called" message:nil preferredStyle:UIAlertControllerStyleAlert];
//        [alert addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"OK", @"InAppSettingsKit") style:UIAlertActionStyleCancel handler:^(UIAlertAction * action) {}]];
//        [sender presentViewController:alert animated:YES completion:nil];
//    } else if ([specifier.key isEqualToString:@"ButtonDemoAction2"]) {
//        NSString *newTitle = [[[NSUserDefaults standardUserDefaults] objectForKey:specifier.key] isEqualToString:@"Logout"] ? @"Login" : @"Logout";
//        [[NSUserDefaults standardUserDefaults] setObject:newTitle forKey:specifier.key];
//    }
//}

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
    albumViewController.title = @"选择头像";
    QDNavigationController *navigationController = [[QDNavigationController alloc] initWithRootViewController:albumViewController];
    
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
    QDSingleImagePickerPreviewViewController *imagePickerPreviewViewController = [[QDSingleImagePickerPreviewViewController alloc] init];
    imagePickerPreviewViewController.delegate = self;
    imagePickerPreviewViewController.assetsGroup = imagePickerViewController.assetsGroup;
    imagePickerPreviewViewController.view.tag = imagePickerViewController.view.tag;

    return imagePickerPreviewViewController;
}

#pragma mark - <QDSingleImagePickerPreviewViewControllerDelegate>

- (void)imagePickerPreviewViewController:(QDSingleImagePickerPreviewViewController *)imagePickerPreviewViewController didSelectImageWithImagesAsset:(QMUIAsset *)imageAsset {
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
    //    NSString *imageName = [NSString stringWithFormat:@"%@_%@.png", [BDSettings getUsername], [BDUtils getCurrentTimeString]];
    //
    [BDCoreApis uploadAvatarData:imageData resultSuccess:^(NSDictionary *dict) {
        //
        NSNumber *status_code = [dict objectForKey:@"status_code"];
        if ([status_code isEqualToNumber:[NSNumber numberWithInt:200]]) {
            
            NSString *avatarUrl = dict[@"data"];
            [BDSettings setAvatar:avatarUrl];
            
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
            [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            
            // 注意：新头像需要与旧头像url保持一致，如此可以保证用户更新头像之后，其所有好友实时更新头像
            // 调用更新个人资料接口
            [BDCoreApis setAvatar:avatarUrl resultSuccess:^(NSDictionary *dict) {
                // 设置成功
                
            } resultFailed:^(NSError *error) {
                [QMUITips showError:@"设置头像错误" inView:self.view hideAfterDelay:2];
            }];
            
        } else {
            [QMUITips showError:@"上传头像错误" inView:self.view hideAfterDelay:2];
        }
        
    } resultFailed:^(NSError *error) {
        
    }];
}

#pragma mark - Selectors

- (void)refreshControlSelector {
    DDLogInfo(@"%s", __PRETTY_FUNCTION__);
    
    //
    [self.mRefreshControl endRefreshing];
}

- (void)handleAboutItemEvent {
    
}

#pragma mark - Notification

- (void)notifyProfileUpdate:(id)sender {
    DDLogInfo(@"%s, profile update", __PRETTY_FUNCTION__);
    
    [self.tableView reloadData];
}

@end
