//
//  NSString+GetIP.m
//  Rrz
//
//  Created by weishibo on 16/3/23.
//  Copyright © 2016年 rongzhongwang. All rights reserved.
//

#import "NSString+GetIP.h"
#include <ifaddrs.h>
#include <arpa/inet.h>

@implementation NSString (GetIP)


+ (NSString *)deviceIPAdress {
    NSString *address = @"an error occurred when obtaining ip address";
    struct ifaddrs *interfaces = NULL;
    struct ifaddrs *temp_addr = NULL;
    int success = 0;
    
    success = getifaddrs(&interfaces);
    
    if (success == 0) { // 0 表示获取成功
        
        temp_addr = interfaces;
        while (temp_addr != NULL) {
            if( temp_addr->ifa_addr->sa_family == AF_INET) {
                // Check if interface is en0 which is the wifi connection on the iPhone
                if ([[NSString stringWithUTF8String:temp_addr->ifa_name] isEqualToString:@"en0"]) {
                    // Get NSString from C String
                    address = [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)temp_addr->ifa_addr)->sin_addr)];
                }
            }
            
            temp_addr = temp_addr->ifa_next;
        }
    }
    
    freeifaddrs(interfaces);
    
//        DLog(@"手机的IP是：%@", address);
    
    return address;
}



+(NSString *) jsonStringWithString:(NSString *) string{
    
    return [NSString stringWithFormat:@"%@",
            
            [[string stringByReplacingOccurrencesOfString:@"\n" withString:@"\\n"] stringByReplacingOccurrencesOfString:@"" withString:@"\\"]
            
            ];
    
}


+(NSString *) jsonStringWithArray:(NSArray *)array{
    
    NSMutableString *reString = [NSMutableString string];
    
    [reString appendString:@"["];
    
    NSMutableArray *values = [NSMutableArray array];
    
    for (id valueObj in array) {
        
        NSString *value = [NSString jsonStringWithObject:valueObj];
        
        if (value) {
            
            [values addObject:[NSString stringWithFormat:@"%@",value]];
            
        }
        
    }
    
    [reString appendFormat:@"%@",[values componentsJoinedByString:@","]];
    
    [reString appendString:@"]"];
    
    return reString;
    
}


+(NSString *) jsonStringWithDictionary:(NSDictionary *)dictionary{
    
    NSArray *keys = [dictionary allKeys];
    
    NSMutableString *reString = [NSMutableString string];
    
    [reString appendString:@"{"];
    
    NSMutableArray *keyValues = [NSMutableArray array];
    
    for (int i=0; i<[keys count]; i++) {
        
        NSString *name = [keys objectAtIndex:i];
        
        id valueObj = [dictionary objectForKey:name];
        
        NSString *value = [NSString jsonStringWithObject:valueObj];
        
        if (value) {
            
            [keyValues addObject:[NSString stringWithFormat:@"%@:%@",name,value]];
            
        }
        
    }
    
    [reString appendFormat:@"%@",[keyValues componentsJoinedByString:@","]];
    
    [reString appendString:@"}"];
    
    return reString;
    
}


+(NSString *) jsonStringWithObject:(id) object{
    
    NSString *value = nil;
    
    if (!object) {
        
        return value;
        
    }
    
    if ([object isKindOfClass:[NSString class]]) {
        
        value = [NSString jsonStringWithString:object];
        
    }else if([object isKindOfClass:[NSDictionary class]]){
        
        value = [NSString jsonStringWithDictionary:object];
        
    }else if([object isKindOfClass:[NSArray class]]){
        
        value = [NSString jsonStringWithArray:object];
        
    }
    
    return value;
    
}





@end
