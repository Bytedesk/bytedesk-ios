//
//  KFThreadViewController.m
//
//  Created by bytedesk.com on 2017/10/12.
//

#import "KFThreadViewController.h"
#import "KFQueueViewController.h"
#import "KFThreadTableViewCell.h"

#import <bytedesk-ui/bdui.h>
#import <bytedesk-core/bdcore.h>

#import <AFNetworking/UIImageView+AFNetworking.h>


@interface KFRecentSearchView : UIView

@property(nonatomic, strong) QMUILabel *titleLabel;
@property(nonatomic, strong) QMUIFloatLayoutView *floatLayoutView;

@end

@implementation KFRecentSearchView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = UIColorWhite;
        //
        self.titleLabel = [[QMUILabel alloc] init];
        self.titleLabel.font = [UIFont systemFontOfSize:14.0f];
        self.titleLabel.textColor = UIColorGray2;
        self.titleLabel.text = @"最近搜索";
        self.titleLabel.contentEdgeInsets = UIEdgeInsetsMake(0, 0, 8, 0);
        [self.titleLabel sizeToFit];
//        self.titleLabel.style = QMUINavigationTitleViewStyleSubTitleVertical;
        [self addSubview:self.titleLabel];
        //
        self.floatLayoutView = [[QMUIFloatLayoutView alloc] init];
        self.floatLayoutView.padding = UIEdgeInsetsZero;
        self.floatLayoutView.itemMargins = UIEdgeInsetsMake(0, 0, 10, 10);
        self.floatLayoutView.minimumItemSize = CGSizeMake(69, 29);
        [self addSubview:self.floatLayoutView];
        //
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

@interface KFThreadViewController ()<QMUISearchControllerDelegate, MGSwipeTableCellDelegate>

@property(nonatomic, strong) NSMutableArray<NSString *> *searchResultsKeywords;
@property(nonatomic, strong) QMUISearchController *mySearchController;
@property(nonatomic, assign) UIStatusBarStyle statusBarStyle;

@property(nonatomic, strong) UIRefreshControl *mRefreshControl;
@property(nonatomic, strong) NSMutableArray<BDThreadModel *> *mThreadArray;


@end

@implementation KFThreadViewController

- (id)initWithStyle:(UITableViewStyle)style {
    if (self = [super initWithStyle:style]) {
        self.shouldShowSearchBar = YES;
        // titleView标题：1. 连接中...(连接到Socket服务器), 2.获取中...(获取会话thread/队列queue/离线消息message)
//        self.shouldShowSearchBar = NO;
//        测试， TODO: 加载真正数据
//        [self showEmptyViewWithText:@"通话记录为空" detailText:@"暂无通话记录" buttonTitle:nil buttonAction:NULL];
//        self.keywords = @[@"Helps", @"Maintain", @"Liver", @"Health", @"Function", @"Supports", @"Healthy", @"Fat", @"Metabolism", @"Nuturally"];
        self.mThreadArray = [[NSMutableArray alloc] init];
        self.searchResultsKeywords = [[NSMutableArray alloc] init];
        // 防止tableview的最后一行被切断
        // http://stackoverflow.com/questions/7678910/uitableviewcontroller-last-row-cut-off
        self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 45, 0);
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    //
    [self reloadTableData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"会话记录";
    // QMUISearchController 有两种使用方式，一种是独立使用，一种是集成到 QMUICommonTableViewController 里使用。
    // 为了展示它的使用方式，这里使用第一种，不理会 QMUICommonTableViewController 内部自带的 QMUISearchController
    self.mySearchController = [[QMUISearchController alloc] initWithContentsViewController:self];
    self.mySearchController.searchResultsDelegate = self;
    self.mySearchController.launchView = [[KFRecentSearchView alloc] init];// launchView 会自动布局，无需处理 frame
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
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notifyOAuthResult:) name:BD_NOTIFICATION_OAUTH_RESULT object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notifyConnectionStatus:) name:BD_NOTIFICATION_CONNECTION_STATUS object:nil];
    //
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notifyInitStatus:) name:BD_NOTIFICATION_INIT_STATUS object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notifyThreadAdd:) name:BD_NOTIFICATION_THREAD_ADD object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notifyThreadDelete:) name:BD_NOTIFICATION_THREAD_DELETE object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notifyQueueAdd:) name:BD_NOTIFICATION_QUEUE_ADD object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notifyQueueDelete:) name:BD_NOTIFICATION_QUEUE_DELETE object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notifyMessageAdd:) name:BD_NOTIFICATION_MESSAGE_ADD object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notifyThreadUpdate:) name:BD_NOTIFICATION_THREAD_UPDATE object:nil];
}

