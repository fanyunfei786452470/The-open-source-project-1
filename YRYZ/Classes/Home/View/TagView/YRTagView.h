//
//  YRTagView.h
//  YRYZ
//
//  Created by 21.5 on 16/9/8.
//  Copyright © 2016年 yryz. All rights reserved.
//

#import <UIKit/UIKit.h>

//typedef void(^YRTagViewBlock)(NSInteger index);
//
//@class YRTagView;
//
//@protocol YRTagViewDelegate <NSObject>
//
//- (void)didSelectedTagArray:(NSArray *)nameArray;
//
//
//@end
#import "YRTagFrame.h"
#define TextColor [UIColor colorWithRed:51.0/255.0 green:51.0/255.0 blue:51.0/255.0 alpha:1.0]
#define UIColorRGBA(r, g, b, a) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:(a)]

@protocol YRTagViewDelegate <NSObject>

-(void)YRTagView:(NSArray *)tagArray;

@end

@interface YRTagView : UIView

{
    //储存选中按钮的tag
    NSMutableArray *selectedBtnList;
}

@property (weak, nonatomic) id<YRTagViewDelegate>delegate;

/** 是否能选中 需要在 IMJIETagFrame 前调用  default is YES*/
@property (assign, nonatomic) BOOL clickbool;

/** 未选中边框大小 需要在 IMJIETagFrame 前调用 default is 0.5*/
@property (assign, nonatomic) CGFloat borderSize;

/** YRTagFrame */
@property (nonatomic, strong) YRTagFrame *tagsFrame;

/** 选中背景颜色 default is whiteColor */
@property (strong, nonatomic) UIColor *clickBackgroundColor;

/** 选中字体颜色 default is TextColor */
@property (strong, nonatomic) UIColor *clickTitleColor;

/** 多选选中 default is 未选中*/
@property (strong, nonatomic) NSArray *clickArray;

/** 单选选中 default is 未选中*/
@property (strong, nonatomic) NSString *clickString;

/** 选中边框大小 default is 0.5*/
@property (assign, nonatomic) CGFloat clickborderSize;

/** 1-多选 0-单选 default is 0-单选*/
@property (assign, nonatomic) NSInteger clickStart;

@property (assign,nonatomic) NSInteger maxCount;
@end
