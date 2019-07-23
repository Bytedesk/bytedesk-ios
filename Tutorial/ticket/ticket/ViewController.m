//
//  ViewController.m
//  kefu
//
//  Created by 宁金鹏 on 2019/7/23.
//  Copyright © 2019 bytedesk.com. All rights reserved.
//

#import "ViewController.h"

// 第四步：添加头文件
#import <bytedesk-ui/bdui.h>

// 管理后台：https://www.bytedesk.com/admin#/login
// 获取adminUid, 登录后台->所有设置->客服账号->管理员uid列
#define DEFAULT_TEST_ADMIN_UID @"201808221551193"


@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"萝卜丝-工单Demo";
    
    // 添加 在线客服按钮
    int x = ([[UIScreen mainScreen] bounds].size.width - 200)/2;
    int y = ([[UIScreen mainScreen] bounds].size.height - 50)/2;
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(x, y, 200, 50)];
    [button setTitle:@"提交工单" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(buttonClicked) forControlEvents:UIControlEventTouchUpInside];
    [button setBackgroundColor:[UIColor grayColor]];
    [self.view addSubview:button];
}

- (void)buttonClicked {
    NSLog(@"%s", __PRETTY_FUNCTION__);
    
    // 第五步：打开提交工单窗口
    [BDUIApis pushTicket:self.navigationController withAdminUid:DEFAULT_TEST_ADMIN_UID];
}


@end
