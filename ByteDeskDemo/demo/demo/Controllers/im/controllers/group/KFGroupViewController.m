//
//  KFRosterViewController.m
//  linphone
//
//  Created by bytedesk.com on 2017/10/12.
//

#import "KFGroupViewController.h"
#import "KFContactTableViewCell.h"
//#import "KFDetailViewController.h"
#import "KFContactSelectViewController.h"

#import <bytedesk-ui/bdui.h>

@interface KFGroupSearchView : UIView

@property(nonatomic, strong) QMUILabel *titleLabel;
@property(nonatomic, strong) QMUIFloatLayoutView *floatLayoutView;

@end

@implementation KFGroupSearchView

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


@interface KFGroupViewController ()<QMUISearchControllerDelegate, MGSwipeTableCellDelegate>

@property(nonatomic, strong) NSMutableArray<NSString *> *searchResultsKeywords;
@property(nonatomic, strong) QMUISearchController *mySearchController;
@property(nonatomic, assign) UIStatusBarStyle statusBarStyle;

@property(nonatomic, strong) UIRefreshControl                  *mRefreshControl;
@property(nonatomic, strong) NSMutableArray<BDGroupModel *>    *mGroupArray;

@end

@implementation KFGroupViewController

- (id)initWithStyle:(UITableViewStyle)style {
    if (self = [super initWithStyle:style]) {
        self.shouldShowSearchBar = YES;
        // 测试， TODO: 加载真正数据
        //        [self showEmptyViewWithText:@"联系人为空" detailText:@"请到设置-隐私查看你的联系人权限设置" buttonTitle:nil buttonAction:NULL];
        self.mGroupArray = [[NSMutableArray alloc] init];
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
    self.title = @"通讯录";
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem qmui_itemWithImage:UIImageMake(@"icon_nav_more") target:self action:@selector(handleTopRightButtonClickEvent)];
    
    // QMUISearchController 有两种使用方式，一种是独立使用，一种是集成到 QMUICommonTableViewController 里使用。为了展示它的使用方式，这里使用第一种，不理会 QMUICommonTableViewController 内部自带的 QMUISearchController
    self.mySearchController = [[QMUISearchController alloc] initWithContentsViewController:self];
    self.mySearchController.searchResultsDelegate = self;
    self.mySearchController.launchView = [[KFGroupSearchView alloc] init];// launchView 会自动布局，无需处理 frame
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
    
    // 1. TODO: 加载群组
    self.mGroupArray = [BDCoreApis getGroups];
    
    if ([self.mGroupArray count] == 0 ) {
        [self showEmptyViewWithText:@"群组为空" detailText:@"暂无群组" buttonTitle:nil buttonAction:NULL];
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
        // 群组
        return self.mGroupArray.count;
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
        // 群组
        BDGroupModel *groupModel = self.mGroupArray[indexPath.row];
        [cell initWithGroupModel:groupModel];
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

    // 群组会话
    [BDUIApis agentPushChat:self.navigationController withGroupModel:[self.mGroupArray objectAtIndex:indexPath.row]];
    
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

//-(BOOL) swipeTableCell:(MGSwipeTableCell*) cell canSwipe:(MGSwipeDirection) direction {
//    return YES;
//}

-(NSArray*) swipeTableCell:(MGSwipeTableCell*) cell swipeButtonsForDirection:(MGSwipeDirection)direction
             swipeSettings:(MGSwipeSettings*) swipeSettings expansionSettings:(MGSwipeExpansionSettings*) expansionSettings
{
    swipeSettings.transition = MGSwipeTransitionBorder;
    expansionSettings.buttonIndex = 0;
    
    //    __weak CSFirstViewController *weakSelf = self;
    
    if (direction == MGSwipeDirectionLeftToRight) {
        
    }
    else {
        
        expansionSettings.fillOnTrigger = NO;
        expansionSettings.threshold = 1.5;
        
        CGFloat padding = 15;
        
        MGSwipeButton * trash = [MGSwipeButton buttonWithTitle:@"删除" backgroundColor:[UIColor colorWithRed:1.0 green:59/255.0 blue:50/255.0 alpha:1.0] padding:padding callback:^BOOL(MGSwipeTableCell *sender) {
            
            DDLogInfo(@"delete");
            //            NSIndexPath *indexPath = [weakSelf.tableView indexPathForCell:sender];
            //            [weakSelf deleteConversation:indexPath];
            
            return NO; //don't autohide to improve delete animation
        }];
        
        return @[trash];
    }
    
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
    //    NSString *status = [notification object];
    
    // 初始化加载数据完毕之后，刷新界面
    [self reloadTableData];
}

#pragma mark - Selectors

- (void)refreshControlSelector {
    DDLogInfo(@"%s", __PRETTY_FUNCTION__);
    UIView *parentView = self.navigationController.view;
    
    // 群组
    [BDCoreApis getGroupsResultSuccess:^(NSDictionary *dict) {
        //
        [self reloadTableData];
        [self.mRefreshControl endRefreshing];
    } resultFailed:^(NSError *error) {
        DDLogError(@"%s, %@", __PRETTY_FUNCTION__, error);
        [QMUITips showError:@"加载群组失败" inView:parentView hideAfterDelay:2.0f];
        [self.mRefreshControl endRefreshing];
    }];
}

- (void)handleTopRightButtonClickEvent {
    
    QMUIAlertAction *cancelAction = [QMUIAlertAction actionWithTitle:@"取消" style:QMUIAlertActionStyleCancel handler:^(QMUIAlertController *aAlertController, QMUIAlertAction *action) {
    }];
    
    QMUIAlertAction *createGroupAction = [QMUIAlertAction actionWithTitle:@"建群" style:QMUIAlertActionStyleDefault handler:^(QMUIAlertController *aAlertController, QMUIAlertAction *action) {
        
        //
        KFContactSelectViewController *contactSelectViewController = [[KFContactSelectViewController alloc] init];
        //
        QMUINavigationController *chatNavigationController = [[QMUINavigationController alloc] initWithRootViewController:contactSelectViewController];
        [self.navigationController presentViewController:chatNavigationController animated:YES completion:^{
            
        }];
    }];
    QMUIAlertController *alertController = [QMUIAlertController alertControllerWithTitle:@"提示" message:@"" preferredStyle:QMUIAlertControllerStyleActionSheet];
    [alertController addAction:cancelAction];
    [alertController addAction:createGroupAction];
    
    [alertController showWithAnimated:YES];
}


@end
