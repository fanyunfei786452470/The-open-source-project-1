//
//  YRRotateView.h
//  YRYZ
//
//  Created by Rongzhong on 16/7/21.
//  Copyright © 2016年 yryz. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YRRotateView : UIView

typedef void (^ItemClikedBlock)(NSUInteger buttonTag);

@property (strong, nonatomic) ItemClikedBlock itemClikedBlock;

@end
