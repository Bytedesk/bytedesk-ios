//
//  BDLeaveMessageViewController.h
//  bytedesk-ui
//
//  Created by 萝卜丝 on 2019/4/8.
//  Copyright © 2019 KeFuDaShi. All rights reserved.
//

#import <QMUIKit/QMUIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface BDLeaveMessageViewController : QMUICommonTableViewController

- (void)initWithType:(NSString *)type workGroupWid:(NSString *)wid agentUid:(NSString *)uid;

@end

NS_ASSUME_NONNULL_END
