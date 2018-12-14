//
//  BDDetailViewController.h
//  bytedesk
//
//  Created by 宁金鹏 on 2018/11/30.
//  Copyright © 2018 宁金鹏. All rights reserved.
//

#import "QDCommonGroupListViewController.h"

@class BDGroupModel;
@class BDContactModel;

@interface BDDetailViewController : QDCommonGroupListViewController

- (void)initWithGroupModel:(BDGroupModel *)groupModel;

- (void)initWithContactModel:(BDContactModel *)contactModel;

@end
