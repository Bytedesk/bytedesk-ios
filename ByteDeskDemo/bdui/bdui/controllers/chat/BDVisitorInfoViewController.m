//
//  BDVisitorInfoViewController.m
//  bytedesk-ui
//
//  Created by 宁金鹏 on 2020/9/25.
//  Copyright © 2020 KeFuDaShi. All rights reserved.
//

#import "BDVisitorInfoViewController.h"

#import <bytedesk-core/bdcore.h>

@interface BDVisitorInfoViewController ()

@property(nonatomic, strong) NSString *mUid;
//
//@property(nonatomic, strong) UIRefreshControl *mRefreshControl;
@property(nonatomic, strong) BDCategoryModel *mCategoryModel;
@property(nonatomic, strong) NSMutableArray *mInfoArray;

@end

@implementation BDVisitorInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"访客信息";
    //
    self.mInfoArray = [[NSMutableArray alloc] init];
    //
//    self.mRefreshControl = [[UIRefreshControl alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
//    [self.tableView addSubview:self.mRefreshControl];
//    [self.mRefreshControl addTarget:self action:@selector(refreshControlSelector) forControlEvents:UIControlEventValueChanged];
//    [self.mRefreshControl beginRefreshing];
    
}

- (void)initWithUid:(NSString *)uid {
    self.mUid = uid;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    //
    [self getDeviceInfo];
}

#pragma mark - <UITableViewDataSource, UITableViewDelegate>

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.mInfoArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    // Configure the cell...
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
//        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    //
    cell.textLabel.text = [self.mInfoArray objectAtIndex:indexPath.row];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark -

//- (void)refreshControlSelector {
//    DDLogInfo(@"%s", __PRETTY_FUNCTION__);
//
//    [self getDeviceInfo];
//}


- (void)getDeviceInfo {
    //
    [BDCoreApis getDeviceInfoByUid:self.mUid resultSuccess:^(NSDictionary *dict) {
//        DDLogInfo(@"%s, %@", __PRETTY_FUNCTION__, dict);
        //
        NSNumber *status_code = [dict objectForKey:@"status_code"];
        if ([status_code isEqualToNumber:[NSNumber numberWithInt:200]]) {
            //
            NSMutableArray *infoArray = dict[@"data"];
            for (NSDictionary *infoDict in infoArray) {
                NSString *name = infoDict[@"name"];
                NSString *value = infoDict[@"value"];
//                NSString *key = infoDict[@"key"];
                //
                NSString *title = [NSString stringWithFormat:@"%@:%@", name, value];
                [self.mInfoArray addObject:title];
            }
            //
            [self.tableView reloadData];
//            [self.mRefreshControl endRefreshing];
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
