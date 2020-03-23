//
//  QMUIConfigurationTemplate.m
//  qmui
//
//  Created by QMUI Team on 15/3/29.
//  Copyright (c) 2015年 QMUI Team. All rights reserved.
//

#import "QMUIConfigurationTemplate.h"

@implementation QMUIConfigurationTemplate

static UIImage *disclosureIndicatorImage;
static UIImage *disclosureIndicatorImageDark;

#pragma mark - <QMUIConfigurationTemplateProtocol>

- (void)applyConfigurationTemplate {
    
    if (!disclosureIndicatorImage) disclosureIndicatorImage = [UIImage qmui_imageWithShape:QMUIImageShapeDisclosureIndicator size:CGSizeMake(6, 10) lineWidth:1 tintColor:UIColorGray7];
    if (!disclosureIndicatorImageDark) disclosureIndicatorImageDark = [UIImage qmui_imageWithShape:QMUIImageShapeDisclosureIndicator size:CGSizeMake(6, 10) lineWidth:1 tintColor:UIColorMake(98, 100, 104)];
    
    // === 修改配置值 === //
    
#pragma mark - Global Color
    
    QMUICMI.clearColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:0];       // UIColorClear : 透明色
    QMUICMI.whiteColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:1];       // UIColorWhite : 白色（不用 [UIColor whiteColor] 是希望保持颜色空间为 RGB）
    QMUICMI.blackColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:1];       // UIColorBlack : 黑色（不用 [UIColor blackColor] 是希望保持颜色空间为 RGB）
    QMUICMI.grayColor = UIColorGray4;                                           // UIColorGray  : 最常用的灰色
    QMUICMI.grayDarkenColor = UIColor.qd_mainTextColor;                          // UIColorGrayDarken : 深一点的灰色
    QMUICMI.grayLightenColor = UIColorGray7;                                    // UIColorGrayLighten : 浅一点的灰色
    QMUICMI.redColor = UIColorMake(250, 58, 58);                                // UIColorRed : 红色
    QMUICMI.greenColor = UIColorTheme4;                                         // UIColorGreen : 绿色
    QMUICMI.blueColor = UIColorTheme6;                                    // UIColorBlue : 蓝色
    QMUICMI.yellowColor = UIColorTheme3;                                        // UIColorYellow : 黄色
    
    QMUICMI.linkColor = UIColorMake(56, 116, 171);                              // UIColorLink : 文字链接颜色
    QMUICMI.disabledColor = UIColorGray;                                        // UIColorDisabled : 全局 disabled 的颜色，一般用于 UIControl 等控件
    QMUICMI.backgroundColor = UIColor.qd_backgroundColor;                                     // UIColorForBackground : 界面背景色，默认用于 QMUICommonViewController.view 的背景色
    QMUICMI.maskDarkColor = UIColorMakeWithRGBA(0, 0, 0, .35f);                 // UIColorMask : 深色的背景遮罩，默认用于 QMAlertController、QMUIDialogViewController 等弹出控件的遮罩
    QMUICMI.maskLightColor = UIColorMakeWithRGBA(255, 255, 255, .5f);           // UIColorMaskWhite : 浅色的背景遮罩，QMUIKit 里默认没用到，只是占个位
    QMUICMI.separatorColor = UIColor.qd_separatorColor;                          // UIColorSeparator : 全局默认的分割线颜色，默认用于列表分隔线颜色、UIView (QMUI_Border) 分隔线颜色
    QMUICMI.separatorDashedColor = UIColorMake(17, 17, 17);                     // UIColorSeparatorDashed : 全局默认的虚线分隔线的颜色，默认 QMUIKit 暂时没用到
    QMUICMI.placeholderColor = UIColor.qd_placeholderColor;                                    // UIColorPlaceholder，全局的输入框的 placeholder 颜色，默认用于 QMUITextField、QMUITextView，不影响系统 UIKit 的输入框
    
    // 测试用的颜色
    QMUICMI.testColorRed = UIColorMakeWithRGBA(255, 0, 0, .3);
    QMUICMI.testColorGreen = UIColorMakeWithRGBA(0, 255, 0, .3);
    QMUICMI.testColorBlue = UIColorMakeWithRGBA(0, 0, 255, .3);
    
    
#pragma mark - UIControl
    
    QMUICMI.controlHighlightedAlpha = 0.5f;                                     // UIControlHighlightedAlpha : UIControl 系列控件在 highlighted 时的 alpha，默认用于 QMUIButton、 QMUINavigationTitleView
    QMUICMI.controlDisabledAlpha = 0.5f;                                        // UIControlDisabledAlpha : UIControl 系列控件在 disabled 时的 alpha，默认用于 QMUIButton
    
