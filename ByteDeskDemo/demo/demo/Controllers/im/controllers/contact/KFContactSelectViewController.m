//
//  KFContactSelectViewController.m
//  bytedesk
//
//  Created by 萝卜丝 on 2018/12/11.
//  Copyright © 2018 萝卜丝. All rights reserved.
//

#import "KFContactSelectViewController.h"
#import "KFContactTableViewCell.h"
#import "KFDetailViewController.h"

@interface KFContactSearchView : UIView

@property(nonatomic, strong) QMUILabel *titleLabel;
@property(nonatomic, strong) QMUIFloatLayoutView *floatLayoutView;

@end

@implementation KFContactSearchView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = UIColorWhite;
        
        self.titleLabel = [[QMUILabel alloc] init];
        self.titleLabel.font = [UIFont systemFontOfSize:14.0f];
        self.titleLabel.textColor = UIColorGray2;
        self.titleLabel.text = @"最近搜索";
        self.titleLabel.contentEdgeInsets = UIEdgeInsetsMake(0, 0, 8, 0);
        [self.titleLabel sizeToFit];
        //        self.titleLabel.qmui_borderPosition = QMUIBorderViewPositionBottom;
        [self addSubview:self.titleLabel];
        
        self.floatLayoutView = [[QMUIFloatLayoutView alloc] init];
        self.floatLayoutView.padding = UIEdgeInsetsZero;
        self.floatLayoutView.itemMargins = UIEdgeInsetsMake(0, 0, 10, 10);
        self.floatLayoutView.minimumItemSize = CGSizeMake(69, 29);
        [self addSubview:self.floatLayoutView];
        
//        NSArray<NSString *> *suggestions = @[@"Helps", @"Maintain", @"Liver", @"Health", @"Function", @"Supports", @"Healthy", @"Fat"];
//        for (NSInteger i = 0; i < suggestions.count; i++) {
//            QMUIGhostButton *button = [[QMUIGhostButton alloc] initWithGhostType:QMUIGhostButtonColorGray];
//            [button setTitle:suggestions[i] forState:UIControlStateNormal];
//            button.titleLabel.font = UIFontMake(14);
//            button.contentEdgeInsets = UIEdgeInsetsMake(6, 20, 6, 20);
//            [self.floatLayoutView addSubview:button];
//        }
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    UIEdgeInsets padding = UIEdgeInsetsMake(26, 26, 26, 26);
    CGFloat titleLabelMarginTop = 20;
    self.titleLabel.frame = CGRectMake(padding.left, padding.top, CGRectGetWidth(self.bounds) - UIEdgeInsetsGetHorizontalValue(padding), CGRectGetHeight(self.titleLabel.frame));
    
    CGFloat minY = CGRectGetMaxY(self.titleLabel.frame) + titleLabelMarginTop;
    self.floatLayoutView.frame = CGRectMake(padding.left, minY, CGRectGetWidth(self.bounds) - UIEdgeInsetsGetHorizontalValue(padding), CGRectGetHeight(self.bounds) - minY);
}

@end

@interface KFContactSelectViewController ()<QMUISearchControllerDelegate, MGSwipeTableCellDelegate>

@property(nonatomic, strong) NSMutableArray<NSString *> *searchResultsKeywords;
@property(nonatomic, strong) QMUISearchController *mySearchController;
@property(nonatomic, assign) UIStatusBarStyle statusBarStyle;

@property(nonatomic, strong) UIRefreshControl                  *mRefreshControl;
@property(nonatomic, strong) NSMutableArray<BDContactModel *>  *mContactArray;

@property(nonatomic, strong) NSMutableArray<BDContactModel *> *mSelectedContactsArray;


@end

@implementation KFContactSelectViewController

