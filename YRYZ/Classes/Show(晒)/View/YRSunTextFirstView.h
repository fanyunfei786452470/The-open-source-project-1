//
//  YRSunTextFirstView.h
//  YRYZ
//
//  Created by Mrs_zhang on 16/8/17.
//  Copyright © 2016年 yryz. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YRSunTextFirstView : UIView
@property (weak, nonatomic) IBOutlet UIImageView *topImage;

@property (weak, nonatomic) IBOutlet UIView *bkView;

@property (weak, nonatomic) IBOutlet UILabel *numberOne;
@property (weak, nonatomic) IBOutlet UILabel *numberTwo;
@property (weak, nonatomic) IBOutlet UIButton *canBtn;

@property (weak, nonatomic) IBOutlet UIButton *addFriendBtn;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topImageY;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topImageH;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topImageW;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *noTextY;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *canView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *canLabY;



@end
