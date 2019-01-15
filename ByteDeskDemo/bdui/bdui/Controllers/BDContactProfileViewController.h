//
//  BDContactProfileViewController.h
//  bytedesk-ui
//
//  Created by 宁金鹏 on 2019/1/14.
//  Copyright © 2019 KeFuDaShi. All rights reserved.
//

//#import <UIKit/UIKit.h>
#import <QMUIKit/QMUIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class BDThreadModel;

@interface BDContactProfileViewController : QMUICommonTableViewController

- (void) initWithThreadModel:(BDThreadModel *)threadModel;

@end

NS_ASSUME_NONNULL_END
