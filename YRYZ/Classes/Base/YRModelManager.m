//
//  YRModelManager.m
//  YRYZ
//
//  Created by Sean on 16/10/12.
//  Copyright © 2016年 yryz. All rights reserved.
//

#import "YRModelManager.h"

@implementation YRModelManager
+(YRModelManager *)manager{
    static YRModelManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[self alloc] init];
    });
    return manager;
}
@end
