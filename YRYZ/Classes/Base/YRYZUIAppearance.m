//
//  RRZUIAppearance.m
//  Rrz
//
//  Created by weishibo on 16/2/19.
//  Copyright © 2016年 rongzhongwang. All rights reserved.
//

#import "YRYZUIAppearance.h"

@implementation YRYZUIAppearance


+ (void)customNavigationbarAppearance {

//    //title字体阴影效果
    NSShadow *shadow = [[NSShadow alloc] init];
    shadow.shadowColor = [UIColor grayColor];
    shadow.shadowOffset = CGSizeMake(0, 0);
    
    //NAV 标题
    [[UINavigationBar appearance] setTitleTextAttributes:
     @{ NSForegroundColorAttributeName: [UIColor whiteColor],
//        NSFontAttributeName: [UIFont fontWithName:@"Heiti SC" size:20],
        NSFontAttributeName: [UIFont systemFontOfSize:22],
        NSShadowAttributeName:shadow
        }
     ];
//    [[UINavigationBar appearance] setBarTintColor:[UIColor wordColor]];
//    [[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor wordColor]}];

    [[UITextField appearance] setTintColor:[UIColor themeColor]];
    [[UITextView  appearance] setTintColor:[UIColor themeColor]];
//    [[UISearchBar appearance] setTintColor:[UIColor themeColor]];
    
    
    [[UINavigationBar appearance] setBarTintColor:[UIColor colorWithRed:0 green:1.f*0xb4/0xff blue:1.f alpha:1.f]];
//    [[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
//    [[UITabBar appearance] setTintColor:[UIColor colorWithRed:0 green:1.f*0xb4/0xff blue:1.f alpha:1.f]];
    
  

}

//
//
//+ (UIImage*)themeColorImage
//{
//    static UIImage *themeColorImage = nil;
//    static dispatch_once_t onceToken;
//    dispatch_once(&onceToken, ^{
//        themeColorImage = [UIImage getImageFromColor:[UIColor themeColor] size:CGSizeMake(1, 1)];
//    });
//    return themeColorImage;
//}
//
//+ (UIImage*)clearColorImage
//{
//    static UIImage *clearColorImage = nil;
//    static dispatch_once_t onceToken;
//    dispatch_once(&onceToken, ^{
//        clearColorImage = [UIImage getImageFromColor:[UIColor clearColor] size:CGSizeMake(1, 1)];
//    });
//    return clearColorImage;
//}



@end
