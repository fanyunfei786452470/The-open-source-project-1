//
//  YRRewardTableViewCell.m
//  YRYZ
//
//  Created by weishibo on 16/8/15.
//  Copyright © 2016年 yryz. All rights reserved.
//

#import "YRRewardTableViewCell.h"

@interface YRRewardTableViewCell ()


@property (nonatomic ,strong)YRRewardListModel           *rewardModel;

@end
@implementation YRRewardTableViewCell




- (void)setRewardModel:(YRRewardListModel *)rewardModel{


    _rewardModel = rewardModel;
    self.nameLabel.text = rewardModel.remark.length>0?rewardModel.remark:rewardModel.nickName;
    [self.rewardImageView setImageWithURL:[NSURL URLWithString:rewardModel.img] placeholder:[UIImage imageNamed:@"yr_list_default"]];
    self.numLabel.text = [NSString stringWithFormat:@"%.2f元",[rewardModel.rewardPrice floatValue] *0.01];
    [self.headImageView setImageWithURL:[NSURL URLWithString:rewardModel.headImg] placeholder:[UIImage defaultHead]];

}

- (void)awakeFromNib {
    [super awakeFromNib];

    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    self.headImageView.layer.cornerRadius = 4;
    self.headImageView.layer.masksToBounds = YES;
    self.nameLabel.font = [UIFont titleFont15];
    self.nameLabel.textColor = [UIColor themeColor];
    
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
