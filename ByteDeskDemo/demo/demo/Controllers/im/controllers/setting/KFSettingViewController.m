//
//  KFSettingsViewController.m
//  demoWebRTC
//
//  Created by 宁金鹏 on 2019/4/8.
//  Copyright © 2019 xiaper.io. All rights reserved.
//

#import "KFSettingViewController.h"

#import <bytedesk-core/BDSettings.h>

@interface KFSettingViewController ()

@end

@implementation KFSettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"设置";
    //
    QMUIStaticTableViewCellDataSource *dataSource =
    [[QMUIStaticTableViewCellDataSource alloc] initWithCellDataSections:
     @[
       // section1
       @[
           ({
        QMUIStaticTableViewCellData *d = [[QMUIStaticTableViewCellData alloc] init];
        d.identifier = 0;
        d.text = @"新消息震动";
        d.accessoryType = QMUIStaticTableViewCellAccessoryTypeSwitch;
        //                d.accessoryValueObject = @YES;
        d.accessoryTarget = self;
        d.accessoryAction = @selector(handleSwitchCellEvent:);
        d.cellForRowBlock = ^(UITableView *tableView, __kindof QMUITableViewCell *cell, QMUIStaticTableViewCellData *cellData) {
            UISwitch *switchControl = (UISwitch *)cell.accessoryView;
            switchControl.tag = 0;
            switchControl.onTintColor = [QDThemeManager sharedInstance].currentTheme.themeTintColor;
            switchControl.tintColor = switchControl.onTintColor;
            switchControl.on = [BDSettings shouldVibrateWhenReceiveMessage];
        };
        d;
    }),
           ({
        QMUIStaticTableViewCellData *d = [[QMUIStaticTableViewCellData alloc] init];
        d.identifier = 1;
        d.text = @"发送消息提示音";
        d.accessoryType = QMUIStaticTableViewCellAccessoryTypeSwitch;
        //                d.accessoryValueObject = @YES;
        d.accessoryTarget = self;
        d.accessoryAction = @selector(handleSwitchCellEvent:);
        d.cellForRowBlock = ^(UITableView *tableView, __kindof QMUITableViewCell *cell, QMUIStaticTableViewCellData *cellData) {
            UISwitch *switchControl = (UISwitch *)cell.accessoryView;
            switchControl.tag = 1;
            switchControl.onTintColor = [QDThemeManager sharedInstance].currentTheme.themeTintColor;
            switchControl.tintColor = switchControl.onTintColor;
            switchControl.on = [BDSettings shouldRingWhenSendMessage];
        };
        d;
    }),
           ({
        QMUIStaticTableViewCellData *d = [[QMUIStaticTableViewCellData alloc] init];
        d.identifier = 2;
        d.text = @"收到消息提示音";
        d.accessoryType = QMUIStaticTableViewCellAccessoryTypeSwitch;
        //                d.accessoryValueObject = @YES;
        d.accessoryTarget = self;
        d.accessoryAction = @selector(handleSwitchCellEvent:);
        d.cellForRowBlock = ^(UITableView *tableView, __kindof QMUITableViewCell *cell, QMUIStaticTableViewCellData *cellData) {
            UISwitch *switchControl = (UISwitch *)cell.accessoryView;
            switchControl.tag = 2;
            switchControl.onTintColor = [QDThemeManager sharedInstance].currentTheme.themeTintColor;
            switchControl.tintColor = switchControl.onTintColor;
            switchControl.on = [BDSettings shouldRingWhenReceiveMessage];
        };
        d;
    })
           ],
       ]];
    // 把数据塞给 tableView 即可
    self.tableView.qmui_staticCellDataSource = dataSource;
}


- (void)handleSwitchCellEvent:(UISwitch *)switchControl {
    
    if (switchControl.tag == 0) {
        DDLogInfo(@"新消息震动");
        
        [BDSettings setVibrateWhenReceiveMessage:switchControl.on];
    } else if (switchControl.tag == 1) {
        DDLogInfo(@"发送消息提示音");
        
        [BDSettings setRingWhenSendMessage:switchControl.on];
    } else if (switchControl.tag == 2) {
        DDLogInfo(@"收到消息提示音");
        
        [BDSettings setRingWhenReceiveMessage:switchControl.on];
    }
}

#pragma mark - <UITableViewDataSource, UITableViewDelegate>


@end