#pragma mark - UIButton
    QMUICMI.buttonHighlightedAlpha = UIControlHighlightedAlpha;                 // ButtonHighlightedAlpha : QMUIButton 在 highlighted 时的 alpha，不影响系统的 UIButton
    QMUICMI.buttonDisabledAlpha = UIControlDisabledAlpha;                       // ButtonDisabledAlpha : QMUIButton 在 disabled 时的 alpha，不影响系统的 UIButton
    QMUICMI.buttonTintColor = UIColor.qd_tintColor;                              // ButtonTintColor : QMUIButton 默认的 tintColor，不影响系统的 UIButton
    
    QMUICMI.ghostButtonColorBlue = UIColorBlue;                                 // GhostButtonColorBlue : QMUIGhostButtonColorBlue 的颜色
    QMUICMI.ghostButtonColorRed = UIColorRed;                                   // GhostButtonColorRed : QMUIGhostButtonColorRed 的颜色
    QMUICMI.ghostButtonColorGreen = UIColorGreen;                               // GhostButtonColorGreen : QMUIGhostButtonColorGreen 的颜色
    QMUICMI.ghostButtonColorGray = UIColorGray;                                 // GhostButtonColorGray : QMUIGhostButtonColorGray 的颜色
    QMUICMI.ghostButtonColorWhite = UIColorWhite;                               // GhostButtonColorWhite : QMUIGhostButtonColorWhite 的颜色
    
    QMUICMI.fillButtonColorBlue = UIColorBlue;                                  // FillButtonColorBlue : QMUIFillButtonColorBlue 的颜色
    QMUICMI.fillButtonColorRed = UIColorRed;                                    // FillButtonColorRed : QMUIFillButtonColorRed 的颜色
    QMUICMI.fillButtonColorGreen = UIColorGreen;                                // FillButtonColorGreen : QMUIFillButtonColorGreen 的颜色
    QMUICMI.fillButtonColorGray = UIColorGray;                                  // FillButtonColorGray : QMUIFillButtonColorGray 的颜色
    QMUICMI.fillButtonColorWhite = UIColorWhite;                                // FillButtonColorWhite : QMUIFillButtonColorWhite 的颜色
    
    
#pragma mark - TextInput
    QMUICMI.textFieldTintColor = UIColor.qd_tintColor;                          // TextFieldTintColor : QMUITextField、QMUITextView 的 tintColor，不影响 UIKit 的输入框
    QMUICMI.textFieldTextInsets = UIEdgeInsetsMake(0, 7, 0, 7);                 // TextFieldTextInsets : QMUITextField 的内边距，不影响 UITextField
    QMUICMI.keyboardAppearance = UIKeyboardAppearanceDefault;                   // KeyboardAppearance : UITextView、UITextField、UISearchBar 的 keyboardAppearance

#pragma mark - UISwitch
    QMUICMI.switchOnTintColor = UIColor.qd_tintColor;                           // SwitchOnTintColor : UISwitch 打开时的背景色（除了圆点外的其他颜色）
    QMUICMI.switchOffTintColor =  UIColor.qd_separatorColor;                    // SwitchOffTintColor : UISwitch 关闭时的背景色（除了圆点外的其他颜色）
    QMUICMI.switchTintColor = SwitchOnTintColor;                                // SwitchTintColor : UISwitch 关闭时的周围边框颜色
    QMUICMI.switchThumbTintColor = nil;                                         // SwitchThumbTintColor : UISwitch 中间的操控圆点的颜色
    
#pragma mark - NavigationBar
    
    QMUICMI.navBarHighlightedAlpha = 0.2f;                                      // NavBarHighlightedAlpha : QMUINavigationButton 在 highlighted 时的 alpha
    QMUICMI.navBarDisabledAlpha = 0.2f;                                         // NavBarDisabledAlpha : QMUINavigationButton 在 disabled 时的 alpha
    QMUICMI.navBarButtonFont = UIFontMake(17);                                  // NavBarButtonFont : QMUINavigationButtonTypeNormal 的字体（由于系统存在一些 bug，这个属性默认不对 UIBarButtonItem 生效）
    QMUICMI.navBarButtonFontBold = UIFontBoldMake(17);                          // NavBarButtonFontBold : QMUINavigationButtonTypeBold 的字体
    QMUICMI.navBarBackgroundImage = [UIImageMake(@"navigationbar_background") resizableImageWithCapInsets:UIEdgeInsetsMake(0, 1, 0, 1) resizingMode:UIImageResizingModeStretch];   // NavBarBackgroundImage : UINavigationBar 的背景图，注意 navigationBar 的高度会受多个因素（是否全面屏、是否使用了 navigationItem.prompt、是否将 UISearchBar 作为 titleView）的影响，要检查各种情况是否都显示正常。
    QMUICMI.navBarShadowImage = nil;                                            // NavBarShadowImage : UINavigationBar.shadowImage，也即导航栏底部那条分隔线，配合 NavBarShadowImageColor 使用。
    QMUICMI.navBarShadowImageColor = UIColorClear;                              // NavBarShadowImageColor : UINavigationBar.shadowImage 的颜色，如果为 nil，则显示系统默认 shadowImage，如果为全透明，则不显示 shadowImage，如果为除了 nil 和全透明外的其他颜色，则会将这个颜色叠加到 NavBarShadowImage 上显示出来，如果不存在 NavBarShadowImage，则使用一张 1px 高的图片作为默认图。
    QMUICMI.navBarBarTintColor = nil;                                           // NavBarBarTintColor : UINavigationBar.barTintColor，也即背景色
    QMUICMI.navBarStyle = UIBarStyleDefault;                                    // NavBarStyle : UINavigationBar 的 barStyle
    QMUICMI.navBarTintColor = UIColorWhite;                                     // NavBarTintColor : QMUINavigationBar 的 tintColor，也即导航栏上面的按钮颜色
    QMUICMI.navBarTitleColor = NavBarTintColor;                                 // NavBarTitleColor : UINavigationBar 的标题颜色，以及 QMUINavigationTitleView 的默认文字颜色
