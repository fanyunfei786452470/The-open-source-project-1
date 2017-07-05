//
//  NSMutableDictionary+Extension.m
//  YRYZ
//
//  Created by 21.5 on 16/9/28.
//  Copyright © 2016年 yryz. All rights reserved.
//

#import "NSMutableDictionary+Extension.h"

@implementation NSMutableDictionary (Extension)

- (NSMutableDictionary *)getDict:(NSDictionary *)dictionary{
    NSMutableDictionary * dict = [[NSMutableDictionary alloc]init];
    for (NSString * key in dictionary) {
        NSString * value = dictionary[key];
        if ([value isEqual:@"<null>"]) {
            [dict setObject:@"0" forKey:key];
        }else{
            [dict setObject:dictionary[key] forKey:key];
        }
    }
    
    return dict;
}
@end


@implementation NSMutableArray (FilterElement)
/**
 *   过滤掉相同的元素
 *
 *   @return 返回一个数组
 */
- (NSMutableArray*)filterTheSameElement
{
    NSMutableSet *set = [NSMutableSet set];
    for (NSObject *obj in self) {
        [set addObject:obj];
    }
    [self removeAllObjects];
    for (NSObject *obj in set) {
        [self addObject:obj];
    }
    return self;
}

@end
