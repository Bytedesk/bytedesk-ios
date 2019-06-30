//
//  KFSocialApiViewController.m
//  demo
//
//  Created by 萝卜丝 on 2018/4/12.
//  Copyright © 2018年 KeFuDaShi. All rights reserved.
//

#import "KFIMApiViewController.h"
#import "KFContactViewController.h"
#import "KFGroupViewController.h"
#import "KFQueueViewController.h"
#import "KFThreadViewController.h"
#import "KFProfileViewController.h"

#import <bytedesk-core/bdcore.h>

@interface KFIMApiViewController ()

@property(nonatomic, strong) NSArray *apisArray;

@property(nonatomic, strong) NSString *mLoginItemDetailText;

@end

@implementation KFIMApiViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"IM接口(未连接)";
    self.mLoginItemDetailText = @"当前未连接，点我建立连接";
    //
    self.apisArray = @[@"接口说明",
                       @"注册接口",
                       @"登录接口",
                       @"联系人接口",
                       @"群组接口",
                       @"会话接口",
                       @"排队接口",
                       @"设置接口",
                       ];
    //
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notifyOAuthResult:) name:BD_NOTIFICATION_OAUTH_RESULT object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notifyConnectionStatus:) name:BD_NOTIFICATION_CONNECTION_STATUS object:nil];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [self.apisArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    // Configure the cell...
    if (!cell){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    [cell.textLabel setText:[NSString stringWithFormat:@"%ld. %@", indexPath.row+1, [self.apisArray objectAtIndex:indexPath.row]]];
    if (indexPath.row == 2) {
        [cell.detailTextLabel setText:self.mLoginItemDetailText];
    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    //
    UIViewController *viewController = nil;
    if (indexPath.row == 0) {
        
        return;
    } else if (indexPath.row == 1) {

    } else if (indexPath.row == 2) {
        
        if ([BDCoreApis isConnected]) {
            [self logout];
        } else {
            [self login];
        }
        return;
        
    } else if (indexPath.row == 3) {
        
        viewController = [[KFContactViewController alloc] init];
    } else if (indexPath.row == 4) {
        
        viewController = [[KFGroupViewController alloc] init];
    } else if (indexPath.row == 5) {
        
        viewController = [[KFThreadViewController alloc] init];
    } else if (indexPath.row == 6) {
        
        viewController = [[KFQueueViewController alloc] init];
    } else if (indexPath.row == 7) {
        
        viewController = [[KFProfileViewController alloc] init];
    }
    
    viewController.title = [self.apisArray objectAtIndex:indexPath.row];
    viewController.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:viewController animated:YES];
}

- (void)login {
    // 测试账号：test1，密码：123456
    // 或者：test1~test15 共15个测试账号，密码均为：123456
    NSString *username = @"test16";
    NSString *password = @"123456";
    NSString *subDomain = @"vip";
    // 登录
    [BDCoreApis loginWithUsername:username withPassword:password withAppkey:DEFAULT_TEST_APPKEY withSubdomain:subDomain resultSuccess:^(NSDictionary *dict) {
        DDLogInfo(@"%s, %@", __PRETTY_FUNCTION__, dict);
    } resultFailed:^(NSError *error) {
        DDLogError(@"%s, %@", __PRETTY_FUNCTION__, error);
    }];
}

- (void)logout {
    // 退出登录
    [BDCoreApis logoutResultSuccess:^(NSDictionary *dict) {
        DDLogInfo(@"%s, %@", __PRETTY_FUNCTION__, dict);
    } resultFailed:^(NSError *error) {
        DDLogError(@"%s, %@", __PRETTY_FUNCTION__, error);
    }];
}

#pragma mark - Section

- (void)notifyOAuthResult:(NSNotification *)notification {
    DDLogInfo(@"%s", __PRETTY_FUNCTION__);
    //
}


- (void)notifyConnectionStatus:(NSNotification *)notification {
    DDLogInfo(@"%s", __PRETTY_FUNCTION__);
    NSString *status = [notification object];
    //
    if ([status isEqualToString:BD_USER_STATUS_CONNECTING]) {
        self.navigationItem.title = [BDCoreApis loginAsVisitor] ? @"客服接口(连接中...)" : @"IM接口(连接中...)";
    } else if ([status isEqualToString:BD_USER_STATUS_CONNECTED]){
        self.navigationItem.title = [BDCoreApis loginAsVisitor] ? @"客服接口(已连接)" : @"IM接口(已连接)";
        self.mLoginItemDetailText = @"当前已连接，点我断开连接";
    } else {
        self.navigationItem.title = [BDCoreApis loginAsVisitor] ? @"客服接口(连接断开)" : @"IM接口(连接断开)";
        self.mLoginItemDetailText = @"当前未连接，点我建立连接";
    }
    [self.tableView reloadData];
}



@end













