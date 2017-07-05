
//
//  YRWebView.h
//  YRWebView
//
//  Created by weishibo on 16/7/15.
//  Copyright © 2016年 yryz. All rights reserved.
//


#import "YRWebView.h"


@interface YRWebView ()
<WKNavigationDelegate>
@property (nonatomic, strong) UIProgressView *progressView;

@end

@implementation YRWebView
- (instancetype)init {
    self = [super init];
    if (self) {
        self.navigationDelegate = self;
        self.userInteractionEnabled = NO;

        UIViewController *vc = [UIViewController getCurrentVC];
        self.progressView = [[UIProgressView alloc] initWithFrame:CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, 1)];
        self.progressView.progressTintColor = RGB_COLOR(21, 142, 135);
//        self.progressView.progressTintColor = [UIColor redColor];
        //设置进度条的高度，下面这句代码表示进度条的宽度变为原来的1倍，高度变为原来的1.5倍.
        self.progressView.transform = CGAffineTransformMakeScale(1.0f, 1.5f);
        [vc.view addSubview:self.progressView];
        
        [self addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:nil];
    }
    return self;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
    if ([keyPath isEqualToString:@"estimatedProgress"]) {
        if (_loadBlock) {
            _loadBlock();
        }
        
        self.progressView.progress = self.estimatedProgress;
        if (self.progressView.progress == 1) {
            /*
             *添加一个简单的动画，将progressView的Height变为1.4倍，在开始加载网页的代理中会恢复为1.5倍
             *动画时长0.25s，延时0.3s后开始动画
             *动画结束后将progressView隐藏
             */
            __weak typeof (self)weakSelf = self;
            [UIView animateWithDuration:0.25f delay:0.3f options:UIViewAnimationOptionCurveEaseOut animations:^{
                weakSelf.progressView.transform = CGAffineTransformMakeScale(1.0f, 1.5f);
            } completion:^(BOOL finished) {
                weakSelf.progressView.hidden = YES;
                
            }];
        }
    }else{
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}


//开始加载
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation {

    //开始加载网页时展示出progressView
    self.progressView.hidden = NO;
    //开始加载网页的时候将progressView的Height恢复为1.5倍
    self.progressView.transform = CGAffineTransformMakeScale(1.0f, 1.5f);
    //防止progressView被网页挡住
    [self bringSubviewToFront:self.progressView];
}

//加载完成
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {

    //加载完成后隐藏progressView
    self.progressView.hidden = YES;
    self.userInteractionEnabled = YES;
}

//加载失败
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation withError:(NSError *)error {
    //加载失败同样需要隐藏progressView
//    self.progressView.hidden = YES;
}


- (void)dealloc{
    [self removeObserver:self forKeyPath:@"estimatedProgress"];
}

@end
