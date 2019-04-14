//
//  KFVisitorProfileViewController.m
//  demo
//
//  Created by 萝卜丝 on 2018/11/22.
//  Copyright © 2018年 Bytedesk.com. All rights reserved.
//

#import "KFUserinfoViewController.h"
#import <bytedesk-core/bdcore.h>

@interface KFUserinfoViewController ()<QMUITextFieldDelegate>

@property(nonatomic, strong) UIRefreshControl *mRefreshControl;
@property(nonatomic, weak) QMUIDialogTextFieldViewController *currentTextFieldDialogViewController;

@property(nonatomic, strong) NSString *mTitle;
@property(nonatomic, strong) NSString *mNickname;

@property(nonatomic, strong) NSString *mTagkey;
@property(nonatomic, strong) NSString *mTagvalue;

@end

@implementation KFUserinfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.mTitle = @"设置昵称";
    self.mTagkey = @"自定义标签";
    
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
    return section == 1 ? @"自定义用户信息接口" : @"默认用户信息接口";
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    // Configure the cell...
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
    }
    
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            cell.textLabel.text = @"昵称";
            cell.detailTextLabel.text = self.mNickname;
        }
    } else if (indexPath.section == 1) {
        cell.textLabel.text = self.mTagkey;
        cell.detailTextLabel.text = self.mTagvalue;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        
        QMUIDialogTextFieldViewController *dialogViewController = [[QMUIDialogTextFieldViewController alloc] init];
        dialogViewController.title = self.mTitle;
        [dialogViewController addTextFieldWithTitle:@"昵称" configurationHandler:^(QMUILabel *titleLabel, QMUITextField *textField, CALayer *separatorLayer) {
            textField.placeholder = @"不超过10个字符";
            textField.maximumTextLength = 10;
        }];
        [dialogViewController addCancelButtonWithText:@"取消" block:nil];
        [dialogViewController addSubmitButtonWithText:@"确定" block:^(QMUIDialogViewController *aDialogViewController) {
            [aDialogViewController hide];
            // 调用接口设置昵称
            [self saveUserinfo];
        }];
        [dialogViewController show];
        self.currentTextFieldDialogViewController = dialogViewController;
        
    } else {
        //
        QMUIDialogTextFieldViewController *dialogViewController = [[QMUIDialogTextFieldViewController alloc] init];
        dialogViewController.title = self.mTagkey;
        [dialogViewController addTextFieldWithTitle:self.mTagkey configurationHandler:^(QMUILabel *titleLabel, QMUITextField *textField, CALayer *separatorLayer) {
            textField.placeholder = @"不超过10个字符";
            textField.maximumTextLength = 10;
        }];
        [dialogViewController addCancelButtonWithText:@"取消" block:nil];
        [dialogViewController addSubmitButtonWithText:@"确定" block:^(QMUIDialogViewController *aDialogViewController) {
            [aDialogViewController hide];
            //
            [self saveUserinfo];
        }];
        [dialogViewController show];
        //
        self.currentTextFieldDialogViewController = dialogViewController;
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void) saveUserinfo {
    //
    DDLogInfo(@"%s", __PRETTY_FUNCTION__);
    if ([self.currentTextFieldDialogViewController.title isEqualToString:self.mTitle]) {
        // 设置昵称
        self.mNickname = self.currentTextFieldDialogViewController.textFields[0].text;
        [BDCoreApis setNickname:self.mNickname resultSuccess:^(NSDictionary *dict) {
            //
            [self.tableView reloadData];
        } resultFailed:^(NSError *error) {
            DDLogInfo(@"%s %@", __PRETTY_FUNCTION__, error);
            if (error) {
                [QMUITips showError:error.localizedDescription inView:self.view hideAfterDelay:3];
            }
        }];
    } else {
        // 设置自定义标签
        self.mTagvalue = self.currentTextFieldDialogViewController.textFields[0].text;
        [BDCoreApis setFingerPrint:@"自定义标签" withKey:self.mTagkey withValue:self.mTagvalue resultSuccess:^(NSDictionary *dict) {
            //
            [self.tableView reloadData];
        } resultFailed:^(NSError *error) {
            DDLogInfo(@"%s %@", __PRETTY_FUNCTION__, error);
            if (error) {
                [QMUITips showError:error.localizedDescription inView:self.view hideAfterDelay:3];
            }
        }];
    }
}

#pragma mark - <QMUITextFieldDelegate>

- (BOOL)textFieldShouldReturn:(QMUITextField *)textField {
    if (self.currentTextFieldDialogViewController.submitButton.enabled) {
        [self.currentTextFieldDialogViewController hide];
        
    } else {
        //        [QMUITips showSucceed:@"请输入文字" inView:self.currentTextFieldDialogViewController.modalPresentedViewController.view hideAfterDelay:2.0];
    }
    return NO;
}

#pragma mark - Selectors

- (void)refreshControlSelector {
    DDLogInfo(@"%s", __PRETTY_FUNCTION__);
    //
    [BDCoreApis getFingerPrintWithUid:[BDSettings getUid] resultSuccess:^(NSDictionary *dict) {
        DDLogInfo(@"%s, %@, %@", __PRETTY_FUNCTION__, dict, dict[@"data"][@"nickname"]);
        self.mNickname = dict[@"data"][@"nickname"];
        NSMutableArray *fingerPrints = dict[@"data"][@"fingerPrints"];
        for (NSDictionary *fingerPrint in fingerPrints) {
            // DDLogInfo(@"%@ %@", fingerPrint[@"key"], fingerPrint[@"value"]);
            if ([fingerPrint[@"key"] isEqualToString:self.mTagkey]) {
                self.mTagvalue = fingerPrint[@"value"];
            }
        }
        //
        [self.mRefreshControl endRefreshing];
        [self.tableView reloadData];
    } resultFailed:^(NSError *error) {
        DDLogInfo(@"%@", error);
        [self.mRefreshControl endRefreshing];
        if (error) {
            [QMUITips showError:error.localizedDescription inView:self.view hideAfterDelay:3];
        }
    }];
}


@end



