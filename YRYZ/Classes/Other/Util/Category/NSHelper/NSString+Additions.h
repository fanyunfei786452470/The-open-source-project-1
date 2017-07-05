//
//  NSString+Additions.h
//  Orimuse
//
//  Created by Bingjie on 14/12/11.
//  Copyright (c) 2014年 Bingjie. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Additions)
//拼接请求参数
+(NSString *)HTTPBodyWithParameters:(NSArray *)parameters keyStr:(NSString*)keyStr;
- (CGSize)getSizeWithFont:(UIFont *)fontSize constrainedToSize:(CGSize)sizeFormat;

+ (NSString*)getJSONSStringByJSONObject:(id)jsonObject;
-(BOOL)isAtoZ;
-(BOOL)isBlank;
-(BOOL)isValid;
-(BOOL)isChinese;
- (NSString *)removeWhiteSpacesFromString;
//判断手机号
- (BOOL)isMinePhoneNumber;
- (NSUInteger)countNumberOfWords;
//是否全是字符串
-(BOOL)PureLetters:(NSString*)str;
- (BOOL)containsString:(NSString *)subString;
- (BOOL)isBeginsWith:(NSString *)string;
- (BOOL)isEndssWith:(NSString *)string;

- (NSString *)replaceCharcter:(NSString *)olderChar withCharcter:(NSString *)newerChar;
- (NSString*)getSubstringFrom:(NSInteger)begin to:(NSInteger)end;
- (NSString *)addString:(NSString *)string;
- (NSString *)removeSubString:(NSString *)subString;

- (BOOL)containsOnlyLetters;
- (BOOL)containsOnlyNumbers;
//带小数点的
- (BOOL)containsOnlyDoubleNumbers;
//判断是否为浮点型：
- (BOOL)isPureFloat;
//判断是否为整形：
- (BOOL)isPureIntNumber;
- (BOOL)containsOnlyNumbersAndLetters;
- (BOOL)isInThisarray:(NSArray*)array;

+ (NSString *)getStringFromArray:(NSArray *)array;
- (NSArray *)getArray;

+ (NSString *)getMyApplicationVersion;
+ (NSString *)getMyApplicationName;

- (NSData *)convertToData;
+ (NSString *)getStringFromData:(NSData *)data;

- (BOOL)isValidEmail;
- (BOOL)isMobileNumber;
- (BOOL)isValidUrl;
- (BOOL)isAbc;
- (BOOL)isPassword;

//验证密码
+ (BOOL) validatePassword:(NSString *)passWord;

+ (NSString*)randomStringWithLength:(NSUInteger)length;

//转换拼音
- (NSString *)transformToPinyin;

+ (NSString*)formatPrice:(CGFloat)price;

////拼缩略图图片url
//+ (NSString*)samllImageUrl:(NSString*)urlStr;
//+ (NSString*)bigImageUrl:(NSString*)urlStr;
////头像Url
//+ (NSString*)headImageUrl:(NSString*)urlStr;
////银行卡图片
////+ (NSString*)bankIconImageUrl:(NSString*)urlStr;
////拼原图Url
//+ (NSString*)imageUrl:(NSString*)urlStr;
//
//+ (NSString*)webViewUrl:(NSString*)urlStr;
//数组转字符串（通联专用）
+(NSString *)formatPaa:(NSArray *)array;
//计算字符串对应的md5值（通联专用）
+ (NSString *)md5:(NSString *)string;

@end
