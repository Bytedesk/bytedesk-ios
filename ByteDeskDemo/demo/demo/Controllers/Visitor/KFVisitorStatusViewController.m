//
//  KFVisitorStatusViewController.m
//  demo
//
//  Created by 宁金鹏 on 2017/11/22.
//  Copyright © 2017年 Bytedesk.com. All rights reserved.
//

#import "KFVisitorStatusViewController.h"
#import <bytedesk-core/bdcore.h>

@interface KFVisitorStatusViewController ()

@property(nonatomic, strong) UIRefreshControl *mRefreshControl;
@property(nonatomic, weak) QMUIDialogTextFieldViewController *currentTextFieldDialogViewController;

@property(nonatomic, strong) NSString *mDefaultWorkgroupWid;
@property(nonatomic, strong) NSString *mWorkgroupStatus;

@property(nonatomic, strong) NSString *mDefaultAgentname;
@property(nonatomic, strong) NSString *mAgentStatus;

@end

@implementation KFVisitorStatusViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.mDefaultWorkgroupWid = @"201807171659201";
    self.mDefaultAgentname = @"270580156@qq.com";
    
    // Do any additional setup after loading the view.
    self.mRefreshControl = [[UIRefreshControl alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
    [self.tableView addSubview:self.mRefreshControl];
    [self.mRefreshControl addTarget:self action:@selector(refreshControlSelector) forControlEvents:UIControlEventValueChanged];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    //
    [self refreshControlSelector];
}


#pragma mark - <UITableViewDataSource, UITableViewDelegate>

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return section == 1 ? @"客服账号在线状态接口" : @"工作组在线状态接口";
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    // Configure the cell...
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
    }
    
    //
    if (indexPath.section == 0) {
        cell.textLabel.text = [NSString stringWithFormat:@"工作组:%@", self.mDefaultWorkgroupWid];
        cell.detailTextLabel.text = self.mWorkgroupStatus;
    }
    else {
        cell.textLabel.text = [NSString stringWithFormat:@"客服账号:%@", self.mDefaultAgentname];
        cell.detailTextLabel.text = self.mAgentStatus;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - Selectors

- (void)refreshControlSelector {
    NSLog(@"%s", __PRETTY_FUNCTION__);
    
    // 查询工作组在线状态
    [BDCoreApis visitorGetWorkGroupStatus:@"201807171659201" resultSuccess:^(NSDictionary *dict) {
//        NSString *workgroupId = dict[@"data"][@"workgroup_id"];
//        // 注：online代表在线，offline代表离线
//        NSString *status = dict[@"data"][@"status"];
//        NSLog(@"id: %@, status:%@", workgroupId, status);
//        self.mWorkgroupStatus = status;
        //
        [self.mRefreshControl endRefreshing];
        [self.tableView reloadData];
    } resultFailed:^(NSError *error) {
        NSLog(@"%@", error);
        [self.mRefreshControl endRefreshing];
    }];
    
    // 查询客服账号在线状态
    [BDCoreApis visitorGetAgentStatus:self.mDefaultAgentname resultSuccess:^(NSDictionary *dict) {
//        NSString *agentname = dict[@"data"][@"agent"];
//        // 注：online代表在线，offline代表离线
//        NSString *status = dict[@"data"][@"status"];
//        NSLog(@"agent:%@, status:%@", agentname, status);
//        self.mAgentStatus = status;
        //
        [self.mRefreshControl endRefreshing];
        [self.tableView reloadData];
    } resultFailed:^(NSError *error) {
        NSLog(@"%@", error);
        [self.mRefreshControl endRefreshing];
    }];
}


@end






