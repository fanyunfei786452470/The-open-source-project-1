//
//  NSString+URL.h
//  Rrz
//
//  Created by 易超 on 16/4/21.
//  Copyright © 2016年 rongzhongwang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (URL)


/**
 *  @author yichao, 16-04-21 11:04:39
 *
 *  从URL中获取参数
 *
 *  @param CS         参数名称
 *  @param webaddress URL
 *
 *  @return 参数
 */
-(NSString *) jiexi:(NSString *)CS webaddress:(NSString *)webaddress;

@end
