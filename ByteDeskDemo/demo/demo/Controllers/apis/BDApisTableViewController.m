//
//  KFSocialApiViewController.m
//  demo
//
//  Created by 萝卜丝1.5.9 on 2018/4/12.
//  Copyright © 2018年 KeFuDaShi. All rights reserved.
//

#import "BDApisTableViewController.h"
#import <SafariServices/SafariServices.h>

#import "KFScanViewController.h"
#import "KFQRCodeViewController.h"
#import "KFServerViewController.h"

// 客服接口演示
#import "KFChatViewController.h"
#import "KFUserinfoViewController.h"
#import "KFStatusViewController.h"
#import "KFVisitorThreadViewController.h"
//#import "BDFeedbackViewController.h"
#import "KFSupportViewController.h"
//#import "KFTicketViewController.h"
#import "KFAppRateViewController.h"
#import "KFAppUpgrateViewController.h"

// IM接口演示
#import "KFContactViewController.h"
#import "KFFriendViewController.h"
#import "KFGroupViewController.h"
#import "KFQueueViewController.h"
#import "KFThreadViewController.h"
#import "KFMomentViewController.h"
#import "KFProfileViewController.h"
#import "KFNoticeViewController.h"
#import "KFSettingViewController.h"

#import <bytedesk-core/bdcore.h>
#import <bytedesk-ui/bdui.h>

//开发文档：https://github.com/pengjinning/bytedesk-ios
//获取appkey：登录后台->所有设置->应用管理->APP->appkey列
//获取subDomain，也即企业号：登录后台->所有设置->客服账号->企业号
// 需要替换为真实的
#define DEFAULT_TEST_APPKEY @"a3f79509-5cb6-4185-8df9-b1ce13d3c655"
#define DEFAULT_TEST_SUBDOMAIN @"vip"


@interface BDApisTableViewController ()<SFSafariViewControllerDelegate>

@property(nonatomic, strong) NSArray *commonApisArray;
@property(nonatomic, strong) NSArray *kefuApisArray;
@property(nonatomic, strong) NSArray *imApisArray;

@property(nonatomic, strong) NSString *mLoginItemDetailText;
@property(nonatomic, weak) QMUIDialogTextFieldViewController *currentTextFieldDialogViewController;

@property(nonatomic, strong) NSString *demoVersion;

@end

