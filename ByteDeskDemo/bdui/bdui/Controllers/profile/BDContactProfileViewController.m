//
//  BDContactProfileViewController.m
//  bytedesk-ui
//
//  Created by 萝卜丝 on 2019/1/14.
//  Copyright © 2019 KeFuDaShi. All rights reserved.
//

#import "BDContactProfileViewController.h"

#import <bytedesk-core/bdcore.h>

@interface BDContactProfileViewController ()

@property(nonatomic, strong) NSString *mUid;
@property(nonatomic, strong) NSString *mTid;

@property(nonatomic, strong) NSString *mNickname;

@property(nonatomic, assign) BOOL mIsTopThread;
@property(nonatomic, assign) BOOL mIsNoDisturb;
@property(nonatomic, assign) BOOL mIsShield;

@end

@implementation BDContactProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"用户信息";
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    [self fetchContactDetail];
}

#pragma mark -

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 3;
    } else {
        // 清空聊天记录
        return 1;
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *cellIndentifier = @"reuseIdentifier";
    QMUITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIndentifier];
    
    // Configure the cell...
    if (cell == nil) {
        cell = [[QMUITableViewCell alloc] initForTableView:self.tableView withStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIndentifier];
    }
    
    if (indexPath.section == 0) {
        
        if (indexPath.row == 0) {
            //
            cell.textLabel.text = @"消息免打扰";
            cell.accessoryType = QMUIStaticTableViewCellAccessoryTypeSwitch;
            
            UISwitch *switcher;
            if ([cell.accessoryView isKindOfClass:[UISwitch class]]) {
                switcher = (UISwitch *)cell.accessoryView;
            } else {
                switcher = [[UISwitch alloc] init];
            }
            switcher.tag = 0;
            switcher.on = self.mIsNoDisturb;
            [switcher removeTarget:nil action:NULL forControlEvents:UIControlEventAllEvents];
            [switcher addTarget:self action:@selector(handleSwitchCellEvent:) forControlEvents:UIControlEventValueChanged];
            cell.accessoryView = switcher;
        } else if (indexPath.row == 1) {
            //
            cell.textLabel.text = @"置顶聊天";
            
            UISwitch *switcher;
            if ([cell.accessoryView isKindOfClass:[UISwitch class]]) {
                switcher = (UISwitch *)cell.accessoryView;
            } else {
                switcher = [[UISwitch alloc] init];
            }
            switcher.tag = 1;
            switcher.on = self.mIsTopThread;
            [switcher removeTarget:nil action:NULL forControlEvents:UIControlEventAllEvents];
            [switcher addTarget:self action:@selector(handleSwitchCellEvent:) forControlEvents:UIControlEventValueChanged];
            cell.accessoryView = switcher;
        } else if (indexPath.row == 2) {
            //
            cell.textLabel.text = @"屏蔽";
            
            UISwitch *switcher;
            if ([cell.accessoryView isKindOfClass:[UISwitch class]]) {
                switcher = (UISwitch *)cell.accessoryView;
            } else {
                switcher = [[UISwitch alloc] init];
            }
            switcher.tag = 2;
            switcher.on = self.mIsShield;
            [switcher removeTarget:nil action:NULL forControlEvents:UIControlEventAllEvents];
            [switcher addTarget:self action:@selector(handleSwitchCellEvent:) forControlEvents:UIControlEventValueChanged];
            cell.accessoryView = switcher;
        }
        
    } else if (indexPath.section == 1) {
        cell.textLabel.text = @"清空聊天记录";
    }
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 1) {
        DDLogInfo(@"清空聊天记录");
        QMUIAlertAction *cancelAction = [QMUIAlertAction actionWithTitle:@"取消" style:QMUIAlertActionStyleCancel handler:^(QMUIAlertController *aAlertController, QMUIAlertAction *action) {
            //
        }];
        QMUIAlertAction *closeAction = [QMUIAlertAction actionWithTitle:@"清空" style:QMUIAlertActionStyleDestructive handler:^(QMUIAlertController *aAlertController, QMUIAlertAction *action) {
            //
            [QMUITips showLoading:@"清空聊天记录中..." inView:self.view];
            //
            [BDCoreApis markClearContactMessage:self.mUid resultSuccess:^(NSDictionary *dict) {
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
                [QMUITips hideAllToastInView:self.view animated:YES];
                // delegate
                if (self.delegate && [self.delegate respondsToSelector:@selector(clearMessages)]) {
                    [self.delegate clearMessages];
                }
            } resultFailed:^(NSError *error) {
                // delegate
                if (self.delegate && [self.delegate respondsToSelector:@selector(clearMessages)]) {
                    [self.delegate clearMessages];
                }
                [QMUITips showError:@"清空聊天记录失败" inView:self.view hideAfterDelay:.8];
                [QMUITips hideAllToastInView:self.view animated:YES];
            }];
            
        }];
        QMUIAlertController *alertController = [QMUIAlertController alertControllerWithTitle:@"确定要清空聊天记录？" message:@"" preferredStyle:QMUIAlertControllerStyleAlert];
        [alertController addAction:cancelAction];
        [alertController addAction:closeAction];
        [alertController showWithAnimated:YES];
    }
}


