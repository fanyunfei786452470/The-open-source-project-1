//
//  YRUserBaskSunModel.m
//  YRYZ
//
//  Created by Sean on 16/8/26.
//  Copyright © 2016年 yryz. All rights reserved.
//

#import "YRUserBaskSunModel.h"

@implementation YRUserBaskSunModel
+ (NSDictionary *)mj_objectClassInArray{
    NSDictionary *dic = @{@"pics":@"BaskPicModel"};
    return dic;
}


@end



@implementation BaskPicModel
+ (NSDictionary *)mj_replacedKeyFromPropertyName{
    NSDictionary *dic = @{@"ids":@"id"};
    return dic;
}

@end

