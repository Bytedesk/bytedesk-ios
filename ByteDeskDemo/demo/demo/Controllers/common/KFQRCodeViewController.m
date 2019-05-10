//
//  KFQRCodeViewController.m
//  demo
//
//  Created by 萝卜丝 on 2019/3/10.
//  Copyright © 2019 KeFuDaShi. All rights reserved.
//

#import "KFQRCodeViewController.h"
#import <CoreImage/CoreImage.h>

#import <bytedesk-core/bdcore.h>

@interface KFQRCodeViewController ()

@property(nonatomic, assign) NSInteger   mScreenWidth;
@property(nonatomic, strong) UIImageView *mQRCodeImageView;

@property(nonatomic, strong) NSString *mType;
@property(nonatomic, strong) NSString *mUid;
@property(nonatomic, strong) NSString *mGid;

@end

@implementation KFQRCodeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.titleView.title = @"生成二维码";
    //
    self.mScreenWidth = [UIScreen mainScreen].bounds.size.width;
    //
    self.mQRCodeImageView = [[UIImageView alloc] initWithFrame:CGRectMake((self.mScreenWidth - 200)/2, 200, 200, 200)];
    [self.view addSubview:self.mQRCodeImageView];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    [self creatCIQRCodeImage];
}

#pragma mark - 自定义方法

- (void)initWithUid:(NSString *)uid {
    self.mType = @"user";
    self.mUid = uid;
}

- (void)initWithGid:(NSString *)gid {
    self.mType = @"group";
    self.mGid = gid;
}


/**
 *  生成二维码
 */
- (void)creatCIQRCodeImage
{
    // 1.创建过滤器，这里的@"CIQRCodeGenerator"是固定的
    CIFilter *filter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    
    // 2.恢复默认设置
    [filter setDefaults];
    
    // 3. 给过滤器添加数据
    NSString *dataString = [BDUtils getQRCodeLogin];
    if ([self.mType isEqualToString:@"user"]) {
        dataString = [BDUtils getQRCodeUser:self.mUid];
    } else if ([self.mType isEqualToString:@"group"]) {
        dataString = [BDUtils getQRCodeGroup:self.mGid];
    }
    NSData *data = [dataString dataUsingEncoding:NSUTF8StringEncoding];
    // 注意，这里的value必须是NSData类型
    [filter setValue:data forKeyPath:@"inputMessage"];
    
    // 4. 生成二维码
    CIImage *outputImage = [filter outputImage];
    
    // 5. 显示二维码
    self.mQRCodeImageView.image = [self createNonInterpolatedUIImageFormCIImage:outputImage withSize:100];
}

/**
 *  根据CIImage生成指定大小的UIImage
 *
 *  @param image CIImage
 *  @param size  图片宽度
 *
 *  @return 生成的高清的UIImage
 */
- (UIImage *)createNonInterpolatedUIImageFormCIImage:(CIImage *)image withSize:(CGFloat)size
{
    CGRect extent = CGRectIntegral(image.extent);
    CGFloat scale = MIN(size/CGRectGetWidth(extent), size/CGRectGetHeight(extent));
    
    // 1. 创建bitmap
    size_t width = CGRectGetWidth(extent) * scale;
    size_t height = CGRectGetHeight(extent) * scale;
    CGColorSpaceRef cs = CGColorSpaceCreateDeviceGray();
    CGContextRef bitmapRef = CGBitmapContextCreate(nil, width, height, 8, 0, cs, (CGBitmapInfo)kCGImageAlphaNone);
    CIContext *context = [CIContext contextWithOptions:nil];
    CGImageRef bitmapImage = [context createCGImage:image fromRect:extent];
    CGContextSetInterpolationQuality(bitmapRef, kCGInterpolationNone);
    CGContextScaleCTM(bitmapRef, scale, scale);
    CGContextDrawImage(bitmapRef, extent, bitmapImage);
    
    // 2.保存bitmap图片
    CGImageRef scaledImage = CGBitmapContextCreateImage(bitmapRef);
    CGContextRelease(bitmapRef);
    CGImageRelease(bitmapImage);
    return [UIImage imageWithCGImage:scaledImage];
}


@end
