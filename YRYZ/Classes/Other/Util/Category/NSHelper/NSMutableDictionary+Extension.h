//
//  NSMutableDictionary+Extension.h
//  YRYZ
//
//  Created by 21.5 on 16/9/28.
//  Copyright © 2016年 yryz. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSMutableDictionary (Extension)

- (NSMutableDictionary *)getDict:(NSDictionary *)dicttionary;

@end

@interface NSMutableArray (FilterElement)
/**
 *   过滤掉相同的元素
 *
 *   @return 返回一个数组
 */
- (NSMutableArray*)filterTheSameElement;



@end
