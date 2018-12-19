//
//  KFSocialApiViewController.m
//  demo
//
//  Created by 萝卜丝 on 2018/4/12.
//  Copyright © 2018年 KeFuDaShi. All rights reserved.
//

#import "BDApisTableViewController.h"
#import <SafariServices/SafariServices.h>

// 客服接口演示
#import "KFVisitorChatViewController.h"
#import "KFVisitorProfileViewController.h"
#import "KFVisitorStatusViewController.h"
#import "KFVisitorThreadViewController.h"

// IM接口演示
#import "KFContactViewController.h"
#import "KFGroupViewController.h"
#import "KFQueueViewController.h"
#import "KFThreadViewController.h"
#import "KFProfileViewController.h"


#import <bytedesk-core/bdcore.h>

//开发文档：https://github.com/pengjinning/bytedesk-ios
//获取appkey：登录后台->所有设置->应用管理->APP->appkey列
//获取subDomain，也即企业号：登录后台->所有设置->客服账号->企业号
// 需要替换为真实的
#define DEFAULT_TEST_APPKEY @"201809171553111"
#define DEFAULT_TEST_SUBDOMAIN @"vip"
#define DEFAULT_TEST_APPKEY @"201809171553111"


@interface BDApisTableViewController ()<SFSafariViewControllerDelegate>

@property(nonatomic, strong) NSArray *commonApisArray;
@property(nonatomic, strong) NSArray *kefuApisArray;
@property(nonatomic, strong) NSArray *imApisArray;

@property(nonatomic, strong) NSString *mLoginItemDetailText;

@end

@implementation BDApisTableViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"萝卜丝(未连接)";
    self.mLoginItemDetailText = @"当前未连接，点我建立连接";
    
    // 公共接口
    self.commonApisArray = @[
                             @"注册接口",
                             @"登录接口",
                             @"退出登录接口"
                             ];
    // 客服接口
    self.kefuApisArray = @[
                           @"联系客服接口",
                           @"自定义用户信息接口",
                           @"在线状态接口",
                           @"历史会话记录接口",
                           @"网页形式接入"
                           ];
    // IM接口
    self.imApisArray = @[
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
    return 3;
}

