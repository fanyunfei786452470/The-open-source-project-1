//
//  BaseNavigationController.h
//  Rrz
//
//  Created by weishibo on 16/2/18.
//  Copyright © 2016年 rongzhongwang. All rights reserved.
//

#import "BaseNavigationController.h"
#import "UIImage+Extension.h"
#import "YRMessageViewController.h"
#import "YRRedPaperPaymentViewController.h"

#import "YRVidioFullController.h"
#import "YRMobilePhoneContactController.h"
#import "YRAddressListController.h"
#import "YRMineAddressListController.h"
#import "YRTranSucessViewController.h"

@interface BaseNavigationController ()<UIGestureRecognizerDelegate>

@end

@implementation BaseNavigationController

+ (void)load
{
    // 导航栏设置图片
    UINavigationBar *navBar = [UINavigationBar appearanceWhenContainedIn:self, nil];
    UIImage *navBgImage = [UIImage imageNamed:@"theme_navbar_bg"];
    //[navBar setBackgroundImage:navBgImage forBarMetrics:UIBarMetricsDefault];
    [navBar setBarTintColor:RGB_COLOR(27, 194, 184)];
    //去掉了导航单底部的线条
    
    [[UINavigationBar appearance] setBackgroundImage:navBgImage forBarMetrics:UIBarMetricsDefault];
    [[UINavigationBar appearance] setShadowImage:[[UIImage alloc] init]];  // 设置阴影图片
    navBar.translucent = NO;

}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UISwipeGestureRecognizer *swipe = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swipe:)];
    //轻扫的方向
    swipe.direction = UISwipeGestureRecognizerDirectionRight;
    [self.view addGestureRecognizer:swipe];

}

/**
 *  @author weishibo, 16-06-21 15:06:51
 *
 */
- (void)swipe:(UISwipeGestureRecognizer *)swipe{
    
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if(animated){
        [self setPopAnimationWithTimingFunction:kCAMediaTimingFunctionDefault];
        viewController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    }
    
    if (self.childViewControllers.count > 0) {
        
        viewController.hidesBottomBarWhenPushed = YES;
        
//        UIButton *returnButton = [UIButton buttonWithType:UIButtonTypeCustom];
//        [returnButton setImage:[UIImage imageNamed:@"backIndicatorImage"] forState:UIControlStateNormal];
//        returnButton.frame = CGRectMake(0, 0, 20, 64);
//        [returnButton addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
//        
//        UIBarButtonItem *returnItem = [[UIBarButtonItem alloc]initWithCustomView:returnButton];
        
        viewController.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"backIndicatorImage"] style:UIBarButtonItemStylePlain target:self action:@selector(back)];
    }
    [super pushViewController:viewController animated:animated];
}

- (void)back
{
    [self popViewControllerAnimated:YES];
}

- (UIViewController *)popViewControllerAnimated:(BOOL)animated
{
    if(animated){
        [self setPopAnimationWithTimingFunction:kCAMediaTimingFunctionDefault];
    }
    return [super popViewControllerAnimated:animated];
}

- (NSArray *)popToRootViewControllerAnimated:(BOOL)animated
{
    if(animated){
        [self setPopAnimationWithTimingFunction:kCAMediaTimingFunctionDefault];
    }
    return [super popToRootViewControllerAnimated:animated];
}


- (NSArray *)popToViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if(animated){
        [self setPopAnimationWithTimingFunction:kCAMediaTimingFunctionDefault];
        viewController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    }
    return [super popToViewController:viewController animated:animated];
}

- (void)setPopAnimationWithTimingFunction:(NSString*)timingFunction
{
    
}

#pragma mark - aboutRotate

- (BOOL)shouldAutorotate
{
//    if ([self.topViewController isKindOfClass:[YRVidioFullController class]]) { // 如果是这个 vc 则支持自动旋转
//        return YES;
//    }

    
    return NO;
}
- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return NO;
}

#pragma mark - UIGestureRecognizerDelegate

// 控制手势是否触发
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    if ([self.childViewControllers.lastObject isKindOfClass:[YRRedPaperPaymentViewController class]]||[self.childViewControllers.lastObject isKindOfClass:[YRMobilePhoneContactController class]]||[self.childViewControllers.lastObject isKindOfClass:[YRAddressListController class]]|| [self.childViewControllers.lastObject isKindOfClass:[YRMineAddressListController class]]){
        return NO;
    }else{
        // 根控制器的时候不需要手势
       return self.childViewControllers.count != 1;
    }
    
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer{
    
    if ([self.childViewControllers.lastObject isKindOfClass:[YRMobilePhoneContactController class]]){
        return NO;
    }
    return YES;
}

@end
