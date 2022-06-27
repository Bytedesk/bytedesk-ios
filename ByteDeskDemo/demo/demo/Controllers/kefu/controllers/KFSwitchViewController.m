//
//  KFSwitchViewController.m
//  demo_kefu
//
//  Created by 宁金鹏 on 2022/6/27.
//  Copyright © 2022 bytedesk.com. All rights reserved.
//

#import "KFSwitchViewController.h"
#import "KFUserinfoViewController.h"
#import <bytedesk-core/bdcore.h>

@interface KFSwitchViewController ()

@end

@implementation KFSwitchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

#pragma mark - <UITableViewDataSource, UITableViewDelegate>

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    // Configure the cell...
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
    }
    
    if (indexPath.row == 0) {
        cell.textLabel.text = @"用户信息";
    } else if (indexPath.row == 1) {
        cell.textLabel.text = @"用户1男";
    } else if (indexPath.row == 2) {
        cell.textLabel.text = @"用户2女";
    } else if (indexPath.row == 3) {
        cell.textLabel.text = @"退出登录";
    }

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 0) {
        [self userInfo];
    } else if (indexPath.row == 1) {
        [self userBoyLogin];
    } else if (indexPath.row == 2) {
        [self userGirlLogin];
    } else if (indexPath.row == 3) {
        [self logout];
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)userInfo {
    //
    KFUserinfoViewController *userInfoVC = [[KFUserinfoViewController alloc] initWithStyle:UITableViewStyleGrouped];
    [self.navigationController pushViewController:userInfoVC animated:YES];
}

- (void)userBoyLogin {
    if ([BDSettings isAlreadyLogin]) {
        [QMUITips showWithText:@"请先退出登录" inView:self.view hideAfterDelay:.8];
        return;;
    }
    [self initWithUsernameAndNicknameAndAvatar:@"myiosuserboy" withNickname:@"我是帅哥ios" withAvatar:@"https://bytedesk.oss-cn-shenzhen.aliyuncs.com/avatars/boy.png" withAppkey:DEFAULT_TEST_APPKEY withSubdomain:DEFAULT_TEST_SUBDOMAIN];
}

- (void)userGirlLogin {
    if ([BDSettings isAlreadyLogin]) {
        [QMUITips showWithText:@"请先退出登录" inView:self.view hideAfterDelay:.8];
        return;;
    }
    [self initWithUsernameAndNicknameAndAvatar:@"myiosusergirl" withNickname:@"我是美女ios" withAvatar:@"https://bytedesk.oss-cn-shenzhen.aliyuncs.com/avatars/girl.png" withAppkey:DEFAULT_TEST_APPKEY withSubdomain:DEFAULT_TEST_SUBDOMAIN];
}

- (void)initWithUsernameAndNicknameAndAvatar:(NSString *)username withNickname:(NSString *)nickname withAvatar:(NSString *)avatar withAppkey:(NSString *)appkey withSubdomain:(NSString *)subDomain {
    [QMUITips showLoading:@"登录中..." inView:self.view];
    
    [BDCoreApis initWithUsername:username withNickname:nickname withAvatar:avatar withAppkey:appkey withSubdomain:subDomain resultSuccess:^(NSDictionary *dict) {
        
        [QMUITips hideAllToastInView:self.view animated:YES];
        [QMUITips showWithText:@"登录成功" inView:self.view hideAfterDelay:.8];
    } resultFailed:^(NSError *error) {
        
        [QMUITips hideAllToastInView:self.view animated:YES];
        [QMUITips showError:@"登录失败" inView:self.view hideAfterDelay:.8];
    }];
}

- (void)logout {
    [QMUITips showLoading:@"退出登录中..." inView:self.view];
    
    [BDCoreApis logoutResultSuccess:^(NSDictionary *dict) {
        
        [QMUITips hideAllToastInView:self.view animated:YES];
        [QMUITips showWithText:@"退出登录成功" inView:self.view hideAfterDelay:.8];
    } resultFailed:^(NSError *error) {
        
        [QMUITips hideAllToastInView:self.view animated:YES];
        [QMUITips showError:@"请先退出登录" inView:self.view hideAfterDelay:.8];
    }];
}

@end
