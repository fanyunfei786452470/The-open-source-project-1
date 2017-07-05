//
//  YRRedPadingViewController.h
//  YRYZ
//
//  Created by Sean on 16/8/11.
//  Copyright © 2016年 yryz. All rights reserved.
//

#import "BaseViewController.h"

@interface YRRedPadingViewController : BaseViewController
//padOrPass YES为审核中界面 NO为未通过界面
- (instancetype)initWithPadOrPass:(BOOL)padOrPass;

@property (nonatomic,weak) UIViewController *delegate;
@end
