//
//  BDGroupProfileViewController.h
//  bytedesk-ui
//
//  Created by 萝卜丝 on 2018/12/11.
//  Copyright © 2018 KeFuDaShi. All rights reserved.
//

#import <QMUIKit/QMUIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol BDGroupProfileViewControllerDelegate <NSObject>

-(void)clearMessages;

@end

@interface BDGroupProfileViewController : QMUICommonTableViewController

@property (nonatomic, weak) id<BDGroupProfileViewControllerDelegate> delegate;

- (void)initWithGroupGid:(NSString *)gid;

@end

NS_ASSUME_NONNULL_END
