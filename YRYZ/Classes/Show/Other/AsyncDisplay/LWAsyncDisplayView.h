/*
 https://github.com/waynezxcv/Gallop
 
 Copyright (c) 2016 waynezxcv <liuweiself@126.com>
 
 Permission is hereby granted, free of charge, to any person obtaining a copy
 of this software and associated documentation files (the "Software"), to deal
 in the Software without restriction, including without limitation the rights
 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the Software is
 furnished to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in
 all copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 THE SOFTWARE.
 */

#import <UIKit/UIKit.h>
#import "GallopUtils.h"

@class LWLayout;
@class LWAsyncDisplayLayer;
@class LWAsyncDisplayView;
@class LWTextStorage;
@class LWImageStorage;

@protocol LWAsyncDisplayViewDelegate <NSObject>

@optional

/***  点击链接 ***/
- (void)lwAsyncDisplayView:(LWAsyncDisplayView *)asyncDisplayView didCilickedTextStorage:(LWTextStorage *)textStorage linkdata:(id)data;
/***  点击LWImageStorage回调 ***/
- (void)lwAsyncDisplayView:(LWAsyncDisplayView *)asyncDisplayView didCilickedImageStorage:(LWImageStorage *)imageStorage touch:(UITouch *)touch;
/***  额外的绘制任务在这里实现 ***/
- (void)extraAsyncDisplayIncontext:(CGContextRef)context size:(CGSize)size isCancelled:(LWAsyncDisplayIsCanclledBlock)isCancelled;

@end

typedef void(^LWAsyncDisplayViewAutoLayoutCallback)(LWImageStorage* imageStorage ,CGFloat delta);

@interface LWAsyncDisplayView : UIView

@property (nonatomic,weak) id <LWAsyncDisplayViewDelegate> delegate;
@property (nonatomic,strong) LWLayout* layout;//布局模型
@property (nonatomic,assign) BOOL displaysAsynchronously;
@property (nonatomic,copy) LWAsyncDisplayViewAutoLayoutCallback auotoLayoutCallback;


@end
