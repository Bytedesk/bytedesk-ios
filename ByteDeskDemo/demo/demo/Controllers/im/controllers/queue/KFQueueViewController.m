//
//  KFQueueViewController.m
//  kefu
//
//  Created by bytedesk.com on 2017/11/28.
//  Copyright © 2017年 吾协云. All rights reserved.
//

#import "KFQueueViewController.h"
#import "KFQueueTableViewCell.h"

#import <bytedesk-ui/bdui.h>
#import <bytedesk-core/bdcore.h>

@interface KFQueueSearchView : UIView

@property(nonatomic, strong) QMUILabel *titleLabel;
@property(nonatomic, strong) QMUIFloatLayoutView *floatLayoutView;

@end

@implementation KFQueueSearchView

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


@interface KFQueueViewController ()<QMUISearchControllerDelegate, MGSwipeTableCellDelegate>

@property(nonatomic, strong) NSMutableArray<NSString *> *searchResultsKeywords;
@property(nonatomic, strong) QMUISearchController *mySearchController;
@property(nonatomic, assign) UIStatusBarStyle statusBarStyle;

@property(nonatomic, strong) UIRefreshControl *mRefreshControl;
@property(nonatomic, strong) NSMutableArray<BDQueueModel *> *mQueueArray;

@end

@implementation KFQueueViewController

- (id)initWithStyle:(UITableViewStyle)style {
    if (self = [super initWithStyle:style]) {
        self.shouldShowSearchBar = YES;
        // 测试， TODO: 加载真正数据
        self.mQueueArray = [[NSMutableArray alloc] init];
        self.searchResultsKeywords = [[NSMutableArray alloc] init];
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
    // Do any additional setup after loading the view.
    self.title = @"排队";
    //
    // QMUISearchController 有两种使用方式，一种是独立使用，一种是集成到 QMUICommonTableViewController 里使用。为了展示它的使用方式，这里使用第一种，不理会 QMUICommonTableViewController 内部自带的 QMUISearchController
    self.mySearchController = [[QMUISearchController alloc] initWithContentsViewController:self];
    self.mySearchController.searchResultsDelegate = self;
    self.mySearchController.launchView = [[KFQueueSearchView alloc] init];// launchView 会自动布局，无需处理 frame
    self.tableView.tableHeaderView = self.mySearchController.searchBar;
    //
    self.mRefreshControl = [[UIRefreshControl alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
    [self.tableView addSubview:self.mRefreshControl];
    [self.mRefreshControl addTarget:self action:@selector(refreshControlSelector) forControlEvents:UIControlEventValueChanged];
    //
    [self registerNotification];
    // 从服务器同步读取数据
//    [self.mRefreshControl beginRefreshing];
    [self refreshControlSelector];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    DDLogInfo(@"%s", __PRETTY_FUNCTION__);
    // TODO: removeObserver
}

#pragma mark - 工具方法

- (void)registerNotification {
    //
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notifyQueueUpdate:) name:BD_NOTIFICATION_QUEUE_UPDATE object:nil];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notifyQueueAdd:) name:KFDS_NOTIFICATION_QUEUE_ADD object:nil];
}

- (void)reloadTableData {
    // 读取本地数据
    self.mQueueArray = [BDCoreApis getQueues];
    if ([self.mQueueArray count] == 0) {
        [self showEmptyViewWithText:@"队列为空" detailText:@"暂无排队记录" buttonTitle:nil buttonAction:NULL];
    } else {
        [self hideEmptyView];
    }
    [self.tableView reloadData];
}

