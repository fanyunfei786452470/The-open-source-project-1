//
//  RRZNavSearchView.m
//  Rrz
//
//  Created by 易超 on 16/3/9.
//  Copyright © 2016年 rongzhongwang. All rights reserved.
//

#import "RRZNavSearchView.h"

@implementation RRZNavSearchView

-(instancetype)init{
    
    self = [[[NSBundle mainBundle]loadNibNamed:NSStringFromClass([RRZNavSearchView class]) owner:nil options:nil] lastObject];
    
    if (self) {
        
        self.layer.cornerRadius = 5;
        self.layer.masksToBounds = YES;
        self.backgroundColor = [UIColor whiteColor];
        
        NSMutableDictionary *attributes = [NSMutableDictionary dictionary];
        // 设置富文本对象的颜色
        attributes[NSForegroundColorAttributeName] = [UIColor lightGrayColor];
        // 设置UITextField的占位文字
        self.seachTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@" 请输入搜索关键字" attributes:attributes];
//        [self.seachTextField setTintColor:[UIColor lightGrayColor]];
    }

//    self.seachTextField.layer.cornerRadius = 5;
//    self.seachTextField.layer.masksToBounds = YES;
    return self;
}

@end
