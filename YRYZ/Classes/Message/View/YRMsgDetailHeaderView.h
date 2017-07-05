//
//  YRMsgDetailHeaderView.h
//  YRYZ
//
//  Created by Mrs_zhang on 16/7/13.
//  Copyright © 2016年 yryz. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^DidSeleteBlock)(void);
@interface YRMsgDetailHeaderView : UIView

@property (nonatomic,copy)DidSeleteBlock didHeadImg;

- (instancetype)initWithFrame:(CGRect)frame Image:(UIImage *)image Name:(NSString *)name;
@end
