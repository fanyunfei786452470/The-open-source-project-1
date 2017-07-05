//
//  YRSunTextFirstView.m
//  YRYZ
//
//  Created by Mrs_zhang on 16/8/17.
//  Copyright © 2016年 yryz. All rights reserved.
//

#import "YRSunTextFirstView.h"

@implementation YRSunTextFirstView

- (void)awakeFromNib{
    
    if (SCREEN_WIDTH ==  414.f) {
        self.topImageY.constant = 40.f;
        self.topImageH.constant = 135.f;
        self.topImageW.constant = 135.f;
        self.noTextY.constant = 30.f;
        self.canLabY.constant = 25.f;
        self.canView.constant = 40.f;
    }
    

    self.canBtn.userInteractionEnabled = NO;
    self.topImage.layer.cornerRadius = 50.f;
    self.topImage.clipsToBounds = YES;
    
    self.bkView.layer.cornerRadius = 5.f;
    self.bkView.clipsToBounds = YES;
    self.bkView.layer.borderWidth = 1.f;
    self.bkView.layer.borderColor = RGB_COLOR(237, 237, 237).CGColor;
    
    self.numberOne.layer.cornerRadius = 10.f;
    self.numberTwo.layer.cornerRadius = 10.f;
    self.numberOne.clipsToBounds = YES;
    self.numberTwo.clipsToBounds = YES;
    
    self.addFriendBtn.layer.cornerRadius = 17.5f;

}



@end
