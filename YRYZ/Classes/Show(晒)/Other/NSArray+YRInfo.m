//
//  NSArray+YRInfo.m
//  YRYZ
//
//  Created by Mrs_zhang on 16/8/31.
//  Copyright © 2016年 yryz. All rights reserved.
//

#import "NSArray+YRInfo.h"

@implementation NSArray (YRInfo)

- (id)objectAtIndexCheck:(NSUInteger)index
{
    if (index >= [self count]) {
        return nil;
    }
    
    id value = [self objectAtIndex:index];
    
    if (value == [NSNull null]) {
        return nil;
    }
    return value;
}
@end
