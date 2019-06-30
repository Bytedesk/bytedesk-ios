//
//  KFUIUtils.m
//  bytedesk-ui
//
//  Created by 宁金鹏 on 2019/4/11.
//  Copyright © 2019 KeFuDaShi. All rights reserved.
//

#import "KFUIUtils.h"
#import "KFCoreTextView.h"

#define CONTENT_TOP_MARGIN        2.0f
#define CONTENT_LEFT_MARGIN       15.0f
#define CONTENT_BOTTOM_MARGIN     30.0f
#define CONTENT_RIGHT_MARGIN      20.0f

@implementation KFUIUtils

+ (NSArray *)documentTypes {
    
    return @[@"public.content",
           @"public.text",
//           @"public.source-code",
//           @"public.image",
//           @"public.audiovisual-content",
           @"com.adobe.pdf",
           @"com.apple.keynote.key",
           @"com.microsoft.word.doc",
           @"com.microsoft.excel.xls",
           @"com.microsoft.powerpoint.ppt"
//           @"public.rtf",
//           @"public.html"
             ];
}

+ (CGSize)sizeOfRobotContent:(NSString *)msgContent
{
    
    CGSize size = [msgContent boundingRectWithSize:CGSizeMake(200, FLT_MAX)
                                           options:NSStringDrawingUsesLineFragmentOrigin
                                        attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14.0f]}
                                           context:nil].size;
    
    KFCoreTextView *kfCoreTextView = [[KFCoreTextView alloc] init];
    kfCoreTextView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [kfCoreTextView setText:msgContent];
    
    CGRect frame = CGRectMake(CONTENT_LEFT_MARGIN + 5,
                              CONTENT_TOP_MARGIN + 8,
                              size.width,
                              size.height + 17);
    kfCoreTextView.autoresizingMask = UIViewAutoresizingFlexibleRightMargin;
    kfCoreTextView.frame = frame;
    [kfCoreTextView fitToSuggestedHeight];
    
    return kfCoreTextView.frame.size;
}

@end
