//
//  "UIColor+Helper.h"
//  Rrz
//
//  Created by weishibo on 16/2/17.
//  Copyright © 2016年 rongzhongwang. All rights reserved.
//
#import "UIColor+Helper.h"

@implementation UIColor (Helper)

+ (UIColor *)colorWithR:(CGFloat)red g:(CGFloat)green b:(CGFloat)blue a:(CGFloat)alpha {
    return [UIColor colorWithRed:red/255.0f
                           green:green/255.0f
                            blue:blue/255.0f
                           alpha:alpha];
}

+ (UIColor *)colorWithW:(CGFloat)white a:(CGFloat)alpha {
    return [UIColor colorWithWhite:white/255.0f alpha:alpha];
}

+ (UIColor *)colorWithHex:(int32_t)rgbValue {
    return [[self class] colorWithHex:rgbValue a:1.0];
}

+ (UIColor *)colorWithHex:(int32_t)rgbValue a:(CGFloat)alpha {
    return [[self class] colorWithR:((float)((rgbValue & 0xFF0000) >> 16))
                                  g:((float)((rgbValue & 0xFF00) >> 8))
                                  b:((float)(rgbValue & 0xFF))
                                  a:alpha];
}

+ (UIColor *)colorWithHexString:(NSString *)colorStr {
    return [[self class] colorWithHexString:colorStr alpha:1.0];
}

+ (UIColor *)colorWithHexString:(NSString *)colorStr alpha:(CGFloat)alpha {
    NSString *cString = [[colorStr stringByTrimmingCharactersInSet:
                          [NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    // String should be 6 or 8 characters
    if ([cString length] < 6) {
        return [UIColor clearColor];
    }
    
    // strip 0X if it appears
    if ([cString hasPrefix:@"0X"])
        cString = [cString substringFromIndex:2];
    if ([cString hasPrefix:@"#"])
        cString = [cString substringFromIndex:1];
    if ([cString length] != 6)
        return [UIColor clearColor];
    
    // Separate into r, g, b substrings
    NSRange range;
    range.location = 0;
    range.length = 2;
    
    //r
    NSString *rString = [cString substringWithRange:range];
    
    //g
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    
    //b
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    
    // Scan values
    unsigned int red, green, blue;
    [[NSScanner scannerWithString:rString] scanHexInt:&red];
    [[NSScanner scannerWithString:gString] scanHexInt:&green];
    [[NSScanner scannerWithString:bString] scanHexInt:&blue];
    
    return [[self class] colorWithR:(float)red
                                  g:(float)green
                                  b:(float)blue
                                  a:alpha];
}

+ (UIColor *)randomColor
{
    CGFloat red     = ( arc4random() % 256);
    CGFloat green   = ( arc4random() % 256);
    CGFloat blue    = ( arc4random() % 256);
    
    return [UIColor colorWithRed:red/255 green:green/255 blue:blue/255 alpha:1];
}

/**
 *  主色
 *
 *  @return <#return value description#>
 */
+ (UIColor *)themeColor
{
    CGFloat red     = 27;
    CGFloat green   = 194;
    CGFloat blue    = 184;
    
    return [UIColor colorWithRed:red/255 green:green/255 blue:blue/255 alpha:1];
}

/**
 *  @author yichao, 16-07-27 14:07:13
 *
 *  提示色
 *
 *  @return <#return value description#>
 */
+ (UIColor *)promptColor{
    CGFloat red     = 255;
    CGFloat green   = 96;
    CGFloat blue    = 96;
    
    return [UIColor colorWithRed:red/255 green:green/255 blue:blue/255 alpha:1];
}


/**
 *  @author yichao, 16-07-27 14:07:46
 *
 *  背景色
 *
 *  @return <#return value description#>
 */
+ (UIColor *)bgColor{
    CGFloat red     = 255;
    CGFloat green   = 255;
    CGFloat blue    = 255;
    
    return [UIColor colorWithRed:red/255 green:green/255 blue:blue/255 alpha:1];
}




/**
 *  文字及光标颜色
 *
 *  @return
 */
+ (UIColor *)wordColor
{
    CGFloat red     = 51;
    CGFloat green   = 51;
    CGFloat blue    = 51;
    
    return [UIColor colorWithRed:red/255 green:green/255 blue:blue/255 alpha:1];
}


/**
 *  辅助颜色
 *
 *  @return
 */
+ (UIColor *)auxiliaryColor
{
    CGFloat red     = 75;
    CGFloat green   = 221;
    CGFloat blue    = 212;
    
    return [UIColor colorWithRed:red/255 green:green/255 blue:blue/255 alpha:1];
}

/**
 *  @author yichao, 16-07-27 14:07:11
 *
 *  灰色1
 *
 *  @return
 */
+ (UIColor *)grayColorOne{
    CGFloat red     = 102;
    CGFloat green   = 102;
    CGFloat blue    = 102;
    
    return [UIColor colorWithRed:red/255 green:green/255 blue:blue/255 alpha:1];
}

/**
 *  @author yichao, 16-07-27 14:07:11
 *
 *  灰色2
 *
 *  @return
 */
+ (UIColor *)grayColorTwo{
    CGFloat red     = 153;
    CGFloat green   = 153;
    CGFloat blue    = 153;
    
    return [UIColor colorWithRed:red/255 green:green/255 blue:blue/255 alpha:1];
}

/**
 *  @author yichao, 16-07-27 14:07:11
 *
 *  灰色3
 *
 *  @return 
 */
+ (UIColor *)grayColorThree{
    CGFloat red     = 204;
    CGFloat green   = 204;
    CGFloat blue    = 204;
    
    return [UIColor colorWithRed:red/255 green:green/255 blue:blue/255 alpha:1];
}


+ (UIColor *)titleColor{

    CGFloat red     = 51;
    CGFloat green   = 51;
    CGFloat blue    = 51;
    
    return [UIColor colorWithRed:red/255 green:green/255 blue:blue/255 alpha:1];
}

+ (UIColor *)subTitleColor{
    
    CGFloat red     = 153;
    CGFloat green   = 153;
    CGFloat blue    = 153;
    
    return [UIColor colorWithRed:red/255 green:green/255 blue:blue/255 alpha:1];
}

@end
