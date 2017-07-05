//
//  CountDownTool.h
//  YRYZ
//
//  Created by 易超 on 16/7/12.
//  Copyright © 2016年 yryz. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CountDownTool : NSObject

@property (nonatomic,assign) NSInteger timer;

+(instancetype)shareCountDownTool;
-(void)startTime:(NSString*)str timer:(dispatch_source_t)timer sender:(UIButton *)sender;

-(void)endTime:(dispatch_source_t)timer sender:(UIButton *)sender;




@end
