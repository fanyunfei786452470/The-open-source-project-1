//
//  YC_ScrollNav.h
//  YC_ScrollNav
//
//  Created by Berton on 15/12/2.
//  Copyright © 2015年 Berton. All rights reserved.
//



#import <UIKit/UIKit.h>
#import "BaseViewController.h"


@protocol BaseScrollNavDelegate <NSObject>

- (void)baseScrollNavDelegate:(NSInteger)obj;

@end



@interface YC_ScrollNav : BaseViewController
//控制我的红包广告页面的长度  YES是210 NO为默认0
@property (nonatomic,assign) BOOL isMine;

- (void)initNavigationBarWithTitle:(NSString*)title;

- (void) hideLeftButton;

- (void)initNavBarWithBgImage:(UIImage*)image TitleLabel:(UIView*)titleView LeftButton:(UIButton*)leftButton RightButton:(UIButton*)rightButton;

//让控制器从210高度开始显示
- (instancetype)initWithMyFrame:(CGRect)frame;

- (void)scrollToRightView;


@property (nonatomic ,assign) id<BaseScrollNavDelegate>   baseScrollNavDelegate;


@end
