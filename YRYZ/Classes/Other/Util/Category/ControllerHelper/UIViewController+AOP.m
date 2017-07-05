//
//  UIViewController+AOP.m
//  Orimuse
//
//  Created by bingjie-macbookpro on 15/9/7.
//  Copyright (c) 2015年 Bingjie. All rights reserved.
//

#import "UIViewController+AOP.h"
#import "ObjcRuntime.h"
#import "UMMobClick/MobClick.h"


#import "YRHomeViewController.h"
#import "YRMessageViewController.h"
#import "YRSunTextViewController.h"
#import "YRDiscoverViewController.h"
#import "YRMineViewController.h"


@implementation UIViewController (AOP)


+ (NSArray*)rootViewControllers
{
    static NSArray *vcs = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        vcs = @[@"YRHomeViewController",
                @"YRMessageViewController",
                @"YRWeChatViewController",
                @"YRDiscoverViewController",
                @"YRMineViewController.h",
                ];
    });
    return vcs;
}


+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Class class = [self class];
    
        Swizzle(class, @selector(viewDidLoad), @selector(aop_viewDidLoad));
        Swizzle(class, @selector(viewDidAppear:), @selector(aop_viewDidAppear:));
        Swizzle(class, @selector(viewWillAppear:), @selector(aop_viewWillAppear:));
        Swizzle(class, @selector(viewWillDisappear:), @selector(aop_viewWillDisappear:));
        
    });
}


- (void)aop_viewDidLoad
{
    [self aop_viewDidLoad];

    if (self.navigationController.viewControllers.count > 1) {
//        [self.rdv_tabBarController setTabBarHidden:YES animated:YES];
    }

}

- (void)aop_viewDidAppear:(BOOL)animated
{
    [self aop_viewDidAppear:animated];
    
    if ([[self.navigationController childViewControllers] count] > 1) {
//        [self.rdv_tabBarController setTabBarHidden:YES animated:YES];
    }else{
//        [self.rdv_tabBarController setTabBarHidden:NO animated:YES];
    }
}


- (void)aop_viewWillAppear:(BOOL)animated
{
    [self aop_viewWillAppear:animated];

    [MobClick beginLogPageView:NSStringFromClass([self class])];
}

- (void)aop_viewWillDisappear:(BOOL)animated
{
    [self aop_viewWillDisappear:animated];
    
    [MobClick endLogPageView:NSStringFromClass([self class])];
}

@end
