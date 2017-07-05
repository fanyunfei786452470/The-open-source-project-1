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

- (instancetype)initWithFrame:(CGRect)frame andName:(NSString *)name andCount:(NSString *)count{
    self = [super initWithFrame:frame];
    if (self) {
        
        CGFloat crlW = frame.size.width;
        CGFloat crlH = frame.size.height;
        
        UILabel *nameLab  = [[UILabel alloc] init];
        nameLab.textAlignment = NSTextAlignmentCenter;
        nameLab.textColor = [UIColor grayColorOne];
        nameLab.font = [UIFont systemFontOfSize:SCREEN_WIDTH == kDevice_Is_iPhone5?iPhone5Font:iPhone6_6pFont];

        UILabel *countLab = [[UILabel alloc] init];
        countLab.backgroundColor = RGB_COLOR(250, 114, 111);
        countLab.textColor = [UIColor whiteColor];
        countLab.textAlignment = NSTextAlignmentCenter;
        countLab.font = [UIFont systemFontOfSize:SCREEN_WIDTH == kDevice_Is_iPhone5?12:14];
        countLab.layer.cornerRadius = SCREEN_WIDTH == kDevice_Is_iPhone5?7.5:10;
        countLab.clipsToBounds = YES;
        
        
        CGFloat nameW = [self widthForString:name fontSize:SCREEN_WIDTH == kDevice_Is_iPhone5?iPhone5Font:iPhone6_6pFont andHeight:40];
        CGFloat countW = [self widthForString:count fontSize:SCREEN_WIDTH == kDevice_Is_iPhone5?iPhone5Font:iPhone6_6pFont andHeight:40];
        
        CGFloat w;
        if ([count isEqualToString:@""]) {
              w = nameW;
             countLab.mj_w = countW;
        }else{
              w = nameW + countW + 5;
              countLab.mj_w = countW;
        }
       
        nameLab.mj_x = (crlW - w)/2;
        nameLab.mj_y = crlH/2 - 15;
        nameLab.mj_w = nameW;
        nameLab.mj_h = 30;
        
        countLab.mj_x = CGRectGetMaxX(nameLab.frame) +5;
        countLab.mj_y =  SCREEN_WIDTH == kDevice_Is_iPhone5?(crlH/2 -7.5):(crlH/2 -10);
        countLab.mj_h = SCREEN_WIDTH == kDevice_Is_iPhone5?15:20;
        
        nameLab.text = name;
        countLab.text = count;
        
        [self addSubview:nameLab];
        [self addSubview:countLab];
        
        self.nameLab = nameLab;
        
    }
    return self;

}


//获取字符串的宽度
-(float)widthForString:(NSString *)value fontSize:(float)fontSize andHeight:(float)height
{
    NSDictionary *attribute = @{NSFontAttributeName: [UIFont systemFontOfSize:fontSize]};
    CGSize size = [value boundingRectWithSize:CGSizeMake(200, height) options: NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attribute context:nil].size;
    return size.width;
}


@end
