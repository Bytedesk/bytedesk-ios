//
//  KFSCanViewController.m
//  demo
//
//  Created by 宁金鹏 on 2019/4/14.
//  Copyright © 2019 KeFuDaShi. All rights reserved.
//

#import "KFScanViewController.h"
#import "KFQRCodeViewController.h"

#import "SWQRCode.h"

#import <bytedesk-core/bdcore.h>

@interface KFScanViewController ()

@end

@implementation KFScanViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"二维码";
    
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    // Configure the cell...
    if (!cell){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    if (indexPath.row == 0) {
        
        cell.textLabel.text = @"个人二维码生成";
        cell.detailTextLabel.text = @"";
        
    } else if (indexPath.row == 1) {
        
        cell.textLabel.text = @"群二维码生成";
        cell.detailTextLabel.text = @"";
        
    } else if (indexPath.row == 2) {
        
        cell.textLabel.text = @"扫一扫";
    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.row == 0) {
        //
        KFQRCodeViewController *qrcodeViewController = [[KFQRCodeViewController alloc] initWithStyle:UITableViewStyleGrouped];
        [qrcodeViewController initWithUid:[BDSettings getUid]];
        [self.navigationController pushViewController:qrcodeViewController animated:YES];
    } else if (indexPath.row == 1) {
        //
        KFQRCodeViewController *qrcodeViewController = [[KFQRCodeViewController alloc] initWithStyle:UITableViewStyleGrouped];
        [qrcodeViewController initWithGid:@""];
        [self.navigationController pushViewController:qrcodeViewController animated:YES];
    } else if (indexPath.row == 2) {
 
        [self showScanController];
    }
}


/**
 扫描
 */
- (void)showScanController {
    SWQRCodeConfig *config = [[SWQRCodeConfig alloc]init];
    config.scannerType = SWScannerTypeBoth;
    
    SWQRCodeViewController *qrcodeVC = [[SWQRCodeViewController alloc]init];
    qrcodeVC.codeConfig = config;
    qrcodeVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:qrcodeVC animated:YES];
}

@end
