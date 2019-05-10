//
//  KFDSChatViewController.m
//  bdui
//
//  Created by 萝卜丝 on 2018/11/29.
//  Copyright © 2018年 Bytedesk.com. All rights reserved.
//

#import "BDChatViewController.h"
#import "BDMsgViewCell.h"
#import "BDMsgNotificationViewCell.h"
#import "BDCommodityTableViewCell.h"
#import "BDUserinfoViewController.h"
#import "BDContactProfileViewController.h"
#import "BDSingleImagePickerPreviewViewController.h"
#import "KFDSUConstants.h"
#import "BDGroupProfileViewController.h"
#import "BDLeaveMessageViewController.h"

#import <HCSStarRatingView/HCSStarRatingView.h>
#import <bytedesk-core/bdcore.h>

#define MaxSelectedImageCount 9
#define NormalImagePickingTag 1045
#define ModifiedImagePickingTag 1046
#define MultipleImagePickingTag 1047
#define SingleImagePickingTag 1048

static CGFloat const kToolbarHeight = 56;
static CGFloat const kEmotionViewHeight = 232;

static QMUIAlbumContentType const kAlbumContentType = QMUIAlbumContentTypeOnlyPhoto;

@interface BDChatViewController ()<UINavigationControllerBackButtonHandlerProtocol, KFDSMsgViewCellDelegate, QMUIAlbumViewControllerDelegate,QMUIImagePickerViewControllerDelegate,BDSingleImagePickerPreviewViewControllerDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, QMUITextFieldDelegate, QMUIImagePreviewViewDelegate, BDGroupProfileViewControllerDelegate, BDContactProfileViewControllerDelegate>
{

}

@property(nonatomic, strong) UIView *toolbarView;
@property(nonatomic, strong) QMUITextField *toolbarTextField;
//@property(nonatomic, strong) QMUIButton *faceButton;
@property(nonatomic, strong) QMUIButton *sendButton;
@property(nonatomic, strong) QMUIButton *plusButton;

@property(nonatomic, strong) QMUIImagePreviewViewController *imagePreviewViewController;
@property(nonatomic, strong) UIImageView *currentImageView;
//@property(nonatomic, strong) NSArray<UIImage *> *images;

// 是否为访客端
@property(nonatomic, assign) BOOL mIsVisitor; // 是否访客端调用接口
@property(nonatomic, assign) BOOL mIsPush;
@property(nonatomic, assign) BOOL mIsDefaultRobot;
@property(nonatomic, assign) BOOL mIsThreadClosed;

@property(nonatomic, assign) BOOL mIsInternetReachable;
@property(nonatomic, strong) NSString *mTitle;

@property(nonatomic, strong) UIRefreshControl *mRefreshControl;
@property(nonatomic, strong) NSMutableArray<BDMessageModel *> *mMessageArray;

//@property(nonatomic, strong) UIView *parentView;
@property(nonatomic, assign) NSInteger mGetMessageFromChannelPage;

@property(nonatomic, strong) NSString *mUid; // visitorUid/cid/gid
@property(nonatomic, strong) NSString *mWorkGroupWid; // 工作组wid
@property(nonatomic, strong) NSString *mThreadTid; // 统一代表：thread.tid/contact.uid/group.gid
@property(nonatomic, strong) NSString *mAgentUid; // 指定坐席uid
@property(nonatomic, strong) NSString *mThreadType; // 区分客服会话thread、同事会话contact、群组会话group
@property(nonatomic, strong) NSString *mRequestType; // 区分工作组会话、指定客服会话

@property(nonatomic, strong) NSString *threadTopic;
@property(nonatomic, strong) BDThreadModel *mThreadModel;
@property(nonatomic, strong) BDContactModel *mContactModel;
@property(nonatomic, strong) BDGroupModel *mGroupModel;

@property(nonatomic, assign) NSInteger rateScore;
@property(nonatomic, strong) NSString *rateNote;
@property(nonatomic, assign) BOOL rateInvite;
// 本地存储的最老一条聊天记录，server_id最小的，时间戳最旧的
@property(nonatomic, assign) NSInteger mLastMessageId;

@property(nonatomic, assign) BOOL mWithCustomDict;
@property(nonatomic, strong) NSDictionary *mCustomDict;

//客服端
@property (nonatomic, strong) UIImagePickerController *mImagePickerController;
@property(nonatomic, assign) BOOL forceEnableBackGesture;

@property (nonatomic, assign) BOOL mIsViewControllerClosed;
@property(nonatomic, assign) BOOL mIsRobot;

@end

@implementation BDChatViewController

@synthesize mImagePickerController;

#pragma mark - 访客端接口

- (void)initWithWorkGroupWid:(NSString *)wId withTitle:(NSString *)title withPush:(BOOL)isPush {
    // titleView状态：1. 连接中...(发送请求到服务器，进入队列)，2. 排队中...(队列中等待客服接入会话), 3. 接入会话（一闪而过）
    self.mIsVisitor = YES;
    self.mIsRobot = NO;
    self.mIsPush = isPush;
    self.mIsThreadClosed = NO;
    self.titleView.needsLoadingView = YES;
    self.titleView.loadingViewHidden = NO;
    self.mTitle = title;
    self.titleView.title = title;
    self.titleView.subtitle = @"连接中...";
    self.titleView.style = QMUINavigationTitleViewStyleSubTitleVertical;
    //
    self.mWorkGroupWid = wId;
    self.mThreadModel = [[BDThreadModel alloc] init];
    self.mThreadType = BD_THREAD_TYPE_THREAD;
    self.mRequestType = BD_THREAD_REQUEST_TYPE_WORK_GROUP;
    //
    self.rateScore = 5;
    self.rateNote = @"";
    self.rateInvite = false;
    self.mLastMessageId = INT_MAX;
    //
//    UIBarButtonItem *rightItem = [UIBarButtonItem qmui_itemWithButton:[[QMUINavigationButton alloc] initWithType:QMUINavigationButtonTypeNormal title:@"评价"] target:self action:@selector(handleRightBarButtonItemClicked:)];
    
    UIBarButtonItem *rightItem = [UIBarButtonItem qmui_itemWithImage:[UIImage imageNamed:@"icon_more" inBundle:[NSBundle bundleForClass:self.class] compatibleWithTraitCollection:nil] target:self action:@selector(handleRightBarButtonItemClicked:)];
    self.navigationItem.rightBarButtonItem = rightItem;
    
    //
    [BDCoreApis requestThreadWithWorkGroupWid:wId resultSuccess:^(NSDictionary *dict) {
//        DDLogInfo(@"%s, %@", __PRETTY_FUNCTION__, dict);
        //
        [self dealWithRequestThreadResult:dict];
    } resultFailed:^(NSError *error) {
        DDLogError(@"%s, %@", __PRETTY_FUNCTION__, error);
        if (error) {
            [QMUITips showError:error.localizedDescription inView:self.view hideAfterDelay:3];
        }
    }];
}

- (void)initWithWorkGroupWid:(NSString *)wId withTitle:(NSString *)title withPush:(BOOL)isPush withCustom:(NSDictionary *)custom {
    //
    self.mWithCustomDict = TRUE;
    self.mCustomDict = custom;
    //
    [self initWithWorkGroupWid:wId withTitle:title withPush:isPush];
}


- (void)initWithAgentUid:(NSString *)uId withTitle:(NSString *)title withPush:(BOOL)isPush {
    //
    self.mIsVisitor = YES;
    self.mIsRobot = NO;
    self.mIsPush = isPush;
    self.mIsThreadClosed = NO;
    self.titleView.needsLoadingView = YES;
    self.titleView.loadingViewHidden = NO;
    self.mTitle = title;
    self.titleView.title = title;
    self.titleView.subtitle = @"连接中...";
    self.titleView.style = QMUINavigationTitleViewStyleSubTitleVertical;
    //
    self.mAgentUid = uId;
    self.mThreadModel = [[BDThreadModel alloc] init];
    self.mThreadType = BD_THREAD_TYPE_THREAD;
    self.mRequestType = BD_THREAD_REQUEST_TYPE_APPOINTED;
    //
    self.rateScore = 5;
    self.rateNote = @"";
    self.rateInvite = false;
    self.mLastMessageId = INT_MAX;
    //
    UIBarButtonItem *rightItem = [UIBarButtonItem qmui_itemWithImage:[UIImage imageNamed:@"icon_more" inBundle:[NSBundle bundleForClass:self.class] compatibleWithTraitCollection:nil] target:self action:@selector(handleRightBarButtonItemClicked:)];
    self.navigationItem.rightBarButtonItem = rightItem;
    //
    [BDCoreApis requestThreadWithAgentUid:uId resultSuccess:^(NSDictionary *dict) {
        DDLogInfo(@"%s, %@", __PRETTY_FUNCTION__, dict);
        //
        [self dealWithRequestThreadResult:dict];
        
    } resultFailed:^(NSError *error) {
        DDLogError(@"%s, %@", __PRETTY_FUNCTION__, error);
        if (error) {
            [QMUITips showError:error.localizedDescription inView:self.view hideAfterDelay:3];
        }
    }];
}


- (void) initWithAgentUid:(NSString *)uId withTitle:(NSString *)title withPush:(BOOL)isPush withCustom:(NSDictionary *)custom {
    //
    self.mWithCustomDict = TRUE;
    self.mCustomDict = custom;
    //
    [self initWithAgentUid:uId withTitle:title withPush:isPush];
}

/**
 * 返回结果代码：
 *
 * 200：请求会话成功-创建新会话
 * 201：请求会话成功-继续进行中会话
 * 202：请求会话成功-排队中
 * 203：请求会话成功-当前非工作时间，请自助查询或留言
 * 204：请求会话成功-当前无客服在线，请自助查询或留言
 *
 * -1: 请求会话失败-access token无效
 * -2：请求会话失败-wId不存在
 */
