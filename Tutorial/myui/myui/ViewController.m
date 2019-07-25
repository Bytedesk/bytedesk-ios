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

#define kDefaultTitle @"在线客服"

// 管理后台：https://www.bytedesk.com/admin#/login
// 获取wid, 所有设置->客服管理->技能组->唯一ID（wId）
#define DEFAULT_TEST_WID @"201807171659201"


@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"萝卜丝-自定义UI";
    
    // 添加 在线客服按钮
    int x = ([[UIScreen mainScreen] bounds].size.width - 200)/2;
    int y = ([[UIScreen mainScreen] bounds].size.height - 50)/2;
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(x, y, 200, 50)];
    [button setTitle:@"在线客服" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(buttonClicked) forControlEvents:UIControlEventTouchUpInside];
    [button setBackgroundColor:[UIColor grayColor]];
    [self.view addSubview:button];
}

- (void)buttonClicked {
    NSLog(@"%s", __PRETTY_FUNCTION__);
    
    // 第五步：打开在线客服会话窗口
    [BDUIApis pushWorkGroupChat:self.navigationController withWorkGroupWid:DEFAULT_TEST_WID withTitle:kDefaultTitle];
}


@end
