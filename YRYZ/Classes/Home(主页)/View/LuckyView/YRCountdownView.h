//
//  YRCountdownView.h
//  YRYZ
//
//  Created by Sean on 16/8/10.
//  Copyright © 2016年 yryz. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^isTimeOut)(BOOL isFinsh);

@interface YRCountdownView : UIView
@property (nonatomic,assign) NSInteger num;

@property (nonatomic,copy) isTimeOut mytime;
@end
