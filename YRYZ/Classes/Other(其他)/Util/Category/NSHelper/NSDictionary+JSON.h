//
//  NSDictionary+JSON.h
//  Rrz
//
//  Created by 易超 on 16/4/8.
//  Copyright © 2016年 rongzhongwang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (JSON)

+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString;

@end
