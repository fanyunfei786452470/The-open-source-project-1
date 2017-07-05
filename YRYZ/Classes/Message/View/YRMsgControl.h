//
//  YRMsgControl.h
//  YRYZ
//
//  Created by Mrs_zhang on 16/7/11.
//  Copyright © 2016年 yryz. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YRMsgControl : UIControl

- (instancetype)initWithFrame:(CGRect)frame andName:(NSString *)name;
- (void)reload;
@property (nonatomic,copy) NSString *msgBarName;

@property (nonatomic,copy) NSString *msgBarCount;

@property (nonatomic,strong) UILabel *nameLab;

@property (nonatomic,strong) UILabel *countLab;
@end
