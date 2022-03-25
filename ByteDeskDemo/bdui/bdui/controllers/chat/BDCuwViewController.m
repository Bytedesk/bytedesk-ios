//
//  BDChatCuwViewController.m
//  bytedesk-ui
//
//  Created by 宁金鹏 on 2020/9/22.
//  Copyright © 2020 KeFuDaShi. All rights reserved.
//
#import <QMUIKit/QMUIKit.h>
#import "BDCuwViewController.h"

#import <bytedesk-core/bdcore.h>

@interface KFCuwSearchView : UIView

@property(nonatomic, strong) QMUILabel *titleLabel;
@property(nonatomic, strong) QMUIFloatLayoutView *floatLayoutView;

@end

@implementation KFCuwSearchView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = UIColorWhite;
        //
        self.titleLabel = [[QMUILabel alloc] init];
        self.titleLabel.font = [UIFont systemFontOfSize:14.0f];
//        self.titleLabel.textColor = UIColorGray2;
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

// TODO: 本地缓存
@interface BDCuwViewController ()<QMUISearchControllerDelegate>

@property(nonatomic, strong) NSMutableArray *searchResults;
@property(nonatomic, strong) QMUISearchController *mySearchController;

@property(nonatomic, strong) NSMutableArray *mSectionArray;

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
    UIBarButtonItem *rightItem = [UIBarButtonItem qmui_itemWithTitle:@"取消" target:self action:@selector(handleRightBarButtonItemClicked:)];
//    UIBarButtonItem *rightItem = [UIBarButtonItem qmui_itemWithImage:[UIImage imageNamed:@"bytedesk_plus" inBundle:[NSBundle bundleForClass:self.class] compatibleWithTraitCollection:nil] target:self action:@selector(handleRightBarButtonItemClicked:)];
    self.navigationItem.rightBarButtonItem = rightItem;
    //
    self.mSectionArray = [[NSMutableArray alloc] init];
    self.searchResults = [[NSMutableArray alloc] init];
    
    // QMUISearchController 有两种使用方式，一种是独立使用，一种是集成到 QMUICommonTableViewController 里使用。
    // 为了展示它的使用方式，这里使用第一种，不理会 QMUICommonTableViewController 内部自带的 QMUISearchController
    self.mySearchController = [[QMUISearchController alloc] initWithContentsViewController:self];
    self.mySearchController.searchResultsDelegate = self;
    self.mySearchController.launchView = [[KFCuwSearchView alloc] init];// launchView 会自动布局，无需处理 frame
    self.tableView.tableHeaderView = self.mySearchController.searchBar;
    //
//    self.mRefreshControl = [[UIRefreshControl alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
//    [self.tableView addSubview:self.mRefreshControl];
//    [self.mRefreshControl addTarget:self action:@selector(refreshControlSelector) forControlEvents:UIControlEventValueChanged];
//    [self.mRefreshControl beginRefreshing];
}

- (void)handleRightBarButtonItemClicked:(id)sender {
    DDLogInfo(@"%s", __PRETTY_FUNCTION__);
    
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

#pragma mark - <UITableViewDataSource, UITableViewDelegate>

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (tableView == self.tableView) {
        return [self.mSectionArray count];
    }
    return 1;
}

- (nullable NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    //
    if (tableView == self.tableView) {
        NSDictionary *dict = [self.mSectionArray objectAtIndex:section];
        return [dict objectForKey:@"name"];
    }
    return @"";
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView == self.tableView) {
        NSDictionary *dict = [self.mSectionArray objectAtIndex:section];
        NSMutableArray *cuwChildren = dict[@"cuwChildren"];
        return [cuwChildren count];
    }
    return self.searchResults.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (tableView == self.tableView) {
    
        static NSString *CellIdentifier = @"Cell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        // Configure the cell...
        if (cell == nil) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        }
        
        NSDictionary *dict = [self.mSectionArray objectAtIndex:indexPath.section];
        NSMutableArray *cuwChildren = dict[@"cuwChildren"];
        NSDictionary *cuwDict = [cuwChildren objectAtIndex:indexPath.row];
        
        cell.textLabel.text = [cuwDict objectForKey:@"name"];
        cell.detailTextLabel.text = [self getDetailText:[cuwDict objectForKey:@"type"] content:[cuwDict objectForKey:@"content"]];
        
        return cell;
        
    } else {
        // 搜索结果
        static NSString *CellIdentifier = @"SearchCell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        // Configure the cell...
        if (cell == nil) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        }
        
        NSDictionary *cuwDict = [self.searchResults objectAtIndex:indexPath.row];
        cell.textLabel.text = [cuwDict objectForKey:@"name"];
        cell.detailTextLabel.text = [self getDetailText:[cuwDict objectForKey:@"type"] content:[cuwDict objectForKey:@"content"]];
        
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSDictionary *cuwDict;
    if (tableView == self.tableView) {
        //
        NSDictionary *dict = [self.mSectionArray objectAtIndex:indexPath.section];
        NSMutableArray *cuwChildren = dict[@"cuwChildren"];
        cuwDict = [cuwChildren objectAtIndex:indexPath.row];
    } else {
        cuwDict = [self.searchResults objectAtIndex:indexPath.row];
    }
    //
    NSString *type = [cuwDict objectForKey:@"type"];
    NSString *content = [cuwDict objectForKey:@"content"];
    // 执行回调
    if ([delegate respondsToSelector:@selector(cuwSelected:)]) {
        NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:type, @"type", content, @"content", nil];
        [delegate performSelector:@selector(cuwSelected:) withObject:dict];
    }
    // 返回聊天页面
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

