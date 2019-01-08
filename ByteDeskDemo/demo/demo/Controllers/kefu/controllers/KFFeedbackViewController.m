//
//  KFFeedbackViewController.m
//  demo
//
//  Created by 宁金鹏 on 2018/12/30.
//  Copyright © 2018 KeFuDaShi. All rights reserved.
//

#import "KFFeedbackViewController.h"
#import "KFFormContentViewCell.h"
#import "KFFormImageViewCell.h"
#import "KFFormPhoneViewCell.h"
#import "KFFormSubmitViewCell.h"

@interface KFFeedbackViewController ()<KFFormContentViewCellDelegate, KFFormPhoneViewCellDelegate, KFFormSubmitViewCellDelegate>

@end

@implementation KFFeedbackViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // TODO: 待上线
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    self.tableView.separatorColor = [UIColor clearColor];
    
    //
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard:)];
    singleTap.numberOfTapsRequired = 1;
    singleTap.numberOfTouchesRequired = 1;
    [self.view addGestureRecognizer:singleTap];
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
    return 1;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    //
    if (section == 0) {
        return @"问题和意见";
    }
    else if (section == 1) {
        return @"";
    }
    else if (section == 2) {
        return @"联系电话";
    }
    
    return @"";
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    //
    if (indexPath.section == 0) {
        return 100;
    }
    else if (indexPath.section == 1) {
        return 100;
    }
    else if (indexPath.section == 2) {
        return 44;
    }
    return 40;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        NSString *identifier = @"identifierContent";
        KFFormContentViewCell *contentCell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!contentCell) {
            contentCell = [[KFFormContentViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier];
        }
        contentCell.delegate = self;
        return contentCell;
    }
    else if (indexPath.section == 1) {
        NSString *identifier = @"identifierImage";
        KFFormImageViewCell *imageViewCell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!imageViewCell) {
            imageViewCell = [[KFFormImageViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier];
        }
//        imageViewCell.delegate = self;
        return imageViewCell;
    }
    else if (indexPath.section == 2) {
        NSString *identifier = @"identifierPhone";
        KFFormPhoneViewCell *phoneCell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!phoneCell) {
            phoneCell = [[KFFormPhoneViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier];
        }
        phoneCell.delegate = self;
        return phoneCell;
    }
    
    NSString *identifier = @"identifierSubmit";
    KFFormSubmitViewCell *submitCell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!submitCell) {
        submitCell = [[KFFormSubmitViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier];
    }
    submitCell.delegate = self;
    
    return submitCell;
}


#pragma mark - TouchGestures

-(void)dismissKeyboard:(id)sender {
    [self.view endEditing:YES];
}


#pragma mark - FBContentViewCellDelegate

-(void)contentTextView:(NSString *)content {
    NSLog(@"%s, %@", __PRETTY_FUNCTION__, content);
    
}

#pragma mark - FBFormPhoneViewCellDelegate

-(void)phoneTextField:(NSString *)phone {
    NSLog(@"%s, %@", __PRETTY_FUNCTION__, phone);
    
}

@end
