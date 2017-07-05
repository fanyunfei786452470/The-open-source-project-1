//
//  NSObject+Time.m
//  YRYZ
//
//  Created by weishibo on 16/9/1.
//  Copyright © 2016年 yryz. All rights reserved.
//

#import "NSObject+Time.h"

@implementation NSObject (Time)
//获取秒级当前时间戳
+(NSString*)getCurrentTimestamp{
    
    NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
    
    NSTimeInterval a=[dat timeIntervalSince1970];
    
    NSString *timeString = [NSString stringWithFormat:@"%0.f", a];//转为字符型
    
    return timeString;
    
}
//获取毫秒级当前时间戳
+(NSString*)getCurrentMsTimestamp{
    
    NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
    
    NSTimeInterval a=[dat timeIntervalSince1970] *1000;
    
    NSString *timeString = [NSString stringWithFormat:@"%0.f", a];//转为字符型
    
    return timeString;

}

//+(NSString *) compareCurrentTime:(NSString*)compareDate
//{
//    
//    NSDate *confromTimesp        = [NSDate dateWithTimeIntervalSince1970:[compareDate doubleValue]/1000];
//    
//    NSTimeInterval  timeInterval = [confromTimesp timeIntervalSinceNow];
//    timeInterval = -timeInterval;
//    long temp = 0;
//    NSString *result;
//    
////    NSCalendar *calendar     = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
////    NSInteger unitFlags      = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitWeekday |
////    NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
////    NSDateComponents*referenceComponents=[calendar components:unitFlags fromDate:confromTimesp];
//    //    NSInteger referenceYear  =referenceComponents.year;
//    //    NSInteger referenceMonth =referenceComponents.month;
//    //    NSInteger referenceDay   =referenceComponents.day;
////    NSInteger referenceHour  =referenceComponents.hour;
//    //    NSInteger referemceMinute=referenceComponents.minute;
//    
//    if (timeInterval < 60) {
//        result = [NSString stringWithFormat:@"刚刚"];
//    }
//    else if((temp= timeInterval/60) < 60){
//        result = [NSString stringWithFormat:@"%ld分钟前",temp];
//    }
//    
//    else if((temp = timeInterval/3600) <24){
//        result = [NSString stringWithFormat:@"%ld小时前",temp];
//    }
//    else if ((temp = timeInterval/3600/24)==1)
//    {
////        result = [NSString stringWithFormat:@"昨天%ld时",(long)referenceHour];
//        result = [NSString stringWithFormat:@"昨天"];
//
//    }
//    else if ((temp = timeInterval/3600/24)==2)
//    {
////        result = [NSString stringWithFormat:@"前天%ld时",(long)referenceHour];
//        result = [NSString stringWithFormat:@"前天"];
//
//    }
//    
//    else if((temp = timeInterval/3600/24) <31){
//        result = [NSString stringWithFormat:@"%ld天前",temp];
//    }
//    
//    else if((temp = timeInterval/3600/24/30) <12){
//        result = [NSString stringWithFormat:@"%ld个月前",temp];
//    }
//    else{
//        temp = temp/12;
//        result = [NSString stringWithFormat:@"%ld年前",temp];
//    }
//    
//    return  result;
//}
//通过时间戳得出显示时间
+ (NSString*) getDateStringWithTimestamp:(NSString *)timestamp
{
    NSDate *confromTimesp    = [NSDate dateWithTimeIntervalSince1970:[timestamp doubleValue]/1000];
    NSCalendar *calendar     = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSInteger unitFlags      = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitWeekday |
    NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    NSDateComponents*referenceComponents=[calendar components:unitFlags fromDate:confromTimesp];
    NSInteger referenceYear  =referenceComponents.year;
    NSInteger referenceMonth =referenceComponents.month;
    NSInteger referenceDay   =referenceComponents.day;
    
    return [NSString stringWithFormat:@"%ld-%02ld-%02ld",referenceYear,(long)referenceMonth,(long)referenceDay];
}
//通过时间戳和格式显示时间
+ (NSString*) getStringWithTimestamp:(NSTimeInterval)timestamp formatter:(NSString*)formatter
{
    if ([NSString stringWithFormat:@"%@", @(timestamp)].length == 13) {
        timestamp /= 1000.0f;
    }
    NSDate*timestampDate=[NSDate dateWithTimeIntervalSince1970:timestamp];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:formatter];
    NSString *strDate = [dateFormatter stringFromDate:timestampDate];
    return strDate;
}
+ (NSString *)getTimeFormatterWithString:(NSString*)time{
    NSString *formatterString;
    NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
    NSInteger a=[dat timeIntervalSince1970]*1000;
    NSString *modelDay = [NSString getStringWithTimestamp:[time integerValue] formatter:@"yyyy-MM-dd"];
    NSString *today = [NSString getStringWithTimestamp:a formatter:@"yyyy-MM-dd"];
    NSString *modelYear = [modelDay substringToIndex:4];
    NSString *todayYear = [modelDay substringToIndex:4];
    if ([modelDay isEqualToString:today]) {
        formatterString = [NSString getStringWithTimestamp:[time integerValue] formatter:@"HH:mm"];
    }
    else if ([modelYear isEqualToString:todayYear]){
        formatterString = [NSString getStringWithTimestamp:[time floatValue] formatter:@"MM-dd HH:mm"];
    }
    else{

        formatterString = [NSString getStringWithTimestamp:[time floatValue] formatter:@"yyyy-MM-dd"];
    }
    return formatterString;
}