- (NSString *)getDetailText:(NSString *)type content:(NSString *)content  {
    //
    if ([type isEqualToString:@"text"]) {
        return [NSString stringWithFormat:@"[文字]%@", content];
    } else if ([type isEqualToString:@"image"]) {
        return @"[图片]";
    } else if ([type isEqualToString:@"file"]) {
        return @"[文件]";
    } else if ([type isEqualToString:@"voice"]) {
        return @"[语音]";
    } else if ([type isEqualToString:@"video"]) {
        return @"[视频]";
    }
    return [NSString stringWithFormat:@"[文字]%@", content];
}
    
#pragma mark - <QMUISearchControllerDelegate>

- (void)searchController:(QMUISearchController *)searchController updateResultsForSearchString:(NSString *)searchString {
    [self.searchResults removeAllObjects];
    // 搜索过滤
    for (NSDictionary *categoryDict in self.mSectionArray) {
        NSMutableArray *cuwChildren = categoryDict[@"cuwChildren"];
        for (NSDictionary *cuwDict in cuwChildren) {
            NSString *name = cuwDict[@"name"];
            NSString *content = cuwDict[@"content"];
            if ([name containsString:searchString] || [content containsString:searchString]) {
                [self.searchResults addObject:cuwDict];
            }
        }
    }
    
    //
    [searchController.tableView reloadData];
    //
    if (self.searchResults.count == 0) {
        [searchController showEmptyViewWithText:@"没有匹配结果" detailText:nil buttonTitle:nil buttonAction:NULL];
    } else {
        [searchController hideEmptyView];
    }
}

- (void)willPresentSearchController:(QMUISearchController *)searchController {
    [self setNeedsStatusBarAppearanceUpdate];
}

- (void)willDismissSearchController:(QMUISearchController *)searchController {
    [self setNeedsStatusBarAppearanceUpdate];
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
            [self.mSectionArray addObjectsFromArray:mineArray];
//            for (NSDictionary *categoryDict in mineArray) {
//                NSMutableArray *cuwChildren = categoryDict[@"cuwChildren"];
//                for (NSDictionary *cuwDict in cuwChildren) {
//                    NSString *type = cuwDict[@"type"];
//                    NSString *name = cuwDict[@"name"];
//                    NSString *content = cuwDict[@"content"];
//                    //
//                    [self.mTypeArray addObject:type];
//                    [self.mNameArray addObject:name];
//                    [self.mContentArray addObject:content];
//                }
//            }
            //
            NSMutableArray *companyArray = dict[@"data"][@"company"];
            [self.mSectionArray addObjectsFromArray:companyArray];
//            for (NSDictionary *categoryDict in companyArray) {
//                NSMutableArray *cuwChildren = categoryDict[@"cuwChildren"];
//                for (NSDictionary *cuwDict in cuwChildren) {
//                    NSString *type = cuwDict[@"type"];
//                    NSString *name = cuwDict[@"name"];
//                    NSString *content = cuwDict[@"content"];
//                    //
//                    [self.mTypeArray addObject:type];
//                    [self.mNameArray addObject:name];
//                    [self.mContentArray addObject:content];
//                }
//            }
            //
            NSMutableArray *platformArray = dict[@"data"][@"platform"];
            [self.mSectionArray addObjectsFromArray:platformArray];
//            for (NSDictionary *categoryDict in platformArray) {
//                NSMutableArray *cuwChildren = categoryDict[@"cuwChildren"];
//                for (NSDictionary *cuwDict in cuwChildren) {
//                    NSString *type = cuwDict[@"type"];
//                    NSString *name = cuwDict[@"name"];
//                    NSString *content = cuwDict[@"content"];
//                    //
//                    [self.mTypeArray addObject:type];
//                    [self.mNameArray addObject:name];
//                    [self.mContentArray addObject:content];
//                }
//            }
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
