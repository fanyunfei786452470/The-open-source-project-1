//
//  YRBannerView.h
//  YRYZ
//
//  Created by Rongzhong on 16/7/21.
//  Copyright © 2016年 yryz. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YRBannerView : UIView

@property NSInteger BannerNumber;

@property (strong,nonatomic) NSTimer *timer;

-(void)startPlay;

-(void)endPlay;

-(void)setBannerOffset;

@end
