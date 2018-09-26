//
//  KFVisitorChatViewController.m
//  demo
//
//  Created by 宁金鹏 on 2017/11/22.
//  Copyright © 2017年 Bytedesk.com. All rights reserved.
//

#import "KFVisitorChatViewController.h"
#import <bytedesk-core/bdcore.h>
#import <bytedesk-ui/bdui.h>

#define kDefaultTitle @"人工客服"

#define kDefaultUid @"201808221551193"
#define kDefaultWid @"201807171659201"

@interface KFVisitorChatViewController ()

@property(nonatomic, strong) NSArray *apisArray;

@end

@implementation KFVisitorChatViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //
    self.apisArray = @[@"Push弹窗",
                       @"Present弹窗"];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    // Configure the cell...
    if (!cell){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    [cell.textLabel setText:[self.apisArray objectAtIndex:indexPath.row]];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.row == 0) {
        //
        [BDUIApis visitorPushChat:self.navigationController uId:kDefaultUid wId:kDefaultWid withTitle:kDefaultTitle];
    } else {
        //
        [BDUIApis visitorPresentChat:self.navigationController uId:kDefaultUid wId:kDefaultWid withTitle:kDefaultTitle];
    }
}



@end







