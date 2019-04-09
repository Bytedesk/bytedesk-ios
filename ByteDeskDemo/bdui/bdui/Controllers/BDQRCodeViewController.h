//
//  BDQRCodeViewController.h
//  bytedesk-ui
//
//  Created by 萝卜丝 on 2019/3/10.
//  Copyright © 2019 KeFuDaShi. All rights reserved.
//

#import <QMUIKit/QMUIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface BDQRCodeViewController : QMUICommonTableViewController

- (void)initWithUid:(NSString *)uid;

- (void)initWithGid:(NSString *)gid;

@end

NS_ASSUME_NONNULL_END