- (void)dealWithRequestThreadResult:(NSDictionary *)dict {
    // 如果点击了左上角返回或关闭按钮之后，网络请求才返回m，则不需要继续处理此返回结果
    if (self.mIsViewControllerClosed) {
        return;
    }
    //
    NSString *message = [dict objectForKey:@"message"];
    NSNumber *status_code = [dict objectForKey:@"status_code"];
    DDLogInfo(@"%s message:%@, status_code:%@", __PRETTY_FUNCTION__, message, status_code);
    
    if ([status_code isEqualToNumber:[NSNumber numberWithInt:200]] ||
        [status_code isEqualToNumber:[NSNumber numberWithInt:201]]) {
        // 创建新会话 / 继续进行中会话
        
        // 解析数据
        self.mThreadModel = [[BDThreadModel alloc] initWithDictionary:dict[@"data"][@"thread"]];
        self.mThreadTid = self.mThreadModel.tid;
        self.threadTopic = [NSString stringWithFormat:@"thread/%@", self.mThreadTid];
        
        // 订阅主题
        [[BDMQTTApis sharedInstance] subscribeTopic:self.threadTopic];

        // 修改UI界面
        NSNumber *appointed = dict[@"data"][@"thread"][@"appointed"];
        if ([appointed boolValue]) {
            self.titleView.title = dict[@"data"][@"thread"][@"agent"][@"nickname"];
        } else {
            self.titleView.title = dict[@"data"][@"thread"][@"workGroup"][@"nickname"];
        }
        self.titleView.subtitle = dict[@"message"];
        self.titleView.needsLoadingView = NO;

        // 保存聊天记录
        BDMessageModel *messageModel = [[BDMessageModel alloc] initWithDictionary:dict[@"data"]];
        [[BDDBApis sharedInstance] insertMessage:messageModel];
        //
        [self reloadTableData];
        
        // TODO: 发送商品信息
        if (self.mWithCustomDict) {
            NSString *customJson = [BDUtils dictToJson:self.mCustomDict];
            [self sendCommodityMessage:customJson];
        }
        
    } else if ([status_code isEqualToNumber:[NSNumber numberWithInt:202]]) {
        // 提示排队中
        
        // 解析数据
        self.mThreadModel = [[BDThreadModel alloc] initWithDictionary:dict[@"data"][@"thread"]];
        self.mThreadTid = self.mThreadModel.tid;
        self.threadTopic = [NSString stringWithFormat:@"thread/%@", self.mThreadTid];
        
        // 订阅主题
        [[BDMQTTApis sharedInstance] subscribeTopic:self.threadTopic];
        
        // 修改UI界面
        NSNumber *appointed = dict[@"data"][@"thread"][@"appointed"];
        if ([appointed boolValue]) {
            self.titleView.title = dict[@"data"][@"thread"][@"agent"][@"nickname"];
        } else {
            self.titleView.title = dict[@"data"][@"thread"][@"workGroup"][@"nickname"];
        }
        self.titleView.subtitle = dict[@"message"];
        self.titleView.needsLoadingView = NO;
        
        // 保存聊天记录
        BDMessageModel *messageModel = [[BDMessageModel alloc] initWithDictionary:dict[@"data"]];
        [[BDDBApis sharedInstance] insertMessage:messageModel];
        [self reloadTableData];
        
        // TODO: 发送商品信息
//        if (self.mWithCustomDict) {
//            NSString *customJson = [BDUtils dictToJson:self.mCustomDict];
//            [self sendCommodityMessage:customJson];
//        }
        
    } else if ([status_code isEqualToNumber:[NSNumber numberWithInt:203]]) {
        // 当前非工作时间，请自助查询或留言
        
        // 解析数据
        self.mThreadModel = [[BDThreadModel alloc] initWithDictionary:dict[@"data"][@"thread"]];
        self.mThreadTid = self.mThreadModel.tid;
        self.threadTopic = [NSString stringWithFormat:@"thread/%@", self.mThreadTid];
        
        // 订阅主题
        [[BDMQTTApis sharedInstance] subscribeTopic:self.threadTopic];
        
        // 修改UI界面
        NSNumber *appointed = dict[@"data"][@"thread"][@"appointed"];
        if ([appointed boolValue]) {
            self.titleView.title = dict[@"data"][@"thread"][@"agent"][@"nickname"];
        } else {
            self.titleView.title = dict[@"data"][@"thread"][@"workGroup"][@"nickname"];
        }
        self.titleView.subtitle = dict[@"message"];
        self.titleView.needsLoadingView = NO;
        
        // 保存聊天记录
        BDMessageModel *messageModel = [[BDMessageModel alloc] initWithDictionary:dict[@"data"]];
        [[BDDBApis sharedInstance] insertMessage:messageModel];
        [self reloadTableData];
        
    } else if ([status_code isEqualToNumber:[NSNumber numberWithInt:204]]) {
        // 当前无客服在线，请自助查询或留言
        
        // 解析数据
        self.mThreadModel = [[BDThreadModel alloc] initWithDictionary:dict[@"data"][@"thread"]];
        self.mThreadTid = self.mThreadModel.tid;
        self.threadTopic = [NSString stringWithFormat:@"thread/%@", self.mThreadTid];
        
        // 订阅主题
        [[BDMQTTApis sharedInstance] subscribeTopic:self.threadTopic];
        
        // 修改UI界面
        NSNumber *appointed = dict[@"data"][@"thread"][@"appointed"];
        if ([appointed boolValue]) {
            self.titleView.title = dict[@"data"][@"thread"][@"agent"][@"nickname"];
        } else {
            self.titleView.title = dict[@"data"][@"thread"][@"workGroup"][@"nickname"];
        }
        self.titleView.subtitle = dict[@"message"];
        self.titleView.needsLoadingView = NO;
        
        // 保存聊天记录
        BDMessageModel *messageModel = [[BDMessageModel alloc] initWithDictionary:dict[@"data"]];
        [[BDDBApis sharedInstance] insertMessage:messageModel];
        [self reloadTableData];
        
    } else if ([status_code isEqualToNumber:[NSNumber numberWithInt:205]]) {
        // TODO: 咨询前问卷
        DDLogInfo(@"dict %@", dict);
        
        // 修改UI界面
        self.titleView.title = dict[@"data"][@"thread"][@"workGroup"][@"nickname"];
//        self.titleView.subtitle = dict[@"message"];
        self.titleView.needsLoadingView = NO;
        self.mThreadTid = dict[@"data"][@"thread"][@"tid"];
        
        // 弹窗标题
        NSString *title = @"";
        // 存储key/value: content/qid
        NSMutableDictionary *questionDict = [[NSMutableDictionary alloc] init];
        // 存储key/value: content/workGroups
        NSMutableDictionary *workGroupDict = [[NSMutableDictionary alloc] init];
        // content数组
        NSMutableArray *questionArray = [[NSMutableArray alloc] init];
        //
        NSMutableArray *questionnaireItemsArray = dict[@"data"][@"questionnaire"][@"questionnaireItems"];
        for (NSDictionary *questionItemDict in questionnaireItemsArray) {
            // for循环目前只有一个元素
            title = questionItemDict[@"title"];
            //
            NSMutableArray *questionnaireItemItemsArray = questionItemDict[@"questionnaireItemItems"];
            for (NSDictionary *questionnaireItemItemsDict in questionnaireItemItemsArray) {
                //
                NSLog(@"content %@", questionnaireItemItemsDict[@"content"]);
                questionDict[questionnaireItemItemsDict[@"content"]] = questionnaireItemItemsDict[@"qid"];
                workGroupDict[questionnaireItemItemsDict[@"content"]] = questionnaireItemItemsDict[@"workGroups"];
                [questionArray addObject:questionnaireItemItemsDict[@"content"]];
            }
        }
        //
        QMUIDialogSelectionViewController *dialogViewController = [[QMUIDialogSelectionViewController alloc] init];
        dialogViewController.title = title;
        dialogViewController.items = questionArray;
        dialogViewController.cellForItemBlock = ^(QMUIDialogSelectionViewController *aDialogViewController, QMUITableViewCell *cell, NSUInteger itemIndex) {
            cell.accessoryType = UITableViewCellAccessoryNone;// 移除点击时默认加上右边的checkbox
        };
        dialogViewController.heightForItemBlock = ^CGFloat (QMUIDialogSelectionViewController *aDialogViewController, NSUInteger itemIndex) {
            return 54;// 修改默认的行高，默认为 TableViewCellNormalHeight
        };
        dialogViewController.didSelectItemBlock = ^(QMUIDialogSelectionViewController *aDialogViewController, NSUInteger itemIndex) {
            //
            NSString *content = questionArray[itemIndex];
            NSString *qid = questionDict[content];
            DDLogInfo(@"content: %@, qid: %@", content, qid);
            //
            // 留学: 意向国家 qid = '201810061551181'
            // 移民：意向国家 qid = '201810061551183'
            // 语培：意向类别 qid = '201810061551182'
            // 其他：意向类别 qid = '201810061551184'
            // 院校：意向院校 qid = '201810061551185'
            //
            NSMutableArray *workGroupsArray = workGroupDict[content];
            if ([qid isEqualToString:@"201810061551181"]) {
                // 单独处理 留学: 意向国家 qid = '201810061551181'
//                [self requestQuestionnaire:qid];
                [self showWorkGroupDialog:workGroupsArray isLiuXue:YES];
            } else {
                [self showWorkGroupDialog:workGroupsArray isLiuXue:NO];
            }
            //
            [aDialogViewController hide];
        };
        [dialogViewController show];
        
        // 保存聊天记录
//        BDMessageModel *messageModel = [[BDMessageModel alloc] initWithDictionary:dict[@"data"]];
//        [[BDDBApis sharedInstance] insertMessage:messageModel];
//        [self reloadTableData];
        
    } else {
        // 请求会话失败
        [QMUITips showError:dict[@"message"] inView:self.view hideAfterDelay:2.0f];
    }
}

//- (void)requestQuestionnaire:(NSString *)itemQid {
//
//    [BDCoreApis requestQuestionnairWithTid:self.mThreadTid itemQid:itemQid resultSuccess:^(NSDictionary *dict) {
////        DDLogInfo(@"%s, %@", __PRETTY_FUNCTION__, dict);
//        if (self.mIsViewControllerClosed) {
//            return;
//        }
//        //
//        NSNumber *status_code = [dict objectForKey:@"status_code"];
//        if ([status_code isEqualToNumber:[NSNumber numberWithInt:200]]) {
//            //
//            // NSString *title = dict[@"data"][@"content"];
//            NSMutableArray *workGroupsArray = dict[@"data"][@"workGroups"];
//            [self showWorkGroupDialog:workGroupsArray];
//
//        } else {
//            NSString *message = [dict objectForKey:@"message"];
//            [QMUITips showError:message inView:self.view hideAfterDelay:2.0];
//        }
//
//    } resultFailed:^(NSError *error) {
//        DDLogError(@"%s %@", __PRETTY_FUNCTION__, error);
//        if (error) {
//            [QMUITips showError:error.localizedDescription inView:self.view hideAfterDelay:3];
//        }
//    }];
//}

- (void)showWorkGroupDialog:(NSMutableArray *)workGroupsArray isLiuXue:(BOOL)isLiuXue {
    
    NSMutableDictionary *workGroupDict = [[NSMutableDictionary alloc] init];
    NSMutableArray *workGroupNamesArray = [[NSMutableArray alloc] init];
    //
    for (NSDictionary *workGroupObjectDict in workGroupsArray) {
        //
        workGroupDict[workGroupObjectDict[@"nickname"]] = workGroupObjectDict[@"wid"];
        [workGroupNamesArray addObject:workGroupObjectDict[@"nickname"]];
    }
    //
    QMUIDialogSelectionViewController *dialogViewController = [[QMUIDialogSelectionViewController alloc] init];
    dialogViewController.title = @"请选择";
    dialogViewController.items = workGroupNamesArray;
    dialogViewController.cellForItemBlock = ^(QMUIDialogSelectionViewController *aDialogViewController, QMUITableViewCell *cell, NSUInteger itemIndex) {
        cell.accessoryType = UITableViewCellAccessoryNone;// 移除点击时默认加上右边的checkbox
    };
    dialogViewController.heightForItemBlock = ^CGFloat (QMUIDialogSelectionViewController *aDialogViewController, NSUInteger itemIndex) {
        return 54;// 修改默认的行高，默认为 TableViewCellNormalHeight
    };
    dialogViewController.didSelectItemBlock = ^(QMUIDialogSelectionViewController *aDialogViewController, NSUInteger itemIndex) {
        //
        NSString *nickname = workGroupNamesArray[itemIndex];
        NSString *wid = workGroupDict[nickname];
        DDLogInfo(@"nickname: %@, wid: %@", nickname, wid);
        //
        if (isLiuXue) {
            [self chooseWorkGroupLiuXue:wid withWorkGroupNickname:nickname];
        } else {
            [self chooseWorkGroup:wid];
        }
        
        [aDialogViewController hide];
    };
    [dialogViewController show];
}

- (void)chooseWorkGroup:(NSString *)workGroupWid {
    
    [BDCoreApis requestChooseWorkGroup:workGroupWid resultSuccess:^(NSDictionary *dict) {
//        DDLogInfo(@"%s, %@", __PRETTY_FUNCTION__, dict);
        
        self.mWorkGroupWid = workGroupWid;
        
        [self dealWithRequestThreadResult:dict];
        
    } resultFailed:^(NSError *error) {
        DDLogError(@"%s %@", __PRETTY_FUNCTION__, error);
        if (error) {
            [QMUITips showError:error.localizedDescription inView:self.view hideAfterDelay:3];
        }
    }];
}

- (void)chooseWorkGroupLiuXue:(NSString *)workGroupWid withWorkGroupNickname:(NSString *)nickname {
    
    [BDCoreApis requestChooseWorkGroupLiuXue:workGroupWid withWorkGroupNickname:nickname resultSuccess:^(NSDictionary *dict) {
        //        DDLogInfo(@"%s, %@", __PRETTY_FUNCTION__, dict);
        
        self.mWorkGroupWid = workGroupWid;
        
        [self dealWithRequestThreadResult:dict];
        
    } resultFailed:^(NSError *error) {
        DDLogError(@"%s %@", __PRETTY_FUNCTION__, error);
        if (error) {
            [QMUITips showError:error.localizedDescription inView:self.view hideAfterDelay:3];
        }
    }];
}

#pragma mark - 客服端接口

- (void)initWithThreadModel:(BDThreadModel *)threadModel withPush:(BOOL)isPush {
    
    // 变量初始化
    self.mIsVisitor = NO;
    self.mIsPush = isPush;
    self.mThreadModel = threadModel;
    self.mThreadType = threadModel.type;
    self.mLastMessageId = INT_MAX;
    //
    if ([self.mThreadType isEqualToString:BD_THREAD_TYPE_THREAD]) {
        // 客服会话
        self.mThreadTid = self.mThreadModel.tid;
        self.mUid = self.mThreadModel.visitor_uid;
    } else if ([self.mThreadType isEqualToString:BD_THREAD_TYPE_CONTACT]) {
        // 联系人会话
        self.mThreadTid = self.mThreadModel.contact_uid;
        self.mUid = self.mThreadModel.contact_uid;
    } else if ([self.mThreadType isEqualToString:BD_THREAD_TYPE_GROUP]) {
        // 群组会话
        self.mThreadTid = self.mThreadModel.group_gid;
        self.mUid = self.mThreadModel.group_gid;
    }
    // 右上角按钮
//    UIBarButtonItem *rightItem = [UIBarButtonItem qmui_itemWithImage:[UIImage imageNamed:@"icon_more" inBundle:[NSBundle bundleForClass:self.class] compatibleWithTraitCollection:nil] target:self action:@selector(handleRightBarButtonItemClicked:)];
//    self.navigationItem.rightBarButtonItem = rightItem;
}

- (void) initWithThreadModel:(BDThreadModel *)threadModel withPush:(BOOL)isPush withCustom:(NSDictionary *)custom {
    //
    [self initWithThreadModel:threadModel withPush:isPush];
    
    // TODO: 发送商品信息
    NSString *customJson = [BDUtils dictToJson:custom];
    [self sendCommodityMessage:customJson];
}

