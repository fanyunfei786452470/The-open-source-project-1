//
//  RewardGiftView.h
//  Rrz
//
//  Created by Rongzhong on 16/6/21.
//  Copyright © 2016年 rongzhongwang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RewardGiftView : UIView

typedef void (^HideBlock)();

//@property (strong, nonatomic) HideBlock hideBlock;

typedef void (^RewardBlock)(NSString*);

@property (strong, nonatomic) RewardBlock rewardBlock;

@property (strong, nonatomic) NSArray *modelArray;

-(void)showGiftView;

-(NSInteger)getGiftViewHeight;

-(void)setTotalMoney:(NSString*)money;

-(void)reloadData;

@end
