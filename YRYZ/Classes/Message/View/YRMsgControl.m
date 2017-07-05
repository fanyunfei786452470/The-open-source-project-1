//
//  YRMsgControl.m
//  YRYZ
//
//  Created by Mrs_zhang on 16/7/11.
//  Copyright © 2016年 yryz. All rights reserved.
//

#import "YRMsgControl.h"

#define iPhone5Font 15
#define iPhone6_6pFont 17

@interface YRMsgControl()

@end

@implementation YRMsgControl

- (instancetype)initWithFrame:(CGRect)frame andName:(NSString *)name{
    self = [super initWithFrame:frame];
    if (self) {
        
        CGFloat crlW = frame.size.width;
        CGFloat crlH = frame.size.height;
        
        self.nameLab  = [[UILabel alloc] init];
        self.nameLab.textAlignment = NSTextAlignmentCenter;
        self.nameLab.textColor = [UIColor blackColor];
        self.nameLab.font = [UIFont titleFont17];

        self.countLab = [[UILabel alloc] init];
        self.countLab.backgroundColor = RGB_COLOR(250, 114, 111);
        self.countLab.textColor = [UIColor whiteColor];
        self.countLab.textAlignment = NSTextAlignmentCenter;
        self.countLab.font = [UIFont systemFontOfSize:SCREEN_WIDTH == kDevice_Is_iPhone5?12:14];
        self.countLab.layer.cornerRadius = SCREEN_WIDTH == kDevice_Is_iPhone5?5.5:8;
        self.countLab.clipsToBounds = YES;
        
        CGFloat nameW = [self widthForString:name fontSize:SCREEN_WIDTH == kDevice_Is_iPhone5?iPhone5Font:iPhone6_6pFont andHeight:40];
        CGFloat countW = [self widthForString:@"" fontSize:SCREEN_WIDTH == kDevice_Is_iPhone5?iPhone5Font:iPhone6_6pFont andHeight:40];
        
        CGFloat w;
        if ([@"" isEqualToString:@""]) {
            w = nameW;
            self.countLab.mj_w = countW;
        }else{
            w = nameW + countW + 2;
            self.countLab.mj_w = countW>20?countW:20;
        }
       
        self.nameLab.mj_x = (crlW - w)/2;
        self.nameLab.mj_y = crlH/2 - 15;
        self.nameLab.mj_w = nameW;
        self.nameLab.mj_h = 30;
        
        self.countLab.mj_x = CGRectGetMaxX(self.nameLab.frame) +2;
        self.countLab.mj_y =  SCREEN_WIDTH == kDevice_Is_iPhone5?(crlH/2 -5.5):(crlH/2 -8);
        self.countLab.mj_h = SCREEN_WIDTH == kDevice_Is_iPhone5?11:16;
        
        self.nameLab.text = name;
        self.countLab.text = @"";
        
        [self addSubview:self.nameLab];
        [self addSubview:self.countLab];
        
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    CGFloat crlW = self.size.width;
    CGFloat crlH = self.size.height;
    NSInteger count = [_msgBarCount integerValue];

    CGFloat nameW = [self widthForString:_msgBarName fontSize:SCREEN_WIDTH == kDevice_Is_iPhone5?iPhone5Font:iPhone6_6pFont andHeight:40];
    CGFloat countW;
    if (count >99) {
        countW = [self widthForString:@"99+" fontSize:SCREEN_WIDTH == kDevice_Is_iPhone5?iPhone5Font:iPhone6_6pFont andHeight:40];
    }else{
        countW = [self widthForString:@"99+" fontSize:SCREEN_WIDTH == kDevice_Is_iPhone5?iPhone5Font:iPhone6_6pFont andHeight:40];
    }

    CGFloat w;
    if ([_msgBarCount isEqualToString:@""]) {
        w = nameW;
        self.countLab.mj_w = 0;
    }else{
        w = nameW + countW + 2;
        self.countLab.mj_w = 30;
    }
    
    self.nameLab.mj_x = (crlW - w)/2+1;
    self.nameLab.mj_y = crlH/2 - 15;
    self.nameLab.mj_w = nameW;
    self.nameLab.mj_h = 30;
    
    self.countLab.mj_x = CGRectGetMaxX(self.nameLab.frame) +2;
    self.countLab.mj_y =  SCREEN_WIDTH == kDevice_Is_iPhone5?(crlH/2 -5.5):(crlH/2 -8);
    self.countLab.mj_h = SCREEN_WIDTH == kDevice_Is_iPhone5?11:16;
    
    self.nameLab.text = _msgBarName;
    
    NSString *msgCounts;
    if (count >99) {
        msgCounts = @"99+";
    }else{
        msgCounts = _msgBarCount;
    }
    self.countLab.text = msgCounts;
}

- (void)reload{
    [self setNeedsLayout];
}

//获取字符串的宽度
-(float)widthForString:(NSString *)value fontSize:(float)fontSize andHeight:(float)height
{
    NSDictionary *attribute = @{NSFontAttributeName: [UIFont systemFontOfSize:fontSize]};
    CGSize size = [value boundingRectWithSize:CGSizeMake(200, height) options: NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attribute context:nil].size;
    return size.width;
}

@end
