//
//  BDDetailViewController.m
//  bytedesk
//
//  Created by 萝卜丝 on 2018/11/30.
//  Copyright © 2018 萝卜丝. All rights reserved.
//

#import "KFDetailViewController.h"

#import <AFNetworking/UIImageView+AFNetworking.h>

#import <bytedesk-ui/bdui.h>
#import <bytedesk-core/bdcore.h>

@interface KFDetailViewController ()

@property(nonatomic, strong) NSString *mType;

@property(nonatomic, strong) BDGroupModel *mGroupModel;

@property(nonatomic, strong) BDContactModel *mContactModel;

@end

@implementation KFDetailViewController

- (instancetype)init {
    self = [super init];
    if (self) {
        //    self.view.qmui_shouldShowDebugColor = true;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)initWithGroupModel:(BDGroupModel *)groupModel {
    //
    self.mType = @"group";
    self.mGroupModel = groupModel;
    //
    self.title = @"群组详情";
}

- (void)initWithContactModel:(BDContactModel *)contactModel {
    //
    self.mType = @"contact";
    self.mContactModel = contactModel;
    //
    self.title = @"个人详情";
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    //
    NSString *identifier = @"cell";
    QMUITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    //
    if (!cell) {
        cell = [[QMUITableViewCell alloc] initForTableView:self.tableView withStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier];
    }
    //
    if (indexPath.section == 0) {
        
        if ([self.mType isEqualToString:@"group"]) {
            // 群组
            [cell.imageView setImageWithURL:[NSURL URLWithString:self.mGroupModel.avatar] placeholderImage:[UIImage imageNamed:@"admin_default_avatar"]];
            cell.textLabel.text = self.mGroupModel.nickname;
            cell.detailTextLabel.text = self.mGroupModel.mdescription;
        } else {
            // 联系人
            [cell.imageView setImageWithURL:[NSURL URLWithString:self.mContactModel.avatar] placeholderImage:[UIImage imageNamed:@"admin_default_avatar"]];
            cell.textLabel.text = self.mContactModel.nickname;
//            cell.detailTextLabel.text = self.mContactModel.mdescription;
        }
        // cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
    } else if (indexPath.section == 1) {
        
        NSString *cellIndentifier = @"exitcellIndentifier";
        cell = [tableView dequeueReusableCellWithIdentifier:cellIndentifier];
        
        // Configure the cell...
        if (cell == nil) {
            cell = [[QMUITableViewCell alloc] initForTableView:self.tableView withStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIndentifier];
        }
        
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.textLabel.text = NSLocalizedString(@"发起会话", nil);
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
    }
    //
    [cell updateCellAppearanceWithIndexPath:indexPath];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return TableViewCellNormalHeight + 20;
    }
    return TableViewCellNormalHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self.tableView qmui_clearsSelection];
    
    if (indexPath.section == 1) {
        //
        if ([self.mType isEqualToString:@"group"]) {
            // 群组会话
            [BDUIApis agentPushChat:self.navigationController withGroupModel:self.mGroupModel];
        } else {
            // 联系人会话
            [BDUIApis agentPushChat:self.navigationController withContactModel:self.mContactModel];
        }
        
    }
}

@end
