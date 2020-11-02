//
//  BDChatCuwViewController.m
//  bytedesk-ui
//
//  Created by 宁金鹏 on 2020/9/22.
//  Copyright © 2020 KeFuDaShi. All rights reserved.
//

#import "BDCuwViewController.h"

#import <bytedesk-core/bdcore.h>

@interface BDCuwViewController ()

@property(nonatomic, strong) NSMutableArray *mCuwArray;

@end

@implementation BDCuwViewController

@synthesize delegate;

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    //
    [self getCuws];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"常用语";
    // Do any additional setup after loading the view.
    // TODO: 下一版添加
//    UIBarButtonItem *rightItem = [UIBarButtonItem qmui_itemWithImage:[UIImage imageNamed:@"bytedesk_plus" inBundle:[NSBundle bundleForClass:self.class] compatibleWithTraitCollection:nil] target:self action:@selector(handleRightBarButtonItemClicked:)];
//    self.navigationItem.rightBarButtonItem = rightItem;
    //
    self.mCuwArray = [[NSMutableArray alloc] init];
    //
//    self.mRefreshControl = [[UIRefreshControl alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
//    [self.tableView addSubview:self.mRefreshControl];
//    [self.mRefreshControl addTarget:self action:@selector(refreshControlSelector) forControlEvents:UIControlEventValueChanged];
//    [self.mRefreshControl beginRefreshing];
}

- (void)handleRightBarButtonItemClicked:(id)sender {
    DDLogInfo(@"%s", __PRETTY_FUNCTION__);
    
    // TODO: 添加常用语
    // 返回聊天页面
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

#pragma mark - <UITableViewDataSource, UITableViewDelegate>

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.mCuwArray count];
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
    cell.textLabel.text = [self.mCuwArray objectAtIndex:indexPath.row];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    //
    NSString *content = [self.mCuwArray objectAtIndex:indexPath.row];
    // 执行回调
    if ([delegate respondsToSelector:@selector(cuwSelected:)]) {
        [delegate performSelector:@selector(cuwSelected:) withObject:content];
    }
    // 返回聊天页面
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

#pragma mark - 加载

- (void)getCuws {
    //
    [BDCoreApis getCuwsWithResultSuccess:^(NSDictionary *dict) {
//        DDLogInfo(@"%s, %@", __PRETTY_FUNCTION__, dict);
        //
        NSNumber *status_code = [dict objectForKey:@"status_code"];
        if ([status_code isEqualToNumber:[NSNumber numberWithInt:200]]) {
            //
            NSMutableArray *mineArray = dict[@"data"][@"mine"];
            for (NSDictionary *categoryDict in mineArray) {
                NSMutableArray *cuwChildren = categoryDict[@"cuwChildren"];
                for (NSDictionary *cuwDict in cuwChildren) {
//                    NSString *name = cuwDict[@"name"];
                    NSString *content = cuwDict[@"content"];
                    //
                    [self.mCuwArray addObject:content];
                }
            }
            //
            NSMutableArray *companyArray = dict[@"data"][@"company"];
            for (NSDictionary *categoryDict in companyArray) {
                NSMutableArray *cuwChildren = categoryDict[@"cuwChildren"];
                for (NSDictionary *cuwDict in cuwChildren) {
//                    NSString *name = cuwDict[@"name"];
                    NSString *content = cuwDict[@"content"];
                    //
                    [self.mCuwArray addObject:content];
                }
            }
            //
            NSMutableArray *platformArray = dict[@"data"][@"platform"];
            for (NSDictionary *categoryDict in platformArray) {
                NSMutableArray *cuwChildren = categoryDict[@"cuwChildren"];
                for (NSDictionary *cuwDict in cuwChildren) {
//                    NSString *name = cuwDict[@"name"];
                    NSString *content = cuwDict[@"content"];
                    //
                    [self.mCuwArray addObject:content];
                }
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
