//
//  BDFeedbackCategoryViewController.m
//  bytedesk-ui
//
//  Created by 萝卜丝 on 2019/1/30.
//  Copyright © 2019 KeFuDaShi. All rights reserved.
//

#import "BDFeedbackCategoryViewController.h"
#import "BDFeedbackHistoryViewController.h"

@interface BDFeedbackCategoryViewController ()

@end

@implementation BDFeedbackCategoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"问题分类";
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem qmui_itemWithButton:[[QMUINavigationButton alloc] initWithType:QMUINavigationButtonTypeNormal title:@"历史反馈"] target:self action:@selector(handleTopRightButtonClickEvent)];
    
    
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
#warning Incomplete implementation, return the number of sections
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete implementation, return the number of rows
    return 0;
}

/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/

- (void)handleTopRightButtonClickEvent {
    //
    BDFeedbackHistoryViewController *historyViewController = [[BDFeedbackHistoryViewController alloc] init];
    [self.navigationController pushViewController:historyViewController animated:YES];
}


@end
