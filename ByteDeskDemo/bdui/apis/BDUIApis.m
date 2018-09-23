//
//  KFDSUIApis.m
//  bdui
//
//  Created by 萝卜丝·Bytedesk.com on 2017/7/15.
//  Copyright © 2017年 Bytedesk.com. All rights reserved.
//

#import "BDUIApis.h"
#import "BDChatViewController.h"

static BDUIApis *sharedInstance = nil;

@implementation BDUIApis

+ (BDUIApis *)sharedInstance {
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[BDUIApis alloc] init];
    });
    return sharedInstance;
}

#pragma mark - 访客端接口

+ (void)visitorPushChat:(UINavigationController *)navigationController
                    uId:(NSString *)uId
                    wId:(NSString *)wId
              withTitle:(NSString *)title{
//    https://blog.csdn.net/u011096206/article/details/50606778
    [self initUI];
    //
    BDChatViewController *chatViewController = [[BDChatViewController alloc] init];
    chatViewController.navigationItem.backBarButtonItem.title = @"";
    [chatViewController initWithUid:uId wId:wId withTitle:title withPush:YES];
    [navigationController pushViewController:chatViewController animated:YES];
}

+ (void)visitorPresentChat:(UINavigationController *)navigationController
                       uId:(NSString *)uId
                       wId:(NSString *)wId
                 withTitle:(NSString *)title{
    [self initUI];
    
    BDChatViewController *chatViewController = [[BDChatViewController alloc] init];
    [chatViewController initWithUid:uId wId:wId withTitle:title withPush:NO];
    //
    QMUINavigationController *chatNavigationController = [[QMUINavigationController alloc] initWithRootViewController:chatViewController];
    [navigationController presentViewController:chatNavigationController animated:YES completion:^{
        
    }];
}

#pragma mark - 客服端接口

+ (void)adminPushChat:(UINavigationController *)navigationController
      withThreadModel:(BDThreadModel *)threadModel {
    //
    BDChatViewController *chatViewController = [[BDChatViewController alloc] init];
    [chatViewController initWithThreadModel:threadModel withPush:YES];
    [navigationController pushViewController:chatViewController animated:YES];
}

+ (void)adminPresentChat:(UINavigationController *)navigationController
         withThreadModel:(BDThreadModel *)threadModel {
    //
    BDChatViewController *chatViewController = [[BDChatViewController alloc] init];
    [chatViewController initWithThreadModel:threadModel withPush:NO];
    //
    QMUINavigationController *chatNavigationController = [[QMUINavigationController alloc] initWithRootViewController:chatViewController];
    [navigationController presentViewController:chatNavigationController animated:YES completion:^{
        
    }];
}


#pragma mark - 公共接口

+(void)initUI {
    
    QMUICMI.navBarHighlightedAlpha = 0.2f;                                      // NavBarHighlightedAlpha : QMUINavigationButton 在 highlighted 时的 alpha
    QMUICMI.navBarDisabledAlpha = 0.2f;                                         // NavBarDisabledAlpha : QMUINavigationButton 在 disabled 时的 alpha
    QMUICMI.navBarButtonFont = UIFontMake(17);                                  // NavBarButtonFont : QMUINavigationButtonTypeNormal 的字体（由于系统存在一些 bug，这个属性默认不对 UIBarButtonItem 生效）
    QMUICMI.navBarButtonFontBold = UIFontBoldMake(17);                          // NavBarButtonFontBold : QMUINavigationButtonTypeBold 的字体
//    QMUICMI.navBarBackgroundImage = UIImageMake(@"navigationbar_background");   // NavBarBackgroundImage : UINavigationBar 的背景图
//    QMUICMI.navBarShadowImage = [UIImage new];                                  // NavBarShadowImage : UINavigationBar.shadowImage，也即导航栏底部那条分隔线
//    QMUICMI.navBarBarTintColor = nil;                                           // NavBarBarTintColor : UINavigationBar.barTintColor，也即背景色
    QMUICMI.navBarTintColor = UIColorWhite;                                     // NavBarTintColor : QMUINavigationBar 的 tintColor，也即导航栏上面的按钮颜色
    QMUICMI.navBarTitleColor = NavBarTintColor;                                 // NavBarTitleColor : UINavigationBar 的标题颜色，以及 QMUINavigationTitleView 的默认文字颜色
    QMUICMI.navBarTitleFont = UIFontBoldMake(17);                               // NavBarTitleFont : UINavigationBar 的标题字体，以及 QMUINavigationTitleView 的默认字体
//    QMUICMI.navBarLargeTitleColor = nil;                                        // NavBarLargeTitleColor : UINavigationBar 在大标题模式下的标题颜色，仅在 iOS 11 之后才有效
//    QMUICMI.navBarLargeTitleFont = nil;                                         // NavBarLargeTitleFont : UINavigationBar 在大标题模式下的标题字体，仅在 iOS 11 之后才有效
    QMUICMI.navBarBackButtonTitlePositionAdjustment = UIOffsetZero;             // NavBarBarBackButtonTitlePositionAdjustment : 导航栏返回按钮的文字偏移
    QMUICMI.navBarBackIndicatorImage = [UIImage qmui_imageWithShape:QMUIImageShapeNavBack size:CGSizeMake(12, 20) tintColor:NavBarTintColor];                                     // NavBarBackIndicatorImage : 导航栏的返回按钮的图片
    QMUICMI.navBarCloseButtonImage = [UIImage qmui_imageWithShape:QMUIImageShapeNavClose size:CGSizeMake(16, 16) tintColor:NavBarTintColor];     // NavBarCloseButtonImage : QMUINavigationButton 用到的 × 的按钮图片
    
    QMUICMI.navBarLoadingMarginRight = 3;                                       // NavBarLoadingMarginRight : QMUINavigationTitleView 里左边 loading 的右边距
    QMUICMI.navBarAccessoryViewMarginLeft = 5;                                  // NavBarAccessoryViewMarginLeft : QMUINavigationTitleView 里右边 accessoryView 的左边距
    QMUICMI.navBarActivityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;// NavBarActivityIndicatorViewStyle : QMUINavigationTitleView 里左边 loading 的主题
    QMUICMI.navBarAccessoryViewTypeDisclosureIndicatorImage = [UIImage qmui_imageWithShape:QMUIImageShapeTriangle size:CGSizeMake(8, 5) tintColor:UIColorWhite];     // NavBarAccessoryViewTypeDisclosureIndicatorImage : QMUINavigationTitleView 右边箭头的图片
    
}


@end







