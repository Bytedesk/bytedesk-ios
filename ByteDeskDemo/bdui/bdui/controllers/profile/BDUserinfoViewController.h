//
//  KFDSUserinfoViewController.h
//  bdui
//
//  Created by 萝卜丝 on 2018/12/18.
//  Copyright © 2018年 Bytedesk.com. All rights reserved.
//

#import <QMUIKit/QMUIKit.h>

@class BDThreadModel;

@interface BDUserinfoViewController : QMUICommonTableViewController

- (void) initWithThreadModel:(BDThreadModel *)threadModel;

@end