- (nullable NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    //
    if (section == 0) {
        return @"公共接口";
    } else if (section == 1) {
        return @"客服接口";
    } else {
        return @"IM接口";
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    if (section == 0) {
        return [self.commonApisArray count];
    } else if (section == 1) {
        return [self.kefuApisArray count];
    } else {
        return [self.imApisArray count];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    // Configure the cell...
    if (!cell){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    if (indexPath.section == 0) {
        
        [cell.textLabel setText:[NSString stringWithFormat:@"%ld. %@", indexPath.row+1, [self.commonApisArray objectAtIndex:indexPath.row]]];
        
        if (indexPath.row == 1) {
            [cell.detailTextLabel setText:self.mLoginItemDetailText];
        }

    } else if (indexPath.section == 1) {
        
        [cell.textLabel setText:[NSString stringWithFormat:@"%ld. %@", indexPath.row+1, [self.kefuApisArray objectAtIndex:indexPath.row]]];

    } else if (indexPath.section == 2) {
        
        [cell.textLabel setText:[NSString stringWithFormat:@"%ld. %@", indexPath.row+1, [self.imApisArray objectAtIndex:indexPath.row]]];
    }

    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 0) {
        // 公共接口
        if (indexPath.row == 0) {
            // 注册：自定义用户名
            [self showRegisterSheet];
        } else if (indexPath.row == 1) {
            // 登录
            [self showLoginSheet];
        } else if (indexPath.row == 2) {
            // 退出登录
            [self logout];
        }
        
    } else if (indexPath.section == 1) {
        // 客服接口
        UIViewController *viewController = nil;
        if (indexPath.row == 0) {
            // 客服会话接口
            viewController = [[KFVisitorChatViewController alloc] initWithStyle:UITableViewStyleGrouped];
        } else if (indexPath.row == 1) {
            // 自定义用户信息接口
            viewController = [[KFVisitorProfileViewController alloc] initWithStyle:UITableViewStyleGrouped];
        } else if (indexPath.row == 2) {
            // 在线状态接口
            viewController = [[KFVisitorStatusViewController alloc] initWithStyle:UITableViewStyleGrouped];
        } else if (indexPath.row == 3) {
            // 历史会话接口
            viewController = [[KFVisitorThreadViewController alloc] init];
        } else if (indexPath.row == 4) {
            // 网页形式接入
            // 注意: 登录后台->所有设置->所有客服->工作组->获取代码 获取相应URL
            NSURL *url = [NSURL URLWithString:@"https://vip.bytedesk.com/chat?uid=201808221551193&wid=201807171659201&type=workGroup&aid=&ph=ph"];
            SFSafariViewController *safariVC = [[SFSafariViewController alloc] initWithURL:url];
            safariVC.delegate = self;
            // 建议
            [self presentViewController:safariVC animated:YES completion:nil];
            return;
        }
        viewController.title = [self.kefuApisArray objectAtIndex:indexPath.row];
        viewController.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:viewController animated:YES];
        
    } else if (indexPath.section == 2) {
        
        // IM接口
        UIViewController *viewController = nil;
        if (indexPath.row == 0) {
            // 联系人接口
            viewController = [[KFContactViewController alloc] init];
        } else if (indexPath.row == 1) {
            // 群组接口
            viewController = [[KFGroupViewController alloc] init];
        } else if (indexPath.row == 2) {
            // 会话接口
            viewController = [[KFThreadViewController alloc] init];
        } else if (indexPath.row == 3) {
            // 排队接口
            viewController = [[KFQueueViewController alloc] init];
        } else if (indexPath.row == 4) {
            // 设置接口
            viewController = [[KFProfileViewController alloc] init];
        }
        viewController.title = [self.imApisArray objectAtIndex:indexPath.row];
        viewController.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:viewController animated:YES];
    }
    
}

#pragma mark - j扩展面板

- (void)showRegisterSheet {
    
    QMUIAlertAction *cancelAction = [QMUIAlertAction actionWithTitle:@"取消" style:QMUIAlertActionStyleCancel handler:^(QMUIAlertController *aAlertController, QMUIAlertAction *action) {}];
    QMUIAlertAction *registerAction = [QMUIAlertAction actionWithTitle:@"自定义用户名" style:QMUIAlertActionStyleDefault handler:^(QMUIAlertController *aAlertController, QMUIAlertAction *action) {
        // 注册用户
        [self registerUser];
    }];
    
    QMUIAlertAction *anonymouseAction = [QMUIAlertAction actionWithTitle:@"匿名用户" style:QMUIAlertActionStyleDefault handler:^(QMUIAlertController *aAlertController, QMUIAlertAction *action) {
        // 匿名用户不需要注册，直接调用匿名登录接口即可
        [QMUITips showWithText:@"匿名用户不需要注册，直接调用匿名登录接口即可" inView:self.navigationController.view hideAfterDelay:4];
    }];
    
    QMUIAlertController *alertController = [QMUIAlertController alertControllerWithTitle:@"注册" message:@"" preferredStyle:QMUIAlertControllerStyleActionSheet];
    [alertController addAction:cancelAction];
    [alertController addAction:registerAction];
    [alertController addAction:anonymouseAction];
    [alertController showWithAnimated:YES];
}

- (void)showLoginSheet {
    
    QMUIAlertAction *cancelAction = [QMUIAlertAction actionWithTitle:@"取消" style:QMUIAlertActionStyleCancel handler:^(QMUIAlertController *aAlertController, QMUIAlertAction *action) {}];
    QMUIAlertAction *loginAction = [QMUIAlertAction actionWithTitle:@"自定义用户名" style:QMUIAlertActionStyleDefault handler:^(QMUIAlertController *aAlertController, QMUIAlertAction *action) {
        // 自定义用户名登录
        [self login];
    }];
    
    QMUIAlertAction *anonymouseAction = [QMUIAlertAction actionWithTitle:@"匿名用户" style:QMUIAlertActionStyleDefault handler:^(QMUIAlertController *aAlertController, QMUIAlertAction *action) {
        // 匿名登录
        [self anonymouseLogin];
    }];
    
    QMUIAlertController *alertController = [QMUIAlertController alertControllerWithTitle:@"登录" message:@"" preferredStyle:QMUIAlertControllerStyleActionSheet];
    [alertController addAction:cancelAction];
    [alertController addAction:loginAction];
    [alertController addAction:anonymouseAction];
    [alertController showWithAnimated:YES];
}

