//
//  BDContactProfileViewController.h
//  bytedesk-ui
//
//  Created by 萝卜丝 on 2019/1/14.
//  Copyright © 2019 KeFuDaShi. All rights reserved.
//

//#import <UIKit/UIKit.h>
#import <QMUIKit/QMUIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol BDContactProfileViewControllerDelegate <NSObject>

-(void)clearMessages;

@end

@interface BDContactProfileViewController : QMUICommonTableViewController

@property (nonatomic, weak) id<BDContactProfileViewControllerDelegate> delegate;

- (void) initWithUid:(NSString *)uid;

@end

NS_ASSUME_NONNULL_END
