//
//  RRZMineInfoCell.h
//  Rrz
//
//  Created by 易超 on 16/3/17.
//  Copyright © 2016年 rongzhongwang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RRZMineInfoCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet UILabel *subTitleLabel;

@property (weak, nonatomic) IBOutlet UIImageView *IconImageView;


@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageWCons;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageHCons;

@end