#pragma mark - 登录、退出登录

- (void)login {
    // 参考文档：https://github.com/pengjinning/bytedesk-ios
    // 测试账号：test1，密码：123456
    // 或者：test1~test15 共15个测试账号，密码均为：123456
    NSString *username = @"test1";
    NSString *password = @"123456";
    // 获取subDomain，也即企业号：登录后台->所有设置->客服账号->企业号
    NSString *subDomain = @"vip";
    // 登录
    [BDCoreApis agentLoginWithUsername:username withPassword:password withAppkey:DEFAULT_TEST_APPKEY withSubdomain:subDomain resultSuccess:^(NSDictionary *dict) {
        DDLogInfo(@"%s, %@", __PRETTY_FUNCTION__, dict);
    } resultFailed:^(NSError *error) {
        DDLogError(@"%s, %@", __PRETTY_FUNCTION__, error);
    }];
}

- (void)anonymouseLogin {
    // 访客登录
    [BDCoreApis visitorLoginWithAppkey:DEFAULT_TEST_APPKEY withSubdomain:DEFAULT_TEST_SUBDOMAIN resultSuccess:^(NSDictionary *dict) {
        // 登录成功
        DDLogInfo(@"%s, %@", __PRETTY_FUNCTION__, dict);
    } resultFailed:^(NSError *error) {
        // 登录失败
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


#pragma mark - 注册

- (void)registerUser {
    
    NSString *username = @"iostest1";
    NSString *nickname = @"iOS测试1";
    NSString *password = @"123456";
    // 获取subDomain，也即企业号：登录后台->所有设置->客服账号->企业号
    NSString *subDomain = @"vip";
    //
    [BDCoreApis registerUser:username withNickname:nickname withPassword:password withSubDomain:subDomain resultSuccess:^(NSDictionary *dict) {
        NSString *message = dict[@"message"];
        NSNumber *status_code = dict[@"status_code"];
        DDLogInfo(@"%s, %@, message:%@, status_code:%@", __PRETTY_FUNCTION__, dict, message, status_code);
        
        if ([status_code isEqualToNumber:[NSNumber numberWithInt:200]]) {
            [QMUITips showSucceed:@"注册成功" inView:self.navigationController.view hideAfterDelay:4];
        } else {
            [QMUITips showError:message inView:self.navigationController.view hideAfterDelay:4];
        }
    } resultFailed:^(NSError *error) {
        DDLogError(@"%s, %@", __PRETTY_FUNCTION__, error);
        [QMUITips showError:@"注册失败" inView:self.navigationController.view hideAfterDelay:4];
    }];
}

#pragma mark - 监听通知

- (void)notifyOAuthResult:(NSNotification *)notification {
    DDLogInfo(@"%s", __PRETTY_FUNCTION__);
    //
}

- (void)notifyConnectionStatus:(NSNotification *)notification {
    DDLogInfo(@"%s", __PRETTY_FUNCTION__);
    NSString *status = [notification object];
    //
    if ([status isEqualToString:BD_USER_STATUS_CONNECTING]) {
        self.navigationItem.title = @"萝卜丝(连接中...)";
    } else if ([status isEqualToString:BD_USER_STATUS_CONNECTED]){
        self.navigationItem.title = @"萝卜丝(已连接)";
        self.mLoginItemDetailText = [NSString stringWithFormat:@"当前已连接: %@", [BDSettings getUsername]];
    } else {
        self.navigationItem.title = @"萝卜丝(连接断开)";
        self.mLoginItemDetailText = @"当前未连接";
    }
    [self.tableView reloadData];
}



@end