- (id)initWithStyle:(UITableViewStyle)style {
    if (self = [super initWithStyle:style]) {
        self.shouldShowSearchBar = YES;
        // 测试， TODO: 加载真正数据
        //        [self showEmptyViewWithText:@"联系人为空" detailText:@"请到设置-隐私查看你的联系人权限设置" buttonTitle:nil buttonAction:NULL];
        self.mContactArray = [[NSMutableArray alloc] init];
        self.mSelectedContactsArray = [[NSMutableArray alloc] init];
        //
        self.searchResultsKeywords = [[NSMutableArray alloc] init];
        // 防止tableview的最后一行被切断
        // http://stackoverflow.com/questions/7678910/uitableviewcontroller-last-row-cut-off
        self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 45, 0);
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self reloadTableData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"建群";
    //
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem qmui_closeItemWithTarget:self action:@selector(handleCloseButtonEvent:)];
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem qmui_itemWithButton:[[QMUINavigationButton alloc] initWithType:QMUINavigationButtonTypeNormal title:@"确定"] target:self action:@selector(handleTopRightButtonClickEvent)];
    
    // QMUISearchController 有两种使用方式，一种是独立使用，一种是集成到 QMUICommonTableViewController 里使用。为了展示它的使用方式，这里使用第一种，不理会 QMUICommonTableViewController 内部自带的 QMUISearchController
    self.mySearchController = [[QMUISearchController alloc] initWithContentsViewController:self];
    self.mySearchController.searchResultsDelegate = self;
    self.mySearchController.launchView = [[KFContactSearchView alloc] init];// launchView 会自动布局，无需处理 frame
    self.tableView.tableHeaderView = self.mySearchController.searchBar;
    //
    self.mRefreshControl = [[UIRefreshControl alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
    [self.tableView addSubview:self.mRefreshControl];
    [self.mRefreshControl addTarget:self action:@selector(refreshControlSelector) forControlEvents:UIControlEventValueChanged];
    //
    [self registerNotification];
    [self reloadTableData];
}

#pragma mark - 工具方法

- (void)registerNotification {
    //
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notifyGroupUpdate:) name:BD_NOTIFICATION_GROUP_UPDATE object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notifyContactUpdate:) name:BD_NOTIFICATION_CONTACT_UPDATE object:nil];
    //    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notifyInitStatus:) name:KFDS_NOTIFICATION_INIT_STATUS object:nil];
}

- (void)reload:(id)sender {
    //    [self hideEmptyView];
    [self.tableView reloadData];
}

- (void)reloadTableData {
    
    // 2. TODO: 加载联系人
    self.mContactArray = [BDCoreApis getContacts];
    if ([self.mContactArray count] == 0) {
        [self showEmptyViewWithText:@"联系人为空" detailText:@"暂无联系人" buttonTitle:nil buttonAction:NULL];
    }
    else {
        [self hideEmptyView];
    }
    //
    [self.tableView reloadData];
}

#pragma mark - <QMUITableViewDataSource, QMUITableViewDelegate>

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    //
    if (tableView == self.tableView) {
        // 联系人
        return self.mContactArray.count;
    }
    // 搜索结果
    return self.searchResultsKeywords.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    //
    static NSString *identifier = @"threadCell";
    KFContactTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[KFContactTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.delegate = self;
    //
    if (tableView == self.tableView) {
        // 联系人
        BDContactModel *rosterModel = self.mContactArray[indexPath.row];
        [cell initWithContactModel:rosterModel];
        //
        if ([self.mSelectedContactsArray containsObject:rosterModel]) {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        } else {
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
        
    } else {
        //
        NSString *keyword = self.searchResultsKeywords[indexPath.row];
        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:keyword attributes:@{NSForegroundColorAttributeName: [UIColor blackColor]}];
        NSRange range = [keyword rangeOfString:self.mySearchController.searchBar.text];
        if (range.location != NSNotFound) {
            [attributedString addAttributes:@{NSForegroundColorAttributeName: [QDThemeManager sharedInstance].currentTheme.themeTintColor} range:range];
        }
        cell.textLabel.attributedText = attributedString;
    }
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
  
    // TODO: 选中结果
    BDContactModel *rosterModel = self.mContactArray[indexPath.row];
    if ([self.mSelectedContactsArray containsObject:rosterModel]) {
        [self.mSelectedContactsArray removeObject:rosterModel];
    } else {
        [self.mSelectedContactsArray addObject:rosterModel];
    }
    //
    [self.tableView reloadData];
}

#pragma mark - <QMUISearchControllerDelegate>