+ (NSString *)getMsgTimeFormatterWithString:(NSString*)time{
    NSString *formatterString;
    NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
    NSInteger a=[dat timeIntervalSince1970]*1000;
    NSString *modelDay = [NSString getStringWithTimestamp:[time integerValue] formatter:@"yyyy-MM-dd"];
    NSString *today = [NSString getStringWithTimestamp:a formatter:@"yyyy-MM-dd"];
    if ([modelDay isEqualToString:today]) {
        formatterString = [NSString getStringWithTimestamp:[time integerValue] formatter:@"HH:mm"];
    }else{
     formatterString = [NSString getStringWithTimestamp:[time floatValue] formatter:@"MM-dd"];
    }
    return formatterString;
}

#pragma mark - 获取当前时间戳

-(NSString*)getCurrentTimestamp{
    
    NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
    
    NSTimeInterval a=[dat timeIntervalSince1970];
    
    NSString*timeString = [NSString stringWithFormat:@"%0.f", a];//转为字符型
    
    return timeString;
    
}
#pragma mark - 将时间转化为时间戳
- (NSString *)timesTampWithTime:(NSString *)time{
    
    NSDateFormatter* collectFormatter = [[NSDateFormatter alloc]init];
    [collectFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *collecDate = [collectFormatter dateFromString:time];
    
    NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[collecDate timeIntervalSince1970]];
    
    return timeSp;
}

//+ (NSString *)getTimeFormatterWithString:(NSString*)time formatter:(NSString *)forrmatter{
//    NSString *formatterString;
//    NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
//    NSInteger a=[dat timeIntervalSince1970]*1000;
// 
//    formatterString = [NSString getStringWithTimestamp:[time floatValue] formatter:@"yyyy-MM-dd HH:mm:ss"];
// 
//    return formatterString;
//}






#pragma mark - 日期转化为字符串
-(NSString *)dateToDateString:(NSDate *)date{
    //实例化一个NSDateFormatter对象
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    //设定时间格式,这里可以设置成自己需要的格式
    
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    
    //设置GMT市区，保证转化后日期字符串与日期一致
    
    NSTimeZone *timezone = [[NSTimeZone alloc] initWithName:@"GMT"];
    
    [dateFormatter setTimeZone:timezone];
    
    NSString *dateString = [dateFormatter stringFromDate:date];
    
    return dateString;
    
}
@end
