//
//  YRSunTextDetailCell.m
//  YRYZ
//
//  Created by Mrs_zhang on 16/7/21.
//  Copyright © 2016年 yryz. All rights reserved.
//

#import "YRSunTextDetailCell.h"

@implementation YRSunTextDetailCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
   
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        UIView *view = [[UIView alloc] init];
        view.frame = CGRectMake(10, 0, SCREEN_WIDTH-20, 90);
        view.backgroundColor = RGBA_COLOR(245, 245, 245, 1);
        [self addSubview:view];
        
        self.backgroundV = view;
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
