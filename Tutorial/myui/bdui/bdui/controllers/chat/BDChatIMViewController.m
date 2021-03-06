//
//  BDChatWxViewController.m
//  bytedesk-ui
//
//  Created by 萝卜丝 on 2019/3/11.
//  Copyright © 2019 bytedesk.com. All rights reserved.
//

#import "BDChatIMViewController.h"
#import "BDMsgViewCell.h"
#import "BDMsgNotificationViewCell.h"
#import "BDCommodityTableViewCell.h"
#import "BDUserinfoViewController.h"
#import "BDContactProfileViewController.h"
#import "BDSingleImagePickerPreviewViewController.h"
#import "KFDSUConstants.h"
#import "BDGroupProfileViewController.h"

#import "KFInputView.h"
#import "KFEmotionView.h"
#import "KFPlusView.h"
#import "KFRecordVoiceViewHUD.h"
#import "WBiCloudManager.h"
#import "KFUIUtils.h"

#import <HCSStarRatingView/HCSStarRatingView.h>

// core或者mars二选一即可
#import <bytedesk-core/bdcore.h>
//#import <bytedesk-mars/bdmars.h>

#define MaxSelectedImageCount 9
#define NormalImagePickingTag 1045
#define ModifiedImagePickingTag 1046
#define MultipleImagePickingTag 1047
#define SingleImagePickingTag 1048

#define INPUTBAR_HEIGHT                    60
#define EMOTION_PLUS_VIEW_HEIGHT           216.0f
#define VIEW_ANIMATION_DURATION            0.25f
#define TEXTBUBBLE_MAX_TEXT_WIDTH          180.0f

#define RECORD_VOICE_VIEW_HUD_WIDTH_HEIGHT 150.0f

static CGFloat const kToolbarHeight = 60;
//static CGFloat const kEmotionViewHeight = 232;

static QMUIAlbumContentType const kAlbumContentType = QMUIAlbumContentTypeOnlyPhoto;

@interface BDChatIMViewController ()<UINavigationControllerBackButtonHandlerProtocol, KFDSMsgViewCellDelegate, QMUIAlbumViewControllerDelegate,QMUIImagePickerViewControllerDelegate,BDSingleImagePickerPreviewViewControllerDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, QMUITextFieldDelegate, QMUIImagePreviewViewDelegate, KFEmotionViewDelegate, KFPlusViewDelegate, KFInputViewDelegate, BDGroupProfileViewControllerDelegate, BDContactProfileViewControllerDelegate,
    UIDocumentPickerDelegate,
    UIDocumentInteractionControllerDelegate,
    UIDocumentMenuDelegate,
    UIDocumentInteractionControllerDelegate>
{

}

//@property(nonatomic, strong) UIView *toolbarView;
//@property(nonatomic, strong) QMUITextField *toolbarTextField;
//@property(nonatomic, strong) QMUIButton *switchVoiceButton;
//@property(nonatomic, strong) QMUIButton *faceButton;
//@property(nonatomic, strong) QMUIButton *sendButton;
//@property(nonatomic, strong) QMUIButton *plusButton;
//@property(nonatomic, strong) QMUIButton *recordButton;

@property (nonatomic, strong) NSDictionary *emotionToTextDictionary;

@property(nonatomic, strong) QMUIImagePreviewViewController *imagePreviewViewController;
@property(nonatomic, strong) UIImageView *currentImageView;
//@property(nonatomic, strong) NSArray<UIImage *> *images;

// 是否为访客端
@property(nonatomic, assign) BOOL mIsVisitor; // 是否访客端调用接口
@property(nonatomic, assign) BOOL mIsPush;
@property(nonatomic, assign) BOOL mIsRobot;
@property(nonatomic, assign) BOOL mIsThreadClosed;

@property(nonatomic, assign) BOOL mIsInternetReachable;
@property(nonatomic, strong) NSString *mTitle;

@property(nonatomic, strong) UIRefreshControl *mRefreshControl;
@property(nonatomic, strong) NSMutableArray<BDMessageModel *> *mMessageArray;

//@property(nonatomic, strong) UIView *parentView;
@property(nonatomic, assign) NSInteger mGetMessageFromChannelPage;

@property(nonatomic, strong) NSString *mUid; // visitorUid/cid/gid
@property(nonatomic, strong) NSString *mWorkGroupWid; // 工作组wid
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

//
@property (nonatomic, strong) KFInputView               *kfInputView;
@property (nonatomic, strong) KFEmotionView             *kfEmotionView;
@property (nonatomic, strong) KFPlusView                *kfPlusView;
@property (nonatomic, strong) KFRecordVoiceViewHUD      *kfRecordVoiceViewHUD;

@property (nonatomic, assign) CGFloat                   inputViewY;
@property (nonatomic, assign) CGFloat                   keyboardY;
@property (nonatomic, assign) CGFloat                   keyboardHeight;

@property (nonatomic, assign) BOOL                      isEmotionPlusPressedToHideKeyboard;
@property (nonatomic, assign) BOOL                      mIsViewControllerClosed;

@property (nonatomic, strong) NSArray *documentTypes;
@property(nonatomic, assign) BOOL mViewDidAppeared;

@end

@implementation BDChatIMViewController

@synthesize mImagePickerController,
            kfInputView,
            kfEmotionView,
            kfPlusView,
            kfRecordVoiceViewHUD,

            inputViewY,
            keyboardY,
            keyboardHeight,
            isEmotionPlusPressedToHideKeyboard;


#pragma mark - 客服端接口

// 从会话model进入
- (void)initWithThreadModel:(BDThreadModel *)threadModel withPush:(BOOL)isPush {
    
    // 变量初始化
    self.mIsVisitor = NO;
    self.mIsPush = isPush;
    self.mThreadModel = threadModel;
    self.mThreadType = threadModel.type;
    self.mLastMessageId = INT_MAX;
    //
    self.mUid = self.mThreadModel.tid;
    // 右上角按钮
    UIBarButtonItem *rightItem = [UIBarButtonItem qmui_itemWithImage:[UIImage imageNamed:@"icon_more" inBundle:[NSBundle bundleForClass:self.class] compatibleWithTraitCollection:nil] target:self action:@selector(handleRightBarButtonItemClicked:)];
    self.navigationItem.rightBarButtonItem = rightItem;
}

- (void) initWithThreadModel:(BDThreadModel *)threadModel withPush:(BOOL)isPush withCustom:(NSDictionary *)custom {
    //
    [self initWithThreadModel:threadModel withPush:isPush];
    
    // TODO: 发送商品信息
    NSString *customJson = [BDUtils dictToJson:custom];
    [self sendCommodityMessage:customJson];
}

// 从联系人model进入
- (void)initWithContactModel:(BDContactModel *)contactModel withPush:(BOOL)isPush {
    
    // 变量初始化
    self.mIsVisitor = NO;
    self.mIsPush = isPush;
    self.mContactModel = contactModel;
    self.mUid = self.mContactModel.uid;
    self.mThreadType = BD_THREAD_TYPE_CONTACT;
    self.mTitle = self.mContactModel.real_name;
    self.mLastMessageId = INT_MAX;
    
    // FIXME: 因为点击右上角按钮初始化需要用到threadModel, 暂时隐藏不启用右上角按钮
    UIBarButtonItem *rightItem = [UIBarButtonItem qmui_itemWithImage:[UIImage imageNamed:@"icon_about" inBundle:[NSBundle bundleForClass:self.class] compatibleWithTraitCollection:nil] target:self action:@selector(handleRightBarButtonItemClicked:)];
    self.navigationItem.rightBarButtonItem = rightItem;
    
    //
    [BDCoreApis getContactThread:self.mUid resultSuccess:^(NSDictionary *dict) {
        DDLogInfo(@"%s %@", __PRETTY_FUNCTION__, dict);
        
        self.mUid = dict[@"data"][@"tid"];
        self.mThreadModel = [[BDThreadModel alloc] initWithDictionary:dict[@"data"]];

        [self reloadTableData];
        
    } resultFailed:^(NSError *error) {
        
    }];
}

- (void) initWithContactModel:(BDContactModel *)contactModel withPush:(BOOL)isPush withCustom:(NSDictionary *)custom {
    //
    [self initWithContactModel:contactModel withPush:isPush];
    
    // TODO: 发送商品信息
    NSString *customJson = [BDUtils dictToJson:custom];
    [self sendCommodityMessage:customJson];
}

