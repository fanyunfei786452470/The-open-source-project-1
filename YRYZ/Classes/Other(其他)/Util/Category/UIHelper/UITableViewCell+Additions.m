//
//  UITableViewCell+Additions.m
//  Orimuse
//
//  Created by Weishibo on 15/4/10.
//  Copyright (c) 2015年 Weishibo. All rights reserved.
//

#import "UITableViewCell+Additions.h"

@implementation UITableViewCell (Additions)


- (void)setSeparatorLineZero
{
    if ([self respondsToSelector:@selector(setSeparatorInset:)]) {
        [self setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([self respondsToSelector:@selector(setLayoutMargins:)]) {
        [self setLayoutMargins:UIEdgeInsetsZero];
    }
    
}

@end