- (void) initWithContactModel:(BDContactModel *)contactModel withPush:(BOOL)isPush {
    
    // 变量初始化
    self.mIsVisitor = NO;
    self.mIsPush = isPush;
    self.mContactModel = contactModel;
    self.mThreadTid = self.mContactModel.uid;
    self.mUid = self.mContactModel.uid;
    self.mThreadType = BD_THREAD_TYPE_CONTACT;
    self.mTitle = self.mContactModel.real_name;
    self.mLastMessageId = INT_MAX;
 
    // FIXME: 因为点击右上角按钮初始化需要用到threadModel, 暂时隐藏不启用右上角按钮
    UIBarButtonItem *rightItem = [UIBarButtonItem qmui_itemWithImage:[UIImage imageNamed:@"icon_about" inBundle:[NSBundle bundleForClass:self.class] compatibleWithTraitCollection:nil] target:self action:@selector(handleRightBarButtonItemClicked:)];
    self.navigationItem.rightBarButtonItem = rightItem;
}

- (void) initWithContactModel:(BDContactModel *)contactModel withPush:(BOOL)isPush withCustom:(NSDictionary *)custom {
    //
    [self initWithContactModel:contactModel withPush:isPush];
    
    // TODO: 发送商品信息
    NSString *customJson = [BDUtils dictToJson:custom];
    [self sendCommodityMessage:customJson];
}


- (void) initWithGroupModel:(BDGroupModel *)groupModel withPush:(BOOL)isPush {
    
    // 变量初始化
    self.mIsVisitor = NO;
    self.mIsPush = isPush;
    self.mGroupModel = groupModel;
    self.mThreadTid = self.mGroupModel.gid;
    self.mUid = self.mGroupModel.gid;
    self.mThreadType = BD_THREAD_TYPE_GROUP;
    self.mTitle = self.mGroupModel.nickname;
    self.mLastMessageId = INT_MAX;
    
    // 右上角按钮
    UIBarButtonItem *rightItem = [UIBarButtonItem qmui_itemWithImage:[UIImage imageNamed:@"icon_about" inBundle:[NSBundle bundleForClass:self.class] compatibleWithTraitCollection:nil] target:self action:@selector(handleRightBarButtonItemClicked:)];
    self.navigationItem.rightBarButtonItem = rightItem;
}

- (void) initWithGroupModel:(BDGroupModel *)groupModel withPush:(BOOL)isPush withCustom:(NSDictionary *)custom {
    //
    [self initWithGroupModel:groupModel withPush:isPush];
    
    // TODO: 发送商品信息
    NSString *customJson = [BDUtils dictToJson:custom];
    [self sendCommodityMessage:customJson];
}


#pragma mark - 公共函数

- (void)initSubviews {
    [super initSubviews];
    //
    self.tableView.separatorColor = [UIColor clearColor];
    //
    _toolbarView = [[UIView alloc] init];
    self.toolbarView.backgroundColor = UIColorWhite;
    self.toolbarView.qmui_borderColor = UIColorSeparator;
    self.toolbarView.qmui_borderPosition = QMUIViewBorderPositionTop;
    [self.view addSubview:self.toolbarView];
    
    _toolbarTextField = [[QMUITextField alloc] init];
    self.toolbarTextField.delegate = self;
    self.toolbarTextField.placeholder = @"请输入...";
    self.toolbarTextField.font = UIFontMake(15);
    self.toolbarTextField.backgroundColor = UIColorWhite;
    self.toolbarTextField.returnKeyType = UIReturnKeySend;
    [self.toolbarView addSubview:self.toolbarTextField];
    
    __weak __typeof(self)weakSelf = self;
    self.toolbarTextField.qmui_keyboardWillChangeFrameNotificationBlock = ^(QMUIKeyboardUserInfo *keyboardUserInfo) {
        if (!weakSelf.plusButton.isSelected) {
            [QMUIKeyboardManager handleKeyboardNotificationWithUserInfo:keyboardUserInfo showBlock:^(QMUIKeyboardUserInfo *keyboardUserInfo) {
                [weakSelf showToolbarViewWithKeyboardUserInfo:keyboardUserInfo];
            } hideBlock:^(QMUIKeyboardUserInfo *keyboardUserInfo) {
                [weakSelf hideToolbarViewWithKeyboardUserInfo:keyboardUserInfo];
            }];
        } else {
            [weakSelf showToolbarViewWithKeyboardUserInfo:nil];
        }
    };
    
    self.sendButton = [[QMUIButton alloc] init];
    self.sendButton.titleLabel.font = UIFontMake(16);
    [self.sendButton setTitle:@"发送" forState:UIControlStateNormal];
    [self.sendButton sizeToFit];
    [self.sendButton addTarget:self action:@selector(handleSendButtonEvent:) forControlEvents:UIControlEventTouchUpInside];
    [self.toolbarView addSubview:self.sendButton];
    ///
    self.plusButton = [[QMUIButton alloc] init];
    self.plusButton.titleLabel.font = UIFontMake(16);
    self.plusButton.qmui_outsideEdge = UIEdgeInsetsMake(-12, -12, -12, -12);
    [self.plusButton setImage:[UIImage imageNamed:@"TypeSelectorBtn_Black_ios7" inBundle:[NSBundle bundleForClass:self.class] compatibleWithTraitCollection:nil] forState:UIControlStateNormal];
    [self.plusButton setImage:[UIImage imageNamed:@"TypeSelectorBtnHL_Black_ios7" inBundle:[NSBundle bundleForClass:self.class] compatibleWithTraitCollection:nil] forState:UIControlStateHighlighted];
    [self.plusButton sizeToFit];
    [self.plusButton addTarget:self action:@selector(handlePlusButtonEvent:) forControlEvents:UIControlEventTouchUpInside];
    [self.toolbarView addSubview:self.plusButton];
    //
    self.mGetMessageFromChannelPage = 0;
    
    UITapGestureRecognizer *singleFingerTap =
    [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
    [self.tableView addGestureRecognizer:singleFingerTap];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
//    self.mInputView.frame = CGRectMake(0, KFDSScreen.height - BD_INPUTBAR_HEIGHT, KFDSScreen.width, BD_INPUTBAR_HEIGHT);
    //
    self.tableView.frame = CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds) - kToolbarHeight);
    
    CGRect toolbarRect = CGRectFlatMake(0, CGRectGetHeight(self.view.bounds) - kToolbarHeight, CGRectGetWidth(self.view.bounds), kToolbarHeight);
    self.toolbarView.frame = CGRectApplyAffineTransform(toolbarRect, self.toolbarView.transform);
    
    CGFloat textFieldInset = 20;
    CGFloat textFieldHeight = kToolbarHeight - textFieldInset * 2;
    CGFloat emotionRight = 12;
    
    self.sendButton.frame = CGRectSetXY(self.sendButton.frame, CGRectGetWidth(self.toolbarView.bounds) - CGRectGetWidth(self.sendButton.bounds) - emotionRight, CGFloatGetCenter(CGRectGetHeight(self.toolbarView.bounds), CGRectGetHeight(self.sendButton.bounds)));
    
    self.plusButton.frame = CGRectSetXY(self.plusButton.frame, 12, CGFloatGetCenter(CGRectGetHeight(self.toolbarView.bounds), CGRectGetHeight(self.plusButton.bounds)));
    
    CGFloat textFieldWidth = CGRectGetMinX(self.sendButton.frame) - textFieldInset * 2;
    self.toolbarTextField.frame = CGRectFlatMake(50, textFieldInset, textFieldWidth, textFieldHeight);

}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    DDLogInfo(@"%s", __PRETTY_FUNCTION__);
    //
    self.title = self.mThreadModel ? self.mThreadModel.nickname : self.mTitle;
    if ([self.mThreadType isEqualToString:BD_THREAD_TYPE_GROUP]) {
        // 群组会话, FIXME: self.mGroupModel未初始化
        // self.title = [NSString stringWithFormat:@"群聊(%@)", self.mGroupModel.member_count];
    }
