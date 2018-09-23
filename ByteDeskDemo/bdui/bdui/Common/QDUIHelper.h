//
//  QDUIHelper.h
//  qmuidemo
//
//  Created by ZhoonChen on 15/6/2.
//  Copyright (c) 2015年 QMUI Team. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <QMUIKit/QMUIKit.h>

@interface QDUIHelper : NSObject

+ (void)forceInterfaceOrientationPortrait;

@end


@interface QDUIHelper (QMUIMoreOperationAppearance)

+ (void)customMoreOperationAppearance;

@end


@interface QDUIHelper (QMUIAlertControllerAppearance)

+ (void)customAlertControllerAppearance;

@end


@interface QDUIHelper (QMUIEmotionView)

+ (void)customEmotionViewAppearance;
@end


@interface QDUIHelper (UITabBarItem)

+ (UITabBarItem *)tabBarItemWithTitle:(NSString *)title image:(UIImage *)image selectedImage:(UIImage *)selectedImage tag:(NSInteger)tag;

@end


@interface QDUIHelper (Button)

+ (QMUIButton *)generateDarkFilledButton;
+ (QMUIButton *)generateLightBorderedButton;

@end


@interface QDUIHelper (Emotion)

+ (NSArray<QMUIEmotion *> *)qmuiEmotions;
@end


@interface QDUIHelper (SavePhoto)

+ (void)showAlertWhenSavedPhotoFailureByPermissionDenied;

@end


@interface QDUIHelper (Calculate)

+ (NSString *)humanReadableFileSize:(long long)size;
    
@end


@interface QDUIHelper (Theme)

+ (UIImage *)navigationBarBackgroundImageWithThemeColor:(UIColor *)color;
@end


@interface NSString (Code)

- (void)enumerateCodeStringUsingBlock:(void (^)(NSString *codeString, NSRange codeRange))block;

@end

