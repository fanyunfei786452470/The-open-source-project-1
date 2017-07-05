//
//  YRMineTopCell.h
//  YRYZ
//
//  Created by 易超 on 16/7/18.
//  Copyright © 2016年 yryz. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YRMineTopCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UILabel     *nameLabel;

@property (nonatomic,copy) void(^chooseCell)(BOOL click);
@end