//    QMUICMI.navBarTitleColor = [UIColor blackColor];
    QMUICMI.navBarTitleFont = UIFontBoldMake(17);                               // NavBarTitleFont : UINavigationBar 的标题字体，以及 QMUINavigationTitleView 的默认字体
    QMUICMI.navBarLargeTitleColor = nil;                                        // NavBarLargeTitleColor : UINavigationBar 在大标题模式下的标题颜色，仅在 iOS 11 之后才有效
    QMUICMI.navBarLargeTitleFont = nil;                                         // NavBarLargeTitleFont : UINavigationBar 在大标题模式下的标题字体，仅在 iOS 11 之后才有效
    QMUICMI.navBarBackButtonTitlePositionAdjustment = UIOffsetZero;             // NavBarBarBackButtonTitlePositionAdjustment : 导航栏返回按钮的文字偏移
    QMUICMI.sizeNavBarBackIndicatorImageAutomatically = YES;                    // SizeNavBarBackIndicatorImageAutomatically : 是否要自动调整 NavBarBackIndicatorImage 的 size 为 (13, 21)
    QMUICMI.navBarBackIndicatorImage = [UIImage qmui_imageWithShape:QMUIImageShapeNavBack size:CGSizeMake(12, 20) tintColor:NavBarTintColor];                                     // NavBarBackIndicatorImage : 导航栏的返回按钮的图片，图片尺寸建议为(13, 21)，否则最终的图片位置无法与系统原生的位置保持一致
    QMUICMI.navBarCloseButtonImage = [UIImage qmui_imageWithShape:QMUIImageShapeNavClose size:CGSizeMake(16, 16) tintColor:NavBarTintColor];     // NavBarCloseButtonImage : QMUINavigationButton 用到的 × 的按钮图片
    
    QMUICMI.navBarLoadingMarginRight = 3;                                       // NavBarLoadingMarginRight : QMUINavigationTitleView 里左边 loading 的右边距
    QMUICMI.navBarAccessoryViewMarginLeft = 5;                                  // NavBarAccessoryViewMarginLeft : QMUINavigationTitleView 里右边 accessoryView 的左边距
    QMUICMI.navBarActivityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;// NavBarActivityIndicatorViewStyle : QMUINavigationTitleView 里左边 loading 的主题
    QMUICMI.navBarAccessoryViewTypeDisclosureIndicatorImage = [[UIImage qmui_imageWithShape:QMUIImageShapeTriangle size:CGSizeMake(8, 5) tintColor:nil] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];     // NavBarAccessoryViewTypeDisclosureIndicatorImage : QMUINavigationTitleView 右边箭头的图片
    
#pragma mark - TabBar
    
    QMUICMI.tabBarBackgroundImage = [[UIImage qmui_imageWithColor:UIColorMake(249, 249, 249)] resizableImageWithCapInsets:UIEdgeInsetsMake(1, 1, 1, 1)];   // TabBarBackgroundImage : UITabBar 的背景图，建议使用 resizableImage，否则在 UITabBar (NavigationController) 的 setBackgroundImage: 里会每次都视为 image 发生了变化（isEqual: 为 NO）
    QMUICMI.tabBarBarTintColor = nil;                                           // TabBarBarTintColor : UITabBar 的 barTintColor
    QMUICMI.tabBarShadowImageColor = UIColorSeparator;                          // TabBarShadowImageColor : UITabBar 的 shadowImage 的颜色，会自动创建一张 1px 高的图片
    QMUICMI.tabBarStyle = UIBarStyleDefault;                                    // TabBarStyle : UITabBar 的 barStyle
    QMUICMI.tabBarItemTitleFont = nil;                                          // TabBarItemTitleFont : UITabBarItem 的标题字体
    QMUICMI.tabBarItemTitleColor = UIColor.qd_descriptionTextColor;             // TabBarItemTitleColor : 未选中的 UITabBarItem 的标题颜色
    QMUICMI.tabBarItemTitleColorSelected = UIColor.qd_tintColor;                // TabBarItemTitleColorSelected : 选中的 UITabBarItem 的标题颜色
    QMUICMI.tabBarItemImageColor = TabBarItemTitleColor;                        // TabBarItemImageColor : UITabBarItem 未选中时的图片颜色
    QMUICMI.tabBarItemImageColorSelected = TabBarItemTitleColorSelected;        // TabBarItemImageColorSelected : UITabBarItem 选中时的图片颜色
    
