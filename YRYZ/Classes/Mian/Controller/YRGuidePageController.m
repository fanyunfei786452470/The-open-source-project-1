//
//  YRGuidePageController.m
//  YRYZ
//
//  Created by Sean on 16/9/8.
//  Copyright © 2016年 yryz. All rights reserved.
//

#import "YRGuidePageController.h"
#import "AppDelegate.h"
#import "SDCycleScrollView.h"
#define  FIRSTENTRY   @"firstEntry"
@interface YRGuidePageController ()<SDCycleScrollViewDelegate>

@end

@implementation YRGuidePageController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
//    [[NSUserDefaults standardUserDefaults] setObject:FIRSTENTRY forKey:FIRSTENTRY];
    
    [self configUI];
}

//- (void)viewWillAppear:(BOOL)animated{
//    [super viewWillAppear:animated];
//    self.navigationController.navigationBar.hidden = YES;
//    if ([self respondsToSelector:@selector(setNeedsStatusBarAppearanceUpdate)]) {
//        [self prefersStatusBarHidden];
//        [self performSelector:@selector(setNeedsStatusBarAppearanceUpdate)];
//    }
//}
//- (BOOL)prefersStatusBarHidden{
//    return YES;
//}
- (void)configUI{
    // 情景一：采用本地图片实现
    NSArray *imageNames = @[@"yr_guide-1",
                            @"yr_guide-2",
                            @"yr_guide-3",
                            @"yr_guide-4",
                            @"yr_guide-5",
                            @"yr_guide-6",   // 本地图片请填写全名
                            ];
    
    SDCycleScrollView *cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:self.view.bounds shouldInfiniteLoop:YES imageNamesGroup:imageNames];
    cycleScrollView.infiniteLoop = NO;
    cycleScrollView.autoScroll = NO;
    cycleScrollView.delegate = self;
    cycleScrollView.showPageControl = NO;
    cycleScrollView.pageControlStyle = SDCycleScrollViewPageContolStyleAnimated;
//    cycleScrollView.currentPageDotColor = [UIColor redColor];
//    cycleScrollView.pageDotColor = [UIColor orangeColor];
    cycleScrollView.scrollDirection = UICollectionViewScrollDirectionHorizontal;
     [self.view addSubview:cycleScrollView];
}
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index
{
    if (index == cycleScrollView.localizationImageNamesGroup.count-1) {
        AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
        [[NSUserDefaults standardUserDefaults] setObject:FIRSTENTRY forKey:FIRSTENTRY];
         [[NSUserDefaults standardUserDefaults] synchronize];

        [UIView animateWithDuration:0.8 animations:^{
            
            self.view.transform = CGAffineTransformMakeScale(1.5, 1.5);
            self.view.alpha = 0.5;
          
        }completion:^(BOOL finished) {
              [delegate changeRootController];
//            self.view.window.rootViewController = _viewController;
        }];
    }

}
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didScrollToIndex:(NSInteger)index{

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
