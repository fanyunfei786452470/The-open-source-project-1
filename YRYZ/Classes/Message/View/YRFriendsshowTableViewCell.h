//
//  YRFriendsshowTableViewCell.h
//  YRYZ
//
//  Created by Mrs_zhang on 16/7/14.
//  Copyright © 2016年 yryz. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "YRFriendsModel.h"

@interface YRFriendsshowTableViewCell : UITableViewCell

@property (nonatomic,strong) YRFriendsModel *model;

@property (weak, nonatomic) IBOutlet UIImageView *headerImg;
@property (weak, nonatomic) IBOutlet UILabel *nameLab;

@property (weak, nonatomic) IBOutlet UILabel *contextLab;
@property (weak, nonatomic) IBOutlet UIImageView *typeImg;
@property (weak, nonatomic) IBOutlet UILabel *timeLab;

@end
