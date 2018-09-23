//
//  DetailViewController.h
//  demo
//
//  Created by 宁金鹏 on 2018/9/23.
//  Copyright © 2018年 宁金鹏. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailViewController : UIViewController

@property (strong, nonatomic) NSDate *detailItem;
@property (weak, nonatomic) IBOutlet UILabel *detailDescriptionLabel;

@end

