//
//  YRUpOldTableViewCell.h
//  YRYZ
//
//  Created by Sean on 16/8/11.
//  Copyright © 2016年 yryz. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YRUpOldTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *titles;

@property (weak, nonatomic) IBOutlet UIImageView *myImage;

@property (weak, nonatomic) IBOutlet UILabel *time;

@property (weak, nonatomic) IBOutlet UILabel *redNum;

@property (weak, nonatomic) IBOutlet UIButton *seeNum;

@property (weak, nonatomic) IBOutlet UIButton *giveMoney;
@property (weak, nonatomic) IBOutlet UILabel *overTime;

@end
