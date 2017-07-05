//
//  YRMgsNavgationView.m
//  YRYZ
//
//  Created by Mrs_zhang on 16/7/11.
//  Copyright © 2016年 yryz. All rights reserved.
//  聊天、好友动态、我的动态View

#import "YRMsgNavgationView.h"
#import "YRMsgControl.h"
#define msgBarW SCREEN_WIDTH/3

@interface YRMsgNavgationView()

@property (nonatomic,strong) UILabel *lineFour;
@property (nonatomic,strong) YRMsgControl *msgCrl;
@property (nonatomic,strong) YRMsgControl *friendsShowCrl;
@property (nonatomic,strong) YRMsgControl *myShowCrl;
@end


@implementation YRMsgNavgationView

- (instancetype)initWithFrame:(CGRect)frame{

    self = [super initWithFrame:frame];
    if (self) {
        
        CGFloat viewH = frame.size.height;
        
        UILabel *lineOne = [[UILabel alloc] initWithFrame:CGRectMake(msgBarW, 10, 1, viewH - 20)];
        lineOne.backgroundColor = RGB_COLOR(240, 240, 240);
        lineOne.textColor = [UIColor blackColor];
        [self addSubview:lineOne];
        
        UILabel *lineTwo = [[UILabel alloc] initWithFrame:CGRectMake(msgBarW*2, 10, 1, viewH - 20)];
        lineTwo.backgroundColor = RGB_COLOR(240, 240, 240);
        lineTwo.textColor = [UIColor blackColor];
        [self addSubview:lineTwo];
        
        
        YRMsgControl *msgCrl = [[YRMsgControl alloc] initWithFrame:CGRectMake(1, 5, msgBarW -2, viewH - 10) andName:@"聊天" andCount:@"100"];
        msgCrl.nameLab.textColor = [UIColor themeColor];
         [self addSubview:msgCrl];
        
        YRMsgControl *friendsShowCrl = [[YRMsgControl alloc] initWithFrame:CGRectMake(1+msgBarW, 5, msgBarW -2, viewH - 10) andName:@"好友动态" andCount:@""];
        [self addSubview:friendsShowCrl];
        
        YRMsgControl *myShowCrl = [[YRMsgControl alloc] initWithFrame:CGRectMake(2+msgBarW*2, 5, msgBarW -2, viewH - 10) andName:@"我的动态" andCount:@"99+"];
        [self addSubview:myShowCrl];
        
        
        [msgCrl addTarget:self action:@selector(msgAction) forControlEvents:UIControlEventTouchUpInside];
        [friendsShowCrl addTarget:self action:@selector(friendsShowAction) forControlEvents:UIControlEventTouchUpInside];
        [myShowCrl addTarget:self action:@selector(myShowAction) forControlEvents:UIControlEventTouchUpInside];
        
        UILabel *lineThree = [[UILabel alloc] initWithFrame:CGRectMake(0, viewH-1, SCREEN_WIDTH, 1)];
        lineThree.backgroundColor = RGB_COLOR(238, 238, 238);
        [self addSubview:lineThree];
        
        UILabel *lineFour = [[UILabel alloc] initWithFrame:CGRectMake(0, viewH-2, msgBarW, 1)];
        lineFour.backgroundColor = [UIColor themeColor];
        [self addSubview:lineFour];
        
        
        self.msgCrl = msgCrl;
        self.friendsShowCrl = friendsShowCrl;
        self.myShowCrl = myShowCrl;
        self.lineFour = lineFour;
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(scrollNorification:) name:@"scrollNotifierCenter" object:nil];
        
    }
    return self;
}

- (void)scrollNorification:(NSNotification *)notification{
    if ([notification.object isEqualToString:@"messageNotifier"]) {
        [UIView animateWithDuration:0.25 animations:^{
            self.lineFour.centerX = self.msgCrl.centerX;
            self.msgCrl.nameLab.textColor = [UIColor themeColor];
            self.friendsShowCrl.nameLab.textColor = [UIColor grayColorOne];
            self.myShowCrl.nameLab.textColor = [UIColor grayColorOne];
        } completion:^(BOOL finished) {
        }];
    }else if ([notification.object isEqualToString:@"friendsShowNotifier"]){
        [UIView animateWithDuration:0.25 animations:^{
            self.lineFour.centerX = self.friendsShowCrl.centerX;
            self.msgCrl.nameLab.textColor = [UIColor grayColorOne];
            self.friendsShowCrl.nameLab.textColor = [UIColor themeColor];
            self.myShowCrl.nameLab.textColor = [UIColor grayColorOne];
        } completion:^(BOOL finished) {
        }];
    }else if ([notification.object isEqualToString:@"mineShowNotifier"]){
        [UIView animateWithDuration:0.25 animations:^{
            self.lineFour.centerX = self.myShowCrl.centerX;
            self.msgCrl.nameLab.textColor = [UIColor grayColorOne];
            self.friendsShowCrl.nameLab.textColor = [UIColor grayColorOne];
            self.myShowCrl.nameLab.textColor = [UIColor themeColor];
        } completion:^(BOOL finished) {
        }];
    }
}
/**
 *  @author ZX, 16-07-11 16:07:13
 *
 *  聊天响应事件
 */
- (void)msgAction{
    [UIView animateWithDuration:0.25 animations:^{
        self.msgBlock();
        self.lineFour.centerX = self.msgCrl.centerX;
    } completion:^(BOOL finished) {
    }];
    
    self.msgCrl.nameLab.textColor = [UIColor themeColor];
    self.friendsShowCrl.nameLab.textColor = [UIColor grayColorOne];
    self.myShowCrl.nameLab.textColor = [UIColor grayColorOne];
}
/**
 *  @author ZX, 16-07-11 16:07:28
 *
 *  好友动态
 */

- (void)friendsShowAction{
    [UIView animateWithDuration:0.25 animations:^{
        self.friendsShowBlock();
        self.lineFour.centerX = self.friendsShowCrl.centerX;
    } completion:^(BOOL finished) {
    }];

    self.msgCrl.nameLab.textColor = [UIColor grayColorOne];
    self.friendsShowCrl.nameLab.textColor = [UIColor themeColor];
    self.myShowCrl.nameLab.textColor = [UIColor grayColorOne];
}

/**
 *  @author ZX, 16-07-11 16:07:37
 *
 *  我的动态
 */
- (void)myShowAction{
    [UIView animateWithDuration:0.25 animations:^{
        self.myShowBlock();
        self.lineFour.centerX = self.myShowCrl.centerX;
    } completion:^(BOOL finished) {
    }];

    self.msgCrl.nameLab.textColor = [UIColor grayColorOne];
    self.friendsShowCrl.nameLab.textColor = [UIColor grayColorOne];
    self.myShowCrl.nameLab.textColor = [UIColor themeColor];
}
@end
