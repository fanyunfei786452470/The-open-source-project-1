//
//  UIBarButtonItem+BlockSupport.h
//  testFreeOpenIM
//
//  Created by sidian on 15/11/19.
//  Copyright © 2015年 taobao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIBarButtonItem (BlockSupport)

- (nullable instancetype)initWithImage:(nullable UIImage *)image style:(UIBarButtonItemStyle)style andBlock:(nullable void(^)())clickBlock;

@end