// 从群组model进入
- (void)initWithGroupModel:(BDGroupModel *)groupModel withPush:(BOOL)isPush {
    
    // 变量初始化
    self.mIsVisitor = NO;
    self.mIsPush = isPush;
    self.mGroupModel = groupModel;
    self.mUid = self.mGroupModel.gid;
    self.mThreadType = BD_THREAD_TYPE_GROUP;
    self.mTitle = self.mGroupModel.nickname;
    self.mLastMessageId = INT_MAX;
    
    // 右上角按钮
    UIBarButtonItem *rightItem = [UIBarButtonItem qmui_itemWithImage:[UIImage imageNamed:@"icon_about" inBundle:[NSBundle bundleForClass:self.class] compatibleWithTraitCollection:nil] target:self action:@selector(handleRightBarButtonItemClicked:)];
    self.navigationItem.rightBarButtonItem = rightItem;
    
    //
    [BDCoreApis getGroupThread:self.mUid resultSuccess:^(NSDictionary *dict) {
        DDLogInfo(@"%s %@", __PRETTY_FUNCTION__, dict);
        
        self.mUid = dict[@"data"][@"tid"];
        self.mThreadModel = [[BDThreadModel alloc] initWithDictionary:dict[@"data"]];
                
        [self reloadTableData];
        
    } resultFailed:^(NSError *error) {
        
    }];
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
    self.mGetMessageFromChannelPage = 0;
    
    UITapGestureRecognizer *singleFingerTap =
    [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
    [self.tableView addGestureRecognizer:singleFingerTap];
    
    //输入框Toolbar
    CGRect inputViewFrame = CGRectMake(0.0f, self.view.frame.size.height - INPUTBAR_HEIGHT, self.view.frame.size.width, INPUTBAR_HEIGHT);
    self.kfInputView = [[KFInputView alloc] initWithFrame:inputViewFrame];
    self.kfInputView.delegate = self;
    [self.view addSubview:self.kfInputView];
    //
    self.emotionToTextDictionary = [NSDictionary dictionaryWithContentsOfFile:[[NSBundle bundleForClass:self.class] pathForResource:@"EmotionToText" ofType:@"plist"]];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    //
    self.tableView.frame = CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds) - kToolbarHeight);
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if (self.mViewDidAppeared) {
        return;
    }
    DDLogInfo(@"%s", __PRETTY_FUNCTION__);

    // FIXME: 加载大量图片容易引起界面卡顿，待优化
//    dispatch_async(dispatch_get_main_queue(), ^{
        CGRect recordVoiceViewFrame = CGRectMake((self.view.frame.size.width - RECORD_VOICE_VIEW_HUD_WIDTH_HEIGHT)/2,
                                                 (self.view.frame.size.height - RECORD_VOICE_VIEW_HUD_WIDTH_HEIGHT)/2,
                                                 RECORD_VOICE_VIEW_HUD_WIDTH_HEIGHT,
                                                 RECORD_VOICE_VIEW_HUD_WIDTH_HEIGHT);
        self.kfRecordVoiceViewHUD = [[KFRecordVoiceViewHUD alloc] initWithFrame:recordVoiceViewFrame];
        [self.view addSubview:self.kfRecordVoiceViewHUD];
        self.kfRecordVoiceViewHUD.hidden = TRUE;
        //
        CGRect emotionViewFrame = CGRectMake(0.0f, self.view.frame.size.height, self.view.frame.size.width, EMOTION_PLUS_VIEW_HEIGHT);
        self.kfEmotionView = [[KFEmotionView alloc] initWithFrame:emotionViewFrame];
        self.kfEmotionView.delegate = self;
        [self.view addSubview:self.kfEmotionView];
        //
        CGRect plusViewFrame = emotionViewFrame;
        self.kfPlusView = [[KFPlusView alloc] initWithFrame:plusViewFrame];
        self.kfPlusView.delegate = self;
        [self.view addSubview:self.kfPlusView];
//    });
    
    self.mViewDidAppeared = TRUE;
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
//        [self.view setQmui_shouldShowDebugColor:YES];
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
    // 从服务器加载聊天记录, 暂时不从服务器加载
    // [self refreshMessages];
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

- (BOOL)forceEnableInteractivePopGestureRecognizer {
    return self.forceEnableBackGesture;
}

- (void)handleRightBarButtonItemClicked:(id)sender {
    DDLogInfo(@"%s", __PRETTY_FUNCTION__);
    
    // 访客端
    if (self.mIsVisitor) {
        //
        [self showRateView];
        
    } else {
        //
        if ([self.mThreadType isEqualToString:BD_THREAD_TYPE_WORKGROUP]) {
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
    static NSString *commodityIdentifier = @"commodityCell";
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
        BDCommodityTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:commodityIdentifier];
        if (!cell) {
            cell = [[BDCommodityTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:commodityIdentifier];
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
    if ([self.mThreadType isEqualToString:BD_THREAD_TYPE_CONTACT]) {
        DDLogInfo(@"3. 客服端：联系人聊天记录 %@", self.mUid);
        self.mMessageArray = [BDCoreApis getMessagesWithContact:self.mUid];
    } else if ([self.mThreadType isEqualToString:BD_THREAD_TYPE_GROUP]) {
        DDLogInfo(@"4. 客服端：群组聊天记录 %@", self.mUid);
        self.mMessageArray = [BDCoreApis getMessagesWithGroup:self.mUid];
    } else {
        DDLogInfo(@"2. 客服端: 客服聊天记录 %@", self.mUid);
        self.mMessageArray = [BDCoreApis getMessagesWithThread:self.mUid];
        // 更新当前会话
        [self updateCurrentThread];
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
    [BDCoreApis updateCurrentThread:preTid currentTid:self.mUid resultSuccess:^(NSDictionary *dict) {
        
        [BDSettings setCurrentTid:self.mUid];
        
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
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notifyReloadCellSuccess:) name:BD_NOTIFICATION_MESSAGE_LOCALID object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notifyMessageAdd:) name:BD_NOTIFICATION_MESSAGE_ADD object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notifyMessageDelete:) name:BD_NOTIFICATION_MESSAGE_DELETE object:nil];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notifyMessagePreview::) name:BD_NOTIFICATION_MESSAGE_PREVIEW object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notifyMessageRecall:) name:BD_NOTIFICATION_MESSAGE_RECALL object:nil];
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
//    DDLogInfo(@"tableViewScrollToBottom");
    
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
    
    [UIView animateWithDuration:0.0f
                          delay:0.0
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         
                         CGSize Size = self.view.frame.size;
                         
                         UIEdgeInsets tableViewInsets = self.tableView.contentInset;
                         tableViewInsets.bottom = BD_INPUTBAR_HEIGHT;
                         self.tableView.contentInset = tableViewInsets;
                         self.tableView.scrollIndicatorInsets = tableViewInsets;
                         
//                         UIEdgeInsets tableViewContentInsets = [self.tableView contentInset];
//                         tableViewContentInsets.bottom = 0.0f;
//                         [self.tableView setContentInset:tableViewContentInsets];
                         
                         //调整kfInputView
                         self.kfInputView.frame = CGRectMake(0.0f,
                                                        Size.height - INPUTBAR_HEIGHT,
                                                        Size.width,
                                                        INPUTBAR_HEIGHT);

                         self.kfEmotionView.frame = CGRectMake(0.0f,
                                                               Size.height,
                                                               Size.width,
                                                               EMOTION_PLUS_VIEW_HEIGHT);

                         self.kfPlusView.frame = CGRectMake(0.0f,
                                                            Size.height,
                                                            Size.width,
                                                            EMOTION_PLUS_VIEW_HEIGHT);
                         
                     } completion:^(BOOL finished) {
                         
                     }];
}

#pragma mark - Handle Keyboard Show/Hide

