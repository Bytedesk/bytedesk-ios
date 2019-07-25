//
//  BDGroupMemberTableViewCell.h
//  bytedesk-ui
//
//  Created by 萝卜丝 on 2019/1/3.
//  Copyright © 2019 KeFuDaShi. All rights reserved.
//

#import <QMUIKit/QMUIKit.h>
#import <bytedesk-core/bdcore.h>

NS_ASSUME_NONNULL_BEGIN

@protocol BDGroupMemberTableViewCellDelegate <NSObject>

- (void)avatarClicked:(BDContactModel *)contactModel;
- (void)inviteClicked;

@end


@interface BDGroupMemberTableViewCell : QMUITableViewCell

- (void)initWithMembers:(NSMutableArray *)membersArray;

@property(nonatomic, assign) id<BDGroupMemberTableViewCellDelegate>  delegate;

@end

NS_ASSUME_NONNULL_END
