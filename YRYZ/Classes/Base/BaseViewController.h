//
//  BaseViewController.h
//  Rrz
//
//  Created by weishibo on 16/2/19.
//  Copyright © 2016年 rongzhongwang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseNavigationController.h"

@interface BaseViewController : UIViewController

- (void)initNavigationBarWithTitle:(NSString*)title;

-(void)hideLeftButton;

- (void)initNavBarWithBgImage:(UIImage*)image TitleLabel:(UIView*)titleView LeftButton:(UIButton*)leftButton RightButton:(UIButton*)rightButton;

@property (assign, readonly , nonatomic) CGFloat contentHeight;

- (void)touristsView;

//跳转至好友详情页面
- (void)pushUserInfoViewController:(NSString *)userID  withIsFriend:(BOOL)isFriend;
- (void)setRightNavButtonWithImage:(UIImage*)rightImage;
- (void)setRightNavButtonWithImage:(NSString *)imageName title:(NSString*)title;
- (void)setRightNavButtonWithTitle:(NSString*)rightTitle;
- (void)rightNavAction:(UIButton*)button;

- (void)setLeftNavButtonWithImage:(UIImage*)leftImage;
- (void)setLeftNavButtonWithTitle:(NSString*)leftTitle;
- (void)leftNavAction:(UIButton *)button;

- (UILabel*)addUpdateNumTodo:(NSInteger)num;

- (void)noLoginTip;
- (void)saveModelInfoToDisk;
@end
