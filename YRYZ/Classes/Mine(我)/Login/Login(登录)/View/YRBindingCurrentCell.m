//
//  YRBindingCurrentCell.m
//  YRYZ
//
//  Created by 易超 on 16/7/13.
//  Copyright © 2016年 yryz. All rights reserved.
//

#import "YRBindingCurrentCell.h"

@interface YRBindingCurrentCell()

@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *subTitleLabel;
@property (weak, nonatomic) IBOutlet UIButton *rightButton;

@end

@implementation YRBindingCurrentCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}


@end
