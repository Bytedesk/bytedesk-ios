//
//  KFDSUserinfoViewController.m
//  bdui
//
//  Created by 萝卜丝 on 2018/12/18.
//  Copyright © 2018年 Bytedesk.com. All rights reserved.
//

#import "BDUserinfoViewController.h"
#import <bytedesk-core/bdcore.h>

@interface BDUserinfoViewController ()

@property(nonatomic, assign) BOOL mIsInternetReachable;
@property(nonatomic, strong) UIRefreshControl *mRefreshControl;

@property(nonatomic, strong) BDThreadModel *mThreadModel;

@end

@implementation BDUserinfoViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    //
    [self loadUserinfoAndTags];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"用户信息";
    
    // Do any additional setup after loading the view.
    self.mRefreshControl = [[UIRefreshControl alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
    [self.tableView addSubview:self.mRefreshControl];
    [self.mRefreshControl addTarget:self action:@selector(refreshControlSelector) forControlEvents:UIControlEventValueChanged];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)initWithThreadModel:(BDThreadModel *)threadModel {
    self.mThreadModel = threadModel;
}

- (void)loadUserinfoAndTags {
    //
//    UIView *parentView = self.navigationController.view;
    //
//    [BDCoreApis adminGetUserinfoWithCompanyId:self.mThreadModel.company_id
//                                   withUsername:self.mThreadModel.username
//                                     withClient:self.mThreadModel.client
//                                  resultSuccess:^(NSDictionary *dict) {
//                                      DDLogInfo(@"%s, %@", __PRETTY_FUNCTION__, dict);
//                                  } resultFailed:^(NSError *error) {
//                                      DDLogInfo(@"%s, %@", __PRETTY_FUNCTION__, error);
//                                      [QMUITips showError:@"加载用户信息失败" inView:parentView hideAfterDelay:2.0f];
//                                  }];
//    //
//    [BDCoreApis adminGetTagWithCompanyId:self.mThreadModel.company_id
//                              withUsername:self.mThreadModel.username
//                                withClient:self.mThreadModel.client
//                             resultSuccess:^(NSDictionary *dict) {
//                                 DDLogInfo(@"%s, %@", __PRETTY_FUNCTION__, dict);
//                             } resultFailed:^(NSError *error) {
//                                 DDLogInfo(@"%s, %@", __PRETTY_FUNCTION__, error);
//                                 [QMUITips showError:@"加载用户标签失败" inView:parentView hideAfterDelay:2.0f];
//                             }];
    
}

#pragma mark - Selectors

- (void)refreshControlSelector {
    DDLogInfo(@"%s", __PRETTY_FUNCTION__);

    [self loadUserinfoAndTags];
}


@end












