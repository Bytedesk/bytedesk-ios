//
//  BDGroupMemberTableViewCell.h
//  bytedesk-ui
//
//  Created by 宁金鹏 on 2019/1/3.
//  Copyright © 2019 KeFuDaShi. All rights reserved.
//

#import <QMUIKit/QMUIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface BDGroupMemberTableViewCell : QMUITableViewCell

- (void)initWithMembers:(NSMutableArray *)membersArray;

@end

NS_ASSUME_NONNULL_END
