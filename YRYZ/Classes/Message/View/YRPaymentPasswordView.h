//
//  YRPaymentPasswordView.h
//  YRYZ
//
//  Created by Rongzhong on 16/7/14.
//  Copyright © 2016年 yryz. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YRPaymentPasswordView : UIView



+(void)showPaymentViewWithMoney:(NSString*)money paymentBlock:(void(^)(NSString*))paymentBlock;
+ (void)hidePaymentPasswordView;
@end
