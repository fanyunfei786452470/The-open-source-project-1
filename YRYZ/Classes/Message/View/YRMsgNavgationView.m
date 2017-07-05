//
//  YRMgsNavgationView.m
//  YRYZ
//
//  Created by Mrs_zhang on 16/7/11.
//  Copyright © 2016年 yryz. All rights reserved.
//  聊天、好友动态、我的动态View

#import "YRMsgNavgationView.h"
#import "YRMsgControl.h"
#import "SPKitExample.h"
#import "MsgPlaySound.h"
#define msgBarW SCREEN_WIDTH/3

@interface YRMsgNavgationView()

@property (nonatomic,weak) UILabel *lineFour;
@property (nonatomic,strong) YRMsgControl *msgCrl;
@property (nonatomic,strong) YRMsgControl *friendsShowCrl;
@property (nonatomic,strong) YRMsgControl *myShowCrl;
@property (nonatomic,copy) NSString *msgCount;

@property (nonatomic,copy) NSString *mineCount;

@property (nonatomic,copy) NSString *mineFCount;

@property (nonatomic,assign) BOOL isChangeColor;

@property (nonatomic,assign) BOOL isFChangeColor;

@property (nonatomic,assign) BOOL isMsgChangeColor;

@end


@implementation YRMsgNavgationView

- (instancetype)initWithFrame:(CGRect)frame{

    self = [super initWithFrame:frame];
    if (self) {
        
        self.isMsgChangeColor = YES;
        CGFloat viewH = frame.size.height;
        
        UILabel *lineOne        = [[UILabel alloc] initWithFrame:CGRectMake(msgBarW, 10, 1, viewH - 20)];
        lineOne.backgroundColor = RGB_COLOR(240, 240, 240);
        lineOne.textColor       = [UIColor blackColor];
        [self addSubview:lineOne];

        UILabel *lineTwo        = [[UILabel alloc] initWithFrame:CGRectMake(msgBarW*2, 10, 1, viewH - 20)];
        lineTwo.backgroundColor = RGB_COLOR(240, 240, 240);
        lineTwo.textColor       = [UIColor blackColor];
        [self addSubview:lineTwo];
        
        self.msgCrl                   = [[YRMsgControl alloc] initWithFrame:CGRectMake(1, 5, msgBarW -2, viewH - 10) andName:@"聊天记录"];
        self.msgCrl.msgBarCount       = @"";
        self.msgCrl.msgBarName        = @"聊天记录";
        self.msgCrl.nameLab.textColor = [UIColor themeColor];
        self.msgCrl.nameLab.font = [UIFont titleFontBoldTab17];
        [self addSubview:self.msgCrl];
        
        self.friendsShowCrl             = [[YRMsgControl alloc] initWithFrame:CGRectMake(1+msgBarW, 5, msgBarW -2, viewH - 10) andName:@"好友动态"];
        self.friendsShowCrl.msgBarCount = @"";
        self.friendsShowCrl.msgBarName  = @"好友动态";
        [self addSubview:self.friendsShowCrl];
        
        self.myShowCrl             = [[YRMsgControl alloc] initWithFrame:CGRectMake(2+msgBarW*2, 5, msgBarW -2, viewH - 10) andName:@"我的动态"];
        self.myShowCrl.msgBarCount = @"";
        self.myShowCrl.msgBarName  = @"我的动态";
        [self addSubview:self.myShowCrl];
        
        [self.msgCrl addTarget:self action:@selector(msgAction) forControlEvents:UIControlEventTouchUpInside];
        [self.friendsShowCrl addTarget:self action:@selector(friendsShowAction) forControlEvents:UIControlEventTouchUpInside];
        [self.myShowCrl addTarget:self action:@selector(myShowAction) forControlEvents:UIControlEventTouchUpInside];
        
        UILabel *lineThree        = [[UILabel alloc] initWithFrame:CGRectMake(0, viewH-1, SCREEN_WIDTH, 1)];
        lineThree.backgroundColor = RGB_COLOR(238, 238, 238);
        [self addSubview:lineThree];

        UILabel *lineFour         = [[UILabel alloc] initWithFrame:CGRectMake(0, viewH-4, msgBarW, 3)];
        lineFour.backgroundColor  = [UIColor themeColor];
        [self addSubview:lineFour];
        self.lineFour             = lineFour;
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(scrollNorification:) name:@"scrollNotifierCenter" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeShowCount:) name:MsgMyShowCount_Notification_Key object:nil];
        
    }
    return self;
}

