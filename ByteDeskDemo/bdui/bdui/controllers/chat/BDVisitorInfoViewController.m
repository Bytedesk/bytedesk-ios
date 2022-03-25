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
//@property(nonatomic, strong) NSMutableArray *mInfoArray;

@property(nonatomic, strong) NSString *clientNote;

@property(nonatomic, strong) NSString *name;
@property(nonatomic, strong) NSString *mobile;
@property(nonatomic, strong) NSString *email;
@property(nonatomic, strong) NSString *age;
@property(nonatomic, strong) NSString *job;
@property(nonatomic, strong) NSString *company;
@property(nonatomic, strong) NSString *note;
@property(nonatomic, strong) NSString *tags; // TODO: 待处理

@end

@implementation BDVisitorInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"访客信息";
    //
    UIBarButtonItem *rightItem = [UIBarButtonItem qmui_itemWithTitle:@"取消" target:self action:@selector(handleRightBarButtonItemClicked:)];
//    UIBarButtonItem *rightItem = [UIBarButtonItem qmui_itemWithImage:[UIImage imageNamed:@"bytedesk_plus" inBundle:[NSBundle bundleForClass:self.class] compatibleWithTraitCollection:nil] target:self action:@selector(handleRightBarButtonItemClicked:)];
    self.navigationItem.rightBarButtonItem = rightItem;
    //
//    self.mInfoArray = [[NSMutableArray alloc] init];
    //
//    self.mRefreshControl = [[UIRefreshControl alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
//    [self.tableView addSubview:self.mRefreshControl];
//    [self.mRefreshControl addTarget:self action:@selector(refreshControlSelector) forControlEvents:UIControlEventValueChanged];
//    [self.mRefreshControl beginRefreshing];
    //
    [self getUserProfileByUid];
    [self getCustomerByUid];
}

- (void)initWithUid:(NSString *)uid {
    self.mUid = uid;
}

//- (void)viewWillAppear:(BOOL)animated {
//    [super viewWillAppear:animated];
//    //
////    [self getDeviceInfo];
//}

- (void)handleRightBarButtonItemClicked:(id)sender {
    DDLogInfo(@"%s", __PRETTY_FUNCTION__);
    
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

#pragma mark - <UITableViewDataSource, UITableViewDelegate>

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//    return [self.mInfoArray count];
    return 9;
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
//    cell.textLabel.text = [self.mInfoArray objectAtIndex:indexPath.row];
    
    if (indexPath.row == 0) {
        cell.textLabel.text = @"客户端备注";
        cell.detailTextLabel.text = self.clientNote;
    } else if (indexPath.row == 1) {
        cell.textLabel.text = @"姓名";
        cell.detailTextLabel.text = self.name;
    } else if (indexPath.row == 2) {
        cell.textLabel.text = @"手机";
        cell.detailTextLabel.text = self.mobile;
    } else if (indexPath.row == 3) {
        cell.textLabel.text = @"邮箱";
        cell.detailTextLabel.text = self.email;
    } else if (indexPath.row == 4) {
        cell.textLabel.text = @"年龄";
        cell.detailTextLabel.text = self.age;
    } else if (indexPath.row == 5) {
        cell.textLabel.text = @"职业";
        cell.detailTextLabel.text = self.job;
    } else if (indexPath.row == 6) {
        cell.textLabel.text = @"公司";
        cell.detailTextLabel.text = self.company;
    } else if (indexPath.row == 7) {
        cell.textLabel.text = @"备注";
        cell.detailTextLabel.text = self.note;
    } else if (indexPath.row == 8) {
        cell.textLabel.text = @"标签";
        cell.detailTextLabel.text = self.tags;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.row == 1) {
        
    } else if (indexPath.row == 2) {
        
    } else if (indexPath.row == 3) {
        
    } else if (indexPath.row == 4) {
        
    } else if (indexPath.row == 5) {
        
    } else if (indexPath.row == 6) {
        
    } else if (indexPath.row == 7) {
        
    } else if (indexPath.row == 8) {
        
    }
}

#pragma mark -

//- (void)refreshControlSelector {
//    DDLogInfo(@"%s", __PRETTY_FUNCTION__);
//
//    [self getDeviceInfo];
//}


- (void)getUserProfileByUid {
    UIView *parentView = self.navigationController.view;
    
    [BDCoreApis getUserProfileByUid:self.mUid resultSuccess:^(NSDictionary *dict) {
        DDLogInfo(@"%s, %@", __PRETTY_FUNCTION__, dict);
//        NSString *message = [dict objectForKey:@"message"];
        NSNumber *status_code = [dict objectForKey:@"status_code"];
        if ([status_code isEqualToNumber:[NSNumber numberWithInt:200]]) {
            self.clientNote = dict[@"data"][@"description"];
            //
            [self.tableView reloadData];
        } else {
//            [QMUITips showError:message inView:parentView hideAfterDelay:2.0f];
        }
    } resultFailed:^(NSError *error) {
        [QMUITips showError:@"加载失败" inView:parentView hideAfterDelay:2.0f];
    }];
}

- (void)getCustomerByUid {
    UIView *parentView = self.navigationController.view;
    
    [BDCoreApis getCustomerByUid:self.mUid resultSuccess:^(NSDictionary *dict) {
        DDLogInfo(@"%s, %@", __PRETTY_FUNCTION__, dict);
//        NSString *message = [dict objectForKey:@"message"];
        NSNumber *status_code = [dict objectForKey:@"status_code"];
        if ([status_code isEqualToNumber:[NSNumber numberWithInt:200]]) {
            self.name = dict[@"data"][@"name"];
            self.mobile = dict[@"data"][@"mobile"];
            self.email = dict[@"data"][@"email"];
            self.age = dict[@"data"][@"age"];
            self.job = dict[@"data"][@"job"];
            self.company = dict[@"data"][@"company"];
            self.note = dict[@"data"][@"note"];
            //
            [self.tableView reloadData];
        } else {
//            [QMUITips showError:message inView:parentView hideAfterDelay:2.0f];
        }
    } resultFailed:^(NSError *error) {
        [QMUITips showError:@"加载失败" inView:parentView hideAfterDelay:2.0f];
    }];
}


- (void)getDeviceInfo {
    //
//    [BDCoreApis getDeviceInfoByUid:self.mUid resultSuccess:^(NSDictionary *dict) {
////        DDLogInfo(@"%s, %@", __PRETTY_FUNCTION__, dict);
//        //
//        NSNumber *status_code = [dict objectForKey:@"status_code"];
//        if ([status_code isEqualToNumber:[NSNumber numberWithInt:200]]) {
//            //
//            NSMutableArray *infoArray = dict[@"data"];
//            for (NSDictionary *infoDict in infoArray) {
//                NSString *name = infoDict[@"name"];
//                NSString *value = infoDict[@"value"];
////                NSString *key = infoDict[@"key"];
//                //
//                NSString *title = [NSString stringWithFormat:@"%@:%@", name, value];
//                [self.mInfoArray addObject:title];
//            }
//            //
//            [self.tableView reloadData];
////            [self.mRefreshControl endRefreshing];
//        } else {
//            //
//            NSString *message = dict[@"message"];
//            [QMUITips showError:message inView:self.view hideAfterDelay:2];
//        }
//    } resultFailed:^(NSError *error) {
//        DDLogError(@"%s %@", __PRETTY_FUNCTION__, error);
//        //
//        if (error) {
//            [QMUITips showError:error.localizedDescription inView:self.view hideAfterDelay:2];
//        }
//    }];
}


@end