- (void)reloadTableData {
    // 读取本地数据
    self.mThreadArray = [BDCoreApis getIMThreads];
    if ([self.mThreadArray count] == 0) {
        //TODO: bug 当对话记录内容为空的时候，无法点击进入排队页面
        [self showEmptyViewWithText:@"对话记录为空" detailText:@"暂无对话记录" buttonTitle:nil buttonAction:NULL];
    }
    else {
        [self hideEmptyView];
    }
    [self.tableView reloadData];
}

#pragma mark - <QMUITableViewDataSource, QMUITableViewDelegate>

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView == self.tableView) {
        return self.mThreadArray.count;
    }
    return self.searchResultsKeywords.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    //
    static NSString *identifier = @"threadCell";
    KFThreadTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    //
    if (!cell) {
        cell = [[KFThreadTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.delegate = self;
    //
    if (tableView == self.tableView) {
        //
        BDThreadModel *threadModel = self.mThreadArray[indexPath.row];
        [cell initWithThreadModel:threadModel];
        
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
    DDLogInfo(@"%s", __PRETTY_FUNCTION__);
    // TODO: 打开聊天页面之后，根据thread类型区分会话类型：一对一、群组、工作组
    BDThreadModel *threadModel = [self.mThreadArray objectAtIndex:indexPath.row];
    [BDUIApis pushChat:self.navigationController withThreadModel:threadModel];
    
//    if ([threadModel.type isEqualToString:BD_THREAD_TYPE_THREAD]) {
//        [BDUIApis agentPushChat:self.navigationController withThreadModel:threadModel];
//    } else if ([threadModel.type isEqualToString:BD_THREAD_TYPE_CONTACT]) {
//        [BDUIApis agentPushChat:self.navigationController withThreadModel:threadModel];
//    } else if ([threadModel.type isEqualToString:BD_THREAD_TYPE_GROUP]) {
//        [BDUIApis agentPushChat:self.navigationController withThreadModel:threadModel];
//    }

    // 清空未读数目
    [[BDDBApis sharedInstance] clearThreadUnreadCount:threadModel.tid];
    [self reloadTableData];
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
             swipeSettings:(MGSwipeSettings*) swipeSettings expansionSettings:(MGSwipeExpansionSettings*) expansionSettings {
    
    swipeSettings.transition = MGSwipeTransitionBorder;
    expansionSettings.buttonIndex = 0;
    
    if (direction == MGSwipeDirectionLeftToRight) {
        
    }
    else {
        
        expansionSettings.fillOnTrigger = NO;
        expansionSettings.threshold = 1.5;
        
        CGFloat padding = 15;
        
        NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
        BDThreadModel *threadModel = [self.mThreadArray objectAtIndex:indexPath.row];
        
        MGSwipeButton * closeButton = [MGSwipeButton buttonWithTitle:@"删除" backgroundColor:[UIColor colorWithRed:1.0 green:59/255.0 blue:50/255.0 alpha:1.0] padding:padding callback:^BOOL(MGSwipeTableCell *sender) {
            DDLogInfo(@"delete");
            // 删除
            [BDCoreApis markDeletedThread:threadModel.tid resultSuccess:^(NSDictionary *dict) {
                
                NSNumber *status_code = [dict objectForKey:@"status_code"];
                if ([status_code isEqualToNumber:[NSNumber numberWithInt:200]]) {
                    
                    [[BDDBApis sharedInstance] deleteThreadUser:threadModel.tid];
                    [self.mThreadArray removeObjectAtIndex:indexPath.row];
                    //
                    [self.tableView beginUpdates];
                    [self.tableView deleteRowsAtIndexPaths:[NSMutableArray arrayWithObjects:indexPath, nil] withRowAnimation:UITableViewRowAnimationFade];
                    [self.tableView endUpdates];
                }
                
                // TODO: 待优化
                //                [self reloadTableData];
            } resultFailed:^(NSError *error) {
                [QMUITips showError:@"删除失败" inView:self.view hideAfterDelay:2.0f];
            }];
            
            return NO;
        }];
        
        // TODO: 标记未读 or 取消标记未读
        NSString *titleUnread = [threadModel.is_mark_unread boolValue] ? @"取消标记未读" : @"标记未读";
        MGSwipeButton * markUnreadButton = [MGSwipeButton buttonWithTitle:titleUnread backgroundColor:[UIColor colorWithRed:0.8 green:0.8 blue:0.8 alpha:1.0] padding:padding callback:^BOOL(MGSwipeTableCell *sender) {
            DDLogInfo(@"mark unread");
            
            if ([threadModel.is_mark_unread boolValue]) {
                // 取消标记未读
                [BDCoreApis unmarkUnreadThread:threadModel.tid resultSuccess:^(NSDictionary *dict) {
                    
                    // TODO: reloadRowsAtIndexPaths
                    NSNumber *status_code = [dict objectForKey:@"status_code"];
                    if ([status_code isEqualToNumber:[NSNumber numberWithInt:200]]) {
                        
                        // TODO: 待优化
                        [self reloadTableData];
                    }
                    
                } resultFailed:^(NSError *error) {
                    [QMUITips showError:@"取消标记未读失败" inView:self.view hideAfterDelay:2.0f];
                }];
            } else {
                // 标记未读
                [BDCoreApis markUnreadThread:threadModel.tid resultSuccess:^(NSDictionary *dict) {
                    
                    // TODO: reloadRowsAtIndexPaths
                    NSNumber *status_code = [dict objectForKey:@"status_code"];
                    if ([status_code isEqualToNumber:[NSNumber numberWithInt:200]]) {
                        
                        // TODO: 待优化
                        [self reloadTableData];
                    }
                    
                } resultFailed:^(NSError *error) {
                    [QMUITips showError:@"标记未读失败" inView:self.view hideAfterDelay:2.0f];
                }];
            }
            
            return YES;
        }];
        
        // TODO: 置顶 or 取消指定
        NSString *titleTop = [threadModel.is_mark_top boolValue] ? @"取消置顶" : @"置顶";
        MGSwipeButton * markTopButton = [MGSwipeButton buttonWithTitle:titleTop backgroundColor:[UIColor colorWithRed:1.0 green:149/255.0 blue:0.05 alpha:1.0] padding:padding callback:^BOOL(MGSwipeTableCell *sender) {
            DDLogInfo(@"mark top");
            
            if ([threadModel.is_mark_top boolValue]) {
                // 取消置顶
                [BDCoreApis unmarkTopThread:threadModel.tid resultSuccess:^(NSDictionary *dict) {
                    
                    // TODO: reloadRowsAtIndexPaths
                    NSNumber *status_code = [dict objectForKey:@"status_code"];
                    if ([status_code isEqualToNumber:[NSNumber numberWithInt:200]]) {
                        
                    }
                    
                    // TODO: 待优化
                    [self reloadTableData];
                } resultFailed:^(NSError *error) {
                    [QMUITips showError:@"取消置顶失败" inView:self.view hideAfterDelay:2.0f];
                }];
            } else {
                // 置顶
                [BDCoreApis markTopThread:threadModel.tid resultSuccess:^(NSDictionary *dict) {
                    
                    // TODO: reloadRowsAtIndexPaths
                    NSNumber *status_code = [dict objectForKey:@"status_code"];
                    if ([status_code isEqualToNumber:[NSNumber numberWithInt:200]]) {
                        
                    }
                    
                    // TODO: 待优化
                    [self reloadTableData];
                } resultFailed:^(NSError *error) {
                    [QMUITips showError:@"置顶失败" inView:self.view hideAfterDelay:2.0f];
                }];
            }
            
            return YES;
        }];
        
        //
        return @[closeButton, markTopButton, markUnreadButton];
    }
    
    return nil;
}

#pragma mark - 通知 selector

- (void)notifyOAuthResult:(NSNotification *)notification {
    DDLogInfo(@"%s", __PRETTY_FUNCTION__);
    //
}

- (void)notifyConnectionStatus:(NSNotification *)notification {
    DDLogInfo(@"%s", __PRETTY_FUNCTION__);
}

- (void)notifyInitStatus:(NSNotification *)notification {
    DDLogInfo(@"%s", __PRETTY_FUNCTION__);
    
    // TODO: 有待优化
    [self reloadTableData];
}

- (void)notifyThreadUpdate:(id)sender {
    DDLogInfo(@"%s, thread update", __PRETTY_FUNCTION__);
    
    // TODO: 有待优化
    [self reloadTableData];
}

- (void)notifyThreadAdd:(NSNotification *)notification {
    BDThreadModel *threadModel = [notification object];
    DDLogInfo(@"%s %@", __PRETTY_FUNCTION__, threadModel.nickname);
    
    // TODO: 有待优化
    [self reloadTableData];
}

- (void)notifyThreadDelete:(NSNotification *)notification {
    NSNumber *threadId = [notification object];
    DDLogInfo(@"%s, %@", __PRETTY_FUNCTION__, threadId);
    //
//    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
//    NSNumber *threadIdNumber = [numberFormatter numberFromString:threadId];
//    for (NSUInteger i = 0; i < [self.mThreadArray count]; i++) {
//        KFDSThreadModel *threadModel = [self.mThreadArray objectAtIndex:i];
//        if ([threadModel.mid isEqualToNumber:threadIdNumber]) {
//            [self.mThreadArray removeObjectAtIndex:i];
//        }
//    }
    // 简单粗暴，TODO： 有待优化
    [self reloadTableData];
}


- (void)notifyQueueAdd:(NSNotification *)notification {
    BDQueueModel *queueModel = [notification object];
    DDLogInfo(@"%s, %@", __PRETTY_FUNCTION__, queueModel.nickname);
    
    // TODO: 有待优化
    [self reloadTableData];
}

- (void)notifyQueueDelete:(NSNotification *)notification {
    NSNumber *queueId = [notification object];
    DDLogInfo(@"%s %@", __PRETTY_FUNCTION__, queueId);
    
    // TODO: 有待优化
    [self reloadTableData];
}

- (void)notifyMessageAdd:(NSNotification *)notification {
    DDLogInfo(@"%s", __PRETTY_FUNCTION__);
    
    // TODO: 有待优化
    [self reloadTableData];
}

#pragma mark - 下拉刷新

- (void)refreshControlSelector {
    DDLogInfo(@"%s", __PRETTY_FUNCTION__);
    UIView *parentView = self.navigationController.view;
    //
    [BDCoreApis getThreadResultSuccess:^(NSDictionary *dict) {
        DDLogInfo(@"%s, %@", __PRETTY_FUNCTION__, dict);
        //
        [self reloadTableData];
        [self.mRefreshControl endRefreshing];
    } resultFailed:^(NSError *error) {
        DDLogInfo(@"%s, %@", __PRETTY_FUNCTION__, error);
        //
        [QMUITips showError:@"加载失败" inView:parentView hideAfterDelay:2.0f];
        [self.mRefreshControl endRefreshing];
    }];
}



@end







