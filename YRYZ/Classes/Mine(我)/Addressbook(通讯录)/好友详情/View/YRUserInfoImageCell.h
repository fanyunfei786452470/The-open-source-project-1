//
//  YRUserInfoImageCell.h
//  YRYZ
//
//  Created by 易超 on 16/7/13.
//  Copyright © 2016年 yryz. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YRUserInfoImageCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *image1;
@property (weak, nonatomic) IBOutlet UIImageView *image2;
@property (weak, nonatomic) IBOutlet UIImageView *image3;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (nonatomic,strong) UIImageView  *image4;

@end
