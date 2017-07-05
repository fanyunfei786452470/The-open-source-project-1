//
//  SUTRuntimeMethodHelper.m
//  YRYZ
//
//  Created by Sean on 16/10/12.
//  Copyright © 2016年 yryz. All rights reserved.
//

#import "SUTRuntimeMethodHelper.h"

@interface SUTRuntimeMethodHelper () {
    SUTRuntimeMethodHelper *_helper;
}

@end

@implementation SUTRuntimeMethodHelper

+ (instancetype)object {
    return [[self alloc] init];
}

- (instancetype)init {
    self = [super init];
    if (self != nil) {
        _helper = [[SUTRuntimeMethodHelper alloc] init];
    }
    
    return self;
}

- (void)test {
    [self performSelector:@selector(method2)];
}

- (id)forwardingTargetForSelector:(SEL)aSelector {
    
    NSLog(@"forwardingTargetForSelector");
    
    NSString *selectorString = NSStringFromSelector(aSelector);
    
    // 将消息转发给_helper来处理
    if ([selectorString isEqualToString:@"method2"]) {
        return _helper;
    }
    
    return [super forwardingTargetForSelector:aSelector];
}

- (void)method2 {
    NSLog(@"%@, %p", self, _cmd);
}


@end