@implementation BDApisTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    self.navigationItem.title = @"萝卜丝1.5.9(未连接)";
    self.demoVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    self.title = [NSString stringWithFormat:@"萝卜丝%@(未连接)", self.demoVersion];
    //
    self.mLoginItemDetailText = @"当前未连接，点我建立连接";
    
    // 公共接口
    self.commonApisArray = @[
                             @"自定义服务器",
                             @"注册接口",
                             @"登录接口",
                             @"退出登录接口",
                             @"二维码",
                             @"多账号管理(TODO)"
                             ];
    // 客服接口
    self.kefuApisArray = @[
                           @"联系客服",
                           @"自定义用户信息",
                           @"在线状态",
                           @"历史会话",
                           @"提交工单",
                           @"意见反馈",
                           @"帮助中心",
                           @"网页会话",
                           @"引导应用商店好评(TODO)",
                           @"引导新版本升级(TODO)"
                           ];
    // IM接口
    self.imApisArray = @[
                       @"好友关系",
                       @"联系人",
                       @"群组",
                       @"会话",
                       @"朋友圈(TODO)",
                       @"排队",
                       @"系统消息",
                       @"个人资料",
                       @"设置",
                       ];
    // 监听消息通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notifyOAuthResult:) name:BD_NOTIFICATION_OAUTH_RESULT object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notifyConnectionStatus:) name:BD_NOTIFICATION_CONNECTION_STATUS object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notifyKickoff:) name:BD_NOTIFICATION_KICKOFF object:nil];
    
    // 摇一摇：意见反馈
    [[UIApplication sharedApplication] setApplicationSupportsShakeToEdit:YES];
    [self becomeFirstResponder];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self resignFirstResponder];
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
        
        [cell.textLabel setText:[NSString stringWithFormat:@"%ld. %@", (long)(indexPath.row+1), [self.commonApisArray objectAtIndex:indexPath.row]]];
        
        if (indexPath.row == 2) {
            [cell.detailTextLabel setText:self.mLoginItemDetailText];
        } else {
            cell.detailTextLabel.text = @"";
        }

    } else if (indexPath.section == 1) {
        
        [cell.textLabel setText:[NSString stringWithFormat:@"%ld. %@", (long)(indexPath.row+1), [self.kefuApisArray objectAtIndex:indexPath.row]]];
        cell.detailTextLabel.text = @"";

    } else if (indexPath.section == 2) {
        
        [cell.textLabel setText:[NSString stringWithFormat:@"%ld. %@", (long)(indexPath.row+1), [self.imApisArray objectAtIndex:indexPath.row]]];
        
        if (indexPath.row == 0) {
            cell.detailTextLabel.text = @"社交: 关注/粉丝/好友/拉黑";
        } else if (indexPath.row == 1) {
            cell.detailTextLabel.text = @"客服同事";
        } else {
            cell.detailTextLabel.text = @"";
        }
    }

    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 0) {
        // 公共接口
        if (indexPath.row == 0) {
            // 自定义服务器
            KFServerViewController *serverViewController = [[KFServerViewController alloc] initWithStyle:UITableViewStyleGrouped];
            [self.navigationController pushViewController:serverViewController animated:YES];
        } else if (indexPath.row == 1) {
            // 注册：自定义用户名
            [self showRegisterSheet];
        } else if (indexPath.row == 2) {
            // 登录
            [self showLoginSheet];
        } else if (indexPath.row == 3) {
            // 退出登录
            [self logout];
        } else if (indexPath.row == 4) {
            // TODO: 二维码、扫一扫
            KFScanViewController *scanViewController = [[KFScanViewController alloc] initWithStyle:UITableViewStyleGrouped];
            [self.navigationController pushViewController:scanViewController animated:YES];
        } else if (indexPath.row == 5) {
            // TODO: 多账号管理
        }
        
    } else if (indexPath.section == 1) {
        // 客服接口
        UIViewController *viewController = nil;
        if (indexPath.row == 0) {
            // 客服会话接口
            viewController = [[KFChatViewController alloc] initWithStyle:UITableViewStyleGrouped];
        } else if (indexPath.row == 1) {
            // 自定义用户信息接口
            viewController = [[KFUserinfoViewController alloc] initWithStyle:UITableViewStyleGrouped];
        } else if (indexPath.row == 2) {
            // 在线状态接口
            viewController = [[KFStatusViewController alloc] initWithStyle:UITableViewStyleGrouped];
        } else if (indexPath.row == 3) {
            // 历史会话接口
            viewController = [[KFVisitorThreadViewController alloc] init];
        } else if (indexPath.row == 4) {
            // 提交工单
//            viewController = [[KFTicketViewController alloc] initWithStyle:UITableViewStyleGrouped];
            [BDUIApis pushTicket:self.navigationController withAdminUid:DEFAULT_TEST_ADMIN_UID];
            return;
        } else if (indexPath.row == 5) {
            // 意见反馈
//            viewController = [[BDFeedbackViewController alloc] initWithStyle:UITableViewStyleGrouped];
            [BDUIApis pushFeedback:self.navigationController withAdminUid:DEFAULT_TEST_ADMIN_UID];
            return;
        } else if (indexPath.row == 6) {
            // TODO: 帮助中心
             viewController = [[KFSupportViewController alloc] initWithStyle:UITableViewStyleGrouped];
        } else if (indexPath.row == 7) {
            // 网页形式接入
            // 注意: 登录后台->所有设置->所有客服->工作组->获取代码 获取相应URL
            NSURL *url = [NSURL URLWithString:@"https://vip.bytedesk.com/chat?uid=201808221551193&wid=201807171659201&type=workGroup&aid=&ph=ph"];
            SFSafariViewController *safariVC = [[SFSafariViewController alloc] initWithURL:url];
            safariVC.delegate = self;
            // 建议
            [self presentViewController:safariVC animated:YES completion:nil];
            return;
        } else if (indexPath.row == 8) {
            // TODO: 应用商店评价
            viewController = [[KFAppRateViewController alloc] initWithStyle:UITableViewStyleGrouped];
        } else {
            // TODO: 引导升级
            viewController = [[KFAppUpgrateViewController alloc] initWithStyle:UITableViewStyleGrouped];
        }
        viewController.title = [self.kefuApisArray objectAtIndex:indexPath.row];
        viewController.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:viewController animated:YES];
        
    } else if (indexPath.section == 2) {
        
        // IM接口
        UIViewController *viewController = nil;
        if (indexPath.row == 0) {
            // 好友接口
            viewController = [[KFFriendViewController alloc] init];
        } else if (indexPath.row == 1) {
            // 联系人接口
            viewController = [[KFContactViewController alloc] init];
        } else if (indexPath.row == 2) {
            // 群组接口
            viewController = [[KFGroupViewController alloc] init];
        } else if (indexPath.row == 3) {
            // 会话接口
            viewController = [[KFThreadViewController alloc] init];
        } else if (indexPath.row == 4) {
            // 朋友圈接口
            viewController = [[KFMomentViewController alloc] init];
        } else if (indexPath.row == 5) {
            // 排队接口
            viewController = [[KFQueueViewController alloc] init];
        } else if (indexPath.row == 6) {
            // TODO: 系统消息接口
            viewController = [[KFNoticeViewController alloc] init];
        } else if (indexPath.row == 7) {
            // 个人资料接口
            viewController = [[KFProfileViewController alloc] init];
        } else if (indexPath.row == 8) {
            // 设置接口
            viewController = [[KFSettingViewController alloc] init];
        }
        viewController.title = [self.imApisArray objectAtIndex:indexPath.row];
        viewController.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:viewController animated:YES];
    }
    
}

