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
-(void)layoutSubviews{
    [super layoutSubviews];
    if (kDevice_Is_iPhone5) {
        self.title.font = [UIFont systemFontOfSize:11];
        self.title2.font = [UIFont systemFontOfSize:11];
    }else{
        self.title.font = [UIFont systemFontOfSize:13];
        self.title2.font = [UIFont systemFontOfSize:13];
    }
}
@end
