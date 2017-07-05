//
//  YRYYCache.h
//  YRYZ
//
//  Created by weishibo on 16/8/9.
//  Copyright © 2016年 yryz. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YRYYCache : NSObject
@property(nonatomic, strong) YYCache           *yyCache;
+(YRYYCache *)share;
@end
