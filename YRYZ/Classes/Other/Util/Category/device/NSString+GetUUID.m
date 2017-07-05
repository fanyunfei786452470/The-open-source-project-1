//
//  NSString+GetUUID.m
//  Rrz
//
//  Created by weishibo on 16/4/16.
//  Copyright © 2016年 rongzhongwang. All rights reserved.
//

#import "NSString+GetUUID.h"
#import "NSString+KeyChainStore.h"

@implementation NSString (GetUUID)
+(NSString *)getUUID

{
    CFUUIDRef puuid = CFUUIDCreate( nil );
    CFStringRef uuidString = CFUUIDCreateString( nil, puuid );
    NSString * result = (NSString *)CFBridgingRelease(CFStringCreateCopy( NULL, uuidString));
    CFRelease(puuid);
    CFRelease(uuidString);
    
    return result;

//    NSString * strUUID = (NSString *)[NSString load:KEY_USERNAME_PASSWORD];
//    //首次执行该方法时，uuid为空
//    if ([strUUID isEqualToString:@""] || !strUUID){
//        //生成一个uuid的方法
//        CFUUIDRef uuidRef = CFUUIDCreate(kCFAllocatorDefault);
//        strUUID = (NSString *)CFBridgingRelease(CFUUIDCreateString (kCFAllocatorDefault,uuidRef));
//        //将该uuid保存到keychain
//        [NSString save:KEY_USERNAME_PASSWORD data:strUUID];
//    }
//    return strUUID;
    
//    return @"";
}
//-(NSString*) uuid {
//     CFUUIDRef puuid = CFUUIDCreate( nil );
//     CFStringRef uuidString = CFUUIDCreateString( nil, puuid );
//     NSString * result = (NSString *)CFBridgingRelease(CFStringCreateCopy( NULL, uuidString));
//     CFRelease(puuid);
//     CFRelease(uuidString);
//    
//     return result;
//}


@end
