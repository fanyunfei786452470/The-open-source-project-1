//
//  YRBeforePrizeTableViewCell.h
//  YRYZ
//
//  Created by Sean on 16/8/10.
//  Copyright © 2016年 yryz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YRBeforePrizeModel.h"
@interface YRBeforePrizeTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIButton *whatNum;
@property (weak, nonatomic) IBOutlet UILabel *time;
@property (weak, nonatomic) IBOutlet UILabel *first;
@property (weak, nonatomic) IBOutlet UILabel *second;

@property (nonatomic,weak) UILabel *OneKey;

@property (nonatomic,weak) UILabel *TwoOneKey;

@property (nonatomic,weak) UILabel *TwoTwoKey;

@property (nonatomic,weak) UILabel *OneName;

@property (nonatomic,weak) UILabel *TwoOneName;

@property (nonatomic,weak) UILabel *TwoTwoName;

@property (nonatomic,weak) UILabel *FMoney;
@property (nonatomic,weak) UILabel *SMoney;

@property (nonatomic,copy) void(^chooseName) (NSString *custId);



@property (nonatomic,strong) YRBeforePrizeModel *modelF;
@property (nonatomic,strong) YRBeforePrizeModel *modelS1;
@property (nonatomic,strong) YRBeforePrizeModel *modelS2;


- (void)setUIWithModel:(YRBeforeArray *)model;
@end
