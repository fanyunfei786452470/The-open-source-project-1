//
//  NSString+Alter.h
//  Rrz
//
//  Created by 易超 on 16/3/29.
//  Copyright © 2016年 rongzhongwang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Alter)
/**
 *  @author yichao, 16-05-16 10:05:55
 *
 *  隐藏手机号
 *
 *  @param phoneNum <#phoneNum description#>
 *
 *  @return <#return value description#>
 */
+(NSString *)stringWithHidePhoneNum:(NSString *)phoneNum;

/**
 *  @author yichao, 16-05-16 10:05:10
 *
 *  隐藏身份证号
 *
 *  @param bankNumToNormalNum <#bankNumToNormalNum description#>
 *
 *  @return <#return value description#>
 */
+(NSString *)stringWithHideIdCardNum:(NSString *)IdCardNum;

/**
 *  @author yichao, 16-05-16 10:05:28
 *
 *  隐藏姓名
 *
 *  @param name <#name description#>
 *
 *  @return <#return value description#>
 */
+(NSString *)stringWithHideName:(NSString *)name;

-(NSString *)bankNumToNormalNum;

@end
