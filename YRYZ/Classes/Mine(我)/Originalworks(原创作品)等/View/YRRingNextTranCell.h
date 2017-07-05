//
//  YRRingNextTranCell.h
//  YRYZ
//
//  Created by Sean on 16/8/17.
//  Copyright © 2016年 yryz. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "YRMineRingTranModel.h"
#import "YRCircleListModel.h"
@interface YRRingNextTranCell : UITableViewCell
@property (nonatomic,copy) void(^chooseBtn)(BOOL isChoose);
@property (weak, nonatomic) IBOutlet UIImageView *imagType;
@property (weak, nonatomic) IBOutlet UIButton *shareBtn;

@property (weak, nonatomic) IBOutlet UILabel *time;
@property (weak, nonatomic) IBOutlet UIImageView *myImge;

@property (weak, nonatomic) IBOutlet UILabel *title;

@property (weak, nonatomic) IBOutlet UIImageView *bigType;

@property (weak, nonatomic) IBOutlet UILabel *forwarded;

@property (weak, nonatomic) IBOutlet UILabel *money;


@property (weak, nonatomic) IBOutlet UIImageView *downImage;


- (void)setUIWithModel:(YRCircleListModel *)model;
@end
