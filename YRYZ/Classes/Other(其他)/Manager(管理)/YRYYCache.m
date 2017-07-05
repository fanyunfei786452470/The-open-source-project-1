//
//  YRYYCache.m
//  YRYZ
//
//  Created by weishibo on 16/8/9.
//  Copyright © 2016年 yryz. All rights reserved.
//

#import "YRYYCache.h"

NSString * const YRHttpDataCache = @"YRHttpDataCache";

@interface YRYYCache ()



@end



@implementation YRYYCache
+(YRYYCache *)share{
    static YRYYCache *share = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        share = [[self alloc] init];
    });
    return share;
}


- (instancetype)init {
    self = [super init];
    if (self) {
        self.yyCache = [[YYCache alloc] initWithName:YRHttpDataCache];
        self.yyCache.memoryCache.shouldRemoveAllObjectsOnMemoryWarning = YES;
        self.yyCache.memoryCache.shouldRemoveAllObjectsWhenEnteringBackground = YES;
    }
    return self;
}



@end
