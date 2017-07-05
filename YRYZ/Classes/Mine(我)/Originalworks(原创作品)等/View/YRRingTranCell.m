//
//  YRRingTranCell.m
//  YRYZ
//
//  Created by 易超 on 16/7/19.
//  Copyright © 2016年 yryz. All rights reserved.
//

#import "YRRingTranCell.h"

@interface YRRingTranCell ()

@property (weak, nonatomic) IBOutlet UIImageView *icomImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *subTitleLable;




@end

@implementation YRRingTranCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.icomImageView.layer.cornerRadius = 4;
    self.icomImageView.layer.masksToBounds = YES;
    
    
    
    self.fristTranLabel.textColor = [UIColor themeColor];
    self.lucreLabel.textColor = [UIColor themeColor];
    self.byTranLabel.textColor = [UIColor themeColor];
}



@end
