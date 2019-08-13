//
//  BDTicketRecordViewController.m
//  bytedesk-ui
//
//  Created by 宁金鹏 on 2019/7/31.
//  Copyright © 2019 KeFuDaShi. All rights reserved.
//

#import "BDTicketRecordViewController.h"

#import <bytedesk-core/bdcore.h>

@interface BDTicketRecordViewController ()

@property(nonatomic, strong) UIRefreshControl *mRefreshControl;
@property(nonatomic, strong) BDTicketModel *mTicketModel;

@property(nonatomic, strong) NSMutableArray *mTicketArray;

@end

@implementation BDTicketRecordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"我的工单";
    //
    self.mTicketArray = [[NSMutableArray alloc] init];
    //
    self.mRefreshControl = [[UIRefreshControl alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
    [self.tableView addSubview:self.mRefreshControl];
    [self.mRefreshControl addTarget:self action:@selector(refreshControlSelector) forControlEvents:UIControlEventValueChanged];
    //
    [self.mRefreshControl beginRefreshing];
    [self getTicketRecords];
}

#pragma mark - <UITableViewDataSource, UITableViewDelegate>

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.mTicketArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    // Configure the cell...
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    //
    BDTicketModel *feedbackModel = [self.mTicketArray objectAtIndex:indexPath.row];
    cell.textLabel.text = feedbackModel.content;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    //
}

#pragma mark -

- (void)refreshControlSelector {
    DDLogInfo(@"%s", __PRETTY_FUNCTION__);
    
    [self getTicketRecords];
}

#pragma mark -

- (void)getTicketRecords {
    //
    [BDCoreApis getTickets:0 withSize:20 resultSuccess:^(NSDictionary *dict) {
        DDLogInfo(@"%s, %@", __PRETTY_FUNCTION__, dict);
        //
        NSNumber *status_code = [dict objectForKey:@"status_code"];
        if ([status_code isEqualToNumber:[NSNumber numberWithInt:200]]) {
            //
            NSMutableArray *ticketArray = dict[@"data"][@"content"];
            for (NSDictionary *ticketDict in ticketArray) {
                BDTicketModel *ticketModel = [[BDTicketModel alloc] initWithDictionary:ticketDict];
                //
//                if (![self.mTicketArray containsObject:ticketModel]) {
                    [self.mTicketArray addObject:ticketModel];
//                }
            }
            //
            [self.tableView reloadData];
            [self.mRefreshControl endRefreshing];
            //
            if ([self.mTicketArray count] == 0) {
                [self showEmptyViewWithText:@"我的工单" detailText:@"暂无工单" buttonTitle:nil buttonAction:NULL];
            }
            else {
                [self hideEmptyView];
            }
            
        } else {
            //
            NSString *message = dict[@"message"];
            [QMUITips showError:message inView:self.view hideAfterDelay:2];
        }
    } resultFailed:^(NSError *error) {
        DDLogError(@"%s %@", __PRETTY_FUNCTION__, error);
        //
        if (error) {
            [QMUITips showError:error.localizedDescription inView:self.view hideAfterDelay:2];
        }
    }];
}

@end
