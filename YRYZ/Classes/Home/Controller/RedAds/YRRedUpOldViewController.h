//
//  YRRedUpOldViewController.h
//  YRYZ
//
//  Created by Sean on 16/8/11.
//  Copyright © 2016年 yryz. All rights reserved.
//

#import "BaseViewController.h"

@interface YRRedUpOldViewController : BaseViewController

//OldOrNew YES为通过界面 NO为过期界面
- (instancetype)initWithOldOrNew:(BOOL)OldOrNew;

@property (nonatomic,weak) UIViewController *delegate;
@end
