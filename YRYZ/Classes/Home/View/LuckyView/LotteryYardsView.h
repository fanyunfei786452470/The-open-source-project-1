//
//  LotteryYardsView.h
//  LuckyDraw
//
//  Created by Sean on 16/8/9.
//  Copyright © 2016年 Sean. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LotteryYardsView : UIView
- (instancetype)initWithFrame:(CGRect)frame withNum:(NSInteger)num;
- (instancetype)initWithNum:(NSInteger)num withArray:(NSMutableArray *)array;

@property (nonatomic,strong) NSMutableArray *array;

@property (nonatomic,assign) NSInteger num;
@end
