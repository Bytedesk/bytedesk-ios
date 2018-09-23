//
//  DetailViewController.h
//  demo
//
//  Created by 萝卜丝·Bytedesk.com on 2018/9/23.
//  Copyright © 2018年 萝卜丝·Bytedesk.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailViewController : UIViewController

@property (strong, nonatomic) NSDate *detailItem;
@property (weak, nonatomic) IBOutlet UILabel *detailDescriptionLabel;

@end