- (void)initWithUid:(NSString *)uid {
    self.mUid = uid;
}

- (void)handleSwitchCellEvent:(UISwitch *)switchControl {
    // UISwitch 的开关事件，注意第一个参数的类型是 UISwitch
    
    if (switchControl.tag == 0) {
        //
        if (switchControl.on) {
            // 设置免打扰
            [BDCoreApis markNoDisturbThread:self.mTid resultSuccess:^(NSDictionary *dict) {
                //
                NSNumber *status_code = [dict objectForKey:@"status_code"];
                if ([status_code isEqualToNumber:[NSNumber numberWithInt:200]]) {
                    // 成功
                    [QMUITips showSucceed:@"打开免打扰成功" inView:self.view hideAfterDelay:.8];
                } else {
                    
                }
                //
            } resultFailed:^(NSError *error) {
                //
                [QMUITips showError:@"打开免打扰失败" inView:self.view hideAfterDelay:.8];
            }];
        } else {
            //
            // 取消免打扰
            [BDCoreApis unmarkNoDisturbThread:self.mTid resultSuccess:^(NSDictionary *dict) {
                //
                NSNumber *status_code = [dict objectForKey:@"status_code"];
                if ([status_code isEqualToNumber:[NSNumber numberWithInt:200]]) {
                    // 成功
                    [QMUITips showSucceed:@"关闭免打扰成功" inView:self.view hideAfterDelay:.8];
                } else {
                    
                }
                //
            } resultFailed:^(NSError *error) {
                //
                [QMUITips showError:@"关闭免打扰失败" inView:self.view hideAfterDelay:.8];
            }];
        }
    } else if (switchControl.tag == 1) {
        //
        if (switchControl.on) {
           
            // 置顶聊天
            [BDCoreApis markTopThread:self.mTid resultSuccess:^(NSDictionary *dict) {
                //
                NSNumber *status_code = [dict objectForKey:@"status_code"];
                if ([status_code isEqualToNumber:[NSNumber numberWithInt:200]]) {
                    // 成功
                    [QMUITips showSucceed:@"关闭指定聊天成功" inView:self.view hideAfterDelay:.8];
                } else {
                    
                }
            } resultFailed:^(NSError *error) {
                //
                [QMUITips showError:@"关闭置顶聊天" inView:self.view hideAfterDelay:.8];
            }];
            
        } else {
            //
            // 取消指定
            [BDCoreApis unmarkTopThread:self.mTid resultSuccess:^(NSDictionary *dict) {
                //
                NSNumber *status_code = [dict objectForKey:@"status_code"];
                if ([status_code isEqualToNumber:[NSNumber numberWithInt:200]]) {
                    // 成功
                    [QMUITips showSucceed:@"关闭指定聊天成功" inView:self.view hideAfterDelay:.8];
                } else {
                    
                }
            } resultFailed:^(NSError *error) {
                //
                [QMUITips showError:@"关闭置顶聊天" inView:self.view hideAfterDelay:.8];
            }];
        }
    } else if (switchControl.tag == 2) {
        //
        if (switchControl.on) {
            // 屏蔽用户
            [BDCoreApis shield:self.mUid resultSuccess:^(NSDictionary *dict) {
                
            } resultFailed:^(NSError *error) {
                if (error) {
                    [QMUITips showError:error.localizedDescription inView:self.view hideAfterDelay:3];
                }
            }];
            
        } else {
            // 取消屏蔽
            [BDCoreApis unshield:self.mUid resultSuccess:^(NSDictionary *dict) {
                
            } resultFailed:^(NSError *error) {
                if (error) {
                    [QMUITips showError:error.localizedDescription inView:self.view hideAfterDelay:3];
                }
            }];
        }
    }
}


#pragma mark - 加载联系人详情

- (void)fetchContactDetail {
    
    [BDCoreApis userDetail:self.mUid resultSuccess:^(NSDictionary *dict) {
        
        NSNumber *status_code = [dict objectForKey:@"status_code"];
        //        DDLogWarn(@"dict:%@", dict);
        if ([status_code isEqualToNumber:[NSNumber numberWithInt:200]]) {
            
            //
            self.mTid = dict[@"data"][@"threadTid"];
            self.mIsTopThread = [dict[@"data"][@"isTopThread"] boolValue];
            self.mIsNoDisturb = [dict[@"data"][@"isNoDisturb"] boolValue];
            self.mIsShield = [dict[@"data"][@"isShield"] boolValue];
            
            // 成功
            self.mNickname = dict[@"data"][@"user"][@"nickname"];
            
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

@end
