//
//  NSString+Alter.m
//  Rrz
//
//  Created by 易超 on 16/3/29.
//  Copyright © 2016年 rongzhongwang. All rights reserved.
//

#import "NSString+Alter.h"

@implementation NSString (Alter)

//隐藏电话号码
+(NSString *)stringWithHidePhoneNum:(NSString *)phoneNum{
    
    NSString *firstStr = [phoneNum substringToIndex:3];
    NSString *lastStr = [phoneNum substringFromIndex:phoneNum.length - 4];
    return [NSString stringWithFormat:@"%@****%@",firstStr,lastStr];
}

//隐藏身份证号
+(NSString *)stringWithHideIdCardNum:(NSString *)IdCardNum{
    
    NSString *lastStr = [IdCardNum substringFromIndex:IdCardNum.length - 4];
    return [NSString stringWithFormat:@"**** %@",lastStr];
}

//隐藏姓名
+(NSString *)stringWithHideName:(NSString *)name{
    NSInteger len = name.length - 1;
    NSString *lastStr = [name substringFromIndex:name.length - len];
    return [NSString stringWithFormat:@"* %@",lastStr];
}

-(NSString *)bankNumToNormalNum
{
    return [self stringByReplacingOccurrencesOfString:@" " withString:@""];
}

@end
