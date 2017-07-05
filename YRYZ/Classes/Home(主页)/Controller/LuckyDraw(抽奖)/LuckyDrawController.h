//
//  LuckyDrawController.h
//  LuckyDraw
//
//  Created by Sean on 16/8/9.
//  Copyright © 2016年 Sean. All rights reserved.
//

#import "BaseViewController.h"

@interface LuckyDrawController : BaseViewController
//用户是否登陆
@property (nonatomic,assign) BOOL isUser;

//是否要显示即将开奖模块,YES为显示 NO为不显示
@property (nonatomic,assign) BOOL isComming;

@end
