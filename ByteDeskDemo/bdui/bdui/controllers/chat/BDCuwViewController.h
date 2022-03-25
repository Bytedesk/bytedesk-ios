//
//  BDChatCuwViewController.h
//  bytedesk-ui
//
//  Created by 宁金鹏 on 2020/9/22.
//  Copyright © 2020 KeFuDaShi. All rights reserved.
//

//#import <QMUIKit/QMUIKit.h>
#import <UIKit/UITableViewController.h>

NS_ASSUME_NONNULL_BEGIN

@protocol BDCuwViewControllerDelegate <NSObject>

-(void)cuwSelected:(NSDictionary *)dict;

@end

@interface BDCuwViewController : UITableViewController

@property (nonatomic, weak) id<BDCuwViewControllerDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
