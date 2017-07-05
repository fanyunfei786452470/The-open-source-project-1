//
//  YRRedAdsTableViewCell.m
//  YRYZ
//
//  Created by Sean on 16/8/11.
//  Copyright © 2016年 yryz. All rights reserved.
//

#import "YRRedAdsTableViewCell.h"

@implementation YRRedAdsTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.time.textColor = RGB_COLOR(214, 214, 214);
    
    [self.num setTitleColor:RGB_COLOR(214, 214, 214) forState:UIControlStateNormal];
     self.selectionStyle = UITableViewCellSelectionStyleNone;
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)redPackButtonClick:(id)sender {
    if (self.delegate){
        [self.delegate redAdsTableViewCellDelegate:kRedBag];
    }
}
@end
