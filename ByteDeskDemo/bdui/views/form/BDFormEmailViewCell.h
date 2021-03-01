//
//  FBPhoneViewCell.h
//  feedback
//
//  Created by 萝卜丝 on 2017/2/18.
//  Copyright © 2017年 萝卜丝. All rights reserved.
//

//#import <UIKit/UIKit.h>
#import <QMUIKit/QMUIKit.h>

@protocol BDFormEmailViewCellDelegate <NSObject>

-(void)emailTextField:(NSString *)email;

@end

@interface BDFormEmailViewCell : UITableViewCell

@property(nonatomic, weak) id<BDFormEmailViewCellDelegate> delegate;

@end
