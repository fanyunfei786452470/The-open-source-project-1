//
//  YRPaymentScrollView.h
//  YRYZ
//
//  Created by Rongzhong on 16/7/15.
//  Copyright © 2016年 yryz. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YRPaymentScrollView : UIScrollView

typedef void (^TouchesEndBlock)();

@property (strong, nonatomic) TouchesEndBlock touchesEndBlock;

@end
