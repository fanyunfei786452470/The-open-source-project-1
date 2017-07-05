//
//  YRMyWorksHeadView.m
//  YRYZ
//
//  Created by 易超 on 16/7/19.
//  Copyright © 2016年 yryz. All rights reserved.
//

#import "YRMyWorksHeadView.h"

@interface YRMyWorksHeadView ()

@property (weak, nonatomic) IBOutlet UIImageView *icomImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *subTitleLable;


@end

@implementation YRMyWorksHeadView

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil]lastObject];
        self.icomImageView.layer.cornerRadius = 4;
        self.icomImageView.layer.masksToBounds = YES;
    }
    return self;
}

@end