//    self.parentView = self.navigationController.view;
//    [self.view setQmui_shouldShowDebugColor:YES];
    //
    if (self.mIsPush) {
        self.navigationItem.leftBarButtonItem = [UIBarButtonItem qmui_backItemWithTarget:self action:@selector(handleBackButtonEvent:)];// 自定义返回按钮要自己写代码去 pop 界面
        self.forceEnableBackGesture = YES;// 当系统的返回按钮被屏蔽的时候，系统的手势返回也会跟着失效，所以这里要手动强制打开手势返回
    }
    else {
        self.navigationItem.leftBarButtonItem = [UIBarButtonItem qmui_closeItemWithTarget:self action:@selector(handleCloseButtonEvent:)];
        self.forceEnableBackGesture = YES;
    }
    //
    self.mRefreshControl = [[UIRefreshControl alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
    [self.tableView addSubview:self.mRefreshControl];
    [self.mRefreshControl addTarget:self action:@selector(refreshMessages) forControlEvents:UIControlEventValueChanged];
    //
    self.mImagePickerController = [[UIImagePickerController alloc] init];
    self.mImagePickerController.delegate = self;
    //
    if (![BDSettings isAlreadyLogin]) {
        [QMUITips showError:@"请首先登录" inView:self.view hideAfterDelay:2];
        return;
    }
    //
    [self registerNotifications];
    [self reloadTableData];
    // 从服务器加载聊天记录
    [self refreshMessages];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setNavigationItemsIsInEditMode:(BOOL)isInEditMode animated:(BOOL)animated {
//    [super setNavigationItemsIsInEditMode:isInEditMode animated:animated];
}

// 针对Present打开模式，左上角返回按钮处理action
- (void)handleCloseButtonEvent:(id)sender {
    DDLogInfo(@"%s", __PRETTY_FUNCTION__);
    self.mIsViewControllerClosed = YES;
    [self.navigationController dismissViewControllerAnimated:YES completion:^{
    }];
}

// 针对Push打开模式，左上角返回按钮处理action
- (void)handleBackButtonEvent:(id)sender {
    DDLogInfo(@"%s", __PRETTY_FUNCTION__);
    self.mIsViewControllerClosed = YES;
    [self.navigationController popViewControllerAnimated:YES];
}

//#pragma mark - <QMUINavigationControllerDelegate>
//
//- (void)navigationController:(QMUINavigationController *)navigationController poppingByInteractiveGestureRecognizer:(UIScreenEdgePanGestureRecognizer *)gestureRecognizer viewControllerWillDisappear:(UIViewController *)viewControllerWillDisappear viewControllerWillAppear:(UIViewController *)viewControllerWillAppear {
//    DDLogInfo(@"%s", __PRETTY_FUNCTION__);
//
//    if (gestureRecognizer.state == UIGestureRecognizerStateEnded) {
//        if (viewControllerWillDisappear == self) {
//            self.mIsViewControllerClosed = YES;
//            [QMUITips showSucceed:@"松手了，界面发生切换"];
//        } else if (viewControllerWillAppear == self) {
//            [QMUITips showInfo:@"松手了，没有触发界面切换"];
//        }
//        return;
//    }
//}

- (BOOL)forceEnableInteractivePopGestureRecognizer {
    return self.forceEnableBackGesture;
}

- (void)handleRightBarButtonItemClicked:(id)sender {
    DDLogInfo(@"%s", __PRETTY_FUNCTION__);
    
    // 访客端
    if (self.mIsVisitor) {
        
//        [self showRateView];
        
        QMUIAlertAction *leaveMessageAction = [QMUIAlertAction actionWithTitle:@"留言" style:QMUIAlertActionStyleCancel handler:^(QMUIAlertController *aAlertController, QMUIAlertAction *action) {
            
            //
            BDLeaveMessageViewController *leaveMessageVC = [[BDLeaveMessageViewController alloc] init];
            [leaveMessageVC initWithType:self.mRequestType workGroupWid:self.mWorkGroupWid agentUid:self.mAgentUid];
            [self.navigationController pushViewController:leaveMessageVC animated:YES];
            
        }];
        
        NSString *title = self.mIsRobot ? @"人工客服" : @"机器人";
        QMUIAlertAction *robotAction = [QMUIAlertAction actionWithTitle:title style:QMUIAlertActionStyleDestructive handler:^(QMUIAlertController *aAlertController, QMUIAlertAction *action) {
            
            if (self.mIsRobot) {
                
                // TODO: 切换人工客服
                if ([self.mRequestType isEqualToString:BD_THREAD_REQUEST_TYPE_WORK_GROUP]) {
                    
                    //
                    [BDCoreApis requestThreadWithWorkGroupWid:self.mWorkGroupWid resultSuccess:^(NSDictionary *dict) {
                        //        DDLogInfo(@"%s, %@", __PRETTY_FUNCTION__, dict);
                        //
                        [self dealWithRequestThreadResult:dict];
                    } resultFailed:^(NSError *error) {
                        DDLogError(@"%s, %@", __PRETTY_FUNCTION__, error);
                        if (error) {
                            [QMUITips showError:error.localizedDescription inView:self.view hideAfterDelay:3];
                        }
                    }];
                    
                } else {
                    
                    //
                    [BDCoreApis requestThreadWithAgentUid:self.mAgentUid resultSuccess:^(NSDictionary *dict) {
                        DDLogInfo(@"%s, %@", __PRETTY_FUNCTION__, dict);
                        //
                        [self dealWithRequestThreadResult:dict];
                        
                    } resultFailed:^(NSError *error) {
                        DDLogError(@"%s, %@", __PRETTY_FUNCTION__, error);
                        if (error) {
                            [QMUITips showError:error.localizedDescription inView:self.view hideAfterDelay:3];
                        }
                    }];
                }
                
            } else {
                
                // 切换机器人
                [BDCoreApis initAnswer:self.mRequestType withWorkGroupWid:self.mWorkGroupWid withAgentUid:self.mAgentUid resultSuccess:^(NSDictionary *dict) {
                    DDLogInfo(@"%s, %@", __PRETTY_FUNCTION__, dict);
                    
                    // TODO: 待优化
                    NSDictionary *messageDict = dict[@"data"];
                    BDMessageModel *messageModel = [[BDMessageModel alloc] initWithDictionary:messageDict];
                    [[BDDBApis sharedInstance] insertMessage:messageModel];
                    
                    [self reloadTableData];
                    
                } resultFailed:^(NSError *error) {
                    DDLogError(@"%s, %@", __PRETTY_FUNCTION__, error);
                    if (error) {
                        [QMUITips showError:error.localizedDescription inView:self.view hideAfterDelay:3];
                    }
                }];
                
            }
            // 置反
            self.mIsRobot = !self.mIsRobot;
        }];
        QMUIAlertController *alertController = [QMUIAlertController alertControllerWithTitle:@"提示" message:@"" preferredStyle:QMUIAlertControllerStyleActionSheet];
        [alertController addAction:leaveMessageAction];
        [alertController addAction:robotAction];
        [alertController showWithAnimated:YES];
        
    } else {
        //
        if ([self.mThreadType isEqualToString:BD_THREAD_TYPE_THREAD]) {
            // 客服会话
            QMUIAlertAction *cancelAction = [QMUIAlertAction actionWithTitle:@"取消" style:QMUIAlertActionStyleCancel handler:^(QMUIAlertController *aAlertController, QMUIAlertAction *action) {
            }];
            QMUIAlertAction *closeAction = [QMUIAlertAction actionWithTitle:@"关闭" style:QMUIAlertActionStyleDestructive handler:^(QMUIAlertController *aAlertController, QMUIAlertAction *action) {
                // 客服关闭会话
                [BDCoreApis agentCloseThread:self.mThreadModel.tid resultSuccess:^(NSDictionary *dict) {

                    NSNumber *status_code = [dict objectForKey:@"status_code"];
                    if ([status_code isEqualToNumber:[NSNumber numberWithInt:200]]) {
                        // 关闭成功
                        // 关闭当前会话窗口
                        if (self.mIsPush) {
                            [self.navigationController popViewControllerAnimated:YES];
                        } else {
                            [self.navigationController dismissViewControllerAnimated:YES completion:^{}];
                        }
                    } else {
                        
                        NSString *message = dict[@"message"];
                        DDLogError(@"%s %@", __PRETTY_FUNCTION__, message);
                        [QMUITips showError:message inView:self.view hideAfterDelay:2];
                    }
                    
                } resultFailed:^(NSError *error) {
                     DDLogError(@"%s %@", __PRETTY_FUNCTION__, error);
                    if (error) {
                        [QMUITips showError:error.localizedDescription inView:self.view hideAfterDelay:3];
                    }
                }];
            }];
            QMUIAlertController *alertController = [QMUIAlertController alertControllerWithTitle:@"确定关闭会话？" message:@"" preferredStyle:QMUIAlertControllerStyleAlert];
            [alertController addAction:cancelAction];
            [alertController addAction:closeAction];
            [alertController showWithAnimated:YES];
        } else if ([self.mThreadType isEqualToString:BD_THREAD_TYPE_CONTACT]) {
            // 联系人会话
            BDContactProfileViewController *contactViewController = [[BDContactProfileViewController alloc] initWithStyle:UITableViewStyleGrouped];
            [contactViewController initWithUid:self.mUid];
            contactViewController.delegate = self;
            [self.navigationController pushViewController:contactViewController animated:YES];
        } else if ([self.mThreadType isEqualToString:BD_THREAD_TYPE_GROUP]) {
            // 群组会话
            BDGroupProfileViewController *groupViewController = [[BDGroupProfileViewController alloc] initWithStyle:UITableViewStyleGrouped];
            [groupViewController initWithGroupGid:self.mUid];
            groupViewController.delegate = self;
            [self.navigationController pushViewController:groupViewController animated:YES];
        }
    }
}

#pragma mark - <QMUITableViewDataSource, QMUITableViewDelegate>

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.mMessageArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *notifyIdentifier = @"notifyCell";
    static NSString *msgIdentifier = @"msgCell";
    //
    BDMessageModel *messageModel = [self.mMessageArray objectAtIndex:indexPath.row];
    if ([messageModel isNotification]) {
        //        DDLogInfo(@"通知 type: %@, content: %@", messageModel.type, messageModel.content);
        //
        BDMsgNotificationViewCell *cell = [tableView dequeueReusableCellWithIdentifier:notifyIdentifier];
        if (!cell) {
            cell = [[BDMsgNotificationViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:notifyIdentifier];
        }
        [cell initWithMessageModel:messageModel];
        cell.tag = indexPath.row;
        // 存储id最小的
        if ([messageModel.server_id integerValue] < self.mLastMessageId) {
            self.mLastMessageId = [messageModel.server_id integerValue];
        }
        //        DDLogInfo(@"server_id: %@, lastMessageId: %li", messageModel.server_id, (long)self.mLastMessageId);
        //
        return cell;
    } else if ([messageModel.type isEqualToString:BD_MESSAGE_TYPE_COMMODITY]) {
        
        //        DDLogInfo(@"商品 type: %@, content: %@", messageModel.type, messageModel.content);
        //
        BDCommodityTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:notifyIdentifier];
        if (!cell) {
            cell = [[BDCommodityTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:notifyIdentifier];
        }
        [cell initWithMessageModel:messageModel];
        cell.tag = indexPath.row;
        // 存储id最小的
        if ([messageModel.server_id integerValue] < self.mLastMessageId) {
            self.mLastMessageId = [messageModel.server_id integerValue];
        }
        //        DDLogInfo(@"server_id: %@, lastMessageId: %li", messageModel.server_id, (long)self.mLastMessageId);
        //
        return cell;
        
    } else {
        //
        BDMsgViewCell *cell = [tableView dequeueReusableCellWithIdentifier:msgIdentifier];
        if (!cell) {
            cell = [[BDMsgViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:msgIdentifier];
            cell.delegate = self;
        }
        //
        [cell initWithMessageModel:messageModel];
        cell.tag = indexPath.row;
        // 存储id最小的
        if ([messageModel.server_id integerValue] < self.mLastMessageId) {
            self.mLastMessageId = [messageModel.server_id integerValue];
        }
        //        DDLogInfo(@"server_id: %@, lastMessageId: %li", messageModel.server_id, (long)self.mLastMessageId);
        //
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    //
    CGFloat height = 0.0;
    //
    BDMessageModel *messageModel = [self.mMessageArray objectAtIndex:indexPath.row];
    if ([messageModel isNotification]) {
        //
        height = 55;
    } else {
        //
        if ([messageModel.type isEqualToString:BD_MESSAGE_TYPE_TEXT] ||
            [messageModel.type isEqualToString:BD_MESSAGE_TYPE_ROBOT]) {
            //
            if ([messageModel isSend]) {
                height = messageModel.contentSize.height + messageModel.contentViewInsets.top + messageModel.contentViewInsets.bottom + 30;
            } else {
                height = messageModel.contentSize.height + messageModel.contentViewInsets.top + messageModel.contentViewInsets.bottom + 40;
            }
            //
            if (height < 45) {
                height = 45;
            }
        } else if ([messageModel.type isEqualToString:BD_MESSAGE_TYPE_COMMODITY]) {
            height = 100;
        } else if ([messageModel.type isEqualToString:BD_MESSAGE_TYPE_IMAGE] ||
                   [messageModel.type isEqualToString:BD_MESSAGE_TYPE_RED_PACKET]) {
            height = 280;
        } else if ([messageModel.type isEqualToString:BD_MESSAGE_TYPE_VOICE]) {
            height = 90;
        } else if ([messageModel.type isEqualToString:BD_MESSAGE_TYPE_FILE]) {
            height = 100;
        } else {
            height = 80;
        }
    }
    //
    return height;
}

#pragma mark - 加载本地数据库聊天记录

- (void)reloadTableData {
    //
    if (self.mIsVisitor) {
        //
        if ([self.mRequestType isEqualToString:BD_THREAD_REQUEST_TYPE_APPOINTED]) {
            DDLogInfo(@"1. 访客端获取聊天记录: 指定坐席 %@", self.mThreadTid);
            self.mMessageArray = [BDCoreApis getMessagesWithThread:self.mThreadTid];
        } else {
            DDLogInfo(@"1. 访客端获取聊天记录：工作组 %@", self.mWorkGroupWid);
            self.mMessageArray = [BDCoreApis getMessagesWithWorkGroup:self.mWorkGroupWid];
        }
    } else if ([self.mThreadType isEqualToString:BD_THREAD_TYPE_THREAD]) {
        DDLogInfo(@"2. 客服端获取聊天记录 %@", self.mUid);
        self.mMessageArray = [BDCoreApis getMessagesWithUser:self.mUid];
        // 更新当前会话
        [self updateCurrentThread];
    } else if ([self.mThreadType isEqualToString:BD_THREAD_TYPE_CONTACT]) {
        DDLogInfo(@"3. 客服端：联系人聊天记录 %@", self.mUid);
        self.mMessageArray = [BDCoreApis getMessagesWithContact:self.mUid];
    } else if ([self.mThreadType isEqualToString:BD_THREAD_TYPE_GROUP]) {
        DDLogInfo(@"4. 客服端：群组聊天记录 %@", self.mUid);
        self.mMessageArray = [BDCoreApis getMessagesWithGroup:self.mUid];
    }
    //
    if ([self.mMessageArray count] == 0) {
        //
        [self showEmptyViewWithText:@"消息记录为空" detailText:@"请尝试下拉刷新" buttonTitle:nil buttonAction:NULL];
    } else if (self.emptyViewShowing) {
        //
        [self hideEmptyView];
    }
    // 刷新tableView
    [self.tableView reloadData];
    [self tableViewScrollToBottom:NO];
}

- (void)reloadCellDataSuccess:(NSString *)localId {
    for (int i = 0; i < [self.mMessageArray count]; i++) {
        BDMessageModel *message = [self.mMessageArray objectAtIndex:i];
        if (![message.local_id isKindOfClass:[NSNull class]] &&
            [message.local_id isEqualToString:localId]) {
            // 更新内存数据
            message.status = BD_MESSAGE_STATUS_STORED;
            // 更新UI
            NSIndexPath *reloadIndexPath = [NSIndexPath indexPathForRow:i inSection:0];
            [self.tableView beginUpdates];
            [self.tableView reloadRowsAtIndexPaths:@[reloadIndexPath] withRowAnimation:UITableViewRowAnimationNone];
            [self.tableView endUpdates];
        }
    }
}

- (void)reloadCellDataError:(NSString *)localId {
    for (int i = 0; i < [self.mMessageArray count]; i++) {
        BDMessageModel *message = [self.mMessageArray objectAtIndex:i];
        if (![message.local_id isKindOfClass:[NSNull class]] &&
            [message.local_id isEqualToString:localId]) {
            // 更新内存数据
            message.status = BD_MESSAGE_STATUS_ERROR;
            // 更新UI
            NSIndexPath *reloadIndexPath = [NSIndexPath indexPathForRow:i inSection:0];
            [self.tableView beginUpdates];
            [self.tableView reloadRowsAtIndexPaths:@[reloadIndexPath] withRowAnimation:UITableViewRowAnimationNone];
            [self.tableView endUpdates];
        }
    }
}

- (void)updateCurrentThread {
    NSString *preTid = [BDSettings getCurrentTid];
    [BDCoreApis updateCurrentThread:preTid currentTid:self.mThreadTid resultSuccess:^(NSDictionary *dict) {
        [BDSettings setCurrentTid:self.mThreadTid];
    } resultFailed:^(NSError *error) {
        DDLogError(@"updateCurrentThread %@", error);
        if (error) {
            [QMUITips showError:error.localizedDescription inView:self.view hideAfterDelay:3];
        }
    }];
}

#pragma mark - UINavigationControllerBackButtonHandlerProtocol 拦截退出界面

- (BOOL)shouldHoldBackButtonEvent {
    return YES;
}

- (BOOL)canPopViewController {
    // 这里不要做一些费时的操作，否则可能会卡顿。
    self.mIsViewControllerClosed = YES;
    [BDCoreApis cancelAllHttpRequest];
    DDLogInfo(@"%s", __PRETTY_FUNCTION__);
//    [self unregisterNotifications];
    // 保存草稿
//    return NO; //拦截，不能退出界面
    return YES; //
}

#pragma mark - Notifications

- (void)registerNotifications {
    
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reachabilityChanged:) name:kReachabilityChangedNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleWillShowKeyboard:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleWillHideKeyboard:) name:UIKeyboardWillHideNotification object:nil];
    //
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notifyQueueAccept:) name:BD_NOTIFICATION_QUEUE_ACCEPT object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notifyThreadClose:) name:BD_NOTIFICATION_THREAD_CLOSE object:nil];
    //
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notifyMessageAdd:) name:BD_NOTIFICATION_MESSAGE_ADD object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notifyMessageDelete:) name:BD_NOTIFICATION_MESSAGE_DELETE object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notifyMessageRetract:) name:BD_NOTIFICATION_MESSAGE_RETRACT object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notifyMessageStatus:) name:BD_NOTIFICATION_MESSAGE_STATUS object:nil];
    //
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notifyKickoff:) name:BD_NOTIFICATION_KICKOFF object:nil];

}

