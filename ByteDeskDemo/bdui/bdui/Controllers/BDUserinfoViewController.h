//
//  KFDSUserinfoViewController.h
//  bdui
//
//  Created by 萝卜丝·Bytedesk.com on 2017/12/18.
//  Copyright © 2017年 Bytedesk.com. All rights reserved.
//

#import <QMUIKit/QMUIKit.h>

@class BDThreadModel;

@interface BDUserinfoViewController : QMUICommonTableViewController

- (void) initWithThreadModel:(BDThreadModel *)threadModel;

@end
