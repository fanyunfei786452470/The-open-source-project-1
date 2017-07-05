//
//  NSString+Additions.m
//  Orimuse
//
//  Created by Bingjie on 14/12/11.
//  Copyright (c) 2014年 Bingjie. All rights reserved.
//

#import "NSString+Additions.h"
#import <CommonCrypto/CommonCrypto.h>


@implementation NSString (Additions)


- (CGSize)getSizeWithFont:(UIFont *)fontSize constrainedToSize:(CGSize)sizeFormat
{
    NSDictionary *dict = @{NSFontAttributeName:fontSize, NSParagraphStyleAttributeName:[NSParagraphStyle defaultParagraphStyle]};
    
    CGSize size = CGSizeZero;
    
    size = [self boundingRectWithSize:sizeFormat
                              options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                           attributes:dict
                              context:nil].size;
    if (CGSizeEqualToSize(sizeFormat,CGSizeZero)||CGSizeEqualToSize(sizeFormat,CGSizeMake(0, 0))) {
        size = [self sizeWithAttributes:dict];
    }
    return size;
}


+ (NSString*)getJSONSStringByJSONObject:(id)jsonObject
{
    NSString *jsonString = nil;
    if ([NSJSONSerialization isValidJSONObject:jsonObject]) {
        NSData *data = [NSJSONSerialization dataWithJSONObject:jsonObject options:NSJSONWritingPrettyPrinted error:nil];
        jsonString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    }
    return jsonString;
}

// Checking if String is Empty
-(BOOL)isBlank
{
    return ([[self removeWhiteSpacesFromString] isEqualToString:@""]) ? YES : NO;
}
//Checking if String is empty or nil
-(BOOL)isValid
{
    return ([[self removeWhiteSpacesFromString] isEqualToString:@""] || self == nil || [self isEqualToString:@"(null)"]) ? NO :YES;
}
//NSRange range = [tempStr rangeOfString:@")\">"];//判断字符串是否包含

-(BOOL)isAtoZ{
    NSString *match=@"(^[A-Za-z]+$)";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF matches %@", match];
    return [predicate evaluateWithObject:self];
    
}
-(BOOL)isChinese
{
    NSString *match=@"(^[\u4e00-\u9fa5]+$)";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF matches %@", match];
    return [predicate evaluateWithObject:self];
}

// remove white spaces from String
- (NSString *)removeWhiteSpacesFromString
{
    NSString *trimmedString = [self stringByTrimmingCharactersInSet:
                               [NSCharacterSet whitespaceAndNewlineCharacterSet]];
    return trimmedString;
}

// Counts number of Words in String
- (NSUInteger)countNumberOfWords
{
    NSScanner *scanner = [NSScanner scannerWithString:self];
    NSCharacterSet *whiteSpace = [NSCharacterSet whitespaceAndNewlineCharacterSet];
    
    NSUInteger count = 0;
    while ([scanner scanUpToCharactersFromSet: whiteSpace  intoString: nil]) {
        count++;
    }
    
    return count;
}

// If string contains substring
- (BOOL)containsString:(NSString *)subString
{
    return ([self rangeOfString:subString].location == NSNotFound) ? NO : YES;
}

// If my string starts with given string
- (BOOL)isBeginsWith:(NSString *)string
{
    return ([self hasPrefix:string]) ? YES : NO;
}

// If my string ends with given string
- (BOOL)isEndssWith:(NSString *)string
{
    return ([self hasSuffix:string]) ? YES : NO;
}



// Replace particular characters in my string with new character
- (NSString *)replaceCharcter:(NSString *)olderChar withCharcter:(NSString *)newerChar
{
    return  [self stringByReplacingOccurrencesOfString:olderChar withString:newerChar];
}

// Get Substring from particular location to given lenght
- (NSString*)getSubstringFrom:(NSInteger)begin to:(NSInteger)end
{
    NSRange r;
    r.location = begin;
    r.length = end - begin;
    return [self substringWithRange:r];
}

// Add substring to main String
- (NSString *)addString:(NSString *)string
{
    if(!string || string.length == 0)
        return self;
    
    return [self stringByAppendingString:string];
}

// Remove particular sub string from main string
-(NSString *)removeSubString:(NSString *)subString
{
    if ([self containsString:subString])
    {
        NSRange range = [self rangeOfString:subString];
        return  [self stringByReplacingCharactersInRange:range withString:@""];
    }
    return self;
}




// If my string contains ony letters
- (BOOL)containsOnlyLetters
{
    NSCharacterSet *letterCharacterset = [[NSCharacterSet letterCharacterSet] invertedSet];
    return ([self rangeOfCharacterFromSet:letterCharacterset].location == NSNotFound);
}