#pragma mark - Toolbar
    
    QMUICMI.toolBarHighlightedAlpha = 0.4f;                                     // ToolBarHighlightedAlpha : QMUIToolbarButton 在 highlighted 状态下的 alpha
    QMUICMI.toolBarDisabledAlpha = 0.4f;                                        // ToolBarDisabledAlpha : QMUIToolbarButton 在 disabled 状态下的 alpha
    QMUICMI.toolBarTintColor = UIColor.qd_tintColor;                            // ToolBarTintColor : UIToolbar 的 tintColor，以及 QMUIToolbarButton normal 状态下的文字颜色
    QMUICMI.toolBarTintColorHighlighted = [ToolBarTintColor colorWithAlphaComponent:ToolBarHighlightedAlpha];   // ToolBarTintColorHighlighted : QMUIToolbarButton 在 highlighted 状态下的文字颜色
    QMUICMI.toolBarTintColorDisabled = [ToolBarTintColor colorWithAlphaComponent:ToolBarDisabledAlpha];         // ToolBarTintColorDisabled : QMUIToolbarButton 在 disabled 状态下的文字颜色
    QMUICMI.toolBarBackgroundImage = nil;                                       // ToolBarBackgroundImage : UIToolbar 的背景图
    QMUICMI.toolBarBarTintColor = nil;                                          // ToolBarBarTintColor : UIToolbar 的 tintColor
    QMUICMI.toolBarShadowImageColor = UIColorSeparator;                         // ToolBarShadowImageColor : UIToolbar 的 shadowImage 的颜色，会自动创建一张 1px 高的图片
    QMUICMI.toolBarStyle = UIBarStyleDefault;                                   // ToolBarStyle : UIToolbar 的 barStyle
    QMUICMI.toolBarButtonFont = UIFontMake(17);                                 // ToolBarButtonFont : QMUIToolbarButton 的字体
    
#pragma mark - SearchBar
    
    QMUICMI.searchBarTextFieldBackgroundImage = UIImage.qd_searchBarTextFieldBackgroundImage;       // SearchBarTextFieldBackgroundImage : QMUISearchBar 里的文本框的背景图，图片高度会决定输入框的高度
    QMUICMI.searchBarTextFieldBorderColor = nil;                                // SearchBarTextFieldBorderColor : QMUISearchBar 里的文本框的边框颜色
    QMUICMI.searchBarBackgroundImage = UIImage.qd_searchBarBackgroundImage;     // SearchBarBackgroundImage : 搜索框的背景图，如果需要设置底部分隔线的颜色也请绘制到图片里
    QMUICMI.searchBarTintColor = UIColor.qd_tintColor;                          // SearchBarTintColor : QMUISearchBar 的 tintColor，也即上面的操作控件的主题色
    QMUICMI.searchBarTextColor = UIColor.qd_titleTextColor;                                  // SearchBarTextColor : QMUISearchBar 里的文本框的文字颜色
    QMUICMI.searchBarPlaceholderColor = [UIColor qmui_colorWithThemeProvider:^UIColor * _Nonnull(__kindof QMUIThemeManager * _Nonnull manager, NSString * _Nullable identifier, NSObject<QDThemeProtocol> *theme) {
        if ([identifier isEqualToString:QDThemeIdentifierDark]) {
            return theme.themePlaceholderColor;
        }
        return UIColorMake(136, 136, 143);
    }];             // SearchBarPlaceholderColor : QMUISearchBar 里的文本框的 placeholder 颜色
    QMUICMI.searchBarFont = nil;                                                // SearchBarFont : QMUISearchBar 里的文本框的文字字体及 placeholder 的字体
    QMUICMI.searchBarSearchIconImage = nil;                                     // SearchBarSearchIconImage : QMUISearchBar 里的放大镜 icon
    QMUICMI.searchBarClearIconImage = nil;                                      // SearchBarClearIconImage : QMUISearchBar 里的文本框输入文字时右边的清空按钮的图片
    QMUICMI.searchBarTextFieldCornerRadius = 4.0;                               // SearchBarTextFieldCornerRadius : QMUISearchBar 里的文本框的圆角大小，-1 表示圆角大小为输入框高度的一半
    
