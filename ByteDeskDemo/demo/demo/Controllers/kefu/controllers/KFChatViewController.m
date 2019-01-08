//
//  KFVisitorChatViewController.m
//  demo
//
//  Created by 萝卜丝 on 2018/11/22.
//  Copyright © 2018年 Bytedesk.com. All rights reserved.
//

#import "KFChatViewController.h"
#import <bytedesk-core/bdcore.h>
#import <bytedesk-ui/bdui.h>

#define kDefaultTitle @"人工客服"

#define kDefaultWorkGroupWid @"201807171659201"
#define kDefaultAgentUid @"201808221551193"


@interface KFChatViewController ()

@property(nonatomic, strong) NSArray *apisArray;

@end

@implementation KFChatViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //
    self.apisArray = @[@"工作组会话Push:",
                       @"工作组会话Present:",
                       @"指定坐席Push:",
                       @"指定坐席Present:"];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (nullable NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    //
    if (tableView == self.tableView) {
        //
        if (section == 0) {
            // 群组
            return @"工作组会话";
        } else {
            // 联系人
            return @"指定坐席会话";
        }
    }
    return @"";
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    // Configure the cell...
    if (!cell){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    //
    if (indexPath.section == 0) {
        cell.textLabel.text = [self.apisArray objectAtIndex:indexPath.row];
        cell.detailTextLabel.text = kDefaultWorkGroupWid;
    } else {
        cell.textLabel.text = [self.apisArray objectAtIndex:indexPath.row+2];
        cell.detailTextLabel.text = kDefaultAgentUid;
    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 0) {
        //
        if (indexPath.row == 0) {
            // push工作组会话
            [BDUIApis visitorPushWorkGroupChat:self.navigationController withWorkGroupWid:kDefaultWorkGroupWid withTitle:kDefaultTitle];
        } else {
            // present工作组会话
            [BDUIApis visitorPresentWorkGroupChat:self.navigationController withWorkGroupWid:kDefaultWorkGroupWid withTitle:kDefaultTitle];
        }
    } else {
        //
        if (indexPath.row == 0) {
            // push指定坐席会话
            [BDUIApis visitorPushAppointChat:self.navigationController withAgentUid:kDefaultAgentUid withTitle:kDefaultTitle];
        } else {
            // present指定坐席会话
            [BDUIApis visitorPresentAppointChat:self.navigationController withAgentUid:kDefaultAgentUid withTitle:kDefaultTitle];
        }
    }
    
}



@end