// If my string contains only numbers
- (BOOL)containsOnlyNumbers
{
    NSCharacterSet *numbersCharacterSet = [[NSCharacterSet characterSetWithCharactersInString:@"0123456789"] invertedSet];
    return ([self rangeOfCharacterFromSet:numbersCharacterSet].location == NSNotFound);
}

//带小数点的
- (BOOL)containsOnlyDoubleNumbers
{
    NSCharacterSet *numbersCharacterSet = [[NSCharacterSet characterSetWithCharactersInString:@"0123456789."] invertedSet];
    return ([self rangeOfCharacterFromSet:numbersCharacterSet].location == NSNotFound);
}


// If my string contains letters and numbers
- (BOOL)containsOnlyNumbersAndLetters
{
    NSCharacterSet *numAndLetterCharSet = [[NSCharacterSet alphanumericCharacterSet] invertedSet];
    return ([self rangeOfCharacterFromSet:numAndLetterCharSet].location == NSNotFound);
}

// If my string is available in particular array
- (BOOL)isInThisarray:(NSArray*)array
{
    for(NSString *string in array) {
        if([self isEqualToString:string]) {
            return YES;
        }
    }
    return NO;
}

// Get String from array
+ (NSString *)getStringFromArray:(NSArray *)array
{
    return [array componentsJoinedByString:@" "];
}

// Convert Array from my String
- (NSArray *)getArray
{
    return [self componentsSeparatedByString:@" "];
}

// Get My Application Version number
+ (NSString *)getMyApplicationVersion
{
    NSDictionary *info = [[NSBundle mainBundle] infoDictionary];
    //    CFBundleVersion
    NSString *version = [info objectForKey:@"CFBundleShortVersionString"];
    return version;
}

// Get My Application name
+ (NSString *)getMyApplicationName
{
    NSDictionary *info = [[NSBundle mainBundle] infoDictionary];
    NSString *name = [info objectForKey:@"CFBundleDisplayName"];
    return name;
}


// Convert string to NSData
- (NSData *)convertToData
{
    return [self dataUsingEncoding:NSUTF8StringEncoding];
}

// Get String from NSData
+ (NSString *)getStringFromData:(NSData *)data
{
    return [[NSString alloc] initWithData:data
                                 encoding:NSUTF8StringEncoding];
    
}

-(BOOL)isAbc{
    //if (preg_match('/[\xf0-\xf7][\x80-\xbf]{3}/', $name)) {
    //    throw new ServiceException('不支持Emoji表情', EchoExceptionConstant::USER_NAME_INVALID);
    //}
    
    NSString  *regex = @"^[xf0-xf7][x80-xbf]{3}";
    //    NSString *regex = @"^[A-Za-z0-9\u4E00-\u9FA5_-]+$";
    NSPredicate *abcTestPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    return [abcTestPredicate evaluateWithObject:self];
}

// Is Valid Email

- (BOOL)isValidEmail
{
    NSString *regex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTestPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    return [emailTestPredicate evaluateWithObject:self];
}


// Is Valid Phone

- (BOOL)isMobileNumber
{
    NSString *phoneRegex = @"^((1[3-9][0-9]))\\d{8}$";
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", phoneRegex];
    
    return [regextestmobile evaluateWithObject:self];
}


//验证密码
- (BOOL)isPassword{
    //    ^(?![0-9]+$)(?![a-zA-Z]+$)[0-9A-Za-z]{6,10}$      ^[a-zA-Z0-9]{6,18}+$
    NSString *passWordRegex = @"^(?![0-9]+$)(?![a-zA-Z]+$)[0-9A-Za-z]{6,18}$";
    NSPredicate *passWordPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",passWordRegex];
    
    return [passWordPredicate evaluateWithObject:self];
}

//验证密码
+ (BOOL) validatePassword:(NSString *)passWord
{
    NSString *passWordRegex = @"^[a-zA-Z0-9]{6,18}+$";
    
    NSPredicate *passWordPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",passWordRegex];
    
    return [passWordPredicate evaluateWithObject:passWord];
}

// Is Valid URL

- (BOOL)isValidUrl
{
    NSString *regex =@"(http|https)://((\\w)*|([0-9]*)|([-|_])*)+([\\.|/]((\\w)*|([0-9]*)|([-|_])*))+";
    NSPredicate *urlTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    return [urlTest evaluateWithObject:self];
}

+ (NSString*)randomStringWithLength:(NSUInteger)length
{
    NSInteger NUMBER_OF_CHARS = length;
    char data[NUMBER_OF_CHARS];
    for (int x=0 ;x < NUMBER_OF_CHARS;data[x++] = (char)('A' + (arc4random_uniform(26))))
    {
    }
    return  [[NSString alloc] initWithBytes:data length:NUMBER_OF_CHARS encoding:NSUTF8StringEncoding];
}

