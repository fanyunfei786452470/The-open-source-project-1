//
//  YRBannerView.m
//  YRYZ
//
//  Created by Rongzhong on 16/7/21.
//  Copyright © 2016年 yryz. All rights reserved.
//

#import "YRBannerView.h"
#import "YRBannerPageControl.h"

@interface YRBannerView()<UIScrollViewDelegate>

@property (nonatomic, strong) YRBannerPageControl *pageControl;

@property (nonatomic, strong) UIScrollView *baseScrollView;

@property NSInteger currentPage;

@end

@implementation YRBannerView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self){
        _currentPage = 0;
        _BannerNumber = 5;
        [self setupView];
    }
    return self;
}

-(void)startPlay
{
    _timer = [NSTimer scheduledTimerWithTimeInterval:5.0f target:self selector:@selector(timerFired) userInfo:nil repeats:YES];
}

-(void)endPlay
{
    [_timer invalidate];
}

-(void)setupView
{
    _baseScrollView = [[UIScrollView alloc]init];
    _baseScrollView.frame =  self.bounds;
    _baseScrollView.contentSize = CGSizeMake(SCREEN_WIDTH * (_BannerNumber + 2), 0);
    _baseScrollView.contentOffset = CGPointMake(SCREEN_WIDTH, 0);
    _baseScrollView.delegate = self;
    _baseScrollView.pagingEnabled = YES;
    _baseScrollView.showsHorizontalScrollIndicator = NO;
    [self addSubview:_baseScrollView];

    for (int i = 0; i < _BannerNumber + 2; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.tag = 100 + i;
        button.frame = CGRectMake(SCREEN_WIDTH * i, 0, self.frame.size.width, self.frame.size.height);
        [button setBackgroundImage:[UIImage imageNamed:@"bannerImage"] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(bannnerClicked:) forControlEvents:UIControlEventTouchUpInside];
        [_baseScrollView addSubview:button];
    }
    
    _pageControl = [[YRBannerPageControl alloc]initWithFrame:CGRectMake(0, self.frame.size.height - 20, SCREEN_WIDTH, 20)];
    _pageControl.numberOfPages = _BannerNumber;
    _pageControl.currentPage = _currentPage;
    [self addSubview:_pageControl];
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (scrollView.contentOffset.x / SCREEN_WIDTH==0) {
        [scrollView setContentOffset:CGPointMake(SCREEN_WIDTH * _BannerNumber,0)];
    }
    if (scrollView.contentOffset.x / SCREEN_WIDTH == (_BannerNumber + 1)) {
        [scrollView setContentOffset:CGPointMake(SCREEN_WIDTH,0)];
    }
    _pageControl.currentPage = scrollView.contentOffset.x / SCREEN_WIDTH - 1;
    
    _currentPage = _pageControl.currentPage;
    
    [_timer invalidate];
    _timer = [NSTimer scheduledTimerWithTimeInterval:2.0f target:self selector:@selector(timerFired) userInfo:nil repeats:YES];
}


-(void)timerFired
{
    [_baseScrollView setContentOffset:CGPointMake(SCREEN_WIDTH * (_baseScrollView.contentOffset.x / SCREEN_WIDTH + 1),0) animated:YES];
    
    if (_baseScrollView.contentOffset.x / SCREEN_WIDTH==0) {
        [_baseScrollView setContentOffset:CGPointMake(SCREEN_WIDTH * _BannerNumber,0)];
    }
    if (_baseScrollView.contentOffset.x / SCREEN_WIDTH == (_BannerNumber + 1)) {
        [_baseScrollView setContentOffset:CGPointMake(SCREEN_WIDTH,0)];
    }
    
    _currentPage = (_currentPage + 1) % _BannerNumber;
    
    _pageControl.currentPage = _currentPage;

}

-(void)setBannerOffset{
    [_baseScrollView setContentOffset:CGPointMake(SCREEN_WIDTH * _currentPage, 0)];
}

-(void)bannnerClicked:(UIButton*)button
{
    
}

@end
