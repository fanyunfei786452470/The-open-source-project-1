//
//  Category.h
//  Orimuse
//
//  Created by weishibo on 16/2/17.
//  Copyright © 2016年 rongzhongwang. All rights reserved.
//

#import <UIKit/UIKit.h>

// 颜色(RGB)
#define RGB_COLOR(r, g, b)       [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:1.0]
#define RGBA_COLOR(r, g, b, a)   [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:a]
//全局文字主色调
#define Global_TextColor        RGB_COLOR(51, 51, 51)
//全局主色调
#define Global_Color            RGB_COLOR(27, 194, 184)


@interface UIColor (Helper)

+ (UIColor *)colorWithR:(CGFloat)red g:(CGFloat)green b:(CGFloat)blue a:(CGFloat)alpha;
+ (UIColor *)colorWithW:(CGFloat)white a:(CGFloat)alpha;

+ (UIColor *)colorWithHex:(int32_t)rgbValue;
+ (UIColor *)colorWithHex:(int32_t)rgbValue a:(CGFloat)alpha;

+ (UIColor *)colorWithHexString:(NSString *)colorStr;
+ (UIColor *)colorWithHexString:(NSString *)colorStr alpha:(CGFloat)alpha;

/**随机色 */
+ (UIColor *)randomColor;
/**主色 */
+ (UIColor *)themeColor;
/**文字颜色 */
+ (UIColor *)wordColor;
/**辅助颜色 */
+ (UIColor *)auxiliaryColor;
/**提示颜色 */
+ (UIColor *)promptColor;
/**背景颜色 */
+ (UIColor *)bgColor;
/**灰色1 */
+ (UIColor *)grayColorOne;
/**灰色2 */
+ (UIColor *)grayColorTwo;
/**灰色3 */
+ (UIColor *)grayColorThree;

@end
