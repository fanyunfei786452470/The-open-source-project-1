//
//  YRInputView.h
//  YRYZ
//
//  Created by Mrs_zhang on 16/8/2.
//  Copyright © 2016年 yryz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YRReportTextView.h"

@protocol YRInputViewDelegate <NSObject>

- (void)textViewChangeHeightWithText:(NSString *)text Return:(BOOL)isReturn;

@end

@interface YRInputView : UIView
@property (nonatomic,strong) YRReportTextView *textView;

@property (nonatomic,weak) id<YRInputViewDelegate> delegate;

@end