- (void)handleWillShowKeyboard:(NSNotification *)notification {
    DDLogInfo(@"%s", __PRETTY_FUNCTION__);
    
    CGRect keyboardRect = [[notification.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    double duration = [[notification.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    CGRect keyboardFrame = [self.view convertRect:keyboardRect fromView:nil];
    keyboardY = keyboardFrame.origin.y;
    keyboardHeight = keyboardFrame.size.height;
    
    [UIView animateWithDuration:duration
                          delay:0.0f
                        options:UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         
                         CGRect inputViewFrame = [self.kfInputView frame];
                         inputViewFrame.origin.y = self.keyboardY - INPUTBAR_HEIGHT;
                         [self.kfInputView setFrame:inputViewFrame];
                         
                         UIEdgeInsets tableViewInsets = self.tableView.contentInset;
                         tableViewInsets.bottom = self.keyboardHeight;
                         self.tableView.contentInset = tableViewInsets;
                         self.tableView.scrollIndicatorInsets = tableViewInsets;
                         
                     } completion:^(BOOL finished) {
                         
                     }];
    
    [self tableViewScrollToBottom:YES];
}

- (void)handleWillHideKeyboard:(NSNotification *)notification {
    DDLogInfo(@"%s", __PRETTY_FUNCTION__);
    
    CGRect keyboardRect = [[notification.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    double duration = [[notification.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    keyboardY = [self.view convertRect:keyboardRect fromView:nil].origin.y;//键盘位置的y坐标
    
    
    [UIView animateWithDuration:duration
                          delay:0.0f
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         
                         CGRect inputViewFrame = [self.kfInputView frame];
                         inputViewFrame.origin.y = self.keyboardY - INPUTBAR_HEIGHT;
                         [self.kfInputView setFrame:inputViewFrame];
                         
                         //调整kfPlusView
                         CGRect plusViewFrame = [self.kfPlusView frame];
                         plusViewFrame.origin.y = inputViewFrame.origin.y + INPUTBAR_HEIGHT;
                         [self.kfPlusView setFrame:plusViewFrame];
                         
                         //隐藏emotionView
                         CGRect emotionViewFrame = [self.kfEmotionView frame];
                         emotionViewFrame.origin.y = inputViewFrame.origin.y + INPUTBAR_HEIGHT;;
                         [self.kfEmotionView setFrame:emotionViewFrame];
                         
                         UIEdgeInsets tableViewInsets = self.tableView.contentInset;
                         tableViewInsets.bottom = 0.0f;
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
    DDLogInfo(@"%s, content:%@, tid:%@, sessionType:%@ ", __PRETTY_FUNCTION__, content, self.mUid,  self.mThreadType);
    
    // TODO: 增加判断content长度，限制<512
    
    // 自定义发送消息本地id，消息发送成功之后，服务器会返回此id，可以用来判断消息发送状态
    NSString *localId = [[NSUUID UUID] UUIDString];
    
    // 插入本地消息, 可通过返回的messageModel首先更新本地UI，然后再发送消息
    BDMessageModel *messageModel = [[BDDBApis sharedInstance] insertTextMessageLocal:self.mUid withWorkGroupWid:self.mWorkGroupWid withContent:content withLocalId:localId withSessionType:self.mThreadType];
    DDLogInfo(@"%s %@ %@", __PRETTY_FUNCTION__, localId, messageModel.content);
    
    // TODO: 立刻更新UI，插入消息到界面并显示发送状态 activity indicator
    NSIndexPath *insertIndexPath = [NSIndexPath indexPathForRow:[self.mMessageArray count] inSection:0];
    [self.mMessageArray addObject:messageModel];
    DDLogInfo(@"message count: %ld", (long)[self.mMessageArray count]);

    [self.tableView beginUpdates];
    [self.tableView insertRowsAtIndexPaths:[NSMutableArray arrayWithObjects:insertIndexPath, nil] withRowAnimation:UITableViewRowAnimationBottom];
    [self.tableView endUpdates];
    [self tableViewScrollToBottom:NO];
     
    // 异步发送消息
//    [[BDMQTTApis sharedInstance] sendTextMessage:content toTid:self.mUid localId:localId sessionType:self.mThreadType];
    
    [[BDMQTTApis sharedInstance] sendTextMessageProtobuf:localId content:content thread:self.mThreadModel];
//    [[BDMQTTApis sharedInstance] sendTextMessageProtobuf:localId content:content
//        tid:self.mUid topic:self.mThreadModel.topic threadType:self.mThreadType threadNickname:self.mThreadModel.nickname threadAvatar:self.mThreadModel.avatar];
    
    // 加密之后发送
//     [[BDMarsApis sharedInstance] sendMessage:content topic:self.mUid];

//    // 同步发送消息
//    [BDCoreApis sendTextMessage:content toTid:self.mUid localId:localId sessionType:self.mThreadType resultSuccess:^(NSDictionary *dict) {
//        DDLogInfo(@"%s %@", __PRETTY_FUNCTION__, dict);
//        //
//        NSNumber *status_code = [dict objectForKey:@"status_code"];
//        if ([status_code isEqualToNumber:[NSNumber numberWithInt:200]]) {
//            // 发送成功
//
//            // 服务器返回自定义消息本地id
//            NSString *localId = dict[@"data"][@"localId"];
//            DDLogInfo(@"callback localId: %@", localId);
//
//            // 修改本地消息发送状态为成功
//            [[BDDBApis sharedInstance] updateMessageSuccess:localId];
//            [self reloadCellDataSuccess:localId];
//
//        } else {
//            // 修改本地消息发送状态为error
//            [[BDDBApis sharedInstance] updateMessageError:localId];
//            [self reloadCellDataError:localId];
//
//            //
//            NSString *message = dict[@"message"];
//            DDLogError(@"%s %@", __PRETTY_FUNCTION__, message);
//            [QMUITips showError:message inView:self.view hideAfterDelay:3];
//        }
//    } resultFailed:^(NSError *error) {
//        DDLogError(@"%s %@", __PRETTY_FUNCTION__, error);
//        // 修改本地消息发送状态为error
//        [[BDDBApis sharedInstance] updateMessageError:localId];
//        [self reloadCellDataError:localId];
//        //
//        if (error) {
//            [QMUITips showError:error.localizedDescription inView:self.view hideAfterDelay:3];
//        }
//    }];
}

//
- (void)uploadImageData:(NSData *)imageData {
    
    // TODO: 选取图片之后，上传成功之前，增加发送图片消息气泡，增加图片发送进度
    
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
            BDMessageModel *messageModel = [[BDDBApis sharedInstance] insertImageMessageLocal:self.mUid withWorkGroupWid:self.mWorkGroupWid withContent:imageUrl withLocalId:localId withSessionType:self.mThreadType];
            DDLogInfo(@"%s %@ %@", __PRETTY_FUNCTION__, localId, messageModel.image_url);
            
            // TODO: 立刻更新UI，插入消息到界面并显示发送状态 activity indicator
            NSIndexPath *insertIndexPath = [NSIndexPath indexPathForRow:[self.mMessageArray count] inSection:0];
            [self.mMessageArray addObject:messageModel];
            
            [self.tableView beginUpdates];
            [self.tableView insertRowsAtIndexPaths:[NSMutableArray arrayWithObjects:insertIndexPath, nil] withRowAnimation:UITableViewRowAnimationBottom];
            [self.tableView endUpdates];
            [self tableViewScrollToBottom:YES];

            //
            [[BDMQTTApis sharedInstance] sendImageMessageProtobuf:localId content:imageUrl thread:self.mThreadModel];
//            [[BDMQTTApis sharedInstance] sendImageMessageProtobuf:localId content:imageUrl
//            tid:self.mUid topic:self.mThreadModel.topic threadType:self.mThreadType threadNickname:self.mThreadModel.nickname threadAvatar:self.mThreadModel.avatar];
            
            // 同步发送图片消息
//            [BDCoreApis sendImageMessage:imageUrl toTid:self.mUid localId:localId sessionType:self.mThreadType resultSuccess:^(NSDictionary *dict) {
//                DDLogInfo(@"%s %@", __PRETTY_FUNCTION__, dict);
//                //
//                NSNumber *status_code = [dict objectForKey:@"status_code"];
//                if ([status_code isEqualToNumber:[NSNumber numberWithInt:200]]) {
//                    // 发送成功
//
//                    // 服务器返回自定义消息本地id
//                    NSString *localId = dict[@"data"][@"localId"];
//                    DDLogInfo(@"callback localId: %@", localId);
//
//                    // 修改本地消息发送状态为成功
//                    [[BDDBApis sharedInstance] updateMessageSuccess:localId];
//                    [self reloadCellDataSuccess:localId];
//
//                } else {
//                    // 修改本地消息发送状态为error
//                    [[BDDBApis sharedInstance] updateMessageError:localId];
//                    [self reloadCellDataError:localId];
//                    //
//                    NSString *message = dict[@"message"];
//                    DDLogError(@"%s %@", __PRETTY_FUNCTION__, message);
//                    [QMUITips showError:message inView:self.view hideAfterDelay:2];
//                }
//            } resultFailed:^(NSError *error) {
//                DDLogError(@"%s %@", __PRETTY_FUNCTION__, error);
//                // 修改本地消息发送状态为error
//                [[BDDBApis sharedInstance] updateMessageError:localId];
//                [self reloadCellDataError:localId];
//                //
//                if (error) {
//                    [QMUITips showError:error.localizedDescription inView:self.view hideAfterDelay:2];
//                }
//            }];
            
        } else {
            [QMUITips showError:@"发送图片错误" inView:self.view hideAfterDelay:2];
        }
        
    } resultFailed:^(NSError *error) {
        DDLogError(@"%s %@", __PRETTY_FUNCTION__, error);
        if (error) {
            [QMUITips showError:error.localizedDescription inView:self.view hideAfterDelay:3];
        }
    }];
}


- (void)uploadAmrVoice:(NSString *)amrVoiceFileName voiceLength:(int)voiceLength {
    
    NSString *amrVoiceFilePath = [NSString stringWithFormat:@"%@/Documents/%@", NSHomeDirectory(), amrVoiceFileName];
    NSData *voiceData = [NSData dataWithContentsOfFile:amrVoiceFilePath];
//    DDLogInfo(@"amrVoiceFileName: %@", amrVoiceFilePath);

    // TODO: 语音发送之后，上传成功之前，增加发送语音消息气泡
    
    //
    [BDCoreApis uploadVoiceData:voiceData withVoiceName:amrVoiceFileName resultSuccess:^(NSDictionary *dict) {
        DDLogInfo(@"%s %@", __PRETTY_FUNCTION__, dict);
        
        //
        NSNumber *status_code = [dict objectForKey:@"status_code"];
        if ([status_code isEqualToNumber:[NSNumber numberWithInt:200]]) {
            
            // 自定义发送消息本地id，消息发送成功之后，服务器会返回此id，可以用来判断消息发送状态
            NSString *localId = [[NSUUID UUID] UUIDString];
            NSString *voiceUrl = dict[@"data"];
            
            // 插入本地消息
            BDMessageModel *messageModel = [[BDDBApis sharedInstance] insertVoiceMessageLocal:self.mUid withWorkGroupWid:self.mWorkGroupWid withContent:voiceUrl withLocalId:localId withSessionType:self.mThreadType withVoiceLength:voiceLength  withFormat:@"amr"];
            DDLogInfo(@"%s %@ %@", __PRETTY_FUNCTION__, localId, messageModel.voice_url);
            
            // TODO: 立刻更新UI，插入消息到界面并显示发送状态 activity indicator
            NSIndexPath *insertIndexPath = [NSIndexPath indexPathForRow:[self.mMessageArray count] inSection:0];
            [self.mMessageArray addObject:messageModel];
            //
            [self.tableView beginUpdates];
            [self.tableView insertRowsAtIndexPaths:[NSMutableArray arrayWithObjects:insertIndexPath, nil] withRowAnimation:UITableViewRowAnimationBottom];
            [self.tableView endUpdates];
            [self tableViewScrollToBottom:YES];
            
            //
            [[BDMQTTApis sharedInstance] sendVoiceMessageProtobuf:localId content:voiceUrl thread:self.mThreadModel];
//            [[BDMQTTApis sharedInstance] sendVoiceMessageProtobuf:localId content:voiceUrl
//            tid:self.mUid topic:self.mThreadModel.topic threadType:self.mThreadType threadNickname:self.mThreadModel.nickname threadAvatar:self.mThreadModel.avatar];
            
            // 同步发送录音消息
//            [BDCoreApis sendVoiceMessage:voiceUrl toTid:self.mUid localId:localId sessionType:self.mThreadType voiceLength:voiceLength format:@"amr" resultSuccess:^(NSDictionary *dict) {
//                DDLogInfo(@"%s %@", __PRETTY_FUNCTION__, dict);
//                //
//                NSNumber *status_code = [dict objectForKey:@"status_code"];
//                if ([status_code isEqualToNumber:[NSNumber numberWithInt:200]]) {
//                    // 发送成功
//
//                    // 服务器返回自定义消息本地id
//                    NSString *localId = dict[@"data"][@"localId"];
//                    DDLogInfo(@"callback localId: %@", localId);
//
//                    // 修改本地消息发送状态为成功
//                    [[BDDBApis sharedInstance] updateMessageSuccess:localId];
//                    [self reloadCellDataSuccess:localId];
//
//                } else {
//                    // 修改本地消息发送状态为error
//                    [[BDDBApis sharedInstance] updateMessageError:localId];
//                    [self reloadCellDataError:localId];
//                    //
//                    NSString *message = dict[@"message"];
//                    DDLogError(@"%s %@", __PRETTY_FUNCTION__, message);
//                    [QMUITips showError:message inView:self.view hideAfterDelay:2];
//                }
//
//            } resultFailed:^(NSError *error) {
//                DDLogError(@"%s %@", __PRETTY_FUNCTION__, error);
//                // 修改本地消息发送状态为error
//                [[BDDBApis sharedInstance] updateMessageError:localId];
//                [self reloadCellDataError:localId];
//                //
//                if (error) {
//                    [QMUITips showError:error.localizedDescription inView:self.view hideAfterDelay:2];
//                }
//            }];
            
        } else {
            [QMUITips showError:@"发送录音错误" inView:self.view hideAfterDelay:2];
        }
        
    } resultFailed:^(NSError *error) {
        DDLogError(@"%s %@", __PRETTY_FUNCTION__, error);
        if (error) {
            [QMUITips showError:error.localizedDescription inView:self.view hideAfterDelay:3];
        }
    }];
}

// 发送商品消息
-(void)sendCommodityMessage:(NSString *)content {
    DDLogInfo(@"%s, content:%@, tid:%@, sessionType:%@ ", __PRETTY_FUNCTION__, content, self.mUid,  self.mThreadType);
    
    // 自定义发送消息本地id，消息发送成功之后，服务器会返回此id，可以用来判断消息发送状态
    NSString *localId = [[NSUUID UUID] UUIDString];
    
    // 插入本地消息, 可通过返回的messageModel首先更新本地UI，然后再发送消息
    BDMessageModel *messageModel = [[BDDBApis sharedInstance] insertCommodityMessageLocal:self.mUid withWorkGroupWid:self.mWorkGroupWid withContent:content withLocalId:localId withSessionType:self.mThreadType];
    DDLogInfo(@"%s %@ %@", __PRETTY_FUNCTION__, localId, messageModel.content);

    // TODO: 立刻更新UI，插入消息到界面并显示发送状态 activity indicator
    NSIndexPath *insertIndexPath = [NSIndexPath indexPathForRow:[self.mMessageArray count] inSection:0];
    [self.mMessageArray addObject:messageModel];

    [self.tableView beginUpdates];
    [self.tableView insertRowsAtIndexPaths:[NSMutableArray arrayWithObjects:insertIndexPath, nil] withRowAnimation:UITableViewRowAnimationBottom];
    [self.tableView endUpdates];
    [self tableViewScrollToBottom:YES];
    
    //
    
    
    // 同步发送消息
//    [BDCoreApis sendCommodityMessage:content toTid:self.mUid localId:localId sessionType:self.mThreadType resultSuccess:^(NSDictionary *dict) {
//        DDLogInfo(@"%s %@", __PRETTY_FUNCTION__, dict);
//        //
//        NSNumber *status_code = [dict objectForKey:@"status_code"];
//        if ([status_code isEqualToNumber:[NSNumber numberWithInt:200]]) {
//            // 发送成功
//
//            // 服务器返回自定义消息本地id
//            NSString *localId = dict[@"data"][@"localId"];
//            DDLogInfo(@"callback localId: %@", localId);
//
//            // reloadRowsAtIndexPaths
//
//            // 修改本地消息发送状态为成功
//            [[BDDBApis sharedInstance] updateMessageSuccess:localId];
//            [self reloadCellDataSuccess:localId];
//
//
//        } else {
//            // 修改本地消息发送状态为error
//            [[BDDBApis sharedInstance] updateMessageError:localId];
//            [self reloadCellDataError:localId];
//            //
//            NSString *message = dict[@"message"];
//            DDLogError(@"%s %@", __PRETTY_FUNCTION__, message);
//            [QMUITips showError:message inView:self.view hideAfterDelay:2];
//        }
//    } resultFailed:^(NSError *error) {
//        DDLogError(@"%s %@", __PRETTY_FUNCTION__, error);
//        // 修改本地消息发送状态为error
//        [[BDDBApis sharedInstance] updateMessageError:localId];
//        [self reloadCellDataError:localId];
//        //
//        if (error) {
//            [QMUITips showError:error.localizedDescription inView:self.view hideAfterDelay:2];
//        }
//    }];
}

// 发送红包消息
-(void)sendRedPacketMessage:(NSString *)content {
    DDLogInfo(@"%s, content:%@, tid:%@, sessionType:%@ ", __PRETTY_FUNCTION__, content, self.mUid,  self.mThreadType);
    
    // 自定义发送消息本地id，消息发送成功之后，服务器会返回此id，可以用来判断消息发送状态
    NSString *localId = [[NSUUID UUID] UUIDString];
    
    // 插入本地消息, 可通过返回的messageModel首先更新本地UI，然后再发送消息
    BDMessageModel *messageModel = [[BDDBApis sharedInstance] insertRedPacketMessageLocal:self.mUid withWorkGroupWid:self.mWorkGroupWid withContent:content withLocalId:localId withSessionType:self.mThreadType];
    DDLogInfo(@"%s %@ %@", __PRETTY_FUNCTION__, localId, messageModel.content);
    
    // TODO: 立刻更新UI，插入消息到界面并显示发送状态 activity indicator
    NSIndexPath *insertIndexPath = [NSIndexPath indexPathForRow:[self.mMessageArray count] inSection:0];
    [self.mMessageArray addObject:messageModel];
    
    [self.tableView beginUpdates];
    [self.tableView insertRowsAtIndexPaths:[NSMutableArray arrayWithObjects:insertIndexPath, nil] withRowAnimation:UITableViewRowAnimationBottom];
    [self.tableView endUpdates];
    [self tableViewScrollToBottom:YES];
    
    //
    
    
    // 同步发送消息
//    [BDCoreApis sendRedPacketMessage:content toTid:self.mUid localId:localId sessionType:self.mThreadType resultSuccess:^(NSDictionary *dict) {
//        DDLogInfo(@"%s %@", __PRETTY_FUNCTION__, dict);
//        //
//        NSNumber *status_code = [dict objectForKey:@"status_code"];
//        if ([status_code isEqualToNumber:[NSNumber numberWithInt:200]]) {
//            // 发送成功
//
//            // 服务器返回自定义消息本地id
//            NSString *localId = dict[@"data"][@"localId"];
//            DDLogInfo(@"callback localId: %@", localId);
//
//            // reloadRowsAtIndexPaths
//
//            // 修改本地消息发送状态为成功
//            [[BDDBApis sharedInstance] updateMessageSuccess:localId];
//            [self reloadCellDataSuccess:localId];
//
//        } else {
//            // 修改本地消息发送状态为error
//            [[BDDBApis sharedInstance] updateMessageError:localId];
//            [self reloadCellDataError:localId];
//            //
//            NSString *message = dict[@"message"];
//            DDLogError(@"%s %@", __PRETTY_FUNCTION__, message);
//            [QMUITips showError:message inView:self.view hideAfterDelay:2];
//        }
//    } resultFailed:^(NSError *error) {
//        DDLogError(@"%s %@", __PRETTY_FUNCTION__, error);
//        // 修改本地消息发送状态为error
//        [[BDDBApis sharedInstance] updateMessageError:localId];
//        [self reloadCellDataError:localId];
//        //
//        if (error) {
//            [QMUITips showError:error.localizedDescription inView:self.view hideAfterDelay:2];
//        }
//    }];
}

#pragma mark - 表情

-(void)emotionFaceButtonPressed:(id)sender
{
    UIButton *emotionButton = (UIButton *)sender;
    NSString *emotionText = [[self emotionToTextDictionary] objectForKey:[NSString stringWithFormat:@"Expression_%ld", (long)emotionButton.tag]];
//    DDLogError(@"emotion %@", emotionText);
    
    //取余为0，即整除
    if (emotionButton.tag%21 == 0)
    {
        emotionText = @"删除";
    }
    
    NSString *content = [self.kfInputView.inputTextView text];
    NSInteger contentLength = [content length];
    NSString *newContent;

    if ([emotionText isEqualToString:@"删除"])
    {
        if (contentLength > 0)
        {
            if ([@"]" isEqualToString:[content substringFromIndex:contentLength - 1]])
            {
                if ([content rangeOfString:@"["].location == NSNotFound)
                {
                    newContent = [content substringToIndex:contentLength - 1];
                }
                else
                {
                    newContent = [content substringToIndex:[content rangeOfString:@"[" options:NSBackwardsSearch].location];
                }
            }
            else
            {
                newContent = [content substringToIndex:contentLength-1];
            }

            self.kfInputView.inputTextView.text = newContent;
        }
    }
    else
    {
        [self.kfInputView.inputTextView setText:[NSString stringWithFormat:@"%@%@", content, emotionText]];
    }

    [self.kfInputView textViewDidChange:kfInputView.inputTextView];
}

-(void)emotionViewSendButtonPressed:(id)sender
{
    NSString *content = [self.kfInputView.inputTextView text];

    if ([content length] == 0) {
        return;
    }
    
    [self sendMessage:content];
}


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
//        dispatch_sync(dispatch_get_main_queue(), ^{
        self.mImagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
//        });
        [self presentViewController:mImagePickerController animated:YES completion:nil];
        
    }else if(authStatus == AVAuthorizationStatusNotDetermined){
        // Explicit user permission is required for media capture, but the user has not yet granted or denied such permission.
        [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
            if(granted){//点击允许访问时调用
                //用户明确许可与否，媒体需要捕获，但用户尚未授予或拒绝许可。
                //DDLogInfo(@"Granted access to %@", AVMediaTypeVideo);
//                dispatch_sync(dispatch_get_main_queue(), ^{
                     self.mImagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
//                });
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


-(void)shareRateButtonPressed:(id)sender {
    DDLogInfo(@"发送商品消息 %s", __PRETTY_FUNCTION__);
    
    // TODO: 发送商品信息
    NSDictionary *dict = [[NSDictionary alloc] initWithObjectsAndKeys:
                          BD_MESSAGE_TYPE_COMMODITY, @"type",
                          @"商品标题", @"title",
                          @"商品详情", @"content",
                          @"¥9.99", @"price",
                          @"https://item.m.jd.com/product/12172344.html", @"url",
                          @"https://m.360buyimg.com/mobilecms/s750x750_jfs/t4483/332/2284794111/122812/4bf353/58ed7f42Nf16d6b20.jpg!q80.dpg", @"imageUrl",
                          nil];
    NSString *customJson = [BDUtils dictToJson:dict];
    [self sendCommodityMessage:customJson];
}

-(void)shareShowFAQButtonPressed:(id)sender {
    DDLogInfo(@"发送红包消息 %s", __PRETTY_FUNCTION__);
    
    // TODO: 发送红包消息
    [self sendRedPacketMessage:@"9.99"];
    
}

#pragma mark - 选取 && 发送文件

// https://github.com/wenmobo/WBDocumentBrowserDemo
// https://github.com/Unlimitzzh/FileAccess_iCloud_QQ_Wechat
-(void)shareFileButtonPressed:(id)sender {
    DDLogInfo(@"发送文件消息 %s", __PRETTY_FUNCTION__);
    
    // 直接选择文件
    UIDocumentPickerViewController *documentPickerViewController = [[UIDocumentPickerViewController alloc] initWithDocumentTypes:[KFUIUtils documentTypes] inMode:UIDocumentPickerModeOpen];
    documentPickerViewController.delegate = self;
    [self presentViewController:documentPickerViewController
                       animated:YES
                     completion:nil];
    
    // alertsheet形式弹窗
//    UIDocumentMenuViewController *documentProviderMenu =
//    [[UIDocumentMenuViewController alloc] initWithDocumentTypes:[KFUIUtils documentTypes]
//                                                         inMode:UIDocumentPickerModeImport];
//
//    documentProviderMenu.delegate = self;
//    [self presentViewController:documentProviderMenu animated:YES completion:nil];
    
}

-(void)shareDestroyAfterReadingButtonPressed:(id)sender {
    DDLogInfo(@"设置阅后即焚 %s", __PRETTY_FUNCTION__);
    
}

#pragma mark - UIDocumentPickerDelegate

/*  < iOS 11 API > */
- (void)documentPicker:(UIDocumentPickerViewController *)controller didPickDocumentsAtURLs:(NSArray<NSURL *> *)urls {
    DDLogInfo(@"%s",__PRETTY_FUNCTION__);
    
    for (NSURL *url in urls) {
        DDLogInfo(@"url: %@", url);
        
        [self getFileFromiCloud:url];
    }
}

/*  < iOS 8 API > */
- (void)documentPicker:(UIDocumentPickerViewController *)controller didPickDocumentAtURL:(NSURL *)url {
    DDLogInfo(@"%s, url: %@", __PRETTY_FUNCTION__, url);
    
    [self getFileFromiCloud:url];
}

- (void)documentPickerWasCancelled:(UIDocumentPickerViewController *)controller {
    DDLogWarn(@"%s",__func__);
}

- (void)getFileFromiCloud:(NSURL *)url {
    
    // 某些文件url末尾带有'/',去掉
    NSString *urlString = [url absoluteString];
    if ([urlString hasSuffix:@"/"]) {
        urlString = [urlString substringWithRange:NSMakeRange(0, [urlString length] - 1)];
    }
    
    NSArray *array = [urlString componentsSeparatedByString:@"/"];
    NSString *fileName = [array lastObject];
    //        DDLogInfo(@"fileName 1: %@", fileName);
    
    fileName = [fileName stringByRemovingPercentEncoding];
    //        DDLogInfo(@"fileName 2: %@", fileName);
    
    if ([WBiCloudManager iCloudEnable]) {
        [WBiCloudManager wb_downloadWithDocumentURL:url
                                     completedBlock:^(id contents, NSString *type) {
                                         
                                         DDLogInfo(@"type: %@", type);
                                         
                                         if ([contents isKindOfClass:[NSData class]]) {
                                             
                                             NSData *data = contents;
                                             //
//                                             NSString *path = [NSHomeDirectory() stringByAppendingString:[NSString stringWithFormat:@"/Documents/%@",fileName]];
                                             //  file path: /var/mobile/Containers/Data/Application/910CED69-727D-4F4D-A19D-CDA6D3719466/Documents/架构图.key
//                                             DDLogInfo(@"file path: %@", path);
                                             //  < 写入沙盒 >
                                             // [NSFileWrapper writeToFile:atomically:]: unrecognized selector sent to instance 0x281963180
//                                             [data writeToFile:path atomically:YES];
                                             
                                             // 上传文件 并发送
                                             [self uploadFileData:data fileName:fileName fileType:type];
                                             
                                         } else if ([contents isKindOfClass:[NSFileWrapper class]]) {
                                             
                                             NSFileWrapper *fileWrapper = contents;
                                             
                                             DDLogInfo(@"filename: %@, attr: %@", fileWrapper.filename, fileWrapper.fileAttributes);
                                             
                                             if ([fileWrapper isDirectory]) {
                                                 // FIXME: 选取文件，提示文件夹？
                                                DDLogInfo(@"文件夹");
                                                [QMUITips showError:@"文件夹?" inView:self.view hideAfterDelay:2];
                                             } else {
                                                 //
                                                 DDLogInfo(@"文件");
                                                 [self uploadFileData:[fileWrapper regularFileContents] fileName:fileName  fileType:type];
                                             }
                                             
                                         } else {
                                             
                                            DDLogInfo(@"其他类型文件");
                                            [QMUITips showError:@"其他类型文件" inView:self.view hideAfterDelay:2];
                                         }
                                     }];
    } else {
        DDLogWarn(@"iCloud not enabled");
        [QMUITips showError:@"iCloud not enabled" inView:self.view hideAfterDelay:2];
    }
}

- (void)uploadFileData:(NSData *)fileData fileName:(NSString *)fileName fileType:(NSString *)fileType {
    
    NSString *fileSize = [NSString stringWithFormat:@"%.2fmb", (float)[fileData length]/1024.0f/1024.0f];
    DDLogInfo(@"%s fileName: %@, fileSize: %@", __PRETTY_FUNCTION__, fileName, fileSize);
    
    // TODO: 选取文件之后，上传成功之前，增加发送文件消息气泡，增加文件发送进度
    
    
    [BDCoreApis uploadFileData:fileData withFileName:fileName resultSuccess:^(NSDictionary *dict) {
        DDLogInfo(@"%s %@", __PRETTY_FUNCTION__, dict);
        
        //
        NSNumber *status_code = [dict objectForKey:@"status_code"];
        if ([status_code isEqualToNumber:[NSNumber numberWithInt:200]]) {
            
            // 自定义发送消息本地id，消息发送成功之后，服务器会返回此id，可以用来判断消息发送状态
            NSString *localId = [[NSUUID UUID] UUIDString];
            NSString *fileUrl = dict[@"data"];
            
            // 插入本地消息
            BDMessageModel *messageModel = [[BDDBApis sharedInstance] insertFileMessageLocal:self.mUid withWorkGroupWid:self.mWorkGroupWid withContent:fileUrl withLocalId:localId withSessionType:self.mThreadType withFormat:fileType withFileName:fileName withFileSize:fileSize];
            DDLogInfo(@"%s %@ %@", __PRETTY_FUNCTION__, localId, messageModel.file_url);
            
            // TODO: 立刻更新UI，插入消息到界面并显示发送状态 activity indicator
            NSIndexPath *insertIndexPath = [NSIndexPath indexPathForRow:[self.mMessageArray count] inSection:0];
            [self.mMessageArray addObject:messageModel];
            
            [self.tableView beginUpdates];
            [self.tableView insertRowsAtIndexPaths:[NSMutableArray arrayWithObjects:insertIndexPath, nil] withRowAnimation:UITableViewRowAnimationBottom];
            [self.tableView endUpdates];
            [self tableViewScrollToBottom:YES];
            
            // 同步发送文件消息
            [BDCoreApis sendFileMessage:fileUrl toTid:self.mUid localId:localId sessionType:self.mThreadType format:fileType fileName:fileName fileSize:fileSize resultSuccess:^(NSDictionary *dict) {
                DDLogInfo(@"%s %@", __PRETTY_FUNCTION__, dict);
                //
                NSNumber *status_code = [dict objectForKey:@"status_code"];
                if ([status_code isEqualToNumber:[NSNumber numberWithInt:200]]) {
                    // 发送成功

                    // 服务器返回自定义消息本地id
                    NSString *localId = dict[@"data"][@"localId"];
                    DDLogInfo(@"callback localId: %@", localId);

                    // TODO：更新发送状态，隐藏activity indicator

                } else {
                    // 修改本地消息发送状态为error
                    [[BDDBApis sharedInstance] updateMessageError:localId];
                    //
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
            
        } else {
            [QMUITips showError:@"发送文件错误" inView:self.view hideAfterDelay:2];
        }
        
    } resultFailed:^(NSError *error) {
        DDLogError(@"%s %@", __PRETTY_FUNCTION__, error);
    }];
}

#pragma mark - UIDocumentMenuDelegate

- (void)documentMenu:(UIDocumentMenuViewController *)documentMenu didPickDocumentPicker:(UIDocumentPickerViewController *)documentPicker {
    DDLogInfo(@"%s", __PRETTY_FUNCTION__);
    documentPicker.delegate = self;
    [self presentViewController:documentPicker
                       animated:YES
                     completion:nil];
}

- (void)documentMenuWasCancelled:(UIDocumentMenuViewController *)documentMenu {
    DDLogInfo(@"%s", __PRETTY_FUNCTION__);
}


#pragma mark - UIDocumentInteractionControllerDelegate




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

- (void) linkUrlClicked:(NSString *)url {
    DDLogInfo(@"%s %@", __PRETTY_FUNCTION__, url);
    
    NSURL *urlToOpen = [[NSURL alloc] initWithString:url];
    [[UIApplication sharedApplication] openURL:urlToOpen];
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

- (void) robotLinkClicked:(NSString *)label withKey:(NSString *)key; {
    DDLogInfo(@"%s key:%@, url:%@", __PRETTY_FUNCTION__, label, key);
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
                      if (error) {
                          [QMUITips showError:error.localizedDescription inView:self.view hideAfterDelay:3];
                      }
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
//    [self.toolbarTextField resignFirstResponder];
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
//            CGFloat distanceFromBottom = [QMUIKeyboardManager distanceFromMinYToBottomInView:self.view keyboardRect:keyboardUserInfo.endFrame];
            
//            self.toolbarView.layer.transform = CATransform3DMakeTranslation(0, - distanceFromBottom, 0);
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
//            self.toolbarView.layer.transform = CATransform3DIdentity;
            //            self.emotionInputManager.emotionView.layer.transform = CATransform3DIdentity;
        } completion:NULL];
    } else {
        [UIView animateWithDuration:0.25 delay:0 options:QMUIViewAnimationOptionsCurveOut animations:^{
//            self.toolbarView.layer.transform = CATransform3DIdentity;
            //            self.emotionInputManager.emotionView.layer.transform = CATransform3DIdentity;
        } completion:NULL];
    }
}

#pragma mark - 录音

- (void)handleSwitchVoiceButtonEvent:(id)sender {
    DDLogInfo(@"%s", __PRETTY_FUNCTION__);
    
//    if ([self.toolbarTextField isHidden]) {
//        [self.recordButton setHidden:TRUE];
//        [self.toolbarTextField setHidden:FALSE];
//    } else {
//        [self.recordButton setHidden:FALSE];
//        [self.toolbarTextField setHidden:TRUE];
//    }
}

//
-(void)recordVoiceButtonTouchDown:(id)sender {
    DDLogInfo(@"%s", __PRETTY_FUNCTION__);
    
//#if TARGET_IPHONE_SIMULATOR
//
//#else
    
//    if ([BDUtils canRecordVoice]) {
        //显示录音HUD
        self.kfRecordVoiceViewHUD.hidden = FALSE;
        //开始录音
        [self.kfRecordVoiceViewHUD startVoiceRecordingToUsername:self.mUid];
    
        //添加录音虚拟气泡
//        KFMessageItem *inputtingVoiceMessage = [[KFMessageItem alloc] init];
//        inputtingVoiceMessage.isSendFromMe = TRUE;
//        inputtingVoiceMessage.username = workgroupname;
//        inputtingVoiceMessage.messageType = KFMessageTypeRecordingVoice;
//        inputtingVoiceMessage.voiceMessageLength = 0;
//        inputtingVoiceMessage.messageContent = @"recording";
//        inputtingVoiceMessage.timestamp = [NSDate date];
//        [messagesMutableArray addObject:inputtingVoiceMessage];
    
        [self.tableView reloadData];
        [self tableViewScrollToBottom:YES];
        
//    }
    
//#endif
}


-(void)recordVoiceButtonTouchUpInside:(id)sender {
    DDLogInfo(@"%s", __PRETTY_FUNCTION__);
    
//#if TARGET_IPHONE_SIMULATOR
//
//#else
//
//#endif
    
//    if ([BDUtils canRecordVoice]) {
    
        self.kfRecordVoiceViewHUD.hidden = TRUE;
        //
        NSString *amrVoiceFileName = [kfRecordVoiceViewHUD stopVoiceRecording];
        int voiceLength = (int)kfRecordVoiceViewHUD.voiceRecordLength;
//        for (int i = 0; i < [messagesMutableArray count]; i++) {
//            KFMessageItem *item = [messagesMutableArray objectAtIndex:i];
//            if (item.isSendFromMe && item.messageType == KFMessageTypeRecordingVoice && item.voiceMessageLength == 0) {
//                [messagesMutableArray removeObject:item];
//                [kfTableView reloadData];
//            }
//        }
        
        if ([amrVoiceFileName isEqualToString:@"tooshort"]) {
            DDLogInfo(@"tooshort");
        }
        else if ([amrVoiceFileName isEqualToString:@"toolong"]) {
            DDLogInfo(@"toolong");
        }
        else
        {
            //
//            KFMessageItem *sendingVoiceItem = [[KFMessageItem alloc] init];
//            sendingVoiceItem.isSendFromMe = TRUE;
//            sendingVoiceItem.username = workgroupname;
//            sendingVoiceItem.messageType = KFMessageTypeSendingVoice;
//            sendingVoiceItem.voiceFileName = voiceFilename;
//            sendingVoiceItem.timestamp = [NSDate date];
//            [messagesMutableArray addObject:sendingVoiceItem];
//            //
//            [kfTableView reloadData];
//            [self tableViewScrollToBottom:YES];
//            //上传、发送语音文件
//            [[KFUtils sharedInstance] uploadVoice:voiceFilename workgroupName:workgroupname];
            
            [self uploadAmrVoice:amrVoiceFileName voiceLength:voiceLength];
            
        }
//    }
    
}


-(void)recordVoiceButtonTouchUpOutside:(id)sender {
    DDLogInfo(@"%s", __PRETTY_FUNCTION__);
    
//#if TARGET_IPHONE_SIMULATOR
//
//#else
//
//#endif
    
    self.kfRecordVoiceViewHUD.hidden = TRUE;
    [self.kfRecordVoiceViewHUD cancelVoiceRecording];

    
}


-(void)recordVoiceButtonTouchDragInside:(id)sender {
    DDLogInfo(@"%s", __PRETTY_FUNCTION__);
    
//#if TARGET_IPHONE_SIMULATOR
//
//#else
//
//#endif
    
//    if ([BDUtils canRecordVoice]) {
    
        //
        self.kfRecordVoiceViewHUD.microphoneImageView.hidden = FALSE;
        self.kfRecordVoiceViewHUD.signalWaveImageView.hidden = FALSE;
        self.kfRecordVoiceViewHUD.cancelArrowImageView.hidden = TRUE;
        //
        self.kfRecordVoiceViewHUD.hintLabel.text = @"上滑取消";
        self.kfRecordVoiceViewHUD.hintLabel.backgroundColor = [UIColor clearColor];
        
//    }

}

-(void)recordVoiceButtonTouchDragOutside:(id)sender {
    DDLogInfo(@"%s", __PRETTY_FUNCTION__);
    
//#if TARGET_IPHONE_SIMULATOR
//
//#else
//
//#endif
    
//    if ([BDUtils canRecordVoice]) {
        //
        self.kfRecordVoiceViewHUD.microphoneImageView.hidden = TRUE;
        self.kfRecordVoiceViewHUD.signalWaveImageView.hidden = TRUE;
        self.kfRecordVoiceViewHUD.cancelArrowImageView.hidden = FALSE;
        //
        self.kfRecordVoiceViewHUD.hintLabel.text = @"松手取消";
        self.kfRecordVoiceViewHUD.hintLabel.backgroundColor = [UIColor redColor];
//    }

}

// TODO: bug显示表情面板的时候，会遮挡聊天记录
- (void)handleFaceButtonEvent:(id)sender {
    DDLogInfo(@"%s", __PRETTY_FUNCTION__);
}

- (void)handlePlusButtonEvent:(id)sender {
    DDLogInfo(@"%s", __PRETTY_FUNCTION__);
}

- (void)handleSendButtonEvent:(id)sender {
    DDLogInfo(@"%s", __PRETTY_FUNCTION__);
}

- (void)showEmotionView {
}

#pragma mark - 下拉刷新

// TODO: 区分加载聊天记录
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
        
    } else if ([self.mThreadType isEqualToString:BD_THREAD_TYPE_WORKGROUP] ||
               [self.mThreadType isEqualToString:BD_THREAD_TYPE_APPOINTED]) {
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
 Description
 
 @param notification <#notification description#>
 */
- (void)notifyReloadCellSuccess:(NSNotification *)notification {
    NSMutableDictionary *dict = [notification object];
    NSString *localId = dict[@"localId"];
//    NSString *status = dict[@"status"];
    DDLogInfo(@"%s %@", __PRETTY_FUNCTION__, localId);
    //
    [self reloadCellDataSuccess:localId];
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
        
        // FIXME: 仅针对单聊和客服会话有效，群聊暂不发送已读状态
        // TODO: 发送消息已读回执
        // 非系统消息
        if (![messageModel.type hasPrefix:BD_MESSAGE_TYPE_NOTIFICATION]) {
            // 消息状态
            if (messageModel.status != NULL ||
                [messageModel.status isEqualToString:BD_MESSAGE_STATUS_STORED]) {
                // TODO: 更新本地消息为已读
                
                // 不是自己发送的消息，发送已读回执
                if (![messageModel.uid isEqualToString:[BDSettings getUid]]) {
//                    [[BDMQTTApis sharedInstance] sendReceiptReadMessage:messageModel.mid threadTid:self.mUid];
                    [[BDMQTTApis sharedInstance] sendReceiptReadMessageProtobufThread:self.mThreadModel receiptMid:messageModel.mid];
                }
            }
        }
        
        // TODO: 判断是否阅后即焚消息，如果是，则倒计时销毁
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
- (void)notifyMessageRecall:(NSNotification *)notification {
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

#pragma mark - KFInputViewDelegate

-(void)showMenuButtonPressed:(id)sender
{
    [self.view endEditing:YES];

}

-(void)switchVoiceButtonPressed:(id)sender
{
    //NSLog(@"%s",__PRETTY_FUNCTION__);
    
    //如果当前按住说话按钮隐藏，则将其显示，并隐藏输入框
    if ([self.kfInputView recordVoiceButton].hidden) {
        
        [self.kfInputView recordVoiceButton].hidden = FALSE;
        
        [[self.kfInputView inputTextView] resignFirstResponder];
        
        [self.kfInputView inputTextView].hidden = TRUE;
    }
    //如果当前按住说话按钮显示，则将其隐藏，并显示输入框，并将其获取焦点
    else
    {
        [self.kfInputView recordVoiceButton].hidden = TRUE;
        
        [self.kfInputView inputTextView].hidden = FALSE;
        
        [[self.kfInputView inputTextView] becomeFirstResponder];
    }
    
    //
    CGFloat emotionViewFrameY = [kfEmotionView frame].origin.y;
    CGFloat plusViewFrameY = [self.kfPlusView frame].origin.y;
    CGFloat frameHeight = self.view.frame.size.height;
    
    //如果当前Emotion扩展处于显示状态, 则隐藏Emotion扩展，
    if (emotionViewFrameY != frameHeight) {
        
        [UIView animateWithDuration:VIEW_ANIMATION_DURATION
                              delay:0.0f
                            options:UIViewAnimationOptionCurveEaseOut
                         animations:^{
                             //
                             //调整kfTableView
                             UIEdgeInsets tableViewContentInsets = [self.tableView contentInset];
                             tableViewContentInsets.bottom -= EMOTION_PLUS_VIEW_HEIGHT;
                             [self.tableView setContentInset:tableViewContentInsets];
                             
                             //调整kfInputView到页面底部
                             CGRect inputViewFrame = [self.kfInputView frame];
                             inputViewFrame.origin.y += EMOTION_PLUS_VIEW_HEIGHT;
                             [self.kfInputView setFrame:inputViewFrame];
                             
                             //隐藏emotionView
                             CGRect emotionViewFrame = [self.kfEmotionView frame];
                             emotionViewFrame.origin.y += EMOTION_PLUS_VIEW_HEIGHT;
                             [self.kfEmotionView setFrame:emotionViewFrame];
                             
                         } completion:^(BOOL finished) {
                             
                         }];
        
    }
    //如果当前Plus扩展处于显示状态，则隐藏Plus扩展
    else if (plusViewFrameY != frameHeight) {
        
        [UIView animateWithDuration:VIEW_ANIMATION_DURATION
                              delay:0.0f
                            options:UIViewAnimationOptionCurveEaseOut
                         animations:^{
                             
                             //调整kfTableView
                             UIEdgeInsets tableViewContentInsets = [self.tableView contentInset];
                             tableViewContentInsets.bottom -= EMOTION_PLUS_VIEW_HEIGHT;
                             [self.tableView setContentInset:tableViewContentInsets];
                             
                             //调整kfInputView到页面底部
                             CGRect inputViewFrame = [self.kfInputView frame];
                             inputViewFrame.origin.y += EMOTION_PLUS_VIEW_HEIGHT;
                             [self.kfInputView setFrame:inputViewFrame];
                             
                             CGRect plusViewFrame = [self.kfPlusView frame];
                             plusViewFrame.origin.y += EMOTION_PLUS_VIEW_HEIGHT;
                             [self.kfPlusView setFrame:plusViewFrame];
                             
                         } completion:^(BOOL finished) {
                             
                         }];
    }
    
    
}

-(void)switchEmotionButtonPressed:(id)sender
{
    //NSLog(@"%s",__PRETTY_FUNCTION__);
    
    //如果输入框目前处于隐藏状态,即：显示录音button状态，则：1.隐藏录音button，2.显示输入框，3.更换switchViewButton image
    if ([self.kfInputView inputTextView].hidden)
    {
        [self.kfInputView recordVoiceButton].hidden = TRUE;
        
        [self.kfInputView inputTextView].hidden = FALSE;
        
        [[self.kfInputView switchVoiceButton] setImage:[UIImage imageNamed:@"ToolViewInputVoice_ios7" inBundle:[NSBundle bundleForClass:self.class] compatibleWithTraitCollection:nil] forState:UIControlStateNormal];
        [[self.kfInputView switchVoiceButton] setImage:[UIImage imageNamed:@"ToolViewInputVoiceHL_ios7" inBundle:[NSBundle bundleForClass:self.class] compatibleWithTraitCollection:nil] forState:UIControlStateHighlighted];
    }
    
    
    CGFloat inputViewFrameY = [self.kfInputView frame].origin.y;
    CGFloat emotionViewFrameY = [kfEmotionView frame].origin.y;
    CGFloat plusViewFrameY = [self.kfPlusView frame].origin.y;
    CGFloat frameHeight = self.view.frame.size.height;
    
    //当前输入工具栏在会话页面最底部，显示表情
    if (inputViewFrameY == frameHeight - INPUTBAR_HEIGHT) {
        
        [UIView animateWithDuration:VIEW_ANIMATION_DURATION
                              delay:0.0f
                            options:UIViewAnimationOptionCurveEaseOut
                         animations:^{
                             
                             //调整kfTableView
                             UIEdgeInsets tableViewContentInsets = [self.tableView contentInset];
                             tableViewContentInsets.bottom += EMOTION_PLUS_VIEW_HEIGHT;
                             [self.tableView setContentInset:tableViewContentInsets];
                             
                             //调整kfInputView
                             CGRect inputViewFrame = [self.kfInputView frame];
                             inputViewFrame.origin.y -= EMOTION_PLUS_VIEW_HEIGHT;
                             [self.kfInputView setFrame:inputViewFrame];
                             
                             //调整kfEmotionView
                             CGRect emotionViewFrame = [self.kfEmotionView frame];
                             emotionViewFrame.origin.y -= EMOTION_PLUS_VIEW_HEIGHT;
                             [self.kfEmotionView setFrame:emotionViewFrame];
                             
                         } completion:^(BOOL finished) {
                             
                         }];
        
    }
    //当前显示表情扩展, 需要显示键盘
    else if (emotionViewFrameY != frameHeight) {
        
        [UIView animateWithDuration:VIEW_ANIMATION_DURATION
                              delay:0.0f
                            options:UIViewAnimationOptionCurveEaseOut
                         animations:^{
                             
                             //输入框设置焦点，显示键盘
                             [self.kfInputView becomeFirstResponder];
                             
                             //隐藏emotionView
                             CGRect emotionViewFrame = [self.kfEmotionView frame];
                             emotionViewFrame.origin.y += EMOTION_PLUS_VIEW_HEIGHT;
                             [self.kfEmotionView setFrame:emotionViewFrame];
                             
                             //
                         } completion:^(BOOL finished) {
                             
                         }];
    }
    //当前显示plus扩展, 需要隐藏plus扩展，显示表情扩展
    else if (plusViewFrameY != frameHeight) {
        
        [UIView animateWithDuration:VIEW_ANIMATION_DURATION
                              delay:0.0f
                            options:UIViewAnimationOptionCurveEaseOut
                         animations:^{
                             
                             //
                             CGRect emotionViewFrame = [self.kfEmotionView frame];
                             emotionViewFrame.origin.y -= EMOTION_PLUS_VIEW_HEIGHT;
                             [self.kfEmotionView setFrame:emotionViewFrame];
                             
                             //
                             CGRect plusViewFrame = [self.kfPlusView frame];
                             plusViewFrame.origin.y += EMOTION_PLUS_VIEW_HEIGHT;
                             [self.kfPlusView setFrame:plusViewFrame];
                             
                             //
                             
                         } completion:^(BOOL finished) {
                             
                         }];
    }
    //当前显示键盘, 需要隐藏键盘，显示kfEmotionView
    else
    {
        
        [UIView animateWithDuration:VIEW_ANIMATION_DURATION
                              delay:0.0f
                            options:UIViewAnimationOptionCurveEaseOut
                         animations:^{
                             
                             //隐藏键盘
                             UIView *keyboard = self.kfInputView.inputTextView.inputAccessoryView.superview;
                             CGRect keyboardFrame = keyboard.frame;
                             keyboardFrame.origin.y = frameHeight;
                             [keyboard setFrame:keyboardFrame];
                             
//                             isEmotionPlusPressedToHideKeyboard = TRUE;
                             
                             [self.kfInputView resignFirstResponder];
                             
                             //调整inputViewFrame
                             CGRect inputViewFrame = [self.kfInputView frame];
                             inputViewFrame.origin.y = frameHeight - EMOTION_PLUS_VIEW_HEIGHT - INPUTBAR_HEIGHT;
                             [self.kfInputView setFrame:inputViewFrame];
                             
                             //显示kfEmotionView
                             CGRect emotionViewFrame = [self.kfEmotionView frame];
                             emotionViewFrame.origin.y -= EMOTION_PLUS_VIEW_HEIGHT;
                             [self.kfEmotionView setFrame:emotionViewFrame];
                             
                             
                         } completion:^(BOOL finished) {
                             
                         }];
        
    }
    
    [self tableViewScrollToBottom:YES];
}

-(void)switchPlusButtonPressed:(id)sender
{
    //如果输入框目前处于隐藏状态,即：显示录音button状态，则：1.隐藏录音button，2.显示输入框，3.更换switchViewButton image
    if ([self.kfInputView inputTextView].hidden)
    {
        [self.kfInputView recordVoiceButton].hidden = TRUE;
        
        [self.kfInputView inputTextView].hidden = FALSE;
        
        [[self.kfInputView switchVoiceButton] setImage:[UIImage imageNamed:@"ToolViewInputVoice_ios7" inBundle:[NSBundle bundleForClass:self.class] compatibleWithTraitCollection:nil] forState:UIControlStateNormal];
        [[self.kfInputView switchVoiceButton] setImage:[UIImage imageNamed:@"ToolViewInputVoiceHL_ios7" inBundle:[NSBundle bundleForClass:self.class] compatibleWithTraitCollection:nil] forState:UIControlStateHighlighted];
    }
    
    CGFloat inputViewFrameY = [self.kfInputView frame].origin.y;
    CGFloat emotionViewFrameY = [kfEmotionView frame].origin.y;
    CGFloat plusViewFrameY = [self.kfPlusView frame].origin.y;
    CGFloat frameHeight = self.view.frame.size.height;
    
    
    //当前输入工具栏在会话页面最底部，显示plus
    if (inputViewFrameY == frameHeight - INPUTBAR_HEIGHT) {
        
        [UIView animateWithDuration:VIEW_ANIMATION_DURATION
                              delay:0.0f
                            options:UIViewAnimationOptionCurveEaseOut
                         animations:^{
                             
                             //调整kfTableView
                             UIEdgeInsets tableViewContentInsets = [self.tableView contentInset];
                             tableViewContentInsets.bottom += EMOTION_PLUS_VIEW_HEIGHT;
                             [self.tableView setContentInset:tableViewContentInsets];
                             
                             //调整kfInputView
                             CGRect inputViewFrame = [self.kfInputView frame];
                             inputViewFrame.origin.y -= EMOTION_PLUS_VIEW_HEIGHT;
                             [self.kfInputView setFrame:inputViewFrame];
                             
                             //调整kfPlusView
                             CGRect plusViewFrame = [self.kfPlusView frame];
                             plusViewFrame.origin.y -= EMOTION_PLUS_VIEW_HEIGHT;
                             [self.kfPlusView setFrame:plusViewFrame];
                             
                         } completion:^(BOOL finished) {
                             
                         }];
        
    }
    //当前显示Plus扩展, 需要显示键盘
    else if (plusViewFrameY != frameHeight) {
        
        [UIView animateWithDuration:VIEW_ANIMATION_DURATION
                              delay:0.0f
                            options:UIViewAnimationOptionCurveEaseOut
                         animations:^{
                             
                             //输入框设置焦点，显示键盘
                             [self.kfInputView becomeFirstResponder];
                             
                             //隐藏plusView
                             CGRect plusViewFrame = [self.kfPlusView frame];
                             plusViewFrame.origin.y += EMOTION_PLUS_VIEW_HEIGHT;
                             [self.kfPlusView setFrame:plusViewFrame];
                             
                         } completion:^(BOOL finished) {
                             
                         }];
    }
    //当前显示表情扩展, 需要隐藏表情扩展，显示Plus扩展
    else if (emotionViewFrameY != frameHeight) {
        
        [UIView animateWithDuration:VIEW_ANIMATION_DURATION
                              delay:0.0f
                            options:UIViewAnimationOptionCurveEaseOut
                         animations:^{
                             
                             //
                             CGRect plusViewFrame = [self.kfPlusView frame];
                             plusViewFrame.origin.y -= EMOTION_PLUS_VIEW_HEIGHT;
                             [self.kfPlusView setFrame:plusViewFrame];
                             
                             //
                             CGRect emotionViewFrame = [self.kfEmotionView frame];
                             emotionViewFrame.origin.y += EMOTION_PLUS_VIEW_HEIGHT;
                             [self.kfEmotionView setFrame:emotionViewFrame];
                             
                             //
                             
                         } completion:^(BOOL finished) {
                             
                         }];
    }
    //当前显示键盘, 需要隐藏键盘，显示kfPlusView
    else
    {
        [UIView animateWithDuration:VIEW_ANIMATION_DURATION
                              delay:0.0f
                            options:UIViewAnimationOptionCurveEaseOut
                         animations:^{
                             
                             //隐藏键盘
                             UIView *keyboard = self.kfInputView.inputTextView.inputAccessoryView.superview;
                             CGRect keyboardFrame = keyboard.frame;
                             keyboardFrame.origin.y = frameHeight;
                             [keyboard setFrame:keyboardFrame];
                             
//                             isEmotionPlusPressedToHideKeyboard = TRUE;
                             
                             [self.kfInputView resignFirstResponder];
                             
                             //调整inputViewFrame
                             CGRect inputViewFrame = [self.kfInputView frame];
                             inputViewFrame.origin.y = frameHeight - EMOTION_PLUS_VIEW_HEIGHT - INPUTBAR_HEIGHT;
                             [self.kfInputView setFrame:inputViewFrame];
                             
                             //显示kfPlusView
                             CGRect plusViewFrame = [self.kfPlusView frame];
                             plusViewFrame.origin.y -= EMOTION_PLUS_VIEW_HEIGHT;
                             [self.kfPlusView setFrame:plusViewFrame];
                             
                         } completion:^(BOOL finished) {
                             
                         }];
        
    }
    
    [self tableViewScrollToBottom:YES];
    
}

-(void)sendMessage:(NSString *)content {
    DDLogInfo(@"%s", __PRETTY_FUNCTION__);
    
//    NSString *content = self.kfInputView.inputTextView.text;
    if ([content stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]].length > 0) {
        [self sendTextMessage:content];
        [self.kfInputView.inputTextView setText:@""];
    }
}

#pragma mark - BDGroupProfileViewControllerDelegate, BDContactProfileViewControllerDelegate

-(void)clearMessages {
    DDLogInfo(@"清空内存聊天记录");
    
    [self reloadTableData];
}



@end
