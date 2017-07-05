//
//  YRMinePayView.h
//  YRYZ
//
//  Created by Sean on 16/9/18.
//  Copyright © 2016年 yryz. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YRMinePayView : UIView
+(void)showPaymentViewWithMoney:(NSString*)money paymentBlock:(void(^)(NSString*))paymentBlock;
+ (void)hidePaymentPasswordView;
@end
