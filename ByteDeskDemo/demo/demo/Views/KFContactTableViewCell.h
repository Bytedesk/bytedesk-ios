//
//  KFRosterTableViewCell.h
//  kefu
//
//  Created by 萝卜丝 on 2018/11/28.
//  Copyright © 2018年 Bytedesk.com. All rights reserved.
//

#import <MGSwipeTableCell/MGSwipeTableCell.h>

#import <bytedesk-core/bdcore.h>

@interface KFContactTableViewCell : MGSwipeTableCell

- (void)initWithGroupModel:(BDGroupModel *)groupModel;

- (void)initWithContactModel:(BDContactModel *)contactModel;

- (void)initWithRelationModel:(BDContactModel *)contactModel;

- (NSString *)getType;

@end
