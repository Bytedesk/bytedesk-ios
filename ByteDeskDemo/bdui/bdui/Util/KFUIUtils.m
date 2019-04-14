//
//  KFUIUtils.m
//  bytedesk-ui
//
//  Created by 宁金鹏 on 2019/4/11.
//  Copyright © 2019 KeFuDaShi. All rights reserved.
//

#import "KFUIUtils.h"

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

@end