- (void)unregisterNotifications {
    
//    [[NSNotificationCenter defaultCenter] removeObserver:self name:kReachabilityChangedNotification object:nil];
//    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
//    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

#pragma mark - TableViewRelated

-(void)tableViewScrollToBottom:(BOOL)animated {
    DDLogInfo(@"tableViewScrollToBottom");
    
    NSInteger rows = [self.tableView numberOfRowsInSection:0];
    
    if(rows > 0) {
        [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:rows - 1 inSection:0]
                              atScrollPosition:UITableViewScrollPositionBottom
                                      animated:animated];
    }
}

#pragma mark - UIScrollViewDelegate

-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    DDLogInfo(@"%s", __PRETTY_FUNCTION__);
    
    [self.view endEditing:YES];

//    self.mInputView.frame = CGRectMake(0, KFDSScreen.height - BD_INPUTBAR_HEIGHT, KFDSScreen.width, BD_INPUTBAR_HEIGHT);
//    [self.mInputView.emotionView setHidden:TRUE];
//    [self.mInputView.plusView setHidden:TRUE];
    
    UIEdgeInsets tableViewInsets = self.tableView.contentInset;
    tableViewInsets.bottom = BD_INPUTBAR_HEIGHT;
    self.tableView.contentInset = tableViewInsets;
    self.tableView.scrollIndicatorInsets = tableViewInsets;
}

#pragma mark - Handle Keyboard Show/Hide

