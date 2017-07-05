//
//  YRAlertView.h
//  YRYZ
//
//  Created by Mrs_zhang on 16/8/13.
//  Copyright © 2016年 yryz. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum
{
    AletTypeOne  = 1,
    AletTypeTwo  = 2,
    AletTypeThree = 3,
} TypeName;//枚举名称
@interface YRAlertView : UIView


typedef void(^YRAlertBlock_t)(void);

//字体
@property (nonatomic,strong) UIFont *textLabFont;
@property (nonatomic,strong) UIFont *cancelButtonFont;
@property (nonatomic,strong) UIFont *comfirmButtonFont;

//颜色
@property (nonatomic,strong) UIColor *textLabColor;
@property (nonatomic,strong) UIColor *cancelButtonColor;
@property (nonatomic,strong) UIColor *comfirmButtonColor;

//响应事件
@property (nonatomic,copy) YRAlertBlock_t addCancelAction;
@property (nonatomic,copy) YRAlertBlock_t addConfirmAction;

//双按钮提示框
- (instancetype)initWithTitle:(NSString *)title cancelButtonText:(NSString *)cancelText confirmButtonText:(NSString *)confirmText;
//单按钮提示框
- (instancetype)initWithTitle:(NSString *)title cancelButtonText:(NSString *)cancelText;
//带有标题和子标题的提示框
- (instancetype)initWithFrame:(CGRect)frame title:(NSString *)title subTitle:(NSString *)subTitle cancelButtonText:(NSString *)cancelText confirmButtonText:(NSString *)confirmText;
- (instancetype)initWithPay:(NSString *)titles cancelButtonTexts:(NSString *)cancelTexts;
//显示
- (void)show;



@end
