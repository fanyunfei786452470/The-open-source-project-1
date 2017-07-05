//
//  NSObject+Time.h
//  YRYZ
//
//  Created by weishibo on 16/9/1.
//  Copyright © 2016年 yryz. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (Time)
//获取秒级
+(NSString*)getCurrentTimestamp;

//获取毫秒级
+(NSString*)getCurrentMsTimestamp;

/**通过时间戳计算时间差（几小时前、几天前）**/
//+(NSString *) compareCurrentTime:(NSString*)compareDate;

/**通过时间戳得出显示时间**/
+ (NSString *) getDateStringWithTimestamp:(NSString *)timestamp;
///**通过时间戳和格式得出显示时间**/
//+ (NSString *)getTimeFormatterWithString:(NSString*)time formatter:(NSString *)forrmatter;
/**现在平台使需要使用的时间规则**/
+ (NSString *)getTimeFormatterWithString:(NSString*)time;
//消息时间规则，不许更改
+ (NSString *)getMsgTimeFormatterWithString:(NSString*)time;
/**通过时间戳和格式显示时间**/
+ (NSString *) getStringWithTimestamp:(NSTimeInterval)timestamp formatter:(NSString*)formatter;
/**获取当前时间戳**/
-(NSString*)getCurrentTimestamp;
/**奖时间转化为时间戳**/
- (NSString *)timesTampWithTime:(NSString *)time;
/**将日期转化为字符串**/
-(NSString *)dateToDateString:(NSDate *)date;
@end