- (void)handleWillShowKeyboard:(NSNotification *)notification {
    DDLogInfo(@"%s", __PRETTY_FUNCTION__);
    
    CGRect keyboardRect = [[notification.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    double duration = [[notification.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];

    CGRect keyboardFrame = [self.view convertRect:keyboardRect fromView:nil];
//    NSUInteger keyboardY = keyboardFrame.origin.y;

    NSUInteger keyboardHeight = keyboardFrame.size.height;
//    DDLogInfo(@"%s keyboard height:%lu", __PRETTY_FUNCTION__, keyboardHeight);

    [UIView animateWithDuration:duration
                          delay:0.0f
                        options:UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         
//                         self.mInputView.frame = CGRectMake(0, keyboardY - BD_INPUTBAR_HEIGHT, KFDSScreen.width, BD_INPUTBAR_HEIGHT);
//                         CGRect inputViewFrame = [weakSelf.mInputView frame];
//                         inputViewFrame.origin.y = keyboardY - BD_INPUTBAR_HEIGHT;
//                         [weakSelf.mInputView setFrame:inputViewFrame];

                         //
                         UIEdgeInsets tableViewInsets = self.tableView.contentInset;
                         tableViewInsets.bottom = keyboardHeight + kToolbarHeight;
                         self.tableView.contentInset = tableViewInsets;
                         self.tableView.scrollIndicatorInsets = tableViewInsets;

                     } completion:^(BOOL finished) {
                         [self tableViewScrollToBottom:YES];
                     }];

}

- (void)handleWillHideKeyboard:(NSNotification *)notification {
    DDLogInfo(@"%s", __PRETTY_FUNCTION__);

//    CGRect keyboardRect = [[notification.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    double duration = [[notification.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];

//    NSUInteger keyboardY = [self.view convertRect:keyboardRect fromView:nil].origin.y;//键盘位置的y坐标
//    self.mInputView.frame = CGRectMake(0, keyboardY - BD_INPUTBAR_HEIGHT, KFDSScreen.width, BD_INPUTBAR_HEIGHT);

    [UIView animateWithDuration:duration
                          delay:0.0f
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{

                         UIEdgeInsets tableViewInsets = self.tableView.contentInset;
                         tableViewInsets.bottom = BD_INPUTBAR_HEIGHT;
                         self.tableView.contentInset = tableViewInsets;
                         self.tableView.scrollIndicatorInsets = tableViewInsets;

                     } completion:^(BOOL finished) {

                     }];

    [self tableViewScrollToBottom:YES];
}

#pragma mark - KFDSInputViewDelegate

#pragma mark - 发送消息

// TODO: 区分发送消息
-(void)sendTextMessage:(NSString *)content {
    DDLogInfo(@"%s, content:%@, tid:%@, sessionType:%@ ", __PRETTY_FUNCTION__, content, self.mThreadTid,  self.mThreadType);
    
    if (self.mIsRobot) {
    
        // 请求机器人问答
        [BDCoreApis messageAnswer:self.mRequestType withWorkGroupWid:self.mWorkGroupWid withAgentUid:self.mAgentUid withMessage:content resultSuccess:^(NSDictionary *dict) {
            DDLogInfo(@"%s, %@", __PRETTY_FUNCTION__, dict);
            
            NSDictionary *queryMessageDict = dict[@"data"][@"query"];
            NSDictionary *replyMessageDict = dict[@"data"][@"reply"];

            //
            BDMessageModel *queryMessageModel = [[BDMessageModel alloc] initWithDictionary:queryMessageDict];
            [[BDDBApis sharedInstance] insertMessage:queryMessageModel];

            //
            BDMessageModel *replyMessageModel = [[BDMessageModel alloc] initWithDictionary:replyMessageDict];
            [[BDDBApis sharedInstance] insertMessage:replyMessageModel];
            
            //
            [self reloadTableData];
            
        } resultFailed:^(NSError *error) {
            DDLogError(@"%s, %@", __PRETTY_FUNCTION__, error);
            if (error) {
                [QMUITips showError:error.localizedDescription inView:self.view hideAfterDelay:2];
            }
        }];
        
        return;
    }
    
    // 自定义发送消息本地id，消息发送成功之后，服务器会返回此id，可以用来判断消息发送状态
    NSString *localId = [[NSUUID UUID] UUIDString];
    
    // 插入本地消息, 可通过返回的messageModel首先更新本地UI，然后再发送消息
    BDMessageModel *messageModel = [[BDDBApis sharedInstance] insertTextMessageLocal:self.mThreadTid withWorkGroupWid:self.mWorkGroupWid withContent:content withLocalId:localId withSessionType:self.mThreadType];
    DDLogInfo(@"%s %@ %@", __PRETTY_FUNCTION__, localId, messageModel.content);
    
    // TODO: 立刻更新UI，插入消息到界面并显示发送状态 activity indicator
    NSIndexPath *insertIndexPath = [NSIndexPath indexPathForRow:[self.mMessageArray count] inSection:0];
    [self.mMessageArray addObject:messageModel];
    
    [self.tableView beginUpdates];
    [self.tableView insertRowsAtIndexPaths:[NSMutableArray arrayWithObjects:insertIndexPath, nil] withRowAnimation:UITableViewRowAnimationBottom];
    [self.tableView endUpdates];
    [self tableViewScrollToBottom:NO];
    
    // 同步发送消息
    [BDCoreApis sendTextMessage:content toTid:self.mThreadTid localId:localId sessionType:self.mThreadType resultSuccess:^(NSDictionary *dict) {
         DDLogInfo(@"%s %@", __PRETTY_FUNCTION__, dict);
        //
        NSNumber *status_code = [dict objectForKey:@"status_code"];
        if ([status_code isEqualToNumber:[NSNumber numberWithInt:200]]) {
            // 发送成功
            
            // 服务器返回自定义消息本地id
            NSString *localId = dict[@"data"][@"localId"];
            DDLogInfo(@"callback localId: %@", localId);
            
            // 修改本地消息发送状态为成功
            [[BDDBApis sharedInstance] updateMessageSuccess:localId];
            [self reloadCellDataSuccess:localId];
            
        } else {
            // 修改本地消息发送状态为error
            [[BDDBApis sharedInstance] updateMessageError:localId];
            [self reloadCellDataError:localId];
            //
            NSString *message = dict[@"message"];
            DDLogError(@"%s %@", __PRETTY_FUNCTION__, message);
            [QMUITips showError:message inView:self.view hideAfterDelay:2];
        }
    } resultFailed:^(NSError *error) {
        DDLogError(@"%s %@", __PRETTY_FUNCTION__, error);
        // 修改本地消息发送状态为error
        [[BDDBApis sharedInstance] updateMessageError:localId];
        [self reloadCellDataError:localId];
        //
        if (error) {
            [QMUITips showError:error.localizedDescription inView:self.view hideAfterDelay:2];
        }
    }];
}

// 上传并发送图片
- (void)uploadImageData:(NSData *)imageData {
    //
    NSString *imageName = [NSString stringWithFormat:@"%@_%@.png", [BDSettings getUsername], [BDUtils getCurrentTimeString]];
    [BDCoreApis uploadImageData:imageData withImageName:imageName resultSuccess:^(NSDictionary *dict) {
        DDLogInfo(@"%s %@", __PRETTY_FUNCTION__, dict);
        
        //
        NSNumber *status_code = [dict objectForKey:@"status_code"];
        if ([status_code isEqualToNumber:[NSNumber numberWithInt:200]]) {
            
            // 自定义发送消息本地id，消息发送成功之后，服务器会返回此id，可以用来判断消息发送状态
            NSString *localId = [[NSUUID UUID] UUIDString];
            NSString *imageUrl = dict[@"data"];
            
            // 插入本地消息
            BDMessageModel *messageModel = [[BDDBApis sharedInstance] insertImageMessageLocal:self.mThreadTid withWorkGroupWid:self.mWorkGroupWid withContent:imageUrl withLocalId:localId withSessionType:self.mThreadType];
            DDLogInfo(@"%s %@ %@", __PRETTY_FUNCTION__, localId, messageModel.image_url);
            
            // TODO: 立刻更新UI，插入消息到界面并显示发送状态 activity indicator
            NSIndexPath *insertIndexPath = [NSIndexPath indexPathForRow:[self.mMessageArray count] inSection:0];
            [self.mMessageArray addObject:messageModel];
            
            [self.tableView beginUpdates];
            [self.tableView insertRowsAtIndexPaths:[NSMutableArray arrayWithObjects:insertIndexPath, nil] withRowAnimation:UITableViewRowAnimationBottom];
            [self.tableView endUpdates];
            [self tableViewScrollToBottom:YES];
            
            // 异步发送图片消息
            //         [[BDMQTTApis sharedInstance] sendImageMessage:imageUrl toTid:self.mThreadTid localId:localId sessionType:self.mThreadType];
            
            // 同步发送图片消息
            [BDCoreApis sendImageMessage:imageUrl toTid:self.mThreadTid localId:localId sessionType:self.mThreadType resultSuccess:^(NSDictionary *dict) {
                DDLogInfo(@"%s %@", __PRETTY_FUNCTION__, dict);
                //
                NSNumber *status_code = [dict objectForKey:@"status_code"];
                if ([status_code isEqualToNumber:[NSNumber numberWithInt:200]]) {
                    // 发送成功
                    
                    // 服务器返回自定义消息本地id
                    NSString *localId = dict[@"data"][@"localId"];
                    DDLogInfo(@"callback localId: %@", localId);
                    
                    // 修改本地消息发送状态为成功
                    [[BDDBApis sharedInstance] updateMessageSuccess:localId];
                    [self reloadCellDataSuccess:localId];
                    
                } else {
                    // 修改本地消息发送状态为error
                    [[BDDBApis sharedInstance] updateMessageError:localId];
                    [self reloadCellDataError:localId];
                    //
                    NSString *message = dict[@"message"];
                    DDLogError(@"%s %@", __PRETTY_FUNCTION__, message);
                    [QMUITips showError:message inView:self.view hideAfterDelay:2];
                }
            } resultFailed:^(NSError *error) {
                DDLogError(@"%s %@", __PRETTY_FUNCTION__, error);
                // 修改本地消息发送状态为error
                [[BDDBApis sharedInstance] updateMessageError:localId];
                [self reloadCellDataError:localId];
                //
                if (error) {
                    [QMUITips showError:error.localizedDescription inView:self.view hideAfterDelay:2];
                }
            }];
            
        } else {
            [QMUITips showError:@"发送图片错误" inView:self.view hideAfterDelay:2];
        }
        
    } resultFailed:^(NSError *error) {
        DDLogError(@"%s %@", __PRETTY_FUNCTION__, error);
    }];
}

// 发送商品消息
-(void)sendCommodityMessage:(NSString *)content {
    DDLogInfo(@"%s, content:%@, tid:%@, sessionType:%@ ", __PRETTY_FUNCTION__, content, self.mThreadTid,  self.mThreadType);
    
//    // 自定义发送消息本地id，消息发送成功之后，服务器会返回此id，可以用来判断消息发送状态
    NSString *localId = [[NSUUID UUID] UUIDString];
//
    // 插入本地消息, 可通过返回的messageModel首先更新本地UI，然后再发送消息
    BDMessageModel *messageModel = [[BDDBApis sharedInstance] insertCommodityMessageLocal:self.mThreadTid withWorkGroupWid:self.mWorkGroupWid withContent:content withLocalId:localId withSessionType:self.mThreadType];
//    DDLogInfo(@"%s %@ %@", __PRETTY_FUNCTION__, localId, messageModel.content);

    // TODO: 立刻更新UI，插入消息到界面并显示发送状态 activity indicator
    NSIndexPath *insertIndexPath = [NSIndexPath indexPathForRow:[self.mMessageArray count] inSection:0];
    [self.mMessageArray addObject:messageModel];

    [self.tableView beginUpdates];
    [self.tableView insertRowsAtIndexPaths:[NSMutableArray arrayWithObjects:insertIndexPath, nil] withRowAnimation:UITableViewRowAnimationBottom];
    [self.tableView endUpdates];
    [self tableViewScrollToBottom:YES];

    // 同步发送消息
    [BDCoreApis sendCommodityMessage:content toTid:self.mThreadTid localId:localId sessionType:self.mThreadType resultSuccess:^(NSDictionary *dict) {
        DDLogInfo(@"%s %@", __PRETTY_FUNCTION__, dict);
        //
        NSNumber *status_code = [dict objectForKey:@"status_code"];
        if ([status_code isEqualToNumber:[NSNumber numberWithInt:200]]) {
            // 发送成功
            
            // 服务器返回自定义消息本地id
            NSString *localId = dict[@"data"][@"localId"];
            DDLogInfo(@"callback localId: %@", localId);
            
            // 修改本地消息发送状态为成功
            [[BDDBApis sharedInstance] updateMessageSuccess:localId];
            [self reloadCellDataSuccess:localId];
            
        } else {
            // 修改本地消息发送状态为error
            [[BDDBApis sharedInstance] updateMessageError:localId];
            [self reloadCellDataError:localId];
            //
            NSString *message = dict[@"message"];
            DDLogError(@"%s %@", __PRETTY_FUNCTION__, message);
            [QMUITips showError:message inView:self.view hideAfterDelay:2];
        }
    } resultFailed:^(NSError *error) {
        DDLogError(@"%s %@", __PRETTY_FUNCTION__, error);
        // 修改本地消息发送状态为error
        [[BDDBApis sharedInstance] updateMessageError:localId];
        [self reloadCellDataError:localId];
        //
        if (error) {
            [QMUITips showError:error.localizedDescription inView:self.view hideAfterDelay:2];
        }
    }];
}

// 发送红包消息
-(void)sendRedPacketMessage:(NSString *)content {
    DDLogInfo(@"%s, content:%@, tid:%@, sessionType:%@ ", __PRETTY_FUNCTION__, content, self.mThreadTid,  self.mThreadType);
    
    // 自定义发送消息本地id，消息发送成功之后，服务器会返回此id，可以用来判断消息发送状态
    NSString *localId = [[NSUUID UUID] UUIDString];
    
    // 插入本地消息, 可通过返回的messageModel首先更新本地UI，然后再发送消息
    BDMessageModel *messageModel = [[BDDBApis sharedInstance] insertRedPacketMessageLocal:self.mThreadTid withWorkGroupWid:self.mWorkGroupWid withContent:content withLocalId:localId withSessionType:self.mThreadType];
    DDLogInfo(@"%s %@ %@", __PRETTY_FUNCTION__, localId, messageModel.content);
    
    // TODO: 立刻更新UI，插入消息到界面并显示发送状态 activity indicator
    NSIndexPath *insertIndexPath = [NSIndexPath indexPathForRow:[self.mMessageArray count] inSection:0];
    [self.mMessageArray addObject:messageModel];
    
    [self.tableView beginUpdates];
    [self.tableView insertRowsAtIndexPaths:[NSMutableArray arrayWithObjects:insertIndexPath, nil] withRowAnimation:UITableViewRowAnimationBottom];
    [self.tableView endUpdates];
    [self tableViewScrollToBottom:YES];
    
    // 异步发送消息
    //     [[BDMQTTApis sharedInstance] sendTextMessage:content toTid:self.mThreadTid localId:localId sessionType:self.mThreadType];
    
    // 同步发送消息
    [BDCoreApis sendRedPacketMessage:content toTid:self.mThreadTid localId:localId sessionType:self.mThreadType resultSuccess:^(NSDictionary *dict) {
        DDLogInfo(@"%s %@", __PRETTY_FUNCTION__, dict);
        //
        NSNumber *status_code = [dict objectForKey:@"status_code"];
        if ([status_code isEqualToNumber:[NSNumber numberWithInt:200]]) {
            // 发送成功
            
            // 服务器返回自定义消息本地id
            NSString *localId = dict[@"data"][@"localId"];
            DDLogInfo(@"callback localId: %@", localId);

            // 修改本地消息发送状态为成功
            [[BDDBApis sharedInstance] updateMessageSuccess:localId];
            [self reloadCellDataSuccess:localId];
            
            
        } else {
            // 修改本地消息发送状态为error
            [[BDDBApis sharedInstance] updateMessageError:localId];
            [self reloadCellDataError:localId];
            //
            NSString *message = dict[@"message"];
            DDLogError(@"%s %@", __PRETTY_FUNCTION__, message);
            [QMUITips showError:message inView:self.view hideAfterDelay:2];
        }
    } resultFailed:^(NSError *error) {
        DDLogError(@"%s %@", __PRETTY_FUNCTION__, error);
        // 修改本地消息发送状态为error
        [[BDDBApis sharedInstance] updateMessageError:localId];
        [self reloadCellDataError:localId];
        //
        if (error) {
            [QMUITips showError:error.localizedDescription inView:self.view hideAfterDelay:2];
        }
    }];
}

#pragma mark - 录音

#pragma mark - 拍照等Plus

-(void)sharePickPhotoButtonPressed:(id)sender {
//    DDLogInfo(@"%s", __PRETTY_FUNCTION__);
    [self authorizationPresentAlbumViewControllerWithTitle:@"选择图片"];
}

-(void)shareTakePhotoButtonPressed:(id)sender {
    DDLogInfo(@"%s", __PRETTY_FUNCTION__);
    //
    if (TARGET_IPHONE_SIMULATOR) {
        [QMUITips showError:@"模拟器不支持" inView:self.view hideAfterDelay:2];
        return;
    }
    
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if(authStatus == AVAuthorizationStatusDenied
       || authStatus ==AVAuthorizationStatusRestricted) {
        // The user has explicitly denied permission for media capture.
        UIAlertController * alert = [UIAlertController
                                     alertControllerWithTitle:@""
                                     message:@"请在iPhone的‘设置-隐私-相机’选项中，允许访问你的相机"
                                     preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction* yesButton = [UIAlertAction
                                    actionWithTitle:@"确定"
                                    style:UIAlertActionStyleDefault
                                    handler:^(UIAlertAction * action) {
                                        //Handle your yes please button action here
                                    }];
        [alert addAction:yesButton];
        [self presentViewController:alert animated:YES completion:nil];
    }
    else if(authStatus == AVAuthorizationStatusAuthorized) {//允许访问
        // The user has explicitly granted permission for media capture,
        //or explicit user permission is not necessary for the media type in question.
        mImagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
        [self presentViewController:mImagePickerController animated:YES completion:nil];
        
    }else if(authStatus == AVAuthorizationStatusNotDetermined){
        // Explicit user permission is required for media capture, but the user has not yet granted or denied such permission.
        [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
            if(granted){//点击允许访问时调用
                //用户明确许可与否，媒体需要捕获，但用户尚未授予或拒绝许可。
                //DDLogInfo(@"Granted access to %@", AVMediaTypeVideo);
                self.mImagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
                [self presentViewController:self.mImagePickerController animated:YES completion:nil];
            }
            else {
                //DDLogInfo(@"Not granted access to %@", AVMediaTypeVideo);
            }
        }];
        
    } else {
        DDLogInfo(@"Unknown authorization status");
    }
}

#pragma mark - KFDSMsgViewCellDelegate

- (void)removeCellWith:(NSInteger)tag {
    DDLogInfo(@"%s", __PRETTY_FUNCTION__);
    //
    UIAlertController * alert = [UIAlertController
                                 alertControllerWithTitle:@""
                                 message:@"确定要删除"
                                 preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction* yesButton = [UIAlertAction
                                actionWithTitle:@"确定"
                                style:UIAlertActionStyleDefault
                                handler:^(UIAlertAction * action) {
                                    //Handle your yes please button action here
                                    //
                                    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:tag inSection:0];
                                    if (indexPath.row < [self.mMessageArray count]) {
                                        BDMessageModel *itemToDelete = [self.mMessageArray objectAtIndex:indexPath.row];
                                        //
                                        [BDCoreApis markDeletedMessage:itemToDelete.mid resultSuccess:^(NSDictionary *dict) {
                                            //
                                            [self.mMessageArray removeObjectAtIndex:indexPath.row];
                                            [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
                                            
                                        } resultFailed:^(NSError *error) {
                                             [QMUITips showError:@"删除失败" inView:self.view hideAfterDelay:2.0f];
                                        }];
                                    }
                                }];
    
    UIAlertAction* cancelButton = [UIAlertAction
                                actionWithTitle:@"取消"
                                style:UIAlertActionStyleDefault
                                handler:^(UIAlertAction * action) {
                                    //Handle your yes please button action here
                                }];
    [alert addAction:yesButton];
    [alert addAction:cancelButton];
    [self presentViewController:alert animated:YES completion:nil];
}

#pragma mark 点击客服头像跳转到客服详情页面：展示客服评价记录
#pragma mark 点击访客头像进入个人详情页

- (void)avatarClicked:(BDMessageModel *)messageModel {
    DDLogInfo(@"%s %@", __PRETTY_FUNCTION__, messageModel.avatar);
    
}

//TODO: 增加上拉、下拉关闭图片
#pragma mark 打开放大图片

- (void) imageViewClicked:(UIImageView *)imageView {
    DDLogInfo(@"%s", __PRETTY_FUNCTION__);
    self.currentImageView = imageView;
    
    if (!self.imagePreviewViewController) {
        self.imagePreviewViewController = [[QMUIImagePreviewViewController alloc] init];
        self.imagePreviewViewController.presentingStyle = QMUIImagePreviewViewControllerTransitioningStyleZoom;// 将 present 动画改为 zoom，也即从某个位置放大到屏幕中央。默认样式为 fade。
        self.imagePreviewViewController.imagePreviewView.delegate = self;
        self.imagePreviewViewController.imagePreviewView.currentImageIndex = 0;// 默认查看的图片的 index
        
        // QMUIImagePreviewViewController 对于以 window 的方式展示的情况，默认会开启手势拖拽退出预览功能。
        // 如果使用了手势拖拽，并且退出预览时需要飞到某个 rect，则需要实现这个 block，在里面自己去 exit，如果不实现这个 block，退出动画会使用 fadeOut 那种
//        __weak __typeof(self)weakSelf = self;
//        self.imagePreviewViewController.customGestureExitBlock = ^(QMUIImagePreviewViewController *aImagePreviewViewController, QMUIZoomImageView *currentZoomImageView) {
//            [weakSelf.currentImageView setImage:currentZoomImageView.image];
//            [aImagePreviewViewController exitPreviewToRectInScreenCoordinate:[weakSelf.currentImageView convertRect:weakSelf.currentImageView.frame toView:nil]];
//        };
        
        __weak __typeof(self)weakSelf = self;
        
        // 如果使用 zoom 动画，则需要在 sourceImageView 里返回一个 UIView，由这个 UIView 的布局位置决定动画的起点/终点，如果用 fade 则不需要使用 sourceImageView。
        // 另外当 sourceImageView 返回 nil 时会强制使用 fade 动画，常见的使用场景是 present 时 sourceImageView 还在屏幕内，但 dismiss 时 sourceImageView 已经不在可视区域，即可通过返回 nil 来改用 fade 动画。
        self.imagePreviewViewController.sourceImageView = ^UIView *{
//            return weakSelf.imageButton;
            return weakSelf.currentImageView;
        };
        
        // 当需要在退出大图预览时做一些事情的时候，可配合 UIViewController (QMUI) 的 qmui_visibleStateDidChangeBlock 来实现。
        self.imagePreviewViewController.qmui_visibleStateDidChangeBlock = ^(QMUIImagePreviewViewController *viewController, QMUIViewControllerVisibleState visibleState) {
            if (visibleState == QMUIViewControllerWillDisappear) {
                UIImage *currentImage = [viewController.imagePreviewView zoomImageViewAtIndex:viewController.imagePreviewView.currentImageIndex].image;
                if (currentImage) {
                    [weakSelf.currentImageView setImage:currentImage];
                }
            }
        };
    }
    
//    [self.imagePreviewViewController startPreviewFromRectInScreenCoordinate:[imageView convertRect:imageView.frame toView:nil] cornerRadius:imageView.layer.cornerRadius];
    [self presentViewController:self.imagePreviewViewController animated:YES completion:nil];
    
}

- (void) fileViewClicked:(id)sender {
    DDLogInfo(@"%s", __PRETTY_FUNCTION__);
}

- (void) sendErrorStatusButtonClicked:(BDMessageModel *)model {
    DDLogInfo(@"%s", __PRETTY_FUNCTION__);
}

#pragma mark - <QMUIImagePreviewViewDelegate>

- (NSUInteger)numberOfImagesInImagePreviewView:(QMUIImagePreviewView *)imagePreviewView {
    return 1;
}

- (void)imagePreviewView:(QMUIImagePreviewView *)imagePreviewView renderZoomImageView:(QMUIZoomImageView *)zoomImageView atIndex:(NSUInteger)index {
    zoomImageView.image = self.currentImageView.image;
}

- (QMUIImagePreviewMediaType)imagePreviewView:(QMUIImagePreviewView *)imagePreviewView assetTypeAtIndex:(NSUInteger)index {
    return QMUIImagePreviewMediaTypeImage;
}

#pragma mark - <QMUIZoomImageViewDelegate>

- (void)singleTouchInZoomingImageView:(QMUIZoomImageView *)zoomImageView location:(CGPoint)location {
    [self.currentImageView setImage:zoomImageView.image];
    // 退出图片预览
    [self dismissViewControllerAnimated:YES completion:nil];
//    self.imagePreviewViewController.customGestureExitBlock(self.imagePreviewViewController, zoomImageView);
//    [self.imagePreviewViewController endPreviewToRectInScreen:[self.currentImageView convertRect:self.currentImageView.frame toView:nil]];
}

#pragma mark - 选取图片

- (void)authorizationPresentAlbumViewControllerWithTitle:(NSString *)title {
    if ([QMUIAssetsManager authorizationStatus] == QMUIAssetAuthorizationStatusNotDetermined) {
        [QMUIAssetsManager requestAuthorization:^(QMUIAssetAuthorizationStatus status) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self presentAlbumViewControllerWithTitle:title];
            });
        }];
    } else {
        [self presentAlbumViewControllerWithTitle:title];
    }
}

