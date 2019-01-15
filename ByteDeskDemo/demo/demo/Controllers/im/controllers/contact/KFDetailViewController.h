//
//  BDDetailViewController.h
//  bytedesk
//
//  Created by 萝卜丝 on 2018/11/30.
//  Copyright © 2018 萝卜丝. All rights reserved.
//

#import "QDCommonGroupListViewController.h"

@class BDGroupModel;
@class BDContactModel;

@interface KFDetailViewController : QDCommonGroupListViewController

- (void)initWithGroupModel:(BDGroupModel *)groupModel;

- (void)initWithContactModel:(BDContactModel *)contactModel;

@end
