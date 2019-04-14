//
//  BDGroupProfileViewController.m
//  bytedesk-ui
//
//  Created by 萝卜丝 on 2018/12/11.
//  Copyright © 2018 KeFuDaShi. All rights reserved.
//

#import "BDGroupProfileViewController.h"
#import "BDGroupMemberTableViewCell.h"
#import "BDGroupInviteTableViewController.h"
#import "BDQRCodeViewController.h"

#import <bytedesk-core/bdcore.h>

@interface BDGroupProfileViewController ()<QMUITextFieldDelegate, BDGroupMemberTableViewCellDelegate>

@property(nonatomic, strong) NSString *mGid;
@property(nonatomic, strong) NSString *mTid;

@property(nonatomic, strong) NSString *mNickname;
@property(nonatomic, strong) NSString *mDescription;
@property(nonatomic, strong) NSString *mAnnouncement;

@property(nonatomic, strong) NSMutableArray *mMembersArray;
@property(nonatomic, strong) NSMutableArray *mAdminsArray;

@property(nonatomic, assign) BOOL mIsAdmin;
@property(nonatomic, assign) BOOL mIsTopThread;
@property(nonatomic, assign) BOOL mIsNoDisturb;

@property(nonatomic, weak) QMUIDialogTextFieldViewController *currentTextFieldDialogViewController;

@end

@implementation BDGroupProfileViewController

