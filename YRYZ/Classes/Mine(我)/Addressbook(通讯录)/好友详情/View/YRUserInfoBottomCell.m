//
//  YRUserInfoBottomCell.m
//  YRYZ
//
//  Created by 易超 on 16/7/13.
//  Copyright © 2016年 yryz. All rights reserved.
//

#import "YRUserInfoBottomCell.h"

@interface YRUserInfoBottomCell ()



@end
@implementation YRUserInfoBottomCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.bottomButton.titleLabel.font = [UIFont systemFontOfSize:18];
    
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (IBAction)bottomButtonClick:(UIButton *)sender {
    
    if ([sender.currentTitle isEqualToString:@"聊天"]) {
        if (self.choose) {
            self.choose(YES);
        }

    }else{
        if (self.choose) {
            self.choose(YES);
        }
    }
    
    
}

@end
