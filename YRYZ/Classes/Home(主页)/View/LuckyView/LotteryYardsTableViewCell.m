//
//  LotteryYardsTableViewCell.m
//  
//
//  Created by Sean on 16/8/9.
//
//

#import "LotteryYardsTableViewCell.h"

@implementation LotteryYardsTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
