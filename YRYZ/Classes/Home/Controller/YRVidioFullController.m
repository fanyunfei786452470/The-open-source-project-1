//
//  YRVidioFullController.m
//  YRYZ
//
//  Created by Sean on 16/8/16.
//  Copyright © 2016年 yryz. All rights reserved.
//

#import "YRVidioFullController.h"
#import "AppDelegate.h"

@interface YRVidioFullController ()

@property (nonatomic,weak) YRVidioDetailController *video;


@end

@implementation YRVidioFullController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.myPlayerView.placeholderImageName = @" ";
//    [self.myPlayerView setPlaceholderImage:self.image];
    self.image.image = self.ima;
    self.navigationController.navigationBar.hidden = YES;
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.myPlayerView.videoURL = self.url;
    self.myPlayerView.seekTime = self.time;
    [self.myPlayerView autoPlayTheVideo];
    
    __weak typeof(self) weakSelf = self;
    
    self.myPlayerView.goBackBlock = ^{
        
        NSArray *array = [weakSelf.myPlayerView.controlView.currentTimeLabel.text componentsSeparatedByString:@":"];
        
        NSInteger time = [array[1] integerValue]+[array[0] integerValue]*60;
        //    播放的url地址
        weakSelf.video.url= weakSelf.myPlayerView.videoURL;
        //播放的时间
        weakSelf.video.time = time;
//        weakSelf.delegate.url =weakSelf.video.url;
//        weakSelf.time = time;
        weakSelf.delegate.time = time;
        weakSelf.delegate.url = weakSelf.myPlayerView.videoURL;
        [weakSelf.navigationController popViewControllerAnimated:YES];
    };
    self.delegate.isFectDetail = NO;
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    AppDelegate *delegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    
    delegate.allowRotation = 1;
    
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationNone];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
}
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
     [self.myPlayerView fullScreenAction:self.myPlayerView.controlView.fullScreenBtn];
}
-(void)viewWillDisappear:(BOOL)animated
{
    
//    [super viewWillDisappear:animated];
    AppDelegate *delegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
//    delegate.allowRotation = 1;
    [super viewWillDisappear:animated];
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationNone];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    delegate.allowRotation = 0;
}

//-(BOOL)shouldAutorotate
//{
//    return YES;
//}
//- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
//    
//  return UIInterfaceOrientationMaskAll;
// }
//
//
//-(UIInterfaceOrientation)preferredInterfaceOrientationForPresentation{
//    
//    return UIInterfaceOrientationLandscapeRight;
//}

//-(NSUInteger)supportedInterfaceOrientations{
//    return UIInterfaceOrientationMaskLandscape;
//}
-(void)dealloc{
    [self.myPlayerView resetPlayer];
     [self.myPlayerView removeAllSubviews];
    
    
    [self.view removeAllSubviews];
    self.myPlayerView = nil;
    self.view = nil;
   
    DLog(@"full die");
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end