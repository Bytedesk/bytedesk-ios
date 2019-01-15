//
//  BDContactProfileViewController.m
//  bytedesk-ui
//
//  Created by 宁金鹏 on 2019/1/14.
//  Copyright © 2019 KeFuDaShi. All rights reserved.
//

#import "BDContactProfileViewController.h"

#import <bytedesk-core/bdcore.h>

@interface BDContactProfileViewController ()

@property(nonatomic, strong) BDThreadModel *mThreadModel;

@end

@implementation BDContactProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"用户信息";
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 2;
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
            switcher.on = [self.mThreadModel.is_mark_disturb boolValue];
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
            switcher.on = [self.mThreadModel.is_mark_top boolValue];
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
        //
        [BDCoreApis markClearMessage:self.mThreadModel.tid resultSuccess:^(NSDictionary *dict) {
            //
            NSNumber *status_code = [dict objectForKey:@"status_code"];
            if ([status_code isEqualToNumber:[NSNumber numberWithInt:200]]) {
                // 成功
                
            } else {
                
            }
            // TODO: 清空本地相关聊天记录
            [QMUITips showSucceed:@"成功清空聊天记录" inView:self.view hideAfterDelay:.8];
        } resultFailed:^(NSError *error) {
            [QMUITips showError:@"清空聊天记录失败" inView:self.view hideAfterDelay:.8];
        }];
    }
}


- (void)initWithThreadModel:(BDThreadModel *)threadModel {
    self.mThreadModel = threadModel;
}

- (void)handleSwitchCellEvent:(UISwitch *)switchControl {
    // UISwitch 的开关事件，注意第一个参数的类型是 UISwitch
    
    if (switchControl.tag == 0) {
        //
        if (switchControl.on) {
            //
            if (self.mThreadModel) {
                // 设置免打扰
                [BDCoreApis markDisturbThread:self.mThreadModel.tid resultSuccess:^(NSDictionary *dict) {
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
            }
        } else {
            //
            if (self.mThreadModel) {
                // 取消免打扰
                [BDCoreApis unmarkDisturbThread:self.mThreadModel.tid resultSuccess:^(NSDictionary *dict) {
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
        }
    } else if (switchControl.tag == 1) {
        //
        if (switchControl.on) {
           
            if (self.mThreadModel) {
                // 置顶聊天
                [BDCoreApis markTopThread:self.mThreadModel.tid resultSuccess:^(NSDictionary *dict) {
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
        } else {
            //
            if (self.mThreadModel) {
                // 取消指定
                [BDCoreApis unmarkTopThread:self.mThreadModel.tid resultSuccess:^(NSDictionary *dict) {
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
        }
    }
}

@end
