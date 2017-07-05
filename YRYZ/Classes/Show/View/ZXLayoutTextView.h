//
//  LayoutTextView.h
//  LayoutTextView
//
//  Created by JiaHaiyang on 16/7/6.
//  Copyright © 2016年 PlutusCat. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YRReportTextView;

@interface ZXLayoutTextView : UIView
@property (weak, nonatomic) YRReportTextView *textView;

@property (copy, nonatomic) NSString *placeholder;

@property (copy, nonatomic) void (^(sendBlock)) (YRReportTextView *textView);

@end
