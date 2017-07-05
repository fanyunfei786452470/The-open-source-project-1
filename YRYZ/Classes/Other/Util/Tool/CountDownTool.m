//
//  CountDownTool.m
//  YRYZ
//
//  Created by 易超 on 16/7/12.
//  Copyright © 2016年 yryz. All rights reserved.
//

#import "CountDownTool.h"

@implementation CountDownTool

+(instancetype)shareCountDownTool{
    static CountDownTool *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[self alloc] init];
    });
    return manager;
}

-(void)startTime:(NSString*)str timer:(dispatch_source_t)timer sender:(UIButton *)sender{
    __block NSInteger timeout = [str integerValue]; //倒计时时间
    
    sender.backgroundColor = [UIColor grayColor];
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
    dispatch_source_set_timer(timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
    dispatch_source_set_event_handler(timer, ^{
        if(timeout < 0){ //倒计时结束，关闭
            dispatch_source_cancel(timer);
            dispatch_async(dispatch_get_main_queue(), ^{
//                sender.enabled = YES;
                sender.userInteractionEnabled = YES;
//                sender.backgroundColor = [UIColor themeColor];
                [sender setTitle:@"获取验证码" forState:UIControlStateNormal];
                [CountDownTool shareCountDownTool].timer = 0;
                sender.backgroundColor = [UIColor themeColor];
            });
        }else{
            NSString *strTime = [NSString stringWithFormat:@"%ld", (long)timeout];
            dispatch_async(dispatch_get_main_queue(), ^{
                [sender setTitle:[NSString stringWithFormat:@" %@s ",strTime] forState:UIControlStateNormal];
            });
            timeout--;
            [CountDownTool shareCountDownTool].timer = timeout;
            
//            if (timeout == 86) {
//                dispatch_source_cancel(timer);
//                dispatch_async(dispatch_get_main_queue(), ^{
//                    sender.enabled = YES;
//                    [sender setTitle:@"获取验证码" forState:UIControlStateNormal];
//                });
//               
//            }
        }
    });
    dispatch_resume(timer);
}


-(void)endTime:(dispatch_source_t)timer sender:(UIButton *)sender{

    dispatch_source_set_event_handler(timer, ^{
        
        dispatch_source_cancel(timer);
        dispatch_async(dispatch_get_main_queue(), ^{
            sender.enabled = YES;
            [sender setTitle:@"获取验证码" forState:UIControlStateNormal];
            sender.backgroundColor = [UIColor themeColor];
        });
      
    });
    dispatch_resume(timer);
}


@end
