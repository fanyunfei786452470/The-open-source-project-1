//
//  YRTapImageView.h
//  YRYZ
//
//  Created by Mrs_zhang on 16/7/22.
//  Copyright © 2016年 yryz. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol YRTapImageViewDelegate <NSObject>

- (void)didSeleteImageViewWithTag:(NSInteger)tag;

@end

@interface YRTapImageView : UIImageView

@property (nonatomic,weak) id<YRTapImageViewDelegate> delegate;

@end
