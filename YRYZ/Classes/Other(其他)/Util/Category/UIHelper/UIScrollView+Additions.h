//
//  UIScrollView+Additions.h
//  Rrz
//
//  Created by weishibo on 16/2/17.
//  Copyright © 2016年 rongzhongwang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIScrollView (Additions)

+ (NSArray*)idleImages;

+ (NSArray*)refreshingImages;

- (void)jk_addGifHeaderWithRefreshingTarget:(id)target refreshingAction:(SEL)action;

- (void)jk_addGifFooterWithRefreshingTarget:(id)target refreshingAction:(SEL)action;
@end