#pragma mark - TableView / TableViewCell
    
    QMUICMI.tableViewEstimatedHeightEnabled = YES;                              // TableViewEstimatedHeightEnabled : 是否要开启全局 QMUITableView 和 UITableView 的 estimatedRow(Section/Footer)Height
    
    QMUICMI.tableViewBackgroundColor = UIColorForBackground;                    // TableViewBackgroundColor : Plain 类型的 QMUITableView 的背景色颜色
    QMUICMI.tableSectionIndexColor = UIColorGrayDarken;                         // TableSectionIndexColor : 列表右边的字母索引条的文字颜色
    QMUICMI.tableSectionIndexBackgroundColor = UIColorClear;                    // TableSectionIndexBackgroundColor : 列表右边的字母索引条的背景色
    QMUICMI.tableSectionIndexTrackingBackgroundColor = UIColorClear;            // TableSectionIndexTrackingBackgroundColor : 列表右边的字母索引条在选中时的背景色
    QMUICMI.tableViewSeparatorColor = UIColorSeparator;                         // TableViewSeparatorColor : 列表的分隔线颜色
    
    QMUICMI.tableViewCellNormalHeight = 56;                                     // TableViewCellNormalHeight : QMUITableView 的默认 cell 高度
    QMUICMI.tableViewCellTitleLabelColor = UIColor.qd_mainTextColor;             // TableViewCellTitleLabelColor : QMUITableViewCell 的 textLabel 的文字颜色
    QMUICMI.tableViewCellDetailLabelColor = UIColor.qd_descriptionTextColor;     // TableViewCellDetailLabelColor : QMUITableViewCell 的 detailTextLabel 的文字颜色
    QMUICMI.tableViewCellBackgroundColor = UIColorForBackground;                 // TableViewCellBackgroundColor : QMUITableViewCell 的背景色
    QMUICMI.tableViewCellSelectedBackgroundColor = UIColor.qd_backgroundColorHighlighted;  // TableViewCellSelectedBackgroundColor : QMUITableViewCell 点击时的背景色
    QMUICMI.tableViewCellWarningBackgroundColor = UIColorYellow;                // TableViewCellWarningBackgroundColor : QMUITableViewCell 用于表示警告时的背景色，备用
    QMUICMI.tableViewCellDisclosureIndicatorImage = [UIImage qmui_imageWithThemeProvider:^UIImage * _Nonnull(__kindof QMUIThemeManager * _Nonnull manager, NSString * _Nullable identifier, NSObject<QDThemeProtocol> * _Nullable theme) {
        return [identifier isEqualToString:QDThemeIdentifierDark] ? disclosureIndicatorImageDark : disclosureIndicatorImage;
    }];    // TableViewCellDisclosureIndicatorImage : QMUITableViewCell 当 accessoryType 为 UITableViewCellAccessoryDisclosureIndicator 时的箭头的图片
    QMUICMI.tableViewCellCheckmarkImage = [UIImage qmui_imageWithShape:QMUIImageShapeCheckmark size:CGSizeMake(15, 12) tintColor:UIColor.qd_tintColor];  // TableViewCellCheckmarkImage : QMUITableViewCell 当 accessoryType 为 UITableViewCellAccessoryCheckmark 时的打钩的图片
    QMUICMI.tableViewCellDetailButtonImage = [UIImage qmui_imageWithShape:QMUIImageShapeDetailButtonImage size:CGSizeMake(20, 20) tintColor:UIColor.qd_tintColor]; // TableViewCellDetailButtonImage : QMUITableViewCell 当 accessoryType 为 UITableViewCellAccessoryDetailButton 或 UITableViewCellAccessoryDetailDisclosureButton 时右边的 i 按钮图片
    QMUICMI.tableViewCellSpacingBetweenDetailButtonAndDisclosureIndicator = 12; // TableViewCellSpacingBetweenDetailButtonAndDisclosureIndicator : 列表 cell 右边的 i 按钮和向右箭头之间的间距（仅当两者都使用了自定义图片并且同时显示时才生效）
    
    QMUICMI.tableViewSectionHeaderBackgroundColor = UIColor.qd_separatorColor;                         // TableViewSectionHeaderBackgroundColor : Plain 类型的 QMUITableView sectionHeader 的背景色
    QMUICMI.tableViewSectionFooterBackgroundColor = UIColor.qd_separatorColor;                         // TableViewSectionFooterBackgroundColor : Plain 类型的 QMUITableView sectionFooter 的背景色
    QMUICMI.tableViewSectionHeaderFont = UIFontBoldMake(12);                                            // TableViewSectionHeaderFont : Plain 类型的 QMUITableView sectionHeader 里的文字字体
    QMUICMI.tableViewSectionFooterFont = UIFontBoldMake(12);                                            // TableViewSectionFooterFont : Plain 类型的 QMUITableView sectionFooter 里的文字字体
    QMUICMI.tableViewSectionHeaderTextColor = UIColorGray5;                                             // TableViewSectionHeaderTextColor : Plain 类型的 QMUITableView sectionHeader 里的文字颜色
    QMUICMI.tableViewSectionFooterTextColor = UIColorGray;                                              // TableViewSectionFooterTextColor : Plain 类型的 QMUITableView sectionFooter 里的文字颜色
    QMUICMI.tableViewSectionHeaderAccessoryMargins = UIEdgeInsetsMake(0, 15, 0, 0);                     // TableViewSectionHeaderAccessoryMargins : Plain 类型的 QMUITableView sectionHeader accessoryView 的间距
    QMUICMI.tableViewSectionFooterAccessoryMargins = UIEdgeInsetsMake(0, 15, 0, 0);                     // TableViewSectionFooterAccessoryMargins : Plain 类型的 QMUITableView sectionFooter accessoryView 的间距
    QMUICMI.tableViewSectionHeaderContentInset = UIEdgeInsetsMake(4, 15, 4, 15);                        // TableViewSectionHeaderContentInset : Plain 类型的 QMUITableView sectionHeader 里的内容的 padding
    QMUICMI.tableViewSectionFooterContentInset = UIEdgeInsetsMake(4, 15, 4, 15);                        // TableViewSectionFooterContentInset : Plain 类型的 QMUITableView sectionFooter 里的内容的 padding
    
    QMUICMI.tableViewGroupedBackgroundColor = [UIColor qmui_colorWithThemeProvider:^UIColor * _Nonnull(__kindof QMUIThemeManager * _Nonnull manager, NSString * _Nullable identifier, NSObject<QDThemeProtocol> * _Nullable theme) {
        if ([identifier isEqualToString:QDThemeIdentifierDark]) {
            return QMUICMI.tableViewBackgroundColor;
        }
        return UIColorMake(246, 246, 246);
    }];       // TableViewGroupedBackgroundColor : Grouped 类型的 QMUITableView 的背景色
    QMUICMI.tableViewGroupedCellTitleLabelColor = TableViewCellTitleLabelColor;                         // TableViewGroupedCellTitleLabelColor : Grouped 类型的 QMUITableView cell 里的标题颜色
    QMUICMI.tableViewGroupedCellDetailLabelColor = TableViewCellDetailLabelColor;                       // TableViewGroupedCellDetailLabelColor : Grouped 类型的 QMUITableView cell 里的副标题颜色
    QMUICMI.tableViewGroupedCellBackgroundColor = UIColor.qd_backgroundColorLighten;                         // TableViewGroupedCellBackgroundColor : Grouped 类型的 QMUITableView cell 背景色
    QMUICMI.tableViewGroupedCellSelectedBackgroundColor = TableViewCellSelectedBackgroundColor;         // TableViewGroupedCellSelectedBackgroundColor : Grouped 类型的 QMUITableView cell 点击时的背景色
    QMUICMI.tableViewGroupedCellWarningBackgroundColor = TableViewCellWarningBackgroundColor;           // tableViewGroupedCellWarningBackgroundColor : Grouped 类型的 QMUITableView cell 在提醒状态下的背景色
    QMUICMI.tableViewGroupedSectionHeaderFont = UIFontMake(12);                                         // TableViewGroupedSectionHeaderFont : Grouped 类型的 QMUITableView sectionHeader 里的文字字体
    QMUICMI.tableViewGroupedSectionFooterFont = UIFontMake(12);                                         // TableViewGroupedSectionFooterFont : Grouped 类型的 QMUITableView sectionFooter 里的文字字体
    QMUICMI.tableViewGroupedSectionHeaderTextColor = UIColorGrayDarken;                                 // TableViewGroupedSectionHeaderTextColor : Grouped 类型的 QMUITableView sectionHeader 里的文字颜色
    QMUICMI.tableViewGroupedSectionFooterTextColor = UIColorGray;                                       // TableViewGroupedSectionFooterTextColor : Grouped 类型的 QMUITableView sectionFooter 里的文字颜色
    QMUICMI.tableViewGroupedSectionHeaderAccessoryMargins = UIEdgeInsetsMake(0, 15, 0, 0);                     // TableViewGroupedSectionHeaderAccessoryMargins : Grouped 类型的 QMUITableView sectionHeader accessoryView 的间距
    QMUICMI.tableViewGroupedSectionFooterAccessoryMargins = UIEdgeInsetsMake(0, 15, 0, 0);                     // TableViewGroupedSectionFooterAccessoryMargins : Grouped 类型的 QMUITableView sectionFooter accessoryView 的间距
    QMUICMI.tableViewGroupedSectionHeaderDefaultHeight = UITableViewAutomaticDimension;                 // TableViewGroupedSectionHeaderDefaultHeight : Grouped 类型的 QMUITableView sectionHeader 的默认高度（也即没使用自定义的 sectionHeaderView 时的高度），注意如果不需要间距，请用 CGFLOAT_MIN
    QMUICMI.tableViewGroupedSectionFooterDefaultHeight = UITableViewAutomaticDimension;                 // TableViewGroupedSectionFooterDefaultHeight : Grouped 类型的 QMUITableView sectionFooter 的默认高度（也即没使用自定义的 sectionFooterView 时的高度），注意如果不需要间距，请用 CGFLOAT_MIN
    QMUICMI.tableViewGroupedSectionHeaderContentInset = UIEdgeInsetsMake(16, PreferredValueForiPhone(20, 15, 15, 15), 8, PreferredValueForiPhone(20, 15, 15, 15));    // TableViewGroupedSectionHeaderContentInset : Grouped 类型的 QMUITableView sectionHeader 里的内容的 padding
    QMUICMI.tableViewGroupedSectionFooterContentInset = UIEdgeInsetsMake(8, 15, 2, 15);                 // TableViewGroupedSectionFooterContentInset : Grouped 类型的 QMUITableView sectionFooter 里的内容的 padding
    
