//
//  BDLeaveMessageViewController.m
//  bytedesk-ui
//
//  Created by 萝卜丝 on 2019/4/8.
//  Copyright © 2019 KeFuDaShi. All rights reserved.
//

#import "BDLeaveMessageViewController.h"

#import <bytedesk-core/bdcore.h>

@interface BDLeaveMessageViewController ()

@property(nonatomic, strong) UILabel *tipLabel;

@property(nonatomic, strong) NSString *type;
@property(nonatomic, strong) NSString *wid;
@property(nonatomic, strong) NSString *uid;

@end

@implementation BDLeaveMessageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"留言";
    
    // TODO: 界面绘制排版
    self.tipLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 100, 300, 100)];
    self.tipLabel.text = @"请直接查看代码中save函数";
    [self.view addSubview:self.tipLabel];
}

- (void)initWithType:(NSString *)type workGroupWid:(NSString *)wid agentUid:(NSString *)uid {
    self.type = type;
    self.wid = wid;
    self.uid = uid;
}

- (void)save {
    
    [BDCoreApis leaveMessage:self.type withWorkGroupWid:self.wid withAgentUid:self.uid
                  withMobile:@"手机号"
                   withEmail:@"邮箱"
                withNickname:@"昵称"
                withLocation:@"所属区域"
                 withCountry:@"意向国家"
                 withContent:@"留言内容"
               resultSuccess:^(NSDictionary *dict) {
        
    } resultFailed:^(NSError *error) {
        if (error) {
            [QMUITips showError:error.localizedDescription inView:self.view hideAfterDelay:3];
        }
    }];
}


@end
