//
//  UIViewController+RootView.h
//  Rrz
//
//  Created by weishibo on 16/2/18.
//  Copyright © 2016年 rongzhongwang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (RootView)


+ (UIViewController*)rrz_rootViewController;

+ (UIViewController *)getCurrentVC;
+(BOOL)isCurrentViewControllerVisible:(UIViewController *)viewController;
@end