#pragma mark - UIWindowLevel
    QMUICMI.windowLevelQMUIAlertView = UIWindowLevelAlert - 4.0;                // UIWindowLevelQMUIAlertView : QMUIModalPresentationViewController、QMUIPopupContainerView 里使用的 UIWindow 的 windowLevel
    
#pragma mark - QMUILog
    QMUICMI.shouldPrintDefaultLog = YES;                                        // ShouldPrintDefaultLog : 是否允许输出 QMUILogLevelDefault 级别的 log
    QMUICMI.shouldPrintInfoLog = YES;                                           // ShouldPrintInfoLog : 是否允许输出 QMUILogLevelInfo 级别的 log
    QMUICMI.shouldPrintWarnLog = YES;                                           // ShouldPrintInfoLog : 是否允许输出 QMUILogLevelWarn 级别的 log
    
#pragma mark - QMUIBadge
    
    QMUICMI.badgeBackgroundColor = UIColorRed;                                  // BadgeBackgroundColor : UIBarButtoItem、UITabBarItem 上的未读数的背景色
    QMUICMI.badgeTextColor = UIColorWhite;                                      // BadgeTextColor : UIBarButtoItem、UITabBarItem 上的未读数的文字颜色
    QMUICMI.badgeFont = UIFontBoldMake(11);                                     // BadgeFont : UIBarButtoItem、UITabBarItem 上的未读数的字体
    QMUICMI.badgeContentEdgeInsets = UIEdgeInsetsMake(2, 4, 2, 4);              // BadgeContentEdgeInsets : UIBarButtoItem、UITabBarItem 上的未读数与圆圈之间的 padding
    QMUICMI.badgeCenterOffset = CGPointMake(14, -10);                           // BadgeCenterOffset : UIBarButtoItem、UITabBarItem 上的未读数相对于 item 中心的偏移
    QMUICMI.badgeCenterOffsetLandscape = CGPointMake(16, -7);                   // BadgeCenterOffsetLandscape : UIBarButtoItem、UITabBarItem 上的未读数在横屏下相对于 item 中心的偏移
    
    QMUICMI.updatesIndicatorColor = UIColorRed;                                 // UpdatesIndicatorColor : UIBarButtoItem、UITabBarItem 上的未读红点的颜色
    QMUICMI.updatesIndicatorSize = CGSizeMake(7, 7);                            // UpdatesIndicatorSize : UIBarButtoItem、UITabBarItem 上的未读红点的大小
    QMUICMI.updatesIndicatorCenterOffset = CGPointMake(14, -10);                // UpdatesIndicatorCenterOffset : UIBarButtoItem、UITabBarItem 上的未读红点相对于 item 中心的偏移
    QMUICMI.updatesIndicatorCenterOffsetLandscape = CGPointMake(14, -10);       // UpdatesIndicatorCenterOffsetLandscape : UIBarButtoItem、UITabBarItem 上的未读红点在横屏下相对于 item 中心的偏移
    
