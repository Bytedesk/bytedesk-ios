//
//  KFSupportCategoryViewController.h
//  demo
//
//  Created by 宁金鹏 on 2019/5/30.
//  Copyright © 2019 KeFuDaShi. All rights reserved.
//

#import "QDCommonTableViewController.h"

NS_ASSUME_NONNULL_BEGIN

@class BDCategoryModel;

@interface KFSupportCategoryViewController : QDCommonTableViewController

- (void) initWithCategoryModel:(BDCategoryModel *)categoryModel;

@end

NS_ASSUME_NONNULL_END
