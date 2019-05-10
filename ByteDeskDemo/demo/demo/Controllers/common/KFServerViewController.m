//
//  KFServerViewController.m
//  demo
//
//  Created by 萝卜丝 on 2019/3/28.
//  Copyright © 2019 KeFuDaShi. All rights reserved.
//

#import "KFServerViewController.h"
#import <bytedesk-core/bdcore.h>

@interface KFServerViewController ()

@end

@implementation KFServerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"自定义服务器";
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    // Dismiss the keyboard if user double taps on the background
    UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard:)];
    doubleTap.numberOfTapsRequired = 2;
    doubleTap.numberOfTouchesRequired = 1;
    [self.view addGestureRecognizer:doubleTap];
    
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    } else if (section == 1) {
        return 4;
    } else if (section == 2){
        return 4;
    }
    return 1;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return @"REST服务器,注意：以'/'结尾";
    } else if (section == 1) {
        return @"STUN/TURN for WebRTC";
    } else if (section == 2) {
        return @"消息服务器, 注意：地址没有http前缀";
    } else {
        return @"";
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    // Configure the cell...
    if (!cell){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    if (indexPath.section == 0) {
        
        cell.textLabel.text = @"地址";
        cell.detailTextLabel.text = [BDConfig getRestApiHost];
        
    } else if (indexPath.section == 1) {
        
        if (indexPath.row == 0) {
            
            cell.textLabel.text = @"STUN";
            cell.detailTextLabel.text = [BDConfig getWebRTCStunServer];
            
        } else if (indexPath.row == 1) {
            
            cell.textLabel.text = @"TURN";
            cell.detailTextLabel.text = [BDConfig getWebRTCTurnServer];
            
        } else if (indexPath.row == 2) {
            
            cell.textLabel.text = @"username";
            cell.detailTextLabel.text = [BDConfig getWebRTCTurnUsername];
            
        } else {
            
            cell.textLabel.text = @"password";
            cell.detailTextLabel.text = [BDConfig getWebRTCTurnPassword];
        }
        
    } else if (indexPath.section == 2) {
        
        if (indexPath.row == 0) {
            
            cell.textLabel.text = @"地址";
            cell.detailTextLabel.text = [BDConfig getMqttHost];
            
        } else if (indexPath.row == 1) {
            
            cell.textLabel.text = @"端口号";
            cell.detailTextLabel.text = [NSString stringWithFormat:@"%ld", (long)[BDConfig getMqttPort]];
            
        } else if (indexPath.row == 2) {
            
            cell.textLabel.text = @"用户名";
            cell.detailTextLabel.text = [BDConfig getMqttAuthUsername];
            
        } else {
            
            cell.textLabel.text = @"密码";
            cell.detailTextLabel.text = [BDConfig getMqttAuthPassword];
        }
        
    } else if (indexPath.section == 3) {
        
        cell.textLabel.text = @"恢复默认值";
    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 0) {
        
        // 修改为自己的服务器地址, 注意：地址以 http或https开头, '/'结尾
        //        [BDConfig setRestApiHost:@"https://api.bytedesk.com/"];
        
    } else if (indexPath.section == 1) {
        
        if (indexPath.row == 0) {
            
            //            修改为自己消息服务器地址, 注意：地址没有http前缀
            //            [BDConfig setMqttHost:@"mq.bytedesk.com"];
            
        } else if (indexPath.row == 1) {
            
            //            修改为自己消息服务器端口号
            //            [BDConfig setMqttPort:1883]
            
        } else if (indexPath.row == 2) {
            
            //            修改为自己消息服务器用户名
            //            [BDConfig setMqttAuthUsername:@"mqtt_ios"];
            
        } else {
            
            //            修改为自己消息服务器密码
            //            [BDConfig setMqttAuthPassword:@"mqtt_ios"];
        }
        
    } else if (indexPath.section == 2) {
        
        //        恢复默认值
        [BDConfig restoreDefault];
        
        [self.tableView reloadData];
    }
}

#pragma mark - 双击界面

-(void)dismissKeyboard:(id)sender {
    [self.view endEditing:YES];
}


@end
