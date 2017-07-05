
//
//  YRWebView.h
//  YRWebView
//
//  Created by weishibo on 16/7/15.
//  Copyright © 2016年 yryz. All rights reserved.
//


#import "YRWebView.h"
#import "NJKWebViewProgressView.h"
#import "NJKWebViewProgress.h"

@interface YRWebView () <NJKWebViewProgressDelegate>

@property (strong, nonatomic) NJKWebViewProgress *progressProxy;

@end

@implementation YRWebView
{
    NJKWebViewProgressView *_progressView;
}

- (void)setupNJKWebViewProgressView
{
    
    CGFloat progressBarHeight = 2.f;
    CGRect barFrame = CGRectMake(0,  -55 , self.bounds.size.width, progressBarHeight);
    _progressView = [[NJKWebViewProgressView alloc] initWithFrame:barFrame];
//    _progressView.backgroundColor = [UIColor themeColor];
//    _progressView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
    [self addSubview:_progressView];
}

- (void)setDelegate:(id<UIWebViewDelegate>)delegate
{
    [super setDelegate:self.progressProxy];
    _progressProxy.webViewProxyDelegate = delegate;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    if (!_progressView.window) {
        [self setupNJKWebViewProgressView];
    }
}

#pragma mark - NJKWebViewProgressDelegate
-(void)webViewProgress:(NJKWebViewProgress *)webViewProgress updateProgress:(float)progress
{
    [_progressView setProgress:progress animated:YES];
}

#pragma mark - lazyload
- (NJKWebViewProgress *)progressProxy
{
    if (!_progressProxy) {
        _progressProxy = [[NJKWebViewProgress alloc] init];
        _progressProxy.progressDelegate = self;
    }
    return _progressProxy;
}


@end
