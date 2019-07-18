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

// 默认设置工作组wid
#define kDefaultWorkGroupWid @"201807171659201"
// 指定坐席uid
#define kDefaultAgentUid @"201808221551193"
// 设置有前置选择的工作组: dxz测试组
#define kPreWorkGroupWid @"201808101819291"
// 机器人测试组
#define kRobotWorkGroupWid @"201809061716221"

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
                       @"指定坐席Present:",
                       @"电商客服Push:",
                       @"电商客服Present:",
                       @"前置选择Push:",
                       @"前置选择Present:",
                       @"默认机器人Push:",
                       @"默认机器人Present:",];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 5;
}

- (nullable NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    //
    if (tableView == self.tableView) {
        //
        if (section == 0) {
            return @"工作组会话";
        } else if (section == 1) {
            return @"指定坐席会话";
        } else if (section == 2){
            return @"电商客服";
        } else if (section == 3) {
            return @"前置选择";
        } else if (section == 4) {
            return @"默认机器人";
        }
    }
    return @"";
}

- (nullable NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section {
    //
    if (tableView == self.tableView) {
        //
        if (section == 3) {
            return @"后台设置问卷选择";
        } else if (section == 4) {
            return @"后台设置默认机器人";
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
    } else if (indexPath.section == 1){
        cell.textLabel.text = [self.apisArray objectAtIndex:indexPath.row+2];
        cell.detailTextLabel.text = kDefaultAgentUid;
    } else if (indexPath.section == 2){
        cell.textLabel.text = [self.apisArray objectAtIndex:indexPath.row+4];
        cell.detailTextLabel.text = kDefaultAgentUid;
    } else if (indexPath.section == 3) {
        cell.textLabel.text = [self.apisArray objectAtIndex:indexPath.row+6];
        cell.detailTextLabel.text = kPreWorkGroupWid;
    } else if (indexPath.section == 4) {
        cell.textLabel.text = [self.apisArray objectAtIndex:indexPath.row+8];
        cell.detailTextLabel.text = kRobotWorkGroupWid;
    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSString *title = [self.apisArray objectAtIndex:indexPath.row];
    
    if (indexPath.section == 0) {
        //
        if (indexPath.row == 0) {
            // push工作组会话
            [BDUIApis pushWorkGroupChat:self.navigationController withWorkGroupWid:kDefaultWorkGroupWid withTitle:title];
        } else {
            // present工作组会话
            [BDUIApis presentWorkGroupChat:self.navigationController withWorkGroupWid:kDefaultWorkGroupWid withTitle:title];
        }
    } else if (indexPath.section == 1){
        //
        if (indexPath.row == 0) {
            // push指定坐席会话
            [BDUIApis pushAppointChat:self.navigationController withAgentUid:kDefaultAgentUid withTitle:title];
        } else {
            // present指定坐席会话
            [BDUIApis presentAppointChat:self.navigationController withAgentUid:kDefaultAgentUid withTitle:title];
        }
    } else if (indexPath.section == 2) {
        //
        if (indexPath.row == 0) {
            // 携带商品信息工作组会话
            NSDictionary *dict = [[NSDictionary alloc] initWithObjectsAndKeys:
                                  BD_MESSAGE_TYPE_COMMODITY, @"type",
                                  @"商品标题", @"title",
                                  @"商品详情", @"content",
                                  @"¥9.99", @"price",
                                  @"https://item.m.jd.com/product/12172344.html", @"url",
                                  @"https://m.360buyimg.com/mobilecms/s750x750_jfs/t4483/332/2284794111/122812/4bf353/58ed7f42Nf16d6b20.jpg!q80.dpg", @"imageUrl",
                                  nil];
            [BDUIApis pushWorkGroupChat:self.navigationController withWorkGroupWid:kDefaultWorkGroupWid withTitle:title withCustom:dict];
        } else {
            // 携带商品信息指定坐席
            NSDictionary *dict = [[NSDictionary alloc] initWithObjectsAndKeys:
                                  BD_MESSAGE_TYPE_COMMODITY, @"type",
                                  @"商品标题", @"title",
                                  @"商品详情", @"content",
                                  @"¥9.99", @"price",
                                  @"https://item.m.jd.com/product/12172344.html", @"url",
                                  @"https://m.360buyimg.com/mobilecms/s750x750_jfs/t4483/332/2284794111/122812/4bf353/58ed7f42Nf16d6b20.jpg!q80.dpg",
                                  @"imageUrl",
                                  nil];
            [BDUIApis pushAppointChat:self.navigationController withAgentUid:kDefaultAgentUid withTitle:title withCustom:dict];
        }
    } else if (indexPath.section == 3) {
        //
        if (indexPath.row == 0) {
            // push工作组会话
            [BDUIApis pushWorkGroupChat:self.navigationController withWorkGroupWid:kPreWorkGroupWid withTitle:title];
        } else {
            // present工作组会话
            [BDUIApis presentWorkGroupChat:self.navigationController withWorkGroupWid:kPreWorkGroupWid withTitle:title];
        }
    } else {
        //
        if (indexPath.row == 0) {
            // push工作组会话
            [BDUIApis pushWorkGroupChat:self.navigationController withWorkGroupWid:kRobotWorkGroupWid withTitle:title];
        } else {
            // present工作组会话
            [BDUIApis presentWorkGroupChat:self.navigationController withWorkGroupWid:kRobotWorkGroupWid withTitle:title];
        }
    }
    
}



@end







