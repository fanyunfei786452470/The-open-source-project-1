//
//  YRStatementTableViewCell.m
//  YRYZ
//
//  Created by Sean on 16/8/13.
//  Copyright © 2016年 yryz. All rights reserved.
//

#import "YRStatementTableViewCell.h"

@implementation YRStatementTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.contentView.backgroundColor = [UIColor whiteColor];
}
-(void)layoutSubviews{
    [super layoutSubviews];
    if (kDevice_Is_iPhone5) {
        self.title.font = [UIFont systemFontOfSize:13];
        self.time.font = [UIFont systemFontOfSize:13];
        self.money.font = [UIFont systemFontOfSize:13];
    }
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
