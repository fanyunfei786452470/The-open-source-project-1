//
//  YRDataPickerView.h
//  YRYZ
//
//  Created by 21.5 on 16/9/10.
//  Copyright © 2016年 yryz. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^DatePickBlock)(NSDate *date);

@interface YRDataPickerView : UIView

- (void)getDateWithBlock:(DatePickBlock)block;

- (void)show;

@end
