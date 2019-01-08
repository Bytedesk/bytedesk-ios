//
//  BDGroupMemberTableViewCell.m
//  bytedesk-ui
//
//  Created by 宁金鹏 on 2019/1/3.
//  Copyright © 2019 KeFuDaShi. All rights reserved.
//

#import "BDGroupMemberTableViewCell.h"
#import <bytedesk-core/bdcore.h>

@import AFNetworking;

#define LBScreen [UIScreen mainScreen].bounds.size

@interface BDGroupMemberTableViewCell ()

@property(nonatomic, strong) QMUIGridView *gridView;

@property(nonatomic, strong) NSMutableArray *mMembersArray;

@end

@implementation BDGroupMemberTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        //
        [self setupSubviews];
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)initWithMembers:(NSMutableArray *)membersArray {
    //
    self.mMembersArray = membersArray;
    //
    for (NSUInteger i = 0; i < [membersArray count]; i++) {
        BDContactModel *contactModel = [membersArray objectAtIndex:i];
        DDLogInfo(@"realName: %@", contactModel.nickname);
        //
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 25, 25)];
        [imageView setImageWithURL:[NSURL URLWithString:contactModel.avatar] placeholderImage:[UIImage imageNamed:@"avatar"]];
        //
        QMUILabel *label = [[QMUILabel alloc] initWithFrame:CGRectMake(0, 25, 25, 20)];
        [label setText:contactModel.nickname];
        //
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
        [view addSubview:imageView];
        [view addSubview:label];
        //
        [self.gridView addSubview:view];
    }
    
    CGFloat height = ([self.mMembersArray count]/5 + 1) * 60;
    [self.gridView setRowHeight:height];
}


- (void)setupSubviews {
    
    self.gridView = [[QMUIGridView alloc] initWithFrame:CGRectMake(0, 0, LBScreen.width, 100)];
    self.gridView.columnCount = 5;
    self.gridView.rowHeight = 60;
    self.gridView.separatorWidth = PixelOne;
    self.gridView.separatorColor = UIColorSeparator;
    self.gridView.separatorDashed = NO;
    [self.contentView addSubview:self.gridView];
    
}



@end
