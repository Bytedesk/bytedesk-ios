//
//  KFNoticeViewController.m
//  demo
//
//  Created by 萝卜丝 on 2018/12/25.
//  Copyright © 2018 KeFuDaShi. All rights reserved.
//

#import "KFNoticeViewController.h"

#import <bytedesk-core/bdcore.h>

#pragma mark - 暂未上线

@interface KFNoticeViewController ()

@property(nonatomic, strong) UIRefreshControl *mRefreshControl;
@property(nonatomic, strong) NSMutableArray<BDNoticeModel *> *mNoticeArray;

@end

@implementation KFNoticeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    self.mNoticeArray = [[NSMutableArray alloc] init];
    //
    self.mRefreshControl = [[UIRefreshControl alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
    [self.tableView addSubview:self.mRefreshControl];
    [self.mRefreshControl addTarget:self action:@selector(refreshControlSelector) forControlEvents:UIControlEventValueChanged];
    //
    [self refreshControlSelector];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.mNoticeArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    //
    static NSString *identifier = @"threadCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    // Configure the cell...
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
    }
    //
    BDNoticeModel *noticeModel = [self.mNoticeArray objectAtIndex:indexPath.row];
    cell.textLabel.text = noticeModel.title;
    if ([noticeModel.processed boolValue]) {
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%@(已处理)", noticeModel.content];
    } else {
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%@(待处理)", noticeModel.content];
    }
    //
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    DDLogInfo(@"%s", __PRETTY_FUNCTION__);
    
    QMUIDialogSelectionViewController *dialogViewController = [[QMUIDialogSelectionViewController alloc] init];
    dialogViewController.title = @"请选择操作";
    dialogViewController.items = @[@"同意", @"拒绝"];
    dialogViewController.cellForItemBlock = ^(QMUIDialogSelectionViewController *aDialogViewController, QMUITableViewCell *cell, NSUInteger itemIndex) {
        cell.accessoryType = UITableViewCellAccessoryNone;// 移除点击时默认加上右边的checkbox
    };
    dialogViewController.heightForItemBlock = ^CGFloat (QMUIDialogSelectionViewController *aDialogViewController, NSUInteger itemIndex) {
        return 54;
    };
    dialogViewController.didSelectItemBlock = ^(QMUIDialogSelectionViewController *aDialogViewController, NSUInteger itemIndex) {
        BDNoticeModel *noticeModel = [self.mNoticeArray objectAtIndex:itemIndex];
        DDLogInfo(@"%s %@ %lu", __PRETTY_FUNCTION__, noticeModel.title, (unsigned long)itemIndex);
        
        if (itemIndex == 0) {
            DDLogInfo(@"同意");
            
            [BDCoreApis acceptGroupTransfer:noticeModel.nid resultSuccess:^(NSDictionary *dict) {
                
            } resultFailed:^(NSError *error) {
                if (error) {
                    [QMUITips showError:error.localizedDescription inView:self.view hideAfterDelay:3];
                }
            }];
            
        } else {
            DDLogInfo(@"拒绝");
            
            [BDCoreApis rejectGroupTransfer:noticeModel.nid resultSuccess:^(NSDictionary *dict) {
                
            } resultFailed:^(NSError *error) {
                if (error) {
                    [QMUITips showError:error.localizedDescription inView:self.view hideAfterDelay:3];
                }
            }];
        }
        [aDialogViewController hide];
    };
    [dialogViewController show];
    
    
}

#pragma mark - 下拉刷新

- (void)refreshControlSelector {
    DDLogInfo(@"%s", __PRETTY_FUNCTION__);
    
    [BDCoreApis getNoticesPage:0 withSize:20 resultSuccess:^(NSDictionary *dict) {
        
        NSNumber *status_code = [dict objectForKey:@"status_code"];
        if ([status_code isEqualToNumber:[NSNumber numberWithInt:200]]) {
            //
            NSMutableArray *noticeArray = dict[@"data"][@"content"];
            for (NSDictionary *noticeDict in noticeArray) {
                //
                BDNoticeModel *noticeModel = [[BDNoticeModel alloc] initWithDictionary:noticeDict];
                if (![self.mNoticeArray containsObject:noticeModel]) {
                    [self.mNoticeArray addObject:noticeModel];
                }
            }
            //
            [self.tableView reloadData];
            [self.mRefreshControl endRefreshing];
        } else {
            [QMUITips showError:dict[@"message"] inView:self.view hideAfterDelay:2.0f];
            [self.mRefreshControl endRefreshing];
        }
    } resultFailed:^(NSError *error) {
        // 请求会话失败
        [QMUITips showError:@"拉取通知失败" inView:self.view hideAfterDelay:2.0f];
    }];
}


@end
