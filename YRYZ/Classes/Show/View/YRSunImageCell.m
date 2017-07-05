//
//  YRSunImageCell.m
//  YRYZ
//
//  Created by Mrs_zhang on 16/7/29.
//  Copyright © 2016年 yryz. All rights reserved.
//

#import "YRSunImageCell.h"

@interface YRSunImageCell()

@property (nonatomic,strong) UIButton *deleteBtn;

@end

@implementation YRSunImageCell


- (instancetype)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    if (self) {
    
        self.imgV.image = nil;
        
        _deleteBtn  = [UIButton buttonWithType:UIButtonTypeCustom];
        _deleteBtn.frame = CGRectMake(frame.size.width-20, 0, 20, 20);
        [_deleteBtn setImage:[UIImage imageNamed:@"yr_msg_X"] forState:UIControlStateNormal];
        [self addSubview:_deleteBtn];
        
        [_deleteBtn addTarget:self action:@selector(deletePhotoAction) forControlEvents:UIControlEventTouchUpInside];
   
    }
    return self;
}

- (void)deletePhotoAction{
    
    if ([self.delegate respondsToSelector:@selector(didClickDelegatePhotoWithIndex:)]) {
        [self.delegate didClickDelegatePhotoWithIndex:self.indexPath];
    }
 
}

@end
