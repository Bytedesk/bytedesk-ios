//
//  WBDocument.m
//  WBDocumentBrowserDemo
//
//  Created by Mr_Lucky on 2018/11/5.
//  Copyright © 2018 wenbo. All rights reserved.
//

#import "WBDocument.h"

@implementation WBDocument

/*  < 读取icloud数据调用，响应openWithCompletionHandler > */
- (BOOL)loadFromContents:(id)contents
                  ofType:(NSString *)typeName
                   error:(NSError * _Nullable __autoreleasing *)outError {
    self.data = contents;
    return YES;
}

/*  < 保存数据、修改数据到icloud，响应save > */
- (id)contentsForType:(NSString *)typeName error:(NSError * _Nullable __autoreleasing *)outError {
    if (!self.data) {
        self.data = [[NSData alloc]init];
    }
    return self.data;
}

@end