- (void)searchController:(QMUISearchController *)searchController updateResultsForSearchString:(NSString *)searchString {
    [self.searchResultsKeywords removeAllObjects];
    
    for (NSString *keyword in self.searchResultsKeywords) {
        if ([keyword containsString:searchString]) {
            [self.searchResultsKeywords addObject:keyword];
        }
    }
    
    [searchController.tableView reloadData];
    
    if (self.searchResultsKeywords.count == 0) {
        [searchController showEmptyViewWithText:@"没有匹配结果" detailText:nil buttonTitle:nil buttonAction:NULL];
    } else {
        [searchController hideEmptyView];
    }
}

- (void)willPresentSearchController:(QMUISearchController *)searchController {
    self.statusBarStyle = UIStatusBarStyleDefault;
    [self setNeedsStatusBarAppearanceUpdate];
}

- (void)willDismissSearchController:(QMUISearchController *)searchController {
    self.statusBarStyle = [super preferredStatusBarStyle];
    [self setNeedsStatusBarAppearanceUpdate];
}
#pragma mark - MGSwipeTableCellDelegate

-(NSArray*) swipeTableCell:(MGSwipeTableCell*) cell swipeButtonsForDirection:(MGSwipeDirection)direction
             swipeSettings:(MGSwipeSettings*) swipeSettings expansionSettings:(MGSwipeExpansionSettings*) expansionSettings
{
    swipeSettings.transition = MGSwipeTransitionBorder;
    expansionSettings.buttonIndex = 0;
    return nil;
}

#pragma mark - 通知

- (void)notifyGroupUpdate:(id)sender {
    DDLogInfo(@"%s, group update", __PRETTY_FUNCTION__);
    
    [self reloadTableData];
}

- (void)notifyContactUpdate:(id)sender {
    DDLogInfo(@"%s, contact update", __PRETTY_FUNCTION__);
    
    [self reloadTableData];
}

- (void)notifyInitStatus:(NSNotification *)notification {
    DDLogInfo(@"%s", __PRETTY_FUNCTION__);
    
    // 初始化加载数据完毕之后，刷新界面
    [self reloadTableData];
}

#pragma mark - Selectors

- (void)refreshControlSelector {
    DDLogInfo(@"%s", __PRETTY_FUNCTION__);
    UIView *parentView = self.navigationController.view;
    
    // 联系人
    [BDCoreApis getContactsResultSuccess:^(NSDictionary *dict) {
        //
        [self reloadTableData];
        [self.mRefreshControl endRefreshing];
    } resultFailed:^(NSError *error) {
        DDLogInfo(@"%s, %@", __PRETTY_FUNCTION__, error);
        [QMUITips showError:@"加载联系人失败" inView:parentView hideAfterDelay:2.0f];
        [self.mRefreshControl endRefreshing];
    }];
    //
}

// 针对Present打开模式，左上角返回按钮处理action
- (void)handleCloseButtonEvent:(id)sender {
    DDLogInfo(@"%s", __PRETTY_FUNCTION__);
    [self.navigationController dismissViewControllerAnimated:YES completion:^{
    }];
}

- (void)handleTopRightButtonClickEvent {
    
    if (self.mSelectedContactsArray.count < 2) {
        UIView *parentView = self.navigationController.view;
        [QMUITips showError:@"至少选择2个人" inView:parentView hideAfterDelay:2.0f];
        return;
    }
    
    // TODO: 调用建群接口，关闭页面
    NSString *nickname = [BDSettings getRealname];
    NSMutableArray *selectedContactUids = [[NSMutableArray alloc] init];
    for (int i = 0; i < self.mSelectedContactsArray.count; i++) {
        BDContactModel *contactModel = [self.mSelectedContactsArray objectAtIndex:i];
        if (i < 4) {
            nickname = [NSString stringWithFormat:@"%@,%@", nickname, contactModel.real_name];
        }
        [selectedContactUids addObject:contactModel.uid];
    }
    //
    [BDCoreApis createGroup:nickname selectedContacts:selectedContactUids resultSuccess:^(NSDictionary *dict) {
        // sdk内部已经本地存储group，下面演示用途：
//        BDGroupModel *groupModel = [[BDGroupModel alloc] initWithDictionary:dict];
//        [[BDDBApis sharedInstance] insertGroup:groupModel];
        // 关闭页面
        [self.navigationController dismissViewControllerAnimated:YES completion:^{
        }];
    } resultFailed:^(NSError *error) {
        DDLogError(@"%s, %@", __PRETTY_FUNCTION__, error);
    }];
}


@end