- (void)presentAlbumViewControllerWithTitle:(NSString *)title {
    DDLogInfo(@"%s", __PRETTY_FUNCTION__);
    // 创建一个 QMUIAlbumViewController 实例用于呈现相簿列表
    QMUIAlbumViewController *albumViewController = [[QMUIAlbumViewController alloc] init];
    albumViewController.albumViewControllerDelegate = self;
    albumViewController.contentType = kAlbumContentType;
    albumViewController.title = title;
//    albumViewController.view.tag = SingleImagePickingTag;
    
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:albumViewController];
    // 获取最近发送图片时使用过的相簿，如果有则直接进入该相簿
//    QMUIAssetsGroup *assetsGroup = [QMUIImagePickerHelper assetsGroupOfLastestPickerAlbumWithUserIdentify:nil];
//    if (assetsGroup) {
//        QMUIImagePickerViewController *imagePickerViewController = [self imagePickerViewControllerForAlbumViewController:albumViewController];
//        [imagePickerViewController refreshWithAssetsGroup:assetsGroup];
//        imagePickerViewController.title = [assetsGroup name];
//        [navigationController pushViewController:imagePickerViewController animated:NO];
//    }
    
    [self presentViewController:navigationController animated:YES completion:NULL];
}

#pragma mark - <QMUIAlbumViewControllerDelegate>

- (QMUIImagePickerViewController *)imagePickerViewControllerForAlbumViewController:(QMUIAlbumViewController *)albumViewController {
//    DDLogInfo(@"%s", __PRETTY_FUNCTION__);
    
    QMUIImagePickerViewController *imagePickerViewController = [[QMUIImagePickerViewController alloc] init];
    imagePickerViewController.imagePickerViewControllerDelegate = self;
    imagePickerViewController.maximumSelectImageCount = 1;
    imagePickerViewController.view.tag = albumViewController.view.tag;
    imagePickerViewController.allowsMultipleSelection = NO;
    
    return imagePickerViewController;
}

#pragma mark - <QMUIImagePickerViewControllerDelegate>

- (QMUIImagePickerPreviewViewController *)imagePickerPreviewViewControllerForImagePickerViewController:(QMUIImagePickerViewController *)imagePickerViewController {
//    DDLogInfo(@"%s", __PRETTY_FUNCTION__);
    
    BDSingleImagePickerPreviewViewController *imagePickerPreviewViewController = [[BDSingleImagePickerPreviewViewController alloc] init];
    imagePickerPreviewViewController.delegate = self;
    imagePickerPreviewViewController.assetsGroup = imagePickerViewController.assetsGroup;
    imagePickerPreviewViewController.view.tag = imagePickerViewController.view.tag;
    return imagePickerPreviewViewController;
}

#pragma mark - <QMUIImagePickerPreviewViewControllerDelegate>

#pragma mark - <QDMultipleImagePickerPreviewViewControllerDelegate>

#pragma mark - <QDSingleImagePickerPreviewViewControllerDelegate>

- (void)imagePickerPreviewViewController:(BDSingleImagePickerPreviewViewController *)imagePickerPreviewViewController didSelectImageWithImagesAsset:(QMUIAsset *)imageAsset {
    
    DDLogInfo(@"%s", __PRETTY_FUNCTION__);
    
    // 显示 loading
//    [self startLoading];
    
    [imageAsset requestImageData:^(NSData *imageData, NSDictionary<NSString *,id> *info, BOOL isGIF, BOOL isHEIC) {
        UIImage *targetImage = [UIImage imageWithData:imageData];
        if (isHEIC) {
            // iOS 11 中新增 HEIF/HEVC 格式的资源，直接发送新格式的照片到不支持新格式的设备，照片可能会无法识别，可以先转换为通用的 JPEG 格式再进行使用。
            // 详细请浏览：https://github.com/QMUI/QMUI_iOS/issues/224
            targetImage = [UIImage imageWithData:UIImageJPEGRepresentation(targetImage, 1)];
        }
        NSData *imageData2 = UIImageJPEGRepresentation(targetImage, 0);
        [self uploadImageData:imageData2];
    }];
    
}

#pragma mark UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    [picker dismissViewControllerAnimated:YES completion:^{
        [self performSelector:@selector(dealWithImage:) withObject:info];
    }];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)dealWithImage:(NSDictionary *)info {
    
    NSString *mediaType = [info objectForKey:UIImagePickerControllerMediaType];
    if([mediaType isEqualToString:@"public.movie"]) {
        //被选中的是视频
        [QMUITips showError:@"请选择图片" inView:self.view hideAfterDelay:2];
    }
    else if([mediaType isEqualToString:@"public.image"]) {
        //获取照片实例
        UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
        UIImageOrientation imageOrientation = image.imageOrientation;
        if (imageOrientation != UIImageOrientationUp) {
            
            UIGraphicsBeginImageContext(image.size);
            [image drawInRect:CGRectMake(0, 0, image.size.width, image.size.height)];
            image = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
        }
        
        NSData *imageData = UIImageJPEGRepresentation(image, 0);
        [self uploadImageData:imageData];
    }
}

// 保留图片到相册
-(void)saveImageToDisk:(NSDictionary *)info {
//    UIImage *image = [info objectForKey:@"image"];
//    NSString *imageName = [info objectForKey:@"imagename"];
//    [[KFUtils sharedInstance] saveImage:image withName:imageName];
//
//    dispatch_async(dispatch_get_main_queue(), ^{
//        [kfTableView reloadData];
//    });
}

#pragma mark - 满意度评价

- (void) showRateView {
    
    // TODO: 没有发生聊天记录的情况下，不能够进行评价
    
    QMUIDialogViewController *dialogViewController = [[QMUIDialogViewController alloc] init];
    dialogViewController.title = @"满意度评价";
    //
    UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 300, 100)];
    contentView.backgroundColor = UIColorWhite;
    
    HCSStarRatingView *starRatingView = [[HCSStarRatingView alloc] initWithFrame:CGRectMake(50, 20, 200, 50)];
    starRatingView.maximumValue = 5;
    starRatingView.minimumValue = 1;
    starRatingView.allowsHalfStars = NO;
    starRatingView.value = 5;
    starRatingView.tintColor = [UIColor yellowColor];
    [starRatingView addTarget:self action:@selector(didChangeValue:) forControlEvents:UIControlEventValueChanged];
    [contentView addSubview:starRatingView];
    
//    UILabel *rateLabel = [[UILabel alloc] initWithFrame:CGRectMake(50, 70, 100, 50)];
//    rateLabel.text = @"非常满意";
//    [contentView addSubview:rateLabel];
    
//    QMUITextView *textView = [[QMUITextView alloc] initWithFrame:CGRectMake(50, 120, 200, 100)];
//    textView.placeholder = @"支持 placeholder、支持自适应高度、支持限制文本输入长度";
//    textView.placeholderColor = UIColorPlaceholder; // 自定义 placeholder 的颜色
//    textView.autoResizable = YES;
//    textView.textContainerInset = UIEdgeInsetsMake(10, 7, 10, 7);
//    textView.returnKeyType = UIReturnKeySend;
//    textView.enablesReturnKeyAutomatically = YES;
//    textView.maximumTextLength = 100;
//    textView.layer.borderWidth = PixelOne;
//    textView.layer.borderColor = UIColorSeparator.CGColor;
//    textView.layer.cornerRadius = 4;
//    [contentView addSubview:textView];
    
    dialogViewController.contentView = contentView;
    //
    [dialogViewController addCancelButtonWithText:@"取消" block:nil];
    [dialogViewController addSubmitButtonWithText:@"确定" block:^(QMUIDialogViewController *aDialogViewController) {
        [aDialogViewController hide];
        
        // TODO: 发送满意度评价
        [BDCoreApis visitorRate:self.mThreadModel.tid
                      withScore:self.rateScore
                       withNote:self.rateNote
                     withInvite:self.rateInvite
                  resultSuccess:^(NSDictionary *dict) {
            
        } resultFailed:^(NSError *error) {
            DDLogInfo(@"%s %@", __PRETTY_FUNCTION__, error);
        }];
        
        // TODO: 关闭当前会话窗口
        if (self.mIsPush) {
            [self.navigationController popViewControllerAnimated:YES];
        } else {
            [self.navigationController dismissViewControllerAnimated:YES completion:^{}];
        }
        
    }];
    [dialogViewController show];
    
}

- (void)didChangeValue:(HCSStarRatingView *)sender {
    DDLogInfo(@"Changed rating to %.1f", sender.value);
    self.rateScore = sender.value;
}

#pragma mark - 点击页面

- (void)handleSingleTap:(UIGestureRecognizer *)gestureRecognizer {
//    DDLogInfo(@"%s", __PRETTY_FUNCTION__);
    [self.toolbarTextField resignFirstResponder];
    [self hideToolbarViewWithKeyboardUserInfo:nil];
}

#pragma mark - QMUITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    DDLogInfo(@"%s", __PRETTY_FUNCTION__);
    [self handleSendButtonEvent:nil];
    
    return YES;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    DDLogInfo(@"%s", __PRETTY_FUNCTION__);
//    self.faceButton.selected = NO;
    return YES;
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {
//    DDLogInfo(@"%s", __PRETTY_FUNCTION__);
//    self.emotionInputManager.selectedRangeForBoundTextInput = self.toolbarTextField.qmui_selectedRange;
    return YES;
}

#pragma mark - ToolbarView Show And Hide

- (void)showToolbarViewWithKeyboardUserInfo:(QMUIKeyboardUserInfo *)keyboardUserInfo {
    if (keyboardUserInfo) {
        // 相对于键盘
        [QMUIKeyboardManager animateWithAnimated:YES keyboardUserInfo:keyboardUserInfo animations:^{
            CGFloat distanceFromBottom = [QMUIKeyboardManager distanceFromMinYToBottomInView:self.view keyboardRect:keyboardUserInfo.endFrame];
            
            self.toolbarView.layer.transform = CATransform3DMakeTranslation(0, - distanceFromBottom, 0);
//            self.emotionInputManager.emotionView.layer.transform = CATransform3DMakeTranslation(0, - distanceFromBottom, 0);
            
        } completion:NULL];
    } else {
        // 相对于表情面板
        [UIView animateWithDuration:0.25 delay:0 options:QMUIViewAnimationOptionsCurveOut animations:^{
//            self.toolbarView.layer.transform = CATransform3DMakeTranslation(0, - CGRectGetHeight(self.emotionInputManager.emotionView.bounds), 0);
        } completion:NULL];
    }
}

- (void)hideToolbarViewWithKeyboardUserInfo:(QMUIKeyboardUserInfo *)keyboardUserInfo {
    if (keyboardUserInfo) {
        [QMUIKeyboardManager animateWithAnimated:YES keyboardUserInfo:keyboardUserInfo animations:^{
            self.toolbarView.layer.transform = CATransform3DIdentity;
//            self.emotionInputManager.emotionView.layer.transform = CATransform3DIdentity;
        } completion:NULL];
    } else {
        [UIView animateWithDuration:0.25 delay:0 options:QMUIViewAnimationOptionsCurveOut animations:^{
            self.toolbarView.layer.transform = CATransform3DIdentity;
//            self.emotionInputManager.emotionView.layer.transform = CATransform3DIdentity;
        } completion:NULL];
    }
}