- (void)initWithGroupGid:(NSString *)gid{
    //
    self.mGid = gid;
    self.mNickname = @"未设置";
    self.mDescription = @"未设置";
    self.mAnnouncement = @"未设置";
    self.mMembersArray = [[NSMutableArray alloc] init];
    self.mAdminsArray = [[NSMutableArray alloc] init];
    self.mIsAdmin = FALSE;
    self.mIsTopThread = FALSE;
    self.mIsNoDisturb = FALSE;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"群组详情";
    
    // TODO: 群链接
    // TODO: 群二维码

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    [self fetchGroupDetail];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    } else if (section == 1) {
        return 5;
    } else if (section == 2) {
        return 3;
    } else {
        return 1;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    //
    if (indexPath.section == 0) {
        return ([self.mMembersArray count]/5 + 1) * 60;
    } else {
        return 40;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        static NSString *CellIdentifier = @"MemberCell";
        BDGroupMemberTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if (!cell){
            cell = [[BDGroupMemberTableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
        }
        [cell initWithMembers:self.mMembersArray];
        cell.delegate = self;
        
        return cell;
    }
    else if (indexPath.section == 1) {
        static NSString *CellIdentifier = @"Cell";
        QMUITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if (!cell){
            cell = [[QMUITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
        //
        if (indexPath.row == 0) {
            cell.textLabel.text = @"群名称";
            cell.detailTextLabel.text = self.mNickname;
        } else if (indexPath.row == 1) {
            cell.textLabel.text = @"群简介";
            cell.detailTextLabel.text = self.mDescription;
        } else if (indexPath.row == 2) {
            cell.textLabel.text = @"群公告";
            cell.detailTextLabel.text = self.mAnnouncement;
        } else if (indexPath.row == 3) {
            cell.textLabel.text = @"二维码";
        } else {
            cell.textLabel.text = @"邀请";
            // TODO: 邀请入群
        }
        
        return cell;
    } else if (indexPath.section == 2) {
        
        static NSString *CellIdentifier = @"ClearCell";
        QMUITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if (!cell){
            cell = [[QMUITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        //
        if (indexPath.row == 0) {
            cell.textLabel.text = @"消息免打扰";
            UISwitch* noDisturbSwitch = [[UISwitch alloc] init];
            noDisturbSwitch.tag = 100;
            [noDisturbSwitch addTarget:self action:@selector(switchNoDisturbChanged:) forControlEvents:UIControlEventValueChanged];
            noDisturbSwitch.on = self.mIsNoDisturb;
            cell.accessoryView = noDisturbSwitch;
        }else if (indexPath.row == 1) {
            cell.textLabel.text = @"清空聊天记录";
        } else if (indexPath.row == 2) {
            cell.textLabel.text = @"会话置顶";
            UISwitch* topThreadSwitch = [[UISwitch alloc] init];
            topThreadSwitch.tag = 101;
            [topThreadSwitch addTarget:self action:@selector(switchTopThreadChanged:) forControlEvents:UIControlEventValueChanged];
            topThreadSwitch.on = self.mIsTopThread;
            cell.accessoryView = topThreadSwitch;
        }
        
        return cell;
        
    } else {
        static NSString *CellIdentifier = @"ExitCell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if (!cell){
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
        
        if (!self.mIsAdmin) {
            cell.textLabel.text = @"退出群";
        } else {
            // TODO: 踢人、禁言
            cell.textLabel.text = @"解散群";
        }
        
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 0) {
        
    }
    else if (indexPath.section == 1) {
        //
        if (indexPath.row == 0) {
            //
            if (!self.mIsAdmin) {
                return;
            }
            //
            QMUIDialogTextFieldViewController *dialogViewController = [[QMUIDialogTextFieldViewController alloc] init];
            dialogViewController.title = @"群昵称";
            [dialogViewController addTextFieldWithTitle:@"昵称" configurationHandler:^(QMUILabel *titleLabel, QMUITextField *textField, CALayer *separatorLayer) {
//                textField.placeholder = @"不超过10个字符";
//                textField.maximumTextLength = 10;
            }];
            [dialogViewController addCancelButtonWithText:@"取消" block:nil];
            [dialogViewController addSubmitButtonWithText:@"确定" block:^(QMUIDialogViewController *aDialogViewController) {
                [aDialogViewController hide];
                // 调用接口设置群昵称
                [self saveGroupinfo];
            }];
            [dialogViewController show];
            self.currentTextFieldDialogViewController = dialogViewController;
        } else if (indexPath.row == 1) {
            //
            if (!self.mIsAdmin) {
                return;
            }
            //
            QMUIDialogTextFieldViewController *dialogViewController = [[QMUIDialogTextFieldViewController alloc] init];
            dialogViewController.title = @"群简介";
            [dialogViewController addTextFieldWithTitle:@"简介" configurationHandler:^(QMUILabel *titleLabel, QMUITextField *textField, CALayer *separatorLayer) {
//                textField.placeholder = @"不超过10个字符";
//                textField.maximumTextLength = 10;
            }];
            [dialogViewController addCancelButtonWithText:@"取消" block:nil];
            [dialogViewController addSubmitButtonWithText:@"确定" block:^(QMUIDialogViewController *aDialogViewController) {
                [aDialogViewController hide];
                // 调用接口设置群简介
                [self saveGroupinfo];
            }];
            [dialogViewController show];
            self.currentTextFieldDialogViewController = dialogViewController;
        } else if (indexPath.row == 2) {
            //
            if (!self.mIsAdmin) {
                return;
            }
            //
            QMUIDialogTextFieldViewController *dialogViewController = [[QMUIDialogTextFieldViewController alloc] init];
            dialogViewController.title = @"群公告";
            [dialogViewController addTextFieldWithTitle:@"公告" configurationHandler:^(QMUILabel *titleLabel, QMUITextField *textField, CALayer *separatorLayer) {
//                textField.placeholder = @"不超过10个字符";
//                textField.maximumTextLength = 10;
            }];
            [dialogViewController addCancelButtonWithText:@"取消" block:nil];
            [dialogViewController addSubmitButtonWithText:@"确定" block:^(QMUIDialogViewController *aDialogViewController) {
                [aDialogViewController hide];
                // 调用接口设置群公告
                [self saveGroupinfo];
            }];
            [dialogViewController show];
            self.currentTextFieldDialogViewController = dialogViewController;
        } else if (indexPath.row == 3) {
            // TODO: 生成群二维码
            DDLogInfo(@"生成群二维码");
            BDQRCodeViewController *qrcodeViewController = [[BDQRCodeViewController alloc] initWithStyle:UITableViewStyleGrouped];
            [qrcodeViewController initWithGid:self.mGid];
            [self.navigationController pushViewController:qrcodeViewController animated:YES];
        } else {
            // TODO: 邀请新成员
            
        }
    } else if (indexPath.section == 2) {
        
        if (indexPath.row == 0) {
            
            DDLogInfo(@"消息免打扰");
            
            // FIXME: 点击tablecell显示两个滑动按钮？
//            UITableViewCell* cell = [tableView cellForRowAtIndexPath:indexPath];
//            UISwitch* switcher = (UISwitch*)[cell.contentView viewWithTag:100];
//            [switcher setOn:!switcher.on animated:YES];
//            [self switchNoDisturbChanged:switcher];
        
        }else if (indexPath.row == 1) {
            
            DDLogInfo(@"清空聊天记录");
        
            [BDCoreApis markClearGroupMessage:self.mGid resultSuccess:^(NSDictionary *dict) {
                //
                NSNumber *status_code = [dict objectForKey:@"status_code"];
                if ([status_code isEqualToNumber:[NSNumber numberWithInt:200]]) {
                    // 成功
                    
                  
                    [QMUITips showSucceed:@"成功清空聊天记录" inView:self.view hideAfterDelay:.8];
                } else {
                    //
                    NSString *message = dict[@"message"];
                    DDLogWarn(@"%s %@", __PRETTY_FUNCTION__, message);
                    [QMUITips showError:message inView:self.view hideAfterDelay:2];
                }
                
                // delegate
                if (self.delegate && [self.delegate respondsToSelector:@selector(clearMessages)]) {
                    [self.delegate clearMessages];
                }
                
            } resultFailed:^(NSError *error) {
                // delegate
                if (self.delegate && [self.delegate respondsToSelector:@selector(clearMessages)]) {
                    [self.delegate clearMessages];
                }
                //
                [QMUITips showError:@"清空聊天记录失败" inView:self.view hideAfterDelay:.8];
            }];
            
            
        } else if (indexPath.row == 2) {
            
            DDLogInfo(@"会话置顶");
            
            // FIXME: 点击tablecell显示两个滑动按钮？
//            UITableViewCell* cell = [tableView cellForRowAtIndexPath:indexPath];
//            UISwitch* switcher = (UISwitch*)[cell.contentView viewWithTag:101];
//            [switcher setOn:!switcher.on animated:YES];
//            [self switchTopThreadChanged:switcher];
            
        }
        
    } else {
        //
        if (!self.mIsAdmin) {
            // 退出群
            QMUIAlertAction *cancelAction = [QMUIAlertAction actionWithTitle:@"取消" style:QMUIAlertActionStyleCancel handler:^(QMUIAlertController *aAlertController, QMUIAlertAction *action) {
                //
            }];
            QMUIAlertAction *closeAction = [QMUIAlertAction actionWithTitle:@"退出" style:QMUIAlertActionStyleDestructive handler:^(QMUIAlertController *aAlertController, QMUIAlertAction *action) {
                //
                // TODO: 调用服务器接口, 并删除本地群组、删除会话thread
                [BDCoreApis withdrawGroup:self.mGid resultSuccess:^(NSDictionary *dict) {
                    
                } resultFailed:^(NSError *error) {
                    DDLogError(@"%s, %@", __PRETTY_FUNCTION__, error);
                    if (error) {
                        [QMUITips showError:error.localizedDescription inView:self.view hideAfterDelay:3];
                    }
                }];
                
            }];
            QMUIAlertController *alertController = [QMUIAlertController alertControllerWithTitle:@"确定要退出群？" message:@"" preferredStyle:QMUIAlertControllerStyleAlert];
            [alertController addAction:cancelAction];
            [alertController addAction:closeAction];
            [alertController showWithAnimated:YES];
        } else {
            // 解散群
            QMUIAlertAction *cancelAction = [QMUIAlertAction actionWithTitle:@"取消" style:QMUIAlertActionStyleCancel handler:^(QMUIAlertController *aAlertController, QMUIAlertAction *action) {
                //
            }];
            QMUIAlertAction *closeAction = [QMUIAlertAction actionWithTitle:@"解散" style:QMUIAlertActionStyleDestructive handler:^(QMUIAlertController *aAlertController, QMUIAlertAction *action) {
                //
                // TODO: 调用服务器接口, 并删除本地群组、删除会话thread
                [BDCoreApis dismissGroup:self.mGid resultSuccess:^(NSDictionary *dict) {
                    
                } resultFailed:^(NSError *error) {
                    DDLogError(@"%s, %@", __PRETTY_FUNCTION__, error);
                    if (error) {
                        [QMUITips showError:error.localizedDescription inView:self.view hideAfterDelay:3];
                    }
                }];
            }];
            QMUIAlertController *alertController = [QMUIAlertController alertControllerWithTitle:@"确定要解散群？" message:@"" preferredStyle:QMUIAlertControllerStyleAlert];
            [alertController addAction:cancelAction];
            [alertController addAction:closeAction];
            [alertController showWithAnimated:YES];
        }
        
    }
}

#pragma mark - <QMUITextFieldDelegate>

- (BOOL)textFieldShouldReturn:(QMUITextField *)textField {
    //
    if (self.currentTextFieldDialogViewController.submitButton.enabled) {
        [self.currentTextFieldDialogViewController hide];
        
    } else {
        // [QMUITips showSucceed:@"请输入文字" inView:self.currentTextFieldDialogViewController.modalPresentedViewController.view hideAfterDelay:2.0];
    }
    return NO;
}

#pragma mark -

- (void) saveGroupinfo {
    //
    DDLogInfo(@"%s", __PRETTY_FUNCTION__);
    if ([self.currentTextFieldDialogViewController.title isEqualToString:@"群昵称"]) {
        // 设置昵称
        self.mNickname = self.currentTextFieldDialogViewController.textFields[0].text;
        //
        [BDCoreApis updateGroupNickname:self.mNickname withGroupGid:self.mGid resultSuccess:^(NSDictionary *dict) {
            // TODO: 更新本地群组信息、更新本地会话信息
            
            [self.tableView reloadData];
        } resultFailed:^(NSError *error) {
            DDLogError(@"%s, %@", __PRETTY_FUNCTION__, error);
            if (error) {
                [QMUITips showError:error.localizedDescription inView:self.view hideAfterDelay:3];
            }
        }];
    } else if ([self.currentTextFieldDialogViewController.title isEqualToString:@"群简介"]) {
        // 设置群简介
        self.mDescription = self.currentTextFieldDialogViewController.textFields[0].text;
        //
        [BDCoreApis updateGroupDescription:self.mDescription withGroupGid:self.mGid resultSuccess:^(NSDictionary *dict) {
            [self.tableView reloadData];
        } resultFailed:^(NSError *error) {
            DDLogError(@"%s, %@", __PRETTY_FUNCTION__, error);
            if (error) {
                [QMUITips showError:error.localizedDescription inView:self.view hideAfterDelay:3];
            }
        }];
    } else {
        // 设置群公告
        self.mAnnouncement = self.currentTextFieldDialogViewController.textFields[0].text;
        //
        [BDCoreApis updateGroupAnnouncement:self.mAnnouncement withGroupGid:self.mGid resultSuccess:^(NSDictionary *dict) {
            [self.tableView reloadData];
        } resultFailed:^(NSError *error) {
            DDLogError(@"%s, %@", __PRETTY_FUNCTION__, error);
            if (error) {
                [QMUITips showError:error.localizedDescription inView:self.view hideAfterDelay:3];
            }
        }];
    }
}

- (void)fetchGroupDetail {
    
    [BDCoreApis getGroupDetail:self.mGid resultSuccess:^(NSDictionary *dict) {
        
        NSNumber *status_code = [dict objectForKey:@"status_code"];
//        DDLogWarn(@"dict:%@", dict);
        if ([status_code isEqualToNumber:[NSNumber numberWithInt:200]]) {
            //
            self.mTid = dict[@"data"][@"threadTid"];
            self.mIsTopThread = [dict[@"data"][@"isTopThread"] boolValue];
            self.mIsNoDisturb = [dict[@"data"][@"isNoDisturb"] boolValue];
            
            // 成功
            self.mNickname = dict[@"data"][@"group"][@"nickname"];
            self.mDescription = dict[@"data"][@"group"][@"description"];
            self.mAnnouncement = dict[@"data"][@"group"][@"announcement"];
            //
            NSMutableArray *membersArray = dict[@"data"][@"group"][@"members"];
            for (NSDictionary *memberDict in membersArray) {
                BDContactModel *memberModel = [[BDContactModel alloc] initWithDictionary:memberDict];
                [self.mMembersArray addObject:memberModel];
            }
            //
            NSMutableArray *adminsArray = dict[@"data"][@"group"][@"admins"];
            for (NSDictionary *adminDict in adminsArray) {
                NSString *uid = adminDict[@"uid"];
                if ([uid isEqualToString:[BDSettings getUid]]) {
                    self.mIsAdmin = TRUE;
                }
                BDContactModel *adminModel = [[BDContactModel alloc] initWithDictionary:adminDict];
                [self.mAdminsArray addObject:adminModel];
            }
        } else {
            //
            NSString *message = dict[@"message"];
            [QMUITips showError:message inView:self.view hideAfterDelay:2];
        }
        //
        [self.tableView reloadData];
    } resultFailed:^(NSError *error) {
        DDLogError(@"%s, %@", __PRETTY_FUNCTION__, error);
        if (error) {
            [QMUITips showError:error.localizedDescription inView:self.view hideAfterDelay:3];
        }
    }];
}

#pragma mark - BDGroupMemberTableViewCellDelegate

- (void)avatarClicked:(BDContactModel *)contactModel {
    
    DDLogInfo(@"%s nickname: %@", __PRETTY_FUNCTION__,  contactModel.nickname);
    
    // 非管理员 或者 点击自己群头像，直接返回
    if (!self.mIsAdmin || [contactModel.uid isEqualToString:[BDSettings getUid]]) {
        return;
    }
    
    QMUIDialogSelectionViewController *dialogViewController = [[QMUIDialogSelectionViewController alloc] init];
    dialogViewController.title = @"请选择操作";
    dialogViewController.items = @[@"转交群", @"踢出群"];
    [dialogViewController addCancelButtonWithText:@"取消" block:nil];
    dialogViewController.cellForItemBlock = ^(QMUIDialogSelectionViewController *aDialogViewController, QMUITableViewCell *cell, NSUInteger itemIndex) {
        cell.accessoryType = UITableViewCellAccessoryNone;// 移除点击时默认加上右边的checkbox
    };
    dialogViewController.heightForItemBlock = ^CGFloat (QMUIDialogSelectionViewController *aDialogViewController, NSUInteger itemIndex) {
        return 54;
    };
    dialogViewController.didSelectItemBlock = ^(QMUIDialogSelectionViewController *aDialogViewController, NSUInteger itemIndex) {
        DDLogInfo(@"%s %@ %lu", __PRETTY_FUNCTION__, contactModel.real_name, (unsigned long)itemIndex);
        
        if (itemIndex == 0) {
            DDLogInfo(@"转交群");
            
            [BDCoreApis transferGroup:contactModel.uid withGroupGid:self.mGid withNeedApprove:FALSE resultSuccess:^(NSDictionary *dict) {
                
                NSNumber *status_code = [dict objectForKey:@"status_code"];
                if ([status_code isEqualToNumber:[NSNumber numberWithInt:200]]) {
                    
                    // TODO: UI提示
                    
                } else {
                    
                    NSString *message = dict[@"message"];
                    DDLogError(@"%s %@", __PRETTY_FUNCTION__, message);
                    [QMUITips showError:message inView:self.view hideAfterDelay:2];
                }
                
            } resultFailed:^(NSError *error) {
                DDLogError(@"%s %@", __PRETTY_FUNCTION__, error);
                if (error) {
                    [QMUITips showError:error.localizedDescription inView:self.view hideAfterDelay:3];
                }
            }];
            
            
        } else {
            DDLogInfo(@"踢出群");
            
            [BDCoreApis kickGroupMember:contactModel.uid withGroupGid:self.mGid resultSuccess:^(NSDictionary *dict) {
                
                NSNumber *status_code = [dict objectForKey:@"status_code"];
                if ([status_code isEqualToNumber:[NSNumber numberWithInt:200]]) {
                    
                    // TODO: UI提示
                    
                } else {
                    
                    NSString *message = dict[@"message"];
                    DDLogError(@"%s %@", __PRETTY_FUNCTION__, message);
                    [QMUITips showError:message inView:self.view hideAfterDelay:2];
                }
                
            } resultFailed:^(NSError *error) {
                DDLogError(@"%s %@", __PRETTY_FUNCTION__, error);
                if (error) {
                    [QMUITips showError:error.localizedDescription inView:self.view hideAfterDelay:3];
                }
            }];
        }
        
        [aDialogViewController hide];
    };
    [dialogViewController show];
}

- (void)inviteClicked {
    
    DDLogInfo(@"inviteClicked");
}



-(void) switchNoDisturbChanged:(id)sender {
    UISwitch* switcher = (UISwitch*)sender;
    BOOL value = switcher.on;
    // Store the value and/or respond appropriately
    
    if (value) {
        
        // 设置免打扰
        [BDCoreApis markNoDisturbThread:self.mTid resultSuccess:^(NSDictionary *dict) {
            
        } resultFailed:^(NSError *error) {
            if (error) {
                [QMUITips showError:error.localizedDescription inView:self.view hideAfterDelay:3];
            }
        }];
        
    } else {
        
        // 取消免打扰
        [BDCoreApis unmarkNoDisturbThread:self.mTid resultSuccess:^(NSDictionary *dict) {
            
        } resultFailed:^(NSError *error) {
            if (error) {
                [QMUITips showError:error.localizedDescription inView:self.view hideAfterDelay:3];
            }
        }];
        
    }
}

-(void) switchTopThreadChanged:(id)sender {
    UISwitch* switcher = (UISwitch*)sender;
    BOOL value = switcher.on;
    // Store the value and/or respond appropriately
    
    if (value) {

        // 设置会话置顶
        [BDCoreApis markTopThread:self.mTid resultSuccess:^(NSDictionary *dict) {
            
        } resultFailed:^(NSError *error) {
            if (error) {
                [QMUITips showError:error.localizedDescription inView:self.view hideAfterDelay:3];
            }
        }];
        
    } else {
        
        // 取消会话置顶
        [BDCoreApis unmarkTopThread:self.mTid resultSuccess:^(NSDictionary *dict) {
            
        } resultFailed:^(NSError *error) {
            if (error) {
                [QMUITips showError:error.localizedDescription inView:self.view hideAfterDelay:3];
            }
        }];
    }
    
}


@end
