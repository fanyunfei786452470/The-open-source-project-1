//
//  RewardGiftView.h
//  Rrz
//
//  Created by Rongzhong on 16/6/21.
//  Copyright © 2016年 rongzhongwang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RewardGiftModel.h"

@interface RewardGiftView : UIView
@property (strong ,nonatomic) UIButton   *rechargeButton; //充值按钮
typedef void (^HideBlock)();


typedef void (^RewardBlock)(RewardGiftModel    *giftModel ,float  money);

@property (copy, nonatomic) RewardBlock rewardBlock;

@property (strong, nonatomic) NSArray *modelArray;

-(void)showGiftView;

-(NSInteger)getGiftViewHeight;

-(void)setTotalMoney:(NSString*)money;

-(void)reloadData;

@end
