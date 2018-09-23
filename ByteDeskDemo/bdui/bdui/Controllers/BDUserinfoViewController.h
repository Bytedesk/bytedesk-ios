//
//  KFDSUserinfoViewController.h
//  bdui
//
//  Created by 宁金鹏 on 2017/12/18.
//  Copyright © 2017年 Bytedesk.com. All rights reserved.
//

#import <QMUIKit/QMUIKit.h>

@class BDThreadModel;

@interface BDUserinfoViewController : QMUICommonTableViewController

- (void) initWithThreadModel:(BDThreadModel *)threadModel;

@end
