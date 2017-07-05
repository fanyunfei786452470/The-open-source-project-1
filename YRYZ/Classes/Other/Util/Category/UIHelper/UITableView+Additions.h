//
//  UITableView+Additions.h
//  ElementFresh
//
//  Created by Weishibo on 14-9-24.
//  Copyright (c) 2014年 Weishibo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITableView (Additions)

- (void)setExtraCellLineHidden;

- (void)addRadiusforCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath;

- (void)addLineforPlainCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath withLeftSpace:(CGFloat)leftSpace;


//需要与UITableViewCell 的该方法同时使用
- (void)setSeparatorLineZero;

@end
