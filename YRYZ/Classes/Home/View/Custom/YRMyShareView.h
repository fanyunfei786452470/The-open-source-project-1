//
//  YRMyShareView.h
//  YRYZ
//
//  Created by Sean on 16/8/12.
//  Copyright © 2016年 yryz. All rights reserved.
//

#import <UIKit/UIKit.h>



@interface YRMyShareView : UIView

@property (nonatomic,weak) UIViewController *delegate;

- (instancetype)initWithNoToReport;
- (void)show;

@property (nonatomic,copy) void(^chooseShareCell)(NSInteger num,NSString *name);

@end
