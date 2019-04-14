//
//  KFFriendViewController.m
//  demo
//
//  Created by 萝卜丝 on 2018/12/23.
//  Copyright © 2018 KeFuDaShi. All rights reserved.
//

#import "KFFriendViewController.h"
#import "KFContactTableViewCell.h"

#import <bytedesk-core/bdcore.h>

@interface KFFriendViewController ()<UITabBarDelegate>

@property(nonatomic, strong) UITabBar *tabBar;
@property(nonatomic, strong) NSMutableArray *mContactArray;

@end

@implementation KFFriendViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    //
    self.mContactArray = [[NSMutableArray alloc] init];
    
    // 双击 tabBarItem 的回调
    __weak __typeof(self)weakSelf = self;
    void (^tabBarItemDoubleTapBlock)(UITabBarItem *tabBarItem, NSInteger index) = ^(UITabBarItem *tabBarItem, NSInteger index) {
        [QMUITips showInfo:[NSString stringWithFormat:@"双击了第 %@ 个 tab", @(index + 1)] inView:weakSelf.view hideAfterDelay:1.2];
    };
    
    self.tabBar = [[UITabBar alloc] init];
    self.tabBar.tintColor = TabBarTintColor;
    
    UITabBarItem *item0 = [QDUIHelper tabBarItemWithTitle:@"测试用户" image:[UIImageMake(@"icon_tabbar_contact") imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] selectedImage:UIImageMake(@"icon_tabbar_contact_selected") tag:0];
    item0.qmui_doubleTapBlock = tabBarItemDoubleTapBlock;
    
    UITabBarItem *item1 = [QDUIHelper tabBarItemWithTitle:@"关注" image:[UIImageMake(@"icon_tabbar_contact") imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] selectedImage:UIImageMake(@"icon_tabbar_contact_selected") tag:1];
    item1.qmui_doubleTapBlock = tabBarItemDoubleTapBlock;
    
    UITabBarItem *item2 = [QDUIHelper tabBarItemWithTitle:@"粉丝" image:[UIImageMake(@"icon_tabbar_keypad") imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] selectedImage:UIImageMake(@"icon_tabbar_keypad_selected") tag:2];
    item2.qmui_doubleTapBlock = tabBarItemDoubleTapBlock;
    
    // 好友 == 互相关注
    UITabBarItem *item3 = [QDUIHelper tabBarItemWithTitle:@"好友" image:[UIImageMake(@"icon_tabbar_recent") imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] selectedImage:UIImageMake(@"icon_tabbar_recent_selected") tag:3];
    item3.qmui_doubleTapBlock = tabBarItemDoubleTapBlock;
    
    UITabBarItem *item4 = [QDUIHelper tabBarItemWithTitle:@"黑名单" image:[UIImageMake(@"icon_tabbar_setting") imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] selectedImage:UIImageMake(@"icon_tabbar_setting_selected") tag:4];
    item4.qmui_doubleTapBlock = tabBarItemDoubleTapBlock;
    
    self.tabBar.items = @[item0, item1, item2, item3, item4];
    self.tabBar.selectedItem = item0;
    self.tabBar.delegate = self;
    [self.tabBar sizeToFit];
    [self.view addSubview:self.tabBar];
    
    // 从服务器加载联系人作为测试数据
    [self getTestUsers];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    CGFloat tabBarHeight = TabBarHeight;
    self.tabBar.frame = CGRectMake(0, CGRectGetHeight(self.view.bounds) - tabBarHeight, CGRectGetWidth(self.view.bounds), tabBarHeight);
}

#pragma mark - 分别加载相应数据

- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item {
    DDLogInfo(@"tab item %@ clicked", @(item.tag + 1));
    
    [self.mContactArray removeAllObjects];
    
    if (item.tag == 0) {
        // 从服务器加载联系人作为测试数据
        [self getTestUsers];
    } else if (item.tag == 1) {
        // 从服务器加载我关注的
        [BDCoreApis getFollowsPage:0 withSize:20 resultSuccess:^(NSDictionary *dict) {
            DDLogInfo(@"%s %@", __PRETTY_FUNCTION__, dict);
            [self dealWithDict:dict];
        } resultFailed:^(NSError *error) {
            DDLogError(@"%s %@", __PRETTY_FUNCTION__, error);
            if (error) {
                [QMUITips showError:error.localizedDescription inView:self.view hideAfterDelay:3];
            }
        }];
    } else if (item.tag == 2) {
        // 从服务器加载我的粉丝
        [BDCoreApis getFansPage:0 withSize:20 resultSuccess:^(NSDictionary *dict) {
            DDLogInfo(@"%s %@", __PRETTY_FUNCTION__, dict);
            [self dealWithDict:dict];
        } resultFailed:^(NSError *error) {
            DDLogError(@"%s %@", __PRETTY_FUNCTION__, error);
            if (error) {
                [QMUITips showError:error.localizedDescription inView:self.view hideAfterDelay:3];
            }
        }];
    } else if (item.tag == 3) {
        // 从服务器加载我的好友：互相关注
        [BDCoreApis getFriendsPage:0 withSize:20 resultSuccess:^(NSDictionary *dict) {
            DDLogInfo(@"%s %@", __PRETTY_FUNCTION__, dict);
            [self dealWithDict:dict];
        } resultFailed:^(NSError *error) {
            DDLogError(@"%s %@", __PRETTY_FUNCTION__, error);
            if (error) {
                [QMUITips showError:error.localizedDescription inView:self.view hideAfterDelay:3];
            }
        }];
    } else if (item.tag == 4) {
        // 从服务器加载我的黑名单
        [BDCoreApis getBlocksPage:0 withSize:20 resultSuccess:^(NSDictionary *dict) {
            DDLogInfo(@"%s %@", __PRETTY_FUNCTION__, dict);
            //
            NSMutableArray *blockedArray = dict[@"data"][@"content"];
            for (NSDictionary *blockedDict in blockedArray) {
                //
                BDContactModel *contactModel = [[BDContactModel alloc] initWithDictionary:blockedDict[@"blockedUser"]];
                // 过滤掉当前登录用户
                if (![contactModel.uid isEqualToString:[BDSettings getUid]]) {
                    [self.mContactArray addObject:contactModel];
                }
            }
            // 刷新table数据
            [self reloadTable];
        } resultFailed:^(NSError *error) {
            DDLogError(@"%s %@", __PRETTY_FUNCTION__, error);
            if (error) {
                [QMUITips showError:error.localizedDescription inView:self.view hideAfterDelay:3];
            }
        }];
    }
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.mContactArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    //
    static NSString *identifier = @"threadCell";
    KFContactTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[KFContactTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    // 联系人
    BDContactModel *rosterModel = self.mContactArray[indexPath.row];
    [cell initWithRelationModel:rosterModel];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    __weak __typeof(self)weakSelf = self;
//    NSInteger tag = self.tabBar.selectedItem.tag;
    BDContactModel *contactModel = [self.mContactArray objectAtIndex:indexPath.row];
    
    QMUIDialogSelectionViewController *dialogViewController = [[QMUIDialogSelectionViewController alloc] init];
    dialogViewController.title = @"请选择操作";
    dialogViewController.items = @[@"添加关注", @"取消关注", @"拉黑", @"取消拉黑", @"添加好友", @"删除好友"];
    dialogViewController.cellForItemBlock = ^(QMUIDialogSelectionViewController *aDialogViewController, QMUITableViewCell *cell, NSUInteger itemIndex) {
        cell.accessoryType = UITableViewCellAccessoryNone;// 移除点击时默认加上右边的checkbox
    };
    dialogViewController.heightForItemBlock = ^CGFloat (QMUIDialogSelectionViewController *aDialogViewController, NSUInteger itemIndex) {
        return 54;// 修改默认的行高，默认为 TableViewCellNormalHeight
    };
    dialogViewController.didSelectItemBlock = ^(QMUIDialogSelectionViewController *aDialogViewController, NSUInteger itemIndex) {
        DDLogInfo(@"%s %@ %lu", __PRETTY_FUNCTION__, contactModel.real_name, (unsigned long)itemIndex);
        
        if (itemIndex == 0) {
            // 添加关注
            [BDCoreApis addFollow:contactModel.uid resultSuccess:^(NSDictionary *dict) {
                DDLogInfo(@"%s %@", __PRETTY_FUNCTION__, dict);
                //
                NSString *message = [dict objectForKey:@"message"];
                NSNumber *status_code = [dict objectForKey:@"status_code"];
                if ([status_code isEqualToNumber:[NSNumber numberWithInt:200]]) {
                    //
                    [QMUITips showInfo:message inView:weakSelf.view hideAfterDelay:1.2];
                } else {
                    //
                    [QMUITips showError:message inView:weakSelf.view hideAfterDelay:1.2];
                }
            } resultFailed:^(NSError *error) {
                DDLogError(@"%s %@", __PRETTY_FUNCTION__, error);
                if (error) {
                    [QMUITips showError:error.localizedDescription inView:self.view hideAfterDelay:3];
                }
            }];
            
        } else if (itemIndex == 1) {
            // 取消关注
            [BDCoreApis unFollow:contactModel.uid resultSuccess:^(NSDictionary *dict) {
                DDLogInfo(@"%s %@", __PRETTY_FUNCTION__, dict);
                //
                NSString *message = [dict objectForKey:@"message"];
                NSNumber *status_code = [dict objectForKey:@"status_code"];
                if ([status_code isEqualToNumber:[NSNumber numberWithInt:200]]) {
                    //
                    [self.mContactArray removeObject:contactModel];
                    [self reloadTable];
                    //
                    [QMUITips showInfo:message inView:weakSelf.view hideAfterDelay:1.2];
                } else {
                    //
                    [QMUITips showError:message inView:weakSelf.view hideAfterDelay:1.2];
                }
            } resultFailed:^(NSError *error) {
                DDLogError(@"%s %@", __PRETTY_FUNCTION__, error);
                if (error) {
                    [QMUITips showError:error.localizedDescription inView:self.view hideAfterDelay:3];
                }
            }];
            
        } else if (itemIndex == 2) {
            // 拉黑
            [BDCoreApis addBlock:contactModel.uid withNote:@"备注内容" resultSuccess:^(NSDictionary *dict) {
                DDLogInfo(@"%s %@", __PRETTY_FUNCTION__, dict);
                //
                NSString *message = [dict objectForKey:@"message"];
                NSNumber *status_code = [dict objectForKey:@"status_code"];
                if ([status_code isEqualToNumber:[NSNumber numberWithInt:200]]) {
                    //
                    [QMUITips showInfo:message inView:weakSelf.view hideAfterDelay:1.2];
                } else {
                    //
                    [QMUITips showError:message inView:weakSelf.view hideAfterDelay:1.2];
                }
            } resultFailed:^(NSError *error) {
                DDLogError(@"%s %@", __PRETTY_FUNCTION__, error);
                if (error) {
                    [QMUITips showError:error.localizedDescription inView:self.view hideAfterDelay:3];
                }
            }];
        } else if (itemIndex == 3) {
            // 取消拉黑
            [BDCoreApis unBlock:contactModel.uid resultSuccess:^(NSDictionary *dict) {
                DDLogInfo(@"%s %@", __PRETTY_FUNCTION__, dict);
                //
                NSString *message = [dict objectForKey:@"message"];
                NSNumber *status_code = [dict objectForKey:@"status_code"];
                if ([status_code isEqualToNumber:[NSNumber numberWithInt:200]]) {
                    //
                    [self.mContactArray removeObject:contactModel];
                    [self reloadTable];
                    //
                    [QMUITips showInfo:message inView:weakSelf.view hideAfterDelay:1.2];
                } else {
                    //
                    [QMUITips showError:message inView:weakSelf.view hideAfterDelay:1.2];
                }
            } resultFailed:^(NSError *error) {
                DDLogError(@"%s %@", __PRETTY_FUNCTION__, error);
                if (error) {
                    [QMUITips showError:error.localizedDescription inView:self.view hideAfterDelay:3];
                }
            }];
        } else if (itemIndex == 4) {
            // 添加好友
            [BDCoreApis addFriend:contactModel.uid resultSuccess:^(NSDictionary *dict) {
                DDLogInfo(@"%s %@", __PRETTY_FUNCTION__, dict);
                //
                NSString *message = [dict objectForKey:@"message"];
                NSNumber *status_code = [dict objectForKey:@"status_code"];
                if ([status_code isEqualToNumber:[NSNumber numberWithInt:200]]) {
                    //
                    [QMUITips showInfo:message inView:weakSelf.view hideAfterDelay:1.2];
                } else {
                    //
                    [QMUITips showError:message inView:weakSelf.view hideAfterDelay:1.2];
                }
            } resultFailed:^(NSError *error) {
                DDLogError(@"%s %@", __PRETTY_FUNCTION__, error);
                if (error) {
                    [QMUITips showError:error.localizedDescription inView:self.view hideAfterDelay:3];
                }
            }];
            
        } else if (itemIndex == 5) {
            // 删除好友
            [BDCoreApis removeFriend:contactModel.uid resultSuccess:^(NSDictionary *dict) {
                DDLogInfo(@"%s %@", __PRETTY_FUNCTION__, dict);
                //
                NSString *message = [dict objectForKey:@"message"];
                NSNumber *status_code = [dict objectForKey:@"status_code"];
                if ([status_code isEqualToNumber:[NSNumber numberWithInt:200]]) {
                    //
                    [self.mContactArray removeObject:contactModel];
                    [self reloadTable];
                    //
                    [QMUITips showInfo:message inView:weakSelf.view hideAfterDelay:1.2];
                } else {
                    //
                    [QMUITips showError:message inView:weakSelf.view hideAfterDelay:1.2];
                }
            } resultFailed:^(NSError *error) {
                DDLogError(@"%s %@", __PRETTY_FUNCTION__, error);
                if (error) {
                    [QMUITips showError:error.localizedDescription inView:self.view hideAfterDelay:3];
                }
            }];
        }
        
        [aDialogViewController hide];
    };
    [dialogViewController show];
}


#pragma mark -


- (void)getTestUsers {
    // 从服务器加载联系人作为测试数据
    [BDCoreApis getContactsResultSuccess:^(NSDictionary *dict) {
        DDLogInfo(@"%s %@", __PRETTY_FUNCTION__, dict);
        //
        NSMutableArray *contactArray = dict[@"data"];
        for (NSDictionary *contactDict in contactArray) {
            //
            BDContactModel *contactModel = [[BDContactModel alloc] initWithDictionary:contactDict];
            // 过滤掉当前登录用户
            if (![contactModel.uid isEqualToString:[BDSettings getUid]]) {
                [self.mContactArray addObject:contactModel];
            }
        }
        // 刷新table数据
        [self reloadTable];
    } resultFailed:^(NSError *error) {
        DDLogError(@"%s %@", __PRETTY_FUNCTION__, error);
        if (error) {
            [QMUITips showError:error.localizedDescription inView:self.view hideAfterDelay:3];
        }
    }];
}

// 解析获取的数据
- (void)dealWithDict:(NSDictionary *)dict {
    
    NSString *message = [dict objectForKey:@"message"];
    NSNumber *status_code = [dict objectForKey:@"status_code"];
    if ([status_code isEqualToNumber:[NSNumber numberWithInt:200]]) {
        //
        NSMutableArray *contactArray = dict[@"data"][@"content"];
        for (NSDictionary *contactDict in contactArray) {
            //
            BDContactModel *contactModel = [[BDContactModel alloc] initWithDictionary:contactDict];
            // 过滤掉当前登录用户
            if (![contactModel.uid isEqualToString:[BDSettings getUid]]) {
                [self.mContactArray addObject:contactModel];
            }
        }
        // 刷新table数据
        [self reloadTable];
    } else {
        //
        [QMUITips showError:message inView:self.view hideAfterDelay:1.2];
    }
}

- (void)reloadTable {
    // 刷新数据
    [self.tableView reloadData];
}



@end