#pragma mark - Others
    
    QMUICMI.automaticCustomNavigationBarTransitionStyle = NO;                   // AutomaticCustomNavigationBarTransitionStyle : 界面 push/pop 时是否要自动根据两个界面的 barTintColor/backgroundImage/shadowImage 的样式差异来决定是否使用自定义的导航栏效果
    QMUICMI.supportedOrientationMask = UIInterfaceOrientationMaskAll;           // SupportedOrientationMask : 默认支持的横竖屏方向
    QMUICMI.automaticallyRotateDeviceOrientation = YES;                         // AutomaticallyRotateDeviceOrientation : 是否在界面切换或 viewController.supportedOrientationMask 发生变化时自动旋转屏幕
    QMUICMI.statusbarStyleLightInitially = YES;                                 // StatusbarStyleLightInitially : 默认的状态栏内容是否使用白色，默认为 NO，也即黑色
    QMUICMI.needsBackBarButtonItemTitle = NO;                                   // NeedsBackBarButtonItemTitle : 全局是否需要返回按钮的 title，不需要则只显示一个返回image
    QMUICMI.hidesBottomBarWhenPushedInitially = YES;                            // HidesBottomBarWhenPushedInitially : QMUICommonViewController.hidesBottomBarWhenPushed 的初始值，默认为 NO，以保持与系统默认值一致，但通常建议改为 YES，因为一般只有 tabBar 首页那几个界面要求为 NO
    QMUICMI.preventConcurrentNavigationControllerTransitions = YES;             // PreventConcurrentNavigationControllerTransitions : 自动保护 QMUINavigationController 在上一次 push/pop 尚未结束的时候就进行下一次 push/pop 的行为，避免产生 crash
    QMUICMI.navigationBarHiddenInitially = NO;                                  // NavigationBarHiddenInitially : QMUINavigationControllerDelegate preferredNavigationBarHidden 的初始值，默认为NO
    QMUICMI.shouldFixTabBarTransitionBugInIPhoneX = YES;                        // ShouldFixTabBarTransitionBugInIPhoneX : 是否需要自动修复 iOS 11 下，iPhone X 的设备在 push 界面时，tabBar 会瞬间往上跳的 bug
    QMUICMI.shouldFixTabBarButtonBugForAll = NO;                                // ShouldFixTabBarButtonBugForAll : 是否要对 iOS 12.1.1 及以后的版本也修复手势返回时 tabBarButton 布局错误的 bug(issue #410)，默认为 NO
    QMUICMI.shouldPrintQMUIWarnLogToConsole = YES;                              // ShouldPrintQMUIWarnLogToConsole : 是否在出现 QMUILogWarn 时自动把这些 log 以 QMUIConsole 的方式显示到设备屏幕上
    QMUICMI.sendAnalyticsToQMUITeam = YES;                                      // SendAnalyticsToQMUITeam : 是否允许在 DEBUG 模式下上报 Bundle Identifier 和 Display Name 给 QMUI 统计用
    QMUICMI.dynamicPreferredValueForIPad = NO;                                  // DynamicPreferredValueForIPad : 当 iPad 处于 Slide Over 或 Split View 分屏模式下，宏 `PreferredValueForXXX` 是否把 iPad 视为某种屏幕宽度近似的 iPhone 来取值。
    if (@available(iOS 13.0, *)) {
        QMUICMI.ignoreKVCAccessProhibited = NO;                                     // IgnoreKVCAccessProhibited : 是否全局忽略 iOS 13 对 KVC 访问 UIKit 私有属性的限制
        QMUICMI.adjustScrollIndicatorInsetsByContentInsetAdjustment = YES;          // AdjustScrollIndicatorInsetsByContentInsetAdjustment : 当将 UIScrollView.contentInsetAdjustmentBehavior 设为 UIScrollViewContentInsetAdjustmentNever 时，是否自动将 UIScrollView.automaticallyAdjustsScrollIndicatorInsets 设为 NO，以保证原本在 iOS 12 下的代码不用修改就能在 iOS 13 下正常控制滚动条的位置。
    }
}

