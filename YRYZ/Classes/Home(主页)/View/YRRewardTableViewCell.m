//
//  YRRewardTableViewCell.m
//  YRYZ
//
//  Created by weishibo on 16/8/15.
//  Copyright © 2016年 yryz. All rights reserved.
//

#import "YRRewardTableViewCell.h"

@interface YRRewardTableViewCell ()


@property (weak, nonatomic) IBOutlet UIImageView *headImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *numLabel;
@property (weak, nonatomic) IBOutlet UIImageView *rewardImageView;

@end
@implementation YRRewardTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];

    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    self.headImageView.layer.cornerRadius = 4;
    self.headImageView.layer.masksToBounds = YES;
    self.nameLabel.textColor = [UIColor themeColor];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