//转换拼音
- (NSString *)transformToPinyin {
    if (self.length <= 0) {
        return self;
    }
    NSMutableString *tempString = [NSMutableString stringWithString:self];
    CFStringTransform((CFMutableStringRef)tempString, NULL, kCFStringTransformToLatin, false);
    tempString = (NSMutableString *)[tempString stringByFoldingWithOptions:NSDiacriticInsensitiveSearch locale:[NSLocale currentLocale]];
    return [tempString uppercaseString];
}

+ (NSString*)formatPrice:(CGFloat)price
{
    return [NSString stringWithFormat:@"￥%.2f",price *0.01];
}


//小图
+ (NSString*)samllImageUrl:(NSString*)urlStr
{
    
    NSString *ipkey = [[NSString stringWithFormat:@"rrzFile%@",[NSString deviceIPAdress]] md5String];
    //    NSString *str = [NSString stringWithFormat:@"%@%@%@?key=%@",kImageIP,urlStr,@".jpg",ipkey];
    //    DLog(@"%@",str);
    return [NSString stringWithFormat:@"%@%@%@?key=%@",kImageIP,urlStr,@".jpg",ipkey];
}

//大图
+ (NSString*)bigImageUrl:(NSString*)urlStr
{
    
    NSString *ipkey = [[NSString stringWithFormat:@"rrzFile%@",[NSString deviceIPAdress]] md5String];
    return [NSString stringWithFormat:@"%@%@?key=%@",kImageIP,urlStr,ipkey];
}

//头像
+ (NSString*)headImageUrl:(NSString*)urlStr
{
    NSString *ipkey = [[NSString stringWithFormat:@"rrzFile%@",[NSString deviceIPAdress]] md5String];
    return [NSString stringWithFormat:@"%@%@?key=%@",kImageIP,urlStr,ipkey];
}


//大图
+ (NSString*)imageUrl:(NSString*)urlStr{
    
    NSString *ipkey = [[NSString stringWithFormat:@"rrzFile%@",[NSString deviceIPAdress]] md5String];
    return [NSString stringWithFormat:@"%@%@?key=%@",kImageIP,urlStr,ipkey];
}

//web地址
+ (NSString*)webViewUrl:(NSString*)urlStr{
    
    NSString *ipkey = [[NSString stringWithFormat:@"rrzFile%@",[NSString deviceIPAdress]] md5String];
    return [NSString stringWithFormat:@"%@%@?key=%@",kImageIP,urlStr,ipkey];
}




+ (NSString *)formatPaa:(NSArray *)array {
    
    NSMutableDictionary *mdic = [NSMutableDictionary dictionary];
    
    NSMutableString *paaStr = [[NSMutableString alloc] init];
    for (int i = 0; i < array.count; i++) {
        [paaStr appendFormat:@"%@=%@&", array[i+1], array[i]];
        mdic[array[i+1]] = array[i];
        i++;
    }
    
    NSString *signMsg = [self md5:[paaStr substringToIndex:paaStr.length - 1]];
    mdic[@"signMsg"] = signMsg.uppercaseString;
    
    
    
    if (mdic[@"key"]) {//商户私有签名密钥 通联后台持有不传入插件
        [mdic removeObjectForKey:@"key"];
    }
    
    NSError *error;
    NSData *data = [NSJSONSerialization dataWithJSONObject:mdic options:NSJSONWritingPrettyPrinted error:&error];
    NSString *jsonStr = [[NSString alloc] initWithBytes:[data bytes] length:[data length] encoding:NSUTF8StringEncoding];
    
    [paaStr setString:jsonStr];
    
    return paaStr;
}



//计算字符串对应的md5值（通联专用）
+ (NSString *)md5:(NSString *)string {
    
    //    DLog(@"%@", string);
    
    if (string == nil) { return nil; }
    
    const char *str = [string cStringUsingEncoding:NSUTF8StringEncoding];
    CC_LONG strLen = (CC_LONG)[string lengthOfBytesUsingEncoding:NSUTF8StringEncoding];
    unsigned char *result = calloc(CC_MD5_DIGEST_LENGTH, sizeof(unsigned char));
    CC_MD5(str, strLen, result);
    
    NSMutableString *hash = [NSMutableString string];
    for (int i = 0; i < CC_MD5_DIGEST_LENGTH; ++i) {
        [hash appendFormat:@"%02x", result[i]];
    }
    
    free(result);
    
    return hash;
}






@end
