//
//  YRAddressListCell.h
//  YRYZ
//
//  Created by 易超 on 16/7/11.
//  Copyright © 2016年 yryz. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YRAddressListCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *iconImage;

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

//新消息提醒
@property (weak, nonatomic) IBOutlet UILabel *neLabel;

@property (nonatomic,strong) UILabel    *message;

@end
