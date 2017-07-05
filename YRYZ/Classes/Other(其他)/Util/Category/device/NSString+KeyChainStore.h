//
//  NSString+KeyChainStore.h
//  Rrz
//
//  Created by weishibo on 16/4/16.
//  Copyright © 2016年 rongzhongwang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (KeyChainStore)
+ (void)save:(NSString *)service data:(id)data;

+ (id)load:(NSString *)service;

+ (void)deleteKeyData:(NSString *)service;
@end