#pragma mark - Selectors

// TODO: bug显示表情面板的时候，会遮挡聊天记录
- (void)handleFaceButtonEvent:(id)sender {
    DDLogInfo(@"%s", __PRETTY_FUNCTION__);
    //
}

- (void)handlePlusButtonEvent:(id)sender {
//    DDLogInfo(@"%s", __PRETTY_FUNCTION__);
    
    QMUIAlertAction *cancelAction = [QMUIAlertAction actionWithTitle:@"取消" style:QMUIAlertActionStyleCancel handler:^(QMUIAlertController *aAlertController, QMUIAlertAction *action) {
    }];
    QMUIAlertAction *pickAction = [QMUIAlertAction actionWithTitle:@"照片" style:QMUIAlertActionStyleDefault handler:^(QMUIAlertController *aAlertController, QMUIAlertAction *action) {
        [self sharePickPhotoButtonPressed:nil];
    }];
    QMUIAlertAction *cameraAction = [QMUIAlertAction actionWithTitle:@"拍照" style:QMUIAlertActionStyleDefault handler:^(QMUIAlertController *aAlertController, QMUIAlertAction *action) {
        [self shareTakePhotoButtonPressed:nil];
    }];
    QMUIAlertController *alertController = [QMUIAlertController alertControllerWithTitle:@"工具栏" message:@"" preferredStyle:QMUIAlertControllerStyleActionSheet];
    [alertController addAction:cancelAction];
    [alertController addAction:pickAction];
    [alertController addAction:cameraAction];
    [alertController showWithAnimated:YES];
}

- (void)handleSendButtonEvent:(id)sender {
    DDLogInfo(@"%s", __PRETTY_FUNCTION__);
    
    NSString *content = self.toolbarTextField.text;
    if ([content stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]].length > 0) {
        [self sendTextMessage:content];
        [self.toolbarTextField setText:@""];
    }
}

- (void)showEmotionView {
    [UIView animateWithDuration:0.25 delay:0 options:QMUIViewAnimationOptionsCurveOut animations:^{
        self.toolbarView.layer.transform = CATransform3DMakeTranslation(0, - kEmotionViewHeight, 0);
//        self.emotionInputManager.emotionView.layer.transform = CATransform3DMakeTranslation(0, - CGRectGetHeight(self.emotionInputManager.emotionView.bounds), 0);
    } completion:NULL];
    [self.toolbarTextField resignFirstResponder];
}

#pragma mark - 下拉刷新

- (void)refreshMessages {
    
    // 1. 访客端
    if (self.mIsVisitor) {
        DDLogInfo(@"1. 客服会话：访客端拉取服务器聊天记录 %li", (long)self.mLastMessageId);
    
//        根据最旧一条聊天记录加载之前20条聊天记录
        [BDCoreApis getMessageWithUser:[BDSettings getUid] withId:self.mLastMessageId resultSuccess:^(NSDictionary *dict) {
            
            [self insertMessagesToTable:dict];
//            [self reloadTableData];
            [self.mRefreshControl endRefreshing];
        } resultFailed:^(NSError *error) {
            
//            [QMUITips showError:@"加载失败" inView:self.view hideAfterDelay:2.0f];
            [self.mRefreshControl endRefreshing];
        }];
        
//        分页加载聊天记录
//        [BDCoreApis getMessageWithUser:[BDSettings getUid]
//                              withPage:self.mGetMessageFromChannelPage
//                         resultSuccess:^(NSDictionary *dict) {
//
//             self.mGetMessageFromChannelPage += 1;
//             [self reloadTableData];
//             [self.mRefreshControl endRefreshing];
//
//         } resultFailed:^(NSError *error) {
//             DDLogInfo(@"%s %@", __PRETTY_FUNCTION__, error);
//
//             [QMUITips showError:@"加载失败" inView:view hideAfterDelay:2.0f];
//             [self.mRefreshControl endRefreshing];
//         }];
        
    } else if ([self.mThreadType isEqualToString:BD_THREAD_TYPE_THREAD]) {
        DDLogInfo(@"2. 客服会话：客服端拉取服务器访客聊天记录%@, %li", self.mUid, (long)self.mLastMessageId);
        
//        根据最旧一条聊天记录加载之前20条聊天记录
        [BDCoreApis getMessageWithUser:self.mUid withId:self.mLastMessageId resultSuccess:^(NSDictionary *dict) {
            
            [self insertMessagesToTable:dict];
//            [self reloadTableData];
            [self.mRefreshControl endRefreshing];
        } resultFailed:^(NSError *error) {
            
//            [QMUITips showError:@"加载失败" inView:self.view hideAfterDelay:2.0f];
            [self.mRefreshControl endRefreshing];
        }];
        
//        分页加载聊天记录
//        [BDCoreApis getMessageWithUser:self.mUid
//                              withPage:self.mGetMessageFromChannelPage
//                         resultSuccess:^(NSDictionary *dict) {
//
//             self.mGetMessageFromChannelPage += 1;
//             [self reloadTableData];
//             [self.mRefreshControl endRefreshing];
//
//         } resultFailed:^(NSError *error) {
//             DDLogInfo(@"%s %@", __PRETTY_FUNCTION__, error);
//
//             [QMUITips showError:@"加载失败" inView:view hideAfterDelay:2.0f];
//             [self.mRefreshControl endRefreshing];
//         }];
        
    } else if ([self.mThreadType isEqualToString:BD_THREAD_TYPE_CONTACT]) {
        DDLogInfo(@"3. IM会话拉取服务器联系人聊天记录 %@, %li", self.mUid, (long)self.mLastMessageId);
        
//        根据最旧一条聊天记录加载之前20条聊天记录
        [BDCoreApis getMessageWithContact:self.mUid withId:self.mLastMessageId resultSuccess:^(NSDictionary *dict) {
            
            [self insertMessagesToTable:dict];
//            [self reloadTableData];
            [self.mRefreshControl endRefreshing];
        } resultFailed:^(NSError *error) {
            
//            [QMUITips showError:@"加载失败" inView:self.view hideAfterDelay:2.0f];
            [self.mRefreshControl endRefreshing];
        }];
        
//        分页加载聊天记录
//        [BDCoreApis getMessageWithContact:self.mUid
//                                 withPage:self.mGetMessageFromChannelPage
//                            resultSuccess:^(NSDictionary *dict) {
//
//            self.mGetMessageFromChannelPage += 1;
//            [self reloadTableData];
//            [self.mRefreshControl endRefreshing];
//
//        } resultFailed:^(NSError *error) {
//
//            [QMUITips showError:@"加载失败" inView:view hideAfterDelay:2.0f];
//            [self.mRefreshControl endRefreshing];
//        }];
        
    } else if ([self.mThreadType isEqualToString:BD_THREAD_TYPE_GROUP]) {
        DDLogInfo(@"4. IM会话拉取服务器群组聊天记录 %@, %li", self.mUid, (long)self.mLastMessageId);
        
//        根据最旧一条聊天记录加载之前20条聊天记录
        [BDCoreApis getMessageWithGroup:self.mUid withId:self.mLastMessageId resultSuccess:^(NSDictionary *dict) {

            [self insertMessagesToTable:dict];
//            [self reloadTableData];
            [self.mRefreshControl endRefreshing];
        } resultFailed:^(NSError *error) {

//            [QMUITips showError:@"加载失败" inView:self.view hideAfterDelay:2.0f];
            [self.mRefreshControl endRefreshing];
        }];
        
//
//        分页加载聊天记录
//        [BDCoreApis getMessageWithGroup:self.mUid
//                               withPage:self.mGetMessageFromChannelPage
//                          resultSuccess:^(NSDictionary *dict) {
//
//            self.mGetMessageFromChannelPage += 1;
//            [self reloadTableData];
//            [self.mRefreshControl endRefreshing];
//
//        } resultFailed:^(NSError *error) {
//
//            [QMUITips showError:@"加载失败" inView:self.view hideAfterDelay:2.0f];
//            [self.mRefreshControl endRefreshing];
//        }];
//
    }
}

- (void)insertMessagesToTable:(NSDictionary *)dict {
    
    NSNumber *status_code = [dict objectForKey:@"status_code"];
    if ([status_code isEqualToNumber:[NSNumber numberWithInt:200]]) {
        
        NSMutableArray *messageArray = dict[@"data"][@"content"];
        // 翻转数组
        NSMutableArray *messageArrayReverse = (NSMutableArray *)[[messageArray reverseObjectEnumerator] allObjects];
        
        for (NSDictionary *messageDict in messageArrayReverse) {
            BDMessageModel *messageModel = [[BDMessageModel alloc] initWithDictionary:messageDict];
            
            if (![self.mMessageArray containsObject:messageModel]) {
                
                // 插入最后
                NSUInteger index = [self.mMessageArray count];
                [self.mMessageArray addObject:messageModel];
                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
                
                [self.tableView beginUpdates];
                [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
                [self.tableView endUpdates];
            }
        }
        
        // 滚动到底部
        [self tableViewScrollToBottom:NO];
        
    } else {
        NSString *message = [dict objectForKey:@"message"];
        [QMUITips showError:message inView:self.view hideAfterDelay:2.0];
    }
    
    //
    if ([self.mMessageArray count] == 0) {
        //
        [self showEmptyViewWithText:@"消息记录为空" detailText:@"请尝试下拉刷新" buttonTitle:nil buttonAction:NULL];
    } else if (self.emptyViewShowing) {
        //
        [self hideEmptyView];
    }
}

#pragma mark - 通知

/**
 客服接入会话通知

 @param notification <#notification description#>
 */
- (void)notifyQueueAccept:(NSNotification *)notification {
    DDLogInfo(@"%s", __PRETTY_FUNCTION__);
    self.titleView.subtitle = @"接入会话";
    self.titleView.needsLoadingView = NO;
    
}

/**
 客服关闭会话通知

 @param notification <#notification description#>
 */
- (void)notifyThreadClose:(NSNotification *)notification {
    DDLogInfo(@"%s", __PRETTY_FUNCTION__);
    self.titleView.subtitle = @"客服关闭会话";
    self.mIsThreadClosed = YES;
}


/**
 收到新消息通知

 @param notification <#notification description#>
 */
- (void)notifyMessageAdd:(NSNotification *)notification {
    DDLogInfo(@"%s", __PRETTY_FUNCTION__);
    [self hideEmptyView];
    
    BDMessageModel *messageModel = [notification object];
    if ([messageModel.type isEqualToString:BD_MESSAGE_TYPE_NOTIFICATION_INVITE_RATE]) {
        self.rateInvite = TRUE;
        [self showRateView];
    }
    
    // 接收到其他人发送的消息
    if (!messageModel.isSend) {
        NSIndexPath *insertIndexPath = [NSIndexPath indexPathForRow:[self.mMessageArray count] inSection:0];
        [self.mMessageArray addObject:messageModel];
    
        [self.tableView beginUpdates];
        [self.tableView insertRowsAtIndexPaths:[NSMutableArray arrayWithObjects:insertIndexPath, nil] withRowAnimation:UITableViewRowAnimationBottom];
        [self.tableView endUpdates];
        [self tableViewScrollToBottom:YES];
        
        // TODO: 发送消息已读回执
        
    }
    
}


/**
 暂未启用

 @param notification <#notification description#>
 */
- (void)notifyMessageDelete:(NSNotification *)notification {
    DDLogInfo(@"%s", __PRETTY_FUNCTION__);
    
    // TODO: 优化处理
    [self reloadTableData];
}


/**
 消息撤回通知

 @param notification <#notification description#>
 */
- (void)notifyMessageRetract:(NSNotification *)notification {
    DDLogInfo(@"%s", __PRETTY_FUNCTION__);
    
    // TODO: 优化处理
    [self reloadTableData];
}


/**
 发送消息状态通知

 @param notification <#notification description#>
 */
- (void)notifyMessageStatus:(NSNotification *)notification {
    DDLogInfo(@"%s", __PRETTY_FUNCTION__);
    
    // TODO: 优化处理
    [self reloadTableData];
}


- (void)notifyKickoff:(NSNotification *)notification {
    DDLogInfo(@"%s", __PRETTY_FUNCTION__);
    NSString *content = [notification object];
    
    // __weak __typeof(self)weakSelf = self;
    QMUIAlertAction *okAction = [QMUIAlertAction actionWithTitle:@"确定" style:QMUIAlertActionStyleDefault handler:^(__kindof QMUIAlertController *aAlertController, QMUIAlertAction *action) {
        
        // 开发者可以根据自己需要决定是否调用退出登录
        // 注意: 同一账号同时登录多个客户端不影响正常会话
        
    }];
    QMUIAlertController *alertController = [QMUIAlertController alertControllerWithTitle:@"账号异地登录提示" message:content preferredStyle:QMUIAlertControllerStyleAlert];
    [alertController addAction:okAction];
    [alertController showWithAnimated:YES];
}

#pragma mark - BDGroupProfileViewControllerDelegate, BDContactProfileViewControllerDelegate

-(void)clearMessages {
    DDLogInfo(@"清空内存聊天记录");
    
     [self reloadTableData];
}

@end














