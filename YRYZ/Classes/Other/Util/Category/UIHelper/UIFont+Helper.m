//
//  UIFont+Helper.m
//  YRYZ
//
//  Created by shibo on 16/10/19.
//  Copyright © 2016年 yryz. All rights reserved.
//

#import "UIFont+Helper.h"

@implementation UIFont (Helper)

+ (UIFont *)titleFontBold17{
    if (kDevice_Is_iPhone5) {
      return [UIFont systemFontOfSize:15 weight:1.1];
    }else{
        return [UIFont systemFontOfSize:17 weight:1.1];
    }
}


+ (UIFont *)titleFontBoldTab17{

        return [UIFont systemFontOfSize:17 weight:1.1];
}



+ (UIFont *)titleFont20{
    return [UIFont systemFontOfSize:20];
}
+ (UIFont *)titleFont19{
    if (kDevice_Is_iPhone5) {
        return [UIFont systemFontOfSize:16];
    }else{
        return [UIFont systemFontOfSize:19];
    }
}
+ (UIFont *)titleFont18{
    return [UIFont systemFontOfSize:18];
}
+ (UIFont *)titleFont17{
    return [UIFont systemFontOfSize:17];
}
+ (UIFont *)titleFont16{
    return [UIFont systemFontOfSize:16];
}
+ (UIFont *)titleFont15{
    if (kDevice_Is_iPhone5) {
        return [UIFont systemFontOfSize:12];
    }else{
        return [UIFont systemFontOfSize:15];
}
}
+ (UIFont *)titleFont14{
    if (kDevice_Is_iPhone5) {
           return [UIFont systemFontOfSize:12];
    }else{
        return [UIFont systemFontOfSize:14];
    }
}
+ (UIFont *)titleFont13{
    return [UIFont systemFontOfSize:13];
}
+ (UIFont *)titleFont12{
    return [UIFont systemFontOfSize:12];
}
+ (UIFont *)titleFont11{
    return [UIFont systemFontOfSize:11];
}






@end
