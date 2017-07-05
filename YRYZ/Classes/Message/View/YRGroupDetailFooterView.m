//
//  YRGroupDetailFooterView.m
//  YRYZ
//
//  Created by Mrs_zhang on 16/7/13.
//  Copyright © 2016年 yryz. All rights reserved.
//

#import "YRGroupDetailFooterView.h"

@implementation YRGroupDetailFooterView

- (instancetype)initWithFrame:(CGRect)frame{

    self = [super initWithFrame:frame];
    if (self) {
        
        UIButton *deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        deleteBtn.frame = CGRectMake(50, 40, SCREEN_WIDTH-100, 40);
        deleteBtn.backgroundColor = [UIColor themeColor];
        deleteBtn.titleLabel.font = [UIFont boldSystemFontOfSize:18];
        [deleteBtn setTitle:@"删除并退出" forState:UIControlStateNormal];
        [deleteBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self addSubview:deleteBtn];
        
        deleteBtn.layer.cornerRadius = 20.f;
        deleteBtn.clipsToBounds = YES;
        
        [deleteBtn addTarget:self action:@selector(deleteAction) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return self;
}

/**
 *  @author ZX, 16-07-13 16:07:49
 *
 *  删除按钮
 */
- (void)deleteAction{
    
    
    if ([self.delegate respondsToSelector:@selector(didClickDeleteGroupChat)]) {
        [self.delegate didClickDeleteGroupChat];
    }
    
    
   
}

@end
