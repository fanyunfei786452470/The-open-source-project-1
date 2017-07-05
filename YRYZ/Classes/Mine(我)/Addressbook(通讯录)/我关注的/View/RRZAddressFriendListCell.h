//
//  RRZAddressFriendListCell.h
//  Rrz
//
//  Created by 易超 on 16/3/14.
//  Copyright © 2016年 rongzhongwang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RRZAddressFriendListCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *iconImage;

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

//新消息提醒
@property (weak, nonatomic) IBOutlet UILabel *neLabel;


@end
