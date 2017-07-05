//
//  StatusModel.m
//  LWAsyncDisplayViewDemo
//
//  Created by 刘微 on 16/4/5.
//  Copyright © 2016年 WayneInc. All rights reserved.
//

#import "StatusModel.h"

@implementation StatusModel

@synthesize videoPic = _videoPic;

- (void)setVideoPic:(NSString *)videoPic{
 
    _videoPic = videoPic;
}


- (NSString *)type{
    NSString *type_;
    
    if (_videoPic == nil || [_videoPic isEqualToString:@""]) {
       type_ = @"image";
    }else{
       type_ = @"video";
    }

    return type_;
}

@end
