//
//  BDGroupProfileViewController.m
//  bytedesk-ui
//
//  Created by 萝卜丝 on 2018/12/11.
//  Copyright © 2018 KeFuDaShi. All rights reserved.
//

#import "BDGroupProfileViewController.h"
#import "BDGroupMemberTableViewCell.h"

#import <bytedesk-core/bdcore.h>

@interface BDGroupProfileViewController ()<QMUITextFieldDelegate>

@property(nonatomic, strong) NSString *mGid;

@property(nonatomic, strong) NSString *mNickname;
@property(nonatomic, strong) NSString *mDescription;
@property(nonatomic, strong) NSString *mAnnouncement;

@property(nonatomic, strong) NSMutableArray *mMembersArray;
@property(nonatomic, strong) NSMutableArray *mAdminsArray;

@property(nonatomic, assign) BOOL mIsAdmin;

@property(nonatomic, weak) QMUIDialogTextFieldViewController *currentTextFieldDialogViewController;

@end

@implementation BDGroupProfileViewController

- (void)initWithGroupGid:(NSString *)gid {
    //
    self.mGid = gid;
    self.mNickname = @"未设置";
    self.mDescription = @"未设置";
    self.mAnnouncement = @"未设置";
    self.mMembersArray = [[NSMutableArray alloc] init];
    self.mAdminsArray = [[NSMutableArray alloc] init];
    self.mIsAdmin = FALSE;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"群组详情";

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    [self fetchGroupDetail];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    } else if (section == 1) {
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
    
        // Configure the cell...
        if (!cell){
            cell = [[BDGroupMemberTableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
        }
        
        [cell initWithMembers:self.mMembersArray];
        
        return cell;
    }
    else if (indexPath.section == 1) {
        static NSString *CellIdentifier = @"Cell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        // Configure the cell...
        if (!cell){
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
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
        } else {
            cell.textLabel.text = @"群成员";
            // TODO: 邀请入群、踢人、禁言
        }
        
        return cell;
    } else {
        static NSString *CellIdentifier = @"ExitCell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        // Configure the cell...
        if (!cell){
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
        
        if (!self.mIsAdmin) {
            cell.textLabel.text = @"退出群";
        } else {
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
        if (!self.mIsAdmin) {
            return;
        }
        //
        if (indexPath.row == 0) {
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
        } else {
            // 群成员
            [BDCoreApis getGroupMembers:self.mGid resultSuccess:^(NSDictionary *dict) {
                
            } resultFailed:^(NSError *error) {
                
            }];
        }
    } else {
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
        }];
    } else if ([self.currentTextFieldDialogViewController.title isEqualToString:@"群简介"]) {
        // 设置群简介
        self.mDescription = self.currentTextFieldDialogViewController.textFields[0].text;
        //
        [BDCoreApis updateGroupDescription:self.mDescription withGroupGid:self.mGid resultSuccess:^(NSDictionary *dict) {
            [self.tableView reloadData];
        } resultFailed:^(NSError *error) {
            DDLogError(@"%s, %@", __PRETTY_FUNCTION__, error);
        }];
    } else {
        // 设置群公告
        self.mAnnouncement = self.currentTextFieldDialogViewController.textFields[0].text;
        //
        [BDCoreApis updateGroupAnnouncement:self.mAnnouncement withGroupGid:self.mGid resultSuccess:^(NSDictionary *dict) {
            [self.tableView reloadData];
        } resultFailed:^(NSError *error) {
            DDLogError(@"%s, %@", __PRETTY_FUNCTION__, error);
        }];
    }
}

- (void)fetchGroupDetail {
    
    [BDCoreApis getGroupDetail:self.mGid resultSuccess:^(NSDictionary *dict) {
        
        self.mNickname = dict[@"data"][@"nickname"];
        self.mDescription = dict[@"data"][@"description"];
        self.mAnnouncement = dict[@"data"][@"announcement"];
        //
        NSMutableArray *membersArray = dict[@"data"][@"members"];
        for (NSDictionary *memberDict in membersArray) {
            BDContactModel *memberModel = [[BDContactModel alloc] initWithDictionary:memberDict];
            [self.mMembersArray addObject:memberModel];
        }
        //
        NSMutableArray *adminsArray = dict[@"data"][@"admins"];
        for (NSDictionary *adminDict in adminsArray) {
            NSString *uid = adminDict[@"uid"];
            if ([uid isEqualToString:[BDSettings getUid]]) {
                self.mIsAdmin = TRUE;
            }
            BDContactModel *adminModel = [[BDContactModel alloc] initWithDictionary:adminDict];
            [self.mAdminsArray addObject:adminModel];
        }
        //
        [self.tableView reloadData];
    } resultFailed:^(NSError *error) {
        DDLogError(@"%s, %@", __PRETTY_FUNCTION__, error);
    }];
}



@end
