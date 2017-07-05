//
//  LotteryView.h
//  LuckyDraw
//
//  Created by MrCai on 16/8/9.
//  Copyright © 2016年 Sean. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <TYAttributedLabel.h>
@interface LotteryView : UIView
- (instancetype)initWithNeedCount:(NSString *)needcount;
@property (nonatomic,weak) TYAttributedLabel *label;
@property (nonatomic,copy) NSString  *needcount;
@end