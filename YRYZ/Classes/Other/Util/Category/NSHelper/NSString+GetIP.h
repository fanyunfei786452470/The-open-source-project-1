//
//  NSString+GetIP.h
//  Rrz
//
//  Created by weishibo on 16/3/23.
//  Copyright © 2016年 rongzhongwang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (GetIP)
+ (NSString *)deviceIPAdress;

+(NSString *) jsonStringWithDictionary:(NSDictionary *)dictionary;

+(NSString *) jsonStringWithArray:(NSArray *)array;

+(NSString *) jsonStringWithString:(NSString *) string;

+(NSString *) jsonStringWithObject:(id) object;
@end
