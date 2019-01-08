//
//  KFVisitorApiViewController.m
//  demo
//
//  Created by 萝卜丝 on 2018/11/22.
//  Copyright © 2018年 Bytedesk.com. All rights reserved.
//

#import "KFKeFuApiViewController.h"
#import <SafariServices/SafariServices.h>

#import "KFIntroViewController.h"
#import "KFChatViewController.h"
#import "KFUserinfoViewController.h"
#import "KFStatusViewController.h"
#import "KFVisitorThreadViewController.h"
//#import "KFVisitorFeedbackViewController.h"
//#import "KFVisitorFAQViewController.h"
//#import "KFVisitorLeavemsgViewController.h"

#import <bytedesk-core/bdcore.h>

//开发文档：https://github.com/pengjinning/bytedesk-ios
//获取appkey：登录后台->所有设置->应用管理->APP->appkey列
//获取subDomain，也即企业号：登录后台->所有设置->客服账号->企业号
// 需要替换为真实的
#define DEFAULT_TEST_APPKEY @"201809171553111"
#define DEFAULT_TEST_SUBDOMAIN @"vip"

//"0. 萝卜丝简介",
//"1. 初始化/登录接口",
//"2. 开始对话接口",
//"3. 设置用户标签/个人资料接口",
//"4. 查询客服在线状态接口",
//"5. 聊天记录接口", // 查询未读消息记录接口, 清空本地聊天记录接口
//"6. 意见反馈接口",
//"7. 常见问题接口",
//"8. 离线留言接口",
//@"9. 未读消息条数接口"

@interface KFKeFuApiViewController ()<SFSafariViewControllerDelegate>

@property(nonatomic, strong) NSArray *apisArray;

@property(nonatomic, strong) NSString *mLoginItemDetailText;

@end

@implementation KFKeFuApiViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"客服接口(未连接)";
    self.mLoginItemDetailText = @"当前未连接，点我建立连接";
    //
    self.apisArray = @[ @"接口说明",
                        @"注册接口",
                        @"登录接口",
                        @"开始新会话接口",
                        @"用户信息接口",
                        @"在线状态接口",
                        @"历史会话记录接口",
                        @"网页形式接入"
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
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    [cell.textLabel setText:[NSString stringWithFormat:@"%ld. %@", (long)(indexPath.row+1), [self.apisArray objectAtIndex:indexPath.row]]];
    if (indexPath.row == 2) {
        [cell.detailTextLabel setText:self.mLoginItemDetailText];
    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    //
    UIViewController *viewController = nil;
    if (indexPath.row == 0) {
        viewController = [[KFIntroViewController alloc] initWithStyle:UITableViewStyleGrouped];
    } else if (indexPath.row == 1) {
        
    } else if (indexPath.row == 2) {
        //
        if ([BDCoreApis isConnected]) {
            [self logout];
        } else {
            [self login];
        }
        return;
    } else if (indexPath.row == 3) {
        viewController = [[KFChatViewController alloc] initWithStyle:UITableViewStyleGrouped];
    } else if (indexPath.row == 4) {
        viewController = [[KFUserinfoViewController alloc] initWithStyle:UITableViewStyleGrouped];
    } else if (indexPath.row == 5) {
        viewController = [[KFStatusViewController alloc] initWithStyle:UITableViewStyleGrouped];
    } else if (indexPath.row == 6) {
        viewController = [[KFVisitorThreadViewController alloc] init];
    } else if (indexPath.row == 7) {
        // 注意: 登录后台->所有设置->所有客服->工作组->获取代码 获取相应URL
        NSURL *url = [NSURL URLWithString:@"https://vip.bytedesk.com/chat?uid=201808221551193&wid=201807171659201&type=workGroup&aid=&ph=ph"];
        SFSafariViewController *safariVC = [[SFSafariViewController alloc] initWithURL:url];
        safariVC.delegate = self;
        
        // 建议
        [self presentViewController:safariVC animated:YES completion:nil];
        return;
    }
    viewController.title = [self.apisArray objectAtIndex:indexPath.row];
    viewController.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:viewController animated:YES];
}

- (void)login {
    
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

#pragma mark - 通知 selector

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

#pragma mark - SFSafariViewControllerDelegate
//加载完成
- (void)safariViewController:(SFSafariViewController *)controller didCompleteInitialLoad:(BOOL)didLoadSuccessfully {
    DDLogInfo(@"%s", __PRETTY_FUNCTION__);
}

//点击左上角的done
- (void)safariViewControllerDidFinish:(SFSafariViewController *)controller {
    DDLogInfo(@"%s", __PRETTY_FUNCTION__);
}


@end