#pragma mark - <QMUITableViewDataSource, QMUITableViewDelegate>

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView == self.tableView) {
        return self.mQueueArray.count;
    }
    return self.searchResultsKeywords.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"queueCell";
    KFQueueTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[KFQueueTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.delegate = self;
    //
    if (tableView == self.tableView) {
        BDQueueModel *queueModel = self.mQueueArray[indexPath.row];
        [cell initWithQueueModel:queueModel];
    } else {
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
//    UIView *parentView = self.navigationController.view;
//    WXQueueModel *queueModel = [self.mQueueArray objectAtIndex:indexPath.row];
//    QMUIAlertAction *cancelAction = [QMUIAlertAction actionWithTitle:@"取消" style:QMUIAlertActionStyleCancel handler:^(QMUIAlertAction *action) {
//       // do nothing
//    }];
//    QMUIAlertAction *acceptAction = [QMUIAlertAction actionWithTitle:@"接入" style:QMUIAlertActionStyleDefault handler:^(QMUIAlertAction *action) {
////        DDLogInfo(@"accept %@", queueModel.mid);
//        [QMUITips showLoading:@"接入中..." inView:parentView];
//        //
////        [WXCoreApis adminManualAcceptQueueWithQueueId:queueModel.mid
////            resultSuccess:^(NSDictionary *dict) {
//////                DDLogInfo(@"%s, %@", __PRETTY_FUNCTION__, dict);
////                [QMUITips hideAllToastInView:parentView animated:YES];
////                // TODO: 1.删除队列queue, 2.打开对话页面
////                [self.mQueueArray removeObjectAtIndex:indexPath.row];
////                [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationLeft];
////                //
////
////            } resultFailed:^(NSError *error) {
////                DDLogInfo(@"%s, %@", __PRETTY_FUNCTION__, error);
////                [QMUITips hideAllToastInView:parentView animated:YES];
////                [QMUITips showError:@"接入失败" inView:parentView hideAfterDelay:2];
////            }];
//    }];
//    QMUIAlertController *alertController = [QMUIAlertController alertControllerWithTitle:@"提示" message:@"确定要接入会话？" preferredStyle:QMUIAlertControllerStyleAlert];
//    [alertController addAction:cancelAction];
//    [alertController addAction:acceptAction];
//    [alertController showWithAnimated:YES];
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
        
        MGSwipeButton * ignoreButton = [MGSwipeButton buttonWithTitle:@"忽略" backgroundColor:[UIColor colorWithRed:1.0 green:59/255.0 blue:50/255.0 alpha:1.0] padding:padding callback:^BOOL(MGSwipeTableCell *sender) {
            DDLogInfo(@"ignore");
    
            return NO; //don't autohide to improve delete animation
        }];
        MGSwipeButton * acceptButton = [MGSwipeButton buttonWithTitle:@"接入" backgroundColor:[UIColor colorWithRed:1.0 green:149/255.0 blue:0.05 alpha:1.0] padding:padding callback:^BOOL(MGSwipeTableCell *sender) {
            DDLogInfo(@"accept");
 
            return YES;
        }];
        
        return @[ignoreButton, acceptButton];
    }
    
    return nil;
}

#pragma mark - 通知 selector

- (void)notifyQueueUpdate:(id)sender {
    DDLogInfo(@"%s, queue update", __PRETTY_FUNCTION__);
    
    [self reloadTableData];
}


#pragma mark - Selectors

- (void)refreshControlSelector {
    DDLogInfo(@"%s", __PRETTY_FUNCTION__);
    UIView *parentView = self.navigationController.view;
    //
    [BDCoreApis getQueueResultSuccess:^(NSDictionary *dict) {
//        DDLogInfo(@"%s, %@", __PRETTY_FUNCTION__, dict);
        //
        [self reloadTableData];
        [self.mRefreshControl endRefreshing];
    } resultFailed:^(NSError *error) {
        DDLogInfo(@"%s, %@", __PRETTY_FUNCTION__, error);
        [QMUITips showError:@"加载失败" inView:parentView hideAfterDelay:2.0f];
        [self.mRefreshControl endRefreshing];
    }];
}

#pragma mark - 通知

- (void)notifyQueueAdd:(NSNotification *)notification {
//    WXQueueModel *queueModel = [notification object];
//    DDLogInfo(@"%s, %@", __PRETTY_FUNCTION__, queueModel.nickname);
    
    // TODO: 有待优化
    [self reloadTableData];
}

- (void)notifyQueueDelete:(NSNotification *)notification {
    NSNumber *queueId = [notification object];
    DDLogInfo(@"%s %@", __PRETTY_FUNCTION__, queueId);
    
    // TODO: 有待优化
    [self reloadTableData];
}



@end