- (void)changeShowCount:(NSNotification *)notification{
    
    if (![self.msgCount isEqualToString:[NSString stringWithFormat:@"%ld",[YRUserInfoManager manager].currentUser.msgCount]]) {
        
        if ([YRUserInfoManager manager].currentUser.msgCount ==0) {
            self.msgCount = @"";
        }else{
            self.msgCount = [NSString stringWithFormat:@"%ld",[YRUserInfoManager manager].currentUser.msgCount];
        }
        
        self.msgCrl.msgBarCount = self.msgCount;
        self.msgCrl.msgBarName = @"聊天记录";
        [self.msgCrl reload];
        
    }

    
    if (![self.mineFCount isEqualToString:[NSString stringWithFormat:@"%ld",[YRUserInfoManager manager].currentUser.friendsShowCount]]) {
        
        if ([YRUserInfoManager manager].currentUser.friendsShowCount ==0) {
           self.mineFCount = @"";
        }else{
           self.mineFCount = [NSString stringWithFormat:@"%ld",[YRUserInfoManager manager].currentUser.friendsShowCount];
        }
        
        self.friendsShowCrl.msgBarCount = self.mineFCount;
        self.friendsShowCrl.msgBarName = @"好友动态";
        [self.friendsShowCrl reload];

    }

    
    if (![self.mineCount isEqualToString:[NSString stringWithFormat:@"%ld",[YRUserInfoManager manager].currentUser.mineShowCount]]) {
        
        if ([YRUserInfoManager manager].currentUser.mineShowCount ==0) {
                self.mineCount = @"";
            }else{
                self.mineCount = [NSString stringWithFormat:@"%ld",[YRUserInfoManager manager].currentUser.mineShowCount];
            }
        self.myShowCrl.msgBarCount = self.mineCount;
        self.myShowCrl.msgBarName = @"我的动态";
        [self.myShowCrl reload];
    }
}

- (void)scrollNorification:(NSNotification *)notification{
    
    if ([notification.object isEqualToString:@"messageNotifier"]) {
        [UIView animateWithDuration:0.25 animations:^{
            self.lineFour.centerX                 = self.msgCrl.centerX;
            self.msgCrl.nameLab.textColor         = [UIColor themeColor];
            self.friendsShowCrl.nameLab.textColor = [UIColor blackColor];
            self.myShowCrl.nameLab.textColor      = [UIColor blackColor];
   
        } completion:^(BOOL finished) {
        }];
    }else if ([notification.object isEqualToString:@"friendsShowNotifier"]){
        [UIView animateWithDuration:0.25 animations:^{
            self.lineFour.centerX                 = self.friendsShowCrl.centerX;
            self.msgCrl.nameLab.textColor         = [UIColor blackColor];
            self.friendsShowCrl.nameLab.textColor = [UIColor themeColor];
            self.myShowCrl.nameLab.textColor      = [UIColor blackColor];


        } completion:^(BOOL finished) {
        }];
    }else if ([notification.object isEqualToString:@"mineShowNotifier"]){
        [UIView animateWithDuration:0.25 animations:^{
            self.lineFour.centerX                 = self.myShowCrl.centerX;
            self.msgCrl.nameLab.textColor         = [UIColor blackColor];
            self.friendsShowCrl.nameLab.textColor = [UIColor blackColor];
            self.myShowCrl.nameLab.textColor      = [UIColor themeColor];

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
    self.isMsgChangeColor = YES;
    self.isFChangeColor = NO;
    self.isChangeColor = NO;
    [self setNeedsLayout];

    self.msgCrl.nameLab.textColor = [UIColor themeColor];
    self.friendsShowCrl.nameLab.textColor = [UIColor blackColor];
    self.myShowCrl.nameLab.textColor = [UIColor blackColor];
    self.msgCrl.nameLab.font = [UIFont titleFontBoldTab17];
    self.myShowCrl.nameLab.font = [UIFont titleFont17];
    self.friendsShowCrl.nameLab.font = [UIFont titleFont17];
    [[NSNotificationCenter defaultCenter] postNotificationName:MsgMyShowCount_Notification_Key object:nil];

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
    
    self.isFChangeColor = YES;
    self.isChangeColor = NO;
    self.isMsgChangeColor = NO;
    [YRUserInfoManager manager].currentUser.friendsShowCount = 0;
    self.friendsShowCrl.msgBarCount = @"";
    self.friendsShowCrl.msgBarName = @"好友动态";
    [self.friendsShowCrl reload];
    [self setNeedsLayout];

    self.msgCrl.nameLab.textColor = [UIColor blackColor];
    self.friendsShowCrl.nameLab.textColor = [UIColor themeColor];
    self.myShowCrl.nameLab.textColor = [UIColor blackColor];
    self.myShowCrl.nameLab.font = [UIFont titleFont17];
    self.msgCrl.nameLab.font = [UIFont titleFont17];
    self.friendsShowCrl.nameLab.font = [UIFont titleFontBoldTab17];
    [[NSNotificationCenter defaultCenter] postNotificationName:MsgMyShowCount_Notification_Key object:nil];

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
    
    self.isChangeColor = YES;
    self.isFChangeColor = NO;
    self.isMsgChangeColor = NO;
    [YRUserInfoManager manager].currentUser.mineShowCount = 0;
    self.myShowCrl.msgBarCount = @"";
    self.myShowCrl.msgBarName = @"我的动态";
    [self.myShowCrl reload];

    [self setNeedsLayout];

    self.msgCrl.nameLab.textColor = [UIColor blackColor];
    self.friendsShowCrl.nameLab.textColor = [UIColor blackColor];
    self.myShowCrl.nameLab.textColor = [UIColor themeColor];
    
    self.myShowCrl.nameLab.font = [UIFont titleFontBoldTab17];
    self.msgCrl.nameLab.font = [UIFont titleFont17];
    self.friendsShowCrl.nameLab.font = [UIFont titleFont17];

    [[NSNotificationCenter defaultCenter] postNotificationName:MsgMyShowCount_Notification_Key object:nil];

}

- (void)dealloc{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end
