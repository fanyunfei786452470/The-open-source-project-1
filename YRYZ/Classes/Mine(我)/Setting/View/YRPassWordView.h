//
//  YRPassWordView.h
//  YRYZ
//
//  Created by Sean on 16/8/17.
//  Copyright © 2016年 yryz. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YRPassWordView : UIView
@property (nonatomic, copy) void(^passwordBlock)(NSString *password);
@property (nonatomic, assign) NSUInteger elementCount;
@property (nonatomic, strong) UIColor *elementColor;
@property (nonatomic, assign) NSUInteger elementMargin;

@property(nonatomic, weak) UITextField *textField;
- (void)clearText;
@end
