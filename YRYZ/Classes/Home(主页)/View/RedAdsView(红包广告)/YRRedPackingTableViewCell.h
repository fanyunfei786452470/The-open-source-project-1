//
//  YRRedPackingTableViewCell.h
//  YRYZ
//
//  Created by Sean on 16/8/12.
//  Copyright © 2016年 yryz. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YRRedPackingTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *myImage;
@property (weak, nonatomic) IBOutlet UILabel *time;
@property (weak, nonatomic) IBOutlet UIButton *redBack;
@property (weak, nonatomic) IBOutlet UIButton *isBacking;
@property (weak, nonatomic) IBOutlet UILabel *titles;

@end