#pragma mark - 扩展面板

- (void)showRegisterSheet {
    
    QMUIAlertAction *cancelAction = [QMUIAlertAction actionWithTitle:@"取消" style:QMUIAlertActionStyleCancel handler:^(QMUIAlertController *aAlertController, QMUIAlertAction *action) {}];
    QMUIAlertAction *registerAction = [QMUIAlertAction actionWithTitle:@"自定义用户名" style:QMUIAlertActionStyleDefault handler:^(QMUIAlertController *aAlertController, QMUIAlertAction *action) {
        // 注册用户
        [self showRegisterDialogViewController];
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


/**
 自定义用户名注册弹框
 */
- (void)showRegisterDialogViewController {
    QMUIDialogTextFieldViewController *dialogViewController = [[QMUIDialogTextFieldViewController alloc] init];
    dialogViewController.title = @"自定义用户名注册";
    [dialogViewController addTextFieldWithTitle:@"用户名" configurationHandler:^(QMUILabel *titleLabel, QMUITextField *textField, CALayer *separatorLayer) {
        textField.placeholder = @"仅允许字母、数字";
//        textField.maximumTextLength = 10;
    }];
    [dialogViewController addTextFieldWithTitle:@"密码" configurationHandler:^(QMUILabel *titleLabel, QMUITextField *textField, CALayer *separatorLayer) {
        textField.placeholder = @"6位数字";
        textField.keyboardType = UIKeyboardTypeNumberPad;
        textField.maximumTextLength = 6;
        textField.secureTextEntry = YES;
    }];
    dialogViewController.enablesSubmitButtonAutomatically = NO;// 为了演示效果与第二个 cell 的区分开，这里手动置为 NO，平时的默认值为 YES
    [dialogViewController addCancelButtonWithText:@"取消" block:nil];
    [dialogViewController addSubmitButtonWithText:@"确定" block:^(QMUIDialogTextFieldViewController *aDialogViewController) {
        if (aDialogViewController.textFields.firstObject.text.length > 0) {
            [aDialogViewController hide];
            
            // 自定义用户名、密码注册
            NSString *username = aDialogViewController.textFields.firstObject.text;
            NSString *password = aDialogViewController.textFields.lastObject.text;
            [self registerUser:username withPassword:password];
            
        } else {
            [QMUITips showInfo:@"请填写内容" inView:self.view hideAfterDelay:1.2];
        }
    }];
    [dialogViewController show];
    self.currentTextFieldDialogViewController = dialogViewController;
}

- (void)showLoginSheet {
    
    QMUIAlertAction *cancelAction = [QMUIAlertAction actionWithTitle:@"取消" style:QMUIAlertActionStyleCancel handler:^(QMUIAlertController *aAlertController, QMUIAlertAction *action) {}];
    QMUIAlertAction *loginAction = [QMUIAlertAction actionWithTitle:@"自定义用户名" style:QMUIAlertActionStyleDefault handler:^(QMUIAlertController *aAlertController, QMUIAlertAction *action) {
        // 自定义用户名登录
        [self showLoginDialogViewController];
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


/**
 显示登录自定义用户名弹框
 */
- (void)showLoginDialogViewController {
    //
    QMUIDialogTextFieldViewController *dialogViewController = [[QMUIDialogTextFieldViewController alloc] init];
    dialogViewController.title = @"自定义用户名登录";
    [dialogViewController addTextFieldWithTitle:@"用户名" configurationHandler:^(QMUILabel *titleLabel, QMUITextField *textField, CALayer *separatorLayer) {
        textField.placeholder = @"仅允许字母、数字";
        //        textField.maximumTextLength = 10;
    }];
    [dialogViewController addTextFieldWithTitle:@"密码" configurationHandler:^(QMUILabel *titleLabel, QMUITextField *textField, CALayer *separatorLayer) {
        textField.placeholder = @"6位数字";
        textField.keyboardType = UIKeyboardTypeNumberPad;
        textField.maximumTextLength = 6;
        textField.secureTextEntry = YES;
    }];
    dialogViewController.enablesSubmitButtonAutomatically = NO;// 为了演示效果与第二个 cell 的区分开，这里手动置为 NO，平时的默认值为 YES
    [dialogViewController addCancelButtonWithText:@"取消" block:nil];
    [dialogViewController addSubmitButtonWithText:@"确定" block:^(QMUIDialogTextFieldViewController *aDialogViewController) {
        if (aDialogViewController.textFields.firstObject.text.length > 0) {
            [aDialogViewController hide];
            
            // 自定义用户名、密码登录
            NSString *username = aDialogViewController.textFields.firstObject.text;
            NSString *password = aDialogViewController.textFields.lastObject.text;
            [self login:username withPassword:password];
            
        } else {
            [QMUITips showInfo:@"请填写内容" inView:self.view hideAfterDelay:1.2];
        }
    }];
    [dialogViewController show];
    self.currentTextFieldDialogViewController = dialogViewController;
}

#pragma mark - 登录、退出登录

- (void)login:(NSString *)username withPassword:(NSString *)password {
    
    [QMUITips showLoading:@"登录中..." inView:self.view];
    // 参考文档：https://github.com/pengjinning/bytedesk-ios
    // 获取subDomain，也即企业号：登录后台->所有设置->客服账号->企业号
    NSString *subDomain = @"vip";
    // 登录
    [BDCoreApis loginWithUsername:[username stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] withPassword:password withAppkey:DEFAULT_TEST_APPKEY withSubdomain:subDomain resultSuccess:^(NSDictionary *dict) {
        DDLogInfo(@"%s, %@", __PRETTY_FUNCTION__, dict);
        [QMUITips hideAllToastInView:self.view animated:YES];
    } resultFailed:^(NSError *error) {
        DDLogError(@"%s, %@", __PRETTY_FUNCTION__, error);
        [QMUITips hideAllToastInView:self.view animated:YES];
        [QMUITips showError:@"登录失败" inView:self.view hideAfterDelay:2];
    }];
}

- (void)anonymouseLogin {
    [QMUITips showLoading:@"登录中..." inView:self.view];
    // 访客登录
    [BDCoreApis visitorLoginWithAppkey:DEFAULT_TEST_APPKEY withSubdomain:DEFAULT_TEST_SUBDOMAIN resultSuccess:^(NSDictionary *dict) {
        // 登录成功
        DDLogInfo(@"%s, %@", __PRETTY_FUNCTION__, dict);
        [QMUITips hideAllToastInView:self.view animated:YES];
    } resultFailed:^(NSError *error) {
        // 登录失败
        DDLogError(@"%s, %@", __PRETTY_FUNCTION__, error);
        [QMUITips hideAllToastInView:self.view animated:YES];
        [QMUITips showError:@"登录失败" inView:self.view hideAfterDelay:2];
    }];
}


- (void)logout {
    
    // 退出登录
    QMUIAlertAction *cancelAction = [QMUIAlertAction actionWithTitle:@"取消" style:QMUIAlertActionStyleCancel handler:^(QMUIAlertController *aAlertController, QMUIAlertAction *action) {
        //
    }];
    QMUIAlertAction *closeAction = [QMUIAlertAction actionWithTitle:@"退出" style:QMUIAlertActionStyleDestructive handler:^(QMUIAlertController *aAlertController, QMUIAlertAction *action) {
        //
        [QMUITips showLoading:@"退出中..." inView:self.view];
        // 退出登录
        [BDCoreApis logoutResultSuccess:^(NSDictionary *dict) {
            DDLogInfo(@"%s, %@", __PRETTY_FUNCTION__, dict);
            
            NSNumber *status_code = [dict objectForKey:@"status_code"];
            if ([status_code isEqualToNumber:[NSNumber numberWithInt:200]]) {
                
            } else {
                
                NSString *message = dict[@"message"];
                DDLogError(@"%s %@", __PRETTY_FUNCTION__, message);
                [QMUITips showError:message inView:self.view hideAfterDelay:2];
            }
            [QMUITips hideAllToastInView:self.view animated:YES];
        } resultFailed:^(NSError *error) {
            DDLogError(@"%s, %@", __PRETTY_FUNCTION__, error);
            [QMUITips hideAllToastInView:self.view animated:YES];
        }];
    }];
    QMUIAlertController *alertController = [QMUIAlertController alertControllerWithTitle:@"确定要退出登录？" message:@"" preferredStyle:QMUIAlertControllerStyleAlert];
    [alertController addAction:cancelAction];
    [alertController addAction:closeAction];
    [alertController showWithAnimated:YES];
}


#pragma mark - 注册

- (void)registerUser:(NSString *)username withPassword:(NSString *)password {
    
    NSString *nickname = [NSString stringWithFormat:@"自定义测试%@", username];
    // 获取subDomain，也即企业号：登录后台->所有设置->客服账号->企业号
    NSString *subDomain = @"vip";
    //
    [BDCoreApis registerUser:[username stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] withNickname:nickname withPassword:[password stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] withSubDomain:subDomain resultSuccess:^(NSDictionary *dict) {
        
        NSString *message = dict[@"message"];
        NSNumber *status_code = dict[@"status_code"];
        DDLogInfo(@"%s, %@, message:%@, status_code:%@", __PRETTY_FUNCTION__, dict, message, status_code);
        
        if ([status_code isEqualToNumber:[NSNumber numberWithInt:200]]) {
            [QMUITips showSucceed:@"注册成功" inView:self.navigationController.view hideAfterDelay:4];
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


/**
 监听连接状态通知

 @param notification <#notification description#>
 */
- (void)notifyConnectionStatus:(NSNotification *)notification {
    NSString *status = [notification object];
    DDLogInfo(@"%s status:%@", __PRETTY_FUNCTION__, status);
    //
    if ([status isEqualToString:BD_USER_STATUS_CONNECTING]) {
        self.title = [NSString stringWithFormat:@"萝卜丝%@(连接中...)", self.demoVersion];
    } else if ([status isEqualToString:BD_USER_STATUS_CONNECTED]){
        self.title = [NSString stringWithFormat:@"萝卜丝%@(已连接)", self.demoVersion];
        self.mLoginItemDetailText = [NSString stringWithFormat:@"当前已连接: %@", [BDSettings getUsername]];
    } else {
        self.title = [NSString stringWithFormat:@"萝卜丝%@(连接断开)", self.demoVersion];
        self.mLoginItemDetailText = @"当前未连接";
    }
    [self.tableView reloadData];
}


/**
 监听账号异地登录通知

 @param notification <#notification description#>
 */
- (void)notifyKickoff:(NSNotification *)notification {
    DDLogInfo(@"%s", __PRETTY_FUNCTION__);
    NSString *content = [notification object];
    
    __weak __typeof(self)weakSelf = self;
    QMUIAlertAction *okAction = [QMUIAlertAction actionWithTitle:@"确定" style:QMUIAlertActionStyleDefault handler:^(__kindof QMUIAlertController *aAlertController, QMUIAlertAction *action) {
        
        // 开发者可以根据自己需要决定是否调用退出登录
        // 注意: 同一账号同时登录多个客户端不影响正常会话
        [weakSelf logout];
    }];
    QMUIAlertController *alertController = [QMUIAlertController alertControllerWithTitle:@"账号异地登录提示" message:content preferredStyle:QMUIAlertControllerStyleAlert];
    [alertController addAction:okAction];
    [alertController showWithAnimated:YES];
}


#pragma mark - ShakeToEdit 摇动手机之后的回调方法, 摇一摇意见反馈(类似知乎)

- (void) motionBegan:(UIEventSubtype)motion withEvent:(UIEvent *)event {
    if (motion == UIEventSubtypeMotionShake) {
        DDLogInfo(@"检测到摇动开始");
    }
}

- (void) motionCancelled:(UIEventSubtype)motion withEvent:(UIEvent *)event {
    DDLogInfo(@"摇动取消");
}

- (void) motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event {
    if (event.subtype == UIEventSubtypeMotionShake) {
        DDLogInfo(@"摇动结束");
        //振动效果 需要#import <AudioToolbox/AudioToolbox.h>
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
    }
}

@end













