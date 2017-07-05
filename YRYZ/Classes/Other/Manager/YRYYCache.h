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
/** 我的好友数组 **/
@property (nonatomic,strong) NSMutableArray *friendArray;
 /** 我关注的数组 **/
@property (nonatomic,strong) NSMutableArray *focusFriend;

- (void)setFocusFriend:(NSMutableArray *)focusFriend;
- (NSMutableArray *)focusFriend;

-(void)setFriendArray:(NSMutableArray *)friendArray;
- (NSMutableArray *)friendArray;
+(YRYYCache *)share;
@end
