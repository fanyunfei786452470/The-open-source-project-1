//
//  YRMyCacheModel.m
//  YRYZ
//
//  Created by Sean on 16/9/2.
//  Copyright © 2016年 yryz. All rights reserved.
//

#import "YRMyCacheModel.h"

@implementation YRMyCacheModel

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self == [super init]) {
        self.name = [aDecoder decodeObjectForKey:@"name"];
        self.imageName = [aDecoder decodeObjectForKey:@"imageName"];
        
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.name forKey:@"name"];
    [aCoder encodeObject:self.imageName forKey:@"imageName"];
}

@end
