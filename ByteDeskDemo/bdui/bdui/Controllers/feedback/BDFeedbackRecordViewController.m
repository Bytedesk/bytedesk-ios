//
//  BDFeedbackRecordViewController.m
//  bytedesk-ui
//
//  Created by 宁金鹏 on 2019/7/31.
//  Copyright © 2019 KeFuDaShi. All rights reserved.
//

#import "BDFeedbackRecordViewController.h"

#import <bytedesk-core/bdcore.h>

@interface BDFeedbackRecordViewController ()

@property(nonatomic, strong) UIRefreshControl *mRefreshControl;
//@property(nonatomic, strong) BDFeedbackModel *mFeedbackModel;

@property(nonatomic, strong) NSMutableArray *mFeedbackArray;

@end

@implementation BDFeedbackRecordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //
    self.title = @"我的反馈";
    //
    self.mFeedbackArray = [[NSMutableArray alloc] init];
    //
    self.mRefreshControl = [[UIRefreshControl alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
    [self.tableView addSubview:self.mRefreshControl];
    [self.mRefreshControl addTarget:self action:@selector(refreshControlSelector) forControlEvents:UIControlEventValueChanged];
    //
    [self.mRefreshControl beginRefreshing];
    [self getFeedbackRecords];
}

#pragma mark - <UITableViewDataSource, UITableViewDelegate>

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.mFeedbackArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    // Configure the cell...
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    //
    BDFeedbackModel *feedbackModel = [self.mFeedbackArray objectAtIndex:indexPath.row];
    cell.textLabel.text = feedbackModel.content;
    if ([feedbackModel.replyContent isKindOfClass:[NSNull class]]) {
        cell.detailTextLabel.text = @"暂未回复";
    } else {
        cell.detailTextLabel.text = feedbackModel.replyContent;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
//    BDFeedbackModel *feedbackModel = [self.mFeedbackArray objectAtIndex:indexPath.row];
    //
}

#pragma mark -

- (void)refreshControlSelector {
    DDLogInfo(@"%s", __PRETTY_FUNCTION__);
    
    [self getFeedbackRecords];
}

#pragma mark -

- (void)getFeedbackRecords {
    //
    [BDCoreApis getFeedbacks:0 withSize:20 resultSuccess:^(NSDictionary *dict) {
        DDLogInfo(@"%s, %@", __PRETTY_FUNCTION__, dict);
        //
        NSNumber *status_code = [dict objectForKey:@"status_code"];
        if ([status_code isEqualToNumber:[NSNumber numberWithInt:200]]) {
            //
            NSMutableArray *feedbackArray = dict[@"data"][@"content"];
            for (NSDictionary *feedbackDict in feedbackArray) {
                BDFeedbackModel *feedbackModel = [[BDFeedbackModel alloc] initWithDictionary:feedbackDict];
                //
                if (![self.mFeedbackArray containsObject:feedbackModel]) {
                    [self.mFeedbackArray addObject:feedbackModel];
                }
            }
            //
            [self.tableView reloadData];
            [self.mRefreshControl endRefreshing];
            //
            if ([self.mFeedbackArray count] == 0) {
                [self showEmptyViewWithText:@"我的反馈" detailText:@"暂无反馈" buttonTitle:nil buttonAction:NULL];
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
