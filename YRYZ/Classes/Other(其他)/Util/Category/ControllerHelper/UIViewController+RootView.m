//
//  UIViewController+RootView.m
//  Rrz
//
//  Created by weishibo on 16/2/18.
//  Copyright © 2016年 rongzhongwang. All rights reserved.
//

#import "UIViewController+RootView.h"

@implementation UIViewController (RootView)


+ (UIViewController*)rrz_rootViewController{


    UIWindow * window = [[[UIApplication sharedApplication]delegate]window]; 
    if (window.windowLevel != UIWindowLevelNormal)
    {
        NSArray *windows = [[UIApplication sharedApplication] windows];
        for(UIWindow * tmpWin in windows)
        {
            if (tmpWin.windowLevel == UIWindowLevelNormal)
            {
                window = tmpWin;
                break;
            }
        }
    }
    UIViewController *result = window.rootViewController;
    return result;
    
    
}

@end
