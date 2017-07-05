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
@synthesize friendArray = _friendArray;
@synthesize focusFriend = _focusFriend;
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

- (NSMutableArray *)friendArray{
    if (!_friendArray) {
        _friendArray = [[NSMutableArray alloc]initWithArray:(NSArray *)[self.yyCache objectForKey:@"myFriendModel"]];
        return _friendArray;
    }else{
        return _friendArray;
    }
}
- (NSMutableArray *)focusFriend{
    if (!_focusFriend) {
        _focusFriend = [[NSMutableArray alloc]initWithArray:(NSArray *)[self.yyCache objectForKey:@"myFocusOnModel"]];
        return _focusFriend;
    }else{
        return _focusFriend;
    }
}
-(void)setFriendArray:(NSMutableArray *)friendArray{
    [self.yyCache removeObjectForKey:@"myFriendModel"];
    [self.yyCache setObject:friendArray forKey:@"myFriendModel"];
}
- (void)setFocusFriend:(NSMutableArray *)focusFriend{
    [self.yyCache removeObjectForKey:@"myFocusOnModel"];
    [self.yyCache setObject:focusFriend forKey:@"myFocusOnModel"];
}

@end
