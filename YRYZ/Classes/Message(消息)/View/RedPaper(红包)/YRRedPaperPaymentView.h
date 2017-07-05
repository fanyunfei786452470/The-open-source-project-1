//
//  YRRedPaperPaymentView.h
//  YRYZ
//
//  Created by Rongzhong on 16/7/12.
//  Copyright © 2016年 yryz. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YRRedPaperPaymentView : UIScrollView

typedef void (^PaymentBlock)(NSUInteger number , NSUInteger totalMoney ,NSUInteger singleMoney ,NSInteger redTpye);

@property (strong, nonatomic) PaymentBlock paymentBlock;



@end
