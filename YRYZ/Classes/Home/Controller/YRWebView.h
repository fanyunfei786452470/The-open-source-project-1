
//
//  YRWebView.h
//  YRWebView
//
//  Created by weishibo on 16/7/15.
//  Copyright © 2016年 yryz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>

@interface YRWebView : WKWebView

typedef void (^LoadBlock)();

@property (strong, nonatomic) LoadBlock loadBlock;

@end