// QMUI 2.3.0 版本里，配置表新增这个方法，返回 YES 表示在 App 启动时要自动应用这份配置表。仅当你的 App 里存在多份配置表时，才需要把除默认配置表之外的其他配置表的返回值改为 NO。
- (BOOL)shouldApplyTemplateAutomatically {
    [QMUIThemeManagerCenter.defaultThemeManager addThemeIdentifier:self.themeName theme:self];
    
    NSString *selectedThemeIdentifier = [[NSUserDefaults standardUserDefaults] stringForKey:QDSelectedThemeIdentifier];
    BOOL result = [selectedThemeIdentifier isEqualToString:self.themeName] || (!selectedThemeIdentifier && !QMUIThemeManagerCenter.defaultThemeManager.currentThemeIdentifier);
    if (result) {
        QMUIThemeManagerCenter.defaultThemeManager.currentTheme = self;
    }
    return result;
}

#pragma mark - <QDThemeProtocol>

- (UIColor *)themeBackgroundColor {
    return UIColorWhite;
}

- (UIColor *)themeBackgroundColorLighten {
    return self.themeBackgroundColor;
}

- (UIColor *)themeBackgroundColorHighlighted {
    return UIColorMake(238, 239, 241);
}

- (UIColor *)themeTintColor {
    return UIColorTheme6;
}

- (UIColor *)themeTitleTextColor {
    return UIColorGray1;
}

- (UIColor *)themeMainTextColor {
    return UIColorGray3;
}

- (UIColor *)themeDescriptionTextColor {
    return UIColorGray6;
}

- (UIColor *)themePlaceholderColor {
    return UIColorGray8;
}

- (UIColor *)themeCodeColor {
    return self.themeTintColor;
}

- (UIColor *)themeSeparatorColor {
    return UIColorMake(222, 224, 226);
}

- (UIColor *)themeGridItemTintColor {
    return self.themeTintColor;
}

- (NSString *)themeName {
    return QDThemeIdentifierDefault;
}

@end
