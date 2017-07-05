//
//  YRMineFriendCell.m
//  YRYZ
//
//  Created by Sean on 16/9/7.
//  Copyright © 2016年 yryz. All rights reserved.
//

#import "YRMineFriendCell.h"

@implementation YRMineFriendCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
    }
    return self;
}
-(void)layoutSubviews{
    [super layoutSubviews];
    self.imageView.frame = CGRectMake(10, 5, 40, 40);
    self.textLabel.frame = CGRectMake(70, 0, 200, 40);
    self.textLabel.centerY = self.contentView.centerY;
    self.textLabel.textAlignment = NSTextAlignmentLeft;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
