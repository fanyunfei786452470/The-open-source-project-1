//
//  BaskHeadView.m
//  TimeDemo
//
//  Created by 21.5 on 16/7/20.
//  Copyright © 2016年 21.5. All rights reserved.
//

#import "BaskHeadView.h"

@implementation BaskHeadView

-(void)awakeFromNib{
    [super awakeFromNib];
    self.nickLab.text = @"  昵称昵称  ";
    self.nickLab.layer.masksToBounds = YES;
    self.nickLab.layer.cornerRadius = 3;
    self.backImage.contentMode = UIViewContentModeScaleAspectFill;
    self.backImage.clipsToBounds = YES;
    self.headImageBtn.layer.masksToBounds = YES;
    self.headImageBtn.layer.cornerRadius = 5;
   
}
@end
